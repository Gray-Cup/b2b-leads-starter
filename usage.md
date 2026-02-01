# B2B Leads Starter - Usage Guide

This is a Turborepo monorepo containing a B2B admin panel and storefront.

## Prerequisites

- Node.js 18+
- pnpm 9+
- Supabase account

## Getting Started

### 1. Install Dependencies

```bash
pnpm install
```

### 2. Set Up Supabase Tables

Before running the applications, you need to create the required database tables in Supabase.

1. Go to your Supabase project dashboard
2. Navigate to **SQL Editor**
3. Copy the contents of `supabase/schema.sql` and run it

This will create all required tables with proper RLS policies.

### 3. Configure Environment Variables

#### Admin App (`apps/admin/.env`)

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
NEXT_PUBLIC_TURNSTILE_SITE_KEY=your_turnstile_key
```

#### Storefront App (`apps/storefront/.env`)

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
NEXT_PUBLIC_MEDUSA_BACKEND_URL=your_medusa_backend_url
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=your_publishable_key
```

### 4. Run Development Servers

```bash
# Run all apps
pnpm dev

# Run only admin
pnpm dev:admin

# Run only storefront
pnpm dev:storefront
```

### 5. Build for Production

```bash
# Build all apps
pnpm build

# Build specific app
pnpm build:admin
pnpm build:storefront
```

---

## Supabase Tables Overview

The following tables need to be created in your Supabase project. Run `supabase/schema.sql` to create all tables automatically.

| Table | Purpose | Key Fields |
|-------|---------|------------|
| `contact_submissions` | General contact form inquiries | company, email, message |
| `quote_requests` | Product price quote requests | product_id, quantity, grade |
| `sample_requests` | Free sample requests (with payment) | selected_products, payment_status |
| `feedback_submissions` | Customer feedback and ratings | feedback_type, rating |
| `product_requests` | Requests for new products not in catalog | category, product_name |
| `call_requests` | Request for callback from sales team | phone, agenda |

### Table Details

#### 1. contact_submissions
General inquiries from the contact form.
- `id` (UUID) - Primary key
- `name` (TEXT) - Contact person's name
- `email` (TEXT) - Business email
- `company` (TEXT) - Company name
- `company_size` (TEXT) - "1-49", "50-99", "100-249", "250-499", "500+"
- `message` (TEXT) - Inquiry message
- `status` (TEXT) - Custom status field
- `resolved` (BOOLEAN) - Default: false
- `created_at` (TIMESTAMPTZ) - Submission timestamp

#### 2. quote_requests
Requests for price quotes on specific products.
- `id` (UUID) - Primary key
- `company_name` (TEXT) - Company name
- `contact_name` (TEXT) - Contact person's name
- `email` (TEXT) - Contact email
- `phone` (TEXT) - Phone number
- `product_id` (TEXT) - Product slug
- `grade` (TEXT) - Selected product grade
- `quantity` (INTEGER) - Requested quantity
- `message` (TEXT) - Additional requirements
- `status` (TEXT) - Custom status field
- `resolved` (BOOLEAN) - Default: false
- `created_at` (TIMESTAMPTZ) - Submission timestamp

#### 3. sample_requests
Requests for product samples (requires payment).
- `id` (UUID) - Primary key
- `company_name` (TEXT) - Company name
- `category` (TEXT) - "Hotel", "Restaurant", "Cafe", "Banquet Hall", "Other"
- `other_category` (TEXT) - Custom category if "Other"
- `gst` (TEXT) - GST number
- `phone` (TEXT) - Contact phone
- `email` (TEXT) - Contact email
- `address` (TEXT) - Delivery address
- `selected_products` (TEXT[]) - Array of product IDs
- `payment_status` (TEXT) - Payment status
- `resolved` (BOOLEAN) - Default: false
- `created_at` (TIMESTAMPTZ) - Submission timestamp

#### 4. feedback_submissions
Customer feedback and ratings.
- `id` (UUID) - Primary key
- `company` (TEXT) - Company name
- `name` (TEXT) - Contact person's name
- `email` (TEXT) - Contact email
- `feedback_type` (TEXT) - "Product Quality", "Service", "Delivery", "Suggestion", "Other"
- `rating` (TEXT) - "Excellent", "Good", "Average", "Poor"
- `feedback` (TEXT) - Detailed feedback text
- `resolved` (BOOLEAN) - Default: false
- `created_at` (TIMESTAMPTZ) - Submission timestamp

#### 5. product_requests
Requests for products not currently in the catalog.
- `id` (UUID) - Primary key
- `company` (TEXT) - Company name
- `name` (TEXT) - Contact person's name
- `email` (TEXT) - Contact email
- `phone` (TEXT) - Contact phone
- `category` (TEXT) - "Tea", "Coffee", "Other Beverages", "Other"
- `product_name` (TEXT) - Name of requested product
- `quantity` (TEXT) - Expected quantity
- `details` (TEXT) - Additional details
- `status` (TEXT) - Custom status field
- `resolved` (BOOLEAN) - Default: false
- `created_at` (TIMESTAMPTZ) - Submission timestamp

#### 6. call_requests
Requests for a callback from the sales team.
- `id` (UUID) - Primary key
- `name` (TEXT) - Contact person's name
- `phone` (TEXT) - Phone number
- `company_name` (TEXT) - Company name
- `agenda` (TEXT) - Purpose of the call
- `resolved` (BOOLEAN) - Default: false
- `created_at` (TIMESTAMPTZ) - Submission timestamp

---

## Project Structure

```
b2b-leads-starter/
├── apps/
│   ├── admin/          # Admin panel (Next.js)
│   │   ├── app/        # App router pages
│   │   ├── lib/        # Utilities and Supabase client
│   │   └── public/     # Static assets
│   │
│   └── storefront/     # Customer-facing storefront (Next.js)
│       ├── src/        # Source files
│       └── public/     # Static assets
│
├── supabase/
│   └── schema.sql      # Database schema
│
├── turbo.json          # Turborepo configuration
├── pnpm-workspace.yaml # pnpm workspace config
└── package.json        # Root package.json
```

---

## Ports

| App | Development Port |
|-----|-----------------|
| Storefront | 3000 |
| Admin | 3001 |

---

## Common Commands

```bash
# Install dependencies
pnpm install

# Development
pnpm dev              # Run all apps
pnpm dev:admin        # Run admin only
pnpm dev:storefront   # Run storefront only

# Build
pnpm build            # Build all apps
pnpm build:admin      # Build admin only
pnpm build:storefront # Build storefront only

# Lint
pnpm lint             # Lint all apps
```
