# Accessibility, Ethics, and Consistency

## Accessibility Requirements

**Non-negotiable rules:**
- Never rely on color alone to convey information (1 in 12 men have color vision deficiency)
- WCAG AA minimum contrast: 4.5:1 for normal text, 3:1 for large text (18px+ bold or 24px+ regular)
- Alt text on every meaningful image. Decorative images get empty alt=""
- All functionality must work with keyboard-only navigation
- Test with screen readers (VoiceOver, NVDA)
- Minimum touch target: 44x44px (Apple HIG). Some standards cite 48x48px
- Sufficient spacing between interactive elements to prevent accidental taps

**Visual accessibility:**
- Protanopia (red-green) is most common. Orange and green can appear identical
- Do not use red/green as sole status indicators. Add icons, labels, or patterns
- Provide sufficient contrast for all text AND interactive elements
- Support user font size preferences. Use relative units (rem, em), not fixed px for text
- Plan for text in multiple languages - translations can be significantly longer than English

**Readability:**
- Body text minimum 16px on screens
- Line length: 45-75 characters per line for comfortable reading
- Appropriate line height (1.5-1.6 for body text)
- Simple, well-spaced layouts improve readability for everyone

**Structural accessibility:**
- Semantic HTML: use proper heading hierarchy (h1 > h2 > h3, never skip levels)
- Landmark roles: nav, main, aside, footer
- Form labels associated with inputs
- Focus indicators visible and clear
- Skip-to-content links for keyboard users
- ARIA attributes only when semantic HTML is insufficient

---

## Design Ethics

**Core principles:**
- Judge design by real-world impact, not just aesthetics
- Users must control their data and understand how it is used
- Data collected for one purpose must not be repurposed without explicit consent
- Offer users controls to delete their data
- Avoid dark patterns: deceptive UI tricks that manipulate users into unintended actions

**Common dark patterns to avoid:**
- Hidden costs revealed at checkout
- Forced continuity (hard-to-cancel subscriptions)
- Misdirection (visual emphasis on the option that benefits the company, not the user)
- Confirm-shaming ("No thanks, I don't want to save money")
- Disguised ads that look like content or navigation
- Pre-checked consent boxes
- Roach motels (easy to get in, hard to get out)

---

## Design Consistency

**Visual consistency:**
- Limit typefaces to 2-3 across the entire product
- One primary color, one secondary, a few tones of each, plus neutrals
- Every screen should feel like the same product
- If a title is 100px from top on one screen, all similar titles match on other screens

**Behavioral consistency:**
- Same interaction patterns throughout: if swiping dismisses in one place, it dismisses everywhere
- Follow established platform conventions (Material Design, HIG)
- Don't reinvent established UI conventions without strong reason

**Tone consistency:**
- Writing tone matches product personality throughout
- A formal homepage should not lead to casual inner pages
- Reference voice-and-tone guides for the brand

**Intentional inconsistency:**
- Break consistency deliberately to create emphasis (e.g., indenting a pull quote)
- Limit emphasis techniques: if everything is bold, nothing is bold
- User needs trump rigid consistency

---

## Content-First Design

- Map content before opening a design tool. Write the words first.
- Design with real content (or close-to-final). Placeholder content causes layout mismatches.
- Plan for real content lengths - text may be longer than allotted space in mockups
- Write as you would speak: simple, clear, no jargon
- Less is more: examine every word, remove those that serve no purpose
- Read everything out loud before finalizing

---

## Mobile Design

**Touch and interaction:**
- Minimum touch target: 44x44px
- Spacing between interactive elements prevents accidental taps
- Thumb zone: primary buttons center-bottom of screen
- Large, well-labeled buttons with contrasting colors

**Layout:**
- Single-column vertical layout for mobile
- Clear CTAs near the top to minimize scrolling
- Concise, scannable text - only essential information
- Generous white space between sections
- Fixed/sticky top bar for key navigation

**Navigation:**
- Hamburger menu to save space, short descriptive labels
- "Back to top" button for long pages
- Logo links to homepage (standard expectation)
- Breadcrumbs to show location and reduce bounce

**Performance:**
- Compress images (JPEG for photos, PNG for transparency, WebP/AVIF for modern browsers)
- Limit animations that slow page load
- Fast loading is critical on mobile networks

---

## Mobile-First Design

- Start with smallest screen first, progressively add complexity for larger viewports
- Mobile constraints force prioritization of essential content - produces cleaner interfaces overall
- Define breakpoints around content needs, not device dimensions
- Common breakpoints: 560px, 768px, 960px, 1280px, 1440px, 1920px
- Use relative units (%, vw, rem) instead of fixed px for widths
- Semantic HTML as foundation before CSS/JS enhancements
- Core functionality should work without JavaScript
- Increase padding and margins at larger viewports for breathing room

---

## Website Structure

**Structure types:**
- Hierarchical/tree: homepage > categories > subcategories (e-commerce, business)
- Linear/sequential: step-by-step flows (onboarding, forms)
- Matrix/web: interlinked pages for exploration (knowledge bases)
- Database/dynamic: generated from queries (catalogs, news)
- Hybrid: most modern sites combine multiple models

**Information architecture rules:**
- Limit main menu items (5-7 maximum)
- Clear, recognizable labels
- No orphan pages (every page linked from somewhere)
- Consistent navigation across all pages
- Shallow hierarchy: content reachable in few clicks
- Readable URLs reflecting site hierarchy: `/blog/web-design/tips` not `?id=123`

**Essential components:**
- Homepage as entry point
- Main navigation (consistent, clear)
- Logical content categories
- Internal linking strategy
- Footer with secondary nav, contact, legal
- Breadcrumbs (clickable: Home > Category > Page)
