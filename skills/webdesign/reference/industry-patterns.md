# Industry Design Patterns

## SaaS and Tech Landing Pages

**Core patterns**: Bento grids, feature blocks, social proof sections, conversion-focused CTAs.

**Layout**: Hero section with clear value proposition, followed by feature grid (bento or card-based), testimonials/logos, pricing, FAQ with accordions, final CTA.

**Visual style**:
- Dark charcoal backgrounds with high-impact headings work for developer/technical tools
- Clean white backgrounds with floating UI elements work for design/productivity tools
- Glass-effect heroes and glassmorphism panels for AI/consulting positioning
- Modular panels on 8px grid for technical credibility

**What works**:
- High-contrast CTA buttons placed early and repeated
- Floating product screenshots or UI mockups in hero
- Accordion FAQs to maintain clean layout
- Stock photos used sparingly - product UI screenshots are stronger
- Bento grids that break uniform sizing for visual interest

**Scale consideration**: Multi-page architectures need consistent navigation and layout logic across the full sitemap. AI/consulting sites often need 50-100+ pages with multilingual support.

---

## Dashboards and Management Systems

**Core patterns**: Sidebar navigation, data cards, charts/graphs, status indicators, activity feeds.

**Layout**: Persistent sidebar (or collapsible) with main content area. Top row for high-level KPIs, then detailed data in two-column grids. Tables for granular data. Filters and dropdowns at top of content area.

**Visual style**:
- Color-coded tags and status indicators (green/yellow/red for urgency)
- Monochromatic schemes feel more cohesive than multi-color dashboards
- Warm earthy tones differentiate from generic gray dashboards (coffee shop, retail)
- Gradient headers add modern energy to otherwise data-heavy layouts
- Modular cards keep complex data organized and scannable

**What works**:
- Big-picture stats first, then drill-down tables
- Sidebar stays fixed while content scrolls
- AI insights panels with recommendations categorized by impact level
- Progress bars for occupancy/capacity visualization
- Time-based filters (dropdowns) at the top of data sections
- Both light and dark mode support - data dashboards are used in varied lighting
- Activity feeds in sidebars for real-time updates

**Data density**: Balance information density with white space. Dense dashboards need clear visual hierarchy through card elevation, color coding, and consistent type sizing.

---

## E-commerce

**Core patterns**: Product grids, hero banners, category navigation, comparison tools, filtering.

**Layout**: Hero section for brand story or promotions, icon-based category navigation, product grid with cards (image, price, rating), detailed product pages with galleries.

**Visual style**:
- Bold colored hero sections (purple, coral) for modern/youth brands
- High-quality photography with generous spacing for luxury/automotive
- Clean white backgrounds with product-focused cards for electronics/general retail
- 3D elements and dark themes for premium single-product showcases
- Interactive color pickers and carrying case animations for product tours

**What works**:
- Product cards: image, name, price, rating - all visible without clicking
- Price comparison tools showing other retailers
- Tags for "new", "featured", "sale" to aid filtering
- Icon-based category navigation above product grids
- Trending/popular links to guide discovery
- Monthly payment calculators on high-ticket items
- Hero sections that set brand mood before showing products

**Single product vs. catalog**: Single-product pages benefit from scroll-driven storytelling (features revealed on scroll, 3D rotation, X-ray views). Catalogs need efficient grids with strong filtering.

---

## Portfolio Sites

**Core patterns**: Hero with identity, project gallery, skills/experience, contact.

**Visual style by discipline**:

| Discipline | Approach |
|-----------|----------|
| Software engineer | Card-based skills and history, embedded contact form, straightforward hero with resume links |
| AI/ML engineer | Neon gradients, plexus backgrounds, glassmorphism cards, color-coded tech tags, progress bars |
| Game developer | Typewriter effects, quest-style progress bars, badges, player-profile framing |
| UI/UX designer | Dark mode with neon accents, split-layout hero with headshot, modular browsing cards |
| Architect | Editorial/magazine feel, cinema-scale hero images, wide margins, centered overlays |
| Videographer | Moody wide-angle hero, thin nav, high-contrast tags, looping video reel hero |
| General designer | Warm gradients (pale pink), floating accents, rounded hero, two-column gallery |

**What works**:
- Vertical timelines for work history
- Interactive skill filters (click Python to see all Python projects)
- Terminal-style search bars for developer portfolios
- Light/dark mode toggles to demonstrate range
- Case study galleries with larger images and descriptions
- Pill tags for skills, color-coded by category

---

## Service and Public Sector

**Core patterns**: Search-first navigation, service grids, trust signals, contact forms, persona-based routing.

**Layout**: Prominent search bar and logical navigation at top. Service grids with icons and checklists. Testimonials and team sections for trust. Contact form on every page or in footer.

**Visual style**:
- Dependable palettes (royal blue + white for trades, navy + sparkles for events)
- High-contrast emergency elements (red highlights, always-visible hotline numbers)
- Human-centered photography in heroes (team photos, people at work)
- Dark gradients with white typography for authority (crisis/legal)
- Gold accents on white for friendly trade businesses

**What works**:
- Persona-based cards ("I'm a student", "I'm a business owner") for government portals
- Live widgets for agendas, news, status updates
- "Quick links" footers for most-requested actions
- Interactive maps for service areas with zip code search
- Dark/light mode toggles that maintain design quality in both
- Service tier organization (residential, commercial, specialty)
- Emergency services highlighted in contrasting color
- Nested menus and well-mapped footers for deep sitemaps

---

## Landing Pages (Conversion-Focused)

**Section structure**: Hero (headline + visual + CTA) > Feature highlights > Social proof (testimonials, logos) > Trust signals (credentials, badges) > Pricing > FAQ accordion > Final CTA.

**Conversion rules**:
- Minimize or remove top-level navigation - keep users focused on one outcome
- Primary CTA above the fold, repeated at mid-page and bottom
- Match page copy with the ad/link that brought users in (consistent messaging lowers bounce)
- Trust signals near CTAs: security badges, "no credit card required", star ratings, privacy links

**By industry**:
- **Product launch**: Hero visual + "Discover More" before commitment, beta tester quotes
- **SaaS**: Headline focused on single biggest problem solved, free tier to remove friction
- **E-commerce**: Image-forward, product center stage, video/360-degree photography
- **Service**: Muted palette + structured layout for trust, headshots + bios, local targeting
- **Events**: Countdown timer, date/time/location prominent, past event video, social share buttons

---

## Business Websites

**Essential pages**: Homepage, About, Service/Product pages, Contact, FAQ.

**Homepage**: Hero with dynamic background or animation, clear CTA, prominent navigation. Communicate brand message immediately.

**About**: Storytelling with team photos, awards, social links. Builds credibility.

**Service/Product**: Clear CTAs, high-quality images, compelling descriptions, comparison charts, testimonials.

**Contact**: Clear info, live chat option, interactive map. Simplify communication.

**FAQ**: Accordion-style expandable answers, search bar, links to help articles.

**Non-negotiables**: 2-3 brand colors + accent, responsive/mobile-first, WCAG accessibility, reusable component design system.

---

## Personal Websites

**Structures by type**:
- **Case-study driven**: Projects broken into phases (discovery > strategy > design > outcome). Map decisions to business impact.
- **Visual-feed driven**: Continuous vertical feed, large visuals, zoom-on-scroll. Let work speak.
- **Interactive/playful**: 3D navigation, draggable components. The site itself is a portfolio piece.
- **Minimal/typography-led**: Generous white space, crisp typography, high-fidelity shots.

**Essential sections**: Hero (name + role + one-liner), project gallery with previews, case study detail pages, about with personal story, contact visible on every page.

---

## Web Applications

**Core patterns**: App shell with navigation, content areas, toolbars, panels, modals (sparingly).

**Layout**: Sidebar or top navigation as app shell. Main content area with contextual toolbars. Split panes for list/detail views. Collapsible panels for secondary information.

**Visual style**:
- Neutral foundations with accent colors for interactive elements
- Consistent icon systems throughout
- Dense but organized information layouts
- Status indicators and breadcrumbs for orientation

**What works**:
- Progressive disclosure: simple defaults, advanced options behind expandable sections
- Keyboard shortcuts for power users
- Empty states that teach the interface
- Optimistic UI: update immediately, sync in background
- Persistent state indicators (saving, synced, error)
- Responsive app shells that adapt to mobile without losing functionality
- Card layouts for browsable content, tables for scannable data
