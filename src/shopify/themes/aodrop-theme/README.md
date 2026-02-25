# AO Shopify Theme Workspace

This folder is the local workspace for the Shopify theme used by the AO store (`aodrop.com`).

## Expected workflow

1. Install Shopify CLI:

```powershell
npm install -g @shopify/cli @shopify/theme
```

2. Authenticate:

```powershell
shopify auth login
```

3. Pull the current live theme into this folder:

```powershell
.\scripts\shopify\theme-pull.ps1
```

4. Run local preview + live reload:

```powershell
.\scripts\shopify\theme-dev.ps1
```

5. Update store theme (merge brand + copy images + push):

```powershell
.\scripts\shopify\theme-update-store.ps1
```

Or push only: `.\scripts\shopify\update-theme.ps1`

**If the store theme hasn’t updated:** Run step 3 (`theme-pull.ps1`) once in an interactive terminal, then run step 5 (`theme-update-store.ps1`) so the live theme gets the AO brand and images.

## Brand customization (pre-applied)

This folder includes AO brand assets:

- **assets/ao-brand.css** — Design tokens and component styles (dark theme, accents, typography).
- **snippets/ao-hero-brand.liquid** — Hero snippet with logo/slogan/motto (optional).
- **sections/ao-hero.liquid** — Hero section with editable headline, subhead, CTA, and brand image pickers.
- **sections/ao-about.liquid** — About block with title, body, tagline, optional logo.
- **sections/ao-footer.liquid** — Footer with tagline, short bio, copyright, optional logo.
- **snippets/ao-footer-brand.liquid** — Footer brand snippet (tagline/logo) for use inside other footer sections.

All section text and images are customizable in **Theme Editor**. Default copy matches `docs/launch/STORE_COPY_AND_CONTENT.md`. Brand images from **assets/brand/** are copied into this theme’s **assets** by `theme-update-store.ps1`. After you **theme-pull**, add the stylesheet and body class as in **LAYOUT_STEPS.md**. If a pull overwrites files, run `.\scripts\shopify\theme-update-store.ps1` (or `merge-brand-into-theme.ps1` + `copy-brand-images-to-theme.ps1`) to re-apply.

**Flow & preview:** See `docs/guides/THEME_CUSTOMIZATION_FLOW.md`. For a **visualized preview** without Shopify, open `docs/guides/theme-preview-mock.html` in your browser. Automated flow: `.\scripts\shopify\theme-pull-and-preview.ps1` (run theme-pull interactively once first).

## Safety notes

- Avoid pushing to **live** theme unless explicitly intended.
- Keep secrets in `.env.local` only (never commit).
