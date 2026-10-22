---
name: joel-security
description: Joel's security patterns: trust boundaries, authorization, credentials, signed payloads, abuse limits, AI guardrails.
disable-model-invocation: true
---

# Security patterns

Read `joel-architecture` first. Security in Joel's systems is structural: enforced by boundaries, types and code paths, never by convention or prompt.

## Defaults

- **Fail closed.** Unknown permission, missing config or an unreachable authority means deny. A half-configured security feature refuses to start.
- **Least exposure.** Every surface (webhooks, public forms, widgets, dashboard, programmatic API, internal endpoints) declares its own auth method, CORS and limits. Internal endpoints accept only a shared secret and are not publicly routable.
- **Validate at every trust boundary.** Bodies, headers, webhook payloads, files, model output and environment are parsed into known shapes before use. Validation is not authorization.

## Identity and authorization

- Delegate identity to a provider and verify tokens locally. Keep each token type to its own audience: a customer-portal token is rejected on merchant routes before verification is even attempted.
- Authorize in two steps: tenant membership first, then capability through one shared permission function. Never scatter role checks through handlers.
- Authentication failures are always 401. They are never caught and turned into 500s, and a failure in auth never falls through to anonymous access.
- Development bypasses are gated by environment and cannot be enabled in production.
- Sensitive datasets (finance, personal records) are gated by verified identity in code, at the data or tool layer.

## Tenant isolation

The rules are in `joel-architecture` section 8. The security view: cross-tenant access returns 404 rather than 403, so existence does not leak, and test data and live data never mix. Isolation gets explicit tests.

## Credentials

- **API keys:** prefixed by type and mode so leaks are recognisable and scannable, random, stored only as a hash, shown once, revoked rather than deleted, with last use tracked.
- **Secrets:** live in one secret store. Code reads them; nothing prints them. Debug output and logs redact secrets and connection-string passwords. Error trackers scrub them. Agent docs and examples never contain real values.
- **Rotation:** any credential that has been committed, logged or pasted is treated as exposed and rotated. Removing it from the file is not enough.
- Signing keys and keystores are never committed or regenerated casually.

## Signed payloads and replay

- Inbound webhooks: verify the HMAC over timestamp plus raw body with a constant-time comparison after a length check, enforce a tolerance window, and deduplicate on the provider's event id. Return a typed rejection reason for logs.
- For SNS-style subscription flows, allowlist the confirmation host and filter by topic.
- Outbound webhooks are signed the same way, so customers can verify them.
- Treat unsigned or unverifiable status updates as hints and re-read the truth from the source.

## Audit trail

Actions taken by API keys and agents are written to an append-only audit log: actor, tenant, action, target, outcome. People need to answer "who did this" for anything a machine did on their behalf.

## Money and messages

Idempotency keys and reconcilers follow `joel-architecture` section 10. On top of those:
- Amounts are integers in minor units and validated by constraints.
- Errors say whether the effect may have happened, so callers never blindly retry a payment.

## Abuse and limits

Rate limits per tenant, per key and per IP. Short windows for signup and auth failures. Body size limits per surface. Plan-based quotas that fall back to the lowest tier when unknown. Bounded queues and timeouts everywhere, so one tenant cannot exhaust shared capacity.

## Files and storage

Clients upload and download through short-lived signed URLs scoped to one object. Object keys include the tenant. Store the content type and validate it. Never serve user uploads from the application origin without the right headers.

## AI and agents

- Tools enforce permissions against the real caller.
- Allowlists apply to models, tools and resources.
- Every write to an outside system needs human approval.
- Query tools are read-only.
- Generated code runs in a sandbox with no network by default.
- Credentials are fetched at call time and never placed in context.
- Model output is untrusted input.
- Assume the prompt is ignored. See `joel-ai-agents`.

## Supply chain

- Lockfiles are enforced in CI.
- Known-vulnerable transitive dependencies are pinned with overrides.
- A checksum-verified vulnerability scanner gates on high severity, and every exemption carries a written reason and a review date.
- Package install scripts are allowlisted.
- Dependency updates are grouped and reviewed weekly.
- CI uses short-lived cloud credentials (OIDC), and deploy roles are narrower than infra roles.

## Review checklist

- Every new surface has a declared auth method and limits.
- Authorization goes through the shared permission check.
- Tenant scope is applied in data access.
- No secret is printed or committed.
- Payloads are verified and replay-safe.
- Money and message paths are idempotent.
- Failures deny.
- Isolation and rejection paths have tests.
