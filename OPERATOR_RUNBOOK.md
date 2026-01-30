# AO Operator Runbook

## Daily Checks

- `npm run lint`
- `npm run format:check`
- `npm run test:unit`

## Integration Checks (credential-gated)

- `npm run test:integration`
- `.\scripts\shopify\test-connection.ps1`
- `.\scripts\github\verify-auth.ps1`

## Health & Quality

- `.\scripts\health\comprehensive-check.ps1`
- `.\scripts\quality\check-all.ps1`

## Sync & Reporting

- `.\scripts\sync\sync-all.ps1`
- `.\scripts\reporting\generate-status.ps1`

## Shopify Theme Development

- **Shopify–GitHub App**: Store is connected to this repo via the Shopify GitHub App.
  - **Theme deploys**: Handled automatically by Shopify when you push to the connected branch (typically `main`).
  - **Configuration**: Managed in Shopify Admin → Settings → Apps and sales channels → GitHub (or your app's connection settings).
  - **GitHub Actions**: The `deploy.yml` workflow no longer handles theme deployment (Shopify GitHub App is the source of truth).
  - **API workflows**: `shopify-sync.yml` still uses GitHub Actions secrets for product sync/backup (Admin API automation).
- `shopify auth login`
- `shopify theme dev --store=aodrop.com --theme=live`

## Dependency Maintenance

- `.\scripts\maintenance\update-dependencies.ps1`
- `.\scripts\maintenance\security-scan.ps1`

## Credentials

- Store in `.env.local` (never commit)
- If missing, copy from `.env.example` and fill values

## Troubleshooting

### Git connectivity issues (proxy misconfiguration)

**Symptom**: `git ls-remote` or `git push/pull` fails with "Failed to connect to 127.0.0.1 port 9"

**Cause**: User-level environment variables (`HTTP_PROXY`, `HTTPS_PROXY`, `ALL_PROXY`) set to `http://127.0.0.1:9` (discard proxy).

**Fix**:

1. Clear git proxy config: `git config --global http.proxy ""` and `git config --global https.proxy ""`
2. Clear User-level env vars (PowerShell as admin):
   ```powershell
   [Environment]::SetEnvironmentVariable('HTTP_PROXY', '', 'User')
   [Environment]::SetEnvironmentVariable('HTTPS_PROXY', '', 'User')
   [Environment]::SetEnvironmentVariable('ALL_PROXY', '', 'User')
   ```
3. Restart terminal/PowerShell session for env vars to take effect.
4. Verify: `git ls-remote --heads origin` should work.

**Note**: If proxy is intentional (corporate/VPN), configure it correctly instead of removing.

### Remaining setup (when you have values)

| Variable               | Where to get it                                                 |
| ---------------------- | --------------------------------------------------------------- |
| `GITHUB_TOKEN`         | GitHub → Settings → Developer settings → Personal access tokens |
| `SHOPIFY_ACCESS_TOKEN` | Shopify Admin → Apps → Development → Your app → API credentials |
| `SHOPIFY_THEME_ID`     | `shopify theme list` or Theme library URL                       |
| `CLOUDFLARE_API_TOKEN` | Cloudflare Dashboard → My Profile → API Tokens                  |
| `CLOUDFLARE_ZONE_ID`   | Cloudflare → Your domain → Overview (right column)              |

After filling `.env.local`:

- `npm run test:integration`
- `.\scripts\shopify\test-connection.ps1`
- `.\scripts\github\verify-auth.ps1`
- `npm run test:e2e` (optional)
- `npm run test:coverage` (optional)

## Shopify app settings (if using embedded app)

- `APP_URL` — your app’s root URL
- `PREFERENCES_URL` — preferences/settings URL
- `REDIRECT_URLS` — allowed OAuth redirect URLs (comma-separated in scripts if needed)
  See `docs/SHOPIFY_SETUP.md` for details.
