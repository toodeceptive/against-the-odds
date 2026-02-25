/**
 * Mouse Control Library
 * Provides functions for controlling mouse (movement, clicks, drag and drop)
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
    } catch (_error) {
      // RobotJS not available, using PowerShell fallback
      return null;
    }
  }
  return robotjs;
}

/**
 * Get current mouse position
 * @returns {Promise<Object>} Mouse position {x, y}
 */
export async function getMousePosition() {
  const robot = await getRobotJS();

  if (robot) {
    const pos = robot.getMousePos();
    return { x: pos.x, y: pos.y };
  } else {
    // PowerShell fallback
    const { execSync } = await import('child_process');
    try {
      const result = execSync(
        'powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $pos = [System.Windows.Forms.Cursor]::Position; Write-Output \'X=$($pos.X), Y=$($pos.Y)\'"',
        {
          encoding: 'utf-8',
        },
      );
      const match = result.match(/X=(\d+), Y=(\d+)/);
      if (match) {
        return { x: parseInt(match[1]), y: parseInt(match[2]) };
      }
    } catch (_error) {
      // Fallback to default position if PowerShell fails
    }
    return { x: 0, y: 0 };
  }
}

/**
 * Move mouse to absolute position
 * @param {number} x - X coordinate
 * @param {number} y - Y coordinate
 * @param {Object} options - Movement options
 * @returns {Promise<void>}
 */
export async function moveMouse(x, y, options = {}) {
  const { smooth = false, duration = 0 } = options;

  if (!Number.isFinite(x) || !Number.isFinite(y)) {
    throw new TypeError('Mouse coordinates must be finite numbers');
  }

  const robot = await getRobotJS();

  if (robot) {
    if (smooth && duration > 0) {
      // Smooth movement
      const current = robot.getMousePos();
      const steps = Math.max(Math.abs(x - current.x), Math.abs(y - current.y));
      const delay = duration / steps;

      for (let i = 0; i <= steps; i++) {
        const progress = i / steps;
        const newX = Math.round(current.x + (x - current.x) * progress);
        const newY = Math.round(current.y + (y - current.y) * progress);
        robot.moveMouse(newX, newY);
        await new Promise((resolve) => setTimeout(resolve, delay));
      }
    } else {
      robot.moveMouse(x, y);
    }
  } else {
    // PowerShell fallback
    const { execSync } = await import('child_process');
    try {
      execSync(
        `powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(${x}, ${y})"`,
        { stdio: 'ignore' },
      );
    } catch (_error) {
      // Silently fail if PowerShell command doesn't work
    }
  }
}

/**
 * Move mouse relative to current position
 * @param {number} deltaX - X offset
 * @param {number} deltaY - Y offset
 * @param {Object} options - Movement options
 * @returns {Promise<void>}
 */
export async function moveMouseRelative(deltaX, deltaY, options = {}) {
  if (!Number.isFinite(deltaX) || !Number.isFinite(deltaY)) {
    throw new TypeError('Mouse delta values must be finite numbers');
  }
  const current = await getMousePosition();
  await moveMouse(current.x + deltaX, current.y + deltaY, options);
}

/**
 * Click mouse button
 * @param {string} button - Button to click ('left', 'right', 'middle')
 * @param {Object} options - Click options
 * @returns {Promise<void>}
 */
export async function clickMouse(button = 'left', options = {}) {
  const { x = null, y = null, double = false, delay = 100 } = options;

  // Move to position if specified
  if (x !== null && y !== null) {
    await moveMouse(x, y);
    await new Promise((resolve) => setTimeout(resolve, 50)); // Small delay
  }

  const robot = await getRobotJS();

  if (robot) {
    if (button === 'left') {
      if (double) {
        robot.mouseClick('left', true);
      } else {
        robot.mouseClick();
      }
    } else if (button === 'right') {
      robot.mouseClick('right');
    } else if (button === 'middle') {
      robot.mouseClick('middle');
    }
  } else {
    // PowerShell fallback using Windows API
    const { execSync } = await import('child_process');
    const { writeFileSync, unlinkSync } = await import('fs');
    const { tmpdir } = await import('os');
    const { join } = await import('path');
    const mouseDownFlag = button === 'right' ? 0x0008 : 0x0002; // RIGHTDOWN or LEFTDOWN
    const mouseUpFlag = button === 'right' ? 0x0010 : 0x0004; // RIGHTUP or LEFTUP

    const psScriptPath = join(tmpdir(), `mouse-click-${Date.now()}.ps1`);
    let psScript;

    if (x !== null && y !== null) {
      // Move cursor and click
      psScript = `$code = @'
using System;
using System.Runtime.InteropServices;
public class Mouse {
  [DllImport("user32.dll")]
  public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint dwData, int dwExtraInfo);
  [DllImport("user32.dll")]
  public static extern bool SetCursorPos(int x, int y);
}
'@
Add-Type -TypeDefinition $code
[Mouse]::SetCursorPos(${x}, ${y})
Start-Sleep -Milliseconds 50
[Mouse]::mouse_event(${mouseDownFlag}, 0, 0, 0, 0)
Start-Sleep -Milliseconds 10
[Mouse]::mouse_event(${mouseUpFlag}, 0, 0, 0, 0)`;
    } else {
      // Click at current position
      psScript = `$code = @'
using System;
using System.Runtime.InteropServices;
public class Mouse {
  [DllImport("user32.dll")]
  public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint dwData, int dwExtraInfo);
}
'@
Add-Type -TypeDefinition $code
[Mouse]::mouse_event(${mouseDownFlag}, 0, 0, 0, 0)
Start-Sleep -Milliseconds 10
[Mouse]::mouse_event(${mouseUpFlag}, 0, 0, 0, 0)`;
    }

    try {
      writeFileSync(psScriptPath, psScript, 'utf8');
      execSync(`powershell -NoProfile -ExecutionPolicy Bypass -File "${psScriptPath}"`, {
        stdio: 'ignore',
      });
    } finally {
      try {
        unlinkSync(psScriptPath);
      } catch {
        // Ignore cleanup errors
      }
    }
  }

  if (delay > 0) {
    await new Promise((resolve) => setTimeout(resolve, delay));
  }
}

/**
 * Drag and drop
 * @param {number} startX - Start X coordinate
 * @param {number} startY - Start Y coordinate
 * @param {number} endX - End X coordinate
 * @param {number} endY - End Y coordinate
 * @param {Object} options - Drag options
 * @returns {Promise<void>}
 */
export async function dragAndDrop(startX, startY, endX, endY, options = {}) {
  const { duration = 500, button = 'left' } = options;

  // Move to start position
  await moveMouse(startX, startY);
  await new Promise((resolve) => setTimeout(resolve, 100));

  // Press mouse button
  const robot = await getRobotJS();
  if (robot) {
    robot.mouseToggle('down', button);
  } else {
    // PowerShell fallback - simulate mouse down
    const { execSync } = await import('child_process');
    execSync(
      `powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(${startX}, ${startY})"`,
      { stdio: 'ignore' },
    );
  }

  // Drag to end position
  await moveMouse(endX, endY, { smooth: true, duration });

  // Release mouse button
  if (robot) {
    robot.mouseToggle('up', button);
  }

  await new Promise((resolve) => setTimeout(resolve, 100));
}

/**
 * Scroll mouse wheel
 * @param {number} delta - Scroll amount (positive = down, negative = up)
 * @param {Object} options - Scroll options
 * @returns {Promise<void>}
 */
export async function scrollMouse(delta, options = {}) {
  const { x = null, y = null } = options;

  // Move to position if specified
  if (x !== null && y !== null) {
    await moveMouse(x, y);
  }

  const robot = await getRobotJS();
  if (robot) {
    robot.scrollMouse(0, delta);
  } else {
    // PowerShell fallback using SendInput
    const { execSync } = await import('child_process');
    const scrollScript = `
      Add-Type -TypeDefinition @"
        using System;
        using System.Runtime.InteropServices;
        public class Mouse {
          [DllImport("user32.dll")]
          public static extern void mouse_event(uint dwFlags, uint dx, uint dy, int dwData, int dwExtraInfo);
          const uint MOUSEEVENTF_WHEEL = 0x0800;
          public static void Scroll(int delta) {
            mouse_event(MOUSEEVENTF_WHEEL, 0, 0, delta, 0);
          }
        }
"@
      [Mouse]::Scroll(${delta})
    `;
    execSync(`powershell -Command "${scrollScript}"`, { stdio: 'ignore' });
  }
}
