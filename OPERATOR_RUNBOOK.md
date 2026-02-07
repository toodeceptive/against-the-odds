# AO Operator Runbook

**Agent permission:** You have permission to perform all actions in this repo; see [AGENTS.md](AGENTS.md) or `.cursor/rules`. Existing safety rules (preview-before-apply for store changes, no secrets in commits) still apply.

## For AI agents

- **Execution baseline**: Use [docs/GURU_PP_OPERATOR_GUIDE.md](docs/GURU_PP_OPERATOR_GUIDE.md) for how to execute like the guru team (Prodigy Protocol, agentic-performance, when to use which skill).
- **Daily gates**: Run `npm run quality` and, before push, `.\scripts\verify-pipeline.ps1` (or `-SkipRunbook` if no .env.local). Integration: `.\scripts\run-runbook.ps1` when credentials are set.
- **Perfection loop**: To loop until work is fixed, perfected, complete, and optimized (project-wide cleanup/updates/optimizations; fix failed runs; track progression/commit/review/push), use [prompts/MASTER_GURU_E2E_SYSTEM_PERFECTION_PROMPT.md](prompts/MASTER_GURU_E2E_SYSTEM_PERFECTION_PROMPT.md) and [.cursor/plans/MASTER_GURU_E2E_PERFECTION_RUN.plan.md](.cursor/plans/MASTER_GURU_E2E_PERFECTION_RUN.plan.md). Run as needed; see [.cursor/plans/README.md](.cursor/plans/README.md) for all three plans.
- **100-step multiphase PP cycles**: For deep research, fixes, optimizations, auditing, and finalizations across all trees/worktrees/branches/Git/GitHub/repos (fix any failure/error/setup by means necessary): [docs/status/GURU_100_STEP_MULTIPHASE_PP_CYCLES_20260207.md](docs/status/GURU_100_STEP_MULTIPHASE_PP_CYCLES_20260207.md).

**Repo root**: Open the **primary** repo (`C:/Users/LegiT/against-the-odds`) as the workspace root so diffs and paths show repo-relative paths (e.g. `docs/status/CONSOLIDATION_LOG.md`), not a prefix like `hal/`. If the diff or Source Control shows a path containing `hal` or `hvf`, you are in the wrong workspace—do not commit; close it and open primary first. Hal and hvf are stale workspace names, not in `git worktree list`; see [WORKTREE_INVENTORY.md](docs/status/WORKTREE_INVENTORY.md).

**Cursor tasks**: Run tasks (e.g. **Open pending approval**, **Shopify: Theme Dev**, **Start theme preview (new window)**) from the **repo root** so paths resolve correctly. **Seamless shortcuts** (add once via Keyboard Shortcuts JSON): **Ctrl+Alt+P** = open pending approval file; **Ctrl+Alt+T** = start theme dev (approved; browser opens preview URL automatically). See `docs/KEYBINDING_PENDING_APPROVAL.md`.

## Daily Checks

- **One command:** `npm run quality` (format, format:check, lint, test:unit)
- Or individually: `npm run lint`, `npm run format:check`, `npm run test:unit`
- **Before push:** Run `.\scripts\verify-pipeline.ps1` (or `-SkipRunbook` if no `.env.local`). See [.github/workflows/README.md](.github/workflows/README.md).
- **Prettier runs automatically on every commit** (pre-commit hook); see [docs/HOOKS.md](docs/HOOKS.md).

## Integration Checks (credential-gated)

- `npm run test:integration`
- `.\scripts\shopify\test-connection.ps1`
- `.\scripts\github\verify-auth.ps1`
- Or run both Shopify and GitHub checks: `.\scripts\run-runbook.ps1`

## Health & Quality

- `.\scripts\health\comprehensive-check.ps1`
- `.\scripts\quality\check-all.ps1`

## Sync & Reporting

- `.\scripts\sync\sync-all.ps1`
- `.\scripts\reporting\generate-status.ps1`

## Update Shopify from Cursor (recommended flow)

**Edit in Cursor → push to GitHub → store updates.** Store is connected to this repo via the Shopify GitHub App; pushing to the connected branch (usually `main`) triggers theme deployment. No `shopify theme push` needed for that flow.

- **One-time**: Pull live theme into repo: `.\scripts\shopify\theme-pull.ps1` (then commit and push).
- **Preview before commit**: Press **Ctrl+Alt+T** (approved shortcut; add keybinding once — see `docs/KEYBINDING_PENDING_APPROVAL.md`) or **Tasks → Run Task → Shopify: Theme Dev (preview before commit)**. The browser opens the preview URL automatically when the server is ready; you can also click the URL in the terminal or paste into **View → Simple Browser**. No commit needed to preview.
- **Daily**: Edit theme under `src/shopify/themes/aodrop-theme`, preview as above, then commit, push to `main`.
- **Deploy log / rollback**: After each deploy or product sync, append to [docs/status/deploy-log.md](docs/status/deploy-log.md). Rollback: theme → Shopify Admin → theme card → Actions → Reset to last commit; products → revert JSON and re-run sync.

**Agent context**: Store URL `aodrop.com`; theme source `src/shopify/themes/aodrop-theme/`; product data `data/products/*.json`; workflow and product/theme docs: [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md), [docs/UPDATE_SHOPIFY_FROM_CURSOR.md](docs/UPDATE_SHOPIFY_FROM_CURSOR.md). Theme ID in `.env.local` (SHOPIFY_THEME_ID); get via `shopify theme list` or Admin. **Store ops**: Product-with-uploads (JSON path + browser path), theme updates, deploy-log for every change — see [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md). **Integrations**: Products via Admin API (`sync-products.ps1`; rate limits ~2 req/s); one-off/settings via user's browser (no headless). See [.cursor/context/shopify.md](.cursor/context/shopify.md).

See **[docs/UPDATE_SHOPIFY_FROM_CURSOR.md](docs/UPDATE_SHOPIFY_FROM_CURSOR.md)** and **[docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md)** for full steps, test connection, and product sync.

## Shopify Theme Development

- **Shopify–GitHub App**: Store is connected to this repo. Theme deploys happen when you push to the connected branch (typically `main`). Configuration: Shopify Admin → Settings → Apps and sales channels → GitHub.
- **GitHub Actions**: Theme deployment is handled by the Shopify GitHub App; `shopify-sync.yml` is for product sync (Admin API secrets if configured).
- `shopify auth login` — needed for theme pull and local dev
- `shopify theme dev --store=aodrop.com --theme=live` — local preview

## Dependency Maintenance

- `.\scripts\maintenance\update-dependencies.ps1`
- `.\scripts\maintenance\security-scan.ps1`

**Desktop automation (optional)**: `robotjs` and `node-window-manager` are optionalDependencies; they may require native build (node-gyp) on install. If `npm install` fails for these, you can skip optional deps or install build tools (e.g. Visual Studio Build Tools on Windows). See `src/desktop-automation/` and `tests/desktop-automation/`.

## Credentials

- Store in `.env.local` (never commit)
- If missing, copy from `.env.example` and fill values
- **Full system setup**: Run `.\scripts\setup\full-setup.ps1` for a single entry point (ensures .env.local, guides Shopify/GitHub credentials, runs verify-credentials). See [docs/CREDENTIALS_SETUP.md](docs/CREDENTIALS_SETUP.md) and [docs/BROWSER_CREDENTIAL_FLOW.md](docs/BROWSER_CREDENTIAL_FLOW.md).
- **replacements.txt** at repo root: regex for git-filter-repo (Shopify secret replacement in history); do not remove if using history sanitization.

## Troubleshooting

For **worktree/hal path and commit policy** (do not commit when diff shows hal or hvf; open primary first): [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) — "Cursor: Failed to apply worktree or missing file in worktree path."

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

## Legacy/optional scripts (archived)

- **Root scripts** (one-off repo setup/sync) moved to `scripts/archive/root-scripts-legacy/`: create-and-push.ps1, create-repo.ps1, sync-repository.ps1. Use `scripts/shopify/`, `scripts/git/`, etc. for current flows. See `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md` and `docs/status/INDEX_REPORTS.md`.

## replacements.txt (repo root)

- **Purpose**: Regex for git-filter-repo (Shopify secret replacement when sanitizing history). Do not remove if you use history sanitization; see `docs/status/CONSOLIDATION_LOG.md` or archive for context.

## Shopify app settings (if using embedded app)

- `APP_URL` — your app’s root URL
- `PREFERENCES_URL` — preferences/settings URL
- `REDIRECT_URLS` — allowed OAuth redirect URLs (comma-separated in scripts if needed)

See `docs/SHOPIFY_SETUP.md` for details.
