/**
 * Window Management Library
 * Provides functions for managing windows (find, activate, resize, etc.)
 */

let windowManager = null;

/**
 * Initialize window manager
 * @returns {Promise<Object>} Window manager module
 */
async function getWindowManager() {
  if (!windowManager) {
    try {
      windowManager = await import('node-window-manager');
    } catch (error) {
      // node-window-manager not available, using PowerShell fallback
      return null;
    }
  }
  return windowManager;
}

/**
 * Get all open windows
 * @returns {Promise<Array>} Array of window objects
 */
export async function getAllWindows() {
  const wm = await getWindowManager();
  
  if (wm && wm.default) {
    const manager = new wm.default();
    const windows = manager.getWindows();
    return windows.map(win => ({
      handle: win.id,
      title: win.getTitle(),
      bounds: win.getBounds(),
      process: win.processName,
      path: win.path
    }));
  } else {
    // PowerShell fallback
    return await getWindowsPowerShell();
  }
}

/**
 * Get windows using PowerShell
 * @returns {Promise<Array>} Array of window objects
 */
async function getWindowsPowerShell() {
  const { execSync } = await import('child_process');
  
  const script = `
    Add-Type @"
      using System;
      using System.Runtime.InteropServices;
      using System.Collections.Generic;
      public class Window {
        [DllImport("user32.dll")]
        public static extern bool EnumWindows(EnumWindowsProc enumProc, IntPtr lParam);
        [DllImport("user32.dll")]
        public static extern int GetWindowText(IntPtr hWnd, System.Text.StringBuilder sb, int nMaxCount);
        [DllImport("user32.dll")]
        public static extern bool IsWindowVisible(IntPtr hWnd);
        [DllImport("user32.dll")]
        public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);
        public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
        [StructLayout(LayoutKind.Sequential)]
        public struct RECT {
          public int Left;
          public int Top;
          public int Right;
          public int Bottom;
        }
        public static List<object> GetWindows() {
          var windows = new List<object>();
          EnumWindows((hWnd, lParam) => {
            if (IsWindowVisible(hWnd)) {
              var sb = new System.Text.StringBuilder(256);
              GetWindowText(hWnd, sb, sb.Capacity);
              var title = sb.ToString();
              if (!string.IsNullOrEmpty(title)) {
                GetWindowRect(hWnd, out RECT rect);
                windows.Add(new {
                  handle = hWnd.ToInt64(),
                  title = title,
                  bounds = new {
                    x = rect.Left,
                    y = rect.Top,
                    width = rect.Right - rect.Left,
                    height = rect.Bottom - rect.Top
                  }
                });
              }
            }
            return true;
          }, IntPtr.Zero);
          return windows;
        }
      }
"@
    $windows = [Window]::GetWindows()
    $windows | ConvertTo-Json
  `;

  try {
    const result = execSync(`powershell -Command "${script}"`, { encoding: 'utf-8' });
    const windows = JSON.parse(result);
    return Array.isArray(windows) ? windows : [];
  } catch (error) {
    // Return empty array on error
    return [];
  }
}

/**
 * Find window by title or process name
 * @param {string} searchTerm - Title pattern or process name
 * @param {Object} options - Search options
 * @returns {Promise<Object|null>} Window object or null
 */
export async function findWindow(searchTerm, options = {}) {
  const {
    exactMatch = false,
    caseSensitive = false
  } = options;

  const windows = await getAllWindows();
  
  for (const window of windows) {
    const title = caseSensitive ? window.title : window.title.toLowerCase();
    const search = caseSensitive ? searchTerm : searchTerm.toLowerCase();
    
    let matches = false;
    if (exactMatch) {
      matches = title === search;
    } else {
      matches = title.includes(search) || 
                (window.process && window.process.toLowerCase().includes(search));
    }
    
    if (matches) {
      return window;
    }
  }

  return null;
}

/**
 * Activate window (bring to front and focus)
 * @param {Object|number} window - Window object or handle
 * @returns {Promise<boolean>} True if activated successfully
 */
export async function activateWindow(window) {
  const handle = typeof window === 'object' ? window.handle : window;
  
  const wm = await getWindowManager();
  if (wm && wm.default) {
    try {
      const manager = new wm.default();
      const win = manager.getWindows().find(w => w.id === handle);
      if (win) {
        win.bringToFront();
        win.focus();
        return true;
      }
    } catch {
      // Fallback to PowerShell method
    }
  }

  // PowerShell fallback
  return await activateWindowPowerShell(handle);
}

/**
 * Activate window using PowerShell
 * @param {number} handle - Window handle
 * @returns {Promise<boolean>} True if activated
 */
async function activateWindowPowerShell(handle) {
  const { execSync } = await import('child_process');
  
  const script = `
    Add-Type @"
      using System;
      using System.Runtime.InteropServices;
      public class Window {
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll")]
        public static extern bool SetForegroundWindow(IntPtr hWnd);
        [DllImport("user32.dll")]
        public static extern bool BringWindowToTop(IntPtr hWnd);
        const int SW_RESTORE = 9;
        public static bool Activate(IntPtr hWnd) {
          ShowWindow(hWnd, SW_RESTORE);
          BringWindowToTop(hWnd);
          return SetForegroundWindow(hWnd);
        }
      }
"@
    [Window]::Activate([IntPtr]${handle})
  `;

  try {
    execSync(`powershell -Command "${script}"`, { stdio: 'ignore' });
    await new Promise(resolve => setTimeout(resolve, 300)); // Wait for activation
    return true;
  } catch (error) {
    return false;
  }
}

/**
 * Close window
 * @param {Object|number} window - Window object or handle
 * @returns {Promise<boolean>} True if closed successfully
 */
export async function closeWindow(window) {
  const handle = typeof window === 'object' ? window.handle : window;
  
  const wm = await getWindowManager();
  if (wm && wm.default) {
    try {
      const manager = new wm.default();
      const win = manager.getWindows().find(w => w.id === handle);
      if (win) {
        win.close();
        return true;
      }
    } catch (error) {
      // Fallback to PowerShell method
    }
  }

  // PowerShell fallback
  return await closeWindowPowerShell(handle);
}

/**
 * Close window using PowerShell
 * @param {number} handle - Window handle
 * @returns {Promise<boolean>} True if closed
 */
async function closeWindowPowerShell(handle) {
  const { execSync } = await import('child_process');
  
  const script = `
    Add-Type @"
      using System;
      using System.Runtime.InteropServices;
      public class Window {
        [DllImport("user32.dll")]
        public static extern bool PostMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
        const uint WM_CLOSE = 0x0010;
        public static bool Close(IntPtr hWnd) {
          return PostMessage(hWnd, WM_CLOSE, IntPtr.Zero, IntPtr.Zero);
        }
      }
"@
    [Window]::Close([IntPtr]${handle})
  `;

  try {
    execSync(`powershell -Command "${script}"`, { stdio: 'ignore' });
    return true;
  } catch (error) {
    return false;
  }
}

/**
 * Resize window
 * @param {Object|number} window - Window object or handle
 * @param {number} width - New width
 * @param {number} height - New height
 * @returns {Promise<boolean>} True if resized successfully
 */
export async function resizeWindow(window, width, height) {
  const handle = typeof window === 'object' ? window.handle : window;
  
  const wm = await getWindowManager();
  if (wm && wm.default) {
    try {
      const manager = new wm.default();
      const win = manager.getWindows().find(w => w.id === handle);
      if (win) {
        const bounds = win.getBounds();
        win.setBounds({
          x: bounds.x,
          y: bounds.y,
          width: width,
          height: height
        });
        return true;
      }
    } catch {
      // Resize failed, return false
    }
  }

  // PowerShell fallback would be more complex
  return false;
}

/**
 * Move window
 * @param {Object|number} window - Window object or handle
 * @param {number} x - New X position
 * @param {number} y - New Y position
 * @returns {Promise<boolean>} True if moved successfully
 */
export async function moveWindow(window, x, y) {
  const handle = typeof window === 'object' ? window.handle : window;
  
  const wm = await getWindowManager();
  if (wm && wm.default) {
    try {
      const manager = new wm.default();
      const win = manager.getWindows().find(w => w.id === handle);
      if (win) {
        const bounds = win.getBounds();
        win.setBounds({
          x: x,
          y: y,
          width: bounds.width,
          height: bounds.height
        });
        return true;
      }
    } catch (error) {
      // Move failed, return false
    }
  }

  return false;
}

/**
 * Minimize window
 * @param {Object|number} window - Window object or handle
 * @returns {Promise<boolean>} True if minimized successfully
 */
export async function minimizeWindow(window) {
  const handle = typeof window === 'object' ? window.handle : window;
  
  const wm = await getWindowManager();
  if (wm && wm.default) {
    try {
      const manager = new wm.default();
      const win = manager.getWindows().find(w => w.id === handle);
      if (win) {
        win.minimize();
        return true;
      }
    } catch {
      // Fallback to PowerShell method
    }
  }

  return await minimizeWindowPowerShell(handle);
}

/**
 * Minimize window using PowerShell
 * @param {number} handle - Window handle
 * @returns {Promise<boolean>} True if minimized
 */
async function minimizeWindowPowerShell(handle) {
  const { execSync } = await import('child_process');
  
  const script = `
    Add-Type @"
      using System;
      using System.Runtime.InteropServices;
      public class Window {
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        const int SW_MINIMIZE = 6;
        public static bool Minimize(IntPtr hWnd) {
          return ShowWindow(hWnd, SW_MINIMIZE);
        }
      }
"@
    [Window]::Minimize([IntPtr]${handle})
  `;

  try {
    execSync(`powershell -Command "${script}"`, { stdio: 'ignore' });
    return true;
  } catch (error) {
    return false;
  }
}

/**
 * Maximize window
 * @param {Object|number} window - Window object or handle
 * @returns {Promise<boolean>} True if maximized successfully
 */
export async function maximizeWindow(window) {
  const handle = typeof window === 'object' ? window.handle : window;
  
  const wm = await getWindowManager();
  if (wm && wm.default) {
    try {
      const manager = new wm.default();
      const win = manager.getWindows().find(w => w.id === handle);
      if (win) {
        win.maximize();
        return true;
      }
    } catch (error) {
      // Fallback to PowerShell method
    }
  }

  return await maximizeWindowPowerShell(handle);
}

/**
 * Maximize window using PowerShell
 * @param {number} handle - Window handle
 * @returns {Promise<boolean>} True if maximized
 */
async function maximizeWindowPowerShell(handle) {
  const { execSync } = await import('child_process');
  
  const script = `
    Add-Type @"
      using System;
      using System.Runtime.InteropServices;
      public class Window {
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        const int SW_MAXIMIZE = 3;
        public static bool Maximize(IntPtr hWnd) {
          return ShowWindow(hWnd, SW_MAXIMIZE);
        }
      }
"@
    [Window]::Maximize([IntPtr]${handle})
  `;

  try {
    execSync(`powershell -Command "${script}"`, { stdio: 'ignore' });
    return true;
  } catch (error) {
    return false;
  }
}
