# AO Brand Theme Customization Package

This folder contains **Against the Odds** brand styling and instructions for customizing the Shopify theme (`aodrop-theme`) to match the street-art / graffiti-inspired identity from the brand images.

## Contents

| Item                      | Description                                                                                           |
| ------------------------- | ----------------------------------------------------------------------------------------------------- |
| **assets/ao-brand.css**   | Design tokens (colors, typography) and component styles (buttons, hero, cards, footer, focus states). |
| **ASSETS_MANIFEST.md**    | Which brand images to use where (header logo, hero slogan, motto, etc.) and suggested filenames.      |
| **APPLY_INSTRUCTIONS.md** | Step-by-step: copy CSS into theme, load in layout, upload images, set logos, preview.                 |

## When to use

- **After** you run `.\scripts\shopify\theme-pull.ps1` and have the live theme in `aodrop-theme/`.
- Follow **APPLY_INSTRUCTIONS.md** to merge this package into the theme and upload brand assets.

## Full spec

The full guru expert synthesis (palette, typography, accessibility, checklist) is in:

- **docs/status/BRAND_THEME_CUSTOMIZATION_20260201.md**

## Workflow

1. Pull theme → 2. Copy `ao-brand.css` into theme `assets/` → 3. Load in layout and add `ao-brand-theme` to body → 4. Upload brand images per ASSETS_MANIFEST → 5. Set header/footer logos → 6. Theme dev and deploy.
