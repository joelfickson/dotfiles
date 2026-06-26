---
name: recap
description: Document current session progress and remaining work so the next agent can pick up seamlessly
disable-model-invocation: true
allowed-tools: Bash, Read, Write, Glob, Grep
---

# Recap Workflow

Produce a handoff document capturing what has been done in this session and what remains, so the next agent can resume without context loss.

## Steps

### 1. Locate Project Root

Determine the project root (where the recap will be saved):

```bash
# Prefer git root if available
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
```

If not a git repo, use the current working directory.

### 2. Ensure .recap Directory Exists

```bash
mkdir -p "$ROOT/.recap"
```

### 3. Gitignore .recap (Git Repos Only)

If `$ROOT/.git` exists, ensure `.recap` is gitignored:

- Read `$ROOT/.gitignore` (create if missing)
- If no line matches `.recap` or `.recap/`, append `.recap/` on its own line
- Do NOT modify `.gitignore` if the project is not a git repo

### 4. Gather Session Context

Collect evidence of what happened in this session. Run in parallel where possible:

```bash
git status                              # Untracked + modified files
git diff --stat                         # Unstaged change summary
git diff --cached --stat                # Staged change summary
git log --oneline -20                   # Recent commits
git log --since="8 hours ago" --oneline # Commits made during session
git stash list                          # Any WIP stashes
```

Also review from the conversation itself:
- User's original request(s) and any refinements
- Tasks completed (files created, edited, commands run successfully)
- Tasks in progress (partially done work)
- Tasks not started (acknowledged but deferred)
- Decisions made and rationale
- Blockers, errors encountered, open questions
- Key file paths with line numbers for resumption points

### 5. Write the Recap File

Filename format: `$ROOT/.recap/YYYY-MM-DD-HHMM-<short-slug>.md`

Use current local time for the timestamp. The slug should be 2-5 words describing the session focus (e.g. `auth-token-refactor`).

**Template:**

```markdown
# Recap: <Session Focus>

- **Date**: YYYY-MM-DD HH:MM
- **Branch**: <current branch, if git>
- **Base commit**: <short sha of HEAD at session start if known, else current HEAD>
- **Working directory**: <absolute path>

## Objective

<1-3 sentences describing what the user asked for this session.>

## Completed

- [x] <Task> - <file:line references where relevant>
- [x] <Task>

## In Progress

- [ ] <Task> - <current state, what's half-done, where to continue>

## Remaining

- [ ] <Task> - <enough detail that a fresh agent can execute>
- [ ] <Task>

## Decisions & Rationale

- <Decision>: <why>
- <Decision>: <why>

## Blockers / Open Questions

- <Blocker or question awaiting user input>

## Key Files Touched

| File | Change | Notes |
|------|--------|-------|
| path/to/file.ts:42 | edited | <what and why> |
| path/to/new.ts | created | <purpose> |

## How to Resume

1. <First concrete step for the next agent>
2. <Next step>
3. <Verification command to confirm state, e.g. `pnpm test`>

## Relevant Commands Run

```
<command 1>
<command 2>
```

## References

- <links to relevant PRs, issues, docs, memory entries>
```

Omit sections that have no content rather than leaving them empty with "N/A".

### 6. Report

After writing, report:
- Absolute path to the recap file
- Whether `.gitignore` was updated
- One-line summary of what the next agent should do first

## Arguments

If `$ARGUMENTS` is provided, treat it as the session focus slug and/or additional framing to include in the Objective section.

## Notes

- Recaps are additive. Never overwrite an existing recap file - generate a new timestamped one.
- Do not include secrets, tokens, or cookies in the recap.
- Prefer absolute paths and `file:line` references so the next agent can jump directly.
- Keep "How to Resume" actionable: concrete commands and file locations, not vague prose.
