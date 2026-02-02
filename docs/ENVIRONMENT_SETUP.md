# Complete Environment Setup Guide

**Note**: For credentials and `.env.local` setup, the canonical doc is [CREDENTIALS_SETUP.md](CREDENTIALS_SETUP.md). This guide covers broader environment and tooling; use both as needed.

## Overview

This guide provides comprehensive instructions for setting up your development environment for the Against The Odds project, including all required credentials, tools, and configurations.

## Prerequisites

- Windows 10/11
- PowerShell 5.1 or later
- Node.js 20.x or later
- Python 3.x (required for Playwright webServer)
- Shopify CLI (recommended: global install)
- Git
- Chrome browser (for Shopify admin access)

## Quick Setup

### Automated Setup (Recommended)

```powershell
# Run automated setup script
.\scripts\setup\auto-configure-env.ps1
```

This script will:

1. Create `.env.local` from template
2. Apply known credentials automatically
3. Guide you through missing credentials
4. Optionally store credentials in Windows Credential Manager
5. Validate all credentials

### Manual Setup

1. **Copy environment template**:

   ```powershell
   Copy-Item .env.example .env.local
   ```

2. **Edit `.env.local`** with your credentials (see below)

3. **Verify setup**:
   ```powershell
   .\scripts\setup\verify-credentials.ps1
   ```

## Required Credentials

### GitHub Configuration

**GITHUB_TOKEN**

- Create at: https://github.com/settings/tokens
- Required scopes: `repo`, `workflow`, `read:org`
- Store securely in `.env.local`

**GITHUB_USERNAME**

- Value: `toodeceptive` (already known)

**GITHUB_REPO**

- Value: `against-the-odds` (already known)

### Shopify Configuration

**SHOPIFY_API_KEY**

- Value: `your_api_key` (from Shopify Admin)

**SHOPIFY_API_SECRET**

- Value: `your_api_secret` (from Shopify Admin)

**SHOPIFY_ACCESS_TOKEN**

- Get from: Shopify Admin > Apps > Development > Custom apps > Your App > API credentials
- Or use browser automation: `.\scripts\shopify\browser\get-access-token.ps1`

**SHOPIFY_STORE_DOMAIN**

- Value: `aodrop.com` (already known)

**SHOPIFY_THEME_ID**

- Get from: Shopify Admin > Online Store > Themes
- Or use browser automation: `.\scripts\shopify\browser\get-theme-id.ps1`

## Credential Retrieval Methods

### Method 1: Browser Automation (Recommended)

If you have Shopify admin open in Chrome:

```powershell
# Extract access token
.\scripts\shopify\browser\get-access-token.ps1

# Extract theme ID
.\scripts\shopify\browser\get-theme-id.ps1
```

### Method 2: Manual Extraction

1. **Access Token**:
   - Go to: https://aodrop.com/admin/apps/development
   - Click on your app
   - View API credentials
   - Copy Admin API access token

2. **Theme ID**:
   - Go to: https://aodrop.com/admin/themes
   - Click on your theme
   - Theme ID is in the URL or theme settings

### Method 3: GitHub Token

1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Select scopes: `repo`, `workflow`
4. Generate and copy token immediately
5. Add to `.env.local`

## Verification

After setup, verify all credentials:

```powershell
# Comprehensive verification
.\scripts\setup\verify-credentials.ps1

# Test Shopify connection
.\scripts\shopify\test-connection.ps1

# Test GitHub connection
.\scripts\github\verify-auth.ps1
```

## Secure Storage Options

### Option 1: .env.local (Recommended for Development)

- File is gitignored
- Easy to edit and update
- Local to your machine

### Option 2: Windows Credential Manager

```powershell
# Store GitHub token
cmdkey /generic:git:https://github.com /user:toodeceptive /pass:YOUR_TOKEN

# Store in environment variables
[System.Environment]::SetEnvironmentVariable('SHOPIFY_ACCESS_TOKEN', 'YOUR_TOKEN', 'User')
```

### Option 3: GitHub Secrets (For CI/CD)

1. Go to: https://github.com/toodeceptive/against-the-odds/settings/secrets/actions
2. Add each secret:
   - `SHOPIFY_STORE_DOMAIN`
   - `SHOPIFY_ACCESS_TOKEN`
   - `SHOPIFY_THEME_ID`

## Troubleshooting

### Credentials Not Working

1. Verify credentials are correct
2. Check for typos or extra spaces
3. Ensure credentials haven't expired
4. Re-run verification script

### Browser Automation Fails

1. Ensure Chrome is open with Shopify admin logged in
2. Check Chrome remote debugging is enabled
3. Try launching new browser instance instead

### API Connection Issues

1. Verify network connectivity
2. Check API credentials are valid
3. Ensure API version matches (2026-01)
4. Check rate limits haven't been exceeded

## Next Steps

After environment setup:

1. **Install dependencies**:

   ```powershell
   npm install
   ```

2. **Install Shopify CLI**:

   ```powershell
   npm install -g @shopify/cli @shopify/theme
   shopify auth login
   ```

3. **Run health check**:
   ```powershell
   .\scripts\health\comprehensive-check.ps1
   ```

## Security Best Practices

- ✅ Never commit `.env.local` to repository
- ✅ Use different credentials for development and production
- ✅ Rotate credentials regularly
- ✅ Use least privilege principle for API tokens
- ✅ Store secrets securely (Credential Manager or secrets manager)
- ✅ Review access logs regularly

## References

- [GitHub Token Creation](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [Shopify API Documentation](https://shopify.dev/docs/api/admin)
- [Environment Variables Guide](docs/SETUP_GITHUB.md)
