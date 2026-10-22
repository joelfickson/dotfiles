---
name: joel-sdk
description: Joel's public API and SDK patterns: reader-first surfaces, one error type, idempotent retries, versioning.
disable-model-invocation: true
---

# Public API and SDK patterns

Read `joel-architecture` first. Default tools: TypeScript, native fetch, tsup (dual module output), Vitest, a manual release pipeline.

## Design for the reader

- **Hand-written surface, machine-checked contract.** Design the surface by hand for the person calling it, then check it in CI against the API spec or shared test vectors. Generated code, if any, stays internal and is never hand-edited.
- **One entry point.** A single client constructed from an API key or an options object (base URL, timeout, retries, injectable fetch), reading the key from the environment when none is given on a server.
- **Namespaces read like the domain.** Group by resource or by the product's main verb (`client.send.email()`, `client.contacts.list()`).
- **Unified first, specific second.** Offer one surface over many providers, with escape hatches to provider-specific features.
- **No dead surface.** Never ship a method the API cannot serve. Mark fields the API does not send yet as forward-looking.
- **Safe types:** money as strings or integer minor units, IDs opaque, timestamps as ISO strings.

## Errors describe consequences

One error type for every failure, carrying status, a stable code, a message, a request id and the cause. Domain-relevant facts are typed fields: did money move, is a retry safe. There are no silent fallbacks, and failures are never swallowed.

## Retries are safe by construction

- Retry rate limits and server errors with exponential backoff, jitter and the server's retry hint, up to a limit.
- Never retry a non-idempotent request unless the caller supplied an idempotency key, which the client forwards.
- Every request has a timeout.
- Identify the SDK and version in a user-agent string.

## Portable and light

The client runs in every JavaScript runtime the users have (servers, edge, browsers) with zero runtime dependencies unless agreed. Heavy optional integrations are optional peer dependencies loaded lazily. The package is side-effect free and ships typed ESM and CommonJS builds.

## Documentation is part of the product

- Every public member has doc comments with an example. This is the scoped exception to the no-comments rule.
- The API reference is generated from those comments.
- README order: one-line pitch, packages, install, a realistic quickstart, configuration, errors, retries and idempotency, stability status, license.
- A docs site with an llms.txt, plus an integration skill for coding agents that shows wrong and right usage side by side.
- A contributing guide: one package manager, the quality gate, conventional commits, no new dependencies without discussion, no network calls in default tests.

## Testing

- Stub the transport.
- For each method, test one success and one failure.
- Test the retry rules explicitly: rate limits retried, unsafe requests without a key not retried, retry hints honoured.
- Real network tests are opt-in.
- CI covers every supported runtime version and typechecks the examples.

## Versioning and release

- Releases are deliberate: a manual pipeline that takes major, minor, patch or beta.
- The quality gate runs **before** the version bump, so a failure leaves no stray version commit.
- The next version is computed from what the registry already has. Betas count up from the last published beta.
- The changelog comes from conventional commits. The release is tagged and published with provenance under the matching channel tag, and gets a release page.
- A dry-run mode packs the artifact for inspection.
- Pre-1.0 packages say plainly that breaking changes are expected.

## Many languages, one shape

When an SDK exists in several languages, keep the same concepts and names in each, adapted to local idiom, and pin behaviour with shared test vectors run against every implementation.
