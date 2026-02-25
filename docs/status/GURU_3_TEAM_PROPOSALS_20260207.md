# Guru 3-team proposals (2026-02-07)

**Purpose**: Collated proposed changes from Phase 1 (discovery and analysis) for cross-comparative review. Format: ID, Team, Area, Current, Proposed, Rationale, Risk. Decision (Accept/Reject/Defer) filled in Phase 3.

**Reference**: Plan `3-team_guru_pp_from_scratch_74befe0e.plan.md` — 3 teams (Cursor, GitHub, Shopify), 5 phases, comparative review before apply.

---

## Team Cursor — proposals

| ID   | Team   | Area                     | Current                                                                                                                                                                                                                                             | Proposed                                                                                                                                                                                                                                                                                                                  | Rationale                                                      | Risk | Decision |
| ---- | ------ | ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- | ---- | -------- |
| C-01 | Cursor | Root                     | `.prettierrc` and `.prettierrc.json` both exist; `.prettierrc` has `trailingComma: "all"`, `.prettierrc.json` has `trailingComma: "es5"` and `endOfLine: "auto"`. Package.json format scripts use Prettier (loads `.prettierrc.json` when present). | Standardize on `.prettierrc.json` as single source; add one sentence to `docs/status/ROOT_FILES_INVENTORY.md` or `FULL_SYSTEM_DEBUG_OPTIMIZATION_AUDIT` that `.prettierrc` is legacy and can be removed after confirming Prettier uses only `.prettierrc.json`. Do not delete `.prettierrc` in this run without approval. | Single source of truth for format config; avoids confusion.    | Low  |          |
| C-02 | Cursor | `.cursor/worktrees.json` | `inventoryDoc` points to `docs/status/WORKTREE_INVENTORY.md`. WORKTREE_INVENTORY states "worktrees.json may not list mhx; this doc is the single source of truth."                                                                                  | Add a short comment or note in `WORKTREE_INVENTORY.md` (or in worktrees.json if valid JSON allows) that `.cursor/worktrees.json` is for Cursor IDE worktree UX only; actual worktree list is from `git worktree list` and WORKTREE_INVENTORY.md.                                                                          | Clarifies ownership; no second source of truth.                | None |          |
| C-03 | Cursor | `package.json`           | `test:desktop` runs PowerShell script; docs reference "13/13 desktop tests" via vitest. No npm script for `vitest run tests/desktop-automation`.                                                                                                    | Add script: `"test:desktop:vitest": "vitest run tests/desktop-automation"` so one command runs the 13 desktop automation tests without PowerShell wrapper.                                                                                                                                                                | Parity with docs; single command for desktop automation tests. | None |          |

---

## Team GitHub — proposals

| ID    | Team   | Area                                          | Current                                                                                                                               | Proposed                                                                                                                                                                                                                          | Rationale                                                      | Risk | Decision |
| ----- | ------ | --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- | ---- | -------- |
| GH-01 | GitHub | `docs/status/HANDOFF_FOR_NEW_AGENT_202602.md` | Line 16 says "Only **mhx** remains" for worktrees; WORKTREE_INVENTORY lists 8 worktrees (primary, mhx, bjm, cpd, ghd, jxj, igt, osd). | Replace worktree sentence with: "See [WORKTREE_INVENTORY.md](WORKTREE_INVENTORY.md) for current list (primary + mhx, bjm, cpd, ghd, igt, osd; jxj when present). ewa, snq, uub removed 2026-02-07; opo, qqa no longer worktrees." | Single source of truth; avoids stale worktree list in HANDOFF. | None |          |
| GH-02 | GitHub | `.github/workflows/README.md`                 | Workflows document secrets and triggers; permissions are not summarized.                                                              | Add one sentence under "Workflow Files" or new "Permissions" section: "All workflows use least-privilege permissions (e.g. `contents: read` only where needed)."                                                                  | Documents security posture; no code change.                    | None |          |
| GH-03 | GitHub | `scripts/` (74 scripts)                       | verify-pipeline.ps1 parses all scripts and validates 6 workflows.                                                                     | No change. Confirm in verification phase that `.\scripts\verify-pipeline.ps1 -SkipRunbook` passes.                                                                                                                                | Already aligned; no proposal.                                  | —    | —        |

---

## Team Shopify — proposals

| ID    | Team    | Area                  | Current                                                                                                                                      | Proposed                                                                                                                                                                                                                                                                  | Rationale                                                    | Risk | Decision |
| ----- | ------- | --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ | ---- | -------- |
| SH-01 | Shopify | `scripts/shopify/`    | No README; theme path `src/shopify/themes/aodrop-theme` is repeated in many scripts (theme-pull.ps1, theme-dev.ps1, update-theme.ps1, etc.). | Create `scripts/shopify/README.md` with: (1) Theme path convention: `src/shopify/themes/aodrop-theme` (default in all scripts). (2) List main scripts: theme-pull, theme-dev, sync-products, test-connection, finish-setup. (3) Point to OPERATOR_RUNBOOK for daily flow. | Single place for theme path and script index; reduces drift. | None |          |
| SH-02 | Shopify | `OPERATOR_RUNBOOK.md` | Theme flow and deploy-log already documented.                                                                                                | No change.                                                                                                                                                                                                                                                                | Already complete.                                            | —    | —        |

---

## Summary (pre–Phase 3)

| Team      | Proposal count      | Risk none | Risk low |
| --------- | ------------------- | --------- | -------- |
| Cursor    | 3                   | 2         | 1        |
| GitHub    | 2 (GH-03 no change) | 2         | 0        |
| Shopify   | 1                   | 1         | 0        |
| **Total** | **6**               | **5**     | **1**    |

---

## Phase 3 — Cross-comparative review and finalized decisions

(To be filled by lead agent.)

### Conflict and overlap check

- No two proposals modify the same file in incompatible ways.
- C-01 (Prettier) and GH-02 (workflow README) and SH-01 (new README) touch different files.
- GH-01 (HANDOFF) and C-02 (WORKTREE_INVENTORY) both reinforce single source of truth for worktrees; consistent.

### Order and risk

- No store-affecting or credential-touching proposals. All risk None or Low.
- Application order: GH-01, C-02, C-01 (doc only), C-03, GH-02, SH-01.

### Finalized decisions

| ID    | Decision | Note                                      |
| ----- | -------- | ----------------------------------------- |
| C-01  | Accept   | Document only; do not delete .prettierrc. |
| C-02  | Accept   | Add note to WORKTREE_INVENTORY.md.        |
| C-03  | Accept   | Add test:desktop:vitest script.           |
| GH-01 | Accept   | Update HANDOFF worktree sentence.         |
| GH-02 | Accept   | One sentence in workflows README.         |
| GH-03 | —        | No change; verify in Phase 4.             |
| SH-01 | Accept   | Create scripts/shopify/README.md.         |
| SH-02 | —        | No change.                                |

---

_After Phase 3, apply only Accepted proposals in Phase 4; then Phase 5 (CONSOLIDATION_LOG, INDEX_REPORTS, commit from primary)._
