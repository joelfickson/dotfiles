# Typography Guide

## Font Selection by Context

### SaaS / Tech
**Headings**: Space Grotesk, Manrope, Plus Jakarta Sans, Montserrat, Raleway
**Body**: Inter, Work Sans, DM Sans, Source Sans Pro, Lato

### Dashboards
**Headings**: Poppins, Nunito, Rubik, Ubuntu
**Body**: Inter, Open Sans, Lato, DM Sans
**Data/Numbers**: Use tabular figures (font-variant-numeric: tabular-nums) - monospace numbers align in columns

### E-commerce
**Headings**: Montserrat, Josefin Sans, Playfair Display (luxury), Raleway
**Body**: Lato, Open Sans, Nunito, Work Sans
**Prices**: Bold weight of body font, tabular figures

### Portfolios
**Headings**: Playfair Display (editorial), Space Mono (tech), Oswald (bold impact), Abril Fatface (luxury)
**Body**: Lora, Source Sans Pro, Karla, PT Sans

### Service / Public Sector
**Headings**: Roboto, Poppins, Montserrat, Ubuntu
**Body**: Open Sans, Lato, Nunito, Source Sans Pro
Prioritize maximum readability and multilingual support.

---

## Proven Font Pairings

### Modern Professional
- **Montserrat + Karla** - geometric polish meets humanist clarity
- **Raleway + Merriweather** - sleek neo-grotesque with classic serif
- **Oswald + Source Serif 4** - bold condensed headers with refined body
- **Inter + Krub** - clean contemporary with distinctive loops

### Warm and Approachable
- **Nunito + Lora** - rounded friendliness with serif sophistication
- **Nunito + PT Sans** - soft headers with structured body
- **Arvo + Lato** - sturdy slab serif with humanist sans

### High-End / Editorial
- **Abril Fatface + Lato** - dramatic serif with clean sans
- **Cinzel + Fauna One** - Roman-inspired grandeur with soft serifs
- **Playfair Display + Source Sans Pro** - transitional elegance with neutral body
- **Yeseva One + Josefin Sans** - bold feminine energy with geometric balance

### Tech / Developer
- **Space Mono + Plus Jakarta Sans** - retro-tech with friendly professional
- **DotGothic16 + Space Mono** - pixel-art flair with monospaced foundation
- **Ubuntu + Rokkitt** - humanist curves with sturdy slab serif

### Creative / Playful
- **Fugaz One + Work Sans** - geometric italic energy with clean body
- **Arima Madurai + Mulish** - flowing curves with minimalist polish
- **Chonburi + Domine** - retro playfulness with approachable reading

---

## Type Scale

Use a modular scale with fluid sizing:

```css
--text-xs: clamp(0.75rem, 0.7rem + 0.25vw, 0.875rem);
--text-sm: clamp(0.875rem, 0.8rem + 0.35vw, 1rem);
--text-base: clamp(1rem, 0.9rem + 0.5vw, 1.125rem);
--text-lg: clamp(1.125rem, 1rem + 0.6vw, 1.25rem);
--text-xl: clamp(1.25rem, 1.1rem + 0.75vw, 1.5rem);
--text-2xl: clamp(1.5rem, 1.2rem + 1.5vw, 2rem);
--text-3xl: clamp(1.875rem, 1.5rem + 1.875vw, 2.5rem);
--text-4xl: clamp(2.25rem, 1.5rem + 3.75vw, 3.5rem);
--text-5xl: clamp(3rem, 2rem + 5vw, 5rem);
```

## Key Typography Rules

**Hierarchy**: H1 hero at 48-80px, H2 sections at 32-48px, body at 16-18px. Never less than 16px for body text on screens.

**Line height**: 1.1-1.2 for headings, 1.5-1.6 for body text. Tighter leading on large text, looser on small.

**Letter spacing**: Tighten tracking on large headlines (-0.02em to -0.04em). Open up on uppercase text (+0.05em to +0.1em). Leave body text at default.

**Weight**: Use variable fonts when available. Headings at 600-800, body at 400-500. Avoid using more than 3 weights per typeface.

**Color**: Never use pure gray for text on colored backgrounds. Tint text color toward the background hue. Ensure WCAG AA contrast minimum (4.5:1 for body, 3:1 for large text).

**Loading**: Use `font-display: swap` for body fonts (prevent invisible text). Use `font-display: optional` for decorative fonts (prevent layout shift). Preload critical fonts with `<link rel="preload">`.

---

## Kinetic and Interactive Typography (2026)

**Variable font animation**: Use `font-variation-settings` with CSS transitions for responsive weight/width shifts on scroll or hover. Single font file, multiple expressions.

```css
.heading {
  font-variation-settings: 'wght' 400, 'wdth' 100;
  transition: font-variation-settings 0.3s ease;
}
.heading:hover {
  font-variation-settings: 'wght' 800, 'wdth' 120;
}
```

**Scroll-reactive kinetic type**: Text that breathes - letter-spacing, weight, and opacity shifting as user scrolls through content. Use CSS `scroll-timeline` or IntersectionObserver.

**Dynamic text treatments**: Text animating in with motion effects timed to statement presentation. Principle: enhancement without distraction - animation serves comprehension, not spectacle.

**When to use kinetic type**: Hero sections, brand moments, portfolio showcases. Never on body text, navigation labels, or form elements. Always respect `prefers-reduced-motion`.
