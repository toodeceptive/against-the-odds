# Node, Playwright, and Desktop Automation — Agent Context

**Purpose**: Single context file so agents know when and how to use Playwright (E2E/browser) and desktop-automation for operations that cannot be performed via GitHub or Shopify API.

---

## Shopify app access (one-command setup)

To establish or refresh **Shopify Admin API access** from Cursor (e2e + runbook + pipeline):

```powershell
.\scripts\shopify\setup-app-access.ps1
```

With Chrome launch and login prompt:

```powershell
.\scripts\shopify\setup-app-access.ps1 -LaunchChrome
```

Uses store ID (e.g. `nbxwpf-z1` for aodrop.com) for direct navigation to Apps > Development. Full flow and fallbacks: **docs/SHOPIFY_APP_SETUP_AUTOMATION.md**.

**Store operations (ongoing):** Initial setup, store changes, Printify, image optimization, orders — see **docs/STORE_OPERATIONS_AUTOMATION.md**. Entry points: `setup-app-access.ps1`, `products/sync.ps1`, `shopify/optimize-images.ps1`, theme scripts, E2E + desktop fallbacks.

---

## When to use

- **Playwright (E2E / browser)**: When you need scripted browser flows, E2E tests, or automated UI flows that APIs don’t cover (e.g. full checkout, admin UI checks). Use the user’s browser (MCP) for interactive credential flows; use Playwright for automated, repeatable runs.
- **Desktop automation**: When you need PC-level operations (screens, windows, input, system checks) that cannot be done via GitHub/Shopify API or browser MCP. See `src/desktop-automation/` and `docs/AGENT_SYSTEM.md`.

---

## npm scripts (package.json)

| Script                       | Purpose                                     |
| ---------------------------- | ------------------------------------------- |
| `npm run test:e2e`           | Playwright default config — general E2E     |
| `npm run test:shopify`       | Playwright Shopify config — store/admin E2E |
| `npm run test:desktop`       | Desktop automation system test (PowerShell) |
| `npm run test:desktop:quick` | Desktop automation quick run                |
| `npm run verify:pipeline`    | Verify pipeline (scripts + workflows)       |

---

## Locations

- **Playwright**: `playwright.config.js`, `playwright.shopify.config.js`; tests in `tests/e2e/`, `tests/shopify-admin/`
- **Desktop automation**: `src/desktop-automation/` (27 modules), `scripts/desktop-automation/test-system.ps1`, `tests/desktop-automation/`
- **Agent system doc**: `docs/AGENT_SYSTEM.md`

---

## Cursor tasks

Use Cursor tasks for one-click runs: **Run Shopify E2E Tests**, **Run Desktop Automation Tests**, **Verify Pipeline**, **Shopify: Theme Pull**, **Shopify: Theme Auth Then Pull**, **Finish Setup**, **Run Runbook**.
