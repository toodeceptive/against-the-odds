# Against The Odds — Release & Environments

## Branch model

This repo is intended to use a simple two-branch model with short-lived topic branches:

- **`main`**: production (“what’s live” for the website/repo and the _production_ release artifact). The deploy workflow triggers on pushes to `main`.
- **`develop`**: staging/integration. The deploy workflow triggers on pushes to `develop` for staging.
- **Topic branches**: branch from `develop` for work, then merge back via PR.
  - Recommended naming: `feature/<issue>-<short-slug>`, `fix/<issue>-<short-slug>`, `docs/<short-slug>`.
- **Release PR**: merge `develop` → `main` via PR when you want to ship.
- **Hotfixes**: if production is broken, branch from `main` (`hotfix/<short-slug>`), merge to `main`, then merge/cherry-pick back to `develop` to keep branches aligned.

Operational notes:

- **CI and quality gates** run on PRs to both `main` and `develop` (`.github/workflows/ci.yml`, `.github/workflows/quality-check.yml`).
- **Automation vs reality**: Some workflows are intentionally placeholder/scaffold (“Add deployment steps here”). Treat them as guardrails/checklists unless you’ve wired the actual deployment commands.

## Detached HEAD recovery

You are currently in a **detached HEAD** state (your `git status` shows `HEAD (no branch)` in this worktree). This is common in worktrees or when checking out a commit directly.

### Why it matters

- Commits you make _can be orphaned_ if you don’t attach them to a branch.
- CI/PR tooling generally assumes you’re on a named branch (`main`, `develop`, feature branch).

### Safe recovery (recommended)

1. **Capture your current work on a new branch** (keeps all commits reachable):

```bash
git switch -c wip/recover-detached-head
```

2. If you intended to work on `develop` or `main`, switch after capturing:

```bash
git switch develop
# or
git switch main
```

3. If you need the detached commits on `develop`, merge or cherry-pick them:

```bash
git switch develop
git merge wip/recover-detached-head
# or cherry-pick specific commits
```

### If you already “lost” commits

Use reflog to find them and branch from the SHA:

```bash
git reflog
git switch -c wip/recovered <sha-from-reflog>
```

### Worktree note

If this worktree was created for a specific branch but ended up detached, you can also add a new worktree attached to a branch and move work there (advanced). The key principle is the same: **create a branch pointing at your current commit before doing anything risky**.

## Environment map

Think of “environments” as a combination of:

- **Git branch / CI pipeline state**
- **Where the site is hosted**
- **Which Shopify theme is being previewed/published**

### Environments (practical)

- **Local (developer machine)**:
  - Node tooling for tests/linters.
  - Shopify theme preview via Shopify CLI (`shopify theme dev`) using scripts like `scripts/shopify/theme-dev.ps1`.
- **Staging (integration)**:
  - **Source**: `develop`
  - **Deploy trigger**: push to `develop` (`.github/workflows/deploy.yml`)
  - **Expectation**: used for pre-release validation (tests, content QA, theme preview links).
  - **Reality check**: the deploy workflow currently prints placeholder output; treat this as a process definition unless you’ve connected actual hosting steps.
- **Production**:
  - **Source**: `main`
  - **Deploy trigger**: push to `main` (`.github/workflows/deploy.yml`)
  - **Shopify theme**:
    - “Development theme” pushes: `scripts/shopify/update-theme.ps1` (default) or Shopify CLI push without `--theme=live`.
    - “Live theme” pushes: `scripts/shopify/update-theme.ps1 -Live` (explicit confirmation prompt).

### Shopify theme states (how to think about them)

- **LIVE (published)**: what customers see.
- **Development/preview theme**: safe space for QA; publish only after validation.
- **Theme ID pinning**:
  - When `SHOPIFY_THEME_ID` is set, pushes can target a specific theme.
  - When unset, Shopify CLI will create/choose a dev theme during push (implementation-dependent).

### Local scripts and worktrees

Several PowerShell scripts set a fixed `$repoPath` (e.g. `C:\Users\LegiT\against-the-odds`). In a Cursor worktree (like this one), that path may differ. If a script fails due to working directory, either:

- run the equivalent Shopify CLI commands from the current repo root, or
- adjust your shell’s working directory manually before running the script.

## Release checklist

Use this checklist for a **production release** (merge `develop` → `main`).

### Pre-flight (before you touch Shopify LIVE)

- [ ] Ensure you’re **on a branch** (not detached HEAD) and your changes are on a PRable branch.
- [ ] Confirm no secrets are present in the diff (never commit `.env.local`).
- [ ] Run local gates:
  - [ ] `npm run lint`
  - [ ] `npm run test:all` (or at minimum `npm test`)
- [ ] Run health/quality scripts (optional but recommended):
  - [ ] `scripts/health/comprehensive-check.ps1`
  - [ ] `scripts/quality/check-all.ps1`
- [ ] Backup Shopify state (lightweight, no-secrets):
  - [ ] Theme snapshot: `scripts/shopify/theme-pull.ps1` (pull live into `src/shopify/themes/...` and commit if appropriate)
  - [ ] Store data export: `scripts/shopify/fetch-store-data.ps1` (writes JSON to `data/shopify-backup/`)

### Release steps (Git)

- [ ] Open PR: `develop` → `main`
- [ ] Confirm CI + quality checks are green on the PR.
- [ ] Merge PR to `main` (this triggers the `Deploy` workflow).

### Release steps (Shopify theme)

- [ ] Validate theme in preview (Shopify CLI preview URL or Shopify theme preview).
- [ ] Push to a **non-live** theme first:
  - [ ] `scripts/shopify/update-theme.ps1` (no `-Live`)
- [ ] Run a production smoke test in Shopify preview:
  - [ ] Homepage loads, product pages render, cart/checkout flow starts, policy links work.
- [ ] Publish:
  - [ ] `scripts/shopify/update-theme.ps1 -Live` **only when ready**

### Post-release

- [ ] Verify monitoring basics:
  - [ ] `scripts/monitoring/performance-check.ps1` (site + Shopify API)
- [ ] Confirm analytics is receiving baseline traffic/conversion signals (see `docs/launch/04_analytics_and_kpis.md`).
- [ ] Capture “release notes” in `CHANGELOG.md` if you’re maintaining one.

## Rollback plan

Rollback should be possible at two layers: **code** and **Shopify theme/content**.

### Code rollback (Git)

- **Fastest**: revert the merge commit on `main` (creates a new commit that undoes the change).
- **Alternative**: redeploy a prior known-good commit by checking it out and running your deployment pipeline (only if you have a real deployment step wired).

Guardrail:

- Prefer **revert** over “rewrite history” (no force pushes to `main`).

### Shopify theme rollback

Target outcome: restore the previously published theme quickly.

- **Primary**: In Shopify Admin → Themes, **publish** the last known-good theme (Shopify keeps multiple theme versions).
- **If you pushed via CLI**:
  - Keep a habit of pulling theme snapshots regularly (`scripts/shopify/theme-pull.ps1`) so the repo has a reference point.
  - If you maintain a “release tag” for themes (recommended), you can repush that snapshot to a non-live theme then publish.

### Product/config rollback (non-theme)

If a product sync or settings change breaks purchase flow:

- Disable affected products/collections (set status to Draft / remove from channels).
- Revert configuration using backups:
  - Store data JSON backups (`data/shopify-backup/`) to understand what changed.
  - Manual restoration in Shopify Admin for settings (payments/shipping/taxes) if needed.

### Communication + incident note

If rollback is customer-impacting, log:

- what happened
- who executed rollback
- timestamps
- follow-up action items (root cause, prevention)
