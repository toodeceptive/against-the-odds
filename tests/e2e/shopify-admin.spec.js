/**
 * Unattended headless automation of Shopify Admin is not recommended per Shopify API terms.
 * Use for manual or user-in-browser flows only (e.g. connect to existing Chrome, user watches).
 */
import { test, expect } from '@playwright/test';
import {
  connectToBrowser,
  ensureShopifyLogin,
} from '../../src/browser-automation/shopify-admin.js';

test.describe('Shopify Admin E2E Tests', () => {
  const storeDomain = process.env.SHOPIFY_STORE_DOMAIN;
  const hasStoreDomain = Boolean(storeDomain);
  const testIf = (condition) => (condition ? test : test.skip);

  testIf(hasStoreDomain)('should access Shopify admin', async () => {
    test.setTimeout(120000); // 2 minutes for manual login if needed

    const browser = await connectToBrowser({ useExisting: true, headless: false });
    const context = await browser.newContext();
    const page = await context.newPage();

    const loggedIn = await ensureShopifyLogin(page, storeDomain);
    expect(loggedIn).toBe(true);

    // Verify we're on admin page
    const url = page.url();
    expect(url).toContain('/admin');

    await context.close();
    await browser.close();
  });

  testIf(hasStoreDomain)('should navigate to products page', async () => {
    test.setTimeout(120000);

    const browser = await connectToBrowser({ useExisting: true, headless: false });
    const context = await browser.newContext();
    const page = await context.newPage();

    const loggedIn = await ensureShopifyLogin(page, storeDomain);
    expect(loggedIn).toBe(true);

    await page.goto(`https://${storeDomain}/admin/products`, { waitUntil: 'domcontentloaded' });

    // Check if products page loaded
    await expect(page).toHaveURL(/\/admin\/products/);
    await expect(page).toHaveTitle(/Products/i);

    await context.close();
    await browser.close();
  });

  testIf(hasStoreDomain)('should navigate to themes page', async () => {
    test.setTimeout(120000);

    const browser = await connectToBrowser({ useExisting: true, headless: false });
    const context = await browser.newContext();
    const page = await context.newPage();

    const loggedIn = await ensureShopifyLogin(page, storeDomain);
    expect(loggedIn).toBe(true);

    await page.goto(`https://${storeDomain}/admin/themes`, { waitUntil: 'domcontentloaded' });

    // Check if themes page loaded
    await expect(page).toHaveURL(/\/admin\/themes/);
    await expect(page).toHaveTitle(/Themes/i);

    await context.close();
    await browser.close();
  });
});
