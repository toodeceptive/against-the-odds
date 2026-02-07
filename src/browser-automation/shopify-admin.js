/**
 * Shopify Admin Browser Automation Library
 * Provides reusable functions for interacting with Shopify admin interface.
 *
 * Note: Unattended headless automation of Shopify Admin is not recommended per Shopify API terms.
 * Use for manual or user-in-browser flows only (e.g. connect to existing Chrome, user watches).
 */

import { warn } from '../desktop-automation/logger.js';

let playwright;

async function getPlaywright() {
  if (!playwright) {
    playwright = await import('@playwright/test');
  }
  return playwright;
}

/**
 * Connect to existing Chrome instance or launch new browser
 * @param {Object} options - Connection options
 * @returns {Promise<Browser>} Playwright browser instance
 */
export async function connectToBrowser(options = {}) {
  const { useExisting = true, headless = false, slowMo = 0 } = options;

  const pw = await getPlaywright();
  const { chromium } = pw;

  // Try to connect to existing Chrome instance
  if (useExisting) {
    try {
      const browser = await chromium.connectOverCDP('http://localhost:9222');
      // Connected to existing Chrome instance
      return browser;
    } catch (_error) {
      // Could not connect to existing Chrome, launching new instance
    }
  }

  // Launch new browser instance
  const browser = await chromium.launch({
    headless,
    slowMo,
    channel: 'chrome',
    args: ['--disable-blink-features=AutomationControlled', '--remote-debugging-port=9222'],
  });

  return browser;
}

/**
 * Navigate to Shopify admin and ensure logged in
 * @param {Page} page - Playwright page instance
 * @param {string} storeDomain - Shopify store domain
 * @returns {Promise<boolean>} True if successfully logged in
 */
export async function ensureShopifyLogin(page, storeDomain) {
  const adminUrl = `https://${storeDomain}/admin`;

  try {
    await page.goto(adminUrl, { waitUntil: 'domcontentloaded', timeout: 30000 });

    // Shopify may redirect aodrop.com/admin → admin.shopify.com/store/<id>
    const currentUrl = page.url();
    const isAdmin = currentUrl.includes('admin.shopify.com') || currentUrl.includes('/admin');
    const hasLoginForm = (await page.locator('form[action*="login"]').count()) > 0;

    if (isAdmin && !hasLoginForm) {
      return true;
    }
    if (hasLoginForm) {
      // Wait for redirect to admin (any admin URL)
      await page.waitForFunction(
        () => {
          const u = window.location.href;
          return u.includes('admin.shopify.com') || u.includes('/admin');
        },
        { timeout: 120000 },
      );
    }
    return true;
  } catch (_error) {
    warn('Failed to access Shopify admin', { storeDomain, error: _error?.message });
    return false;
  }
}

/**
 * Navigate directly to Shopify Apps > Development using store ID (for automation)
 * Use when store ID is known (e.g. nbxwpf-z1 from admin URL) to avoid depending on current page
 * @param {Page} page - Playwright page instance
 * @param {string} storeId - Store ID from admin URL (e.g. nbxwpf-z1)
 * @returns {Promise<boolean>} True if navigation successful
 */
export async function navigateToAppsDevelopmentByStoreId(page, storeId) {
  if (!storeId || !/^[a-z0-9_-]+$/i.test(storeId)) return false;
  try {
    const appsUrl = `https://admin.shopify.com/store/${storeId}/apps/development`;
    await page.goto(appsUrl, { waitUntil: 'domcontentloaded', timeout: 20000 });
    await page.waitForSelector('h1, [data-testid="apps-page"], main, [role="main"]', {
      timeout: 15000,
    });
    return true;
  } catch (_error) {
    warn('Failed to navigate to Apps > Development by store ID', {
      storeId,
      error: _error?.message,
    });
    return false;
  }
}

/**
 * Navigate to Shopify Apps > Development page (uses current URL or store ID from env)
 * @param {Page} page - Playwright page instance
 * @returns {Promise<boolean>} True if navigation successful
 */
export async function navigateToAppsDevelopment(page) {
  try {
    const storeIdFromEnv = typeof process !== 'undefined' && process.env.ATO_SHOPIFY_STORE_ID;
    if (storeIdFromEnv) {
      const ok = await navigateToAppsDevelopmentByStoreId(page, storeIdFromEnv);
      if (ok) return true;
    }

    // Fallback: derive from current URL
    const currentUrl = page.url();
    if (currentUrl.includes('admin.shopify.com/store/')) {
      const url = new URL(currentUrl);
      const pathMatch = url.pathname.match(/^\/store\/([^/]+)/);
      const storePath = pathMatch ? pathMatch[0] : '/store';
      const appsUrl = `${url.origin}${storePath}/apps/development`;
      await page.goto(appsUrl, { waitUntil: 'domcontentloaded', timeout: 15000 });
    } else {
      await page.goto('/admin/apps/development', { waitUntil: 'domcontentloaded', timeout: 15000 });
    }

    await page.waitForSelector('h1, [data-testid="apps-page"], main, [role="main"]', {
      timeout: 10000,
    });
    return true;
  } catch (_error) {
    warn('Failed to navigate to Apps > Development', { error: _error?.message });
    return false;
  }
}

/**
 * Navigate from Apps > Development to the first app's API credentials and reveal token if masked
 * @param {Page} page - Playwright page instance (should be on apps/development)
 * @returns {Promise<boolean>} True if we reached a page that may show the token
 */
export async function navigateToAppApiCredentialsAndReveal(page) {
  try {
    // From apps/development: click first link that goes to an app detail (e.g. /store/.../apps/123), not "Create app"
    const appLinks = page.locator('a[href*="/apps/"]');
    const n = await appLinks.count();
    for (let i = 0; i < Math.min(n, 8); i++) {
      const href = await appLinks.nth(i).getAttribute('href');
      const text = await appLinks.nth(i).textContent();
      // Skip "Create app", "Development", or links that are just /apps/development
      if (href && !href.endsWith('/development') && !/create|new|development/i.test(text || '')) {
        await appLinks.nth(i).click();
        await page.waitForLoadState('domcontentloaded');
        await page.waitForTimeout(2000);
        break;
      }
    }

    // Click "API credentials" if present (link, tab, or button)
    const apiCredsLink = page
      .locator(
        'a:has-text("API credentials"), [href*="credentials"]:visible, button:has-text("API credentials")',
      )
      .first();
    if ((await apiCredsLink.count()) > 0) {
      await apiCredsLink.click();
      await page.waitForLoadState('domcontentloaded');
      await page.waitForTimeout(1500);
    }

    // Click every "Reveal" to unmask tokens (Admin API token is often hidden)
    const revealBtns = page.locator(
      'button:has-text("Reveal"), [role="button"]:has-text("Reveal"), a:has-text("Reveal")',
    );
    const revealCount = await revealBtns.count();
    for (let r = 0; r < revealCount; r++) {
      try {
        await revealBtns.nth(r).click();
        await page.waitForTimeout(600);
      } catch {
        // Ignore if click fails (e.g. already revealed)
      }
    }

    return true;
  } catch (_e) {
    return false;
  }
}

/**
 * Extract access token from Shopify admin
 * @param {Page} page - Playwright page instance
 * @returns {Promise<string|null>} Access token or null if not found
 */
export async function extractAccessToken(page) {
  // Shopify Admin API tokens: shpat_ + alphanumeric (typically 32+ chars; accept 20+ for flexibility)
  const tokenPattern = /shpat_[a-zA-Z0-9]{20,}/;
  const tryExtractFromCurrentPage = async () => {
    const content = await page.content();
    const m = content.match(tokenPattern);
    if (m) return m[0];
    const visible = await page.evaluate(() => {
      const t = document.body?.innerText || '';
      const match = t.match(/shpat_[a-zA-Z0-9]{20,}/);
      return match ? match[0] : null;
    });
    return visible;
  };

  try {
    // If user already navigated to API credentials page, try Reveal + extract first
    const revealBtn = page.locator('button:has-text("Reveal"), [role="button"]:has-text("Reveal")');
    if ((await revealBtn.count()) > 0) {
      for (let r = 0; r < (await revealBtn.count()); r++) {
        try {
          await revealBtn.nth(r).click();
          await page.waitForTimeout(800);
        } catch {
          // Ignore if click fails
        }
      }
      const already = await tryExtractFromCurrentPage();
      if (already) return already;
    }

    const success = await navigateToAppsDevelopment(page);
    if (!success) {
      return null;
    }

    // Navigate into first app's API credentials and click Reveal if present
    await navigateToAppApiCredentialsAndReveal(page);

    // Look for access token in various possible locations
    // Method 1: Full page HTML
    const pageContent = await page.content();
    const tokenMatch = pageContent.match(tokenPattern);
    if (tokenMatch) {
      return tokenMatch[0];
    }

    // Method 1b: Visible text (in case token is in shadow DOM or rendered differently)
    const visibleToken = await page.evaluate(() => {
      const bodyText = document.body?.innerText || '';
      const m = bodyText.match(/shpat_[a-zA-Z0-9]{20,}/);
      return m ? m[0] : null;
    });
    if (visibleToken) return visibleToken;

    // Method 2: Look for token in inputs and data attributes (Reveal often populates an input)
    const inputWithToken = await page.locator(
      'input[value*="shpat_"], [data-access-token], [data-token]',
    );
    for (let i = 0; i < (await inputWithToken.count()); i++) {
      const v =
        (await inputWithToken.nth(i).getAttribute('value')) ||
        (await inputWithToken.nth(i).getAttribute('data-access-token')) ||
        (await inputWithToken.nth(i).getAttribute('data-token'));
      if (v && /^shpat_[a-zA-Z0-9]{20,}$/.test(v.trim())) return v.trim();
    }

    // Method 3: Check API credentials section
    const apiSection = page.locator('text=/API.*[Cc]redential/i, text=/Access.*[Tt]oken/i');
    if ((await apiSection.count()) > 0) {
      // Try to find token in nearby elements
      const nearbyText = await apiSection.first().evaluate((el) => {
        const parent = el.closest('section, div, form') || el.parentElement;
        return parent?.textContent || '';
      });

      const m = nearbyText.match(tokenPattern);
      if (m) {
        return m[0];
      }
    }

    // Access token not found on page
    return null;
  } catch (_error) {
    // Error extracting access token
    return null;
  }
}

/**
 * Extract theme ID from Shopify admin
 * @param {Page} page - Playwright page instance
 * @returns {Promise<string|null>} Theme ID or null if not found
 */
export async function extractThemeId(page) {
  try {
    // Navigate to themes page
    await page.goto('/admin/themes', { waitUntil: 'networkidle' });

    // Wait for themes to load
    await page.waitForSelector('[data-theme-id], .theme-card, .theme-item', { timeout: 10000 });

    // Look for live/main theme
    const liveTheme = await page
      .locator('[data-theme-role="main"], .theme[data-role="main"]')
      .first();
    if ((await liveTheme.count()) > 0) {
      const themeId =
        (await liveTheme.getAttribute('data-theme-id')) ||
        (await liveTheme.getAttribute('data-id'));
      if (themeId) {
        return themeId;
      }
    }

    // Alternative: Extract from URL or page content
    const url = page.url();
    const urlMatch = url.match(/themes\/(\d+)/);
    if (urlMatch) {
      return urlMatch[1];
    }

    // Check page content for theme IDs
    const pageContent = await page.content();
    const themeIdPattern = /"id":\s*(\d+).*"role":\s*"main"/;
    const match = pageContent.match(themeIdPattern);
    if (match) {
      return match[1];
    }

    // Theme ID not found
    return null;
  } catch {
    // Error extracting theme ID
    return null;
  }
}

/**
 * Take screenshot of current page
 * @param {Page} page - Playwright page instance
 * @param {string} filename - Screenshot filename
 * @returns {Promise<string>} Path to screenshot file
 */
export async function takeScreenshot(page, filename) {
  const screenshotPath = `docs/screenshots/${filename}`;
  await page.screenshot({ path: screenshotPath, fullPage: true });
  return screenshotPath;
}

/**
 * Wait for element and extract text
 * @param {Page} page - Playwright page instance
 * @param {string} selector - CSS selector
 * @returns {Promise<string>} Element text content
 */
export async function extractText(page, selector) {
  try {
    await page.waitForSelector(selector, { timeout: 10000 });
    return await page.locator(selector).first().textContent();
  } catch (_error) {
    // Error extracting text
    return null;
  }
}
