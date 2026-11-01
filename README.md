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

Setup instructions will be added as the `client` and `api` packages are scaffolded (see tasks T-01 to T-03 in [docs/TASKS.md](docs/TASKS.md)).
