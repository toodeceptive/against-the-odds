/**
 * Screen Capture Library
 * Provides functions for capturing screen content (full screen, regions, windows)
 */

import screenshot from 'screenshot-desktop';
import { writeFile } from 'fs/promises';
import { join } from 'path';

/**
 * Capture full screen
 * @param {Object} options - Capture options
 * @returns {Promise<Buffer>} Screenshot image buffer
 */
export async function captureScreen(options = {}) {
  const {
    screen = 0, // Screen index (for multi-monitor)
    filename = null, // Optional: save to file
  } = options;

  const img = await screenshot({ screen, filename: null });

  // Save to file if filename provided
  if (filename) {
    const screenshotsDir = 'docs/screenshots';
    const filepath = join(screenshotsDir, filename);
    await writeFile(filepath, img);
  }

  return img;
}

/**
 * Capture specific screen region
 * @param {Object} region - Region coordinates {x, y, width, height}
 * @param {Object} options - Capture options
 * @returns {Promise<Buffer>} Screenshot image buffer
 */
export async function captureRegion(region, options = {}) {
  const { x, y, width, height } = region;

  // Capture full screen first, then crop
  const fullScreen = await captureScreen(options);

  // Use sharp for cropping (will be imported when available)
  try {
    const sharp = await import('sharp');
    const cropped = await sharp
      .default(fullScreen)
      .extract({ left: x, top: y, width, height })
      .toBuffer();

    if (options.filename) {
      await writeFile(options.filename, cropped);
    }

    return cropped;
  } catch (_error) {
    // Fallback: return full screen if cropping fails
    return fullScreen;
  }
}

/**
 * Capture specific window
 * @param {string} windowTitle - Window title or process name
 * @param {Object} options - Capture options
 * @returns {Promise<Buffer>} Screenshot image buffer
 */
export async function captureWindow(windowTitle, options = {}) {
  // First, find and activate the window
  const { findWindow, activateWindow } = await import('./window-manager.js');
  const window = await findWindow(windowTitle);

  if (!window) {
    throw new Error(`Window not found: ${windowTitle}`);
  }

  // Activate window to bring to front
  await activateWindow(window.handle);

  // Wait a moment for window to be ready
  await new Promise((resolve) => setTimeout(resolve, 500));

  // Capture screen (window should be in front)
  const screenshot = await captureScreen(options);

  // If window bounds are available, crop to window
  if (window.bounds) {
    return await captureRegion(window.bounds, options);
  }

  return screenshot;
}

/**
 * Capture multiple screens (for multi-monitor setups)
 * @param {Object} options - Capture options
 * @returns {Promise<Array<Buffer>>} Array of screenshot buffers
 */
export async function captureAllScreens() {
  const screenshots = [];

  // Try to capture up to 4 screens
  for (let i = 0; i < 4; i++) {
    try {
      const img = await screenshot({ screen: i, filename: null });
      screenshots.push({ screen: i, image: img });
    } catch (_error) {
      // No more screens
      break;
    }
  }

  return screenshots;
}

/**
 * Get screen dimensions
 * @returns {Promise<Object>} Screen dimensions {width, height}
 */
export async function getScreenDimensions() {
  try {
    // Capture a small test screenshot to get dimensions
    const img = await captureScreen();
    const sharp = await import('sharp');
    const metadata = await sharp.default(img).metadata();

    return {
      width: metadata.width,
      height: metadata.height,
    };
  } catch {
    // Default fallback
    return { width: 1920, height: 1080 };
  }
}

/**
 * Save screenshot with timestamp
 * @param {Buffer} imageBuffer - Image buffer to save
 * @param {string} prefix - Filename prefix
 * @returns {Promise<string>} File path
 */
export async function saveScreenshot(imageBuffer, prefix = 'screenshot') {
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const filename = `${prefix}-${timestamp}.png`;
  const filepath = join('docs/screenshots', filename);

  await writeFile(filepath, imageBuffer);
  return filepath;
}
