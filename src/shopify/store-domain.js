const KNOWN_STORES = Object.freeze({
  'aodrop.com': Object.freeze({
    myshopifyDomain: 'nbxwpf-z1.myshopify.com',
    storeSlug: 'nbxwpf-z1',
  }),
  'nbxwpf-z1.myshopify.com': Object.freeze({
    myshopifyDomain: 'nbxwpf-z1.myshopify.com',
    storeSlug: 'nbxwpf-z1',
  }),
});

function readEnvValue(value) {
  return typeof value === 'string' && value.trim() ? value.trim() : null;
}

export function normalizeStoreHost(storeDomain) {
  const trimmed = readEnvValue(storeDomain);
  if (!trimmed) return null;

  try {
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return new URL(trimmed).hostname.toLowerCase();
    }
    return new URL(`https://${trimmed}`).hostname.toLowerCase();
  } catch {
    return null;
  }
}

function deriveStoreSlugFromMyShopifyHost(hostname) {
  return hostname?.endsWith('.myshopify.com') ? hostname.replace(/\.myshopify\.com$/, '') : null;
}

function buildFallbackMyShopifyHost(storefrontHost, storeSlug) {
  if (storeSlug) {
    return `${storeSlug}.myshopify.com`;
  }
  return `${storefrontHost}.myshopify.com`;
}

function normalizeStoreSlug(storeSlug) {
  const trimmed = readEnvValue(storeSlug);
  return trimmed ? trimmed.toLowerCase() : null;
}

function normalizeAdminPath(pathname = '/') {
  const trimmed = readEnvValue(pathname) || '/';
  const withLeadingSlash = trimmed.startsWith('/') ? trimmed : `/${trimmed}`;
  const withoutAdminPrefix = withLeadingSlash.replace(/^\/admin(?=\/|$)/, '');
  return withoutAdminPrefix === '' ? '/' : withoutAdminPrefix;
}

export function resolveShopifyStoreInfo(storeDomain, options = {}) {
  const storefrontHost = normalizeStoreHost(storeDomain);
  if (!storefrontHost) {
    return {
      storefrontHost: null,
      adminHost: null,
      cliHost: null,
      storeSlug: null,
      trustedHosts: ['admin.shopify.com'],
    };
  }

  const explicitMyShopifyDomain = normalizeStoreHost(
    options.myshopifyDomain ?? process.env.SHOPIFY_MYSHOPIFY_DOMAIN
  );
  const hasExplicitMyShopifyDomain = explicitMyShopifyDomain?.endsWith('.myshopify.com');
  const explicitStoreSlug = normalizeStoreSlug(
    options.storeSlug ?? process.env.ATO_SHOPIFY_STORE_ID
  );
  const knownStore =
    KNOWN_STORES[storefrontHost] ||
    (hasExplicitMyShopifyDomain ? KNOWN_STORES[explicitMyShopifyDomain] : null);

  let adminHost = storefrontHost;
  let storeSlug = explicitStoreSlug;

  if (storefrontHost.endsWith('.myshopify.com')) {
    adminHost = storefrontHost;
    storeSlug ||= deriveStoreSlugFromMyShopifyHost(storefrontHost);
  } else if (hasExplicitMyShopifyDomain) {
    adminHost = explicitMyShopifyDomain;
    storeSlug ||= deriveStoreSlugFromMyShopifyHost(explicitMyShopifyDomain);
  } else if (knownStore?.myshopifyDomain) {
    adminHost = knownStore.myshopifyDomain;
    storeSlug ||= knownStore.storeSlug;
  } else {
    adminHost = buildFallbackMyShopifyHost(storefrontHost, storeSlug);
  }

  const trustedHosts = Array.from(new Set(['admin.shopify.com', storefrontHost, adminHost]));

  return {
    storefrontHost,
    adminHost,
    cliHost: adminHost,
    storeSlug,
    trustedHosts,
  };
}

export function buildShopifyAdminUrl(storeDomain, pathname = '/', options = {}) {
  const normalizedPath = normalizeAdminPath(pathname);
  const currentUrl = readEnvValue(options.currentUrl);

  if (currentUrl) {
    try {
      const parsed = new URL(currentUrl);
      if (parsed.hostname === 'admin.shopify.com') {
        const currentStoreMatch = parsed.pathname.match(/^\/store\/([^/]+)/);
        if (currentStoreMatch) {
          return `https://admin.shopify.com/store/${currentStoreMatch[1]}${normalizedPath}`;
        }
      }
    } catch {
      // Fall back to the resolved host below.
    }
  }

  const resolved = resolveShopifyStoreInfo(storeDomain, options);
  if (resolved.storeSlug) {
    return `https://admin.shopify.com/store/${resolved.storeSlug}${normalizedPath}`;
  }

  const legacyAdminPath = normalizedPath === '/' ? '/admin' : `/admin${normalizedPath}`;
  return `https://${resolved.adminHost}${legacyAdminPath}`;
}

export function isTrustedShopifyAdminUrl(urlValue, storeDomain, options = {}) {
  try {
    const parsed = new URL(urlValue);
    if (parsed.protocol !== 'https:') return false;

    const { trustedHosts } = resolveShopifyStoreInfo(storeDomain, options);
    const hostname = parsed.hostname.toLowerCase();
    if (!trustedHosts.includes(hostname)) return false;

    if (hostname === 'admin.shopify.com') {
      return /^\/store\/[^/]+(?:\/|$)/.test(parsed.pathname);
    }

    return parsed.pathname === '/admin' || parsed.pathname.startsWith('/admin/');
  } catch {
    return false;
  }
}

export function buildClientCredentialsEndpoints(storeDomain, options = {}) {
  const resolved = resolveShopifyStoreInfo(storeDomain, options);
  const endpoints = new Set();

  if (resolved.adminHost) {
    endpoints.add(`https://${resolved.adminHost}/admin/oauth/access_token`);
  }

  if (resolved.storeSlug) {
    endpoints.add(`https://${resolved.storeSlug}.myshopify.com/admin/oauth/access_token`);
  }

  return Array.from(endpoints);
}
