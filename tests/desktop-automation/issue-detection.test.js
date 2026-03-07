import { describe, expect, it } from 'vitest';
import {
  classifyIssue,
  detectIssues,
  monitorIssues,
} from '../../src/desktop-automation/issue-detector.js';

describe('Issue Detection', () => {
  const isWindows = process.platform === 'win32';
  const itIf = (condition) => (condition ? it : it.skip);

  itIf(isWindows)(
    'should detect issues on screen',
    async () => {
      const issues = await detectIssues();
      expect(Array.isArray(issues)).toBe(true);
    },
    30000
  );

  it('should classify issues', () => {
    const issue = {
      type: 'error_message',
      severity: 'high',
      message: 'Test error',
    };

    const classified = classifyIssue(issue);
    expect(classified).toHaveProperty('classification');
    expect(classified.classification).toHaveProperty('category');
    expect(classified.classification).toHaveProperty('priority');
  });

  itIf(isWindows)('should monitor issues', async () => {
    const stopMonitoring = await monitorIssues({
      interval: 2000,
      onIssue: () => {},
    });
    await new Promise((resolve) => setTimeout(resolve, 500));
    stopMonitoring();
    expect(typeof stopMonitoring).toBe('function');
  });
});
