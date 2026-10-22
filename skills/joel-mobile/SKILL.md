---
name: joel-mobile
description: Joel's mobile patterns: shared core with native UI, UI state, cache-then-network, offline outbox, paid tiers, releases.
disable-model-invocation: true
---

# Mobile patterns

Read `joel-architecture` and `joel-ui-design` first; the design rules apply to native screens. Default tools: Kotlin Multiplatform for shared logic, Jetpack Compose on Android, SwiftUI on Apple platforms. Flutter is maintenance only.

## Shared core, native shell

- **Share logic, never UI.** Networking, auth, models, persistence, domain rules and DI live in a shared core. Each platform builds its own native UI so it can use platform features fully (TV focus, car integrations, widgets, media sessions, system design language).
- **Platform seams are thin.** Only genuinely platform-specific pieces (HTTP engine, secure storage, file paths, device info) cross the platform boundary.
- **One domain module per app, one shared module for all.** An app depends on the shared core and its own domain module. Apps never depend on each other.
- **Expose concurrency idiomatically** on each side, so native code consumes streams and sealed results naturally.

## UI state

- Each screen has one immutable state object with sensible defaults, held by a view model and exposed as a stream. Updates copy the state; views render it.
- Events flow up from the view, state flows down. No business logic in views.
- On Apple platforms, use the modern observation model when the deployment floor allows it.
- Navigation: one stack per tab, with routes declared in one place per graph.

## Data: cache, then network

- Repositories emit cached data immediately, then fetch, write the cache and emit fresh data.
- Offline, they emit the cached snapshot and stop.
- A network failure after cached data was shown is logged and absorbed. Without a cache it surfaces.
- Cancellation always propagates.
- Images and media use persistent caches. Never use an uncached image loader.

## Offline-first writes

Mutations go to a local outbox: a typed payload, FIFO order, retries with backoff, dedupe of toggles, drained on reconnect. The server is the source of truth on conflict. Analytics events queue the same way.

## Security

Tokens live in platform secure storage behind one interface. Release signing keys are never committed or regenerated. Store identifiers and signing stay continuous across rewrites so users upgrade in place. Debug logging and verbose network logs exist only in debug builds.

## Paid tiers

- Purchases go through the platform store. The server verifies receipts, caches the tier briefly, and downgrades an expired subscription on read.
- Per-tier limits live in one server-side lookup table. The client gate is for UX only; the server enforces.
- Store-required features (in-app account deletion, restore purchases) ship with the first paid release, not after review rejects it.
- With no backend, the client is the only gate. Accept that only for a prototype.

## Local first, server later

A prototype may ship with no server: on-device storage or the platform's own sync, plus a defensive import/export format. Keep that storage behind the same repository interface a server-backed version will use, so adding the backend is an adapter, not a rewrite *(inferred)*.

## Environments

Use build types, not product flavours. Debug and release get distinct app identifiers and install side by side. Configuration comes from build config, one config object per app, and extra API clients are registered by name.

## Platform parity

- A feature ships on every platform in the same change. A change on one side gets its twin on the other.
- Shared-core changes cascade to every app that uses them.
- Every supported language ships with the change on both platforms.
- Platform-specific exceptions (a sign-in method one store forbids) are written down as intentional.
- When working in parallel, assign one agent per platform.

## Design rules on native

One corner radius (8pt). Consistent control heights and a 44pt minimum touch target. One typeface. No cards or raised panels. Skeleton or shimmer loading instead of spinners. Persistent navigation, and a persistent mini player in media apps.

## Testing

- Shared-core logic is tested in common code with coroutine test utilities.
- API clients are tested against a mock HTTP engine.
- Use hand-written fakes instead of a mocking library.
- Key screens get snapshot tests on Apple platforms.
- Every change builds on every platform before handoff.

## Delivery

- Pull requests run change detection only; full builds run on the main branch, filtered by changed paths.
- A release train picks apps, platforms and the version bump, then ships to internal testing tracks.
- Store submission is scripted.
- The release pipeline is linted and tested like code.

## Session discipline

Write a short implementation report and record debt entries at the start and end of each session. Keep a platform-parity audit current.
