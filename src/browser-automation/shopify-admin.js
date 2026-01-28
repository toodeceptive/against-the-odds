/**
 * Shopify Admin Browser Automation Library
 * Provides reusable functions for interacting with Shopify admin interface
 */

// Browser automation library for Shopify admin
// Uses Playwright for browser automation

let playwright;
try {
  playwright = require('@playwright/test');
} catch {
  // Playwright not available, will use dynamic import
}

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
  const { 
    useExisting = true,
    headless = false,
    slowMo = 0 
  } = options;

  const pw = await getPlaywright();
  const { chromium } = pw;

  // Try to connect to existing Chrome instance
  if (useExisting) {
    try {
      const browser = await chromium.connectOverCDP('http://localhost:9222');
      // Connected to existing Chrome instance
      return browser;
    } catch (error) {
      // Could not connect to existing Chrome, launching new instance
    }
  }
  
  // Launch new browser instance
  const browser = await chromium.launch({
    headless,
    slowMo,
    channel: 'chrome',
    args: [
      '--disable-blink-features=AutomationControlled',
      '--remote-debugging-port=9222',
    ],
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
    await page.goto(adminUrl, { waitUntil: 'networkidle' });
    
    // Check if already logged in (no login form)
    const loginForm = await page.locator('form[action*="login"]').count();
    if (loginForm === 0) {
      // Already logged in to Shopify admin
      return true;
    }
    
    // If login form exists, user needs to log in manually
    // Login required - waiting for manual login
    await page.waitForURL(adminUrl, { timeout: 120000 }); // Wait up to 2 minutes
    
    return true;
  } catch (error) {
    // Failed to access Shopify admin
    return false;
  }
}

/**
 * Navigate to Shopify Apps > Development page
 * @param {Page} page - Playwright page instance
 * @returns {Promise<boolean>} True if navigation successful
 */
export async function navigateToAppsDevelopment(page) {
  try {
    // Navigate to apps page
    await page.goto('/admin/apps/development', { waitUntil: 'networkidle' });
    
    // Wait for page to load
    await page.waitForSelector('h1, [data-testid="apps-page"]', { timeout: 10000 });
    
    return true;
  } catch {
    // Failed to navigate to Apps > Development
    return false;
  }
}

/**
 * Extract access token from Shopify admin
 * @param {Page} page - Playwright page instance
 * @returns {Promise<string|null>} Access token or null if not found
 */
export async function extractAccessToken(page) {
  try {
    const success = await navigateToAppsDevelopment(page);
    if (!success) {
      return null;
    }
    
    // Look for access token in various possible locations
    // Method 1: Check for token in page content
    const tokenPattern = /shpat_[a-zA-Z0-9]{32,}/;
    const pageContent = await page.content();
    const tokenMatch = pageContent.match(tokenPattern);
    
    if (tokenMatch) {
      return tokenMatch[0];
    }
    
    // Method 2: Look for token in data attributes
    const tokenElement = await page.locator('[data-access-token], [data-token], input[value*="shpat_"]').first();
    if (await tokenElement.count() > 0) {
      const token = await tokenElement.getAttribute('value') || 
                   await tokenElement.getAttribute('data-access-token') ||
                   await tokenElement.getAttribute('data-token');
      if (token && token.startsWith('shpat_')) {
        return token;
      }
    }
    
    // Method 3: Check API credentials section
    const apiSection = page.locator('text=/API.*[Cc]redential/i, text=/Access.*[Tt]oken/i');
    if (await apiSection.count() > 0) {
      // Try to find token in nearby elements
      const nearbyText = await apiSection.first().evaluate((el) => {
        const parent = el.closest('section, div, form') || el.parentElement;
        return parent?.textContent || '';
      });
      
      const tokenMatch = nearbyText.match(tokenPattern);
      if (tokenMatch) {
        return tokenMatch[0];
      }
    }
    
    // Access token not found on page
    return null;
  } catch (error) {
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
    const liveTheme = await page.locator('[data-theme-role="main"], .theme[data-role="main"]').first();
    if (await liveTheme.count() > 0) {
      const themeId = await liveTheme.getAttribute('data-theme-id') ||
                     await liveTheme.getAttribute('data-id');
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
  } catch (error) {
    // Error extracting text
    return null;
  }
}
