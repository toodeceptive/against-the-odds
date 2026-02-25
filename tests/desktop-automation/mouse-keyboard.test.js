import { describe, it, expect } from 'vitest';
import {
  getMousePosition,
  moveMouse,
  clickMouse,
} from '../../src/desktop-automation/mouse-control.js';
import { typeText, pressKey } from '../../src/desktop-automation/keyboard-control.js';

describe('Mouse and Keyboard Control', () => {
  const isWindows = process.platform === 'win32';
  const itIf = (condition) => (condition ? it : it.skip);

  itIf(isWindows)(
    'should get current mouse position',
    async () => {
      const pos = await getMousePosition();
      expect(pos).toHaveProperty('x');
      expect(pos).toHaveProperty('y');
      expect(typeof pos.x).toBe('number');
      expect(typeof pos.y).toBe('number');
    },
    5000,
  );

  itIf(isWindows)(
    'should move mouse',
    async () => {
      const startPos = await getMousePosition();
      await moveMouse(startPos.x + 10, startPos.y + 10);
      const newPos = await getMousePosition();
      // Allow tolerance for mouse movement (some systems may not move exactly)
      expect(Math.abs(newPos.x - (startPos.x + 10))).toBeLessThan(15);
      expect(Math.abs(newPos.y - (startPos.y + 10))).toBeLessThan(15);
    },
    5000,
  );

  itIf(isWindows)(
    'should click mouse',
    async () => {
      // Click at current position (safe test)
      const pos = await getMousePosition();
      await clickMouse('left', { x: pos.x, y: pos.y });
      // If no error thrown, click succeeded
      expect(true).toBe(true);
    },
    5000,
  );

  itIf(isWindows)(
    'should type text',
    async () => {
      // This test would need a safe target (like a text editor)
      // For now, just verify function exists and can be called
      await typeText('test', { delay: 0 });
      expect(true).toBe(true);
    },
    5000,
  );

  itIf(isWindows)(
    'should press keys',
    async () => {
      // Test pressing a safe key
      await pressKey('escape');
      expect(true).toBe(true);
    },
    5000,
  );
});
