# GamePriceCheck — Workspace Rules

## 1. Naming conventions

### Files and folders
| Item | Convention | Example |
| --- | --- | --- |
| React components | `PascalCase.jsx`, one component per file | `ProductCard.jsx` |
| Hooks | `camelCase`, prefixed `use` | `useSearchParamsState.js` |
| Other JS modules | `camelCase.js` | `formatPrice.js` |
| CSS Modules | match component | `ProductCard.module.css` |
| Folders | `kebab-case` | `filter-panel/` |
| Tests | same name + `.test.js(x)` next to the source | `ProductCard.test.jsx` |
| Express routes | plural resource nouns | `routes/products.js` |
| Adapters | source name + `Adapter` | `adapters/ebayAdapter.js` |
| SQL migrations | `YYYYMMDDHHMMSS_snake_description.sql` | `20261101120000_initial_schema.sql` |
| Docs | `UPPER_SNAKE.md` | `SITE_MAP.md` |

### Code
- Variables and functions: `camelCase`. Components and classes: `PascalCase`. Constants: `UPPER_SNAKE_CASE`.
- Booleans read as questions: `isLoading`, `hasDiscount`, `inStock`.
- Event handlers: `handleX` inside components, `onX` for props.
- Database: `snake_case` table and column names; tables are plural (`listings`); foreign keys are `<singular>_id` (`product_id`).
- API: URL paths are lowercase plural nouns (`/api/products/:id`); query params and JSON fields are `camelCase` (`minPrice`, `lastCheckedAt`). The API maps `snake_case` DB columns to `camelCase` JSON.
- Environment variables: `UPPER_SNAKE_CASE`; client-exposed vars must start with `VITE_`.

### Formatting
- Prettier (2-space indent, single quotes, semicolons, 100-char lines) and ESLint are the source of truth; run them before committing.

## 2. Commit message guidelines

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary in imperative mood>

<optional body: what and why, wrapped at 72 chars>

Refs: T-22, US-7
```

- **type:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `build`, `ci`, `perf`
- **scope:** `client`, `api`, `db`, `docs`, `ci` (or a feature area such as `search`, `filters`)
- **summary:** ≤ 72 chars, imperative ("add", not "added"), no trailing period
- Reference the task ID (and story) in the footer.
- One logical change per commit; never commit `.env` files, secrets, or build output.

Examples:
```
feat(api): add condition filter to search endpoint

Refs: T-22, US-7
```
```
fix(client): keep filter chips after navigating back from product
```

## 3. Branching strategy

Lightweight **GitHub Flow with a `develop` integration branch**:

| Branch | Purpose | Rules |
| --- | --- | --- |
| `main` | Production-ready; deployed | Protected. Changes only via PR from `develop` (release) or `hotfix/*`. |
| `develop` | Integration of completed features | Protected. Changes only via PR. CI must pass. |
| `feature/T-<id>-<short-desc>` | New work for one task | Branch from `develop`; e.g. `feature/T-22-condition-filter` |
| `fix/T-<id>-<short-desc>` | Non-urgent bug fix | Branch from `develop` |
| `hotfix/<short-desc>` | Urgent production fix | Branch from `main`; merge to `main` **and** `develop` |
| `docs/<short-desc>` | Documentation only | Branch from `develop` |

- Keep branches short-lived (ideally < 3 days); rebase on or merge in `develop` regularly.
- Delete branches after merge.
- Tag releases on `main` with semantic versions (`v1.0.0`).

## 4. Pull request and review process

1. **Open a PR** from your branch into `develop` (or `main` for hotfixes/releases).
2. **Title** follows the commit format: `feat(client): add filter bottom sheet (T-21)`.
3. **Description** includes:
   - What changed and why
   - Linked task / story (`Closes T-21`, `US-7`)
   - How to test (steps, screenshots or screen recording for UI changes — include a phone-width screenshot)
   - Any migrations or new environment variables
4. **Checks required before merge:**
   - CI green (lint, tests, build)
   - At least **1 approving review** from someone other than the author
   - All review conversations resolved
   - Acceptance criteria from [TASKS.md](TASKS.md) met
5. **Reviewer checklist:**
   - Code is readable and follows these naming conventions
   - Tests cover new behavior; no unrelated changes
   - No secrets, API keys, or personal data committed
   - UI works at 360px width and is keyboard accessible
   - API changes are reflected in `docs/openapi.yaml`
6. **Merge** using **squash and merge** so each PR is one Conventional Commit on `develop`. Delete the branch afterward.
7. Keep PRs small (aim for < 400 changed lines); split large work into multiple PRs.
