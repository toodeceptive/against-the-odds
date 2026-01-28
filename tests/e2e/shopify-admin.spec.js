import { test, expect } from '@playwright/test';
import { connectToBrowser, ensureShopifyLogin } from '../../src/browser-automation/shopify-admin.js';

test.describe('Shopify Admin E2E Tests', () => {
  const storeDomain = process.env.SHOPIFY_STORE_DOMAIN || 'aodrop.com';
  
  test('should access Shopify admin', async () => {
    test.setTimeout(120000); // 2 minutes for manual login if needed
    
    const browser = await connectToBrowser({ useExisting: true, headless: false });
    const context = browser.contexts()[0] || await browser.newContext();
    const page = context.pages()[0] || await context.newPage();
    
    const loggedIn = await ensureShopifyLogin(page, storeDomain);
    expect(loggedIn).toBe(true);
    
    // Verify we're on admin page
    const url = page.url();
    expect(url).toContain('/admin');
    
    await browser.close();
  });
  
  test('should navigate to products page', async () => {
    test.setTimeout(120000);
    
    const browser = await connectToBrowser({ useExisting: true, headless: false });
    const context = browser.contexts()[0] || await browser.newContext();
    const page = context.pages()[0] || await context.newPage();
    
    const loggedIn = await ensureShopifyLogin(page, storeDomain);
    expect(loggedIn).toBe(true);
    
    await page.goto(`https://${storeDomain}/admin/products`, { waitUntil: 'networkidle' });
    
    // Check if products page loaded
    const pageTitle = await page.title();
    expect(pageTitle).toContain('Products');
    
    await browser.close();
  });
  
  test('should navigate to themes page', async () => {
    test.setTimeout(120000);
    
    const browser = await connectToBrowser({ useExisting: true, headless: false });
    const context = browser.contexts()[0] || await browser.newContext();
    const page = context.pages()[0] || await context.newPage();
    
    const loggedIn = await ensureShopifyLogin(page, storeDomain);
    expect(loggedIn).toBe(true);
    
    await page.goto(`https://${storeDomain}/admin/themes`, { waitUntil: 'networkidle' });
    
    // Check if themes page loaded
    const pageTitle = await page.title();
    expect(pageTitle).toContain('Themes');
    
    await browser.close();
  });
});
