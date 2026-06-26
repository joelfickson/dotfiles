---
name: commit
description: Format code and create a commit with conventional commit message
disable-model-invocation: true
allowed-tools: Bash, Read, Glob, Grep
---

# Commit Workflow

Create a well-formatted commit following project conventions.

## Steps

### 1. Detect Project Type and Format Code

Check for project configuration files and run the appropriate formatter:

**Node.js** (package.json exists):
- Detect package manager: pnpm-lock.yaml -> pnpm, yarn.lock -> yarn, bun.lockb -> bun, else npm
- Run `<pkg-manager> run format` if "format" script exists
- Or run `<pkg-manager> run lint:fix` if "lint:fix" script exists

**Rust** (Cargo.toml exists):
- Run `cargo fmt`

**Python** (pyproject.toml exists):
- Run `ruff format .` or `black .` or `autopep8 --in-place --recursive .`

**Go** (go.mod exists):
- Run `go fmt ./...`

### 2. Check for Formatting Changes

After running formatters, check if any staged files were modified:
```bash
git diff --name-only
```

If files were modified by formatting:
- Report which files changed
- Stage the formatted files: `git add <files>`
- Continue to commit

### 3. Stage Files if None Staged

If no files are staged (`git diff --cached` is empty):
- If arguments specify files, stage only those files
- Otherwise, stage all changes: `git add -A`
- If still nothing to commit, report "Nothing to commit" and stop

### 4. Analyze Changes

Run these commands to understand the changes:
```bash
git status
git diff --cached --stat
git diff --cached
git log --oneline -5
```

### 5. Group Changes by Purpose

If multiple unrelated changes exist, consider separate commits. Group files by:
- Feature additions
- Bug fixes
- Refactoring
- Documentation
- Dependencies/config

### 6. Create Commit Message

**Rules:**
- Use conventional commits: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- Maximum 100 characters for the first line
- NO emojis
- Format: `type(scope): description` or `type: description`

**Examples:**
- `feat(auth): add password reset flow`
- `fix: resolve null pointer in user lookup`
- `chore: update dependencies`
- `docs: add API documentation for endpoints`

### 7. Execute Commit

Use heredoc format for the commit message:
```bash
git commit -m "$(cat <<'EOF'
type: concise description under 100 chars
EOF
)"
```

## Arguments

If arguments are provided ($ARGUMENTS), use them as guidance for the commit message or scope.
