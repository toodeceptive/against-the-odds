# Full-system debug, update, optimization and cleaning audit (2026-02-07)

**Purpose**: Lead-agent PP run: comprehensive audit of all work, tasks, repos, local, branches, worktrees, files; identify obsolete, useless, out-of-date files and unused system aspects. Informs cleanup and optimization without redundant re-audits.

**Reference**: [MASTER_FULL_SCALE_GURU_PP_PROMPT.md](../../prompts/MASTER_FULL_SCALE_GURU_PP_PROMPT.md), [EXECUTIVE_DECISION_WORK_PRINCIPLES.md](EXECUTIVE_DECISION_WORK_PRINCIPLES.md), [WORKTREE_INVENTORY.md](WORKTREE_INVENTORY.md), [CONSOLIDATION_LOG.md](CONSOLIDATION_LOG.md).

---

## 1. Audit scope (what was reviewed)

- **Branches**: main + local (chore/script-paths-utilities-gitignore, cursor/main-project-setup-2bd1, feature/ao-brand-shopify-automation, guru-pp-run-20260207, handoff-doc-permissions-20260129, mlf-main) and remotes (origin/\*, dependabot, shopify-theme).
- **Worktrees**: Primary + mhx, bjm, cpd, ghd, igt, osd (jxj when present). ewa, snq, uub removed 2026-02-07; hal, hvf stale in Cursor only.
- **Structure**: Root (AGENTS.md, OPERATOR_RUNBOOK, package.json, scripts/, .github/workflows/, .cursor/, docs/, prompts/, src/, tests/, archive/), 74 PowerShell scripts, 6 workflows, 4 plans under .cursor/plans/.
- **Docs**: docs/status/ (52+ files), INDEX_REPORTS, CONSOLIDATION_LOG, HANDOFF, BRANCH_INVENTORY, WORKTREE_INVENTORY.
- **Tests**: unit (vitest), integration (credential-gated), desktop automation (13/13), E2E (Playwright, credential-gated).

---

## 2. Obsolete / out-of-date / redundant (findings)

### 2.1 Documentation contradictions (fixed in this run)

- **HANDOFF_FOR_NEW_AGENT_202602.md** stated "Only mhx remains" for worktrees; actual list is primary + mhx, bjm, cpd, ghd, igt, osd (and jxj when present). **Fix**: Point to WORKTREE_INVENTORY as single source of truth.
- **EXECUTIVE_DECISION_WORK_PRINCIPLES.md** listed "ewa/mhx/snq/uub"; ewa, snq, uub were removed. **Fix**: Reference WORKTREE_INVENTORY for current worktrees.
- **IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY.md** listed ewa, mhx, snq, uub, opo, qqa. **Fix**: Reference WORKTREE_INVENTORY.
- **VERSION_UPDATE_TABLE.md** (WORKTREE_INVENTORY row) said "ewa, mhx, snq". **Fix**: Update to reference WORKTREE_INVENTORY for current list.

### 2.2 Config duplication (documented; no delete without approval)

- **.prettierrc** (JSON) and **.prettierrc.json** both exist; package.json `format`/`format:check` use Prettier (loads .prettierrc.json when present). Slight differences (trailingComma, endOfLine). **Recommendation**: Use .prettierrc.json as single source; .prettierrc can be removed in a later cleanup if Prettier is confirmed to use only .prettierrc.json.

### 2.3 Legacy / archive (kept by design)

- **archive/2026-01-30/** (46 .md files): Historical reports; kept per plan and CONSOLIDATION_LOG. No deletion.
- **scripts/archive/root-scripts-legacy/**: create-repo.ps1, create-and-push.ps1, sync-repository.ps1; portable paths applied; kept for reference.

### 2.4 Optional / low-use scripts (documented; not removed)

- **run-everything-debug.ps1**, **open-pending-approval.ps1**: Debug/UX helpers; useful for operator flows. Keep unless explicitly deprecated.
- **scripts/pm/**, **scripts/manufacturing/**: Niche; keep for future use.

---

## 3. System aspects: do we need X if we have Y?

### 3.1 PC (desktop) automation vs rest of pipeline

- **Desktop automation** (tests/desktop-automation, vitest): Mouse/keyboard, screen capture, issue detection. Runs **without** browser or Shopify; agent-driven UI/screen tasks.
- **Conclusion**: PC automation does **not** replace APIs, secrets, or E2E. It **supplements** (e.g. drive Cursor, verify UI). We still need:
  - **APIs/Secrets**: For Shopify (theme deploy, product sync, store data) and GitHub (push/pull, Actions). Required for store operations and CI.
  - **E2E (Playwright)**: Browser-based; credential-gated; needed for storefront/admin flows when creds allow.
  - **verify-pipeline / runbook**: Script and workflow hygiene; runbook step 5 is credential-gated but rest is not.
- **Verdict**: Keep APIs, secrets, E2E, and runbook. They are not redundant with PC automation.

### 3.2 APIs and secrets

- **Needed**: Shopify Admin API (theme pull/backup, product sync, sync-theme-branch, shopify-sync workflow); GitHub (push/pull, Actions secrets for CI). Documented in ENVIRONMENTS_AND_SECRETS_INVENTORY, CREDENTIALS_SETUP, HANDOFF.
- **Optional for local-only**: GITHUB_TOKEN for API rate limits; Shopify token for runbook step 5 and integration tests. When missing, steps skip or defer per HANDOFF.
- **Verdict**: APIs/secrets are required for store and CI; optional for local-only agent work. Do not remove.

### 3.3 Workflows (6)

- **ci.yml**: Quality gate (format:check, lint, test:unit). **Keep.**
- **codeql.yml**: Security scan (continue-on-error). **Keep.**
- **shopify-sync.yml**, **sync-theme-branch.yml**: Theme/product and branch sync; need secrets. **Keep.**
- **sync.yml**, **maintenance.yml**: Sync and maintenance. **Keep.**
- No redundant workflow identified.

---

## 4. Cleanup and updates applied (this run)

1. **HANDOFF_FOR_NEW_AGENT_202602.md**: Worktrees sentence updated to point to WORKTREE_INVENTORY for current list (primary, mhx, bjm, cpd, ghd, igt, osd; jxj when present).
2. **EXECUTIVE_DECISION_WORK_PRINCIPLES.md**: Worktree bullet updated to "see WORKTREE_INVENTORY.md for current list" (no ewa/snq/uub).
3. **IF_HANDOFF_FILES_MISSING_READ_FROM_PRIMARY.md**: Worktree list replaced with reference to WORKTREE_INVENTORY.
4. **VERSION_UPDATE_TABLE.md**: WORKTREE_INVENTORY row updated to "Current worktrees per WORKTREE_INVENTORY.md".

---

## 5. Verification after changes

- `npm run quality` (format, format:check, lint, test:unit) — pass.
- `.\scripts\verify-pipeline.ps1 -SkipRunbook` — 74 scripts parse, 6 workflows, lint OK.
- Desktop automation: `npx vitest run tests/desktop-automation` — 13/13 pass (run when needed).

---

## 6. Summary

- **Obsolete/out-of-date**: Doc contradictions on worktree count/list fixed by referencing WORKTREE_INVENTORY.
- **Useless files**: None deleted; optional scripts and archive kept by design.
- **Unused system aspects**: APIs, secrets, E2E, and runbook are **not** redundant with PC automation; all retained.
- **Single source of truth for worktrees**: WORKTREE_INVENTORY.md; all handoff/executive docs now point to it.

---

_Added 2026-02-07. Referenced in CONSOLIDATION_LOG and INDEX_REPORTS._
