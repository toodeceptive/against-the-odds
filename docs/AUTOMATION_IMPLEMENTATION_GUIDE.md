# Automation implementation guide — guru-recommended approach

**Purpose:** Best way to implement permanent automation using **PC control / live viewing**, **E2E**, and **API** for: theme update → preview → save, product demo, place order, and image optimization for embroidery (and similar). Use this when adding or changing automation flows.

---

## 1. When to use which method (guru decision table)

| Goal                                          | Best primary method                       | Why                                                                                                                                                                                                                           | Fallback                                                               |
| --------------------------------------------- | ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| **Live viewing of your desktop/screen**       | **PC control + screen capture**           | You see exactly what the user sees; no browser/API blind spots. Use `src/desktop-automation/screen-capture.js` (full screen, region, or window). Optional: capture on a timer for “live” feel, or on-demand for verification. | E2E browser screenshot if the target is only the browser.              |
| **Theme update → preview → save**             | **Scripted flow + optional capture**      | Chain: merge/copy theme (no push) → start theme dev (preview URL) → capture preview (Playwright or desktop) → then push when approved. Keeps preview and save as one repeatable flow.                                         | Manual: run theme-dev, check in browser, run update-theme.             |
| **Product demo (show product on storefront)** | **E2E (Playwright)**                      | Navigate to store URL + product page; take screenshot or record. No need to drive your whole desktop.                                                                                                                         | PC control: capture window/screen while you click through storefront.  |
| **Place order (test or real)**                | **E2E checkout or API**                   | E2E: full flow (cart → checkout) for demos or tests. API: `POST /admin/api/.../orders.json` for scripted orders.                                                                                                              | PC control: drive browser via keyboard/mouse if E2E/API not available. |
| **Optimize image quality for embroidery**     | **Script (sharp) with embroidery preset** | Embroidery needs high fidelity: high quality, minimal compression, optional fixed dimensions/DPI. Use a dedicated preset (e.g. `--preset=embroidery`) so web and embroidery outputs stay consistent and repeatable.           | Manual export from design tool; then run preset on exported file.      |

**Summary:** Use **PC control / live viewing** when the outcome must match what’s on your desktop (e.g. “see my screen”, verify theme preview in real browser, or drive any app). Use **E2E** when the flow is browser-based and repeatable (theme preview URL, product page, checkout). Use **API** when the action is create/update/delete and the API exists (orders, products, shop settings).

---

## 2. PC control / live viewing — how to implement

- **Screen capture (on demand):** `src/desktop-automation/screen-capture.js` — `captureScreen()`, `captureRegion()`, `captureWindow()`. Saves to `docs/screenshots/` or returns buffer. Use from a script or Node workflow when you need “what’s on screen now”.
- **Live viewing (periodic capture):** Run a small loop (e.g. every 2–5 s) that calls `captureScreen()` and writes to a file or stream. Agent or user can open the latest image to “view live”. No built-in streaming server in repo; add one if you need true live stream.
- **PC control (keyboard/mouse):** `src/desktop-automation/keyboard-control.js`, `mouse-control.js`, `window-manager.js` — activate window, type, click. Use when automation must drive the desktop (e.g. focus Chrome and type URL, click “Save” in an app).
- **Where to hook in:** Theme preview verification, “product demo” recording, or “place order” fallback can all call screen capture before/after a step. See theme-update-preview-save and product demo below.

---

## 3. Theme update → preview → save (recommended flow)

**Permanent automation:** One script that does update (no push), then preview, then optional screenshot, then save (push) when you confirm.

1. **Update (no push):** `.\scripts\shopify\theme-update-store.ps1 -SkipPush` — merges brand, copies images, does not push.
2. **Preview:** Run theme dev so you get a local preview URL (e.g. `http://127.0.0.1:9292`). Use `.\scripts\shopify\theme-update-preview-save.ps1` which can start theme-dev (or you run it in another terminal), wait for the URL, then capture the preview (Playwright or desktop capture) to `docs/screenshots/theme-preview-<timestamp>.png`.
3. **Save:** When satisfied, run `.\scripts\shopify\update-theme.ps1` to push to store (or use the same script with a confirm step that runs update-theme for you).

**Script:** `scripts/shopify/theme-update-preview-save.ps1` — runs step 1, optionally starts/starts theme-dev and captures preview screenshot, then prompts to push (step 3). See that script for exact usage.

**Live viewing:** Use desktop capture to screenshot the theme preview window or the browser showing the preview URL, so you (or the agent) see exactly what will go live.

---

## 4. Product demo

- **Recommended:** E2E (Playwright): open store URL (e.g. `https://aodrop.com`), navigate to a product page, take a full-page or viewport screenshot. Run as a test or one-off script. Optionally add `tests/e2e/storefront.spec.js` that opens store + product and saves a screenshot to `docs/screenshots/`.
- **With PC control / live viewing:** Run desktop capture before/after navigating, or record a sequence of screenshots while you click through the storefront. Use when you need “see my desktop” rather than only the browser.

---

## 5. Place order

- **Recommended:**
  - **Test/demo:** E2E checkout flow (Playwright): add to cart, go to checkout, fill test data, optional place order (or stop before submit).
  - **Scripted orders:** Shopify Admin API `POST /admin/api/2024-01/orders.json` (script under `scripts/shopify/` or `scripts/orders/` if you add one).
- **Fallback:** PC control: activate browser, use keyboard/mouse to go through checkout. Prefer E2E or API for repeatability.

---

## 6. Optimize image quality for embroidery

- **Recommended:** Use the same optimize-images pipeline with an **embroidery preset**: high quality (e.g. 95–100), no aggressive downscale (high or no max width), PNG preferred for art. Run: `.\scripts\shopify\optimize-images.ps1 -Preset embroidery` (or `-Preset Embroidery`).
- **Preset behavior:** Preset “embroidery” sets quality high and max width large (or skip resize), so output is suitable for embroidery use (clean, high-fidelity raster). For true embroidery formats (e.g. DST), use a dedicated design/embroidery tool; this preset is for “optimize for quality/embroidery-ready” raster assets.

---

## 7. File and script reference

| Item                                                                                  | Purpose                                                                                                                                              |
| ------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| `src/desktop-automation/screen-capture.js`                                            | Full screen, region, or window capture; “live viewing” via on-demand or periodic capture.                                                            |
| `src/desktop-automation/keyboard-control.js`, `mouse-control.js`, `window-manager.js` | PC control: type, click, activate window.                                                                                                            |
| `scripts/shopify/theme-update-preview-save.ps1`                                       | Theme update (no push) → preview (optional screenshot) → prompt to save (push).                                                                      |
| `scripts/shopify/optimize-images.ps1`                                                 | Web and embroidery presets; `-Preset embroidery` for high-quality/embroidery-ready.                                                                  |
| `tests/e2e/storefront.spec.js`                                                        | Product demo E2E: store homepage + optional product page screenshot to `docs/screenshots/`. Run: `npx playwright test tests/e2e/storefront.spec.js`. |
| `docs/STORE_OPERATIONS_AUTOMATION.md`                                                 | Full map of store operations (themes, content, products, orders, etc.).                                                                              |

---

## 8. Adding new flows (pp / guru)

1. **Decide** primary method from the table (PC control vs E2E vs API). Prefer E2E for browser flows, API for data, PC control for “see my screen” or drive any app.
2. **Implement** the smallest script or test; add screen capture or live-view steps only where they add value (e.g. theme preview, product demo).
3. **Document** in this guide and/or STORE_OPERATIONS_AUTOMATION.md; add Cursor task if useful.
4. **Verify** once: run the flow, check screenshot or outcome, then leave it as permanent automation.

This gives you a single, guru-backed way to implement PC control/live viewing and the main flows (theme update→preview→save, product demo, place order, image for embroidery) as permanent automation.
