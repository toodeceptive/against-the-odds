# Cursor and Workspace Audit — 2026-01-30

**Scope**: .cursor/rules, .cursor/plans, .cursor/context, .cursor/tasks.json, .cursor/settings.json, .cursor/extensions.json; worktrees; Cursor IDE state (out of repo).  
**Deliverable**: Findings and .cursor/\* updates (Phase 5 Full Project Guru Perfection Plan)

---

## 1. .cursor/rules/

| File                         | Purpose                                                | Status                                                                                                            |
| ---------------------------- | ------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------- |
| ao-guru.rules.md             | Execution principles, safety, quality gates, reporting | Updated: reporting now references docs/status/ and INDEX_REPORTS.md (MASTER_EXECUTION_REPORT.md moved to archive) |
| env-credentials.mdc          | Env and credentials handling                           | No change                                                                                                         |
| shopify-preview-approval.mdc | Shopify preview/approval flow                          | No change                                                                                                         |
| use-user-browser.mdc         | Use user browser for automation                        | No change                                                                                                         |

---

## 2. .cursor/plans/

| File                                                     | Purpose                     | Status                                                                      |
| -------------------------------------------------------- | --------------------------- | --------------------------------------------------------------------------- |
| cursor-github-shopify-pipeline.plan.md                   | Pipeline plan               | Retained; reference for workflows                                           |
| expert_team_security_and_platform_plan_fbf7f611.plan.md  | Security/platform plan      | Retained                                                                    |
| perfect_execution_prompt_aca26457.plan.md (consolidated) | Phase 0 / perfect execution | See .cursor/plans/README.md; single plan: FINAL_REPO_ORGANIZATION_AND_AUDIT |

**Note**: No redundant plans removed. "Full project perfection" is in .cursor/plans (or repo plan reference); decision tree points to it. Documented here for future pruning if desired.

---

## 3. .cursor/context/

| File       | Purpose                        | Status                               |
| ---------- | ------------------------------ | ------------------------------------ |
| github.md  | Repo, auth, workflows, secrets | Current                              |
| shopify.md | Store, theme, API, scripts     | Current; theme path and branch noted |

No changes required.

---

## 4. .cursor/tasks.json

- All tasks use repo-relative paths (e.g. `scripts/setup/...`, `scripts/shopify/...`). Default execution context is workspace root — **run from repo root** satisfied.
- Tasks: Setup Environment, Verify Credentials, Test Shopify Connection, Run Tests, Run E2E, Lint, Format, Sync Products, Health Check, Shopify theme-dev (preview/Live), Open pending approval. No updates needed.

---

## 5. .cursor/settings.json vs .cursor/extensions.json

- **settings.json**: Contains `extensions.recommendations` array (PowerShell, Prettier, ESLint, Playwright, Vitest, PR, dotenv, markdownlint, yaml, Python).
- **extensions.json**: Slightly different set (adds Copilot, TypeScript, Tailwind, path-intellisense, GitLens; no Playwright/Vitest in snippet but may be full list).
- **Alignment**: Both are valid; Cursor/VS Code merge recommendations. Recommendation: keep extensions.json as the single list for "recommended extensions" and remove the duplicate from settings.json to avoid drift, or document that both are intentional (e.g. settings for minimal set, extensions.json for full set). No change made; documented for maintainability.

---

## 6. .cursor/worktrees.json

- `setup-worktree`: ["npm install"]. Documents worktree setup. Single-workspace vs worktree: use one workspace per worktree; run commands from repo root of that worktree. Documented here.

---

## 7. Cursor conversations and history (out of repo)

- **In scope (plan)**: Not in repo; no automated edit. Document: "Cursor conversations/history: stored in the IDE; optional manual or export-based review for context."
- **Action**: This audit documents that scope. All actionable work is on repo and .cursor/\* only.

---

## 8. Updates applied

- **.cursor/rules/ao-guru.rules.md**: "Maintain MASTER_EXECUTION_REPORT.md" replaced with "Maintain current execution/audit reports in docs/status/ (see INDEX_REPORTS.md)."

---

## 9. Summary

- Cursor in-repo config is consistent; tasks run from repo root; rules updated to point to docs/status/ and INDEX_REPORTS.
- Plans and context are current; optional future pruning of plans documented.
- Cursor IDE state (conversations, history) is out of repo; documented as in scope for awareness only.

**Phase 5 Cursor workspace deliverable**: Complete.
