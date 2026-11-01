-- Development seed data (T-03)
-- 10 products per category, 6 sellers, listings in every condition,
-- with some out of stock and some discounted (original_price > price).
-- Listing URLs point at each seller's real search page for the product title.

-- ---------------------------------------------------------------------------
-- Sellers
-- ---------------------------------------------------------------------------
insert into public.sellers (name, type, website, reliability_score, reliability_source) values
  ('Best Buy',        'retailer',           'https://www.bestbuy.com',   95.00, 'Major retailer'),
  ('GameStop',        'retailer',           'https://www.gamestop.com',  90.00, 'Major retailer'),
  ('Target',          'retailer',           'https://www.target.com',    93.00, 'Major retailer'),
  ('Walmart',         'retailer',           'https://www.walmart.com',   91.00, 'Major retailer'),
  ('RetroVaultGames', 'marketplace_seller', 'https://www.ebay.com',      99.20, 'eBay feedback'),
  ('ConsoleCorner',   'marketplace_seller', 'https://www.ebay.com',      97.80, 'eBay feedback');

-- ---------------------------------------------------------------------------
-- Products
-- ---------------------------------------------------------------------------
insert into public.products (title, category, platform, developer, release_year, description) values
  -- Games
  ('The Legend of Zelda: Tears of the Kingdom', 'game', 'Nintendo Switch', 'Nintendo', 2023,
    'Open-world action adventure across the skies and depths of Hyrule.'),
  ('Super Mario Odyssey', 'game', 'Nintendo Switch', 'Nintendo', 2017,
    '3D platformer where Mario travels the world with his sentient hat, Cappy.'),
  ('Elden Ring', 'game', 'PlayStation 5', 'FromSoftware', 2022,
    'Open-world action RPG set in the Lands Between.'),
  ('God of War Ragnarök', 'game', 'PlayStation 5', 'Santa Monica Studio', 2022,
    'Kratos and Atreus journey through the Nine Realms.'),
  ('Halo Infinite', 'game', 'Xbox Series X', '343 Industries', 2021,
    'Master Chief returns in an open-world Halo campaign.'),
  ('Red Dead Redemption 2', 'game', 'PlayStation 4', 'Rockstar Games', 2018,
    'Western epic following outlaw Arthur Morgan.'),
  ('The Last of Us Part II', 'game', 'PlayStation 4', 'Naughty Dog', 2020,
    'Story-driven action game set in a post-pandemic United States.'),
  ('Pokémon Scarlet', 'game', 'Nintendo Switch', 'Game Freak', 2022,
    'Open-world Pokémon adventure in the Paldea region.'),
  ('Super Mario 64', 'game', 'Nintendo 64', 'Nintendo', 1996,
    'Classic 3D platformer. Cartridge only unless noted.'),
  ('Halo 3', 'game', 'Xbox 360', 'Bungie', 2007,
    'Conclusion of the original Halo trilogy.'),
  -- Consoles
  ('Nintendo Switch OLED Model', 'console', 'Nintendo Switch', 'Nintendo', 2021,
    'Switch with a 7-inch OLED screen, wide adjustable stand, and 64 GB storage.'),
  ('Nintendo Switch Lite', 'console', 'Nintendo Switch', 'Nintendo', 2019,
    'Handheld-only Switch. Does not connect to a TV.'),
  ('PlayStation 5 Console', 'console', 'PlayStation 5', 'Sony', 2020,
    'PS5 with Ultra HD Blu-ray disc drive.'),
  ('PlayStation 5 Digital Edition', 'console', 'PlayStation 5', 'Sony', 2020,
    'PS5 without a disc drive. Physical games cannot be played.'),
  ('Xbox Series X', 'console', 'Xbox Series X', 'Microsoft', 2020,
    'Microsoft''s 4K console with disc drive and 1 TB storage.'),
  ('Xbox Series S', 'console', 'Xbox Series S', 'Microsoft', 2020,
    'Compact all-digital Xbox. No disc drive.'),
  ('PlayStation 4 Pro', 'console', 'PlayStation 4', 'Sony', 2016,
    'Enhanced PS4 with 4K output support.'),
  ('Nintendo 64 Console', 'console', 'Nintendo 64', 'Nintendo', 1996,
    'Classic 64-bit home console.'),
  ('Super Nintendo Entertainment System', 'console', 'SNES', 'Nintendo', 1991,
    'Classic 16-bit home console.'),
  ('Game Boy Advance SP', 'console', 'Game Boy Advance', 'Nintendo', 2003,
    'Clamshell handheld with a front-lit screen and rechargeable battery.'),
  -- Accessories
  ('DualSense Wireless Controller', 'accessory', 'PlayStation 5', 'Sony', 2020,
    'PS5 controller with haptic feedback and adaptive triggers.'),
  ('Xbox Wireless Controller', 'accessory', 'Xbox Series X', 'Microsoft', 2020,
    'Works with Xbox Series X|S, Xbox One, and PC.'),
  ('Nintendo Switch Pro Controller', 'accessory', 'Nintendo Switch', 'Nintendo', 2017,
    'Traditional-style controller for Nintendo Switch.'),
  ('Joy-Con Pair (Neon Red/Neon Blue)', 'accessory', 'Nintendo Switch', 'Nintendo', 2017,
    'Left and right Joy-Con controllers.'),
  ('DualSense Charging Station', 'accessory', 'PlayStation 5', 'Sony', 2020,
    'Charges two DualSense controllers at once.'),
  ('Xbox Rechargeable Battery + USB-C Cable', 'accessory', 'Xbox Series X', 'Microsoft', 2020,
    'Rechargeable battery pack for Xbox Wireless Controllers.'),
  ('SteelSeries Arctis Nova 7 Wireless Headset', 'accessory', 'Multi-platform', 'SteelSeries', 2022,
    'Wireless gaming headset for PC, PlayStation, and Switch.'),
  ('HyperX Cloud Stinger 2 Headset', 'accessory', 'Multi-platform', 'HyperX', 2022,
    'Lightweight wired gaming headset.'),
  ('PowerA Protection Case for Nintendo Switch', 'accessory', 'Nintendo Switch', 'PowerA', 2019,
    'Hard-shell carrying case with game card storage.'),
  ('Nintendo 64 Controller', 'accessory', 'Nintendo 64', 'Nintendo', 1996,
    'Original N64 controller.');

-- ---------------------------------------------------------------------------
-- Listings
-- (product title, seller name, condition, price, original price, in stock, notes)
-- ---------------------------------------------------------------------------
with data (title, seller, condition, price, original_price, in_stock, notes) as (
  values
    -- Games
    ('The Legend of Zelda: Tears of the Kingdom', 'Best Buy',        'new',         69.99, null,   true,  null),
    ('The Legend of Zelda: Tears of the Kingdom', 'Target',          'new',         59.99, 69.99,  true,  null),
    ('The Legend of Zelda: Tears of the Kingdom', 'GameStop',        'used',        49.99, null,   true,  'Case and cartridge'),
    ('Super Mario Odyssey',                       'Walmart',         'new',         49.99, 59.99,  true,  null),
    ('Super Mario Odyssey',                       'GameStop',        'used',        34.99, null,   true,  null),
    ('Super Mario Odyssey',                       'RetroVaultGames', 'used',        29.99, null,   true,  'Cartridge only, no case'),
    ('Elden Ring',                                'Best Buy',        'new',         39.99, 59.99,  true,  null),
    ('Elden Ring',                                'GameStop',        'used',        27.99, null,   false, null),
    ('Elden Ring',                                'ConsoleCorner',   'used',        24.50, null,   true,  'Disc has light scratches'),
    ('God of War Ragnarök',                       'Target',          'new',         49.99, 69.99,  true,  null),
    ('God of War Ragnarök',                       'Walmart',         'new',         44.00, 69.99,  false, null),
    ('God of War Ragnarök',                       'GameStop',        'used',        29.99, null,   true,  null),
    ('Halo Infinite',                             'Best Buy',        'new',         29.99, 59.99,  true,  null),
    ('Halo Infinite',                             'ConsoleCorner',   'used',        14.99, null,   true,  null),
    ('Red Dead Redemption 2',                     'Walmart',         'new',         24.99, 39.99,  true,  null),
    ('Red Dead Redemption 2',                     'GameStop',        'used',        14.99, null,   true,  'Includes map'),
    ('Red Dead Redemption 2',                     'RetroVaultGames', 'used',        12.00, null,   true,  null),
    ('The Last of Us Part II',                    'Target',          'new',         19.99, 39.99,  false, null),
    ('The Last of Us Part II',                    'GameStop',        'used',        11.99, null,   true,  null),
    ('Pokémon Scarlet',                           'Best Buy',        'new',         59.99, null,   true,  null),
    ('Pokémon Scarlet',                           'Target',          'new',         54.99, 59.99,  true,  null),
    ('Pokémon Scarlet',                           'ConsoleCorner',   'used',        39.99, null,   true,  null),
    ('Super Mario 64',                            'RetroVaultGames', 'used',        42.00, null,   true,  'Cartridge only, label worn'),
    ('Super Mario 64',                            'ConsoleCorner',   'used',        54.99, null,   true,  'Complete in box'),
    ('Super Mario 64',                            'GameStop',        'refurbished', 49.99, null,   false, 'Tested and cleaned'),
    ('Halo 3',                                    'RetroVaultGames', 'used',         7.99, null,   true,  null),
    ('Halo 3',                                    'GameStop',        'used',         9.99, null,   true,  null),
    -- Consoles
    ('Nintendo Switch OLED Model',                'Best Buy',        'new',        349.99, null,   true,  null),
    ('Nintendo Switch OLED Model',                'Walmart',         'new',        329.00, 349.99, true,  null),
    ('Nintendo Switch OLED Model',                'GameStop',        'refurbished',279.99, null,   true,  '90-day warranty'),
    ('Nintendo Switch OLED Model',                'ConsoleCorner',   'used',       249.99, null,   true,  'Includes dock and Joy-Con'),
    ('Nintendo Switch Lite',                      'Target',          'new',        199.99, null,   false, null),
    ('Nintendo Switch Lite',                      'GameStop',        'used',       139.99, null,   true,  null),
    ('Nintendo Switch Lite',                      'RetroVaultGames', 'used',       124.99, null,   true,  'Minor screen scratch'),
    ('PlayStation 5 Console',                     'Best Buy',        'new',        499.99, null,   true,  null),
    ('PlayStation 5 Console',                     'Target',          'new',        449.99, 499.99, true,  null),
    ('PlayStation 5 Console',                     'GameStop',        'refurbished',419.99, null,   true,  'Includes one controller'),
    ('PlayStation 5 Digital Edition',             'Walmart',         'new',        399.99, 449.99, true,  null),
    ('PlayStation 5 Digital Edition',             'ConsoleCorner',   'used',       329.00, null,   true,  null),
    ('Xbox Series X',                             'Best Buy',        'new',        499.99, null,   false, null),
    ('Xbox Series X',                             'Walmart',         'new',        479.00, 499.99, true,  null),
    ('Xbox Series X',                             'GameStop',        'used',       379.99, null,   true,  null),
    ('Xbox Series S',                             'Target',          'new',        299.99, null,   true,  null),
    ('Xbox Series S',                             'GameStop',        'refurbished',229.99, null,   true,  null),
    ('PlayStation 4 Pro',                         'GameStop',        'refurbished',249.99, null,   true,  null),
    ('PlayStation 4 Pro',                         'ConsoleCorner',   'used',       199.99, null,   true,  'Includes HDMI and power cable'),
    ('Nintendo 64 Console',                       'RetroVaultGames', 'used',       129.99, null,   true,  'Console, one controller, cables'),
    ('Nintendo 64 Console',                       'ConsoleCorner',   'refurbished',159.99, null,   true,  'Cleaned and tested'),
    ('Super Nintendo Entertainment System',       'RetroVaultGames', 'used',       119.99, null,   true,  null),
    ('Super Nintendo Entertainment System',       'GameStop',        'refurbished',149.99, null,   false, null),
    ('Game Boy Advance SP',                       'RetroVaultGames', 'used',        89.99, null,   true,  'AGS-101 backlit model'),
    ('Game Boy Advance SP',                       'ConsoleCorner',   'used',        74.99, null,   true,  'Charger not included'),
    -- Accessories
    ('DualSense Wireless Controller',             'Best Buy',        'new',         74.99, null,   true,  null),
    ('DualSense Wireless Controller',             'Target',          'new',         54.99, 74.99,  true,  null),
    ('DualSense Wireless Controller',             'GameStop',        'used',        44.99, null,   true,  null),
    ('Xbox Wireless Controller',                  'Walmart',         'new',         49.99, 59.99,  true,  null),
    ('Xbox Wireless Controller',                  'Best Buy',        'new',         59.99, null,   true,  null),
    ('Xbox Wireless Controller',                  'ConsoleCorner',   'used',        32.00, null,   true,  null),
    ('Nintendo Switch Pro Controller',            'Target',          'new',         69.99, null,   true,  null),
    ('Nintendo Switch Pro Controller',            'GameStop',        'refurbished', 54.99, null,   true,  null),
    ('Joy-Con Pair (Neon Red/Neon Blue)',         'Best Buy',        'new',         79.99, null,   true,  null),
    ('Joy-Con Pair (Neon Red/Neon Blue)',         'Walmart',         'new',         69.00, 79.99,  false, null),
    ('Joy-Con Pair (Neon Red/Neon Blue)',         'RetroVaultGames', 'used',        45.00, null,   true,  'Slight stick drift on left Joy-Con'),
    ('DualSense Charging Station',                'Best Buy',        'new',         29.99, null,   true,  null),
    ('DualSense Charging Station',                'Target',          'new',         24.99, 29.99,  true,  null),
    ('Xbox Rechargeable Battery + USB-C Cable',   'Walmart',         'new',         24.99, null,   true,  null),
    ('Xbox Rechargeable Battery + USB-C Cable',   'GameStop',        'new',         19.99, 24.99,  true,  null),
    ('SteelSeries Arctis Nova 7 Wireless Headset','Best Buy',        'new',        149.99, 179.99, true,  null),
    ('SteelSeries Arctis Nova 7 Wireless Headset','ConsoleCorner',   'refurbished',109.99, null,   true,  'Manufacturer refurbished'),
    ('HyperX Cloud Stinger 2 Headset',            'Walmart',         'new',         39.99, 49.99,  true,  null),
    ('HyperX Cloud Stinger 2 Headset',            'Target',          'new',         49.99, null,   true,  null),
    ('PowerA Protection Case for Nintendo Switch','Target',          'new',         19.99, null,   true,  null),
    ('PowerA Protection Case for Nintendo Switch','GameStop',        'new',         14.99, 19.99,  true,  null),
    ('Nintendo 64 Controller',                    'RetroVaultGames', 'used',        24.99, null,   true,  'Joystick tight'),
    ('Nintendo 64 Controller',                    'ConsoleCorner',   'used',        19.99, null,   true,  'Joystick slightly loose'),
    ('Nintendo 64 Controller',                    'GameStop',        'refurbished', 29.99, null,   false, null)
),
search_urls (seller, base) as (
  values
    ('Best Buy',        'https://www.bestbuy.com/site/searchpage.jsp?st='),
    ('GameStop',        'https://www.gamestop.com/search/?q='),
    ('Target',          'https://www.target.com/s?searchTerm='),
    ('Walmart',         'https://www.walmart.com/search?q='),
    ('RetroVaultGames', 'https://www.ebay.com/sch/i.html?_nkw='),
    ('ConsoleCorner',   'https://www.ebay.com/sch/i.html?_nkw=')
)
insert into public.listings (
  product_id, seller_id, source, external_id, price, original_price,
  condition, condition_notes, in_stock, url, last_checked_at
)
select
  p.id,
  s.id,
  'seed',
  'seed-' || row_number() over (order by d.title, d.seller),
  d.price,
  d.original_price,
  d.condition::public.item_condition,
  d.notes,
  d.in_stock,
  u.base || replace(d.title, ' ', '+'),
  now() - interval '30 minutes'
from data d
join public.products p on p.title = d.title
join public.sellers s on s.name = d.seller
join search_urls u on u.seller = d.seller;
