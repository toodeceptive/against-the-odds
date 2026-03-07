import { describe, expect, it } from 'vitest';
import {
  buildClientCredentialsEndpoints,
  buildShopifyAdminUrl,
  isTrustedShopifyAdminUrl,
  normalizeStoreHost,
  resolveShopifyStoreInfo,
} from '../../src/shopify/store-domain.js';

describe('Shopify store domain helpers', () => {
  it('normalizes store hosts from URLs and raw domains', () => {
    expect(normalizeStoreHost('https://AODROP.com/admin')).toBe('aodrop.com');
    expect(normalizeStoreHost('nbxwpf-z1.myshopify.com')).toBe('nbxwpf-z1.myshopify.com');
  });

  it('maps the storefront domain to the canonical admin host', () => {
    expect(resolveShopifyStoreInfo('aodrop.com')).toEqual({
      storefrontHost: 'aodrop.com',
      adminHost: 'nbxwpf-z1.myshopify.com',
      cliHost: 'nbxwpf-z1.myshopify.com',
      storeSlug: 'nbxwpf-z1',
      trustedHosts: ['admin.shopify.com', 'aodrop.com', 'nbxwpf-z1.myshopify.com'],
    });
  });

  it('derives the store slug from a direct myshopify domain', () => {
    expect(resolveShopifyStoreInfo('nbxwpf-z1.myshopify.com')).toMatchObject({
      adminHost: 'nbxwpf-z1.myshopify.com',
      cliHost: 'nbxwpf-z1.myshopify.com',
      storeSlug: 'nbxwpf-z1',
    });
  });

  it('builds modern admin.shopify.com routes when a store slug is known', () => {
    expect(buildShopifyAdminUrl('aodrop.com', '/themes')).toBe(
      'https://admin.shopify.com/store/nbxwpf-z1/themes'
    );
  });

  it('preserves the current admin.shopify.com store slug when one is already active', () => {
    expect(
      buildShopifyAdminUrl('aodrop.com', '/products', {
        currentUrl: 'https://admin.shopify.com/store/custom-store/apps/development',
      })
    ).toBe('https://admin.shopify.com/store/custom-store/products');
  });

  it('recognizes trusted admin URLs for the storefront and canonical admin hosts', () => {
    expect(
      isTrustedShopifyAdminUrl('https://admin.shopify.com/store/nbxwpf-z1/themes', 'aodrop.com')
    ).toBe(true);
    expect(
      isTrustedShopifyAdminUrl('https://nbxwpf-z1.myshopify.com/admin/themes', 'aodrop.com')
    ).toBe(true);
    expect(
      isTrustedShopifyAdminUrl('https://aodrop.com.myshopify.com/admin/themes', 'aodrop.com')
    ).toBe(false);
  });

  it('builds token endpoints without inventing invalid custom-domain myshopify hosts', () => {
    expect(buildClientCredentialsEndpoints('aodrop.com')).toContain(
      'https://nbxwpf-z1.myshopify.com/admin/oauth/access_token'
    );
    expect(buildClientCredentialsEndpoints('aodrop.com')).not.toContain(
      'https://aodrop.com.myshopify.com/admin/oauth/access_token'
    );
  });
});
