# Shopify Integration Context

## Store Information

- **Store Domain**: aodrop.com
- **Store URL**: https://aodrop.com
- **App Name**: AO
- **Client ID**: your_shopify_api_key_here (set in .env.local as SHOPIFY_API_KEY)
- **API Version**: 2026-01
- **Theme ID**: Set in .env.local as SHOPIFY_THEME_ID; get via `shopify theme list` or Shopify Admin → Online Store → Themes → theme URL. Theme source in repo: `src/shopify/themes/aodrop-theme/`. Connected branch for GitHub: `shopify-theme` (subtree from main).

## API Endpoints

- **Admin API**: https://aodrop.com/admin/api/2026-01
- **Storefront API**: (if configured)
- **Theme API**: https://aodrop.com/admin/api/2026-01/themes.json

## Credentials Location

- Environment variables in `.env.local`
- GitHub Secrets for CI/CD
- Windows Credential Manager (optional)

## Common Operations

- **Bulk product sync (repo → store):** `scripts/shopify/sync-products.ps1` (use `-DryRun` to preview); used by CI and workflow.
- **Bidirectional wrapper:** `scripts/products/sync.ps1` (delegates import to sync-products.ps1; use `-Direction import|export|both`).
- Theme development: `scripts/shopify/theme-dev.ps1`
- API testing: `scripts/shopify/test-connection.ps1`
- Browser automation: `scripts/shopify/browser/`

## Documentation (agent: where to find product/theme info)

- **Workflow (store updates)**: `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md` — products, theme, **preview-before-apply** (pending-approval.md → open-pending-approval.ps1; for theme also start-theme-preview.ps1), approval in chat, deploy-log.
- **Update from Cursor**: `docs/UPDATE_SHOPIFY_FROM_CURSOR.md`
- **Setup**: `docs/SHOPIFY_SETUP.md`
- **Product data**: `data/products/*.json` (source of truth for sync); schema: `data/products/example-hoodie.json`.
- **Theme source**: `src/shopify/themes/aodrop-theme/` (layout, sections, templates, assets).
- **Manufacturing**: `docs/MANUFACTURING.md`
