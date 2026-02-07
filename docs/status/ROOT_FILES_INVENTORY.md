# Root Files Inventory

**Purpose**: Explicit list of every root-level file and directory; used by Phase 0 and Track F. **Last updated: 2026-02 (added .cursorignore).**

---

## Root-level files (current)

### System / IDE

| File                | Purpose                                                                               |
| ------------------- | ------------------------------------------------------------------------------------- |
| `.editorconfig`     | Editor defaults                                                                       |
| `eslint.config.mjs` | ESLint 9 flat config                                                                  |
| `.prettierrc.json`  | Prettier config                                                                       |
| `.gitignore`        | Git ignore patterns (includes .env.local, node_modules, docs/screenshots/\*.png\|jpg) |

### Cursor workspace

| File / dir   | Purpose                                                                 |
| ------------ | ----------------------------------------------------------------------- |
| `.cursor/`   | Rules, context, plans, tasks, settings, extensions, worktrees          |
| `.cursorignore` | Cursor indexing/context exclusions (semantic search, Agent, @ mentions); see docs/status/CURSOR_AND_AGENT_OPTIMIZATION.md |

### Config and env (templates only at root)

| File                   | Purpose                                             |
| ---------------------- | --------------------------------------------------- |
| `.env.example`         | Env template (no secrets)                           |
| `.env.shopify.example` | Shopify env template (excluded from CI secret-scan) |
| `.env.local`           | **Local secrets only; gitignored; never commit**    |

### Scripts and config at root

| File                           | Purpose                                                                         |
| ------------------------------ | ------------------------------------------------------------------------------- |
| `package.json`                 | npm scripts, dependencies                                                       |
| `vitest.config.js`             | Vitest                                                                          |
| `playwright.config.js`         | Playwright default                                                              |
| `playwright.shopify.config.js` | Playwright Shopify E2E                                                          |
| `replacements.txt`             | Regex for git-filter-repo (secret replacement in history); see OPERATOR_RUNBOOK |

### Docs and project

| File                  | Purpose                                                      |
| --------------------- | ------------------------------------------------------------ |
| `README.md`           | Project overview; links to OPERATOR_RUNBOOK, docs, AGENTS.md |
| `CHANGELOG.md`        | Version history                                              |
| `NEXT_STEPS.md`       | Immediate next steps                                         |
| `OPERATOR_RUNBOOK.md` | Daily checks, Shopify, credentials                           |
| `AGENTS.md`           | Agent permission and browser use                             |
| `index.html`          | Root HTML (e.g. static site entry)                           |
| `styles.css`          | Root CSS                                                     |

### GitHub

| Dir        | Purpose                                                                    |
| ---------- | -------------------------------------------------------------------------- |
| `.github/` | Workflows, ISSUE_TEMPLATE, PULL_REQUEST_TEMPLATE, settings.optimization.md |

### Directories (root)

| Dir        | Purpose                                                                                     |
| ---------- | ------------------------------------------------------------------------------------------- |
| `archive/` | Archived batches (e.g. 2026-01-30); ARCHIVE_LOG at archive/ARCHIVE_LOG.md                   |
| `assets/`  | drop01 (artwork, exports, mockups, spec-pack); **brand/** (root .png moved here 2026-01-31) |
| `config/`  | git-hooks, shopify/.shopify-cli.yml, github-auth.md                                         |
| `data/`    | products, manufacturers, samples (source for sync)                                          |
| `docs/`    | Documentation; index docs/README.md                                                         |
| `prompts/` | Expert and finalization prompts                                                             |
| `scripts/` | PowerShell scripts; index scripts/README.md                                                 |
| `src/`     | shopify/themes, browser-automation, desktop-automation                                      |
| `tests/`   | Unit, integration, e2e, shopify-admin, desktop-automation                                   |

---

## Resolved (Track F)

- **Root .png files (issue #8)**: Seven PNGs (logo/design) were at root. **Moved to `assets/brand/`** 2026-01-31; see [assets/brand/README.md](../../assets/brand/README.md) and CONSOLIDATION_LOG Track F. Root is clear of loose image files.

---

## Resolved / current

- **LICENSE**: Root LICENSE file added (UNLICENSED; aligns with package.json). Documented in OPERATOR_RUNBOOK and ROOT_FILES_INVENTORY.

## To be addressed (if any)

- **replacements.txt**: Kept at root; documented in OPERATOR_RUNBOOK; optional relocate to config/ in future.
