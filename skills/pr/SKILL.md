---
name: pr
description: Create a pull request with proper formatting and description
disable-model-invocation: true
allowed-tools: Bash, Read, Glob, Grep
---

# Pull Request Workflow

Create a well-documented pull request.

## Steps

### 1. Format Code First

Before creating PR, ensure code is formatted. Check for project configuration and run formatter:

**Node.js** (package.json): `pnpm/npm/yarn/bun run format`
**Rust** (Cargo.toml): `cargo fmt`
**Python** (pyproject.toml): `ruff format .` or `black .`
**Go** (go.mod): `go fmt ./...`

If formatting changes files, stage and commit them first using the /commit workflow.

### 2. Gather Context

```bash
git status
git branch --show-current
git log --oneline main..HEAD 2>/dev/null || git log --oneline master..HEAD
git diff main..HEAD --stat 2>/dev/null || git diff master..HEAD --stat
```

### 3. Check Remote Status

```bash
git remote -v
git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "No upstream set"
```

If no upstream, push with:
```bash
git push -u origin $(git branch --show-current)
```

### 4. Analyze All Commits

Review ALL commits in the branch, not just the latest:
```bash
git log main..HEAD --pretty=format:"%h %s" 2>/dev/null || git log master..HEAD --pretty=format:"%h %s"
```

### 5. Create PR Title

**Rules:**
- Under 70 characters
- NO emojis
- Use conventional format when appropriate: `feat:`, `fix:`, etc.
- Be descriptive but concise

### 6. Create PR Description

Use this format:
```markdown
## Summary
- Bullet point 1: what changed and why
- Bullet point 2: another change
- Bullet point 3: if needed

## Test plan
- [ ] Test case 1
- [ ] Test case 2
```

### 7. Execute PR Creation

```bash
gh pr create --title "title here" --body "$(cat <<'EOF'
## Summary
- Change 1
- Change 2

## Test plan
- [ ] Test 1
- [ ] Test 2
EOF
)"
```

### 8. Return PR URL

After creation, display the PR URL so the user can review it.

## Arguments

If arguments are provided ($ARGUMENTS):
- If it looks like a branch name, use it as the base branch
- If it's descriptive text, use it to guide the PR title/description
- If it's a number, it might be an issue number to reference
