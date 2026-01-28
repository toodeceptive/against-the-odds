import { test, expect } from '@playwright/test';

test('homepage loads', async ({ page }) => {
  await page.goto('/');
  await expect(page).toHaveTitle(/Against the Odds/);
});

test('logo catalog section exists', async ({ page }) => {
  await page.goto('/');
  const catalogSection = page.locator('#catalog');
  await expect(catalogSection).toBeVisible();
});
