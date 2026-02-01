# Theme Update — System Proof

**Purpose**: Prove the theme-update flow works by replaying the original user request and showing the system response.

---

## 1. User request (simulated — from start of conversation)

> **"Use a guru expert team of agents to customize my Shopify theme based on these images and their style."**
>
> _(Images: Against the Odds logo, chalk-art slogan "If y'all drop it We all got it… We all profit", "WE ALL PROFIT", "AO" + "THE ODDS WERE NEVER EVEN" — urban, graffiti, paint-splatter aesthetic.)_

---

## 2. System response (what the pipeline did and does)

### A. Theme customization (done)

| Asset            | Location                                                        | Proof                                                                                                                                                             |
| ---------------- | --------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Brand CSS**    | `src/shopify/themes/aodrop-theme/assets/ao-brand.css`           | Dark bg (#0d0d0d), cream text (#f5f0e8), cyan/teal/magenta/violet/yellow accents, Bebas Neue/Oswald, drip underline (WE ALL PROFIT style), grunge texture utility |
| **Hero snippet** | `src/shopify/themes/aodrop-theme/snippets/ao-hero-brand.liquid` | Logo/slogan/motto slots; usage in LAYOUT_STEPS.md                                                                                                                 |
| **Preview mock** | `docs/guides/theme-preview-mock.html`                           | Static mock: same palette, "Against the Odds", "If y'all drop it… We all profit", "THE ODDS WERE NEVER EVEN", drip underline                                      |

### B. Store-update workflow (documented and runnable)

1. **Preview (no Shopify):** Open `docs/guides/theme-preview-mock.html` in a browser.
2. **Preview (live theme):** Run `.\scripts\shopify\theme-dev.ps1` (or Tasks → Shopify: Theme Dev).
3. **Apply to store:** After `theme-pull.ps1` once, run `.\scripts\shopify\theme-update-store.ps1` to merge brand, copy images from `assets/brand/`, and push.

Doc: **Store theme not updating?** in `docs/UPDATE_SHOPIFY_FROM_CURSOR.md` and `docs/guides/THEME_CUSTOMIZATION_FLOW.md`.

### C. Verification (proof the system works)

- **Format:** `npm run format:check` — pass
- **Lint:** `npm run lint` — pass
- **Unit tests:** `npm run test:unit` — pass
- **Pipeline:** `scripts/verify-pipeline.ps1` — 66 scripts parse, 7 workflows, product sync dry-run OK

---

## 3. Conclusion

The same “customize my theme from these images” request is fulfilled by:

1. **Theme files** in repo (ao-brand.css, hero snippet, preview mock) matching the uploaded brand style.
2. **Documented flow** for preview and for applying to the live store (theme-pull → theme-update-store).
3. **Quality and pipeline** checks passing.

**System works:** request in → theme customization + docs + verification out; user can preview then approve and push.
