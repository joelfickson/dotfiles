---
name: writing
description: Use when writing or editing prose for humans - technical documentation and user-facing guides, READMEs, API references, blog posts, essays, or general team messages (Slack, email, announcements, PR and commit descriptions). Also use when prose reads like generic AI output (em-dashes, emojis, filler, hedging, recap endings), when it is wordy or jargon-heavy, or when it needs to be made simpler, clearer, and grammatically clean. Not for ad copy, SEO pages, cold email, or marketing funnels - use the marketing skills for those.
user-invokable: true
args:
  - name: target
    description: What to write or the file/draft to edit (optional)
    required: false
---

# Writing

## Overview

Write like a sharp human who respects the reader's time. Every sentence earns its place. Concrete beats abstract. Plain beats clever. Use the simplest word that carries the meaning: if a smart twelve-year-old would trip on a word, change it.

Three modes, one voice. The voice never changes. The register and structure shift by mode.

## When to use

- **Technical** - READMEs, docs, API references, runbooks, design notes
- **Blog** - posts, essays, and announcements that explain or persuade a wide audience
- **General** - Slack and email to teammates, PR descriptions, commit bodies, status updates

When NOT to use: ad creative, landing-page SEO copy, cold outreach, paywalls. Those have dedicated skills (copywriting, ad-creative, cold-email, page-cro).

## The voice (every mode)

Non-negotiable:

- **No emojis.** Anywhere.
- **No em-dashes.** Use a hyphen, a colon, or two sentences.
- **Short declarative sentences.** One idea each.
- **Concrete nouns, strong verbs.** Cut adjectives that carry no information.
- **Active voice.** Name the actor.
- **Say it once.** Never restate the same point in new words.
- **Plain words.** Use the shortest word that means what you mean. No jargon the reader does not already use.
- **Tight.** Cut any word the sentence does not need. If you can delete it and the meaning survives, delete it.
- **Grammatically correct.** Proofread. Clean punctuation, subject-verb agreement, parallel lists.

## Strip these AI tells

| Tell | Fix |
|------|-----|
| Em-dash break in a sentence | hyphen, colon, or split into two sentences |
| Emojis or emoji bullets | plain text and real bullets |
| Triads for rhythm ("faster, cleaner, simpler") | keep the one that is true, or list the real items |
| "It's worth noting", "Notably", "Importantly" | just say the thing |
| Scene-setting openers ("In today's fast-paced world") | open on the actual point |
| "not just X, but Y" / "not because X, but because Y" | state Y directly |
| Hedging: "might", "arguably", "in many cases" | commit, or give the exact condition |
| "delve", "leverage", "robust", "seamless", "landscape", "tapestry" | use the plain word |
| Dramatic one-line fragment for effect | at most one per piece, and only if earned |
| Closing sentence that recaps what you just said | delete it |

## Plain words

Reach for the simple word. Swap the formal one out.

| Don't write | Write |
|-------------|-------|
| utilize, leverage | use |
| in order to | to |
| prior to / subsequent to | before / after |
| in the event that | if |
| at this point in time | now |
| a large number of | many |
| facilitate | help |
| commence / terminate | start / stop |
| locate | find |
| further assistance | more help |
| in a secure location | somewhere safe |
| functionality | features |
| is able to / has the ability to | can |
| approximately | about |
| sufficient | enough |
| obtain | get |

Keep a term only when the reader already uses it. A backend engineer knows "idempotent"; a Hearth customer does not. Match the word to the reader, not to the topic.

## Cut the wordiness

Read each sentence and delete what it does not need. The meaning should survive.

| Wordy | Tight |
|-------|-------|
| make a decision | decide |
| provide assistance to | help |
| perform an analysis of | analyze |
| is responsible for handling | handles |
| due to the fact that | because |
| there are three options that let you | three options let you |
| the file is read by vex (passive) | vex reads the file |
| each and every / first and foremost | pick one |
| follow the steps below to enable it | delete it: the steps are right there |

Patterns that bloat:

- **Nominalizations.** A verb hiding as a noun. "Make a decision" is "decide". "Provide a recommendation" is "recommend".
- **Passive voice.** Name who acts: "the migration is run by us" becomes "we run the migration".
- **Throat-clearing.** "Basically", "actually", "really", "very", "just" usually add nothing. Cut them.
- **Stating the obvious.** Do not tell the reader to read what is in front of them.

## Modes

### Technical and documentation

Goal: a reader who does not share your context completes a task or understands a system without you present. Covers READMEs, API references, runbooks, and user-facing guides and help articles.

- Write for someone who lacks your context. Assume no shared acronyms, tools, or history.
- Lead with the reader's goal, not a definition. They came to do a thing.
- Define a term the first time, or avoid it. Never both assume and explain.
- Show, do not describe. A real config, a real command, real output.
- One step, one action. Start each step with the verb: Click, Open, Enter.
- One canonical, annotated example beats three half-examples.
- Document the failure mode and the override, not only the happy path.
- Headings are signposts. A reader should find the answer by scanning.

```
vex reads vex.toml from the current directory, walking up the tree until it
finds one, then falls back to defaults. Override any value inline:

    vex build --set server.port=9090

Precedence: CLI flags > vex.toml > defaults.
```

### Blog

Goal: a busy reader keeps reading and leaves informed or convinced.

- Open on the concrete stakes. The first sentence carries a claim or a tension, not a warm-up.
- Tell it through what happened: numbers, decisions, costs.
- One idea per paragraph. Vary sentence length but keep the floor short.
- Earn every abstraction with a specific underneath it.
- End on what changed or what comes next. Do not recap.

```
For three years we shipped two codebases that did the same thing twice. A
feature meant two tickets, two bug trails, and a QA pass that never agreed
with itself. The teams drifted apart because the architecture made them.
```

### General (team messages)

Goal: the reader learns what happened, what it means for them, and what to do.

- Front-load the headline in the subject and first line. Assume it is read on a phone.
- Bullets for actions, action verb first.
- Give the deadline, the impact, and the fallback.
- Sign off plainly. A thanks is enough.

```
Subject: Staging DB down Saturday 9am-noon for migration

Staging is unavailable Saturday 9am-noon while we run the schema migration.

- Hold any merge that auto-deploys to staging during the window.
- Export test data you need by Friday EOD. Treat unsaved data as disposable.
- Blocked on testing? Use local, or ping me for a temporary instance.

Production is unaffected. I will post here when it is back.
```

## Self-edit pass

Read the draft once for each, in order:

1. Cut every sentence that does not change the reader's understanding or action.
2. Search for em-dashes and emojis. Remove all of them.
3. Replace each long or formal word with the plain one. Cut the wordiness.
4. Replace each abstract claim with the concrete fact underneath it.
5. Read it as the actual reader. Would they trip on a term or an assumption you skipped?
6. Proofread for grammar and punctuation. Read it out loud to catch what your eye skips.

## Common mistakes

- Leaving the warm-up paragraph in after writing the real intro.
- Three examples where one annotated example is clearer.
- Burying the action of a team message under context.
- Writing for yourself, not the reader: shipping the acronyms, context, and history only you have.
- Reaching for the formal word ("utilize", "facilitate") to sound professional. Simple reads as competent.
- Adopting a file's emoji headers because the surrounding doc uses them. Keep the voice. If a file must stay consistent with heavy existing emoji use, confirm before matching it.
