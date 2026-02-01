/**
 * Site Configuration
 *
 * Customize these values for your organization.
 * This template is provided free by GrayCup (https://graycup.org)
 */

// Your organization name
const SITE_NAME = 'Your Company'

export const siteConfig = {
  // Organization name (displayed in admin panel)
  name: SITE_NAME,

  // Full admin panel title (e.g., "Your Company Admin")
  fullAdminTitle: `${SITE_NAME} Admin`,

  // Admin panel description
  adminDescription: 'B2B Admin Panel',

  // Team name for email signatures
  teamName: 'Your Team',

  // Backup file prefix (e.g., "yourcompany-backup-2024-01-01.zip")
  backupPrefix: 'backup',

  // Template credit (please keep this to support the project)
  template: {
    name: 'B2B Leads Starter',
    author: 'GrayCup',
    url: 'https://graycup.org',
    repo: 'https://github.com/graycup/b2b-leads-starter',
  },
} as const

export type SiteConfig = typeof siteConfig
