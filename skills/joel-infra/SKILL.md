---
name: joel-infra
description: Joel's engineering-system patterns: monorepo, testing strategy, CI as the gate, deploys, environments, secrets.
disable-model-invocation: true
---

# Engineering system patterns

Read `joel-stack` first. Default tools: pnpm + Turborepo, Biome, Vitest, GitHub Actions on Blacksmith, Docker, Terraform on AWS, Cloudflare Workers for web, 1Password.

## Repository shape

- **One monorepo per product**, organised by role: `apps/` (deployables), `packages/` (shared contracts, data layer, UI, configuration presets, provider clients), `services/` when there are several backends, plus `infra/`, `deploy/`, `docs/` and `technical-debt/`.
- **Shared configuration is a package.** Compiler presets, lint config and build presets are versioned workspace packages that every app extends. Do not copy them.
- **One command per intent** at the root (dev, build, typecheck, test, lint, format, check), with filtered variants per app. `dev` starts local dependencies, then the apps.
- **The task graph is explicit.** Builds depend on upstream builds, outputs are declared, and environment inputs are part of cache keys.
- **Pin the toolchain** (package manager, runtime version) in the repo itself.

## Quality gates live in CI

No local git hooks. CI runs the full gate on every push and pull request: install from the lockfile, lint and format check, typecheck, test, build, then **execute the built artifact**. Agents run the same gate before handoff.

## Testing strategy

- **Integration over mocks for your own stack.** Service tests run the real app against a real database, which is created and migrated for the run. Mock only what you do not own: third-party networks, at the HTTP boundary.
- **Unit-test the dangerous logic** exhaustively: money, permissions, signatures, idempotency, limits, parsing. Cover rejection paths, not just happy paths.
- **Every behaviour change brings a test.** "Existing tests still pass" is not coverage.
- **Smoke-test artifacts.** Boot the built output or container in CI and hit its health endpoint. Grep built frontend bundles for the production API origin and the absence of localhost. Code that never executed in CI is untested, however green the unit tests are.
- **Guard tests for the repository itself.** Assert architectural rules (which modules may import what, where heavy work may run, emitted schemas against a baseline). A guard's failure message links to the decision record that explains the rule.
- **Tests are hermetic.** Real credentials are blanked in the test environment so nothing can send live email or charge a card.
- **End-to-end tests are few,** reserved for critical journeys.

## Delivery

- **A merge is not a release.** Deploys are triggered deliberately per environment and per target.
- **Deploy only what CI passed.** The pipeline verifies a green CI run on the exact commit before deploying.
- **One artifact, many environments.** Build once with an immutable tag, then promote the same bytes through beta, release candidate and GA by re-tagging. Never rebuild for production.
- **Migrations are a separate step** that runs before the new version rolls out, never inside container start.
- **Roll out one target at a time.** Wait for stability, check health on the public URL, then move to the next. Deploys never cancel each other mid-flight.
- **Rollback is a documented recipe**, kept in a runbook with preflight checks and the rollout order.

## Environments and infrastructure

- **Everything is code.** Infrastructure is declared in Terraform with remote locked state. Applies run from CI after a plan posted for review. Only a one-time bootstrap is applied by hand.
- **Short-lived credentials.** CI authenticates to the cloud through OIDC roles, split into an infra role and a narrower deploy role.
- **Shared foundations, owned additions.** Products reuse a shared network and load balancer and own only their own resources.
- **Cost is a design input.** Choose small instance classes, avoid NAT where public subnets will do, tag every resource by project, and set a budget alarm per product.
- **Placement follows workload.** Web frontends run on the edge. Stateful backends run as containers near their database, in the region closest to users. Small personal backends get one VM with compose and a reverse proxy.
- Staging and production are separate, named consistently, and configured from the same templates.

## Secrets and configuration

One secret store is the source of truth. CI holds a single service-account credential and pulls everything else at runtime. Local env files are rendered from secret references. Only example files are committed. Adding a setting updates code, example file, infrastructure and pipelines in one change. After a deploy, verify that every required secret exists.

## Containers

Multi-stage builds from the monorepo root. A standalone production dependency set. A non-root user. A real init process. Health checks. Migrations shipped inside the image. Pick a slim base image when native libraries are needed and a minimal one otherwise. Pin the image version to the runtime version.

## Supply chain

Pin dependency overrides for known vulnerabilities. Run a pinned, checksum-verified vulnerability scanner as a gate on high severity, and give every exemption a written reason. Group automated dependency updates weekly. Restrict which packages may run install scripts.

## Observability and operations

- Every service has a health endpoint that reports real dependency state. Smoke tests, probes and container health checks all use it.
- Logs are structured, and the error tracker scrubs secrets and is rate-limited.
- Metrics and log aggregation run for clustered deployments. Analytics are for product questions.
- Cost alarms go to a human.
- CI steps record the incident that made them necessary, so nobody deletes a guard they don't understand.

## Releases

Published packages follow `joel-sdk`. Binaries follow `joel-rust`. Binary downloads for private code go to a public releases repository.
