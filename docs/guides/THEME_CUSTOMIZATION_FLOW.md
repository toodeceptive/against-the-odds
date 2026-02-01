# AO Theme Customization — Flow & Visualized Preview

This document describes the **automated flow** for pulling the live theme, applying AO brand customization, and opening a **visualized preview**. Run the flow once manually (or in an interactive terminal for pull), then use the script for repeat runs. **Prettier runs automatically on every commit** (pre-commit hook); run `npm run quality` anytime for format + lint + unit tests.

---

## Quick reference (easy to use)

| Goal                                           | Command                                                             |
| ---------------------------------------------- | ------------------------------------------------------------------- |
| **Preview look (no Shopify)**                  | Open `docs/guides/theme-preview-mock.html` in your browser          |
| **Pull theme (once, interactive)**             | `.\scripts\shopify\theme-pull.ps1`                                  |
| **Merge brand + preview**                      | `.\scripts\shopify\theme-pull-and-preview.ps1 -SkipPull`            |
| **Update store theme (brand + images + push)** | `.\scripts\shopify\theme-update-store.ps1`                          |
| **Quality check (format, lint, tests)**        | `npm run quality`                                                   |
| **Before commit**                              | Pre-commit runs Prettier automatically; optional: `npm run quality` |

---

## Flow diagram

```mermaid
flowchart LR
  subgraph manual["Manual (once)"]
    A[theme-pull.ps1\ninteractive terminal]
  end
  subgraph automated["Automated"]
    B[merge-brand-into-theme.ps1]
    C[theme-dev.ps1]
    D[Preview in browser]
  end
  subgraph commit["On commit"]
    E[Prettier auto\npre-commit]
    F[Commit & push]
  end
  A --> B
  B --> C
  C --> D
  D --> E
  E --> F
```

**Steps:**

| Step                 | Script / action                                                      | What it does                                                                                                                                                                   |
| -------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1. **Pull**          | `.\scripts\shopify\theme-pull.ps1` (run in **interactive** terminal) | Pulls live theme from aodrop.com into `src/shopify/themes/aodrop-theme/`. Requires `shopify auth login` once.                                                                  |
| 2. **Merge brand**   | `.\scripts\shopify\merge-brand-into-theme.ps1`                       | Copies `ao-brand.css` and `ao-hero-brand.liquid` into theme; patches `layout/theme.liquid` (stylesheet + body class) when present.                                             |
| 3. **Preview**       | `.\scripts\shopify\theme-dev.ps1`                                    | Starts local theme dev server; open the URL (e.g. http://127.0.0.1:9292) to **see the AO brand theme** (dark background, accent colors, logo/slogan when assets are uploaded). |
| 4. **Before commit** | Pre-commit hook (or `npm run quality`)                               | **Prettier runs automatically** on commit; optional full check: format, format:check, lint, test:unit. See [HOOKS.md](../HOOKS.md).                                            |
| 5. **Deploy theme**  | `.\scripts\shopify\theme-update-store.ps1`                           | Merges brand CSS/snippet, copies all PNGs from `assets/brand/` into theme assets, then pushes to Shopify. Run after pull at least once.                                        |
| 6. **Commit repo**   | Commit and push to connected branch                                  | Version control; Shopify deploys from connected branch if configured.                                                                                                          |

---

## One-command flow (after first pull)

After you have pulled the theme at least once (interactively):

```powershell
.\scripts\shopify\theme-pull-and-preview.ps1
```

- **Skip pull this run:** `.\scripts\shopify\theme-pull-and-preview.ps1 -SkipPull`
- **Only start preview (no pull, no merge):** `.\scripts\shopify\theme-pull-and-preview.ps1 -PreviewOnly`

If pull fails (e.g. non-interactive), run `theme-pull.ps1` manually in a terminal, then:

```powershell
.\scripts\shopify\merge-brand-into-theme.ps1
.\scripts\shopify\theme-dev.ps1
```

---

## Visualized preview — what you’ll see

When you open the **theme dev URL** (step 3), you get a **live preview** of the store with:

- **Dark background** (`#0d0d0d`) and cream text (`#f5f0e8`)
- **AO accent colors** (cyan, yellow, pink, violet) on buttons and links
- **Bold display typography** for headings
- **Logo/slogan/motto** where you’ve added the hero snippet and uploaded assets (see ASSETS_MANIFEST)

To **preview the look locally without Shopify**, open:

**`docs/guides/theme-preview-mock.html`** in your browser. It shows a static mock of the AO brand (dark theme, placeholder logo/slogan text, accent underlines) so you can see the style before running theme dev.

---

## Reference

- Brand spec: `docs/status/BRAND_THEME_CUSTOMIZATION_20260201.md`
- Apply instructions: `src/shopify/themes/ao-brand-customization/APPLY_INSTRUCTIONS.md`
- Asset placement: `src/shopify/themes/ao-brand-customization/ASSETS_MANIFEST.md`
- Layout steps (manual fallback): `src/shopify/themes/aodrop-theme/LAYOUT_STEPS.md`
- Pre-commit (Prettier auto, quality): `docs/HOOKS.md`
