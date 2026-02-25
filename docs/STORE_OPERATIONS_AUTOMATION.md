# Store operations automation — permanent use from Cursor

**Purpose:** Single map for automating **initial setup**, **future store changes**, **themes**, **content**, **products**, **sizes**, **posts**, **store info**, **Printify**, **image optimization**, and **orders** from the Cursor desktop app using e2e (Playwright), desktop automation (screen/PC control), and scripts. Use for both first-time setup and ongoing operations.

---

## Automation matrix

| Use case                                              | Primary method        | Scripts / entry points                                                                                                                          | Fallback                                                                     |
| ----------------------------------------------------- | --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| **Initial setup (Shopify API access)**                | E2E + CDP             | `setup-app-access.ps1`, `get-access-token.ps1`, `launch-chrome-for-agent.ps1`, `save-token-to-env.ps1`                                          | Manual copy token → save-token-to-env; desktop: focus Chrome, type admin URL |
| **Themes (update, edit files, push)**                 | API + CLI             | `theme-pull.ps1`, `theme-dev.ps1`, `theme-update-store.ps1`, `merge-brand-into-theme.ps1`, `copy-brand-images-to-theme.ps1`, `update-theme.ps1` | E2E: Admin → Online Store → Themes; desktop: navigate theme editor           |
| **Content (theme copy, pages, homepage)**             | Edit files + push     | Edit files in `src/shopify/themes/aodrop-theme/` (snippets, sections, templates); then `theme-update-store.ps1` or theme dev                    | E2E: Theme editor in Admin; API: Content in theme JSON if applicable         |
| **Products (titles, descriptions, images)**           | API + data            | `scripts/shopify/sync-products.ps1` (canonical); edit `data/products/*.json`, run `-DryRun`, then apply only after approval                      | E2E: Admin → Products; API: REST Admin API products                          |
| **Sizes / variants (options, SKU, price, inventory)** | API + data            | Same as products: `data/products/*.json` has `variants[]` and `options[]`; run `scripts/shopify/sync-products.ps1` with preview/approval flow   | E2E: Admin → Product → Variants; API: product variants endpoints             |
| **Posts (blog articles)**                             | API + E2E             | Shopify Admin API `articles` (blog); no script in repo yet — add under `scripts/shopify/` or use E2E to Admin → Online Store → Blog → Post      | E2E: Admin → Content → Blog; desktop: type and submit                        |
| **Store info (name, domain, contact, policies)**      | API + E2E             | `fetch-store-data.ps1` (backup); `browser/backup-store-settings.ps1`; update via API `shop.json` or Admin Settings                              | E2E: Admin → Settings → General/Domains/etc.; API: GET/PUT shop              |
| **Printify (connect store, sync products, fulfill)**  | API + manual link     | (Future) Printify API; today: connect in Printify dashboard, then use Shopify product sync                                                      | E2E: open Printify dashboard in Chrome                                       |
| **Optimizing images**                                 | Script (Node + sharp) | `scripts/shopify/optimize-images.ps1` → `assets/brand` and/or theme assets                                                                      | Run before theme push or product sync                                        |
| **Creating orders**                                   | API + E2E             | Shopify Admin API orders; product sync for catalog; (Future) order script                                                                       | E2E: checkout flow; desktop: Admin → Orders → Create                         |

---

## 1. Initial setup (Shopify app access)

- **One command:** `.\scripts\shopify\setup-app-access.ps1` or with `-LaunchChrome`.
- **Cursor tasks:** _Shopify: Setup app access (e2e + runbook)_, _Shopify: Setup app access (launch Chrome first)_.
- **Details:** [docs/SHOPIFY_APP_SETUP_AUTOMATION.md](SHOPIFY_APP_SETUP_AUTOMATION.md), [docs/status/CREDENTIAL_SETUP_STEPS.md](status/CREDENTIAL_SETUP_STEPS.md).

---

## 2. Updating themes, content, products, sizes, posts, store info

### Themes

- **Pull from store:** `.\scripts\shopify\theme-pull.ps1` or `theme-auth-then-pull.ps1`. Theme path: `src/shopify/themes/aodrop-theme/`.
- **Edit locally:** Change Liquid/sections/snippets/templates in that folder; push with `theme-update-store.ps1` or `theme-dev.ps1`.
- **Brand into theme:** `.\scripts\shopify\merge-brand-into-theme.ps1`, `.\scripts\shopify\copy-brand-images-to-theme.ps1`.

### Content (pages, homepage, theme copy)

- **Theme copy:** Edit files in `src/shopify/themes/aodrop-theme/` (sections, templates, snippets); push with `theme-update-store.ps1`.
- **Pages/blog:** Admin → Content → Pages / Blog, or API (pages, articles). No repo script yet; E2E or add script.

### Products

- **Data:** `data/products/*.json` (title, body_html, variants, options, images).
- **Canonical sync path:** `.\scripts\shopify\sync-products.ps1 -DryRun` → write `docs/status/pending-approval.md` → run `.\scripts\open-preview-popup.ps1` → get chat approval → run `.\scripts\shopify\sync-products.ps1`.
- **Compatibility wrapper:** `.\scripts\products\sync.ps1` remains available for bidirectional import/export orchestration.

### Sizes / variants

- **Data:** In each product JSON: `variants[]` (title, price, sku, option1, option2) and `options[]` (e.g. Size: Small, Medium, Large). Edit JSON and use the same canonical preview/approval sync path above.

### Posts (blog articles)

- **Current:** No script in repo. Use API `blogs/{id}/articles.json` or E2E: Admin → Content → Blog. **Future:** Optional script for articles from markdown/JSON.

### Store info (name, domain, contact, policies)

- **Backup:** `.\scripts\shopify\fetch-store-data.ps1`, `.\scripts\shopify\browser\backup-store-settings.ps1`. **Update:** API `shop.json` or E2E: Admin → Settings → General, Domains. **URLs:** `https://admin.shopify.com/store/nbxwpf-z1/settings/general`, `.../settings/domains`.

### Full setup/repair and admin UI

- **One shot:** `.\scripts\shopify\finish-setup.ps1` — pipeline verify, theme pull, merge brand, copy images, SETUP_STATUS.
- **E2E:** Chrome CDP (9222) + Playwright; `src/browser-automation/shopify-admin.js`; direct URLs by `SHOPIFY_STORE_ID` for Settings, Content, Products, etc.
- **Desktop fallback:** `src/desktop-automation/` — activate Chrome, type admin URL, OCR + mouse/keyboard for find-and-click. “find and click” if structure is stable.

---

## 3. Printify

- **Current:** No Printify API scripts in repo. Connect store in [Printify](https://printify.com) dashboard (Shopify app or store connection). Product data pushed to Shopify via `scripts/shopify/sync-products.ps1` (or Admin); Printify syncs from Shopify when configured.
- **Future:** Add scripts or workflows for Printify API (product push, order status) if needed; document webhook/order flow. E2E can open Printify dashboard and automate repetitive steps if CDP is available.
- **Orders:** Shopify orders that use Printify products are fulfilled via Printify; creating orders in Shopify (API or Admin) is the main lever until Printify API is integrated.

---

## 4. Optimizing images

- **Script:** `.\scripts\shopify\optimize-images.ps1` — runs Node script that uses **sharp** to resize/compress PNGs in `assets/brand` (and optionally theme assets). Outputs to same folder or a build folder; preserves aspect ratio, optional max width/quality.
- **When:** Before theme push, or in CI; run from Cursor task or terminal.
- **Cursor task:** _Shopify: Optimize brand images_.

---

## 5. Creating orders

- **Via API:** Shopify Admin API `POST /admin/api/2024-01/orders.json` (script not in repo yet; can be added under `scripts/shopify/` or `scripts/orders/`).
- **Via product sync:** Ensure products exist with `scripts/shopify/sync-products.ps1` using preview/approval flow; create orders in Admin or via future script.
- **E2E:** Playwright test or script: go to checkout URL, fill cart, submit (use for testing or one-off flows).
- **Desktop:** Navigate to Admin → Orders → Create order; use desktop automation to fill form if needed.

---

## Cursor tasks (quick reference)

| Task                                              | Purpose                                                 |
| ------------------------------------------------- | ------------------------------------------------------- |
| _Shopify: Setup app access (e2e + runbook)_       | Initial/future API access; runbook + pipeline           |
| _Shopify: Setup app access (launch Chrome first)_ | Same, with Chrome launch and login prompt               |
| _Sync Products_                                   | Product import/export/both                              |
| _Shopify: Theme Pull_                             | Pull theme from store                                   |
| _Shopify: Theme Auth Then Pull_                   | Auth then pull                                          |
| _Shopify: Theme Dev_                              | Theme dev server / preview                              |
| _Finish Setup_                                    | Pipeline + theme pull + merge brand + copy images       |
| _Shopify: Optimize brand images_                  | Optimize assets/brand (and optionally theme) with sharp |
| _Verify Pipeline_                                 | Scripts, workflows, lint, runbook                       |
| _Run Runbook_                                     | Shopify + GitHub checks                                 |

---

## Env and config (.env.local)

- `SHOPIFY_STORE_DOMAIN` — e.g. aodrop.com
- `SHOPIFY_ACCESS_TOKEN` — Admin API token (shpat\_...)
- `SHOPIFY_STORE_ID` — optional; e.g. nbxwpf-z1 for direct admin URLs
- `GITHUB_TOKEN` — optional; for runbook/CI

---

## Adding new automations (pp / guru)

1. **Document** the goal and success criteria in this file or a linked doc.
2. **Choose** primary method: API script, E2E (Playwright + CDP), or desktop (OCR + mouse/keyboard).
3. **Implement** smallest script or flow; verify (lint, run, manual check).
4. **Add** Cursor task and/or link from [.cursor/context/node-and-automation.md](.cursor/context/node-and-automation.md).
5. **Audit:** Aligned with intent? Reusable? Documented?

This keeps initial setup and future store changes, Printify, image optimization, and order creation in one place for permanent use from Cursor.
