# Shopify Integration Context

## Store Information
- **Store Domain**: aodrop.com
- **Store URL**: https://aodrop.com
- **App Name**: AO
- **Client ID**: 775fc3aa250b20e6d3122dd39de5b028
- **API Version**: 2026-01

## API Endpoints
- **Admin API**: https://aodrop.com/admin/api/2026-01
- **Storefront API**: (if configured)
- **Theme API**: https://aodrop.com/admin/api/2026-01/themes.json

## Credentials Location
- Environment variables in `.env.local`
- GitHub Secrets for CI/CD
- Windows Credential Manager (optional)

## Common Operations
- Product sync: `scripts/products/sync.ps1`
- Theme development: `scripts/shopify/theme-dev.ps1`
- API testing: `scripts/shopify/test-connection.ps1`
- Browser automation: `scripts/shopify/browser/`

## Documentation
- Setup: `docs/SHOPIFY_SETUP.md`
- Manufacturing: `docs/MANUFACTURING.md`
