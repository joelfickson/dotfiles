---
name: joel-rust
description: Joel's Rust and systems patterns: crate boundaries, error taxonomy, bounded concurrency, CLI UX, distribution.
disable-model-invocation: true
---

# Systems patterns (Rust)

Read `joel-architecture` first. Rust is for CLIs, native apps, media pipelines, agent runtimes and protocol code. Product web APIs stay in TypeScript. Default tools: tokio, axum, sqlx, serde, tracing, clap, thiserror and anyhow.

## Structure

- **Workspaces with small crates.** Split by responsibility. Name internal crates plainly (`agent`, `cli`, `gateway`, `tools`, `types`). Cross-crate contracts live in `types`. Write down the dependency direction. Share dependency versions at the workspace level.
- **Library plus thin binary.** Logic lives in the library; the binary parses arguments, builds config, wires dependencies and runs. Integration tests import the library. `main` never accumulates logic.
- **Organise by responsibility,** not by type: `api/`, `config`, `error`, `queue`, `contracts`, one module per feature.
- **Pin the toolchain** and use the latest edition.

## Errors

- **A typed error per crate**, each wrapped library error converting in automatically, with a crate-level result alias. A general-purpose error type only at the binary edge and in config loading.
- **Messages tell the user what to do next** ("Not authenticated. Run `<tool> login` first.").
- **One wire shape** shared with the TypeScript services: a human message plus a stable snake_case code. Internal errors are logged in full and returned generic.
- **No panics on runtime paths.** Unwrapping is for tests and process boot only.
- **Background loops log and continue.** They never take the process down.

## Configuration

Configuration is loaded once from service-prefixed environment variables into a typed struct. Non-secrets get defaults; missing secrets fail with a clear message. The struct's debug output redacts every secret and the credentials in connection URLs. User-level state lives in a dot-directory in the home folder. Project config is a TOML file edited without destroying formatting.

## Concurrency

- **Bound everything:** bounded channels, a semaphore per workload class, byte-bounded caches, timeouts on every external call.
- **Shared state is explicit:** a cloneable app state holding the pool and shared services. Optional services are absent (and announced at boot) when unconfigured.
- **Periodic workers** run an interval loop, enabled by an env flag, with the interval clamped to a sane minimum.
- **Cancel stale work** with generation counters instead of letting it finish and race.
- **Blocking libraries** run on dedicated threads, connected to async code by bounded channels.
- **Use proven tools as subprocesses** (ffmpeg, git) rather than binding or reimplementing them.

## Core and UI separation

The core emits typed events and has no terminal or GUI knowledge. The binary or UI subscribes and renders. Requests that need a human (approvals, input) are one-shot request/response messages and default to deny if the channel closes.

## Types

Plain data structs with serialization derives. Closed sets as enums with snake_case wire names. Named constructors. A private wire type when the external format differs from the internal model. Feature-gated database derives on shared protocol types, so clients don't pull database code.

## Testing seams

Anything that crosses a network or process boundary sits behind a trait, with the production implementation as the default type parameter and stubs in tests. Tests drain event streams and assert on the final event. Local mock servers stand in for HTTP. Live tests are opt-in.

## Cross-language contracts

Wire types are mirrored by hand in the other languages, and one rule requires every contract change to update the protocol crate, every SDK and the docs together. When several SDKs implement one protocol, shared JSON test vectors and a conformance runner pin the behaviour across languages.

## CLI and terminal UX

- Subcommands map to user intents and nest by area.
- Long flags have sensible defaults; closed choices are enums.
- Errors go to stderr with a non-zero exit code.
- Output is plain, aligned and scriptable. List commands offer table and JSON formats. Spinners disappear when output is not a terminal or is JSON.
- No colour libraries.
- Terminal UIs are compact and monospace, show tool output and diffs inline, and carry no marketing chrome.
- Visual changes to native apps still go through an approved HTML mock.

## Quality gate

Format check, lint with warnings as errors across all targets, and tests with the lockfile enforced. The same gate runs locally (as one make target) and in CI.

## Distribution

Releases are built by a hand-written pipeline:

- Run the gate first.
- Build a target matrix (macOS on both architectures, Linux, and Windows when relevant).
- Publish archives with checksum files, with notes generated from conventional commits.
- Publish to the package registry when it is a library.
- Ship a one-line installer that detects platform and architecture and installs into the user's home directory.
- Private source publishes its binaries to a public releases repository.
