# GamePriceCheck

A mobile-first web app that helps gamers and collectors find and compare prices for **physical** video games, consoles, and accessories across multiple retailers and sellers. GamePriceCheck does not sell products or process payments — it sends users to the seller's site to buy.

## Repository layout

```
/client/     # React PWA (local dev: Vite)
/api/        # Express API (local dev: Node)
/supabase/   # SQL migrations + seeds
/docs/       # PRD, site map, OpenAPI, deployment notes
```

## Documentation

| Doc | Purpose |
| --- | --- |
| [docs/PRD.md](docs/PRD.md) | Product requirements and technical architecture |
| [docs/TASKS.md](docs/TASKS.md) | Development task list mapped to user stories |
| [docs/WORKSPACE_RULES.md](docs/WORKSPACE_RULES.md) | Naming, commits, PRs, branching |
| [docs/SITE_MAP.md](docs/SITE_MAP.md) | Hierarchical site map of all screens |

The original project specification is in [Specification_1 (2).pdf](<Specification_1 (2).pdf>).

## Tech stack

- **Client:** React + Vite, installable PWA, mobile-first
- **API:** Node.js + Express
- **Database:** Supabase (PostgreSQL)

## Getting started

Prerequisites: Node.js 22+, and Docker if you want to run Supabase locally.

```bash
# API (http://localhost:3000)
cd api
cp .env.example .env
npm install
npm run dev
```

```bash
# Client (http://localhost:5173, proxies /api to the API)
cd client
npm install
npm run dev
```

```bash
# Database: local Supabase with migrations + seed data
npx supabase start
npx supabase db reset
```

Copy the `API URL` and `service_role key` printed by `npx supabase status` into `api/.env`.

Each package has `npm run lint`, `npm test`, and `npm run format`; the client also has `npm run build`.
