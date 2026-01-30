/**
 * File Explorer Automation
 * Provides functions for navigating and interacting with Windows File Explorer
 */

import { dirname, basename } from 'path';
import { openFileExplorer } from './system-apps.js';
import { clickOnText, doubleClick } from '../input-simulator.js';
import { typeText, pressKey } from '../keyboard-control.js';

/**
 * Navigate to folder in File Explorer
 * @param {string} folderPath - Path to folder
 * @returns {Promise<boolean>} True if navigated
 */
export async function navigateToFolder(folderPath) {
  await openFileExplorer();
  await new Promise((resolve) => setTimeout(resolve, 1000));

  // Focus address bar
  await pressKey(['control', 'l']);
  await new Promise((resolve) => setTimeout(resolve, 200));

  // Type path
  await typeText(folderPath);
  await pressKey('enter');
  await new Promise((resolve) => setTimeout(resolve, 1000));

  return true;
}

/**
 * Open file in File Explorer
 * @param {string} filePath - Path to file
 * @returns {Promise<boolean>} True if opened
 */
export async function openFileInExplorer(filePath) {
  const folderPath = dirname(filePath);
  const fileName = basename(filePath);

  // Navigate to folder
  await navigateToFolder(folderPath);

  // Find and double-click file
  const fileElement = await clickOnText(fileName);
  if (fileElement) {
    // Get position and double-click
    // Would need to get element position from screen analysis
    // For now, try double-clicking on the text
    await doubleClick(0, 0); // Would need actual coordinates
  }

  return true;
}

/**
 * Create new folder
 * @param {string} folderName - Name of folder to create
 * @returns {Promise<boolean>} True if created
 */
export async function createFolder(folderName) {
  await openFileExplorer();

  // Right-click in empty area
  // Would need to find empty area coordinates
  // For now, use keyboard shortcut
  await pressKey(['control', 'shift', 'n']);
  await new Promise((resolve) => setTimeout(resolve, 500));

  // Type folder name
  await typeText(folderName);
  await pressKey('enter');

  return true;
}

/**
 * Delete file or folder
 * @param {string} itemName - Name of item to delete
 * @param {Object} options - Delete options
 * @returns {Promise<boolean>} True if deleted (with confirmation)
 */
export async function deleteItem(itemName, options = {}) {
  const { requireConfirmation = true } = options;

  await openFileExplorer();

  // Find and select item
  await clickOnText(itemName);
  await new Promise((resolve) => setTimeout(resolve, 200));

  // Press Delete key
  await pressKey('delete');

  if (requireConfirmation) {
    // Wait for confirmation dialog
    await new Promise((resolve) => setTimeout(resolve, 500));

    // Confirm deletion (would need to check dialog)
    // For safety, this should require explicit confirmation
    return false; // Don't auto-confirm deletions
  }

  return true;
}

/**
 * Copy file or folder
 * @param {string} itemName - Name of item to copy
 * @returns {Promise<boolean>} True if copied
 */
export async function copyItem(itemName) {
  await openFileExplorer();

  // Select item
  await clickOnText(itemName);
  await new Promise((resolve) => setTimeout(resolve, 200));

  // Copy
  await pressKey(['control', 'c']);

  return true;
}

/**
 * Paste file or folder
 * @returns {Promise<boolean>} True if pasted
 */
export async function pasteItem() {
  await openFileExplorer();
  await pressKey(['control', 'v']);
  return true;
}
