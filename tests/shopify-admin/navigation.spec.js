/**
 * Unattended headless automation of Shopify Admin is not recommended per Shopify API terms.
 * Use for manual or user-in-browser flows only (e.g. connect to existing Chrome, user watches).
 */
import { test, expect } from '@playwright/test';
import {
  connectToBrowser,
  ensureShopifyLogin,
  getConnectedBrowserPage,
} from '../../src/browser-automation/shopify-admin.js';
import { buildShopifyAdminUrl, isTrustedShopifyAdminUrl } from '../../src/shopify/store-domain.js';

test.describe('Shopify Admin E2E Tests', () => {
  test.setTimeout(120000); // 2 minutes for manual login if needed
  const storeDomain = process.env.SHOPIFY_STORE_DOMAIN;
  const hasStoreDomain = Boolean(storeDomain);
  const testIf = (condition) => (condition ? test : test.skip);

  testIf(hasStoreDomain)('should access Shopify admin', async () => {
    const browser = await connectToBrowser({ useExisting: true, headless: false });
    const { page, cleanup } = await getConnectedBrowserPage(browser, { storeDomain });
    try {
      const loggedIn = await ensureShopifyLogin(page, storeDomain);
      expect(loggedIn).toBe(true);

      // Verify we're on admin page
      const url = page.url();
      expect(isTrustedShopifyAdminUrl(url, storeDomain)).toBe(true);
    } finally {
      await cleanup();
      await browser.close();
    }
  });

  testIf(hasStoreDomain)('should navigate to products page', async () => {
    const browser = await connectToBrowser({ useExisting: true, headless: false });
    const { page, cleanup } = await getConnectedBrowserPage(browser, { storeDomain });
    try {
      const loggedIn = await ensureShopifyLogin(page, storeDomain);
      expect(loggedIn).toBe(true);

      await page.goto(buildShopifyAdminUrl(storeDomain, '/products', { currentUrl: page.url() }), {
        waitUntil: 'domcontentloaded',
      });

      // Check if products page loaded
      await expect(page).toHaveURL(/(\/admin\/products|\/store\/[^/]+\/products)/);
    } finally {
      await cleanup();
      await browser.close();
    }
  });

  testIf(hasStoreDomain)('should navigate to themes page', async () => {
    const browser = await connectToBrowser({ useExisting: true, headless: false });
    const { page, cleanup } = await getConnectedBrowserPage(browser, { storeDomain });
    try {
      const loggedIn = await ensureShopifyLogin(page, storeDomain);
      expect(loggedIn).toBe(true);

      await page.goto(buildShopifyAdminUrl(storeDomain, '/themes', { currentUrl: page.url() }), {
        waitUntil: 'domcontentloaded',
      });

      // Check if themes page loaded
      await expect(page).toHaveURL(/(\/admin\/themes|\/store\/[^/]+\/themes)/);
    } finally {
      await cleanup();
      await browser.close();
    }
  });
});
