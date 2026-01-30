/**
 * Cursor IDE Navigator
 * Navigate Cursor IDE interface and workspace
 */

import { openCursor } from './cursor-automation.js';
import { clickOnText } from '../input-simulator.js';
import { typeText, pressKey } from '../keyboard-control.js';

/**
 * Navigate to specific view in Cursor
 * @param {string} view - View name ('explorer', 'search', 'source control', 'extensions', etc.)
 * @returns {Promise<boolean>} True if navigated successfully
 */
export async function navigateToView(view) {
  await openCursor();

  // Use Ctrl+Shift+E for explorer, etc.
  const viewShortcuts = {
    explorer: ['control', 'shift', 'e'],
    search: ['control', 'shift', 'f'],
    'source control': ['control', 'shift', 'g'],
    extensions: ['control', 'shift', 'x'],
    terminal: ['control', '`'],
    problems: ['control', 'shift', 'm'],
  };

  const shortcut = viewShortcuts[view.toLowerCase()];
  if (shortcut) {
    await pressKey(shortcut);
    await new Promise((resolve) => setTimeout(resolve, 300));
    return true;
  }

  // Fallback: try clicking on view name
  return await clickOnText(view);
}

/**
 * Open workspace folder
 * @param {string} folderPath - Path to folder
 * @returns {Promise<boolean>} True if opened
 */
export async function openWorkspaceFolder(folderPath) {
  await openCursor();

  // Use File > Open Folder
  await pressKey(['alt', 'f']);
  await new Promise((resolve) => setTimeout(resolve, 200));

  // Navigate to Open Folder
  (await clickOnText('Open Folder')) || (await pressKey('o'));
  await new Promise((resolve) => setTimeout(resolve, 500));

  // Type folder path
  await typeText(folderPath);
  await pressKey('enter');

  return true;
}

/**
 * Navigate file explorer
 * @param {string} filePath - Path to file in explorer
 * @returns {Promise<boolean>} True if navigated
 */
export async function navigateFileExplorer(filePath) {
  // Open explorer view
  await navigateToView('explorer');

  // Click on file path parts
  const parts = filePath.split(/[/\\]/);
  for (const part of parts) {
    if (part) {
      const clicked = await clickOnText(part);
      if (!clicked) {
        // Try typing to search
        await typeText(part);
        await pressKey('enter');
      }
      await new Promise((resolve) => setTimeout(resolve, 200));
    }
  }

  return true;
}

/**
 * Use Cursor's AI features
 * @param {string} action - Action to perform ('compose', 'chat', 'edit')
 * @param {string} prompt - Prompt for AI
 * @returns {Promise<boolean>} True if accessed
 */
export async function useCursorAI(action, prompt) {
  await openCursor();

  // Cursor AI shortcuts (may vary by version)
  // Ctrl+L for chat, Ctrl+K for inline edit, etc.
  const aiShortcuts = {
    chat: ['control', 'l'],
    compose: ['control', 'i'],
    edit: ['control', 'k'],
  };

  const shortcut = aiShortcuts[action.toLowerCase()];
  if (shortcut) {
    await pressKey(shortcut);
    await new Promise((resolve) => setTimeout(resolve, 300));
    await typeText(prompt);
    return true;
  }

  return false;
}
