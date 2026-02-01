# AO Brand Assets — Theme Placement

Use these brand images in your Shopify theme sections. Upload each to **Theme assets** (or **Settings → Files**) and reference by filename in your sections.

| Asset (logical name)                                | Suggested filename in theme             | Placement                                             |
| --------------------------------------------------- | --------------------------------------- | ----------------------------------------------------- |
| **Against the Odds — Full Logo (Blue/Pink)**        | `logo-against-the-odds-blue-pink.png`   | Header logo, footer logo                              |
| **Against the Odds — Full Logo (Blue/Yellow)**      | `logo-against-the-odds-blue-yellow.png` | Alternate hero, collection headers                    |
| **Full Slogan** ("If y'all drop it… We all profit") | `slogan-full.png`                       | Hero banner, about section, email signup block        |
| **We All Profit** (partial slogan)                  | `slogan-we-all-profit.png`              | CTA sections, cart/checkout confidence, footer        |
| **AO — Logo acronym**                               | `logo-ao-acronym.png`                   | Favicon source, app icon, small placements            |
| **AO + The Odds Were Never Even** (logo + motto)    | `logo-ao-with-motto.png`                | Hero lockup, about, brand story section               |
| **The Odds Were Never Even** (motto only)           | `motto-the-odds-were-never-even.png`    | Section divider, footer tagline, product storytelling |

## Source files and automation

Brand images in **assets/brand/** (repo root) are copied into the theme’s **assets** folder when you run:

- `.\scripts\shopify\copy-brand-images-to-theme.ps1` — copies all PNGs with sanitized filenames (spaces → hyphens).
- Or use the full flow: `.\scripts\shopify\theme-update-store.ps1` — merge brand + copy images + push.

After copy, filenames in the theme will match the source names (sanitized). Rename in Theme Editor to the suggested filenames above if you want Liquid to reference them consistently, e.g.:

```liquid
<img src="{{ 'logo-against-the-odds-blue-pink.png' | asset_url }}" alt="Against the Odds" width="200" height="auto" loading="lazy">
```

## Transparent backgrounds

Use the PNG variants with transparent backgrounds for header/footer and overlay use so the dark theme background shows through cleanly.
