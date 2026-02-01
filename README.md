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

5. Push changes (dev theme by default):

```powershell
.\scripts\shopify\update-theme.ps1
```

## Brand customization (pre-applied)

This folder includes AO brand assets:

- **assets/ao-brand.css** — Design tokens and component styles (dark theme, accents, typography).
- **snippets/ao-hero-brand.liquid** — Hero section with logo/slogan/motto (optional).

After you **theme-pull**, add the stylesheet and body class as in **LAYOUT_STEPS.md**. If a pull overwrites these files, run `.\scripts\shopify\merge-brand-into-theme.ps1` to re-apply (or re-copy from `ao-brand-customization/`).

**Flow & preview:** See `docs/guides/THEME_CUSTOMIZATION_FLOW.md`. For a **visualized preview** without Shopify, open `docs/guides/theme-preview-mock.html` in your browser. Automated flow: `.\scripts\shopify\theme-pull-and-preview.ps1` (run theme-pull interactively once first).

## Safety notes

- Avoid pushing to **live** theme unless explicitly intended.
- Keep secrets in `.env.local` only (never commit).
