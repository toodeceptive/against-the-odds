/**
 * Keyboard Control Library
 * Provides functions for keyboard input and shortcuts
 */

let robotjs = null;

/**
 * Initialize robotjs
 * @returns {Promise<Object>} RobotJS module
 */
async function getRobotJS() {
  if (!robotjs) {
    try {
      robotjs = await import('robotjs');
    } catch (error) {
      // RobotJS not available, using PowerShell fallback
      return null;
    }
  }
  return robotjs;
}

/**
 * Type text
 * @param {string} text - Text to type
 * @param {Object} options - Typing options
 * @returns {Promise<void>}
 */
export async function typeText(text, options = {}) {
  const {
    delay = 50, // Delay between keystrokes (ms)
    clearFirst = false // Clear existing text first
  } = options;

  const robot = await getRobotJS();

  if (robot) {
    if (clearFirst) {
      // Select all and delete
      robot.keyTap('a', 'control');
      await new Promise(resolve => setTimeout(resolve, 100));
      robot.keyTap('delete');
      await new Promise(resolve => setTimeout(resolve, 100));
    }

    // Type text with delay
    for (const char of text) {
      robot.typeString(char);
      if (delay > 0) {
        await new Promise(resolve => setTimeout(resolve, delay));
      }
    }
  } else {
    // PowerShell fallback using SendKeys
    const { execSync } = await import('child_process');
    const escapedText = text.replace(/'/g, "''").replace(/"/g, '""');
    const script = `
      Add-Type -AssemblyName System.Windows.Forms
      $text = "${escapedText}"
      foreach ($char in $text.ToCharArray()) {
        [System.Windows.Forms.SendKeys]::SendWait($char)
        Start-Sleep -Milliseconds ${delay}
      }
    `;
    execSync(`powershell -Command "${script}"`, { stdio: 'ignore' });
  }
}

/**
 * Press key combination
 * @param {string|Array} keys - Key(s) to press
 * @param {Object} options - Key options
 * @returns {Promise<void>}
 */
export async function pressKey(keys, options = {}) {
  const {
    delay = 100
  } = options;

  const robot = await getRobotJS();

  if (robot) {
    if (Array.isArray(keys)) {
      // Key combination (e.g., ['control', 'c'])
      const modifiers = keys.slice(0, -1);
      const mainKey = keys[keys.length - 1];
      
      // Press modifiers
      modifiers.forEach(mod => {
        robot.keyToggle(mod, 'down');
      });
      
      // Press main key
      robot.keyTap(mainKey);
      
      // Release modifiers
      modifiers.reverse().forEach(mod => {
        robot.keyToggle(mod, 'up');
      });
    } else {
      // Single key
      robot.keyTap(keys);
    }
  } else {
    // PowerShell fallback
    const { execSync } = await import('child_process');
    
    if (Array.isArray(keys)) {
      const modifiers = keys.slice(0, -1);
      const mainKey = keys[keys.length - 1];
      const modString = modifiers.map(m => {
        const modMap = { control: '^', alt: '%', shift: '+' };
        return modMap[m.toLowerCase()] || m;
      }).join('');
      
      const keyMap = {
        'enter': '~',
        'escape': '{ESC}',
        'tab': '{TAB}',
        'backspace': '{BS}',
        'delete': '{DEL}'
      };
      
      const sendKey = keyMap[mainKey.toLowerCase()] || mainKey;
      execSync(
        `powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('${modString}${sendKey}')"`,
        { stdio: 'ignore' }
      );
    } else {
      const keyMap = {
        'enter': '~',
        'escape': '{ESC}',
        'tab': '{TAB}',
        'backspace': '{BS}',
        'delete': '{DEL}'
      };
      const sendKey = keyMap[keys.toLowerCase()] || keys;
      execSync(
        `powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('${sendKey}')"`,
        { stdio: 'ignore' }
      );
    }
  }

  if (delay > 0) {
    await new Promise(resolve => setTimeout(resolve, delay));
  }
}

/**
 * Common keyboard shortcuts
 */
export const Shortcuts = {
  copy: async () => await pressKey(['control', 'c']),
  paste: async () => await pressKey(['control', 'v']),
  cut: async () => await pressKey(['control', 'x']),
  selectAll: async () => await pressKey(['control', 'a']),
  undo: async () => await pressKey(['control', 'z']),
  redo: async () => await pressKey(['control', 'y']),
  save: async () => await pressKey(['control', 's']),
  open: async () => await pressKey(['control', 'o']),
  new: async () => await pressKey(['control', 'n']),
  close: async () => await pressKey(['control', 'w']),
  find: async () => await pressKey(['control', 'f']),
  replace: async () => await pressKey(['control', 'h']),
  refresh: async () => await pressKey(['f5']),
  fullScreen: async () => await pressKey(['f11']),
  altTab: async () => await pressKey(['alt', 'tab']),
  winTab: async () => await pressKey(['command', 'tab']), // Windows key + Tab
  escape: async () => await pressKey(['escape']),
  enter: async () => await pressKey(['enter']),
  tab: async () => await pressKey(['tab'])
};

/**
 * Type text with special character handling
 * @param {string} text - Text to type
 * @param {Object} options - Typing options
 * @returns {Promise<void>}
 */
export async function typeTextSafe(text, options = {}) {
  // Handle special characters that might need escaping
  const specialChars = {
    '\n': () => pressKey('enter'),
    '\t': () => pressKey('tab'),
    '\b': () => pressKey('backspace')
  };

  for (const char of text) {
    if (specialChars[char]) {
      await specialChars[char]();
    } else {
      await typeText(char, { ...options, delay: 0 });
      if (options.delay > 0) {
        await new Promise(resolve => setTimeout(resolve, options.delay));
      }
    }
  }
}

/**
 * Simulate key hold and release
 * @param {string} key - Key to hold
 * @param {string} state - 'down' or 'up'
 * @returns {Promise<void>}
 */
export async function toggleKey(key, state) {
  const robot = await getRobotJS();
  
  if (robot) {
    robot.keyToggle(key, state);
  } else {
    // PowerShell fallback would be more complex
    // For now, just press/release
    if (state === 'down') {
      await pressKey(key);
    }
  }
}
