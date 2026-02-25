# Guru Expert — Extensions & Config Audit (2026-02-07)

**Purpose**: User-approved manual configure/optimize of all extensions using guru expert PP cycles and desktop automation; guru team to identify all issues locally, in repo, in extensions, on GitHub account/repo; using browser or any approved methods.

**Reference**: [CURSOR_AND_AGENT_OPTIMIZATION.md](CURSOR_AND_AGENT_OPTIMIZATION.md), [FULL_SCALE_PP_AUDIT_20260207.md](FULL_SCALE_PP_AUDIT_20260207.md), [GURU_20_TEAMS_60_SPECIALTIES.md](GURU_20_TEAMS_60_SPECIALTIES.md).

---

## Guru team assignment (extensions & config)

| Team / lens              | Scope                   | Check / action                                                                  |
| ------------------------ | ----------------------- | ------------------------------------------------------------------------------- |
| **Extensions**           | .cursor/extensions.json | Recommendations aligned; no duplicates; unwanted empty; Codacy/Prettier/ESLint. |
| **Project settings**     | .cursor/settings.json   | formatOnSave, defaultFormatter, codeActionsOnSave, worktree, ESLint flat.       |
| **VS Code parity**       | .vscode/settings.json   | Same editor/git/files keys as .cursor (Cursor-only keys only in .cursor).       |
| **Local verification**   | Local machine           | npm run quality; verify-pipeline; desktop automation tests.                     |
| **Repo**                 | Repo state              | No secrets; .env.local gitignored; scripts parse; workflows valid.              |
| **GitHub / remote**      | GitHub account & repo   | verify-auth, verify-secrets (credential-gated); branch list; PR status.         |
| **Browser / automation** | Desktop automation      | vitest run tests/desktop-automation (mouse, keyboard, screen, issue detection). |

---

## Audit result (2026-02-07)

- **Extensions**: 18 recommendations; single source .cursor/extensions.json and .vscode/extensions.json match. No unwanted. Prettier, ESLint, markdownlint, EditorConfig, PowerShell, Playwright, Vitest, GitLens, GitHub PR, dotenv, YAML, TypeScript, Tailwind, path-intellisense, Shopify theme-check, Codacy, Python. ✅
- **.cursor/settings.json**: formatOnSave, formatOnPaste, defaultFormatter Prettier; ESLint fix on save; language-specific formatters (PowerShell, JS/TS/JSON/MD/HTML/CSS); worktree settings; eslint.useFlatConfig; markdownlint MD060 off. ✅
- **.vscode/settings.json**: Mirrors editor/git/files; no cursor.\* (Cursor-only keys correctly only in .cursor). ✅
- **Local**: Quality gates and pipeline verified (see Execution below). Desktop automation 13/13 pass. ✅
- **Repo**: .env.local in .gitignore; verify-pipeline 74/74 parse, 6 workflows. ✅
- **GitHub**: run-runbook reports repo access OK when run; verify-auth/verify-secrets credential-gated (documented in HANDOFF). ✅
- **Optimizations applied**: None required; config already optimal per CURSOR_AND_AGENT_OPTIMIZATION. Optional: user can enable "Iterate on Lints" and "Auto-apply to files outside context" in Cursor Settings (see CURSOR_AND_AGENT_OPTIMIZATION §6).

---

## Execution (PP cycles + desktop automation)

1. **Guru team verification**: Quality (format, format:check, lint, test:unit) — pass; verify-pipeline -SkipRunbook — 74/74 scripts, 6 workflows, lint OK; desktop automation — 13/13 tests pass (screen-capture, window-management, mouse-keyboard, issue-detection).
2. **Findings**: No extension or settings changes required; .cursor and .vscode extensions.json match; config aligned with CURSOR_AND_AGENT_OPTIMIZATION.
3. **Desktop automation**: Used as approved method to verify local automation stack (Team 8).

---

_Completed 2026-02-07; CONSOLIDATION_LOG entry added._
