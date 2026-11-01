# supabase

- `config.toml` — Supabase CLI config for the local stack
- `migrations/` — ordered SQL migrations (`YYYYMMDDHHMMSS_description.sql`)
- `seeds/` — development seed data, loaded in filename order on `db reset`

## Schema

| Table | Purpose |
| --- | --- |
| `products` | One row per physical product (game, console, accessory), with full-text `search_vector` |
| `sellers` | Retailers and marketplace sellers, with reliability score and its source |
| `listings` | A seller's offer for a product: price, original price, condition, stock, URL |
| `search_cache` | Cached API search responses with an expiry |
| `outbound_clicks` | Anonymous "Go to seller" clicks |

RLS is enabled on every table with no policies, so only the API (using the service-role key) can read or write.

## Local development

Requires [Docker](https://docs.docker.com/get-docker/) for the local Supabase stack.

```bash
npx supabase start      # start local Postgres, API, Studio
npx supabase db reset   # apply migrations + seeds from scratch
npx supabase status     # print local URL and service-role key for api/.env
```

New migration:

```bash
npx supabase migration new <snake_description>
```
