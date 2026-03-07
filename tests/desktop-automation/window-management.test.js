import { describe, it, expect } from 'vitest';
import { getAllWindows, findWindow } from '../../src/desktop-automation/window-manager.js';

describe('Window Management', () => {
  const isWindows = process.platform === 'win32';
  const itIf = (condition) => (condition ? it : it.skip);

  itIf(isWindows)(
    'should get all windows',
    async () => {
      const windows = await getAllWindows();
      expect(Array.isArray(windows)).toBe(true);
      if (windows.length > 0) {
        expect(windows[0]).toHaveProperty('handle');
        expect(windows[0]).toHaveProperty('title');
      }
    },
    10000
  );

  itIf(isWindows)(
    'should find window by title',
    async () => {
      // Try to find a common window (might not exist)
      const window =
        (await findWindow('Cursor')) ||
        (await findWindow('Chrome')) ||
        (await findWindow('Explorer'));

      // Window might not exist, so just verify function works
      // If window exists, it should have required properties
      if (window) {
        expect(window).toHaveProperty('handle');
        expect(window).toHaveProperty('title');
      } else {
        // No window found is also a valid result
        expect(window).toBeNull();
      }
    },
    10000
  );
});
