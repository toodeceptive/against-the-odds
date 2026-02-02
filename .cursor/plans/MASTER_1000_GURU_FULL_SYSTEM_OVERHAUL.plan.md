# Master 1,000 Guru Expert Full-System Overhaul Plan

**Purpose**: Aggregate ALL issues from cross-comparative guru expert analyses, audits, and reviews; provide one executable step-by-step to-do/process for file-by-file, folder-by-folder, function/element/component-level overhaul. Aligned with [FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md](FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md), [FULL_SYSTEM_AUDIT_AND_FIX_ADDENDUM.md](FULL_SYSTEM_AUDIT_AND_FIX_ADDENDUM.md), and [GURU_1000_QA_AUDIT_AND_INSIGHTS.md](GURU_1000_QA_AUDIT_AND_INSIGHTS.md).

---

## Complete repository file inventory (corrected)

**Total on disk** (excluding .git and node_modules): **~476 files.**  
**Tracked** (excluding gitignored generated dirs): **~431 files.**

| Area | File count | Notes |
|------|------------|--------|
| **Root** | 22 | index.html, styles.css, package.json, eslint.config.mjs, vitest, playwright configs, README, OPERATOR_RUNBOOK, AGENTS, LICENSE, etc. |
| **.cursor/** | 16 | context (3), plans (4), rules (5), tasks.json, settings.json, worktrees.json, extensions.json |
| **.github/** | 13 | ISSUE_TEMPLATE (3), PULL_REQUEST_TEMPLATE, settings.optimization, workflows (8) |
| **archive/** | 47 | 2026-01-30: expert-analyses-legacy (11), status-legacy (8), + reports; ARCHIVE_LOG |
| **assets/** | 19 | brand (8), drop01 (11: artwork, exports, mockups, spec-pack) |
| **config/** | 4 | git-hooks/pre-commit, github-auth.md, shopify/.shopify-cli.yml, README |
| **data/** | 6 | products, manufacturers, samples (.gitkeep + JSON + README) |
| **docs/** | **141** | Root-level MD (40+), business-plan, decisions, expert-analyses, guides (6), knowledge-base (8), launch (10), security (3), **status (77)**, screenshots/README |
| **docs/status/** | **77** | All status/report MD + performance-report.json |
| **prompts/** | 37 | experts 01–10, finalization-*, head-guru, MASTER_10, PERFECT_EXECUTION, ULTIMATE_*, setup/debug/test/optimization, agent-context, agent-capabilities |
| **scripts/** | 71 | 70 PS1 + README (root 7, archive 3, shopify 25, shopify/browser 9, git 4, github 4, health 5, etc.) |
| **src/** | 45 | browser-automation (2), desktop-automation (27 + apps 5), shopify/themes (16: ao-brand-customization 5, aodrop-theme 11) |
| **tests/** | 10 | unit (1), integration (2), e2e (2), shopify-admin (1), desktop-automation (4) |

### Gitignored / generated (not in tracked count)

| Item | Count | Note |
|------|--------|------|
| **coverage/** | 41 | Vitest coverage output; .gitignore |
| **playwright-report/** | 1 | Playwright HTML report; .gitignore |
| **test-results/** | 1 | Playwright results; .gitignore |
| **.vscode/** | 2 | If present; .gitignore |
| **node_modules/** | — | Excluded from count and from Cursor file tree |

Earlier plan text used "docs (122 files)" and "docs/status (67 files)" — **corrected to docs 141, docs/status 77.** Any plan or addendum referencing those numbers should use 141 and 77.

---

## Part 1: Master issue list (all sources)

(Unchanged from prior master plan: addendum 13–30, U1–U14, new N1–N10; see FULL_SYSTEM_AUDIT_AND_FIX_ADDENDUM and GURU_1000_QA for full tables.)

---

## Part 2: Step-by-step to-do (file-by-file, folder-by-folder)

(Phase 0 verify → .cursor → .github → config → scripts [path sweep] → scripts/shopify [API + bootstrap] → docs → prompts → root/package → src → data/assets → tests → synthesis. Same structure as before; execute per FINAL plan + addendum.)

---

## Part 3: Success criteria

- File counts in all plans/addenda: **docs 141, docs/status 77, total ~476 on disk, ~431 tracked.**
- coverage/, playwright-report/, test-results/, .vscode/ documented as gitignored/generated.
- Every script repo path fixed; theme-pull-rest API aligned; head-guru updated; package lint; config TODO; .gitignore performance-report.json if needed; CONSOLIDATION_LOG and INDEX_REPORTS updated.
