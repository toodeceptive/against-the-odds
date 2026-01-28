/**
 * System Applications Automation
 * Provides functions for automating Windows system applications
 */

import { findWindow, activateWindow } from '../window-manager.js';
import { typeText, pressKey } from '../keyboard-control.js';
import { execSync } from 'child_process';

/**
 * Open File Explorer
 * @param {string} path - Path to open
 * @returns {Promise<boolean>} True if opened
 */
export async function openFileExplorer(path = null) {
  // Launch File Explorer
  if (path) {
    execSync(`explorer "${path}"`, { stdio: 'ignore' });
  } else {
    execSync('explorer .', { stdio: 'ignore' });
  }
  
  await new Promise(resolve => setTimeout(resolve, 1000));
  
  // Find and activate File Explorer window
  const explorer = await findWindow('File Explorer') || await findWindow('This PC');
  if (explorer) {
    await activateWindow(explorer);
    return true;
  }
  
  return false;
}

/**
 * Open PowerShell
 * @returns {Promise<boolean>} True if opened
 */
export async function openPowerShell() {
  execSync('powershell', { stdio: 'ignore', detached: true });
  await new Promise(resolve => setTimeout(resolve, 1000));
  
  const psWindow = await findWindow('PowerShell') || await findWindow('Windows PowerShell');
  if (psWindow) {
    await activateWindow(psWindow);
    return true;
  }
  
  return false;
}

/**
 * Open Command Prompt
 * @returns {Promise<boolean>} True if opened
 */
export async function openCommandPrompt() {
  execSync('cmd', { stdio: 'ignore', detached: true });
  await new Promise(resolve => setTimeout(resolve, 1000));
  
  const cmdWindow = await findWindow('Command Prompt') || await findWindow('cmd');
  if (cmdWindow) {
    await activateWindow(cmdWindow);
    return true;
  }
  
  return false;
}

/**
 * Open Settings app
 * @returns {Promise<boolean>} True if opened
 */
export async function openSettings() {
  execSync('start ms-settings:', { stdio: 'ignore' });
  await new Promise(resolve => setTimeout(resolve, 2000));
  
  const settings = await findWindow('Settings');
  if (settings) {
    await activateWindow(settings);
    return true;
  }
  
  return false;
}

/**
 * Open Control Panel
 * @returns {Promise<boolean>} True if opened
 */
export async function openControlPanel() {
  execSync('control', { stdio: 'ignore' });
  await new Promise(resolve => setTimeout(resolve, 1000));
  
  const controlPanel = await findWindow('Control Panel');
  if (controlPanel) {
    await activateWindow(controlPanel);
    return true;
  }
  
  return false;
}

/**
 * Open Task Manager
 * @returns {Promise<boolean>} True if opened
 */
export async function openTaskManager() {
  execSync('taskmgr', { stdio: 'ignore' });
  await new Promise(resolve => setTimeout(resolve, 1000));
  
  const taskManager = await findWindow('Task Manager');
  if (taskManager) {
    await activateWindow(taskManager);
    return true;
  }
  
  return false;
}

/**
 * Run PowerShell command
 * @param {string} command - PowerShell command
 * @param {Object} options - Execution options
 * @returns {Promise<string>} Command output
 */
export async function runPowerShellCommand(command, options = {}) {
  const {
    workingDirectory = null,
    waitForCompletion = true
  } = options;

  try {
    const cmd = `powershell -Command "${command}"`;
    const execOptions = {
      cwd: workingDirectory,
      encoding: 'utf-8',
      stdio: waitForCompletion ? 'pipe' : 'ignore'
    };

    if (waitForCompletion) {
      const output = execSync(cmd, execOptions);
      return output.toString();
    } else {
      execSync(cmd, execOptions);
      return '';
    }
  } catch (error) {
    throw new Error(`PowerShell command failed: ${error.message}`);
  }
}

/**
 * Run command in new terminal
 * @param {string} command - Command to run
 * @param {string} terminal - Terminal type ('powershell', 'cmd')
 * @returns {Promise<boolean>} True if executed
 */
export async function runInTerminal(command, terminal = 'powershell') {
  if (terminal === 'powershell') {
    await openPowerShell();
  } else {
    await openCommandPrompt();
  }

  await new Promise(resolve => setTimeout(resolve, 500));
  await typeText(command);
  await pressKey('enter');
  
  return true;
}
