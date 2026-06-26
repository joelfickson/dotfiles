# Layout Recipes

## Hero Patterns

### Value Proposition Hero
Split hero: headline + subtext + CTA on one side, product screenshot or illustration on the other. Best for SaaS, apps, and service businesses.

### Full-Screen Hero
Single background image or video covering the viewport. Text overlay with clear CTA. Best for brand storytelling, luxury, portfolios.

### Floating Elements Hero
Clean background with floating UI components, cards, or illustrations arranged around the headline. Best for design tools, productivity apps.

### Bold Typography Hero
Oversized headline filling most of the viewport. Minimal imagery. Best for agencies, portfolios, creative brands.

### Dark Cinematic Hero
Dark gradient background with glowing or 3D elements. Best for premium products, gaming, entertainment.

---

## Page Layouts

### Bento Grid
Modular cards of varying sizes arranged in a grid. Mix square, wide, and tall cards. Best for feature showcases, SaaS landing pages, dashboards.

### Zig-Zag (Alternating)
Alternating image-left/text-right and text-left/image-right sections. Follows Z-pattern eye tracking. Best for feature explanations, product pages, homepages.

### F-Pattern
Heavy content on the left, scanning downward. Important info at top-left and along left edge. Best for long-form content, blogs, documentation.

### Magazine / Editorial
Multi-column grid with varied article sizes. Large featured piece with smaller supporting pieces. Best for news, publications, content-heavy sites.

### Card Grid
Uniform cards in responsive grid. Each card: image + title + metadata. Best for e-commerce catalogs, blog indexes, team pages.

### Split Screen
Two equal (or asymmetric) columns. Best for comparisons, sign-up pages, before/after, dual-focus content.

---

## Data Layouts (Dashboards)

### KPI Bar + Detail Grid
Top row of metric cards (big number + label + trend), followed by two-column grid of charts and tables.

### Sidebar + Canvas
Fixed sidebar navigation with main content area. Sidebar shows nav hierarchy; canvas shows current view's data.

### Filter Bar + Results
Horizontal filter controls at top (dropdowns, date pickers), results grid or table below. Best for analytics, search results.

### Master-Detail
List/table on left, detail panel on right (or expanding). Clicking a row reveals full detail without page change.

---

## Navigation Patterns

### Fixed Top Bar
Logo left, nav center or right, CTA far right. Stays visible on scroll. Standard for most websites.

### Sidebar Navigation
Persistent left sidebar with icon + label nav items. Collapsible to icon-only. Standard for dashboards and web apps.

### Hamburger Menu
Hidden nav behind menu icon. Three reveal patterns: slide-out sidebar, full-screen overlay, or dropdown panel. Animate icon to X when open (under 300ms). Add `aria-label`, `aria-expanded`, keyboard nav (Tab/Enter/Escape), and focus trap. Consider hybrid: show 3-4 key links visible + hamburger for the rest. Add "Menu" text label for less tech-savvy audiences.

### Bottom Tab Bar
3-5 icon+label items fixed at screen bottom. Better discoverability than hamburger on mobile. Reserve for primary navigation in apps and mobile-first sites.

### Tab Navigation
Horizontal tabs for switching between views within a section. Best for settings, profiles, content with parallel sections.

---

## Content Section Patterns

### Accordion FAQ
Question as toggle, answer expands below. Keeps pages clean while holding substantial content. Place near bottom of landing pages.

### Testimonial Grid
Cards with quote, name, role, and photo. 2-3 column grid or horizontal carousel. Place after feature sections for social proof.

### Pricing Table
2-4 columns comparing tiers. Highlight recommended tier. Toggle for monthly/annual. Clear CTA per tier.

### Feature Grid
3-4 column grid of feature cards. Icon + heading + short description per card. Optionally use bento layout for varied emphasis.

### Team Section
Photo + name + role cards in grid. Optional hover for bio or social links. Humanizes the brand.

### Contact Section
Form (name, email, message) alongside contact info and optional map. Embed in footer or as standalone section.

### CTA Patterns
- **Placement**: Primary CTA above the fold. Repeat at mid-page and bottom. Sticky CTAs follow scroll without interrupting content.
- **Progressive CTAs**: Start broad ("Get started"), become more specific as user scrolls ("Start your free trial of X"). Matches intent at each journey stage.
- **Side-by-side CTAs**: Address different intents simultaneously ("Sign up free" next to "See pricing").
- **Copy**: Action verbs ("Start watching", "Shop new styles"), not generic ("Click here", "Submit"). Personalized CTAs convert up to 202% better.
- **Design**: Contrasting color, generous padding, white space around CTA. Supporting trust signals nearby ("No credit card required", star ratings).
- **Pop-up CTAs**: Timed for peak interest moments, always with clear exit. Use sparingly.

### One-Page Website Structure
For focused single-page sites: Header > Hero (headline + subheading) > Content sections in scannable blocks > CTA > Footer (contact, social, legal). Use sticky navigation with jump links to sections. Keep it simple - limited color palette, generous white space. Optimize load time aggressively.

---

## Grid Systems

### Block Grid (Single Column)
Large central column. Best for text-heavy content: blogs, articles, about pages. Break monotony with headers, hero images, pull quotes.

### Column Grid
2-12 columns (3 is the UX sweet spot). Classic for pricing comparisons. Use `grid-template-columns: repeat(auto-fit, minmax(250px, 1fr))` for responsive auto-adjustment.

### Modular Grid
Gallery-style in neat rows AND columns. Best for product catalogs, image galleries, portfolio grids. Maximizes items visible, responsive across devices.

### Baseline Grid
Dense horizontal lines dictating text placement. Aligns all text for scanability. Use REM units for accessibility.

### Hierarchical Grid
Modules arranged by importance, not strict rows/columns. Most flexible type. Best for mixed content pages.

### Grid Rules
- Use soft grids (consistent base-unit spacing) over hard grids (strict pixel alignment) for digital
- Base unit: 8px (0.5rem) or 16px (1rem). All sizing/spacing in increments of this
- Set sizes as percentages/REM, not fixed px
- Mobile: small margins so content doesn't touch edges. Desktop: flexible margins so text doesn't span full widescreen

---

## Eye Tracking Principles

**Z-pattern**: For pages with minimal text. Place logo top-left, nav top-right, main content center, CTA bottom-right.

**F-pattern**: For text-heavy pages. Place important content in the first two lines and along the left edge.

**Upper-left gravity**: Users look top-left first. Place primary navigation, logo, and search there.

**Size = importance**: Larger elements get seen first. Use size to establish hierarchy.

**Visual weight**: Bold colors, high contrast, and isolation (white space) increase an element's perceived importance.

---

## 2026 Layout Patterns

### TL;DR / Pitch-Deck Layout
Structured overviews with front-loaded essentials and drill-down options. Pitch-deck-style: one key point per viewport section, scannable format. Respects how users actually consume content (45% average scroll depth on mobile). Best for: SaaS, content-heavy sites, documentation.

### Guided Scrolling
Scroll-based wayfinding with progress indicators, section markers, and visual cues. Positional markers showing location within experience. This is a navigation tool - not narrative scrollytelling. Best for: long-form content, product tours, multi-section landing pages.

### Organic / Anti-Grid
Moving away from strict grids toward natural, flowing designs. SVG-powered masks and shape dividers for fluid transitions. Multi-layer gradient overlays with backdrop filters. Asymmetric layouts using flexbox and nestable containers. Best for: creative agencies, brand experiences.

### Brand Storytelling Sections
Nested carousels, tabs, and accordions for narrative unfolding. Motion effects on key story moments (fade, slide, scale). Sequential story beats revealed through scrolling. Best for: product launches, company stories, campaign pages.

## Responsive Adaptation

**Do not just shrink** - reorganize:
- Bento grids collapse to single column, maintaining card order by importance
- Split screens stack vertically (image on top, content below)
- Sidebar navigation becomes bottom tab bar or hamburger on mobile
- Data tables become card lists on small screens
- Multi-column grids reduce columns progressively (4 > 2 > 1)
- Touch targets minimum 44x44px on mobile
