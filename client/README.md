# client

React PWA for GamePriceCheck, built with Vite. Mobile-first.

```bash
npm install
npm run dev        # http://localhost:5173 (proxies /api to localhost:3000)
npm test           # Vitest + React Testing Library
npm run lint
npm run build      # production build with service worker + web manifest
```

## Structure

```
src/
  api/          # fetch wrapper for the Express API
  components/   # shared UI (Layout, SearchBar)
  pages/        # one component per route
  styles/       # global CSS and design tokens
  test/         # test setup
```

## Routes

| Route | Page |
| --- | --- |
| `/` | Home: search and category shortcuts |
| `/search` | Search results (placeholder until T-13) |
| `/product/:id` | Product detail (placeholder until T-40) |
| `/about` | About and condition guide |
| `*` | Not found |

Set `VITE_API_URL` (see `.env.example`) when the API is on a different origin.
