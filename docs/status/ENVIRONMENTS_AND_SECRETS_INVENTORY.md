# Environments and Secrets Inventory

**Purpose**: Verify single source of secrets and document environment setup for Cursor and CI.

**Last updated**: 2026-01-31 (executing final plan)

---

## Local development environment

- **.env.example** (template only)
- **.env.shopify.example** (template only) — excluded from GitHub secret-scan via CI
- **.env.local** (single local secret store; **gitignored** per [.gitignore](.gitignore) lines 26–28) — **never commit**
- **.cursor/settings.json**: Formats on save, excludes .env.local, dist, build, node_modules, etc.

**Verification**: Confirm .env.local exists at repo root; secrets in docs/CREDENTIALS_SETUP.md.

## CI environment (GitHub Actions)

**Secrets** (repository: Settings > Secrets and variables > Actions):

| Secret | Value (example) | Used in |
| ------ | --------------- | ------- |
| SHOPIFY_STORE_DOMAIN | aodrop.com | shopify-sync.yml, deploy.yml |
| SHOPIFY_ACCESS_TOKEN | Your Shopify Admin API token | shopify-sync.yml |

**Note**: No staging/production environments or GitHub Actions `environment:` used. Repo uses **main only** (no develop branch); deploy is main-only until develop is introduced.

**Verification**: No secrets appear in logs; CI yml uses env variables (not CLI args).

## Remote repository

- **origin**: https://github.com/toodeceptive/against-the-odds.git (fetch and push)
- **Org/owner**: toodeceptive

**Verification**: URL is intentional (no typo); 2FA enabled where applicable.

---

## Sign-off

Environments and secrets inventory complete. All local, CI, and remote configs are documented. No secrets are committed; no GitHub Environments are in use; remote URL is verified.

## Next steps

Ensure .env.local is populated and credentials are rotated if needed.