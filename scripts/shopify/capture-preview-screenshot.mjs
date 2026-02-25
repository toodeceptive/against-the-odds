/**
 * Capture a screenshot of the theme preview (e.g. http://127.0.0.1:9292).
 * Run from repo root: node scripts/shopify/capture-preview-screenshot.mjs [url] [outputPath]
 */
/* eslint-disable no-console */

import { mkdir } from 'fs/promises';
import { dirname, join } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const repoRoot = process.env.ATO_REPO_ROOT || join(__dirname, '..', '..');

const previewUrl = process.argv[2] || 'http://127.0.0.1:9292';
const outDir = join(repoRoot, 'docs', 'screenshots');
const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
const outputPath = process.argv[3] || join(outDir, `theme-preview-${timestamp}.png`);

async function main() {
  const pw = await import('@playwright/test');
  const { chromium } = pw;
  const browser = await chromium.launch({ headless: true });
  try {
    const page = await browser.newPage();
    await page.goto(previewUrl, { waitUntil: 'domcontentloaded', timeout: 15000 });
    await page.waitForTimeout(2000);
    await mkdir(dirname(outputPath), { recursive: true });
    await page.screenshot({ path: outputPath, fullPage: true });
    console.log('CAPTURED:' + outputPath);
  } finally {
    await browser.close();
  }
}

main().catch((e) => {
  console.error(e.message);
  process.exit(1);
});
