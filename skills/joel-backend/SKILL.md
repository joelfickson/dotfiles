---
name: joel-backend
description: Joel's backend patterns - the request lifecycle, three-tier layering, error and outcome model, identity and tenancy, API keys, per-surface policy, webhooks, idempotency, rate limiting, background work, reconciliation, and provider integration. Use when designing or changing an API, endpoint, middleware, webhook, worker, scheduled job, or third-party integration in one of Joel's projects.
---

# Backend patterns

Read `joel-architecture` first; this skill applies it to services. Default tools: TypeScript, Hono (keep Fastify where it already exists), zod, Clerk.

## Request lifecycle

Every request passes the same stages, each owned by one tier:

1. **Surface policy** (edge): CORS, rate limit, body limit, raw-body capture, chosen per surface.
2. **Identity** (edge): who is calling, from a session token, API key or signed payload.
3. **Authorization** (edge): membership in the tenant, then capability (`can(role, action)`).
4. **Validation** (edge): parse params, query and body into contract types. Reject with the first clear message.
5. **Domain** (service): apply rules, return a typed outcome.
6. **Data access** (repository): tenant-scoped reads and writes, inside a transaction when several rows change.
7. **Mapping** (edge): outcome to status code and body, row to public view.

A handler that does more than wire these stages together is doing too much.

## Layering

```
routes/        bind paths to middleware and controllers, nothing else
controllers/   validate input, call one service, map the outcome to HTTP
services/      business rules, tenant-scoped, return outcomes
repositories/  the only code that touches storage
providers/     adapters for external systems, behind domain-owned interfaces
jobs/          async entry points that call the same services
schemas/       boundary validation
config/        schema-validated environment
```

The app is built by a factory, separate from the process that listens, so tests and other ingresses construct the same app. Every service exposes a health endpoint that checks its dependencies with a timeout, and shuts down gracefully.

## Response and error model

- **Success returns the resource**, passed through a view function that removes secrets and normalises formats. No success envelopes in product APIs (`{ data, error }`, `{ success: true }`): the status code carries success. Older and prototype repos use envelopes; keep the repo's existing shape rather than mixing two. Lists return the page plus total, page and limit for bounded lists; large or append-heavy lists use keyset cursors (see `joel-database`).
- **Errors have one shape** across every service and language: a human message, an optional stable snake_case code, optional details. On money and message endpoints, `details` says whether a retry is safe and whether the effect may have happened. Server errors are always generic to the caller and fully logged.
- **Status codes are part of the contract:** 201 create, 202 accepted for async work, 204 empty, 400 invalid, 401 unauthenticated, 403 forbidden, 404 absent in this tenant, 409 conflict or replayed key with different input, 422 rule violation, 429 rate limited (with retry-after), 503 optional capability not configured.
- **Outcomes, not exceptions**, for expected failures; the controller maps them in one place. Database uniqueness violations become conflicts through a single helper.

## Identity and tenancy

- **Delegate identity, own the data.** An external identity provider issues sessions; the service verifies tokens locally (no network call per request; a provider whose tokens can only be checked remotely, as in some prototypes, needs a short-lived cache in front of that call) and lazily mirrors users and organisations into its own tables on first sight, keyed by the provider's id.
- **Programmatic access uses API keys:** a recognisable prefix with mode (live or test), a random body, only a hash stored, shown once, revoked rather than deleted, last-used tracked with a throttle off the request path. Machine callers are resolved before session auth.
- **Authentication failures are never caught and converted** into server errors.
- **Development bypasses** are gated by environment and cannot exist in production.
- Tenancy rules are in `joel-architecture` §8.

## Per-surface policy

Group routes by who calls them and apply policy per group: provider webhooks, public forms, embeddable widgets, the signed-in dashboard, programmatic API, internal endpoints. Each group gets its own CORS, rate limits, auth method and body handling, declared once. Internal endpoints accept only a shared secret and are never reachable through public routing by accident.

## Inbound webhooks

1. Keep the raw body; verify the signature over timestamp plus body with a constant-time compare and a tolerance window against replay.
2. Record the event with a unique key on (provider, event id); duplicates become no-ops. Record rejected deliveries too.
3. Acknowledge as soon as the record is durable; process asynchronously; nothing after the record may fail the response.
4. Treat unsigned or ambiguous payloads as hints and re-read status from the provider.
5. Enforce monotonic state transitions.

**Outbound webhooks** are signed the same way, retried with backoff, logged per delivery, and surfaced to the customer when they keep failing.

## Idempotency

Endpoints that move money or send messages accept an idempotency key. Reserve the key atomically before any work (the unique constraint is the lock), fingerprint the validated input, replay the stored response on retry, reject reuse with different input, treat a stale in-flight reservation as abandoned, and release the reservation when the domain refuses. Store reservations durably; an evicted cache entry turns a retry into a duplicate.

## Rate limiting and plans

Limits are a product feature: tied to plan, applied per tenant and per key, reported back in response headers. Unknown plans fall back to the lowest tier so a configuration slip never takes the API down. Abuse limits (signup, auth failures) apply per IP with short windows.

## Background work

- Async entry points (queue consumers, scheduled jobs) are another ingress over the same services.
- Pick the mechanism by the infrastructure already running: a queue system if it exists, a database job table with row locking if not, a scheduled trigger calling an authenticated internal endpoint on edge runtimes, a durable workflow engine for long multi-step pipelines with human gates.
- Decide retry policy per job. Retry what is idempotent. For non-idempotent effects, classify the failure yourself and retry only what is safe.
- Every job has bounded concurrency and a result summary (scanned, changed, skipped, failed).
- **Reconcile.** Each callback-dependent state has a sweep that re-reads truth from the source and repairs drift.

## Integrations

- Domain-owned interface, one adapter per provider, a registry chosen at boot, a mock adapter for development and tests.
- Every call that moves money carries an idempotency key, and every error says whether the effect may have happened.
- Provider configuration is all or nothing; production without it refuses to start.
- Keep provider quirks inside the adapter. The domain never sees a provider's status vocabulary.

## Observability

Structured logs with context objects (tenant, request, event ids), never secrets or whole bodies. Error tracking with scrubbing and rate limits. Metrics for request latency and the domain's money or message counters. Health endpoints that reflect real dependency state.

## Testing

Route tests drive the real app factory against a real database. Security helpers (signatures, idempotency, limits, permissions) are tested on their rejection paths, not only the happy path. Every behaviour change gets a test named for the behaviour.
