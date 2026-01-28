/**
 * Cursor IDE Automation
 * Provides functions for automating Cursor IDE operations
 */

import { findWindow, activateWindow } from '../window-manager.js';
import { typeText, pressKey, Shortcuts } from '../keyboard-control.js';
import { analyzeScreen } from '../screen-analyzer.js';

/**
 * Open Cursor IDE
 * @returns {Promise<Object>} Cursor window object
 */
export async function openCursor() {
  // Find Cursor window
  const cursorWindow = await findWindow('Cursor');
  
  if (!cursorWindow) {
    // Try to launch Cursor (would need path)
    // For now, assume it's already running or user needs to launch
    throw new Error('Cursor IDE not found. Please launch Cursor first.');
  }
  
  // Activate window
  await activateWindow(cursorWindow);
  await new Promise(resolve => setTimeout(resolve, 500));
  
  return cursorWindow;
}

/**
 * Open file in Cursor
 * @param {string} filePath - Path to file
 * @returns {Promise<boolean>} True if opened successfully
 */
export async function openFile(filePath) {
  await openCursor();
  
  // Use Ctrl+P to open file
  await pressKey(['control', 'p']);
  await new Promise(resolve => setTimeout(resolve, 300));
  
  // Type file path
  await typeText(filePath);
  await new Promise(resolve => setTimeout(resolve, 500));
  
  // Press Enter to open
  await pressKey('enter');
  
  return true;
}

/**
 * Use Cursor command
 * @param {string} command - Command to execute
 * @returns {Promise<boolean>} True if command executed
 */
export async function executeCommand(command) {
  await openCursor();
  
  // Use Ctrl+Shift+P for command palette
  await pressKey(['control', 'shift', 'p']);
  await new Promise(resolve => setTimeout(resolve, 300));
  
  // Type command
  await typeText(command);
  await new Promise(resolve => setTimeout(resolve, 500));
  
  // Press Enter
  await pressKey('enter');
  
  return true;
}

/**
 * Navigate editor tabs
 * @param {string} direction - 'next' or 'previous'
 * @returns {Promise<void>}
 */
export async function navigateTabs(direction) {
  await openCursor();
  
  if (direction === 'next') {
    await pressKey(['control', 'pagedown']);
  } else if (direction === 'previous') {
    await pressKey(['control', 'pageup']);
  }
}

/**
 * Close current tab
 * @returns {Promise<void>}
 */
export async function closeTab() {
  await openCursor();
  await pressKey(['control', 'w']);
}

/**
 * Save current file
 * @returns {Promise<void>}
 */
export async function saveFile() {
  await openCursor();
  await Shortcuts.save();
}

/**
 * Access Cursor agent features
 * @param {string} prompt - Prompt for agent
 * @returns {Promise<boolean>} True if accessed
 */
export async function accessAgent(prompt) {
  await openCursor();
  
  // Open agent panel (Ctrl+L or Cursor-specific shortcut)
  // This would depend on Cursor's actual shortcuts
  await pressKey(['control', 'l']);
  await new Promise(resolve => setTimeout(resolve, 300));
  
  // Type prompt
  await typeText(prompt);
  
  return true;
}

/**
 * Get current file information from Cursor
 * @returns {Promise<Object|null>} File information or null
 */
export async function getCurrentFile() {
  await openCursor();
  
  // Analyze screen to get current file name
  const analysis = await analyzeScreen();
  
  // Try to find file name in screen text
  // Cursor typically shows file name in title or tab
  const fileMatch = analysis.text.match(/([^/\\]+\.(js|ts|json|md|ps1|yml|yaml|html|css))$/i);
  
  if (fileMatch) {
    return {
      name: fileMatch[1],
      path: null // Would need more sophisticated extraction
    };
  }
  
  return null;
}

/**
 * Search in Cursor
 * @param {string} searchText - Text to search for
 * @returns {Promise<boolean>} True if search executed
 */
export async function searchInCursor(searchText) {
  await openCursor();
  await Shortcuts.find();
  await new Promise(resolve => setTimeout(resolve, 200));
  await typeText(searchText);
  return true;
}

/**
 * Replace in Cursor
 * @param {string} findText - Text to find
 * @param {string} replaceText - Text to replace with
 * @returns {Promise<boolean>} True if replace executed
 */
export async function replaceInCursor(findText, replaceText) {
  await openCursor();
  await Shortcuts.replace();
  await new Promise(resolve => setTimeout(resolve, 200));
  await typeText(findText);
  await pressKey('tab');
  await typeText(replaceText);
  return true;
}
