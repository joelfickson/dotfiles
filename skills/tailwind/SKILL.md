---
name: tailwind
description: Use when writing or reviewing Tailwind CSS classes in any framework - covers class ordering, component patterns, dark mode, responsive design, config structure, and common anti-patterns
---

# Tailwind CSS Best Practices

## Overview

Utility-first CSS done well requires discipline around class composition, config structure, and component boundaries. Without it, Tailwind projects degrade into unmaintainable class soup. This skill codifies battle-tested patterns from production codebases.

## Prerequisite: CSS Knowledge

Tailwind is another way of writing CSS, not a replacement for understanding it. Know the box model, flexbox axes, specificity, and cascade before reaching for utilities.

## Class Composition

### Use Shorthand Utilities

Prefer combined utilities over redundant expansions:

```html
<!-- BAD -->
<div class="pt-4 pb-4 pl-6 pr-6 flex flex-row justify-between border border-dotted border-2 border-black border-opacity-50">

<!-- GOOD -->
<div class="py-4 px-6 flex justify-between border-dotted border-2 border-black/50">
```

`flex-row` is the default - don't specify it. `border-opacity-50` is legacy - use `/50` modifier syntax.

### Automate Class Ordering

Install `prettier-plugin-tailwindcss` and never think about ordering again:

```json
{
  "plugins": ["prettier-plugin-tailwindcss"],
  "tailwindFunctions": ["cn", "cva", "clsx"]
}
```

This handles `cn()` and `cva()` calls too, not just `className`.

### Never Concatenate Class Names Dynamically

The compiler scans source files for complete class strings. Dynamic construction breaks purging:

```tsx
// BAD - purged in production, elements unstyled
const color = `bg-${status}-500`
const size = `text-${scale}xl`

// GOOD - full strings preserved by compiler
const colorMap = {
  success: 'bg-green-500',
  error: 'bg-red-500',
  warning: 'bg-yellow-500',
} as const

const color = colorMap[status]
```

If you must reference classes not in source, use `@source inline()` directives or safelist them in config.

## The `cn` Helper

Combine `clsx` (conditional logic) with `tailwind-merge` (specificity resolution) into one utility:

```typescript
import { clsx, type ClassValue } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

Use `cn` for all conditional or composable class strings. Configure IntelliSense to recognize it.

## Component Variants with CVA

For components with multiple visual states, use `class-variance-authority`:

```typescript
import { cva } from 'class-variance-authority'

const button = cva('rounded font-medium transition-colors', {
  variants: {
    intent: {
      primary: 'bg-blue-500 hover:bg-blue-600 text-white',
      danger: 'bg-red-500 hover:bg-red-600 text-white',
      ghost: 'bg-transparent hover:bg-gray-100 text-gray-700',
    },
    size: {
      sm: 'text-sm px-3 py-1.5',
      md: 'text-base px-4 py-2',
      lg: 'text-lg px-6 py-3',
    },
  },
  defaultVariants: {
    intent: 'primary',
    size: 'md',
  },
})
```

This is strictly better than accepting arbitrary className props - it centralizes design decisions and prevents inconsistent overrides.

## Config: Semantic Design Tokens

Name tokens by intent, not appearance:

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        // BAD: visual names
        'bright-red': 'oklch(54% 0.22 29)',
        'nice-green': 'oklch(75% 0.18 154)',

        // GOOD: semantic names
        primary: 'oklch(75% 0.18 154)',
        error: 'oklch(54% 0.22 29)',
        brand: {
          light: '#3fbaeb',
          DEFAULT: '#0fa9e6',
          dark: '#0c87b8',
        },
      },
    },
  },
}
```

Remove unused default tokens to shrink bundle size. Group tokens by category (colors, spacing, typography).

## Responsive Design

### Mobile-First Always

Write base styles unprefixed. Layer on breakpoint modifiers for larger screens:

```html
<h1 class="text-3xl font-bold md:text-5xl">Title</h1>
<p class="text-sm md:text-base lg:text-lg">Body</p>
```

Stack modifiers for responsive + interactive states: `md:hover:text-blue-600`.

### Layout Wrapper Pattern

Constrain content width without affecting section backgrounds:

```html
<section class="bg-gray-50">
  <div class="mx-auto w-[90%] max-w-[68.75rem]">
    <!-- content here -->
  </div>
</section>
```

Background/images go on the outer `<section>`. Layout constraints, flexbox, and text styles go on the inner wrapper.

## Dark Mode

Use CSS custom properties with Tailwind's `dark:` modifier. Define tokens at `:root` and override under `[data-theme="dark"]` for instant switching without re-renders:

```css
:root {
  --color-bg: theme(colors.white);
  --color-text: theme(colors.gray.900);
}

[data-theme="dark"] {
  --color-bg: theme(colors.gray.900);
  --color-text: theme(colors.gray.100);
}
```

## Spacing and Vertical Rhythm

Use `space-y-*` for equal spacing between children instead of adding margin to each:

```html
<!-- BAD -->
<div>
  <p class="mb-4">First</p>
  <p class="mb-4">Second</p>
  <p>Third</p>
</div>

<!-- GOOD -->
<div class="space-y-4">
  <p>First</p>
  <p>Second</p>
  <p>Third</p>
</div>
```

## Parent-Child State with `group`

Eliminate repetitive hover/focus prefixes across sibling elements:

```html
<button class="group rounded-lg p-4 hover:bg-gray-100">
  <h3 class="group-hover:text-blue-600">Title</h3>
  <p class="group-hover:text-gray-600">Description</p>
</button>
```

Also works with ARIA: `group-aria-expanded:rotate-180`.

## Complex CSS with @utility

Bundle verbose multi-line CSS under a single Tailwind-compatible class:

```css
@utility clip-hero {
  clip-path: polygon(0 0, 100% 0, 100% 85%, 0 100%);
}
```

Keeps arbitrary value sprawl (`[clip-path:polygon(...)]`) out of your markup.

## Base Layer Typography

Set project-wide type defaults in `@layer base`:

```css
@layer base {
  h1 { @apply text-3xl font-bold md:text-5xl; }
  h2 { @apply text-2xl font-semibold md:text-3xl; }
  body { @apply text-sm md:text-base; }
}
```

This is one of the few acceptable uses of `@apply` - global base styles that every page shares.

## Third-Party Library Integration

When coexisting with component libraries (MUI, Radix, etc.):

1. Load `tailwind.css` after the library's baseline styles
2. Enable CSS variable mode in the library if available
3. Reserve `!important` only for unavoidable inline style overrides from third parties - document the reason and add a TODO for removal

## Tooling (Non-Negotiable)

- **IntelliSense**: `bradlc.vscode-tailwindcss` - configure it to recognize `cn()` and `cva()` patterns
- **Prettier plugin**: `prettier-plugin-tailwindcss` - automated class sorting
- **Production minification**: `npx tailwindcss -o build.css --minify`

## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| Dynamic class concatenation (`bg-${x}-500`) | Purged in production | Use explicit variant maps |
| Accepting arbitrary `className` props | Inconsistent component appearance | Use CVA or predefined variant objects |
| Excessive `@apply` in components | Defeats utility-first benefits, bloats CSS | Extract React/Vue components instead |
| Arbitrary value explosion (`[23px]`, `[#a4f]`) | Bypasses design system | Add tokens to config |
| Missing `!important` documentation | Impossible to remove later | Comment with reason and TODO |
| Specifying defaults (`flex-row`, `items-stretch`) | Noise, harder to scan | Only add classes that change defaults |

## Quick Reference

| Task | Pattern |
|------|---------|
| Conditional classes | `cn('base', condition && 'active')` |
| Component variants | `cva('base', { variants: {...} })` |
| Responsive | `text-sm md:text-base lg:text-lg` |
| Dark mode | `dark:bg-gray-900 dark:text-white` |
| Group hover | `group` on parent, `group-hover:*` on children |
| Space between | `space-y-4` on parent |
| Complex CSS | `@utility name { ... }` |
| Safe dynamic classes | Explicit map object with full class strings |
