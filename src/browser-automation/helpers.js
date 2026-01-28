/**
 * Browser Automation Helper Utilities
 * Common functions for browser automation tasks
 */

/**
 * Wait for network to be idle
 * @param {Page} page - Playwright page instance
 * @param {number} timeout - Timeout in milliseconds
 */
export async function waitForNetworkIdle(page, timeout = 30000) {
  try {
    await page.waitForLoadState('networkidle', { timeout });
  } catch (error) {
    console.warn('Network idle timeout:', error.message);
  }
}

/**
 * Retry function with exponential backoff
 * @param {Function} fn - Function to retry
 * @param {number} maxRetries - Maximum number of retries
 * @param {number} delay - Initial delay in milliseconds
 * @returns {Promise<any>} Function result
 */
export async function retryWithBackoff(fn, maxRetries = 3, delay = 1000) {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error) {
      if (attempt === maxRetries) {
        throw error;
      }
      const waitTime = delay * Math.pow(2, attempt - 1);
      console.log(`Attempt ${attempt} failed, retrying in ${waitTime}ms...`);
      await new Promise(resolve => setTimeout(resolve, waitTime));
    }
  }
}

/**
 * Safe element click with retry
 * @param {Locator} element - Playwright locator
 * @param {Object} options - Click options
 */
export async function safeClick(element, options = {}) {
  await retryWithBackoff(async () => {
    await element.waitFor({ state: 'visible', timeout: 10000 });
    await element.click(options);
  });
}

/**
 * Fill form field safely
 * @param {Locator} field - Form field locator
 * @param {string} value - Value to fill
 */
export async function safeFill(field, value) {
  await retryWithBackoff(async () => {
    await field.waitFor({ state: 'visible', timeout: 10000 });
    await field.clear();
    await field.fill(value);
  });
}

/**
 * Extract data from table
 * @param {Page} page - Playwright page instance
 * @param {string} tableSelector - Table CSS selector
 * @returns {Promise<Array<Object>>} Table data as array of objects
 */
export async function extractTableData(page, tableSelector) {
  try {
    await page.waitForSelector(tableSelector, { timeout: 10000 });
    
    const tableData = await page.evaluate((selector) => {
      const table = document.querySelector(selector);
      if (!table) return [];
      
      const headers = Array.from(table.querySelectorAll('thead th, tr:first-child th, tr:first-child td')).map(
        th => th.textContent.trim()
      );
      
      const rows = Array.from(table.querySelectorAll('tbody tr, tr:not(:first-child)'));
      return rows.map(row => {
        const cells = Array.from(row.querySelectorAll('td, th'));
        const rowData = {};
        cells.forEach((cell, index) => {
          if (headers[index]) {
            rowData[headers[index]] = cell.textContent.trim();
          }
        });
        return rowData;
      });
    }, tableSelector);
    
    return tableData;
  } catch (error) {
    console.error('Error extracting table data:', error);
    return [];
  }
}

/**
 * Check if element exists
 * @param {Page} page - Playwright page instance
 * @param {string} selector - CSS selector
 * @returns {Promise<boolean>} True if element exists
 */
export async function elementExists(page, selector) {
  try {
    const count = await page.locator(selector).count();
    return count > 0;
  } catch {
    return false;
  }
}

/**
 * Wait for element to appear or disappear
 * @param {Page} page - Playwright page instance
 * @param {string} selector - CSS selector
 * @param {boolean} shouldExist - True to wait for appearance, false for disappearance
 * @param {number} timeout - Timeout in milliseconds
 */
export async function waitForElementState(page, selector, shouldExist = true, timeout = 10000) {
  if (shouldExist) {
    await page.waitForSelector(selector, { timeout, state: 'visible' });
  } else {
    await page.waitForSelector(selector, { timeout, state: 'hidden' });
  }
}
