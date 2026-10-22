---
name: joel-stack
description: Joel Fickson's engineering principles and the map of his pattern skills. Use when starting, scaffolding, designing, or writing code in one of Joel's own projects, when choosing an approach or tool for him, or when asked "how would Joel build this". Routes to the joel-* pattern skills, including the ones that only load through this map (mobile, infra, AI agents, SDKs, Rust, security, workflow).
---

# Joel's engineering principles

Defaults for **Joel's own projects**. In an upstream or customer repo, that repo's conventions win and these only inform judgement.

Precedence inside his projects: the repo's own `CLAUDE.md`/`AGENTS.md` > a nested per-app file > these skills > generic skills.

## Which skill

The first five fire on their own. The rest load only through this map, to keep them out of context during unrelated work: read the file at the path given.

| Work | Skill |
|---|---|
| Designing a system, service, module or feature; deciding where code belongs | `joel-architecture` (read first for any design work) |
| APIs, request handling, auth, webhooks, jobs, integrations | `joel-backend` |
| Data modelling, schemas, migrations, queries, storage choice | `joel-database` |
| Web app structure, state, data flow, forms | `joel-frontend` |
| Anything visual | `joel-ui-design` |
| Auth, permissions, keys, webhooks, payments, uploads, secrets, AI tools | `~/.claude/skills/joel-security/SKILL.md` |
| Planning, slicing, review, ship verdicts, handoff | `~/.claude/skills/joel-workflow/SKILL.md` |
| Repo layout, testing strategy, CI, delivery, environments | `~/.claude/skills/joel-infra/SKILL.md` |
| LLM features, agents, tools, MCP | `~/.claude/skills/joel-ai-agents/SKILL.md` |
| iOS, Android, TV, shared mobile core | `~/.claude/skills/joel-mobile/SKILL.md` |
| Public APIs, SDKs, published packages | `~/.claude/skills/joel-sdk/SKILL.md` |
| Systems code, CLIs, native apps, concurrency | `~/.claude/skills/joel-rust/SKILL.md` |

## Principles

1. **Verify before handoff.** Format, lint, typecheck, test and build everything you touched. A change that does not build is a regression. Name any check you could not run and why. Never reclassify a failure to look greener.
2. **Never guess.** Numbers, live values, IDs and versions are measured, queried, or marked unverified. "Implemented" is not "verified in production".
3. **Fail explicitly and closed.** No silent fallbacks, no swallowed errors, bounded waits and caches, deny on unknown. Misconfiguration crashes at boot.
4. **Names over comments.** No code comments or docstrings unless asked; explanations go in the PR. Exceptions: a one-line note for a constraint code cannot express, JSDoc on a published SDK, and the incident behind a CI step.
5. **Types document, runtime enforces.** Strict typing, no escape hatches (`any`, casts, ignores), no enums (string unions), no inline object types in signatures, one shared contracts package. Validate at every boundary. Never claim a type replaces a runtime check.
6. **Design before markup.** Visual changes start as a standalone HTML mock and wait for approval.
7. **Secrets are read, never shown.** Confirm presence in words. One secret store. Env changes move code, examples, manifests and CI together.
8. **Small, honest history.** Conventional commits, no emojis or tool footers, PRs with Summary and Test plan. Stage only your own files. Commit, push or open non-draft PRs only when asked.
9. **Legacy is read-only.** Build beside it; follow current rules only in what you touch.
10. **Contracts move together.** A shared-contract change updates every consumer in the same change, or records the gap as debt.
11. **Outside writes need approval**: repos, trackers, chat, email, production data, deploys.
12. **Plain prose.** No emojis, no em dashes, short declarative sentences (use the `writing` skill).
13. **Leave a trail.** Specs and plans for larger work, dated decision records that are superseded rather than rewritten, debt entries for unfinished consumers, and a handoff note at the end of long sessions.
14. **Ask when unclear.** One or two short questions beat a wrong file.
15. **Isolate risk.** Migrations and parallel work happen in a separate worktree with their own ports and env.
16. **Choose boring, proven, and already-running.** Prefer what the system already operates over adding infrastructure. Every new dependency or service must earn its place.

## Prototype mode and product mode

Joel builds many throwaway prototypes, and they do not follow the full rules. Ask which mode a project is in when it is not obvious, and record the answer in its agent file.

- **Prototype** (validating an idea, a single deployable, no paying users): tests only on the risky pure logic (scoring, money, parsing), typecheck as the gate, deploy from a laptop, one deployable, envelopes and provider SDKs used directly are fine.
- **Holds in both modes:** secrets never in the repo or in output, input validated at trust boundaries, tenancy scoped in data access, webhooks signature-checked, fail closed on auth, one schema source (no unused schema files beside hand-written SQL).
- **Moving to product** (first paying user, second developer, or data you cannot lose): add CI as the gate, config parsed at boot, typed outcomes, reconcilers, and the rest of these skills. Do it as an explicit step, not gradually.

## Default toolbox

When a project has no precedent, these are the choices, not the point. The patterns in the other skills matter more than the tools.

TypeScript first, Rust for systems work, Kotlin Multiplatform for mobile. pnpm + Turborepo monorepo, Biome, Vitest. React with React Router on Cloudflare Workers for web. Hono for APIs. Postgres with Drizzle. Clerk for identity. Tailwind and shadcn/ui. AWS via Terraform for backends that need it; a small product picks one platform for web and API rather than splitting across two clouds. GitHub Actions. 1Password for secrets. AI SDK through AI Gateway for LLMs.

Retired for new product work: PHP, MongoDB, Express, Redux, CRA, Vue, Go, Flutter for new apps, ESLint/Prettier, Jest. A learning project or a collaborator's existing stack is the exception, and the repo's stack wins there.

## How much to trust these skills

The patterns come from Joel's repos from 2019 to 2026 and from rules he wrote down. Much of the 2025-26 code was written by agents under his instruction files, so a pattern describes what he accepted, not always what he chose by hand. Rules marked *(inferred)* are generalisations with thin evidence. Follow them, but say so when one decides a design, so Joel can confirm or correct it.

## Naming

Kebab-case files and folders; PascalCase components; verb-first camelCase functions; constants in SCREAMING_SNAKE with the unit in the name; named exports (default only where a framework requires it); role suffixes in layered code (`.controller`, `.service`, `.repository`, `.schema`, `.types`, `.job`, `.adapter`); lookup tables over conditional chains.

## Writing agent instruction files for his repos

Short, dated rules with the reason attached. A root `AGENTS.md`, with `CLAUDE.md` pointing at it. Nested files win on specifics. Document known-red baselines so agents gate on the delta. Write scoped exceptions down with the date decided. State the module dependency direction. No personas, no emoji headings, no credentials.
