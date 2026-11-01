# GamePriceCheck — Product Requirements Document

**Version:** 1.0 (MVP)  
**Last updated:** 2026-11-01  
**Source:** Project Specification (`Specification_1 (2).pdf`) and client interview

---

## 1. Project title and description

**GamePriceCheck** is a mobile-first web application that helps gamers and collectors find and compare prices for **physical** video games, gaming consoles, and gaming accessories. Instead of visiting several retailer and marketplace sites, users search once and see listings from multiple sellers side by side — with price, condition, availability, discount, and seller reliability — then follow a link to the seller's site to buy.

GamePriceCheck does **not** sell products, collect payments, process transactions, or ship anything. Digital downloads are out of scope.

### 1.1 Goals

- One search box for games, consoles, and accessories.
- Clear, comparable listings from multiple retailers and marketplace sellers.
- Simple filters (condition, price, retailer, developer, discount) usable by people with limited gaming knowledge.
- No account required for any v1 feature (works on shared school/work devices).

### 1.2 Users

| Group | Needs |
| --- | --- |
| **Casual gamers** (primary) | Find a specific game/console quickly; see who has it cheapest and in stock. |
| **Collectors / enthusiasts** (secondary) | Older and pre-owned items; filter by developer, release year, and condition; judge seller reliability. |
| **Non-gamers buying for others** | Simple categories and plain-language filters; no jargon required. |

### 1.3 Usage context

- Accessed from phones, tablets, and desktops — layouts are designed for phones first, then scaled up.
- Requires an internet connection for live prices; the PWA shell may load offline and show a friendly "you're offline" state.
- Typical flow: open app → search → filter/sort results → open product → compare sellers → go to seller's website.

### 1.4 Feature chart (from specification)

```
GamePriceCheck
├── Search
│   ├── Search games
│   ├── Search consoles
│   ├── Search accessories
│   └── Search by details (developer, release year, condition)
├── Compare Prices
│   ├── View prices
│   ├── Compare sellers
│   ├── View discounts
│   └── Check availability
├── Filter Results
│   ├── Filter by condition
│   ├── Filter by retailer
│   ├── Filter by price
│   └── Filter by developer
└── View Product
    ├── View details
    ├── View seller reliability
    ├── View product condition
    └── Go to website
```

### 1.5 User stories (v1 scope)

| # | Story |
| --- | --- |
| US-1 | As a gamer, I want to search for a video game by name so that I can quickly find available copies of the game I want. |
| US-2 | As a gamer, I want to search for a gaming console by name so that I can find available consoles from different sellers. |
| US-3 | As a gamer, I want to search for gaming accessories so that I can find accessories that meet my gaming needs. |
| US-4 | As a gamer, I want to view the prices of a product from different sellers so that I can determine how much the product costs at each seller. |
| US-5 | As a price-conscious gamer, I want to compare multiple sellers offering the same product so that I can choose the seller that provides the best option. |
| US-6 | As a gamer, I want to see whether a product is currently available from a seller so that I do not waste time visiting a listing for an unavailable product. |
| US-7 | As a gamer, I want to filter products by condition so that I only see products that are new, used, or refurbished based on my preference. |
| US-8 | As a price-conscious gamer, I want to filter search results by price so that I only see products within my budget. |
| US-9 | As a gamer, I want to view detailed information about a product so that I can determine whether it is the product I am looking for. |
| US-10 | As a gamer, I want to select a product listing and be redirected to the seller's website so that I can complete my purchase directly through the seller. |

Additional chart features carried into v1 scope: search by details (developer / release year), filter by retailer, filter by developer, view discounts, and view seller reliability.

### 1.6 Out of scope for v1 (future candidates)

- User accounts, login, and profiles
- Saved / watch-listed products
- Price-history charts, target prices, and price-drop alerts / notifications
- Digital game prices
- Any checkout, payment, or shipping

If account features are added later, only those personalized features will require login; search and comparison remain public.

---

## 2. Technical architecture

### 2.1 Overview

```
┌──────────────────────┐   HTTPS/JSON   ┌───────────────────────┐   adapters   ┌─────────────────────────┐
│  React PWA (client)  │ ─────────────▶ │  Express API (api)    │ ───────────▶ │ Retailer / marketplace  │
│  Vite, mobile-first  │ ◀───────────── │  search, normalize,   │ ◀─────────── │ APIs (eBay, Best Buy,   │
└──────────────────────┘                │  cache, rank          │              │ etc.)                   │
                                        └──────────┬────────────┘              └─────────────────────────┘
                                                   │ supabase-js (service role)
                                                   ▼
                                        ┌───────────────────────┐
                                        │ Supabase (Postgres)   │
                                        │ products, listings,   │
                                        │ sellers, cache        │
                                        └───────────────────────┘
```

The client talks **only** to the Express API. The API is the only component holding retailer API keys and the Supabase service-role key.

### 2.2 Front end — `/client`

| Concern | Choice |
| --- | --- |
| Framework | React 18 + Vite |
| Language | JavaScript (ES modules); TypeScript may be adopted later |
| Routing | React Router (URL holds search query + filters so results are shareable/bookmarkable) |
| Data fetching | TanStack Query (caching, loading/error states, retries) |
| Styling | CSS Modules or Tailwind; mobile-first breakpoints (base = phone, `md` = tablet, `lg` = desktop) |
| PWA | `vite-plugin-pwa` — manifest, icons, service worker caching the app shell (not prices) |
| Testing | Vitest + React Testing Library; Playwright for key end-to-end flows |
| Accessibility | WCAG 2.1 AA target: labeled inputs, 44px tap targets, keyboard navigable, sufficient contrast |

### 2.3 Back end — `/api`

| Concern | Choice |
| --- | --- |
| Runtime | Node.js 20 LTS + Express |
| Structure | `routes/` → `controllers/` → `services/` → `adapters/` (one adapter per data source) |
| Validation | `zod` for query/param validation |
| Data access | `@supabase/supabase-js` with the service-role key (server-side only) |
| Caching | Search results cached in Supabase (TTL ~15 min) to respect source rate limits |
| Security | `helmet`, CORS allow-list for the client origin, rate limiting (`express-rate-limit`) |
| Docs | OpenAPI 3 spec in `/docs/openapi.yaml` |
| Testing | Vitest/Jest + Supertest; adapters tested against recorded fixtures |

**Planned endpoints (v1)**

| Method | Path | Purpose |
| --- | --- | --- |
| GET | `/api/health` | Liveness check |
| GET | `/api/search?q=&category=&condition=&minPrice=&maxPrice=&retailer=&developer=&year=&sort=&page=` | Search + filter products |
| GET | `/api/products/:id` | Product details + all seller listings |
| GET | `/api/filters?category=` | Available filter values (retailers, developers, years) |
| GET | `/api/out/:listingId` | Logs the click, then 302-redirects to the seller URL |

### 2.4 Database — `/supabase`

Core tables (initial migration):

- `products` — id, title, category (`game` \| `console` \| `accessory`), platform, developer, release_year, image_url, description
- `sellers` — id, name, type (`retailer` \| `marketplace_seller`), website, reliability_score, reliability_source
- `listings` — id, product_id, seller_id, source, price, original_price, currency, condition (`new` \| `used` \| `refurbished`), in_stock, url, last_checked_at
- `search_cache` — query hash, response JSON, expires_at
- `outbound_clicks` — listing_id, clicked_at (anonymous; no personal data)

Row Level Security is enabled on all tables; v1 has no public client access to Supabase (all reads go through the API).

### 2.5 Data sources

Prices come from **official retailer/marketplace APIs and affiliate feeds** (e.g. eBay Browse API, Best Buy Products API), accessed through per-source adapters that map responses into the common `listing` shape. Scraping sites against their terms of service is not permitted. Seller reliability uses the source's own signals (e.g. eBay feedback %) or a fixed rating for first-party retailers.

### 2.6 Hosting and environments

| Component | Local dev | Production (planned) |
| --- | --- | --- |
| Client | `vite` dev server on :5173 | Static host (Vercel or Netlify) |
| API | `node --watch` on :3000 | Node host (Render or Railway) |
| Database | Supabase CLI local stack or a dev project | Supabase hosted project |

Secrets live in `.env` files (never committed); each package provides `.env.example`.

### 2.7 Constraints

- Physical products only; no payments, carts, or shipping.
- No login required for any v1 feature; no personal data collected.
- Must be usable on a 360px-wide phone screen.
- Dependent on third-party API availability, quotas, and terms — results must show `last_checked_at` and degrade gracefully when a source fails.
- Prices are informational; the seller's site is the source of truth.

### 2.8 Non-functional requirements

- Search results returned in < 2 s (p95) on a cached query, < 5 s uncached.
- Lighthouse mobile scores ≥ 90 for Performance, Accessibility, Best Practices, PWA.
- API errors from one source must not fail the whole search.
