---
name: investor-pitch
description: Use when preparing investor outreach, pitch decks, cold emails to VCs/angels, fundraising strategy, or any pre-seed/seed stage pitch materials for Sekuire. Also use when the user mentions "pitch deck," "investor email," "fundraise," "pre-seed," "seed round," "VC outreach," "angel investor," "raise capital," "investor meeting," or "pitch to investors."
---

# Investor Pitch - Sekuire

You are an expert at pre-seed/seed fundraising strategy. Your goal is to help prepare pitch materials, investor outreach, and fundraising strategy specifically for Sekuire.

## Before Starting

**Check for product marketing context first:**
If `.agents/product-marketing-context.md` exists, read it before asking questions.

Understand the situation (ask if not provided):

1. **Which investor(s)?** - Name, fund, thesis, portfolio, stage preference
2. **What format?** - Pitch deck, cold email, one-pager, verbal pitch, follow-up
3. **What stage are we at?** - First contact, warm intro, follow-up, post-meeting
4. **Any specific angles?** - Compliance focus, developer tool angle, open-source play, agent economy thesis

---

## Sekuire - Core Pitch Context

### The Problem

Autonomous AI agents are becoming economically significant actors - they execute contracts, handle payments, and control sensitive data. But there is no trust infrastructure:

- **No identity layer** - Any script can claim to be a trusted agent. Unlike humans (legal liability) or traditional software (code signing), agents are anonymous.
- **No governance** - Agents can silently violate security constraints. No way to enforce what an agent is allowed to do before it runs.
- **No audit trail** - No proof of what actually happened. Compliance teams cannot verify agent behavior.
- **No mutual trust** - Agents cannot securely verify each other when delegating work.

This is the same gap that existed before SSL/TLS for web traffic or before OAuth for identity.

### The Solution

Sekuire is the identity and governance layer for autonomous AI agents. Think "SSL for AI Agents" or "Okta for Agents."

Three pillars:

1. **Identity** - Deterministic, cryptographic agent IDs based on code + prompt (BLAKE3 hash). Same config always produces the same ID. Content-addressable and reproducible.
2. **Policy** - Local-first runtime enforcement. Network allowlists, filesystem permissions, tool whitelisting, rate limits, compliance metadata. Evaluated client-side with zero dependencies on Sekuire servers.
3. **Audit** - Immutable, Ed25519-signed event logs. Every action an agent takes is recorded with tamper-evident cryptographic proof.

Plus: mutual authentication protocol for agent-to-agent trust, a public/private agent registry, and trust scoring.

### Why Now

- LLM capabilities crossed the autonomy threshold in 2024-2025
- Enterprise agent deployments are exploding (customer support, internal automation, workflow orchestration)
- Regulatory pressure mounting (EU AI Act, SOC2/HIPAA requirements for AI systems)
- No established standard exists - the window to define the governance protocol is open now

### Technical Differentiation / Moat

1. **Open Agent Governance Specification (OAGS)** - Apache 2.0 open standard. Creates a standards moat similar to OAuth. Sekuire owns the reference implementations and the platform that extends it.
2. **Content-addressable identity** - Deterministic identity from agent code + prompt. Unique to Sekuire. Enables reproducible verification.
3. **Local-first architecture** - Policy enforcement runs in the SDK, not on Sekuire servers. Works offline, in air-gapped environments. Zero vendor lock-in for core functionality.
4. **Multi-provider LLM support** - Works with OpenAI, Anthropic, Google, Ollama. Not tied to any single provider.
5. **Multi-language SDKs from day one** - Rust, TypeScript, Python. Most competitors pick one language.
6. **Trust protocol** - Proprietary agent-to-agent handshake (similar to mTLS but for agents). Hard to displace once adopted.

### Business Model

Freemium SaaS with open-source foundation:

| Tier | What | Revenue Driver |
|------|------|----------------|
| Free / OSS | SDKs, CLI, local policy enforcement, OAGS spec | Adoption, ecosystem growth |
| Pro | Cloud audit logs, agent registry, trust scores, workspace policies, fleet management | Per-agent, per-event pricing |
| Enterprise | Multi-org, private registries, compliance templates (HIPAA, PCI-DSS, SOC2, GDPR), SLA | Contract-based |

### Market

- **Primary:** Enterprise AI ops teams deploying autonomous agents who need governance and compliance
- **Secondary:** SaaS/agent platform companies building agent marketplaces
- **Tertiary:** Systems integrators building multi-agent workflows
- **Long-term:** LLM providers themselves (OpenAI, Anthropic, Google)

TAM: The AI agent market. Every deployed autonomous agent needs identity and governance.

### Traction

- CLI published on crates.io (`sekuire-cli` v0.2.10)
- TypeScript SDK on npm (`@sekuire/sdk` v0.2.0)
- Python SDK on PyPI (`sekuire-sdk` v0.1.0)
- Rust SDK on crates.io (`sekuire-sdk` v0.1.0)
- OAGS specification v0.1.1 with 4 conformance levels
- Reference agents: Slack + Google Workspace demonstrating A2A protocol
- One-liner installer: `curl -fsSL https://install.sekuire.ai | sh`

### Competitive Positioning

Not competing with LLM providers, agent frameworks (LangChain, CrewAI), or vector DBs. Orthogonal to all of them.

Actual alternatives:
- Enterprises building custom governance (expensive, non-standard)
- General identity systems (Okta, Auth0) that do not understand agents
- Future offerings from cloud providers (AWS, Azure, GCP) - but Sekuire moves first with the open standard

### Analogies That Work

- "SSL certificates, but for AI agents"
- "Okta for the agent economy"
- "What OAuth did for web identity, OAGS does for agent governance"
- "The trust layer between autonomous agents and the businesses that deploy them"

---

## Pitch Deck Structure

Optimal pre-seed deck: 10-12 slides. Two versions - a visual-heavy "presentation deck" for live pitches and a detailed "reader deck" for async review.

### Slide Order

1. **Cover** - Sekuire logo, "The Identity and Governance Layer for AI Agents," contact info
2. **Problem** - The trust gap in the agent economy. Use concrete scenarios: "An agent with access to your CRM just sent 10,000 emails. Who authorized it? What were its constraints? Where is the audit trail?"
3. **Solution** - Three pillars: Identity, Policy, Audit. Show the developer experience (sekuire.yml manifest, SDK integration code).
4. **Why Now** - LLM autonomy threshold crossed, enterprise adoption curve, regulatory pressure, no existing standard
5. **Market** - TAM/SAM/SOM. Every autonomous agent deployment needs governance. Enterprise AI spending projections.
6. **Product Demo** - Screenshots or demo of: CLI init, policy enforcement in action, audit log, dashboard
7. **Business Model** - Freemium tiers table. Land with free SDK, expand to platform.
8. **Traction** - Published SDKs, registry stats, OAGS adoption, any enterprise pilots or LOIs
9. **Competition** - Positioning matrix. Highlight: open standard ownership, multi-language, local-first
10. **Team** - Founder backgrounds, relevant experience, why this team for this problem
11. **Roadmap** - 6-12 month milestones. What the funding enables specifically.
12. **The Ask** - Funding target, use of funds, expected runway

### Design Principles
- 2-3 colors max. Heavy use of white space.
- Icons and screenshots over text walls
- One key message per slide
- Do not use generic templates

---

## Cold Email to Investors

### Pre-Email Research (non-negotiable)

- Verify the investor funds your stage, geography, and sector (developer tools / infrastructure / AI / security)
- Identify complementary portfolio companies (agent platforms, developer tools, security companies)
- Find one specific person per fund - target junior investors/associates first (they actively seek deal flow)
- Check for recent blog posts, tweets, or talks about AI agents, governance, or trust

### Subject Line

Under 60 characters. Include a traction signal + sector.

Examples:
- "Agent governance infra | SDKs live on npm + PyPI + crates.io"
- "Building SSL for AI agents - opening pre-seed"
- "OAGS: Open standard for agent identity | pre-seed"
- "AI agent trust layer | 4 SDKs shipped, raising pre-seed"

Avoid: "opportunity," "solution," "million," "billion," "risk-free," "revolutionary"

### Email Structure (75-125 words)

```
[Personalized opener - reference their specific work, portfolio, or thesis]

We're building the identity and governance layer for autonomous AI agents -
deterministic cryptographic identity, local-first policy enforcement, and
signed audit trails. Think SSL certificates for AI agents.

We've shipped SDKs in Rust, TypeScript, and Python (live on crates.io, npm,
PyPI), published the Open Agent Governance Specification (Apache 2.0), and
built reference agents demonstrating agent-to-agent trust.

[Why this investor specifically - thesis fit, portfolio synergy]

Would love 15 minutes to walk through how we're approaching the trust layer
for the agent economy. Deck attached.

[Name]
```

### Follow-Up Cadence

- **Day 0:** Initial email with deck link
- **Day 3-4:** Follow-up 1 - add a new data point (download stats, new integration, enterprise interest)
- **Day 7-8:** Follow-up 2 - different angle (e.g., link to OAGS spec, demo video, relevant news about agent security incidents)
- **Day 10-12:** Final follow-up - brief, direct

Each follow-up as a reply to the original thread. Add fresh information every time.

### Best Timing
- Tuesday or Thursday
- 4-9 AM investor's local time
- Avoid Monday morning, Friday afternoon, holidays

---

## Verbal Pitch Frameworks

### 30-Second Elevator Pitch

"Sekuire is the identity and governance layer for autonomous AI agents. In a world where agents execute contracts and control company data, you need to know who you're talking to, verify what they'll do, and prove what happened. We provide cryptographic identity, local-first policy enforcement, and signed audit trails - all built on an open standard we created called OAGS. We've shipped SDKs in three languages and they're live on npm, PyPI, and crates.io."

### 2-Minute Pitch

Add to the above:
- The "why now" (LLM autonomy threshold, regulatory pressure)
- Business model (free SDKs drive adoption, platform monetizes governance)
- Traction specifics
- The ask

### Handling Common Questions

**"Why can't enterprises build this themselves?"**
They can - and some will try. But governance requires a standard, not just an implementation. Custom solutions do not interoperate. OAGS is to agent governance what OAuth was to web identity: the open standard that everyone converges on. We are building both the standard and the best platform on top of it.

**"What if OpenAI/Anthropic/Google builds this in?"**
LLM providers are incentivized to be agent-agnostic, not to build governance for competitors' agents. Sekuire works across all providers. If a provider does build governance, it will be locked to their ecosystem. OAGS is vendor-neutral by design.

**"Where is the revenue?"**
Free SDK creates the distribution. Enterprise governance creates the revenue. Every company deploying agents needs audit logs for compliance, policy templates for security, and fleet management for operations. The conversion path is: developer adopts free SDK, team needs audit logs, company needs compliance dashboard.

**"How do you get adoption of the standard?"**
Ship great SDKs that developers want to use regardless of the standard. Make OAGS the easiest path to agent governance. The standard follows the tooling, not the other way around. TCP/IP did not win through committee - it won because the implementations were good.

**"What is your competitive moat?"**
Standards ownership (OAGS), content-addressable identity (unique and hard to replicate), multi-language SDK ecosystem, and first-mover trust protocol. Once agents use Sekuire handshake for mutual auth, switching costs are high.

**"How big is this market?"**
Every autonomous agent deployment needs identity and governance. Today: thousands of enterprise agent deployments. In 2-3 years: millions. We are building infrastructure, not an application - the TAM is the agent economy itself.

---

## What Pre-Seed Investors Evaluate

At pre-seed, the hierarchy is:

1. **Team** (highest weight) - Founder-market fit, execution ability, resilience
2. **Market timing** - Is this the right moment for this category?
3. **Problem clarity** - Do investors feel the pain?
4. **Validation** - Any signal of real demand (users, LOIs, downloads, community)
5. **Business model** - Clear monetization path
6. **Legal hygiene** - Clean cap table, proper incorporation, vesting schedules

### What Kills Pre-Seed Pitches

- Unclear problem statement
- Vague market sizing without TAM/SAM/SOM
- Asking for too little (ask for what you need, not what you think you can get)
- No competition slide (signals naivety)
- Weak team narrative
- Generic deck template
- Scattershot investor targeting

---

## Investor Targeting Strategy

### Ideal Investor Profile for Sekuire

- Invests in: developer tools, infrastructure, security, AI/ML
- Stage: pre-seed or seed
- Thesis fit: open-source commercial, protocol/standards plays, picks-and-shovels for AI
- Portfolio synergy: agent platforms, LLM tooling, DevSecOps

### Pipeline Management

- Target 50-100 first meetings within 2-3 weeks
- Expect ~30:1 ratio of first meetings to term sheets
- Full cycle: 90-120 days
- Track in CRM: investor name, fund, stage, thesis, contact, status, last touch, notes

### Warm Intro vs Cold Outreach

Warm intros convert better but cold outreach works at pre-seed - especially for infrastructure companies where the product speaks for itself. Properly executed cold emails can achieve ~80% response rates.

For warm intros: leverage existing investors, advisors, founder networks. Always ask "who specifically should I talk to at [fund]?"

---

## Tactical Notes

- **Two deck versions:** Presentation (visual, minimal text) for live pitches. Reader (detailed) for async review.
- **Always include a demo or screenshots.** The developer experience (CLI, SDK, dashboard) is a selling point.
- **Lead with the problem, not the technology.** Investors buy the problem-solution fit, not the cryptography.
- **Use the SSL/OAuth analogies early.** They instantly frame the category.
- **Prepare a one-pager** for quick sharing after meetings or in email threads.
- **Record a 2-minute Loom** for investors who prefer async. Walk through the demo.
- **Ask for feedback, not money** when reaching out cold. "Would love your take on our approach" reduces friction.
- **Create FOMO carefully** - mention other funds in discussions during follow-ups.
- **15-20% dilution is standard** at pre-seed. Calculate your ask based on 24 months of runway.
