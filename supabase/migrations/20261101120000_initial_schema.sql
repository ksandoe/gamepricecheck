-- GamePriceCheck initial schema (T-03)
-- All reads/writes go through the Express API using the service-role key.
-- RLS is enabled with no policies, so the anon/authenticated roles have no access.

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------
create type public.product_category as enum ('game', 'console', 'accessory');
create type public.item_condition as enum ('new', 'used', 'refurbished');
create type public.seller_type as enum ('retailer', 'marketplace_seller');

-- ---------------------------------------------------------------------------
-- updated_at trigger helper
-- ---------------------------------------------------------------------------
create function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- products: one row per distinct physical product
-- ---------------------------------------------------------------------------
create table public.products (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 200),
  category public.product_category not null,
  platform text,
  developer text,
  release_year smallint check (release_year between 1970 and 2100),
  image_url text,
  description text,
  search_vector tsvector generated always as (
    to_tsvector(
      'english',
      coalesce(title, '') || ' ' || coalesce(platform, '') || ' ' || coalesce(developer, '')
    )
  ) stored,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index products_category_idx on public.products (category);
create index products_developer_idx on public.products (developer);
create index products_release_year_idx on public.products (release_year);
create index products_search_vector_idx on public.products using gin (search_vector);

create trigger products_set_updated_at
  before update on public.products
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- sellers: retailers (Best Buy) and marketplace sellers (an eBay store)
-- ---------------------------------------------------------------------------
create table public.sellers (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  type public.seller_type not null,
  website text not null,
  -- 0-100; null means "Not rated"
  reliability_score numeric(5, 2) check (reliability_score between 0 and 100),
  -- Where the score comes from, shown to users (e.g. "eBay feedback")
  reliability_source text,
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- listings: a seller's offer for a product at a point in time
-- ---------------------------------------------------------------------------
create table public.listings (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products (id) on delete cascade,
  seller_id uuid not null references public.sellers (id) on delete cascade,
  -- Data source adapter that produced the listing (e.g. 'ebay', 'bestbuy', 'seed')
  source text not null,
  -- The listing's id at the source, used to upsert on refresh
  external_id text not null,
  price numeric(10, 2) not null check (price >= 0),
  -- Pre-discount price when the seller shows one
  original_price numeric(10, 2) check (original_price >= 0),
  currency char(3) not null default 'USD',
  condition public.item_condition not null,
  condition_notes text,
  in_stock boolean not null default true,
  url text not null check (url ~ '^https://'),
  last_checked_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (source, external_id)
);

create index listings_product_id_idx on public.listings (product_id);
create index listings_seller_id_idx on public.listings (seller_id);
create index listings_price_idx on public.listings (price);
create index listings_condition_idx on public.listings (condition);

create trigger listings_set_updated_at
  before update on public.listings
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- search_cache: cached API responses to respect source rate limits
-- ---------------------------------------------------------------------------
create table public.search_cache (
  query_hash text primary key,
  response jsonb not null,
  created_at timestamptz not null default now(),
  expires_at timestamptz not null
);

create index search_cache_expires_at_idx on public.search_cache (expires_at);

-- ---------------------------------------------------------------------------
-- outbound_clicks: anonymous "Go to seller" clicks (no personal data)
-- ---------------------------------------------------------------------------
create table public.outbound_clicks (
  id bigint generated always as identity primary key,
  listing_id uuid references public.listings (id) on delete set null,
  clicked_at timestamptz not null default now()
);

create index outbound_clicks_listing_id_idx on public.outbound_clicks (listing_id);

-- ---------------------------------------------------------------------------
-- Row Level Security: on for every table, no policies (API-only access)
-- ---------------------------------------------------------------------------
alter table public.products enable row level security;
alter table public.sellers enable row level security;
alter table public.listings enable row level security;
alter table public.search_cache enable row level security;
alter table public.outbound_clicks enable row level security;
