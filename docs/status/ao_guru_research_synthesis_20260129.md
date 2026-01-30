# AO Guru Research Synthesis

**Date**: 2026-01-29  
**Purpose**: Cross-domain best practices mapped to concrete repo changes.

## Vitest (timeouts + determinism)

**Source**: Vitest docs (`testTimeout`)  
**Key guidance**:

- Default timeout is 5s (Node); set `testTimeout` globally.
- Use per-test options object for timeouts and skips.
  **Concrete change**:
- Add `testTimeout` in `vitest.config.js` and standardize per-test overrides.

## Playwright (networkidle + retries)

**Source**: Playwright best practices  
**Key guidance**:

- `networkidle` is unreliable; use explicit locators/expectations.
- `trace: 'on-first-retry'` is recommended for CI.
  **Concrete change**:
- Replace `waitUntil: 'networkidle'` in E2E tests with element-based waits.
- Use consistent retry/timeout defaults in Playwright configs/tests.

## GitHub Actions (least privilege + pinning)

**Source**: GitHub Actions security hardening  
**Key guidance**:

- Add explicit `permissions` blocks (least privilege).
- Pin action versions (tags/SHAs).
  **Concrete change**:
- Update workflows to include `permissions`.
- Pin `trivy-action` to a versioned tag and avoid `@master`.

## GitHub Actions caching (npm)

**Source**: GitHub Actions caching docs  
**Key guidance**:

- Cache `~/.npm`, not `node_modules`, using `actions/cache`.
- Prefer `npm ci` for deterministic installs.
  **Concrete change**:
- Add npm cache to workflows and use `npm ci` where appropriate.

## Shopify Admin API (versioning + rate limits)

**Source**: Shopify API versioning + rate limit docs  
**Key guidance**:

- Specify API version explicitly (2026-01).
- REST is legacy; GraphQL recommended for new work.
  **Concrete change**:
- Update docs referencing older versions.
- Add rate-limit handling/retries in API tests/scripts where feasible.

## Shopify CLI (install method)

**Source**: Shopify CLI installation docs  
**Key guidance**:

- Global install recommended: `npm install -g @shopify/cli@latest`.
  **Concrete change**:
- Update docs to note global CLI install as preferred.

## Cloudflare (security headers + WAF)

**Source**: Cloudflare docs  
**Key guidance**:

- Use security headers (CSP, HSTS, X-Frame-Options, etc.).
- Configure via Transform Rules, Pages `_headers`, or Workers.
  **Concrete change**:
- Add Cloudflare runbook/checklist with header guidance.
