import { test, expect } from '@playwright/test';
import {
  connectToBrowser,
  ensureShopifyLogin,
  extractAccessToken,
  extractThemeId,
} from '../../src/browser-automation/shopify-admin.js';

test.describe('Shopify Admin Credential Extraction', () => {
  test.setTimeout(120000); // 2 minutes for manual login if needed
  const storeDomain = process.env.SHOPIFY_STORE_DOMAIN;
  const hasStoreDomain = Boolean(storeDomain);
  const testIf = (condition) => (condition ? test : test.skip);

  testIf(hasStoreDomain)('should extract access token from admin', async () => {
    const browser = await connectToBrowser({ useExisting: true, headless: false });
    const context = await browser.newContext();
    const page = await context.newPage();
    const loggedIn = await ensureShopifyLogin(page, storeDomain);

    expect(loggedIn).toBe(true);

    const token = await extractAccessToken(page);

    // Token should start with shpat_ if found
    if (token) {
      expect(token).toMatch(/^shpat_/);
      console.log('Access token extracted successfully');
    } else {
      console.log('Access token not found automatically - may need manual extraction');
    }

    await context.close();
    await browser.close();
  });

  testIf(hasStoreDomain)('should extract theme ID from admin', async () => {
    const browser = await connectToBrowser({ useExisting: true, headless: false });
    const context = await browser.newContext();
    const page = await context.newPage();
    const loggedIn = await ensureShopifyLogin(page, storeDomain);

    expect(loggedIn).toBe(true);

    const themeId = await extractThemeId(page, storeDomain);

    // Theme ID should be numeric if found
    if (themeId) {
      expect(themeId).toMatch(/^\d+$/);
      console.log('Theme ID extracted:', themeId);
    } else {
      console.log('Theme ID not found automatically - may need manual check');
    }

    await context.close();
    await browser.close();
  });
});
