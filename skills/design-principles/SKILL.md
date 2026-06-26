---
name: design-principles
description: Use when doing any visual or UI design work - building, styling, or reviewing interfaces, components, pages, or layouts in any framework. Holds the house design rules that apply on top of the task-specific design skills (frontend-design, webdesign, polish, critique, animate, and the rest). Start here for what we always do and what we never do.
user-invokable: true
---

# Design principles

## Overview

Our standing design rules. They apply to every interface we build or review, on top of whatever task-specific design skill is in use (frontend-design, webdesign, animate, polish, critique, audit, distill, and the rest). When a task skill and a rule here disagree, the rule here wins.

Add new house rules to this file. Keep one place to look.

## No border framing

Do not box content in borders to separate it. Bordered cards, outlined panels, framed sidebars, and boxed sections are out.

Separate content with space, background, and hierarchy instead:

- **Whitespace.** Padding and gaps group and divide. Two well-spaced blocks read as separate with no line between them.
- **Background shift.** A subtle tint or a step in elevation sets a region apart. A card is a faint background change, not an outline.
- **Shadow.** A soft shadow lifts a surface off the page when it needs to float: menus, dialogs, raised cards.
- **Hierarchy.** Size, weight, and position tell the reader what belongs together. A clear heading does the job a border reaches for.

**Scope: container framing only.** Functional borders stay:

- Input, textarea, and select outlines, and focus rings.
- Table and data-grid lines where alignment needs them.
- A single hairline divider when space alone leaves the split ambiguous.

This kills decorative framing of containers. It does not ban every one-pixel line.

```
Before: <div class="rounded-lg border border-gray-200 p-6"> ... </div>
After:  <div class="rounded-lg bg-muted/40 p-6"> ... </div>

A card is a background, not an outline. If it still needs to lift off the
page, add a soft shadow, not a border.
```

## Common mistakes

- Reaching for a border because a section feels unanchored. Add space or a background step first.
- Stacking a border, a shadow, and a background tint on the same card. Pick one separator, usually the background.
- Dropping the border from one card but leaving it on the next. Be consistent across the whole surface.
