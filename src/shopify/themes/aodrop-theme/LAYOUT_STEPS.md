# Theme layout steps (after theme pull)

After pulling the live theme into this folder, enable AO brand styling by editing the main layout file (e.g. `layout/theme.liquid`).

## 1. Add the brand stylesheet

In the `<head>`, after the base theme CSS, add:

```liquid
{{ 'ao-brand.css' | asset_url | stylesheet_tag }}
```

## 2. Add body class for brand styling

On the `<body>` tag, add the class `ao-brand-theme`:

```liquid
<body class="ao-brand-theme">
```

If the theme already has body classes, append: `class="... ao-brand-theme"`.

## 3. (Optional) Hero snippet

To show the AO logo + slogan + motto on the homepage, add a section or use the snippet in a template:

```liquid
{% render 'ao-hero-brand', logo: 'logo-against-the-odds-blue-pink.png', slogan: 'slogan-full.png', motto: 'motto-the-odds-were-never-even.png' %}
```

Upload those image files to theme assets first (see `src/shopify/themes/ao-brand-customization/ASSETS_MANIFEST.md`).
