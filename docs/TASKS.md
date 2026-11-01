# GamePriceCheck — Task List

Tasks are grouped by feature (matching the spec's feature chart) and mapped to user stories (US-#, see [PRD.md](PRD.md#15-user-stories-v1-scope)). Task IDs are used in branch names and commit messages (see [WORKSPACE_RULES.md](WORKSPACE_RULES.md)).

---

## 0. Foundation

### T-01 — Scaffold React PWA client
- **Feature / story:** Foundation (all stories)
- **Description:** Create the Vite + React app in `/client` with React Router, TanStack Query, `vite-plugin-pwa`, lint/format config, and a mobile-first base layout (header with search, main content area).
- **Acceptance criteria:**
  - `npm run dev` in `/client` serves the app at `localhost:5173`.
  - `npm run build` produces a build with a valid web manifest and registered service worker.
  - Layout renders without horizontal scroll at 360px width.
  - ESLint and Prettier run with no errors.

### T-02 — Scaffold Express API
- **Feature / story:** Foundation (all stories)
- **Description:** Create the Express app in `/api` with `routes/controllers/services/adapters` folders, `helmet`, CORS, rate limiting, central error handler, and `GET /api/health`.
- **Acceptance criteria:**
  - `npm run dev` in `/api` serves on port 3000; `GET /api/health` returns `200 {"status":"ok"}`.
  - Unknown routes return a JSON 404; thrown errors return JSON 500 without stack traces in production.
  - CORS only allows the configured client origin.
  - `.env.example` lists every required variable.

### T-03 — Initial Supabase schema and seed data
- **Feature / story:** Foundation; US-1–US-10
- **Description:** Write the first migration creating `products`, `sellers`, `listings`, `search_cache`, `outbound_clicks` with enums, indexes, and RLS; add seed data covering games, consoles, and accessories with multiple sellers and conditions.
- **Acceptance criteria:**
  - Migration applies cleanly to an empty database and is re-runnable via `supabase db reset`.
  - Seed includes ≥ 10 products per category, ≥ 4 sellers, and listings in all three conditions, with some out of stock and some discounted.
  - RLS is enabled on every table.

### T-04 — OpenAPI spec
- **Feature / story:** Foundation
- **Description:** Document all v1 endpoints, parameters, and response schemas in `/docs/openapi.yaml`.
- **Acceptance criteria:**
  - Spec validates with an OpenAPI linter.
  - Every endpoint in PRD §2.3 is described with request params and example responses.

### T-05 — CI pipeline
- **Feature / story:** Foundation
- **Description:** GitHub Actions workflow running lint, tests, and build for `client` and `api` on every PR.
- **Acceptance criteria:**
  - Workflow runs on pull requests to `main` and `develop`.
  - A failing lint or test blocks the PR from merging (branch protection enabled).

---

## 1. Search

### T-10 — Data source adapter interface + first adapter
- **Feature / story:** Search; US-1, US-2, US-3, US-4
- **Description:** Define the adapter contract (`search(query, options) → Listing[]`) and implement the first real source adapter (e.g. eBay Browse API) plus a seed-data adapter for local development.
- **Acceptance criteria:**
  - Adapter output matches the normalized listing shape (price, original price, condition, in-stock, seller, URL, image).
  - Adapter unit tests pass against recorded fixtures (no live network in tests).
  - A failing/timing-out source is logged and skipped; other sources still return results.

### T-11 — Search endpoint
- **Feature / story:** Search; US-1, US-2, US-3
- **Description:** Implement `GET /api/search` that validates params, checks `search_cache`, queries adapters in parallel, merges/de-duplicates results into products, and caches the response.
- **Acceptance criteria:**
  - `q` is required (1–100 chars); invalid params return `400` with a message.
  - `category=game|console|accessory` restricts results to that category.
  - Repeat query within TTL is served from cache (verified by test).
  - Response is paginated (`page`, `pageSize`, `total`).

### T-12 — Home screen with search bar and category shortcuts
- **Feature / story:** Search; US-1, US-2, US-3
- **Description:** Build the Home screen: prominent search input, Games / Consoles / Accessories category buttons, and short "how it works" text.
- **Acceptance criteria:**
  - Submitting a search navigates to `/search?q=...`.
  - Tapping a category navigates to `/search?category=...` (or that category's browse screen).
  - Empty search shows inline validation and does not navigate.
  - Input has a visible label and works with the on-screen keyboard "Search" key.

### T-13 — Search results screen
- **Feature / story:** Search, Compare Prices; US-1, US-2, US-3, US-4
- **Description:** Render results as cards: image, title, platform, lowest price, number of sellers, condition badges, availability.
- **Acceptance criteria:**
  - Loading skeleton, empty state ("No results for …"), and error state with retry are all implemented.
  - Each card shows the lowest current price and how many sellers offer it.
  - URL reflects query, category, and filters; reloading the page restores the same results.
  - Single column on phones, grid on tablet/desktop.

### T-14 — Search by details (developer, release year)
- **Feature / story:** Search → Search by details
- **Description:** Support `developer` and `year` parameters in the API and expose them in an "Advanced search" section of the filter panel.
- **Acceptance criteria:**
  - `GET /api/search?q=zelda&developer=Nintendo&year=2017` returns only matching products.
  - The UI lets users pick developer and year from available values (from `/api/filters`).

---

## 2. Filter Results

### T-20 — Filters endpoint
- **Feature / story:** Filter Results; US-7, US-8
- **Description:** Implement `GET /api/filters` returning available retailers, developers, release years, and the min/max price for the current category/query.
- **Acceptance criteria:**
  - Response lists only values present in the data for the given category.
  - Covered by an integration test using seed data.

### T-21 — Filter panel UI (mobile bottom sheet)
- **Feature / story:** Filter Results; US-7, US-8
- **Description:** Build a filter panel that opens as a bottom sheet on phones and a sidebar on desktop, with Apply / Clear actions and active-filter chips on the results screen.
- **Acceptance criteria:**
  - Panel opens/closes with a button; focus is trapped while open and returns on close.
  - Active filters show as removable chips above results.
  - "Clear all" resets filters and the URL.

### T-22 — Filter by condition
- **Feature / story:** Filter Results; **US-7**
- **Description:** Multi-select New / Used / Refurbished filter, applied server-side.
- **Acceptance criteria:**
  - Selecting "Used" shows only products/listings with condition `used`.
  - Multiple conditions combine with OR.
  - Condition labels use plain language with a short tooltip explaining each.

### T-23 — Filter by price
- **Feature / story:** Filter Results; **US-8**
- **Description:** Min/max price inputs (and/or slider) applied server-side.
- **Acceptance criteria:**
  - Only listings with `minPrice ≤ price ≤ maxPrice` are returned.
  - `minPrice > maxPrice` shows a validation message and is not submitted.
  - Prices are shown and entered in USD with two decimals.

### T-24 — Filter by retailer and developer
- **Feature / story:** Filter Results → Filter by retailer / Filter by developer
- **Description:** Multi-select retailer and developer filters populated from `/api/filters`.
- **Acceptance criteria:**
  - Selecting one or more retailers returns only listings from those sellers.
  - Selecting a developer returns only products from that developer.

### T-25 — Sort results
- **Feature / story:** Compare Prices; US-5, US-8
- **Description:** Sort by price (low→high, high→low), biggest discount, and relevance.
- **Acceptance criteria:**
  - Sort is reflected in the URL and persists across pagination.
  - Default sort is relevance.

---

## 3. Compare Prices

### T-30 — Product detail endpoint
- **Feature / story:** View Product, Compare Prices; US-4, US-5, US-9
- **Description:** Implement `GET /api/products/:id` returning product details and all listings with seller info.
- **Acceptance criteria:**
  - Unknown id returns `404`.
  - Listings include price, original price, discount %, condition, in-stock, seller name, reliability, URL, and `last_checked_at`.

### T-31 — Seller comparison table
- **Feature / story:** Compare Prices; **US-4, US-5**
- **Description:** On the product screen, list every seller offer, sorted by price, with the best in-stock offer highlighted.
- **Acceptance criteria:**
  - Each row shows seller, price, condition, availability, and reliability.
  - The lowest in-stock price is visually marked "Best price".
  - On phones the table collapses into stacked rows with no horizontal scroll.
  - Listings can be sorted by price or reliability and filtered by condition in place.

### T-32 — Discount display
- **Feature / story:** Compare Prices → View discounts
- **Description:** Show discount badges ("-25%") and strikethrough original prices when `original_price > price`.
- **Acceptance criteria:**
  - Discount % is computed server-side and rounded to whole numbers.
  - No badge appears when there is no original price or no discount.
  - Results can be sorted by biggest discount (T-25).

### T-33 — Availability indicator
- **Feature / story:** Compare Prices → Check availability; **US-6**
- **Description:** Show "In stock" / "Out of stock" per listing; out-of-stock listings are de-emphasized and sorted last.
- **Acceptance criteria:**
  - Availability is shown in text (not color alone).
  - Out-of-stock listings appear below in-stock listings and their "Go to seller" button is labeled accordingly.
  - A "Hide out of stock" toggle is available and on by default in results.

---

## 4. View Product

### T-40 — Product detail screen
- **Feature / story:** View Product → View details; **US-9**
- **Description:** Product screen with image, title, platform, category, developer, release year, and description, above the seller comparison (T-31).
- **Acceptance criteria:**
  - Route is `/product/:id`; a deep link loads directly.
  - Loading, not-found, and error states are implemented.
  - Back navigation returns to the results with filters and scroll position intact.

### T-41 — Seller reliability display
- **Feature / story:** View Product → View seller reliability; US-5
- **Description:** Show a reliability indicator per seller (e.g. "Trusted retailer" or "98.7% positive feedback") with an info popover explaining its source.
- **Acceptance criteria:**
  - Every listing displays a reliability value or "Not rated".
  - The info popover states where the rating comes from.

### T-42 — Product condition display
- **Feature / story:** View Product → View product condition; US-7, US-9
- **Description:** Condition badge per listing plus any condition notes from the source (e.g. "disc only, no case").
- **Acceptance criteria:**
  - Badge text is one of New / Used / Refurbished.
  - Condition notes appear when the source provides them.

### T-43 — Go to seller website (outbound redirect)
- **Feature / story:** View Product → Go to website; **US-10**
- **Description:** "Go to seller" button hits `GET /api/out/:listingId`, which records an anonymous click and 302-redirects to the seller's URL in a new tab.
- **Acceptance criteria:**
  - Clicking opens the seller's page in a new tab (`rel="noopener noreferrer"`).
  - A row is inserted into `outbound_clicks` with no personal data.
  - Unknown listing id returns `404`; only URLs stored in `listings` can be redirected to (no open redirect).
  - A note near the button states purchases are completed on the seller's site.

---

## 5. Quality and release

### T-50 — Accessibility pass
- **Feature / story:** All stories (usable by non-gamers)
- **Acceptance criteria:** axe reports no serious/critical issues on Home, Results, Product screens; all flows are keyboard-operable.

### T-51 — Offline and error handling
- **Feature / story:** Usage context (internet required)
- **Acceptance criteria:** When offline, the app shell loads and shows an offline message instead of a blank screen; source failures show a non-blocking notice.

### T-52 — End-to-end tests
- **Feature / story:** US-1 → US-10 flow
- **Acceptance criteria:** Playwright test covers search → filter → product → go-to-seller on a mobile viewport and passes in CI.

### T-53 — Deployment
- **Feature / story:** Foundation
- **Description:** Deploy client, API, and Supabase; document in `/docs/DEPLOYMENT.md`.
- **Acceptance criteria:** Production URL serves the PWA, API health check passes, environment variables documented, Lighthouse mobile ≥ 90 in all categories.

---

## Story coverage

| Story | Tasks |
| --- | --- |
| US-1 Search games | T-10, T-11, T-12, T-13 |
| US-2 Search consoles | T-10, T-11, T-12, T-13 |
| US-3 Search accessories | T-10, T-11, T-12, T-13 |
| US-4 View prices | T-13, T-30, T-31 |
| US-5 Compare sellers | T-25, T-31, T-41 |
| US-6 Availability | T-33 |
| US-7 Filter by condition | T-21, T-22, T-42 |
| US-8 Filter by price | T-21, T-23, T-25 |
| US-9 Product details | T-30, T-40, T-42 |
| US-10 Redirect to seller | T-43 |
