---
name: joel-workflow
description: How Joel plans, slices, reviews, verifies (SHIP verdicts) and hands off engineering work.
disable-model-invocation: true
---

# Working patterns

Read `joel-stack` first. This skill covers how work moves from idea to shipped, not what the code looks like.

## Plan before code

- **Spec, then plan, then build.** Non-trivial work gets a dated spec (the problem, constraints, decisions, what is out of scope) and a plan (ordered checkbox tasks, each with its verification). Keep them in `docs/superpowers/specs/` and `docs/superpowers/plans/`.
- **Numbered issue specs** for a backlog. Start from the lowest unimplemented number whose dependencies are met.
- **Design and visuals are approved first** (see `joel-ui-design`). Logic can proceed in parallel.
- **Decisions are recorded** as they are made: what was decided, why, what was rejected, what is still unproven. A later decision supersedes with a new record and links back.
- **Ask early.** If the spec leaves a real choice open, ask one or two short questions before building the wrong thing.

## Slice the work

- Each task is small enough to verify on its own: it builds, its tests pass, and someone can see the behaviour.
- Contract first, then server, then each consumer. Or a thin vertical slice through all layers, then widen.
- Parallel agents get disjoint scopes (one per platform, per package, or per feature) and stage only their own files.
- Risky changes (migrations, infra, cross-cutting refactors) run in their own worktree off the latest default branch.

## Cross-repo changes

When a change in one product's contract affects a sibling product, file a triage entry before merging and check open entries before starting work. Never edit a sibling repo from another repo's session. Adding a field is not a triage event; changing or removing one is.

## Verify before handoff

Run the full gate for everything touched: format, lint, typecheck, test, build, and boot the built artifact where one exists. Then audit the diff honestly.

**Hunt the diff for shortcuts:**
- TODO, FIXME, HACK and "temporary" markers.
- Type escapes and lint suppressions.
- Leftover debug output and commented-out code.
- Swallowed errors.
- Hardcoded credentials, IDs or production URLs.
- Sleeps used for synchronisation.
- Skipped or focused tests.
- Loosened version pins.
- Raw queries near user input.
- Flags turned on by default without a rollout note.

Cite the exact line for each hit.

**Check test reality:** every new function, branch and error path has a test. "Existing tests still pass" is not coverage.

**Classify breakage risk:**
- API contract changes
- Migrations (locks on large tables, NOT NULL without a default, dropping a column still referenced)
- Shared-type changes
- Infrastructure, cloud, edge or dependency changes
- Auth changes
- Performance-sensitive paths (N+1 queries, network calls in loops, synchronous IO on hot paths)

**Verify against real systems, read-only:** inspect the live schema and row counts before a migration, the deployed config before an infra change, and every consumer of a changed contract. If a system cannot be reached, list it under "Unverified". Never guess its state.

**Give a verdict:** SHIP, SHIP WITH CAVEATS, or DO NOT SHIP, with blocking issues, risks, unverified items and the commands that were run. Never soften a real failure to improve the verdict.

## Code review focus

Review in this order:
1. Does it do what the spec asked, and nothing it did not ask?
2. Does it respect the architecture: dependency direction, one contract home, adapters, tenancy in data access, typed outcomes?
3. Are failure paths explicit, bounded and tested?
4. Is every consumer of a changed contract updated, or is the gap recorded?
5. Is anything security-sensitive changed (see `joel-security`)?
6. Only then: naming and readability.

Comment on what would break, not on taste. Each finding names the concrete scenario that fails.

## Performance work

- **Measure first.** Never invent targets or results. Record the baseline, change one thing, measure again, report both numbers and how they were taken.
- **Preserve the contract.** Optimisations keep response fields, ordering, pagination and pricing identical. Prove it with tests or a parity check against the old path.
- **Usual suspects:** N+1 queries, unbounded result sets, missing indexes for the actual query, network calls in loops, synchronous heavy work on request paths (move it to a worker), unbounded caches.
- Bind large ID batches as arrays, add the index the query needs, and move heavy processing off the request path.

## Hand off

Long or multi-session work ends with a handoff note: what was built, what remains, what is unverified, the decisions made, and file references for the next session. Handoffs are additive and never overwrite an earlier one. Known gaps become technical-debt entries. Report what actually happened, including skipped checks.
