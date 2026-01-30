# Shopify Setup Guide

## Complete Shopify Integration for Against The Odds

This guide provides step-by-step instructions for setting up complete Shopify integration with the aodrop.com store.

## Prerequisites

- Shopify store: `aodrop.com`
- Domain connected via Cloudflare
- Shopify Partner account (recommended for development)
- Node.js and npm installed

## Shopify–GitHub App (connected)

Shopify is connected to this repository via the **Shopify GitHub App**. That integration typically:

- **Theme deploys**: Pushes to the connected branch (e.g. `main`) can trigger theme deployment from Shopify’s side. You may not need GitHub Actions to deploy the theme if the app is handling it.
- **Repo link**: Configured in Shopify Admin (e.g. Settings → Apps and sales channels → GitHub, or your app’s connection settings).
- **GitHub Actions**: Workflows in this repo that call the Shopify API (e.g. product sync, backups, `deploy.yml` theme step) still use **GitHub Actions secrets** (`SHOPIFY_ACCESS_TOKEN`, `SHOPIFY_STORE_DOMAIN`, `SHOPIFY_THEME_ID`). Keep those set in the repo if you use those workflows.

## Step 1: Shopify CLI Installation

### Install Shopify CLI

```powershell
# Install globally
npm install -g @shopify/cli @shopify/theme

# Verify installation
shopify version
```

### Install Shopify CLI for Windows (Alternative)

If npm installation fails, download from:
https://github.com/Shopify/cli/releases

## Step 2: Shopify Partner Account Setup

1. **Create Partner Account** (if needed):
   - Go to: https://partners.shopify.com/
   - Sign up for free Partner account
   - Access Partner Dashboard

2. **Create Development Store**:
   - In Partner Dashboard, click "Stores" → "Add store"
   - Choose "Development store"
   - Name: "Against The Odds - Development"
   - Or use existing store: `aodrop.com`

## Step 3: Authenticate Shopify CLI

```powershell
# Authenticate with Shopify
shopify auth login

# Follow the prompts:
# 1. Select your Partner account
# 2. Authorize the CLI
# 3. Select your store (aodrop.com)
```

## Step 4: Generate API Credentials

### Admin API Access

1. **Via Shopify Admin**:
   - Go to: https://aodrop.com/admin/settings/apps/development
   - Click "Create custom app"
   - Name: "Against The Odds - API Access"
   - Configure Admin API scopes:
     - `read_products`
     - `write_products`
     - `read_orders`
     - `write_orders`
     - `read_themes`
     - `write_themes`
     - `read_customers`
     - `read_inventory`
   - Install app
   - Copy API credentials:
     - API Key
     - API Secret Key
     - Admin API access token

2. **Store Credentials Securely**:
   ```powershell
   # Add to .env.local
   SHOPIFY_API_KEY=your_api_key
   SHOPIFY_API_SECRET=your_api_secret
   SHOPIFY_ACCESS_TOKEN=your_access_token
   SHOPIFY_STORE_DOMAIN=aodrop.com
   ```

### Storefront API Access

1. **Enable Storefront API**:
   - Go to: https://aodrop.com/admin/settings/apps/development
   - Create custom app for Storefront API
   - Configure scopes:
     - `unauthenticated_read_product_listings`
     - `unauthenticated_read_product_inventory`
     - `unauthenticated_read_checkouts`
   - Copy Storefront API access token

## Step 5: Link CLI to Store

```powershell
# Navigate to project directory
cd C:\Users\LegiT\against-the-odds

# Link to store
shopify theme dev --store=aodrop.com

# Or for app development
shopify app dev
```

## Step 6: Test API Connectivity

### Test Script

Create a test script to verify API access:

```powershell
# scripts/shopify/test-connection.ps1
$store = $env:SHOPIFY_STORE_DOMAIN
$token = $env:SHOPIFY_ACCESS_TOKEN

$headers = @{
    "X-Shopify-Access-Token" = $token
}

$response = Invoke-RestMethod -Uri "https://$store/admin/api/2026-01/shop.json" -Headers $headers -Method Get
Write-Host "Store Name: $($response.shop.name)" -ForegroundColor Green
```

Run the test:

```powershell
.\scripts\shopify\test-connection.ps1
```

## Step 7: Theme Development Setup

### Initialize Theme Development

```powershell
# Create theme directory structure
New-Item -ItemType Directory -Force -Path "src\shopify\themes\aodrop-theme"

# Pull existing theme (if store has a theme)
shopify theme pull --store=aodrop.com --theme=live --path=src/shopify/themes/aodrop-theme

# Or create new theme
shopify theme init --path=src/shopify/themes/aodrop-theme
```

### Local Development

```powershell
# Start local development server
shopify theme dev --store=aodrop.com --theme=live

# This will:
# - Start local server on http://localhost:9292
# - Sync changes to development theme
# - Provide live preview URL
```

## Step 8: GitHub Actions Integration

### Add Shopify Secrets to GitHub

1. Go to: https://github.com/toodeceptive/against-the-odds/settings/secrets/actions
2. Add secrets:
   - `SHOPIFY_API_KEY`
   - `SHOPIFY_API_SECRET`
   - `SHOPIFY_ACCESS_TOKEN`
   - `SHOPIFY_STORE_DOMAIN` (value: `aodrop.com`)
   - `SHOPIFY_THEME_ID` (optional, for theme deployment)

## Step 9: Product Management Setup

### Product Data Structure

Products are stored in `data/products/` as JSON files:

```json
{
  "title": "AO Hoodie",
  "body_html": "<p>Against The Odds signature hoodie</p>",
  "vendor": "Against The Odds",
  "product_type": "Apparel",
  "variants": [
    {
      "option1": "Small",
      "price": "79.99",
      "sku": "AO-HOODIE-S"
    }
  ],
  "images": [
    {
      "src": "https://example.com/hoodie.jpg",
      "alt": "AO Hoodie"
    }
  ]
}
```

### Sync Products

```powershell
# Import products to Shopify
.\scripts\products\sync.ps1

# Export products from Shopify
.\scripts\products\export.ps1
```

## Step 10: Webhooks Setup (Optional)

### Configure Webhooks

1. **Via Admin API**:

   ```powershell
   # Create webhook for order creation
   $webhook = @{
       webhook = @{
           topic = "orders/create"
           address = "https://your-app.com/webhooks/orders"
           format = "json"
       }
   } | ConvertTo-Json

   Invoke-RestMethod -Uri "https://$store/admin/api/2026-01/webhooks.json" `
       -Headers $headers `
       -Method Post `
       -Body $webhook `
       -ContentType "application/json"
   ```

## Verification Checklist

- [ ] Shopify CLI installed and authenticated
- [ ] API credentials generated and stored securely
- [ ] CLI linked to aodrop.com store
- [ ] API connectivity tested
- [ ] Theme development environment set up
- [ ] Local development server working
- [ ] GitHub Actions secrets configured
- [ ] Product management scripts functional

## Troubleshooting

### Authentication Issues

**Problem**: `shopify auth login` fails

**Solutions**:

1. Clear cached credentials: `shopify auth logout`
2. Try browser-based auth: `shopify auth login --browser`
3. Check Partner account access

### API Connection Issues

**Problem**: API requests return 401/403

**Solutions**:

1. Verify access token is valid
2. Check API scopes are correct
3. Regenerate API credentials if needed
4. Verify store domain is correct

### Theme Development Issues

**Problem**: Theme changes not syncing

**Solutions**:

1. Check theme ID is correct
2. Verify store access permissions
3. Restart development server
4. Check network connectivity

## Next Steps

1. Customize theme for AO brand
2. Set up product catalog
3. Configure checkout customization
4. Set up analytics and tracking
5. Prepare for launch

## References

- [Shopify CLI Documentation](https://shopify.dev/docs/apps/tools/cli)
- [Shopify Admin API](https://shopify.dev/docs/api/admin)
- [Shopify Theme Development](https://shopify.dev/docs/themes)
- [Shopify Partners](https://partners.shopify.com/)
