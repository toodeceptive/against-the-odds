# Master full-system overhaul and unified guru PP prompt

**Purpose**: Use when the user wants a full-system overhaul, comprehensive audit, and unified agent-driven execution (any request → plan → agent team → PC and/or APIs as needed → preview/approve/apply).

**How to run**: Use in a new agent chat as master approval; create roster from [GURU_20_TEAMS_60_SPECIALTIES.md](docs/status/GURU_20_TEAMS_60_SPECIALTIES.md); execute Phase 0 (audit) then 100-step cycles from primary.

**Reference**: [OPERATOR_RUNBOOK.md](OPERATOR_RUNBOOK.md), [GURU_PP_OPERATOR_GUIDE.md](docs/GURU_PP_OPERATOR_GUIDE.md), [MASTER_FULL_SCALE_GURU_PP_PROMPT.md](prompts/MASTER_FULL_SCALE_GURU_PP_PROMPT.md).

---

## 1. Approval and lead role

I approve you to run a **full-system overhaul**, update, optimization, upgrade, and cleaning using PP and a new full-scale guru PP run with you as the **lead agent**.

**Scope**: All work, tasks, repos, local state, branches, worktrees, and files (single comprehensive audit).

---

## 2. Audit scope and system-aspect decisions (conditional)

### Inventory

- All work/tasks, repos, local clones, branches, worktrees, files (scripts, workflows, docs, tests, config).

### Classify

- Obsolete, useless, out-of-date files; unused system aspects.

### System-aspect (refined — conditional)

- **Theme apply and many store tasks** do **not** require APIs/secrets when the agent runs **on the user's PC** and the user has a **browser session** (e.g. Chrome logged into Shopify Admin). The agent can navigate PC and browser to perform theme apply, product edits, settings, etc.; **the session is the credential**; no repo secrets needed.

- **APIs/secrets are required** when: **CI or headless** (no user desktop); **bulk/scripted** operations where UI is slow or fragile; or user prefers API for reliability.

- **Rule**: Prefer APIs when available and when context is CI/headless; use **PC + browser** when agent is on user's PC and no secrets (or user prefers not to store tokens). Align with [FULL_SYSTEM_DEBUG_OPTIMIZATION_AUDIT_20260207.md](docs/status/FULL_SYSTEM_DEBUG_OPTIMIZATION_AUDIT_20260207.md) §3 if present, else [FULL_SCALE_PP_AUDIT_20260207.md](docs/status/FULL_SCALE_PP_AUDIT_20260207.md) and [CONSOLIDATION_LOG.md](docs/status/CONSOLIDATION_LOG.md).

### Decision tree (when to use APIs vs PC/desktop automation)

- **User request** (e.g. update theme, sync products, deploy) →
  - **Is agent on user's PC with access to browser?**
    - **YES** → **Is user logged into Shopify Admin (or relevant app)?**
      - **YES** → Use PC/desktop automation; no repo secrets required.
      - **NO** → Ask user to log in or add token.
    - **NO** (CI/headless) → Secrets required; use API/CLI if present, else document or skip.

### Credentials × mode matrix

| Task | Secrets present | Browser only (on user PC, logged in) | Neither |
|------|-----------------|--------------------------------------|---------|
| Theme apply | Prefer CLI/API | Use PC + browser (Admin → Themes) | Ask user to log in or add token |
| Product sync | Prefer API/sync script | Use PC + browser (Admin → Products) | Ask or skip |
| CI deploy | Required (secrets) | N/A (no PC in CI) | Skip/defer |

### Other

- **Purpose of every file/automation**: Audit to document or infer purpose; remove only obsolete/useless by explicit criteria; no "second system" removal without justification.
- **Single source of truth for worktrees**: [WORKTREE_INVENTORY.md](docs/status/WORKTREE_INVENTORY.md).

---

## 3. Phase 0 (audit)

Before or alongside Phase 1: Run **Phase 0 (audit)**:

- Full inventory; classify obsolete/out-of-date/unused; document system-aspect decisions (including conditional APIs vs PC).
- **Output**: Short audit report (e.g. `docs/status/FULL_SYSTEM_OVERHAUL_AUDIT_YYYYMMDD.md`) or append to existing audit. Then proceed to 100-step cycles.

---

## 4. Unified automated system vision

- **Flow**: User prompts in Cursor → lead agent creates plan → guru team/subagents perform task → use **PC automation** and/or **APIs/browser** as needed → present preview or outcome → user agrees or requests changes → apply updates.

- **Examples**:
  - Theme update (match designs/logo/motto) → plan → edit theme files → navigate to Shopify (desktop or browser) → update → preview → approve/edits → apply.
  - Any request (product design, T-shirt, Shopify → Printful, etc.): same pattern.

- **Principle**: One unified system; user describes goal; agent chooses combination of local editing, PC automation, and APIs (no duplicate "second systems").

---

## 5. Determine context (execution step)

After creating the plan, **determine context**: Is the agent running on the user's PC with access to a browser where the user can be logged into Shopify Admin (or relevant app)?

- **Yes**: For store tasks (theme apply, product edits, etc.), **PC + browser** is allowed and does not require repo secrets; use when no token or user prefers it.
- **No** (CI/headless): Use APIs when secrets exist; otherwise document or skip.

---

## 6. Methods and execution (pre-approved)

- **PP**: Purpose-first, task tree, verify, fix-if-fail, audit loop (per `.cursor/skills/prodigy-protocol`).
- **Guru team**: Assign per [GURU_20_TEAMS_60_SPECIALTIES.md](docs/status/GURU_20_TEAMS_60_SPECIALTIES.md); lead orchestrates; team owns phases/steps.
- **Execution**: Phase 0 (audit) then 100-step multiphase PP cycles per [GURU_100_STEP_MULTIPHASE_PP_CYCLES_20260207.md](docs/status/GURU_100_STEP_MULTIPHASE_PP_CYCLES_20260207.md).
- **Tools**: Desktop automation, E2E (credential-gated), quality, verify-pipeline, runbook when creds allow; APIs/secrets retained where required (CI/headless or user preference).

---

## 7. Fix-if-fail and commit policy (reference only)

**Fix-if-fail rules and commit/push policy**: See [MASTER_FULL_SCALE_GURU_PP_PROMPT.md](prompts/MASTER_FULL_SCALE_GURU_PP_PROMPT.md) §3 and §5; same rules apply.

---

## 8. References

- [OPERATOR_RUNBOOK.md](OPERATOR_RUNBOOK.md), [GURU_PP_OPERATOR_GUIDE.md](docs/GURU_PP_OPERATOR_GUIDE.md)
- [MASTER_FULL_SCALE_GURU_PP_PROMPT.md](prompts/MASTER_FULL_SCALE_GURU_PP_PROMPT.md), [GURU_100_STEP_MULTIPHASE_PP_CYCLES_20260207.md](docs/status/GURU_100_STEP_MULTIPHASE_PP_CYCLES_20260207.md), [GURU_20_TEAMS_60_SPECIALTIES.md](docs/status/GURU_20_TEAMS_60_SPECIALTIES.md)
- [WORKTREE_INVENTORY.md](docs/status/WORKTREE_INVENTORY.md), [HANDOFF_FOR_NEW_AGENT_202602.md](docs/status/HANDOFF_FOR_NEW_AGENT_202602.md)
- **Audit** (when present): [FULL_SYSTEM_DEBUG_OPTIMIZATION_AUDIT_20260207.md](docs/status/FULL_SYSTEM_DEBUG_OPTIMIZATION_AUDIT_20260207.md) or [FULL_SCALE_PP_AUDIT_20260207.md](docs/status/FULL_SCALE_PP_AUDIT_20260207.md)
- **APIs vs PC automation Q&A**: [APIS_VS_PC_AUTOMATION_QA_20260207.md](docs/status/APIS_VS_PC_AUTOMATION_QA_20260207.md) (decision tree, credentials matrix)
- **Store flows**: [STORE_OPERATIONS_AUTOMATION.md](docs/STORE_OPERATIONS_AUTOMATION.md), [AGENT_WORKFLOW_CURSOR_SHOPIFY.md](docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md)

---

_Use with NEW_AGENT_FULL_SCALE_GURU_PP_INSTRUCTIONS.md for handoff to a new agent instance; for full-system overhaul + unified vision use this prompt._
