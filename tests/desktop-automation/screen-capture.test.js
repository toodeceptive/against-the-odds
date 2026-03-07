import { describe, it, expect } from 'vitest';
import {
  captureScreen,
  getScreenDimensions,
  captureAllScreens,
} from '../../src/desktop-automation/screen-capture.js';

describe('Screen Capture', () => {
  const isWindows = process.platform === 'win32';
  const itIf = (condition) => (condition ? it : it.skip);

  itIf(isWindows)(
    'should capture full screen',
    async () => {
      const screenshot = await captureScreen();
      expect(screenshot).toBeInstanceOf(Buffer);
      expect(screenshot.length).toBeGreaterThan(0);
    },
    10000
  );

  itIf(isWindows)(
    'should get screen dimensions',
    async () => {
      const dimensions = await getScreenDimensions();
      expect(dimensions.width).toBeGreaterThan(0);
      expect(dimensions.height).toBeGreaterThan(0);
    },
    10000
  );

  itIf(isWindows)(
    'should capture all screens',
    async () => {
      const screenshots = await captureAllScreens();
      expect(Array.isArray(screenshots)).toBe(true);
      if (screenshots.length > 0) {
        expect(screenshots[0]).toHaveProperty('screen');
        expect(screenshots[0]).toHaveProperty('image');
      }
    },
    15000
  );
});
