# AO Brand — Shopify Theme Customization

This folder contains drop-in assets to style your Shopify theme (e.g. Dawn or any Online Store 2.0 theme) with the Against the Odds (AO) brand derived from the logo set.

## Contents

| File                     | Purpose                                                                                                                                                                                                                                           |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ao-brand-variables.css` | CSS custom properties (colors, typography, button classes)                                                                                                                                                                                        |
| `settings_ao_brand.json` | **Reference only** — one settings group (AO Brand colors). Do not replace your theme’s full `config/settings_schema.json`; append this object to the existing `settings_schema.json` array if you want theme editor controls for AO colors/fonts. |

## How to apply (after pulling your theme)

1. **Pull the theme** (if you haven’t):

   ```powershell
   .\scripts\shopify\theme-pull.ps1
   ```

   Theme files will appear under `src/shopify/themes/aodrop-theme/`.

2. **Add AO variables to the theme**
   - Copy `ao-brand-variables.css` into the theme as an asset, e.g.:
     - `src/shopify/themes/aodrop-theme/assets/ao-brand-variables.css`
   - In your theme’s `layout/theme.liquid`, load it after your base CSS:
     ```liquid
     {{ 'ao-brand-variables.css' | asset_url | stylesheet_tag }}
     ```

3. **Use the variables in your theme CSS**
   - In `base.css` or section CSS, use the tokens, e.g.:
     - Background: `var(--ao-bg)` or `var(--color-background)`
     - Headings: `font-family: var(--ao-font-display);`
     - Buttons: use classes `.ao-btn-primary` / `.ao-btn-outline` or map your theme’s button styles to `--ao-yellow` / `--ao-cyan`.

4. **Optional: theme editor controls**
   - If your theme uses `config/settings_schema.json`, you can add the "AO Brand colors" group from `settings_ao_brand.json` (merge into the existing array; do not remove existing groups).
   - Then in Liquid/CSS, replace hardcoded hex values with `settings.ao_bg`, `settings.ao_cyan`, etc., and output them as CSS variables in `theme.liquid`.

5. **Fonts**
   - Design system recommends **Bebas Neue** or **Oswald** for display and **DM Sans** or **Inter** for body. Add via Shopify’s font picker (if using the schema above) or load from Google Fonts in `theme.liquid`:
     ```html
     <link rel="preconnect" href="https://fonts.googleapis.com" />
     <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
     <link
       href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;600;700&display=swap"
       rel="stylesheet"
     />
     ```

## Design system reference

See [../ao-brand-design-system.md](../ao-brand-design-system.md) for full tokens, typography, and usage notes.

## Preview before going live

- Run **Tasks → Run Task → Shopify: Theme Dev** and open the preview URL to confirm colors and fonts.
- Commit and push to your connected branch so Shopify deploys from the repo; or use `.\scripts\shopify\update-theme.ps1` to push via CLI.
