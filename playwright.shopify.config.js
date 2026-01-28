import { defineConfig, devices } from '@playwright/test';

/**
 * Playwright configuration for Shopify Admin browser automation
 * Connects to existing Chrome instance when available
 */
export default defineConfig({
  testDir: './tests/shopify-admin',
  fullyParallel: false, // Sequential for admin operations
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: 1, // Single worker for admin operations
  reporter: 'html',
  timeout: 60000, // Longer timeout for admin operations
  
  use: {
    // Try to connect to existing Chrome instance first
    // If not available, launch new browser
    baseURL: process.env.SHOPIFY_STORE_URL || 'https://aodrop.com',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    
    // Chrome-specific settings for admin access
    launchOptions: {
      channel: 'chrome',
      args: [
        '--disable-blink-features=AutomationControlled',
        '--disable-dev-shm-usage',
      ],
    },
    
    // Storage state for maintaining login
    storageState: process.env.SHOPIFY_STORAGE_STATE || undefined,
  },
  
  projects: [
    {
      name: 'shopify-admin',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: { width: 1920, height: 1080 },
      },
    },
  ],
  
  // Web server not needed for Shopify admin (external site)
  webServer: undefined,
  
  // Global setup/teardown
  globalSetup: undefined,
  globalTeardown: undefined,
});
