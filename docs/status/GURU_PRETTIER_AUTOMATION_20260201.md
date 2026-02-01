# Guru Review — Prettier Automation & Process Perfection

**Date:** 2026-02-01  
**Scope:** Prettier runs automatically on commit; one-command quality; flow and visualization guide updated for easy use.

## Changes

### 1. Prettier automatically next time (pre-commit)

- **scripts/git/pre-commit.ps1** — Runs `npm run format` first; re-stages any formatted files so the commit includes formatted code. Repo root resolved from script location (worktree-safe).
- **docs/HOOKS.md** — Documents Prettier auto step, full pre-commit behavior, and `npm run quality` for manual check.

### 2. One-command quality (easy to use)

- **package.json** — Added `npm run quality` (format + format:check + lint + test:unit). Added HTML to format/format:check globs.
- **OPERATOR_RUNBOOK.md** — Daily checks: one command `npm run quality`; note that Prettier runs automatically on commit.
- **scripts/README.md** — npm script table: format (runs on pre-commit), quality (guru review).

### 3. Visualization guide & process

- **docs/guides/THEME_CUSTOMIZATION_FLOW.md** — Quick reference table (preview mock, pull, merge+preview, quality, before commit); flow diagram updated with “On commit” (Prettier auto); step 4 “Before commit” with link to HOOKS.md; reference to HOOKS.md.
- Theme flow is automated and documented for easy use.

### 4. Guru review

- Ran `npm run format` (includes HTML); ran `npm run quality` — format, format:check, lint (0 errors), test:unit passed.
- Pre-existing ESLint warnings (22) unchanged; no secrets in changed files.

## Reference

- Pre-commit / Prettier auto: `docs/HOOKS.md`
- Theme flow: `docs/guides/THEME_CUSTOMIZATION_FLOW.md`
- Daily checks: `OPERATOR_RUNBOOK.md` (Daily Checks)
- npm scripts: `scripts/README.md`, `package.json`
