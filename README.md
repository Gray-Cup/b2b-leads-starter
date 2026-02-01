# B2B Leads Starter

A Turborepo monorepo containing B2B admin panel and storefront applications.

## Quick Start

```bash
# Install dependencies
pnpm install

# Set up Supabase tables (run supabase/schema.sql in SQL Editor)

# Start development
pnpm dev
```

## Apps

| App | Port | Description |
|-----|------|-------------|
| `@b2b/storefront` | 3000 | Customer-facing storefront |
| `@b2b/admin` | 3001 | Admin panel for lead management |

## Documentation

See [usage.md](usage.md) for detailed setup instructions and Supabase table documentation.

## Database

Run `supabase/schema.sql` in your Supabase SQL Editor to create all required tables.
