import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    testTimeout: 20000,
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      exclude: ['node_modules/', 'tests/', '*.config.js', 'scripts/', 'dist/', 'build/'],
      // Target 90%; baseline set per COVERAGE_REMEDIATION_PLAN.md until coverage meets 90%
      thresholds: {
        lines: 16,
        functions: 23,
        branches: 35,
        statements: 16,
      },
    },
    include: ['tests/**/*.test.{js,ts}'],
    exclude: ['node_modules/', 'dist/', 'build/'],
  },
});
