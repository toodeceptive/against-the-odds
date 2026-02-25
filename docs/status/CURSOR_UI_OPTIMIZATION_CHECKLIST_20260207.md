# Cursor UI optimization checklist (2026-02-07)

**Purpose**: User-approved actionable checklist for Cursor Settings (UI) and related enhancements. Use with guru PP cycles across project, Cursor, and GitHub. Source: [CURSOR_AND_AGENT_OPTIMIZATION.md](CURSOR_AND_AGENT_OPTIMIZATION.md) §6 and related.

---

## 1. Cursor Settings UI — enable for best agent behavior

Set in **Cursor → Settings** (not in repo). Tick when applied.

| #   | Area                      | Setting                                 | Recommendation                                              | Done |
| --- | ------------------------- | --------------------------------------- | ----------------------------------------------------------- | ---- |
| 1   | **Chat & Composer**       | **Iterate on Lints (Beta)**             | On — agent fixes linter errors during runs                  | ☐    |
| 2   | **Chat & Composer**       | **Auto-apply to files outside context** | On — agent can edit files not currently open                | ☐    |
| 3   | **Chat & Composer**       | **Agent mode stickiness**               | On — Agent mode persists across new conversations           | ☐    |
| 4   | **Chat & Composer**       | **Large context**                       | On for large codebases (if capacity allows)                 | ☐    |
| 5   | **Models**                | Default / Max Mode                      | Choose default for Agent; consider Max for complex tasks    | ☐    |
| 6   | **Features → Editor**     | **Index new files by default**          | On                                                          | ☐    |
| 7   | **Features → Editor**     | **Git graph relationships**             | On to improve context (if acceptable)                       | ☐    |
| 8   | **Features → Editor**     | **Hierarchical Cursor Ignore**          | On if using nested .cursorignore                            | ☐    |
| 9   | **Ignore files (global)** | Patterns                                | Add `**/.env`, `**/.env.*`, `**/*.key`, `**/*.pem`          | ☐    |
| 10  | **Rules (user)**          | Optional                                | e.g. "Reply concisely" or "Prefer Windows paths in scripts" | ☐    |
| 11  | **Notifications**         | Enable                                  | For parallel agents / worktrees so runs complete visibly    | ☐    |

---

## 2. GitHub verification (credential-gated)

Run from **primary repo** when credentials are set:

| Script                              | Result (2026-02-07)                                    | Action                                                                                                                                                                                        |
| ----------------------------------- | ------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `scripts/github/verify-auth.ps1`    | Repo access **OK** (19 branches); GITHUB_TOKEN not set | Set GITHUB_TOKEN in `.env.local` or env to test API; optional for push/pull if SSH/HTTPS already works.                                                                                       |
| `scripts/github/verify-secrets.ps1` | **gh** CLI not installed; required secrets listed      | Install `gh` (e.g. `winget install GitHub.cli`) to list/verify Actions secrets; or check manually: [repo secrets](https://github.com/toodeceptive/against-the-odds/settings/secrets/actions). |

**Required GitHub Actions secrets** (for workflows): SHOPIFY_STORE_DOMAIN, SHOPIFY_ACCESS_TOKEN, SHOPIFY_THEME_ID. Optional: SHOPIFY_API_KEY, SHOPIFY_API_SECRET, GITHUB_TOKEN, CLOUDFLARE_API_TOKEN.

---

## 3. Multi-faceted PP cycles (project, Cursor, GitHub)

Guru expert team runs aligned PP cycles across:

- **Project**: quality (format, lint, test:unit), verify-pipeline, desktop automation tests.
- **Cursor**: extensions and settings (see GURU_EXTENSIONS_CONFIG_AUDIT_20260207); this checklist (§1).
- **GitHub**: verify-auth, verify-secrets (or browser) per §2; branch/workflow state per HANDOFF.

Apply **aligned / efficient / improvable** audit; document in CONSOLIDATION_LOG.

---

_Linked from CONSOLIDATION_LOG and INDEX_REPORTS._
