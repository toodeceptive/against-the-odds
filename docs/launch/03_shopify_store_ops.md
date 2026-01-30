# Against The Odds — Shopify Store Ops

## Store configuration checklist

This is the minimum operational baseline for `aodrop.com` before launch.

### Admin access + security (store-level)

- [ ] Staff accounts are **named** (no shared logins), role-based, and have **2FA** enabled.
- [ ] Only required apps are installed; unused apps removed.
- [ ] Shopify custom app scopes are minimized to what scripts actually use:
  - products/themes/shop read/write as needed (see `docs/SHOPIFY_SETUP.md`).
- [ ] Store email and notification sender addresses are set and tested (order confirmation, shipping, refund).

### Settings: payments, taxes, shipping

- [ ] **Payments**: provider configured, test mode verified off/on as appropriate, and test transaction performed.
- [ ] **Taxes**: configured for target markets; collection method documented.
- [ ] **Shipping profiles/rates**:
  - [ ] domestic rates
  - [ ] international (if applicable)
  - [ ] free-shipping threshold (if used)
  - [ ] handling times and cutoffs documented (also used by support macros).

### Checkout + customer experience

- [ ] Checkout branding set (logo, colors where available).
- [ ] Required customer fields decided (email/phone).
- [ ] Abandoned checkout recovery enabled (if used).
- [ ] Cart/checkout policies links visible.

### Domains + email deliverability

- [ ] Primary domain is correct (`aodrop.com`) and SSL is active.
- [ ] Redirects from `myshopify.com` domain are in place.
- [ ] Email sending domain verification steps completed (where applicable).

### Policies (must exist and be linked)

- [ ] Shipping policy
- [ ] Returns/refunds policy
- [ ] Privacy policy
- [ ] Terms of service

### Backup baseline (before you touch LIVE)

- [ ] Theme snapshot pulled: `scripts/shopify/theme-pull.ps1`
- [ ] Store data exported: `scripts/shopify/fetch-store-data.ps1`
- [ ] Manual screenshots of key settings pages captured (stopgap): `scripts/shopify/browser/backup-store-settings.ps1`

## Theme workflow

The goal is to keep changes safe, reviewable, and reversible.

### Recommended “safe” workflow (day to day)

1. **Pull the current live theme** into the repo (creates a local snapshot):
   - `scripts/shopify/theme-pull.ps1`
2. **Run a local dev preview** (sync + preview URL):
   - `scripts/shopify/theme-dev.ps1`
3. **Push to a development theme** for QA:
   - `scripts/shopify/update-theme.ps1`
4. **Publish to LIVE only after QA**:
   - `scripts/shopify/update-theme.ps1 -Live` (requires explicit `yes`)

Notes:

- Shopify CLI is the underlying engine (`shopify theme dev/pull/push`); scripts are thin wrappers.
- Several scripts set a fixed `$repoPath` (example: `C:\Users\LegiT\against-the-odds`). In this Cursor worktree, run from the repo root or use equivalent CLI commands if the path doesn’t match.

### Theme guardrails (non-negotiable)

- Always have a **known-good theme** available to publish quickly (see rollback below).
- Avoid editing LIVE theme directly in the code editor without a preview cycle.
- Keep theme changes small and reversible; prefer PRs in Git for theme code.

## Product & collection readiness

### Product data expectations (minimum viable)

For every sellable SKU/variant:

- [ ] Title + clear description (benefits + materials + fit/care).
- [ ] Variant options (size/color), SKU strategy, and barcode (if used).
- [ ] Pricing + compare-at (if used) + tax settings.
- [ ] Inventory policy (continue selling vs stop at zero) set intentionally.
- [ ] Shipping weight and fulfillment location set.
- [ ] Media: 4–8 images per product (front/back/detail/lifestyle) with alt text.
- [ ] Size chart and fit guidance (link to `docs/launch/05_content_and_assets.md` for creative asset requirements).
- [ ] SEO fields: handle, title, meta description.

### Collections (navigation + merchandising)

- [ ] Primary collections created (e.g., “Hoodies”, “New”, “Best Sellers”).
- [ ] Rules documented (manual vs automated tagging).
- [ ] Sort order and featured products set.
- [ ] Collection images/headers in place.

### Data sync (repo → Shopify)

This repo includes product sync helpers:

- `scripts/shopify/sync-products.ps1` reads `data/products/*.json` and creates/updates products by title.
- Use `-DryRun` first to confirm what will change.

Operational caution:

- Title-based matching can be brittle if titles change. If you plan frequent updates, consider evolving the sync strategy to use a stable identifier (SKU/metafield) and document it here.

## Policies + legal pages

Minimum set (must be live and linked in footer and/or checkout):

- **Shipping policy**: carriers, costs, timeframes, handling times, international duties, lost package flow.
- **Returns/refunds**: eligibility window, condition requirements, exchange policy, refund timing, return shipping responsibility.
- **Privacy policy**: what data is collected, why, who it’s shared with, how customers can request deletion/access.
- **Terms of service**: purchase terms, dispute resolution basics, prohibited use.

Operational requirement:

- Support macros in `docs/launch/06_customer_support_ops.md` should reference the same policies (no contradictions).

## Operational readiness

### Pre-launch smoke tests (do before launch day)

- [ ] Place at least one **test order** end-to-end (test mode if possible; otherwise minimal-value order).
- [ ] Confirm:
  - [ ] order confirmation email
  - [ ] fulfillment workflow
  - [ ] refund workflow
  - [ ] discount code application
  - [ ] cart + checkout on mobile and desktop
- [ ] Confirm tracking basics are present (see `docs/launch/04_analytics_and_kpis.md`).

### Day-1 operational knobs (be ready to use)

- [ ] Ability to:
  - [ ] pause sales (password-protect storefront or unpublish products)
  - [ ] disable a discount code quickly
  - [ ] set products to Draft
  - [ ] revert/publish a prior theme
- [ ] Support channel is live and staffed (see `docs/launch/06_customer_support_ops.md`).

### Backups cadence (after launch)

- [ ] Weekly: `scripts/shopify/fetch-store-data.ps1` → commit/export snapshot location decision documented.
- [ ] Before any LIVE theme publish: `scripts/shopify/theme-pull.ps1`
- [ ] Monthly: capture screenshots of key admin settings pages (stopgap until automation is real).

## Rollback plan

The fastest rollback in Shopify is almost always **publishing a previous theme**.

### Theme rollback (preferred)

1. Shopify Admin → **Online Store → Themes**
2. Find the last known-good theme and **Publish** it.
3. Confirm:
   - homepage renders
   - product page renders
   - cart/checkout starts

### If rollback is due to a product/content change

- Set affected products to **Draft** or remove from sales channels to stop purchases.
- Restore from backups:
  - JSON exports from `data/shopify-backup/` (from `scripts/shopify/fetch-store-data.ps1`) to identify what changed.
  - Manual admin restoration for configuration settings.

### Post-rollback actions

- Capture incident notes: what happened, when, impact, mitigation, follow-ups.
- Open a GitHub issue with labels: `bug`, `shopify`, `critical` (if customer-impacting).
