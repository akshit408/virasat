-- =============================================================================
-- VIRASAT v3.0 — SUPABASE MIGRATION 20260925000000_init_schema.sql
-- TEAM 3AM | SIH 2026
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. USERS TABLE
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    state VARCHAR(100),
    district VARCHAR(100),
    role VARCHAR(50) NOT NULL DEFAULT 'BUYER',
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. ARTISANS TABLE
CREATE TABLE IF NOT EXISTS artisans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    artisan_name VARCHAR(255) NOT NULL,
    bio TEXT,
    craft_specialty VARCHAR(255),
    experience_years INT DEFAULT 0,
    is_gi_certified BOOLEAN DEFAULT false,
    is_women_artisan BOOLEAN DEFAULT false,
    rating NUMERIC(3,2) DEFAULT 4.80,
    total_sales INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. PRODUCTS TABLE
CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    craft_category VARCHAR(100) NOT NULL,
    state_id VARCHAR(50) NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    district VARCHAR(100),
    city_cluster VARCHAR(100),
    price NUMERIC(10,2) NOT NULL,
    wholesale_price NUMERIC(10,2),
    moq INT DEFAULT 1,
    stock_count INT DEFAULT 10,
    image_url TEXT NOT NULL,
    image_urls TEXT[],
    is_gi_tagged BOOLEAN DEFAULT false,
    gi_tag_year INT,
    description TEXT,
    craft_story TEXT,
    materials VARCHAR(255),
    care_instructions TEXT,
    artisan_id UUID REFERENCES artisans(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. ORDERS TABLE
CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number VARCHAR(100) UNIQUE NOT NULL,
    buyer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    artisan_id UUID REFERENCES artisans(id) ON DELETE SET NULL,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INT NOT NULL DEFAULT 1,
    total_amount NUMERIC(10,2) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    shipping_address TEXT,
    tracking_number VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. WISHLIST TABLE
CREATE TABLE IF NOT EXISTS wishlist (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    buyer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(buyer_id, product_id)
);

-- 6. CART TABLE
CREATE TABLE IF NOT EXISTS cart (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    buyer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(buyer_id, product_id)
);

-- 7. B2B REQUESTS TABLE
CREATE TABLE IF NOT EXISTS b2b_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_name VARCHAR(255) NOT NULL,
    buyer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    artisan_id UUID REFERENCES artisans(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    quantity INT NOT NULL,
    budget NUMERIC(12,2),
    delivery_date DATE,
    requirements TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    quotation_amount NUMERIC(12,2),
    lead_time_days INT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. DISCOVER STATES TABLE
CREATE TABLE IF NOT EXISTS discover_states (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    capital VARCHAR(100),
    region VARCHAR(100),
    banner_url TEXT,
    culture_overview TEXT,
    famous_crafts TEXT[],
    gi_products TEXT[],
    key_districts TEXT[],
    total_artisans INT DEFAULT 0
);

-- 9. CRAFTS TABLE
CREATE TABLE IF NOT EXISTS crafts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    state_id VARCHAR(50),
    district VARCHAR(100),
    is_gi_tagged BOOLEAN DEFAULT false,
    image_path TEXT,
    story TEXT,
    popularity_score INT DEFAULT 90
);

-- 10. REVIEWS TABLE
CREATE TABLE IF NOT EXISTS reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    buyer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 11. GOVERNMENT SCHEMES TABLE
CREATE TABLE IF NOT EXISTS government_schemes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    scheme_name VARCHAR(255) NOT NULL,
    ministry VARCHAR(255),
    description TEXT,
    eligibility TEXT,
    portal_url TEXT,
    category VARCHAR(100)
);

-- 12. ADDRESSES TABLE
CREATE TABLE IF NOT EXISTS addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    street TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    district VARCHAR(100),
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(20) NOT NULL,
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 13. NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'INFO',
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ADDITIONAL HELPER TABLES
CREATE TABLE IF NOT EXISTS artisan_clusters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cluster_name VARCHAR(255) NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL,
    craft_type VARCHAR(100),
    total_artisans INT DEFAULT 0,
    latitude NUMERIC(10,6),
    longitude NUMERIC(10,6)
);

CREATE TABLE IF NOT EXISTS translations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_id UUID NOT NULL,
    language_code VARCHAR(10) NOT NULL,
    field_name VARCHAR(100) NOT NULL,
    translated_text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- INDEXES
CREATE INDEX IF NOT EXISTS idx_products_state ON products(state_id);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(craft_category);
CREATE INDEX IF NOT EXISTS idx_products_artisan ON products(artisan_id);
CREATE INDEX IF NOT EXISTS idx_orders_buyer ON orders(buyer_id);
CREATE INDEX IF NOT EXISTS idx_orders_artisan ON orders(artisan_id);
CREATE INDEX IF NOT EXISTS idx_wishlist_buyer ON wishlist(buyer_id);
CREATE INDEX IF NOT EXISTS idx_cart_buyer ON cart(buyer_id);
CREATE INDEX IF NOT EXISTS idx_b2b_buyer ON b2b_requests(buyer_id);
CREATE INDEX IF NOT EXISTS idx_b2b_artisan ON b2b_requests(artisan_id);
CREATE INDEX IF NOT EXISTS idx_addresses_user ON addresses(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_product ON reviews(product_id);

-- ENABLE ROW LEVEL SECURITY
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE artisans ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE wishlist ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart ENABLE ROW LEVEL SECURITY;
ALTER TABLE b2b_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE discover_states ENABLE ROW LEVEL SECURITY;
ALTER TABLE crafts ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE government_schemes ENABLE ROW LEVEL SECURITY;
ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- POLICIES
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Public Read Products') THEN
        CREATE POLICY "Public Read Products" ON products FOR SELECT USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Public Read Discover States') THEN
        CREATE POLICY "Public Read Discover States" ON discover_states FOR SELECT USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Public Read Crafts') THEN
        CREATE POLICY "Public Read Crafts" ON crafts FOR SELECT USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Public Read Government Schemes') THEN
        CREATE POLICY "Public Read Government Schemes" ON government_schemes FOR SELECT USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Public Read Reviews') THEN
        CREATE POLICY "Public Read Reviews" ON reviews FOR SELECT USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow All Users') THEN
        CREATE POLICY "Allow All Users" ON users FOR ALL USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow All Artisans') THEN
        CREATE POLICY "Allow All Artisans" ON artisans FOR ALL USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow All Orders') THEN
        CREATE POLICY "Allow All Orders" ON orders FOR ALL USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow All Wishlist') THEN
        CREATE POLICY "Allow All Wishlist" ON wishlist FOR ALL USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow All Cart') THEN
        CREATE POLICY "Allow All Cart" ON cart FOR ALL USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow All B2B Requests') THEN
        CREATE POLICY "Allow All B2B Requests" ON b2b_requests FOR ALL USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow All Addresses') THEN
        CREATE POLICY "Allow All Addresses" ON addresses FOR ALL USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow All Notifications') THEN
        CREATE POLICY "Allow All Notifications" ON notifications FOR ALL USING (true);
    END IF;
END $$;

-- SUPABASE REALTIME PUBLICATION SETUP
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime') THEN
    CREATE PUBLICATION supabase_realtime;
  END IF;
END $$;

DO $$
BEGIN
  BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE orders;
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE cart;
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE wishlist;
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE b2b_requests;
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
END $$;

-- STORAGE BUCKETS SETUP
INSERT INTO storage.buckets (id, name, public)
VALUES 
  ('product-images', 'product-images', true),
  ('artisan-profiles', 'artisan-profiles', true),
  ('craft-gallery', 'craft-gallery', true),
  ('state-banners', 'state-banners', true),
  ('story-media', 'story-media', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- STORAGE POLICIES
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Public Read Storage Objects' AND tablename = 'objects') THEN
        CREATE POLICY "Public Read Storage Objects" ON storage.objects
          FOR SELECT USING (bucket_id IN ('product-images', 'artisan-profiles', 'craft-gallery', 'state-banners', 'story-media'));
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Public Insert Storage Objects' AND tablename = 'objects') THEN
        CREATE POLICY "Public Insert Storage Objects" ON storage.objects
          FOR INSERT WITH CHECK (bucket_id IN ('product-images', 'artisan-profiles', 'craft-gallery', 'state-banners', 'story-media'));
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Public Update Storage Objects' AND tablename = 'objects') THEN
        CREATE POLICY "Public Update Storage Objects" ON storage.objects
          FOR UPDATE USING (bucket_id IN ('product-images', 'artisan-profiles', 'craft-gallery', 'state-banners', 'story-media'));
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Public Delete Storage Objects' AND tablename = 'objects') THEN
        CREATE POLICY "Public Delete Storage Objects" ON storage.objects
          FOR DELETE USING (bucket_id IN ('product-images', 'artisan-profiles', 'craft-gallery', 'state-banners', 'story-media'));
    END IF;
END $$;
