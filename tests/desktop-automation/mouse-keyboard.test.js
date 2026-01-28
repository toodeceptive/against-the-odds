import { describe, it, expect } from 'vitest';
import { getMousePosition, moveMouse, clickMouse } from '../../src/desktop-automation/mouse-control.js';
import { typeText, pressKey } from '../../src/desktop-automation/keyboard-control.js';

describe('Mouse and Keyboard Control', () => {
  it('should get current mouse position', async () => {
    const pos = await getMousePosition();
    expect(pos).toHaveProperty('x');
    expect(pos).toHaveProperty('y');
    expect(typeof pos.x).toBe('number');
    expect(typeof pos.y).toBe('number');
  }, 5000);

  it('should move mouse', async () => {
    const startPos = await getMousePosition();
    await moveMouse(startPos.x + 10, startPos.y + 10);
    const newPos = await getMousePosition();
    // Allow some tolerance for mouse movement
    expect(Math.abs(newPos.x - (startPos.x + 10))).toBeLessThan(5);
    expect(Math.abs(newPos.y - (startPos.y + 10))).toBeLessThan(5);
  }, 5000);

  it('should click mouse', async () => {
    // Click at current position (safe test)
    const pos = await getMousePosition();
    await clickMouse('left', { x: pos.x, y: pos.y });
    // If no error thrown, click succeeded
    expect(true).toBe(true);
  }, 5000);

  it('should type text', async () => {
    // This test would need a safe target (like a text editor)
    // For now, just verify function exists and can be called
    await typeText('test', { delay: 0 });
    expect(true).toBe(true);
  }, 5000);

  it('should press keys', async () => {
    // Test pressing a safe key
    await pressKey('escape');
    expect(true).toBe(true);
  }, 5000);
});
