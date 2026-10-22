---
name: joel-frontend
description: Joel's web frontend architecture patterns - rendering strategy per surface, server state vs client state, data access layering, no effect-driven logic, presentational components, routing as state, forms, auth guards, i18n, and feature-folder structure. Use when designing or changing a web app, page, route, component, data hook, form, or API client in one of Joel's projects. Pair with joel-ui-design for anything visual.
---

# Frontend patterns

Read `joel-architecture` first, and `joel-ui-design` before touching markup. Default tools: React with React Router (framework mode) on Cloudflare Workers, TanStack Query, Zustand, Tailwind and shadcn/ui. Internal admin tools may be single-page apps with a typed file router. Next.js only for Vercel-hosted or content sites.

## Rendering strategy per surface

- **Public and SEO pages render on the server**: data loads in the route loader, missing data throws a not-found response, metadata and structured data come from one shared helper, and sitemaps, robots and social images are routes.
- **Signed-in dashboards render on the client**: no server loaders; data comes through query hooks; the shell loads fast and fills in. The exception is users on slow networks or low-end devices: render on the server and ship minimal JavaScript.
- **App-like products** run as a single-page app with prerendered marketing routes.
- Private apps are `noindex` by default.

## Two kinds of state, never mixed

- **Server state** (anything the backend owns) lives only in the query cache: fetched, cached, invalidated, never copied into local or global state.
- **Client state** (UI, preferences, a player, a cart, disclosure that crosses components) lives in small focused stores, one per concern.
- **Local component state** only for values that never leave one leaf component.
- **Context** only to provide infrastructure (auth, query client, i18n), never as a state store.
- **The URL is state.** Tabs, filters, selected items and tenant are routes or search params, so every view is linkable and the back button works.

## No effect-driven logic

Side effects live in event handlers, data-layer callbacks (on success, on error, on settled), and route loaders or actions. Redirects are rendered (a navigate element), not triggered from an effect. The one exception is bridging a non-React system (a media engine, a third-party widget), isolated in a single named module.
*Why:* effect chains create waterfalls, race conditions and double-fetches, and hide control flow from the reader.

## Data access layering

```
api client      one typed module mirroring the backend routes; parses responses against shared contracts; throws a typed API error
query keys      one hierarchical key factory per domain
hooks           one hook per query and one per mutation; components never call the query library directly
components      consume hooks, render, emit events
```

- Contract types come from the shared package; the app never redeclares them.
- Auth tokens are fetched inside each request function, not stored.
- Mutations invalidate the keys they affect. Optimistic updates snapshot, apply, roll back on error with a user-facing message, and reconcile on settle.
- Server-only modules are marked as such so they never ship to the browser.

## Components

- Presentational by default: props in, events out, no fetching or business rules.
- Props are named types from the contracts or a sibling types file, never inline literals.
- No components or types declared inside another component.
- Variant styling through lookup tables, not conditional chains.
- Shared primitives live in a UI package split into component, types and variants. App-specific overrides stay in the app.

## Forms

- Default: native uncontrolled forms. The submit handler reads the form data into a typed body and calls one mutation. Validation happens on the server and is mirrored by the shared schema.
- Complex forms (field-level live validation, dynamic arrays, multi-step) use a form library bound to the shared schema.
- Pending state comes from the mutation, never a hand-rolled loading flag.

## Auth and access

Guards are components that render a skeleton while identity loads, a redirect when signed out, and the content otherwise. The tenant is part of the URL in multi-tenant apps. A fix to session handling covers every app through shared logic.

## Internationalisation

When a product is multilingual, every user-facing string goes through translation keys organised per app, every supported language ships in the same change, the locale is resolved from the path and remembered, the server renders in the right locale, and money and dates use locale-aware formatters.

## Structure

```
app/
  routes/             route modules (thin: load, meta, compose features)
  features/<domain>/  keys, queries, mutations, and the domain's components
  components/         shared app components
  components/ui/      owned copies of design-system primitives
  stores/             client-state stores, one per concern
  lib/                api client, formatting, small pure helpers
  providers/
```

Feature folders keep a domain's data access and UI together. Routes stay thin and compose features.

## Accessibility and resilience

Semantic elements before roles; current-page and busy states announced; decorative icons hidden; colour always paired with text; reduced motion respected. Error boundaries on every route. Degrade to a placeholder when data is unavailable, never show NaN or broken layout.

## Testing

Test hooks and pure logic directly; component-test the money, billing and permission UI through a shared provider wrapper; name tests for behaviour; reserve end-to-end tests for the few critical journeys. Before handoff: typecheck (including generated route types), build, test, and compare the running page with the approved mock at phone and desktop widths.
