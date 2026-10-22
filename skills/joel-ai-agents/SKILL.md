---
name: joel-ai-agents
description: Joel's AI and agent patterns: choosing the loop, model tiering, tools, MCP, sandboxing, prompts, evals.
disable-model-invocation: true
---

# AI and agent patterns

Read `joel-architecture` first: an agent is another ingress over the same domain. For current SDK details, defer to `vercel:ai-sdk`, `vercel:eve`, `vercel:workflow`, `vercel:vercel-sandbox` and `vercel:ai-gateway`.

## Choose the loop by need

| Need | Shape |
|---|---|
| A long-lived product or company agent with tools, subagents, connections and approvals | An agent framework that owns the loop (eve) |
| A bounded multi-step task inside a service | An SDK tool loop with a step cap. If it ends without an answer, run one final call that writes the answer from the last tool result |
| Full control over providers, streaming or broadcast to many users | A hand-written loop behind your own provider interface, with a typed stop reason and a round limit |
| Long pipelines with retries, human gates and waiting on callbacks | A durable workflow engine whose steps are idempotent |
| Classification, extraction, scoring | One structured-output call against a schema, temperature 0 |
| High-volume cheap work | The cheapest capable model on edge inference |

Product loops always have a cap. Coding agents may run uncapped, but they checkpoint state after every step and prompt the model to verify its changes.

## Models

- Route through a gateway with `provider/model` ids kept in one constants module. Look ids up, never guess them.
- **Tier by job:** a fast model for routing, acknowledgements and yes/no gates; a mid model for analysis and writing; the strongest model only for creative or hardest reasoning. Send a fast acknowledgement while the slow model works.
- **Every AI feature works without AI.** With no key, it falls back to a deterministic path (keyword scoring, rules) or reports itself disabled. The product boots without model credentials.
- Validate model output against a schema like any other untrusted input.

**The model never emits identifiers.** Number the items in the prompt and have the model return indices; code maps them back to ids. Keep the sample order fixed between building the prompt and resolving. Deterministic recovery passes (keyword, then embedding match) may add items the model missed, never remove them.

**The model extracts, code decides.** For ranking or matching, the model classifies and extracts features; a deterministic filter and a weighted scorer rank, and return a per-signal breakdown. The scorer is the unit-tested part and the ranking stays explainable.

## Tools

- One tool, one job, one file. Names are snake_case `verb_noun`.
- Input schemas describe every field.
- Descriptions are operational: what the tool changes, what it costs, whether it is safe to retry, and when to prefer another tool.
- Results are compact and shaped for the model. Errors come back as data the model can act on, never as a crash out of the loop.
- Read tools and write tools are separate. Write tools need approval.

## Security is code, not prompt

- Allowlists for models, tools and target resources.
- Permission checks inside the tool against the real caller, and read-only guards on query tools.
- Human approval for every write to an outside system by agents we operate. Tools we expose to other people's agents rely instead on scoped keys, spend and rate caps, and the audit log.
- Credentials fetched at call time from a secret store or connection broker, never placed in prompts or context.
- Guards that reject model edits to tests or to files the model was not shown.
- Sensitive data (finance, personal records) gated by identity in code.
- Assume the prompt will be ignored. Anything that must hold is enforced in code.

## MCP

- MCP is another ingress: tools call the same domain functions or in-process HTTP handlers as the public API, so behaviour, limits and billing cannot drift.
- **Stateless and scoped:** build a server per request from the caller's credentials. Register only the tools that caller may use, and apply the API's rate limits and credits.
- Provide a remote HTTP transport for hosted use and a thin local stdio client of the public API for desktop tools.
- Shared result and error helpers return sanitized failures.
- Test the tool list per permission set, plus one success and one rejection.

## Sandboxing

Model-generated or untrusted code runs in an isolated sandbox with no network by default, a timeout on every command, and teardown in a finally block. In durable pipelines, only the sandbox id crosses step boundaries, and each step reattaches.

## Prompts, context and skills

- Prompts are Markdown files versioned beside the agent. Short classifier prompts may be constants.
- Number the items you give the model when it must refer back to them, and treat that numbering as an invariant.
- Keep context bounded: summarise or trim history deliberately instead of letting it grow.
- Skills are shared files usable by both the agent runtime and coding agents.
- To test a skill, run the task without it, write the skill, run it again, and record both runs.
- Developer products ship agent-facing documentation: an llms.txt and an integration skill showing wrong and right patterns side by side.

## Evals and evidence

Anything that ships has a small fixed eval set with expected outcomes, policy tests for permission logic, and a comparison run when choosing or changing models. Report measured results. Never claim quality you did not run.

## Observability

Log model, tokens, tools called, stop reason and latency per run. Trace loops where the product has tracing. Stream progress to users through the workflow or session channel, not polling.
