---
name: joel-architecture
description: Joel's system architecture patterns - module boundaries, layering and dependency direction, composition roots, contract-first shared types, one domain with many ingresses, ports and adapters for providers, explicit results over exceptions, fail-closed configuration, tenancy as a boundary, runtime-shaped deployables, and how to evolve a system without breaking it. Use when designing a new system, service, module or feature, deciding where code belongs, reviewing a design, or refactoring structure in one of Joel's projects.
---

# Architecture patterns

These patterns are how Joel structures systems, whatever the language. Each one names the problem, the shape of the solution, and why. Apply them by default. Break one only when you can say which force makes it wrong here, and write that down.

## 1. Boundaries and dependency direction

**Layered core, thin edges.** Every backend has three tiers: an *edge* (transport: parse, authenticate, validate, map results to the protocol), a *domain* (business rules, no transport or storage knowledge), and *data access* (the only code that touches storage). Dependencies point inward: edge → domain → data access. The domain never imports the transport framework; data access never calls the domain. External providers are the one inversion: the domain owns their interfaces (section 4), the port types live in the contracts package or a `ports` module, and adapters import those types only, never domain logic.
*Why:* the same rule can then be reached from HTTP, a queue, a CLI, a cron job or an AI tool without being rewritten, and each tier tests on its own.
*Anti-pattern:* business logic in route handlers; queries scattered through services; a "utils" folder that quietly holds domain rules.

**Write the dependency graph down.** Each repo's agent file states the allowed direction between modules (for example `cli → agent → {gateway, tools, types}`). A dependency that points the wrong way is a design bug, not a style issue.

**No cross-app dependencies.** Deployables depend on shared packages, never on each other. If two apps need the same thing, it moves into a package.

**Core emits, edge renders.** Long-running cores (agents, pipelines, players, workers) emit typed events over a channel and know nothing about terminals, screens or HTTP. The edge subscribes and renders. Approvals and user input travel back as request/response messages, and fail closed (deny) when the channel breaks.

## 2. Contracts

**One source of truth per contract.** Request and response shapes, domain unions, and events live in one shared contracts package that the server, web, mobile and SDKs all import. Database row types are derived from the schema, never hand-copied. If a type exists twice, one copy is wrong.

**Contract-first change.** Change the contract, then every consumer, in the same change. Adding an optional field is safe. Renaming, removing or changing the meaning of a field is a breaking change: either update every consumer now or record the gap as tracked debt. Never leave silent drift between server, clients and docs.

**Hand-written surface, machine-checked contract.** Public surfaces (APIs, SDKs, protocols) are designed by hand for the reader, then verified mechanically against a spec or shared test vectors in CI. Ergonomics come from a human; correctness from a machine.

**Validate at every trust boundary.** Data is parsed into a known shape where it enters (HTTP body, webhook, queue message, file, model output, env) and is trusted inside. Types describe what was validated; they never replace the validation, the authorization check, or the confirmation that a write landed.

## 3. One domain, many ingresses

A capability is implemented once and reached through several doors: REST, an SMTP or webhook ingress, a worker, an MCP tool, a CLI. The doors are thin adapters over the same domain function, or call the same in-process handler. They share auth, limits, billing and validation by construction.
*Why:* a second implementation always drifts, and the drift is usually a security or billing hole.
*Anti-pattern:* an MCP server or admin tool that reimplements business logic "because it was quicker".

## 4. Ports and adapters for everything external

Every external dependency (payments, email, SMS, storage, LLMs, search, video) sits behind an interface owned by the domain, with one adapter per provider and a registry that chooses at startup.

- **A mock or null adapter always exists**, so the system boots and tests run with no credentials.
- **A provider is fully configured or absent.** A half-configured provider fails startup with the names of the missing settings. "A half-configured provider is worse than an absent one."
- **Production refuses the fallback.** Missing configuration in production throws at boot. It never quietly selects the mock, local disk, or a personal credential.
- **Errors describe consequences**, not just causes: did money move, was the message accepted, is a retry safe.
- **Prefer a unified surface** over provider-specific calls, with escape hatches for provider features.

## 5. Explicit outcomes

**Results for the expected, exceptions for the unexpected.** Domain functions return discriminated outcomes (`ok` / `reason`, or a `kind`) for the failures callers must handle: not found, conflict, stale, insufficient credit, signature mismatch. Exceptions are reserved for broken invariants and infrastructure failure. The edge maps outcomes to protocol responses in one place.

**Reasons are data.** Rejections carry a machine-readable reason, so logs, metrics and UIs can tell "missing" from "stale" from "mismatch".

**States encode what is durably known.** Model a lifecycle with the unhappy members included (pending, accepted, failed, cancelled, indeterminate), and only advance on confirmed facts. "Intent recorded" is not "effect accepted". Transitions are monotonic and checked against an allowed-from list.

**Fail loudly, fail closed.** No swallowed errors, no silent defaults that hide a fault. Unknown or missing permission means deny. The only tolerated swallow is a cache that degrades to a miss, and it still logs.

## 6. Composition

**Explicit composition roots.** Wiring happens in one place per deployable: build config, create clients, construct modules, hand each its narrow dependencies. Complex domains get their own small root (`createXModule(deps)` returning its service and repository). No DI container, no decorators, no service locator.

**Functions over classes for logic.** Domain and data-access code are plain functions that take their dependencies (the database handle first) as arguments, so they compose inside a transaction and swap in tests. Classes are for things with lifecycle or state (clients, workers, stores).

**Lazy singletons for clients**, with a reset hook for tests. Construct expensive clients once, on first use.

## 7. Configuration as a boundary

Configuration is untrusted input. Parse it at boot against a schema, derive capability flags (`emailEnabled`), and crash early on missing secrets, placeholder secrets, or a development value in production. Defaults are for non-secrets only. Every new setting updates code, the example env file, deployment manifests and CI together. Secrets are read, never printed.

## 8. Tenancy is a boundary, not a filter

Multi-tenant systems carry the tenant on every tenant-owned row, enforce membership at the edge, and scope every read and write by tenant in data access, including lookups by primary key. Row-level security in the database is welcome as a second line of defence, never as the only one. A row outside the caller's tenant does not exist (404, not 403). Developer products add an environment dimension (sandbox and production) that never mixes. Uniqueness and indexes are per tenant.

## 9. Deployables follow runtime roles

Start with one deployable. A small product serves its UI, API, webhooks and cron from a single app, with the cron as an internal endpoint guarded by a shared secret that fails closed when unset. Keep the runtime roles separate *in code* from day one (handlers, jobs and scheduled entries in their own modules over the same domain), so a split is a wiring change.

Split into separate deployables by how code runs, not by noun: an API (request/response), a worker (queues), a cron entry (time), an MCP or CLI ingress, a web app. Split when a role needs different scaling, timeouts, isolation or security from the rest. They share packages, live in one monorepo, and deploy independently. Split the *domain* into separate services only when a boundary has a different ownership need *(inferred)*.
*Anti-pattern:* splitting services per noun up front (a users service, a payments service) before any boundary demands it.

## 10. Asynchronous work

- **Persist, then acknowledge, then process.** Inbound events are written durably first, acknowledged quickly, and processed asynchronously.
- **Idempotency everywhere money or messages move.** Callers supply a key; the server reserves it atomically before doing work, replays the original response on retry, and rejects reuse with a different payload.
- **At-least-once by default, so make handlers idempotent.** Deduplicate on the source's event id.
- **Reconcilers close every loop.** Any state that waits on a callback (payment, delivery, transcode, scheduled job) gets a periodic sweep that re-reads the truth from the source. Callbacks are an optimisation; reconciliation is the guarantee. Confirm the source actually has a read or status API before designing the sweep, and that a provider supports idempotency before relying on it. Where no read path exists, move the state to a terminal value after a deadline and surface it.
- **Queues match the infrastructure you already run.** A dedicated queue only when the system already operates it; otherwise a database table with row locking, or a scheduled trigger calling an internal endpoint.
- **Bound everything.** Queues, concurrency, caches, waits and retries all have explicit limits and timeouts.
- **Batch runs report, not abort.** A scheduled or fan-out job isolates each item's failure, keeps going, and returns a run report: counts, cost, and a list of errors. It aborts only when a step every later step depends on fails. The errors are recorded and surfaced, never swallowed.

## 11. Durability and choice of store

Durable facts go in the relational database, including things people often put in a cache (idempotency records, rate counters where there is no shared memory). Caches hold only what is cheap to lose. Large bytes go to object storage with the key in the database. When you reject a store, write the reason where the decision lives.

**Keep the raw input.** Anything ingested from outside (webhooks, scraped pages, third-party API payloads) is stored raw and immutable beside the normalised form: a raw column, a raw events table, or dated raw files with a content hash. Normalisation can then be fixed and replayed without fetching again. Upserts touch only the fields that legitimately change.

## 12. Clients mirror the same discipline

Frontends and mobile apps separate *server state* (fetched, cached, invalidated) from *client state* (UI, session), keep side effects in events and data-layer callbacks rather than render lifecycles, and keep components presentational. Mobile apps share a logic core across platforms and keep UI native. Offline is designed in: read from cache first, queue mutations in an outbox, let the server win conflicts.

## 13. Evolving a system

- **Expand, migrate, contract.** Add the new shape alongside the old, move readers and writers, then remove the old. Schema changes are additive first and verified from an empty database.
- **Legacy is quarantined, not rewritten.** Mark it read-only, build the replacement beside it, and follow current rules only in what you touch.
- **Immutable artifacts, promoted not rebuilt.** The bytes you tested are the bytes you ship.
- **A merge is not a release.** Deploys are deliberate.
- **Record decisions.** Each significant choice gets a short dated record: what, why, what was rejected, what is unproven. Later decisions supersede with a new record.

## Design review checklist

Before proposing or approving a design, confirm: dependency direction is inward and written down; each contract has one home; every external system is behind an adapter with a mock; misconfiguration fails at boot; expected failures are typed outcomes; tenancy is enforced in data access; every callback-driven state has a reconciler; every money or message path is idempotent; everything async is bounded; the change can roll out with expand/contract; the decision is recorded.
