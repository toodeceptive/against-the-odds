# Config — Index

**Purpose**: Index of configuration files used by the repo. Env templates and secrets are documented in [docs/CREDENTIALS_SETUP.md](../docs/CREDENTIALS_SETUP.md) and [OPERATOR_RUNBOOK.md](../OPERATOR_RUNBOOK.md).

---

## Repository config (root)

| File                           | Purpose                                                         |
| ------------------------------ | --------------------------------------------------------------- |
| `.editorconfig`                | Editor defaults (indent, line endings)                          |
| `eslint.config.mjs`            | ESLint 9 flat config; used by `npm run lint` and CI             |
| `.prettierrc.json`             | Prettier formatting; used by `npm run format` and quality-check |
| `vitest.config.js`             | Vitest (unit/integration tests)                                 |
| `playwright.config.js`         | Playwright E2E default config                                   |
| `playwright.shopify.config.js` | Playwright config for Shopify admin E2E                         |

---

## config/ directory

| Path                                | Purpose                                                                                      |
| ----------------------------------- | -------------------------------------------------------------------------------------------- |
| **config/git-hooks/pre-commit**     | Git hook entry; invokes `scripts/git/pre-commit.ps1` (see [docs/HOOKS.md](../docs/HOOKS.md)) |
| **config/shopify/.shopify-cli.yml** | Shopify CLI: store (aodrop.com), theme dev port, API version                                 |
| **config/github-auth.md**           | GitHub auth and credential setup notes                                                       |

---

## Cursor and IDE

| Path                                      | Purpose                                                    |
| ----------------------------------------- | ---------------------------------------------------------- |
| `.cursor/rules/*.mdc`                     | Agent rules (permissions, env, preview-approval, browser)  |
| `.cursor/context/github.md`, `shopify.md` | Context for agents                                         |
| `.cursor/settings.json`                   | Cursor format-on-save, excludes, extensions subset         |
| `.cursor/extensions.json`                 | Recommended extensions                                     |
| `.cursor/tasks.json`                      | IDE tasks (e.g. open pending approval, theme dev)          |
| `.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md` | Single plan file; open in Cursor and use Build |

---

## Data and schema

- **data/** structure and schemas: see [data/README.md](../data/README.md) if present, or [scripts/README.md](../scripts/README.md) (Data section) and [.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md](../.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md) Track E (Expert 9: data schema).

_Last updated: 2026-01-31_
