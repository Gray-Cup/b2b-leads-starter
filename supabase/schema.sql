-- B2B Leads Starter - Supabase Database Schema
-- Run this SQL in your Supabase SQL Editor to create all required tables

-- =====================================================
-- 1. CONTACT SUBMISSIONS
-- General inquiries from the contact form
-- =====================================================
CREATE TABLE IF NOT EXISTS contact_submissions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  company TEXT NOT NULL,
  company_size TEXT NOT NULL CHECK (company_size IN ('1-49', '50-99', '100-249', '250-499', '500+')),
  message TEXT NOT NULL CHECK (char_length(message) >= 10 AND char_length(message) <= 2000),
  status TEXT,
  resolved BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE contact_submissions ENABLE ROW LEVEL SECURITY;

-- Policy for service role (full access)
CREATE POLICY "Service role has full access to contact_submissions"
  ON contact_submissions
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Policy for anonymous insert (for public form submissions)
CREATE POLICY "Anyone can insert contact_submissions"
  ON contact_submissions
  FOR INSERT
  WITH CHECK (true);

-- =====================================================
-- 2. QUOTE REQUESTS
-- Requests for price quotes on specific products
-- =====================================================
CREATE TABLE IF NOT EXISTS quote_requests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  company_name TEXT NOT NULL,
  contact_name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  product_id TEXT,
  grade TEXT,
  quantity INTEGER NOT NULL,
  message TEXT,
  status TEXT,
  resolved BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE quote_requests ENABLE ROW LEVEL SECURITY;

-- Policy for service role (full access)
CREATE POLICY "Service role has full access to quote_requests"
  ON quote_requests
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Policy for anonymous insert
CREATE POLICY "Anyone can insert quote_requests"
  ON quote_requests
  FOR INSERT
  WITH CHECK (true);

-- =====================================================
-- 3. SAMPLE REQUESTS
-- Requests for product samples (requires payment)
-- =====================================================
CREATE TABLE IF NOT EXISTS sample_requests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  company_name TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('Hotel', 'Restaurant', 'Cafe', 'Banquet Hall', 'Other')),
  other_category TEXT,
  gst TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT,
  address TEXT NOT NULL,
  selected_products TEXT[] NOT NULL,
  payment_status TEXT,
  resolved BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE sample_requests ENABLE ROW LEVEL SECURITY;

-- Policy for service role (full access)
CREATE POLICY "Service role has full access to sample_requests"
  ON sample_requests
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Policy for anonymous insert
CREATE POLICY "Anyone can insert sample_requests"
  ON sample_requests
  FOR INSERT
  WITH CHECK (true);

-- =====================================================
-- 4. FEEDBACK SUBMISSIONS
-- Customer feedback and ratings
-- =====================================================
CREATE TABLE IF NOT EXISTS feedback_submissions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  company TEXT NOT NULL,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  feedback_type TEXT NOT NULL CHECK (feedback_type IN ('Product Quality', 'Service', 'Delivery', 'Suggestion', 'Other')),
  rating TEXT NOT NULL CHECK (rating IN ('Excellent', 'Good', 'Average', 'Poor')),
  feedback TEXT NOT NULL,
  resolved BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE feedback_submissions ENABLE ROW LEVEL SECURITY;

-- Policy for service role (full access)
CREATE POLICY "Service role has full access to feedback_submissions"
  ON feedback_submissions
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Policy for anonymous insert
CREATE POLICY "Anyone can insert feedback_submissions"
  ON feedback_submissions
  FOR INSERT
  WITH CHECK (true);

-- =====================================================
-- 5. PRODUCT REQUESTS
-- Requests for products not currently in the catalog
-- =====================================================
CREATE TABLE IF NOT EXISTS product_requests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  company TEXT NOT NULL,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('Tea', 'Coffee', 'Other Beverages', 'Other')),
  product_name TEXT NOT NULL,
  quantity TEXT,
  details TEXT,
  status TEXT,
  resolved BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE product_requests ENABLE ROW LEVEL SECURITY;

-- Policy for service role (full access)
CREATE POLICY "Service role has full access to product_requests"
  ON product_requests
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Policy for anonymous insert
CREATE POLICY "Anyone can insert product_requests"
  ON product_requests
  FOR INSERT
  WITH CHECK (true);

-- =====================================================
-- 6. CALL REQUESTS
-- Requests for a callback from the sales team
-- =====================================================
CREATE TABLE IF NOT EXISTS call_requests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  company_name TEXT NOT NULL,
  agenda TEXT NOT NULL,
  resolved BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE call_requests ENABLE ROW LEVEL SECURITY;

-- Policy for service role (full access)
CREATE POLICY "Service role has full access to call_requests"
  ON call_requests
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Policy for anonymous insert
CREATE POLICY "Anyone can insert call_requests"
  ON call_requests
  FOR INSERT
  WITH CHECK (true);

-- =====================================================
-- INDEXES FOR BETTER QUERY PERFORMANCE
-- =====================================================

-- Index on resolved status for filtering
CREATE INDEX IF NOT EXISTS idx_contact_submissions_resolved ON contact_submissions(resolved);
CREATE INDEX IF NOT EXISTS idx_quote_requests_resolved ON quote_requests(resolved);
CREATE INDEX IF NOT EXISTS idx_sample_requests_resolved ON sample_requests(resolved);
CREATE INDEX IF NOT EXISTS idx_feedback_submissions_resolved ON feedback_submissions(resolved);
CREATE INDEX IF NOT EXISTS idx_product_requests_resolved ON product_requests(resolved);
CREATE INDEX IF NOT EXISTS idx_call_requests_resolved ON call_requests(resolved);

-- Index on created_at for sorting by date
CREATE INDEX IF NOT EXISTS idx_contact_submissions_created_at ON contact_submissions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_quote_requests_created_at ON quote_requests(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_sample_requests_created_at ON sample_requests(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_feedback_submissions_created_at ON feedback_submissions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_product_requests_created_at ON product_requests(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_call_requests_created_at ON call_requests(created_at DESC);

-- Composite index for common query patterns (unresolved items sorted by date)
CREATE INDEX IF NOT EXISTS idx_contact_submissions_unresolved ON contact_submissions(resolved, created_at DESC) WHERE resolved = false;
CREATE INDEX IF NOT EXISTS idx_quote_requests_unresolved ON quote_requests(resolved, created_at DESC) WHERE resolved = false;
CREATE INDEX IF NOT EXISTS idx_sample_requests_unresolved ON sample_requests(resolved, created_at DESC) WHERE resolved = false;
CREATE INDEX IF NOT EXISTS idx_feedback_submissions_unresolved ON feedback_submissions(resolved, created_at DESC) WHERE resolved = false;
CREATE INDEX IF NOT EXISTS idx_product_requests_unresolved ON product_requests(resolved, created_at DESC) WHERE resolved = false;
CREATE INDEX IF NOT EXISTS idx_call_requests_unresolved ON call_requests(resolved, created_at DESC) WHERE resolved = false;
