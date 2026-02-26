/**
 * Shopify Admin Browser Automation Library
 * Provides reusable functions for interacting with Shopify admin interface.
 *
 * Note: Unattended headless automation of Shopify Admin is not recommended per Shopify API terms.
 * Use for manual or user-in-browser flows only (e.g. connect to existing Chrome, user watches).
 *
 * @typedef {import('@playwright/test').Browser} Browser
 * @typedef {import('@playwright/test').Page} Page
 */

import { warn } from '../desktop-automation/logger.js';

let playwright;

async function getPlaywright() {
  if (!playwright) {
    playwright = await import('@playwright/test');
  }
  return playwright;
}

function normalizeStoreHost(storeDomain) {
  if (!storeDomain || typeof storeDomain !== 'string') return null;
  const trimmed = storeDomain.trim();
  if (!trimmed) return null;

  try {
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return new URL(trimmed).hostname.toLowerCase();
    }
    return new URL(`https://${trimmed}`).hostname.toLowerCase();
  } catch {
    return null;
  }
}

function getTrustedShopifyHosts(storeDomain) {
  const hosts = new Set(['admin.shopify.com']);
  const normalizedStoreHost = normalizeStoreHost(storeDomain);
  if (!normalizedStoreHost) return Array.from(hosts);

  hosts.add(normalizedStoreHost);
  if (!normalizedStoreHost.endsWith('.myshopify.com')) {
    hosts.add(`${normalizedStoreHost}.myshopify.com`);
  }

  return Array.from(hosts);
}

function isTrustedShopifyAdminUrl(urlValue, trustedHosts) {
  try {
    const parsed = new URL(urlValue);
    if (parsed.protocol !== 'https:') return false;

    const hostname = parsed.hostname.toLowerCase();
    if (!trustedHosts.includes(hostname)) return false;

    if (hostname === 'admin.shopify.com') {
      return parsed.pathname.startsWith('/store/');
    }

    return parsed.pathname === '/admin' || parsed.pathname.startsWith('/admin/');
  } catch {
    return false;
  }
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
  const trustedHosts = getTrustedShopifyHosts(storeDomain);

  try {
    await page.goto(adminUrl, { waitUntil: 'domcontentloaded', timeout: 30000 });

    // Shopify may redirect aodrop.com/admin → admin.shopify.com/store/<id>
    const currentUrl = page.url();
    const isAdmin = isTrustedShopifyAdminUrl(currentUrl, trustedHosts);
    const hasLoginForm = (await page.locator('form[action*="login"]').count()) > 0;

    if (isAdmin && !hasLoginForm) {
      return true;
    }

    // Attempt one-click social login entries often available on Shopify auth pages.
    const socialLoginSelectors = [
      'a:has-text("Continue with Google")',
      'button:has-text("Continue with Google")',
      'a:has-text("Continue with Apple")',
      'button:has-text("Continue with Apple")',
    ];

    for (const selector of socialLoginSelectors) {
      const candidate = page.locator(selector).first();
      if ((await candidate.count()) > 0) {
        try {
          await candidate.click();
          break;
        } catch {
          // Try next candidate.
        }
      }
    }

    // Wait for redirect to a trusted Shopify admin URL.
    await page.waitForFunction(
      (allowedHosts) => {
        try {
          const parsed = new URL(window.location.href);
          if (parsed.protocol !== 'https:') return false;

          const hostname = parsed.hostname.toLowerCase();
          if (!allowedHosts.includes(hostname)) return false;

          if (hostname === 'admin.shopify.com') {
            return parsed.pathname.startsWith('/store/');
          }

          return parsed.pathname === '/admin' || parsed.pathname.startsWith('/admin/');
        } catch {
          return false;
        }
      },
      trustedHosts,
      { timeout: 120000 },
    );

    return isTrustedShopifyAdminUrl(page.url(), trustedHosts);
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

async function clickFirstAppDetailLink(page) {
  const appLinks = page.locator('a[href*="/apps/"]');
  const n = await appLinks.count();
  for (let i = 0; i < Math.min(n, 8); i++) {
    const href = await appLinks.nth(i).getAttribute('href');
    const text = await appLinks.nth(i).textContent();
    if (href && !href.endsWith('/development') && !/create|new|development/i.test(text || '')) {
      await appLinks.nth(i).click();
      await page.waitForLoadState('domcontentloaded');
      await page.waitForTimeout(2000);
      return true;
    }
  }
  return false;
}

async function clickRevealButtons(page) {
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
}

/**
 * Navigate from Apps > Development to the first app's API credentials and reveal token if masked
 * @param {Page} page - Playwright page instance (should be on apps/development)
 * @returns {Promise<boolean>} True if we reached a page that may show the token
 */
export async function navigateToAppApiCredentialsAndReveal(page) {
  try {
    await clickFirstAppDetailLink(page);

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

    await clickRevealButtons(page);
    return true;
  } catch (_e) {
    return false;
  }
}

function getStoreSlugFromAdminUrl(urlValue) {
  try {
    const parsed = new URL(urlValue);
    if (parsed.hostname !== 'admin.shopify.com') return null;
    const match = parsed.pathname.match(/^\/store\/([^/]+)/);
    return match ? match[1] : null;
  } catch {
    return null;
  }
}

function buildClientCredentialsEndpoints(storeDomain, storeSlug) {
  const endpoints = new Set();
  const normalizedStoreHost = normalizeStoreHost(storeDomain);

  if (normalizedStoreHost) {
    endpoints.add(`https://${normalizedStoreHost}/admin/oauth/access_token`);
    if (!normalizedStoreHost.endsWith('.myshopify.com')) {
      endpoints.add(`https://${normalizedStoreHost}.myshopify.com/admin/oauth/access_token`);
    }
  }

  if (storeSlug && /^[a-z0-9-]+$/i.test(storeSlug)) {
    endpoints.add(`https://${storeSlug}.myshopify.com/admin/oauth/access_token`);
  }

  // Known ATO canonical myshopify domain (used elsewhere in repo scripts).
  if (normalizedStoreHost === 'aodrop.com' || storeSlug === 'aodrop') {
    endpoints.add('https://nbxwpf-z1.myshopify.com/admin/oauth/access_token');
  }

  return Array.from(endpoints);
}

async function openDevDashboardPopup(page) {
  const devDashboardLink = page
    .locator('a:has-text("Build apps in Dev Dashboard"), a[href*="dev.shopify.com/dashboard"]')
    .first();
  if ((await devDashboardLink.count()) === 0) return page;

  const [popup] = await Promise.all([
    page.waitForEvent('popup', { timeout: 7000 }).catch(() => null),
    devDashboardLink.click().catch(() => null),
  ]);

  if (popup) {
    await popup.waitForLoadState('domcontentloaded');
    return popup;
  }
  await page.waitForLoadState('domcontentloaded');
  return page;
}

async function clickFirstAppLinkFromIndex(devPage) {
  const appLinks = devPage.locator('a[href*="/dashboard/"][href*="/apps/"]');
  const n = await appLinks.count();
  for (let i = 0; i < Math.min(n, 15); i++) {
    const href = await appLinks.nth(i).getAttribute('href');
    if (href && /\/apps\/\d+/.test(href) && !/\/apps\/?$/.test(href)) {
      await Promise.all([
        devPage
          .waitForNavigation({ waitUntil: 'domcontentloaded', timeout: 15000 })
          .catch(() => null),
        appLinks
          .nth(i)
          .click()
          .catch(() => null),
      ]);
      return true;
    }
  }
  return false;
}

async function openDevDashboardSettingsPage(page) {
  const devPage = await openDevDashboardPopup(page);

  if (/\/dashboard\/\d+\/apps(?:\?|$)/.test(devPage.url())) {
    await clickFirstAppLinkFromIndex(devPage);
  }

  const currentUrl = devPage.url();
  if (/\/dashboard\/\d+\/apps\/\d+(?:\?|$)/.test(currentUrl)) {
    await devPage.goto(`${currentUrl.replace(/\/$/, '')}/settings`, {
      waitUntil: 'domcontentloaded',
      timeout: 15000,
    });
  }

  if (!/\/dashboard\/\d+\/apps\/\d+\/settings/.test(devPage.url())) {
    return null;
  }

  await devPage.waitForSelector('h1, input, button', { timeout: 15000 });
  return devPage;
}

async function extractClientCredentials(devPage) {
  const revealButton = devPage
    .locator(
      'button:has-text("Reveal client secret"), [role="button"]:has-text("Reveal client secret")',
    )
    .first();
  if ((await revealButton.count()) > 0) {
    try {
      await revealButton.click();
      await devPage.waitForTimeout(500);
    } catch {
      // Continue; in some UIs copy button may still work without reveal.
    }
  }

  const creds = await devPage.evaluate(() => {
    const getContextText = (el) => {
      const labels = el.labels
        ? Array.from(el.labels)
            .map((l) => l.textContent || '')
            .join(' ')
        : '';
      const parentText = (el.closest('section, form, div')?.textContent || '').slice(0, 600);
      return `${labels} ${parentText}`.toLowerCase();
    };

    const controls = Array.from(document.querySelectorAll('input, textarea'));
    const values = controls
      .map((el) => ({
        value: (el instanceof HTMLInputElement || el instanceof HTMLTextAreaElement
          ? el.value
          : el.getAttribute('value') || ''
        ).trim(),
        context: getContextText(el),
      }))
      .filter((entry) => entry.value.length > 0);

    let clientId = null;
    for (const entry of values) {
      if (/client\s*id/.test(entry.context) || /^[a-f0-9]{32}$/i.test(entry.value)) {
        clientId = entry.value;
        break;
      }
    }

    let clientSecret = null;
    for (const entry of values) {
      if (entry.value === clientId) continue;
      if (/client\s*secret|secret/.test(entry.context) && entry.value.length >= 24) {
        clientSecret = entry.value;
        break;
      }
    }

    if (!clientSecret) {
      const fallback = values.find(
        (entry) =>
          entry.value !== clientId &&
          /^[A-Za-z0-9_-]{24,}$/.test(entry.value) &&
          !/^shpat_[A-Za-z0-9]{20,}$/.test(entry.value),
      );
      clientSecret = fallback ? fallback.value : null;
    }

    return { clientId, clientSecret };
  });

  if (!creds?.clientId || !creds?.clientSecret) return null;
  return creds;
}

async function tryOAuthEndpoint(endpoint, clientId, clientSecret) {
  const body = new URLSearchParams({
    grant_type: 'client_credentials',
    client_id: clientId,
    client_secret: clientSecret,
  });
  const res = await fetch(endpoint, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body,
  });
  if (!res.ok) return null;
  const payload = await res.json().catch(() => null);
  const token = payload?.access_token;
  return typeof token === 'string' && /^shpat_[a-zA-Z0-9]{32,}$/.test(token) ? token : null;
}

async function requestAccessTokenFromClientCredentials(page, storeDomain) {
  const settingsPage = await openDevDashboardSettingsPage(page);
  if (!settingsPage) return null;

  const creds = await extractClientCredentials(settingsPage);
  if (!creds) return null;

  const storeSlug = getStoreSlugFromAdminUrl(page.url());
  const endpoints = buildClientCredentialsEndpoints(storeDomain, storeSlug);

  for (const endpoint of endpoints) {
    try {
      const token = await tryOAuthEndpoint(endpoint, creds.clientId, creds.clientSecret);
      if (token) return token;
    } catch {
      // Try next endpoint.
    }
  }
  return null;
}

const TOKEN_PATTERN = /shpat_[a-zA-Z0-9]{32,}/;

async function extractTokenFromPageContent(page) {
  const content = await page.content();
  const m = content.match(TOKEN_PATTERN);
  if (m) return m[0];
  return page.evaluate(() => {
    const t = document.body?.innerText || '';
    const match = t.match(/shpat_[a-zA-Z0-9]{32,}/);
    return match ? match[0] : null;
  });
}

async function extractTokenFromInputs(page) {
  const inputWithToken = page.locator('input[value*="shpat_"], [data-access-token], [data-token]');
  const count = await inputWithToken.count();
  for (let i = 0; i < count; i++) {
    const v =
      (await inputWithToken.nth(i).getAttribute('value')) ||
      (await inputWithToken.nth(i).getAttribute('data-access-token')) ||
      (await inputWithToken.nth(i).getAttribute('data-token'));
    if (v && /^shpat_[a-zA-Z0-9]{32,}$/.test(v.trim())) return v.trim();
  }
  return null;
}

async function extractTokenFromApiSection(page) {
  const apiSection = page.locator('text=/API.*[Cc]redential/i, text=/Access.*[Tt]oken/i');
  if ((await apiSection.count()) === 0) return null;
  const nearbyText = await apiSection.first().evaluate((el) => {
    const parent = el.closest('section, div, form') || el.parentElement;
    return parent?.textContent || '';
  });
  const m = nearbyText.match(TOKEN_PATTERN);
  return m ? m[0] : null;
}

/**
 * Extract access token from Shopify admin
 * @param {Page} page - Playwright page instance
 * @param {string|null} [storeDomain] - Store domain used for API endpoint fallbacks
 * @returns {Promise<string|null>} Access token or null if not found
 */
export async function extractAccessToken(page, storeDomain = null) {
  try {
    const revealBtn = page.locator('button:has-text("Reveal"), [role="button"]:has-text("Reveal")');
    if ((await revealBtn.count()) > 0) {
      const n = await revealBtn.count();
      for (let r = 0; r < n; r++) {
        try {
          await revealBtn.nth(r).click();
          await page.waitForTimeout(800);
        } catch {
          // Ignore if click fails
        }
      }
      const already = await extractTokenFromPageContent(page);
      if (already) return already;
    }

    if (!(await navigateToAppsDevelopment(page))) return null;
    await navigateToAppApiCredentialsAndReveal(page);

    const fromContent = await extractTokenFromPageContent(page);
    if (fromContent) return fromContent;

    const fromInputs = await extractTokenFromInputs(page);
    if (fromInputs) return fromInputs;

    const fromApiSection = await extractTokenFromApiSection(page);
    if (fromApiSection) return fromApiSection;

    return await requestAccessTokenFromClientCredentials(page, storeDomain);
  } catch (_error) {
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
 * @returns {Promise<string|null>} Element text content or null
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
