# ADR 001: Shopify Integration Approach

## Status
Accepted

## Context
We need to integrate the Against The Odds store (aodrop.com) with our development workflow. The store exists but is not yet integrated programmatically.

## Decision
We will use a multi-layered approach:
1. **Shopify CLI** for theme development and local preview
2. **Admin API** for product management and store operations
3. **GitHub Actions** for automated deployments and syncing

## Rationale
- Shopify CLI provides the best developer experience for theme development
- Admin API gives us programmatic control over products, orders, and store configuration
- GitHub Actions enables CI/CD automation and keeps everything in version control

## Consequences
- Requires Shopify CLI installation and authentication
- Need to manage API credentials securely
- Can automate product sync and theme deployments
- Enables full integration with development workflow

## Alternatives Considered
- Direct API-only approach: More complex, less developer-friendly
- Shopify App development: Overkill for our current needs
- Manual management: Not scalable

## References
- [Shopify CLI Documentation](https://shopify.dev/docs/apps/tools/cli)
- [Shopify Admin API](https://shopify.dev/docs/api/admin)
