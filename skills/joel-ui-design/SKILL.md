---
name: joel-ui-design
description: Joel's visual design principles and the HTML-mock-first process - flat chrome, one radius, structure without card framing, status as dot plus word, meaning-carrying colour, tokens, one typeface plus mono, plain labels, skeleton loading, responsive by default. Use before any UI, layout, styling, component, page, dashboard, email, or mobile screen work for Joel, and when reviewing a design or mock.
---

# UI design principles

These override generic design skills and component-library defaults. Where a generic skill and a rule here disagree, the rule here wins.

## Process: mock first

1. Any change to layout, spacing, hierarchy, a new component or a restyle starts as a **standalone HTML mock**: one file, real copy, the product's tokens and font.
2. Show the mock and wait for explicit approval. Building the mock is not approval to implement.
3. Implement against the approved mock. Then compare the real page with the mock at phone and desktop widths before claiming parity.

Pure logic needs no mock. If you are unsure whether a change counts as design, treat it as design.

## Principles

- **Flat chrome.** Use single-colour surfaces and controls. No gradients and no coloured glows. Neutral shadows appear only on floating layers. Gradients are for data or a logo.
- **One radius.** 8px for every control and surface, from a single token. No pills. Circles only for avatars, dots, toggles and radios.
- **Structure without boxes.** Group with whitespace, type hierarchy and alignment, not bordered or rounded containers. No card grids, stat cards or boxed panels. A faint tint marks a genuinely separate surface. A project opts out only in writing.
- **Separators are a last resort.** Spacing first. Use one hairline only when spacing leaves the split ambiguous.
- **No coloured edge stripes** on items. Type and status go inside the element as a dot, chip or icon.
- **Status is a dot plus a word** on a soft tint of the status colour. Never rely on colour alone. Only live states pulse, and only when motion is allowed.
- **Colour carries meaning:** status, lane, action, direction of money. One accent with soft and strong pairs, plus status pairs for ok, warn, fail and running.
- **Tokens, never literals.** Every colour, radius and font is a token. Fix a wrong token at its source.
- **One typeface plus one mono.** The mono is for status, IDs, timestamps and metadata. Weight and tracking carry hierarchy. Numbers use tabular figures.
- **Plain labels.** Eyebrows and section tags carry no ornamental dashes, rules or ticks.
- **Minimal, confident, typography-led.** No "editorial" styling, and no hero headings or taglines inside product UI.
- **Honest states.** Skeletons for loading content. Busy buttons announce it. Disabled controls switch to a muted surface instead of fading to half opacity.
- **Responsive by default.** Every screen works at phone width.
- **Copy** uses no emojis and no em dashes.
- **Theme is a product decision.** Light, dark or both is decided once and written down. No theme toggle by default.

## Implementation guidance

- Use the component library's primitives and never hand-roll one it already has. When adding a component, strip default card wrappers, pill badges and fully rounded buttons.
- Style variants with variant maps and lookup tables, not conditional class chains.
- A section without a card is a small uppercase muted heading with content beneath, separated from the next section by space.

## Review checklist

Before showing a mock or a finished page:

- One radius everywhere.
- No boxes.
- No edge stripes.
- No gradients or glows.
- Every colour is a token.
- Status has a word.
- One family plus mono.
- Plain labels.
- Phone width works.
- Clean copy.
- Matches the approved mock.
