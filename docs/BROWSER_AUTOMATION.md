# Browser Automation Guide

## Overview

This guide covers browser automation for Shopify admin tasks using Playwright. The automation can connect to your existing Chrome instance (when Shopify is open) or launch a new browser.

## Architecture

```
User's Chrome (Shopify Open)
    ↓
Playwright (Connect via CDP)
    ↓
Shopify Admin Navigation
    ↓
Data Extraction / Task Automation
    ↓
Results Storage / API Integration
```

## Setup

### Prerequisites

1. **Node.js and Playwright installed**:
   ```powershell
   npm install
   npx playwright install chromium
   ```

2. **Chrome with Remote Debugging** (for connecting to existing instance):
   - Chrome must be launched with: `--remote-debugging-port=9222`
   - Or use the automation scripts which handle this

### Configuration

Browser automation uses `playwright.shopify.config.js` for Shopify-specific settings.

## Usage

### Extract Shopify Access Token

```powershell
.\scripts\shopify\browser\get-access-token.ps1
```

**Requirements**:
- Chrome open with Shopify admin logged in
- Or script will launch new browser and wait for login

**Output**:
- Token saved to `.env.local` automatically
- Or displayed for manual entry

### Extract Theme ID

```powershell
.\scripts\shopify\browser\get-theme-id.ps1
```

**Requirements**:
- Shopify admin access
- Themes page accessible

**Output**:
- Theme ID saved to `.env.local`

### Verify Store Setup

```powershell
.\scripts\shopify\browser\verify-store-setup.ps1
```

Checks store configuration via browser automation.

## Browser Automation Library

### Core Functions

Located in `src/browser-automation/shopify-admin.js`:

- `connectToBrowser()` - Connect to existing Chrome or launch new
- `ensureShopifyLogin()` - Ensure logged in to Shopify admin
- `extractAccessToken()` - Extract access token from admin
- `extractThemeId()` - Extract theme ID from admin
- `takeScreenshot()` - Capture screenshots for documentation

### Helper Functions

Located in `src/browser-automation/helpers.js`:

- `waitForNetworkIdle()` - Wait for network to be idle
- `retryWithBackoff()` - Retry with exponential backoff
- `safeClick()` - Safe element click with retry
- `safeFill()` - Safe form field fill
- `extractTableData()` - Extract data from tables
- `elementExists()` - Check if element exists

## Connecting to Existing Chrome

### Method 1: Automatic (Recommended)

The scripts automatically try to connect to existing Chrome:

```javascript
const browser = await connectToBrowser({ useExisting: true });
```

### Method 2: Manual Chrome Launch

Launch Chrome with remote debugging:

```powershell
# Windows
& "C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222
```

Then run automation scripts.

## Writing Custom Automation

### Example: Extract Product Count

```javascript
import { connectToBrowser, ensureShopifyLogin } from '../src/browser-automation/shopify-admin.js';

const browser = await connectToBrowser({ useExisting: true });
const page = await browser.newPage();

await ensureShopifyLogin(page, 'aodrop.com');
await page.goto('https://aodrop.com/admin/products');

const count = await page.locator('[data-product-count]').textContent();
console.log(`Products: ${count}`);

await browser.close();
```

### Example: Navigate and Extract Data

```javascript
import { extractTableData } from '../src/browser-automation/helpers.js';

await page.goto('https://aodrop.com/admin/products');
const products = await extractTableData(page, 'table.products-table');
console.log(products);
```

## Testing

### Run Browser Tests

```powershell
# Run Shopify admin tests
npm run test:shopify

# Or directly
npx playwright test --config=playwright.shopify.config.js
```

### Test Files

- `tests/shopify-admin/extract-credentials.spec.js` - Credential extraction tests
- `tests/e2e/shopify-admin.spec.js` - General admin tests

## Best Practices

1. **Always use retry logic** for network operations
2. **Wait for elements** before interacting
3. **Handle login states** gracefully
4. **Take screenshots** on errors for debugging
5. **Use existing browser** when possible (faster, maintains session)
6. **Clean up** browser instances after use

## Troubleshooting

### Cannot Connect to Chrome

**Issue**: Script can't connect to existing Chrome instance

**Solutions**:
1. Ensure Chrome is running
2. Launch Chrome with remote debugging: `chrome.exe --remote-debugging-port=9222`
3. Use `useExisting: false` to launch new browser

### Login Required

**Issue**: Automation hits login page

**Solutions**:
1. Log in manually in browser first
2. Use storage state to save login session
3. Wait for manual login (script will pause)

### Element Not Found

**Issue**: Selectors don't match elements

**Solutions**:
1. Check Shopify admin structure hasn't changed
2. Use more flexible selectors
3. Add wait conditions
4. Take screenshot to inspect page

## Advanced Usage

### Saving Login State

```javascript
// After login
await page.context().storageState({ path: 'shopify-auth.json' });

// Next time, use saved state
const context = await browser.newContext({
  storageState: 'shopify-auth.json'
});
```

### Screenshot on Error

```javascript
try {
  await page.click('button');
} catch (error) {
  await page.screenshot({ path: 'error.png' });
  throw error;
}
```

## Security Considerations

- Browser automation may require admin access
- Store authentication state securely
- Don't commit screenshots with sensitive data
- Use environment variables for credentials
- Rotate credentials regularly

## References

- [Playwright Documentation](https://playwright.dev)
- [Shopify Admin Structure](https://shopify.dev/docs/apps)
- [Browser Automation Best Practices](docs/knowledge-base/browser-automation.md)
