---
name: codex
description: Adversarial second-opinion check by the Codex CLI on a fixed set of claims or items: a report, a draft, a finding list, a diff. Codex judges each item against the evidence it is given and nothing else. Use when asked to "run codex", "have codex verify", "fact-check this", "get a second opinion", or before shipping a customer-facing claim that needs independent verification.
---

# Codex verification

Codex is the **adversary**. Its job is to break claims, not to agree with them. Every item it is handed starts as _unproven_ and earns _verified_ only from evidence Codex checks itself. Its review is **in scope** by construction: it judges exactly the items you hand it, against exactly the evidence you name, and its report covers those items and nothing else.

## Steps

### 1. Pin the scope

Write down three lists before you build a prompt:

- **Target**: the file(s) or pasted text under review.
- **Items**: every claim, number or decision Codex must judge. Extract them yourself and number them. "Every factual claim in report.md" is acceptable only when you also list the numbers Codex must recompute. An item list is done when a reader could tick each one off.
- **Evidence**: the files, folders, URLs, source clones and repro outputs Codex may use. Anything absent from this list cannot verify an item.

If the user named only a target, derive the items from it and show them the list only when it is ambiguous what counts as a claim.

### 2. Clear the data gate

Codex sends what it reads to OpenAI. Customer data (anything under `investigations/customers/`, customer repos, usage exports) goes to Codex only when Joel asked for Codex on that material in this conversation. Exclude `.env*` files, tokens and credentials from the evidence list in every case. If the gate is not cleared, stop and ask.

### 3. Build the prompt

Fill [PROMPT.md](PROMPT.md) with the three lists from step 1 and save it to a temp file. The template carries the adversarial stance, the scope fence and the output format; edit only the placeholders.

### 4. Run Codex

```bash
codex exec --skip-git-repo-check -s read-only -C "<working dir>" \
  -o "<output file>" - < /tmp/codex-prompt.md > /tmp/codex.log 2>&1
```

- Always `-s read-only`. Codex reviews; it never edits.
- Run it in the background. Long reviews take minutes.
- Put the output next to the target (for an investigation, its `artifacts/codex-verification.md`).

### 5. Judge the judge

Codex's report is input to your judgement, not the verdict. Read it against the item list:

- **Scope check**: every row must map to a numbered item. Drop rows that do not, and note how many you dropped.
- **Coverage check**: every item must have a row. Re-run Codex on missing items only.
- **Spot-check every _wrong_ and _unsupported_ row** yourself against the cited evidence. Codex can be wrong too. Mark each as _confirmed_ or _rejected_ with your reason.
- Sample at least two _verified_ rows that carry derived numbers and recompute them.

The step is done when every item has a final verdict that you, not Codex, stand behind.

### 6. Report

Give the user: the overall verdict, a table of items that are wrong or unsupported after your spot-check (with the fix), items Codex could not check and why, dropped out-of-scope rows (count only), and the path to Codex's raw output. Fix nothing until the user asks.
