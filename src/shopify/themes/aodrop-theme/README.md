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

## Safety notes

- Avoid pushing to **live** theme unless explicitly intended.
- Keep secrets in `.env.local` only (never commit).

