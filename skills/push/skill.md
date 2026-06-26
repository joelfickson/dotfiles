---
name: push
description: Verify builds for changed files and push commits to remote
disable-model-invocation: true
allowed-tools: Bash, Read, Glob, Grep
---

# Push Workflow

Verify that changed code builds successfully before pushing to remote.

## Steps

### 1. Check for Commits to Push

Get the current branch and check for unpushed commits:
```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "origin/$BRANCH")
git log --oneline $UPSTREAM..HEAD
```

If no commits to push, report "Nothing to push" and stop.

### 2. Get Changed Files

Get all files changed in the commits to be pushed:
```bash
git diff --name-only $UPSTREAM..HEAD
```

Store this list for analysis.

### 3. Detect Affected Components

Based on file paths, determine which components need build verification:

| Path Pattern | Component | Build Check |
|--------------|-----------|-------------|
| `services/core/**` or `services/*/` | Rust service | `cargo check -p <package>` |
| `packages/cli/**` | CLI (Rust) | `cargo check -p sekuire-cli` |
| `packages/sdks/rust/**` | Rust SDK | `cargo check -p sekuire-sdk` |
| `packages/sdks/typescript/**` | TypeScript SDK | `cd packages/sdks/typescript && pnpm build` |
| `packages/sdks/python/**` | Python SDK | `cd packages/sdks/python && python -m py_compile` |
| `apps/docs/**` | Docs (Docusaurus) | `cd apps/docs && pnpm build` |
| `apps/*-web/**` | Frontend (React) | `cd apps/<name> && pnpm typecheck` |
| `*.rs` anywhere | Rust | `cargo check` |
| `*.ts` or `*.tsx` | TypeScript | Find nearest package.json and run typecheck |
| `Cargo.toml` or `Cargo.lock` | Rust workspace | `cargo check` |
| `package.json` | Node package | Run typecheck in that directory |

### 4. Run Targeted Build Checks

For each affected component, run ONLY the relevant check:

**Rust (services/core):**
```bash
SQLX_OFFLINE=true cargo check -p sekuire-registry-api
```

**Rust (other packages):**
```bash
cargo check -p <package-name>
```

**TypeScript/React apps:**
```bash
cd <app-directory>
pnpm typecheck 2>&1 || pnpm tsc --noEmit 2>&1
```

**TypeScript SDK:**
```bash
cd packages/sdks/typescript
pnpm build
```

**Docusaurus docs:**
```bash
cd apps/docs
pnpm build
```

**Python:**
```bash
cd <python-directory>
python -m py_compile <changed-files>
```

### 5. Report Build Results

For each component checked:
- Report SUCCESS or FAILURE
- On failure, show the error output
- Stop if any check fails

### 6. Push to Remote

If all checks pass:
```bash
git push origin HEAD
```

If pushing to a new branch without upstream:
```bash
git push -u origin HEAD
```

### 7. Summary

Report:
- Number of commits pushed
- Components verified
- Remote branch updated

## Skip Options

If $ARGUMENTS contains:
- `--force` or `-f`: Skip build checks and push directly
- `--no-verify`: Same as --force

## Examples

```
/push              # Check affected builds and push
/push --force      # Skip checks and push immediately
```

## Notes

- Only checks components with actual file changes
- Uses SQLX_OFFLINE=true for Rust services to avoid database dependency
- Fails fast on first build error
- Does not run tests (use /test for that)
