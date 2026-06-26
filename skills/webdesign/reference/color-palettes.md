# Color Palette Strategies

## Palette Selection by Context

### SaaS / Tech
- **Developer tools**: Dark foundations (charcoal, slate) with single high-contrast accent (lime, cyan, orange)
- **Productivity tools**: Clean whites and light grays with a strong brand color and muted secondary
- **AI/ML products**: Deep blues or purples with electric accents - but avoid the overused cyan-on-dark cliche
- **Enterprise**: Conservative blue/gray foundations with trust-building accent colors

### Dashboards
- **Monochromatic schemes** feel most cohesive for data-heavy interfaces
- Use color coding semantically: green (success/healthy), amber (warning), red (critical/error)
- Warm earthy tones differentiate from generic gray dashboards
- Reserve bright colors for data visualization and status indicators
- Both light and dark themes should be supported

### E-commerce
- **Luxury**: Neutral elegance (cream, taupe, charcoal) with gold or deep jewel accents
- **Youth/fashion**: Vibrant palettes (coral, purple, electric blue) with bold hero sections
- **General retail**: Clean white foundation with brand color for CTAs and category accents
- **Food/organic**: Warm earth tones (terracotta, olive, cream) with natural photography

### Portfolios
- **Tech/developer**: Dark mode with neon or gradient accents (green, cyan, purple)
- **Designer**: Either dramatic dark with selective color, or warm pastels (pink, peach)
- **Editorial/architecture**: Near-monochrome with high contrast (black/white with one accent)
- **Creative**: Bold, expressive palettes that showcase personality

### Service / Public Sector
- **Trades**: Dependable combinations (royal blue + white, navy + gold)
- **Events**: Dark navy or black with sparkle/metallic accents
- **Government**: Accessible, high-contrast palettes with clear status colors
- **Crisis/legal**: Dark gradients with authoritative white typography
- **Healthcare**: Calming blues and greens with clean white spaces

---

## Palette Categories

### Minimal and Neutral
Whites, blacks, grays, soft pastels. Promote focus and elegance.
- Ink wash: monochromatic grays for readability-first designs
- Neutral elegance: muted beige, gray, brown for luxury minimalism
- Add a single accent (teal, cinnamon, chartreuse) for CTAs and interactive elements

### Warm
Reds, oranges, yellows, browns. Evoke energy, comfort, appetite.
- Earth tones (terracotta, amber, walnut) for authenticity and warmth
- Coral and peach for approachable energy
- Mustard and taupe for timeless sophistication
- Pair warm accents with cool neutral backgrounds for balance

### Cool
Blues, greens, purples. Project calm, intelligence, trust.
- Deep blues and plum for luxury and sophistication
- Sage and mint for wellness, sustainability, organic
- Lavender and periwinkle for gentle, creative brands
- Navy and teal for professional authority

### Vibrant and Bold
Saturated, high-energy palettes. Capture attention.
- Neon pink + deep purple for entertainment and gaming
- Electric blue + warm orange for adventure and tech startups
- Lime green + dark charcoal for modern edge (gaming, sports)
- Use sparingly - bright accents against dark or neutral foundations

### Neon-Noir
Dark, cinematic palettes with aggressive accent tension.
- Pure black (#0a0a0a) base + aggressive red (#ff3333) or neon cyan
- Deep charcoal + electric magenta for nightlife and entertainment
- Midnight blue + hot pink for edgy tech brands
- CSS: use `text-shadow` glow effects on accents for cinematic depth

### Cool Blue / Blue Hour
Blue as the defining palette direction of 2026.
- Icy blue (#d1e8ff) to deep cobalt (#1a3a6b) gradients
- Steel blue foundations with warmer accent (amber, coral)
- Muted blue-gray for backgrounds with saturated blue for interactive elements
- Signals quietude, trust, clarity - works across fintech, wellness, corporate

### Soft-Glow
Ethereal, dreamlike palettes with gentle luminosity.
- Warm peach and rose gradients with low-opacity glow layers
- Pale lavender to soft gold transitions
- CSS: `radial-gradient` with low-opacity warm stops, soft `filter: blur()`
- Best for: wellness, beauty, luxury, spiritual brands

### Neo Deco Metallics
1920s-inspired metallic palettes modernized.
- Brass (#d4a574) + charcoal for sophisticated warmth
- Chrome silver + deep navy for modern luxury
- Gold accents on matte black for high-end products
- CSS: metallic `linear-gradient` with multiple color stops for shimmer effect

### Modern
Minimal palettes with strategic pops of color.
- Gray foundation with single bold accent (orange, teal, coral)
- Monochromatic blue with white for fintech/wellness
- Black and white with one vibrant accent for contemporary edge
- Muted tones with one unexpected color for sophisticated contrast

---

## Color Application Rules

**Primary**: 60% of the design. Background and large surfaces.
**Secondary**: 30%. Cards, sections, navigation backgrounds.
**Accent**: 10%. CTAs, links, highlights, status indicators.

**Tint neutrals toward your brand hue** - even subtle tinting creates cohesion. A blue brand tints its grays cool; a warm brand tints its grays warm.

**Never use pure black (#000) or pure white (#fff)** - tint them. Off-black (#0a0a0a, #111) and off-white (#fafafa, #f5f5f0) feel more natural.

**CTA contrast**: Primary action buttons need the highest contrast in the design. If your background is dark, CTAs should be bright and vice versa.

**Accessibility**: WCAG AA minimum - 4.5:1 for normal text, 3:1 for large text. Test every color combination.

**Dark mode**: Not an inversion - redesign the palette. Reduce contrast slightly (pure white text on dark backgrounds causes eye strain). Use elevation through subtle brightness increases rather than shadows.
