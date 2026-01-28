/**
 * Enhanced Browser Automation
 * Extends Playwright with desktop automation for browser window control
 */

import { findWindow, activateWindow } from '../window-manager.js';
import { pressKey, typeText, Shortcuts } from '../keyboard-control.js';

/**
 * Find browser window
 * @param {string} browser - Browser type ('chrome', 'firefox', 'edge')
 * @returns {Promise<Object|null>} Browser window or null
 */
export async function findBrowserWindow(browser = 'chrome') {
  const browserNames = {
    'chrome': ['Chrome', 'Google Chrome'],
    'firefox': ['Firefox', 'Mozilla Firefox'],
    'edge': ['Edge', 'Microsoft Edge']
  };
  
  const names = browserNames[browser.toLowerCase()] || browserNames['chrome'];
  
  for (const name of names) {
    const window = await findWindow(name);
    if (window) {
      return window;
    }
  }
  
  return null;
}

/**
 * Activate browser window
 * @param {string} browser - Browser type
 * @returns {Promise<boolean>} True if activated
 */
export async function activateBrowser(browser = 'chrome') {
  const window = await findBrowserWindow(browser);
  if (window) {
    await activateWindow(window);
    await new Promise(resolve => setTimeout(resolve, 500));
    return true;
  }
  return false;
}

/**
 * Navigate browser tabs
 * @param {string} direction - 'next' or 'previous'
 * @param {string} browser - Browser type
 * @returns {Promise<void>}
 */
export async function navigateBrowserTabs(direction, browser = 'chrome') {
  await activateBrowser(browser);
  
  if (direction === 'next') {
    await pressKey(['control', 'pagedown']);
  } else if (direction === 'previous') {
    await pressKey(['control', 'pageup']);
  }
}

/**
 * Close current browser tab
 * @param {string} browser - Browser type
 * @returns {Promise<void>}
 */
export async function closeBrowserTab(browser = 'chrome') {
  await activateBrowser(browser);
  await pressKey(['control', 'w']);
}

/**
 * Open new browser tab
 * @param {string} browser - Browser type
 * @returns {Promise<void>}
 */
export async function openBrowserTab(browser = 'chrome') {
  await activateBrowser(browser);
  await pressKey(['control', 't']);
}

/**
 * Navigate to URL in browser
 * @param {string} url - URL to navigate to
 * @param {string} browser - Browser type
 * @returns {Promise<void>}
 */
export async function navigateToURL(url, browser = 'chrome') {
  await activateBrowser(browser);
  
  // Focus address bar
  await pressKey(['control', 'l']);
  await new Promise(resolve => setTimeout(resolve, 200));
  
  // Type URL
  await typeText(url);
  await pressKey('enter');
}

/**
 * Refresh browser page
 * @param {string} browser - Browser type
 * @returns {Promise<void>}
 */
export async function refreshBrowser(browser = 'chrome') {
  await activateBrowser(browser);
  await Shortcuts.refresh();
}

/**
 * Get all browser tabs (via window analysis)
 * @param {string} browser - Browser type
 * @returns {Promise<Array>} Array of tab information
 */
export async function getBrowserTabs(browser = 'chrome') {
  await activateBrowser(browser);
  
  // Extract tab information from screen text
  // This would need more sophisticated parsing
  const tabs = [];
  
  // Look for tab indicators in screen text
  // Browser-specific implementation would be needed
  
  return tabs;
}

/**
 * Switch to specific browser tab
 * @param {number} tabIndex - Tab index (1-based)
 * @param {string} browser - Browser type
 * @returns {Promise<void>}
 */
export async function switchToTab(tabIndex, browser = 'chrome') {
  await activateBrowser(browser);
  
  // Use Ctrl+1, Ctrl+2, etc. for tab switching
  if (tabIndex >= 1 && tabIndex <= 9) {
    await pressKey(['control', tabIndex.toString()]);
  }
}
