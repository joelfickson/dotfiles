---
name: verify
description: Audit pending changes for code quality, shortcuts, hotfixes, and breakage risk - uses postgres, k8s, aws, wrangler to validate API/migration/infra changes against live systems
disable-model-invocation: true
allowed-tools: Bash, Read, Glob, Grep, Edit, Write
---

# Verify Workflow

Produce an honest audit of the current changes before they ship. Surface shortcuts, hotfix patterns, missing tests, and anything that could break once deployed. If the changes touch APIs, schemas, infrastructure, or external services, use the available tools to verify against the real systems - do not rely on the diff alone.

The goal is to catch problems now, not after deploy. Be direct about what is risky.

## Steps

### 1. Determine Scope of Changes

Find out what is actually changing. Run in parallel:

```bash
git status
git diff --stat
git diff --cached --stat
git diff                  # unstaged
git diff --cached         # staged
git log --oneline -10
git log origin/main..HEAD --oneline 2>/dev/null  # commits ahead of main
```

If `$ARGUMENTS` specifies a base ref (e.g. `main`, `origin/main`, a sha), diff against that instead:

```bash
BASE="${ARGUMENTS:-origin/main}"
git diff "$BASE"...HEAD --stat
git diff "$BASE"...HEAD
```

Classify the changed files into buckets:
- Application code (src/, app/, lib/)
- API routes / controllers / handlers
- Database migrations / schema files
- Shared types / contracts
- Infrastructure (Terraform, k8s manifests, Dockerfiles, CI config)
- Cloudflare Workers / wrangler.toml
- Tests
- Config / env / secrets references
- Docs only

### 2. Code Quality Pass

Run project tooling first. Abort verification for that tool if it is not configured, but note it.

Detect project type (see commit skill for detection logic) and run the most aggressive checks available without auto-fixing:

```bash
# Node.js
<pkg-manager> run typecheck 2>&1 || <pkg-manager> exec tsc --noEmit
<pkg-manager> run lint
<pkg-manager> run test -- --run 2>&1 | tail -50

# Rust
cargo clippy --all-targets -- -D warnings
cargo test --no-run

# Python
uv run ruff check .
uv run mypy . 2>&1 || true
uv run pytest --collect-only

# Go
go vet ./...
go build ./...
go test ./... -count=1
```

Record the exact failing output. Do not summarise away real errors.

### 3. Hunt for Shortcuts, Hotfixes and Smells

Scan the diff (not the whole repo) for patterns that usually mean "I will fix this later":

```bash
BASE="${ARGUMENTS:-origin/main}"
git diff "$BASE"...HEAD | grep -n -iE '\b(TODO|FIXME|HACK|XXX|TEMP|TEMPORARY|HOTFIX|QUICK[- ]?FIX|WORKAROUND|KLUDGE|REVERTME|DO NOT MERGE|DNM|@ts-(ignore|expect-error)|eslint-disable|# type: ignore|rubocop:disable|@SuppressWarnings|unimplemented!|todo!)\b'
```

Also look for these specific anti-patterns in added lines (`+` in the diff):

- `console.log`, `println!`, `dbg!`, `print(` left in non-test code
- `any` / `as any` / `@ts-ignore` in TypeScript
- `unwrap()` / `expect(` in Rust production code
- Commented-out code blocks
- Swallowed exceptions: `catch (_) {}`, `except: pass`, `catch (e) { // ignore }`
- Hardcoded credentials, tokens, IPs, customer IDs, bearer tokens, production URLs where staging is expected
- `sleep(` / `setTimeout` with magic numbers as a synchronisation primitive
- Disabled tests: `.skip`, `.only`, `xit(`, `xdescribe(`, `#[ignore]`
- Feature flags flipped on by default without a rollout note
- Version pinning loosened (`^` -> `*`, `~` removed)
- New `unsafe` blocks (Rust) or raw SQL near user input

For each hit, list: file, line, the actual line, and why it is a concern. Do not list generic findings - cite the exact line.

### 4. Test Coverage Reality Check

For every non-trivial code file changed, confirm a corresponding test was added or updated:

```bash
git diff --name-only "$BASE"...HEAD | grep -vE '\.(md|json|lock|yaml|yml|toml)$'
```

Cross-reference with test files in the diff. If a new function, branch, or error path has no covering test, list it. Do not accept "the existing tests still pass" as coverage for new logic.

### 5. Detect Breakage-Prone Changes

Decide which of the following categories apply. Run the corresponding deep verification in step 6.

- **API contract change**: added/removed/renamed routes, request/response field changes, status code changes, auth header changes, pagination changes
- **Database migration**: new migration file, schema diff, index change, column type change, NOT NULL added, ENUM value added/removed, RLS policy change
- **Shared types change**: edit to a package consumed by other apps (e.g. `@vwaza/types`)
- **Infra change**: k8s manifests, Helm values, Terraform, Dockerfile, CI workflow, resource limits, secrets mounts
- **AWS change**: IAM policies, S3 bucket policy, CloudFront, Lambda, RDS parameter groups
- **Cloudflare change**: wrangler.toml, Worker code, routes, KV/R2/D1 bindings, DNS
- **Dependency change**: major version bumps, new transitive deps, removed deps, lockfile-only changes
- **Auth / security change**: login, token issuance, session handling, password flows, role checks
- **Performance-sensitive change**: N+1 candidates, new network calls in loops, new synchronous IO on hot paths

### 6. Deep Verification Using Available Tools

Use the real systems. Do not guess. If a tool is not authenticated or not available, report that explicitly as an unverified risk rather than silently skipping.

#### 6a. Database / Migrations (PostgreSQL MCP or psql)

If a migration or schema change exists:

1. Read the migration file(s) in full.
2. Verify the current live schema of the affected tables:
   ```bash
   # If postgres MCP is available, prefer MCP queries.
   # Otherwise use psql against the appropriate environment.
   docker exec -it vwaza_postgres psql -U postgres -d vwaza_db -c "\d+ <table>"
   docker exec -it vwaza_postgres psql -U postgres -d vwaza_db -c "SELECT column_name, data_type, is_nullable, column_default FROM information_schema.columns WHERE table_name = '<table>';"
   ```
3. Check indexes, constraints, foreign keys, row count (for lock risk):
   ```sql
   SELECT indexname, indexdef FROM pg_indexes WHERE tablename = '<table>';
   SELECT reltuples::bigint AS approx_rows FROM pg_class WHERE relname = '<table>';
   ```
4. Simulate destructive operations mentally against the real row count. Flag:
   - `ALTER TABLE ... ADD COLUMN ... NOT NULL` without a default on a large table
   - `ALTER TABLE ... DROP COLUMN` that is still referenced in application code (grep for the column name)
   - New unique constraint on a column with existing data (check for duplicates)
   - Missing index on a new foreign key
   - `DROP INDEX` on a column used in `WHERE` / `JOIN`
   - Enum changes inside a transaction (Postgres restriction)
5. Confirm the migration has a corresponding rollback / down, or document why it is irreversible.

#### 6b. API Contract Changes

1. List every changed route and its before/after signature.
2. Grep every consumer across the workspace for the old signature:
   ```bash
   # Vwaza workspace has web, mobile KMP, and Flutter consumers
   grep -rn "<old-path-or-field>" monorepo/apps/ mobile/ vwaza_app/ \
     --include="*.ts" --include="*.tsx" \
     --include="*.kt" --include="*.swift" \
     --include="*.dart"
   ```
3. For each consumer, confirm whether it was updated in this change. If not, a technical debt file under `/technical-debt/` must exist (Vwaza rule). If neither is true, flag it as a breaking change with unfixed callers.
4. If `@vwaza/types` changed, verify mobile models under `mobile/shared/src/commonMain/.../models/` match.

#### 6c. Kubernetes Changes

```bash
# Current context and what it points at - always print before anything else
kubectl config current-context
kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}'

# Dry-run the manifests against the live cluster
kubectl diff -f <manifest>
kubectl apply --dry-run=server -f <manifest>

# Inspect the current running state for the affected resource
kubectl get deploy,sts,svc,ingress,cm,secret -n <ns> -l app=<app>
kubectl describe deploy <name> -n <ns>
```

Flag: resource limit decreases, replica count going to 0 or 1, probe timeouts shortened, PDB removed, image tag pinned to `latest`, secrets moved into ConfigMaps, Ingress host changes, service type changes.

Do NOT run `kubectl apply`, `kubectl delete`, or anything that mutates cluster state during verification. `--dry-run=server` and `diff` only.

#### 6d. AWS Changes

```bash
aws sts get-caller-identity          # confirm account and identity first
aws configure list                    # confirm region
```

Then, for each affected resource type:

```bash
# IAM
aws iam get-policy --policy-arn <arn>
aws iam get-policy-version --policy-arn <arn> --version-id <v>

# S3
aws s3api get-bucket-policy --bucket <name>
aws s3api get-bucket-versioning --bucket <name>
aws s3api get-public-access-block --bucket <name>

# Lambda
aws lambda get-function --function-name <name>
aws lambda get-function-configuration --function-name <name>

# CloudFront
aws cloudfront get-distribution-config --id <id>
```

Flag: public S3 policies, `"Principal": "*"` in IAM, Lambda env vars containing secrets, CloudFront origins pointing to non-prod, removal of versioning / MFA delete.

Read-only commands only. No `aws * put-*`, `create-*`, `update-*`, `delete-*` unless the user explicitly asks.

#### 6e. Cloudflare Workers (wrangler)

```bash
wrangler whoami
wrangler deployments list --name <worker>
wrangler tail --name <worker> --format pretty   # only briefly, to confirm live traffic shape
```

Diff `wrangler.toml` bindings (KV, R2, D1, Durable Objects, vars, routes, compatibility_date). For each new binding, confirm the resource exists:

```bash
wrangler kv:namespace list
wrangler r2 bucket list
wrangler d1 list
```

Flag: `compatibility_date` moved backward, routes overlapping with another worker, secrets demoted to `vars`, missing binding that code references.

Do not run `wrangler deploy` during verification.

#### 6f. Dependency Changes

```bash
# Node
<pkg-manager> why <package>
<pkg-manager> outdated

# Rust
cargo tree -i <crate>

# Python
uv pip show <package>
```

For any major version bump, locate the upstream changelog and list real breaking changes (not a generic "check the changelog"). If you cannot reach the changelog, say so.

### 7. Cross-Consumer Impact (Vwaza-specific)

When the repo is the Vwaza workspace and a backend service under `monorepo/services/` changed, walk the consumer matrix from the root CLAUDE.md. For every consumer that is not updated in this change:

- Either confirm a matching file exists under `/Volumes/Work/code/Vwaza/current-apps/technical-debt/`
- Or flag "missing technical debt entry" in the report

### 8. Write the Verify Report

Write the report to `$ROOT/.verify/YYYY-MM-DD-HHMM-<slug>.md` where `$ROOT` is the git root (or `pwd` if not a repo). Create `.verify/` if needed and gitignore it (same rules as the recap skill).

Also print a compact summary to the terminal so the user sees it without opening the file.

**Template:**

```markdown
# Verify: <Short title>

- **Date**: YYYY-MM-DD HH:MM
- **Branch**: <branch>
- **Base**: <base ref used for diff>
- **HEAD**: <short sha>
- **Verdict**: SHIP / SHIP WITH CAVEATS / DO NOT SHIP

## Summary

<3-5 sentences. Lead with the verdict and the single biggest risk.>

## Code Quality

- Typecheck: PASS / FAIL (<details or excerpt>)
- Lint: PASS / FAIL
- Tests: PASS / FAIL (<count>)
- Build: PASS / FAIL

## Shortcuts & Smells Found

| File:Line | Pattern | Concern |
|-----------|---------|---------|
| path/to/file.ts:42 | `@ts-ignore` | Silences a real type error on the new field |
| path/to/file.rs:88 | `.unwrap()` | Panics on malformed input from HTTP body |

## Test Coverage Gaps

- <function / branch> in <file> has no added test covering <case>

## Breakage Risk

### API changes
- <route>: <before> -> <after>. Consumers found: <list>. Updated in this change: <yes/no per consumer>.

### Migrations
- <file>: <summary>. Live row count: <n>. Lock risk: <low/medium/high>. Rollback present: <yes/no>.

### Infra / AWS / k8s / Cloudflare
- <resource>: <diff summary>. Live state verified via <command>. Risk: <...>.

## Unverified
<Things you could not check and why. Do not hide these.>

## Required Follow-ups Before Merge

- [ ] <concrete action>
- [ ] <concrete action>

## Commands Run

```
<verbatim commands>
```
```

Omit sections that have no content rather than filling them with "N/A".

### 9. Final Terminal Output

End the session with:

1. The verdict (SHIP / SHIP WITH CAVEATS / DO NOT SHIP) on its own line.
2. The top 3 risks, one line each, most severe first.
3. Absolute path to the full report.

## Hard Rules

- Never run mutating commands (`apply`, `deploy`, `put-*`, `delete`, `create`, `update`, `DROP`, `ALTER`, `TRUNCATE`, `INSERT`, `UPDATE`) during verification. Read-only and dry-run only.
- Never guess at a live value. If you cannot reach postgres / k8s / aws / cloudflare, list it under "Unverified" - do not pretend the check passed.
- Do not silence or reclassify a real failure to make the verdict greener. A failing typecheck is a failure, not a "minor issue".
- Do not paste secrets, tokens, cookies, or full connection strings into the report.
- If the diff is empty, report that and exit. Do not invent findings.

## Arguments

`$ARGUMENTS` can be:
- A base ref to diff against (e.g. `main`, `origin/main`, a sha). Defaults to `origin/main`.
- A scope hint (e.g. `migrations only`, `api only`) to focus the report.
