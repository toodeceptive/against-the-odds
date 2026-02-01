import { describe, it, expect } from 'vitest';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

function loadEnv() {
  try {
    const envPath = join(__dirname, '../../.env.local');
    const envContent = readFileSync(envPath, 'utf-8');
    const envVars = {};

    envContent.split('\n').forEach((line) => {
      const match = line.match(/^([A-Z_]+)=(.+)$/);
      if (match && !line.startsWith('#')) {
        envVars[match[1]] = match[2].trim();
      }
    });

    return envVars;
  } catch (_error) {
    return {};
  }
}

describe('Shopify API Integration', () => {
  const envVars = loadEnv();
  const storeDomain = envVars.SHOPIFY_STORE_DOMAIN || process.env.SHOPIFY_STORE_DOMAIN;
  const accessToken = envVars.SHOPIFY_ACCESS_TOKEN || process.env.SHOPIFY_ACCESS_TOKEN;
  const hasCredentials = Boolean(storeDomain && accessToken);
  const itIf = (condition) => (condition ? it : it.skip);

  itIf(Boolean(storeDomain))('should have store domain configured', () => {
    expect(storeDomain).toBeDefined();
    expect(storeDomain).not.toBe('');
    expect(storeDomain).toMatch(/\.(com|myshopify\.com)$/);
  });

  itIf(Boolean(accessToken))('should have access token configured', () => {
    expect(accessToken).toBeDefined();
    expect(accessToken).not.toBe('');
    expect(accessToken).toMatch(/^shpat_/);
  });

  itIf(hasCredentials)('should connect to Shopify API', async () => {
    const response = await fetch(`https://${storeDomain}/admin/api/2026-01/shop.json`, {
      headers: {
        'X-Shopify-Access-Token': accessToken,
        'Content-Type': 'application/json',
      },
    });

    expect(response.ok).toBe(true);
    const data = await response.json();
    expect(data.shop).toBeDefined();
    expect(data.shop.domain).toBe(storeDomain);
  });

  itIf(hasCredentials)('should fetch products from Shopify', async () => {
    const response = await fetch(`https://${storeDomain}/admin/api/2026-01/products.json?limit=1`, {
      headers: {
        'X-Shopify-Access-Token': accessToken,
        'Content-Type': 'application/json',
      },
    });

    expect(response.ok).toBe(true);
    const data = await response.json();
    expect(data.products).toBeDefined();
    expect(Array.isArray(data.products)).toBe(true);
  });

  itIf(hasCredentials)('should fetch themes from Shopify', async () => {
    const response = await fetch(`https://${storeDomain}/admin/api/2026-01/themes.json`, {
      headers: {
        'X-Shopify-Access-Token': accessToken,
        'Content-Type': 'application/json',
      },
    });

    expect(response.ok).toBe(true);
    const data = await response.json();
    expect(data.themes).toBeDefined();
    expect(Array.isArray(data.themes)).toBe(true);
  });
});
