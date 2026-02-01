# How to Apply AO Brand Customization to Your Theme

Follow these steps **after** pulling your live theme into `src/shopify/themes/aodrop-theme/` with `.\scripts\shopify\theme-pull.ps1`.

## 1. Copy brand CSS (and optional snippet) into the theme

- Copy **assets/ao-brand.css** into your theme’s **assets** folder:
  - From: `src/shopify/themes/ao-brand-customization/assets/ao-brand.css`
  - To: `src/shopify/themes/aodrop-theme/assets/ao-brand.css`
- Optional: Copy **snippets/ao-hero-brand.liquid** into your theme’s **snippets** folder. Use it in a section or template with:
  - `{% render 'ao-hero-brand', logo: 'logo-against-the-odds-blue-pink.png', slogan: 'slogan-full.png', motto: 'motto-the-odds-were-never-even.png' %}`
  - (Use the asset filenames you uploaded.)

## 2. Load the stylesheet in the theme layout

In your theme’s main layout file (e.g. `layout/theme.liquid`), add the stylesheet in the `<head>` (after base theme CSS):

```liquid
{{ 'ao-brand.css' | asset_url | stylesheet_tag }}
```

## 3. Enable brand styling on the body (optional but recommended)

Add the class `ao-brand-theme` to the `<body>` tag in the same layout so the CSS variables and component styles apply:

```liquid
<body class="ao-brand-theme">
```

If your theme uses a different body class structure, you can add `theme-ao-brand` as an alternative class; both are targeted in `ao-brand.css`.

## 4. Upload brand images to the theme

- Upload the 7 brand images (see **ASSETS_MANIFEST.md**) to the theme’s **assets** folder, or to **Shopify Admin → Content → Files** and reference by URL.
- Use the suggested filenames in ASSETS_MANIFEST so sections can reference them consistently.

## 5. Set header and footer logos

- In **Shopify Admin → Online Store → Themes → Customize**, set the **header logo** to the full logo asset (e.g. `logo-against-the-odds-blue-pink.png`).
- In the footer section, add the motto or “We All Profit” image if you have a custom footer block.

## 6. (Optional) Set theme colors and fonts in the editor

If your theme (e.g. Dawn) uses **Theme settings** for colors and typography:

- Set **Background** to `#0d0d0d` (or the darkest brand color).
- Set **Text** to `#f5f0e8`.
- Set **Accent / Buttons** to `#00d4ff` (cyan) or `#facc15` (yellow).
- Set **Headings** font to Bebas Neue or Oswald if available; body to Inter or DM Sans.

Alternatively, rely on `ao-brand.css` variables and the `ao-brand-theme` class without changing theme settings.

## 7. Preview and deploy

- Run theme dev: `.\scripts\shopify\theme-dev.ps1` (or **Tasks → Shopify: Theme Dev**).
- Open the preview URL and check: header/footer, hero, buttons, links, and contrast.
- Commit and push to your connected branch so Shopify deploys the updated theme.

## Reference

- Full spec: `docs/status/BRAND_THEME_CUSTOMIZATION_20260201.md`
- Asset placement: `ASSETS_MANIFEST.md` (this folder)
