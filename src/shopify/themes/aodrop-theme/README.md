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

4. **Apply AO brand customization** (after first pull):
   - Copy `docs/design-system/theme-customization/ao-brand-variables.css` into this theme as `assets/ao-brand-variables.css`.
   - In `layout/theme.liquid`, load it after your base CSS: `{{ 'ao-brand-variables.css' | asset_url | stylesheet_tag }}`.
   - In your theme CSS, use the tokens (e.g. `var(--ao-bg)`, `var(--ao-cyan)`, `var(--ao-font-display)`). See `docs/design-system/theme-customization/README.md` and `docs/design-system/ao-brand-design-system.md` for full steps and optional settings_schema merge.

5. Run local preview + live reload:

```powershell
.\scripts\shopify\theme-dev.ps1
```

6. Push changes (dev theme by default):

```powershell
.\scripts\shopify\update-theme.ps1
```

## AO brand style (from logo set)

Colors and typography are defined in the design system so the theme matches the Against the Odds logo set: dark background, cyan/yellow/pink/purple accents, bold display font, and slogan/motto treatment. Reference: `docs/design-system/ao-brand-design-system.md` and `docs/design-system/theme-customization/`.

## Safety notes

- Avoid pushing to **live** theme unless explicitly intended.
- Keep secrets in `.env.local` only (never commit).
