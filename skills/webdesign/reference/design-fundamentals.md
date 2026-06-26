# Design Fundamentals

Mathematical principles, composition rules, and core design laws that inform every layout decision.

## Golden Ratio (1:1.618)

**Applications to web layout:**
- Two-column layout: 618px + 382px in a 1000px container
- Apply phi scaling (multiply/divide by 1.618) to font sizes, margins, and spacing for natural hierarchy
- Golden rectangle: width 1000px implies height 618px
- Place CTAs and focal points at the golden spiral's convergence point
- Combine with rule of thirds: focal points where golden ratio lines intersect thirds gridlines

**When NOT to use:** When it threatens usability or readability. Accessibility always trumps proportions.

---

## Fitts' Law

**Formula:** MT = A + B * log2(2D/W) - time to target increases with distance (D), decreases with width (W).

**Actionable rules:**
- Primary CTAs: large and close to where cursor/thumb already is
- "Prime pixel": center of screen or near last-clicked element - place primary actions here
- Screen corners ("magic pixels"): hardest to reach - only non-critical elements
- Mobile thumb zone: primary buttons at center-bottom, not top corners
- Use padding to increase hit area without bloating visual size
- Submit buttons should be larger than surrounding form elements
- Group related actions to minimize movement, but space enough to prevent misclicks
- "Save" and "Cancel": close enough to compare, far enough to avoid errors

---

## Hick's Law

Decision time increases with the number and complexity of choices. Streamline options wherever possible. Fewer choices = faster decisions = better UX.

---

## 13 Graphic Design Principles

1. **Alignment**: Align elements to a common edge, center, or baseline. Use layout grids. Left-align text by default (LTR).
2. **Contrast**: Eye gravitates to higher contrast. Use size, color, weight to emphasize. Don't over-apply.
3. **Balance**: Symmetrical = harmony. Asymmetrical = dynamic energy. Use white space to prevent clutter.
4. **Hierarchy**: Most important information at top. Use color, bold, and size for emphasis.
5. **Color**: Use color theory (complementary, analogous). Consider color vision deficiencies.
6. **White space**: Breathing room between elements. More space = focus. Consistent padding/spacing.
7. **Proportion**: Size relative to importance. Larger = more important.
8. **Repetition**: Reuse colors, shapes, fonts consistently. Builds brand identity and cohesion.
9. **Rhythm**: Regular (consistent spacing), progressive (gradual change), flowing (organic curves), random.
10. **Movement**: Z-pattern for minimal text pages, F-pattern for text-heavy, layer cake for scanning headings.
11. **Emphasis**: Highlight focal points using contrast, color, white space, or proportion.
12. **Proximity**: Close elements = related. Use spacing to separate unrelated groups.
13. **Unity**: All elements feel cohesive - consistent colors, fonts, shapes, spacing throughout.

---

## Visual Hierarchy

Seven principles for directing attention:

1. **Alignment** - aligned objects read as related
2. **Color** - use luminance and brilliance, not just hue
3. **Contrast** - juxtapose warm/cool or complementary colors
4. **Proximity** - group related items together
5. **Size** - larger elements draw more attention
6. **Texture** - visual highlights without relying on color alone
7. **Time** - animation and transitions as hierarchy tools

**Key rules:**
- If everything looks the same, nothing stands out
- Progressive disclosure: break information into digestible chunks across screens
- Context matters: consider the user's physical situation (rushed? one-handed? distanced?)
- Design should reward both glancing and close reading

---

## Interaction Design

**Five dimensions:**
1. **Words** - clear, concise, action-oriented labels. "Submit" not "Click here". Error messages explain issue + next steps.
2. **Visual representations** - recognizable icons (trash = delete, arrow = download). Signal hierarchy through visuals.
3. **Physical objects/space** - design for device context (tap vs click, thumb reach on mobile)
4. **Time** - animations confirm actions, transitions smooth navigation, progress indicators set expectations
5. **Behavior** - actions have clear, predictable results. Users can recover from errors easily.

**Gestalt principles**: humans naturally group related visuals into meaningful patterns. Use proximity, similarity, closure, and continuity to create clear layouts.

---

## Simplicity and Complexity Reduction

- **Simplicity is not absence of complexity** - it is revealing complex information in measured, digestible pieces
- Strip away the inconsequential. Remove everything that doesn't serve the user's immediate task
- Hide non-crucial information behind menus or reveal contextually (progressive disclosure)
- Use familiar paradigms (hamburger menus, standard nav patterns). Don't reinvent conventions
- Increase white space between elements to improve focus and tappability
- **3-5 tap rule**: any primary action should be completable within 3-5 interactions
- Balance simplification vs. oversimplification: reducing noise is good, hiding essential information is bad
- Break complex flows into multiple screens rather than cramming into one
- Replace jargon with plain language

---

## Design Constraints

Constraints are forcing functions that improve design decisions:
- Device size, audience, and brand guidelines define the design space
- Mobile constraints: bigger text, shorter lines, smaller file sizes, slow networks
- Accessibility is a non-negotiable constraint: contrast, RTL support, color vision, dyslexia
- Platform conventions (Material Design, Apple HIG) increase usability through familiarity
- Understanding development constraints changes how you design layouts
- Self-imposed constraints (time-boxing, scoping) accelerate solutions

---

## Lateral Thinking for Design

**SCAMPER method** for iterating on any design:
- **S**ubstitute - what element could be replaced?
- **C**ombine - what elements could merge?
- **A**dapt - what could be borrowed from another domain?
- **M**odify - what could be enlarged, reduced, or changed?
- **P**ut to another use - could this element serve a different purpose?
- **E**liminate - what could be removed entirely?
- **R**everse - what happens if the order/flow is reversed?

**Reverse brainstorming**: list everything that could go wrong, then design to prevent those failures.

---

## Designing for Machines (MX)

The "Parallel Web": sites built for both humans and AI agents that read, interpret, and summarize them.

**Structural implications:**
- Semantic HTML hierarchy matters more than ever - AI agents parse heading structure, landmark roles, and content grouping
- Content architecture should be meaningful when stripped of all visual styling
- Metadata, structured data (JSON-LD), and clear document outlines improve machine readability
- This does not conflict with human-centered design - semantic structure benefits both audiences

**Practical rules:**
- Use proper heading hierarchy (h1 > h2 > h3, never skip levels)
- Descriptive link text ("Read the pricing guide" not "Click here")
- Meaningful image alt text that describes content, not decoration
- Structured data markup for products, articles, events, organizations
- Content that makes sense when read linearly, not just visually
