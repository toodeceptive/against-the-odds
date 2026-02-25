/**
 * Storefront E2E — product demo and live store verification.
 * Opens the live store (e.g. aodrop.com), optionally navigates to a product, captures screenshot.
 * Run: npx playwright test tests/e2e/storefront.spec.js
 * For product-demo screenshot: set SCREENSHOT_DIR or check docs/screenshots/.
 */

import { test, expect } from '@playwright/test';
import { join } from 'path';
import { mkdir } from 'fs/promises';

const storeDomain = process.env.SHOPIFY_STORE_DOMAIN || 'aodrop.com';
const storeUrl = `https://${storeDomain}`;

test.describe('Storefront (product demo)', () => {
  test.setTimeout(30000);

  test('store homepage loads', async ({ page }) => {
    await page.goto(storeUrl, { waitUntil: 'domcontentloaded', timeout: 15000 });
    await expect(page).toHaveURL(new RegExp(storeDomain));
    const title = await page.title();
    expect(title?.length).toBeGreaterThan(0);
  });

  test('product demo: homepage and optional product page screenshot', async ({ page }) => {
    await page.goto(storeUrl, { waitUntil: 'domcontentloaded', timeout: 15000 });
    const outDir = process.env.SCREENSHOT_DIR || join(process.cwd(), 'docs', 'screenshots');
    await mkdir(outDir, { recursive: true });
    const ts = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
    await page.screenshot({
      path: join(outDir, `product-demo-home-${ts}.png`),
      fullPage: true,
    });
    // If store has /products, open first product link and capture
    const productLink = page.locator('a[href*="/products/"]').first();
    if ((await productLink.count()) > 0) {
      await productLink.click();
      await page.waitForLoadState('domcontentloaded');
      await page.screenshot({
        path: join(outDir, `product-demo-product-${ts}.png`),
        fullPage: true,
      });
    }
  });
});
