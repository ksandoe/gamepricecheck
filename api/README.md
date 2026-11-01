# api

Express API for GamePriceCheck. Aggregates listings from retailer/marketplace sources, normalizes them, and serves search, filter, and product-detail endpoints to the client.

```bash
cp .env.example .env
npm install
npm run dev        # http://localhost:3000, restarts on change
npm test           # Vitest + Supertest
npm run lint
```

## Structure

```
src/
  server.js       # entry point: loads .env, starts listening
  app.js          # createApp(config): middleware + routes (used by tests)
  config.js       # validated environment variables
  routes/         # URL -> controller wiring
  controllers/    # request/response handling
  services/       # business logic (search, caching, ranking)
  adapters/       # one module per price data source
  middleware/     # 404 and error handlers
  lib/            # Supabase client, HttpError
test/
```

## Endpoints

| Method | Path | Status |
| --- | --- | --- |
| GET | `/api/health` | Done: returns `{"status":"ok"}` |

Planned endpoints are listed in [../docs/PRD.md](../docs/PRD.md#23-back-end--api).
