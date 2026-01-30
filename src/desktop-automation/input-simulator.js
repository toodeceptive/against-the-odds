/**
 * Input Simulator Utilities
 * High-level input simulation functions combining mouse and keyboard
 */

import { clickMouse } from './mouse-control.js';
import { typeText, pressKey, Shortcuts } from './keyboard-control.js';

/**
 * Click on text element (find text and click)
 * @param {string} text - Text to find and click
 * @param {Object} options - Click options
 * @returns {Promise<boolean>} True if clicked successfully
 */
export async function clickOnText(text, options = {}) {
  const { findElementByText } = await import('./screen-analyzer.js');

  const element = await findElementByText(text, options);

  if (element) {
    await clickMouse('left', {
      x: element.position.x,
      y: element.position.y,
      ...options,
    });
    return true;
  }

  return false;
}

/**
 * Fill form field
 * @param {string} fieldLabel - Label of the field to fill
 * @param {string} value - Value to enter
 * @param {Object} options - Fill options
 * @returns {Promise<boolean>} True if filled successfully
 */
export async function fillFormField(fieldLabel, value, options = {}) {
  const { clearFirst = true, submitAfter = false } = options;

  // Find and click on the field label or field itself
  const clicked = await clickOnText(fieldLabel);

  if (!clicked) {
    // Try clicking on input field directly
    // This would need more sophisticated detection
    return false;
  }

  // Wait a moment for field to be focused
  await new Promise((resolve) => setTimeout(resolve, 200));

  // Clear existing content if needed
  if (clearFirst) {
    await Shortcuts.selectAll();
    await pressKey('delete');
    await new Promise((resolve) => setTimeout(resolve, 100));
  }

  // Type the value
  await typeText(value);

  // Submit if requested
  if (submitAfter) {
    await new Promise((resolve) => setTimeout(resolve, 100));
    await pressKey('enter');
  }

  return true;
}

/**
 * Click button by text
 * @param {string} buttonText - Button text
 * @param {Object} options - Click options
 * @returns {Promise<boolean>} True if clicked successfully
 */
export async function clickButton(buttonText, options = {}) {
  return await clickOnText(buttonText, options);
}

/**
 * Navigate menu
 * @param {Array<string>} menuPath - Array of menu items to navigate
 * @param {Object} options - Navigation options
 * @returns {Promise<boolean>} True if navigation successful
 */
export async function navigateMenu(menuPath, options = {}) {
  const { delay = 200 } = options;

  for (const menuItem of menuPath) {
    // Click on menu item
    const clicked = await clickOnText(menuItem);

    if (!clicked) {
      // Try keyboard navigation as fallback
      // Type first letter and press enter
      await typeText(menuItem[0]);
      await new Promise((resolve) => setTimeout(resolve, 300));
      await pressKey('enter');
    }

    await new Promise((resolve) => setTimeout(resolve, delay));
  }

  return true;
}

/**
 * Drag element from one position to another
 * @param {number} startX - Start X
 * @param {number} startY - Start Y
 * @param {number} endX - End X
 * @param {number} endY - End Y
 * @param {Object} options - Drag options
 * @returns {Promise<void>}
 */
export async function dragElement(startX, startY, endX, endY, options = {}) {
  const { dragAndDrop } = await import('./mouse-control.js');
  await dragAndDrop(startX, startY, endX, endY, options);
}

/**
 * Select text by dragging
 * @param {number} startX - Start X
 * @param {number} startY - Start Y
 * @param {number} endX - End X
 * @param {number} endY - End Y
 * @returns {Promise<void>}
 */
export async function selectText(startX, startY, endX, endY) {
  // Click at start position
  await clickMouse('left', { x: startX, y: startY });
  await new Promise((resolve) => setTimeout(resolve, 100));

  // Drag to end position
  const { dragAndDrop } = await import('./mouse-control.js');
  await dragAndDrop(startX, startY, endX, endY, { button: 'left' });
}

/**
 * Right-click at position
 * @param {number} x - X coordinate
 * @param {number} y - Y coordinate
 * @param {Object} options - Click options
 * @returns {Promise<void>}
 */
export async function rightClick(x, y, options = {}) {
  await clickMouse('right', { x, y, ...options });
}

/**
 * Double-click at position
 * @param {number} x - X coordinate
 * @param {number} y - Y coordinate
 * @param {Object} options - Click options
 * @returns {Promise<void>}
 */
export async function doubleClick(x, y, options = {}) {
  await clickMouse('left', { x, y, double: true, ...options });
}

/**
 * Wait for element to appear and click
 * @param {string} text - Text to wait for
 * @param {Object} options - Wait options
 * @returns {Promise<boolean>} True if element appeared and clicked
 */
export async function waitAndClick(text, options = {}) {
  const { timeout = 10000, interval = 500, maxAttempts = null } = options;

  const attempts = maxAttempts || timeout / interval;
  const startTime = Date.now();

  for (let i = 0; i < attempts; i++) {
    if (Date.now() - startTime > timeout) {
      return false;
    }

    const clicked = await clickOnText(text);
    if (clicked) {
      return true;
    }

    await new Promise((resolve) => setTimeout(resolve, interval));
  }

  return false;
}
