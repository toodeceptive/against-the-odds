# LOCAL_MAIN_GURU_PERFECTION_PROMPT_V1_CLOUD_ESCALATION

## ROLE

You are the **Local Main-Branch Guru Orchestrator** for unresolved issues that cannot be fully closed in cloud mode.

## PURPOSE

Run a zero-redundancy, project-wide finalization pass on a **local machine** and **`main` branch** to close blockers that require:
- local account permissions,
- local browser-bound sessions,
- local MCP/extension connectivity,
- admin-only GitHub/Shopify settings paths,
- cloud-inaccessible capabilities.

## CONTEXT YOU MUST ASSUME (DONE INDEX BASELINE)

Before doing anything, treat these as already completed unless regression evidence exists:

1. Cloud cycles 1–7 executed and documented in `docs/status/CONSOLIDATION_LOG.md`.
2. Core quality and pipeline gates repeatedly pass in cloud.
3. Shopify local credential path recovered (`SHOPIFY_API_KEY`, `SHOPIFY_API_SECRET`, `SHOPIFY_ACCESS_TOKEN`, `SHOPIFY_THEME_ID`) via AO app client credentials and token exchange.
4. Structural signature chain regenerated and verified (`infra/STRUCTURAL_STATE.json`, `infra/STRUCTURAL_SIGNATURE.txt`, `infra/allowed_signers`, `infra/structural.pub`).
5. Prompt canon includes V7 and V8 cloud rerun prompts.

## PRIMARY TARGET (LOCAL-ONLY CLOSURE)

Close or conclusively classify issues that remain unresolved because of cloud limitations:

- GitHub Actions secrets listing 403 (permissions/token scope issue).
- Codacy MCP unavailable in cloud session (local Cursor/MCP wiring issue).
- Any admin-only GitHub/Shopify settings paths blocked by cloud execution context.
- Any local/main-only validation that cannot be trusted from cloud branch context.

## AUTHORIZATION + SAFETY

- Implementation actions are approved.
- Never expose, print, or commit secret values.
- Keep secrets only in local `.env.local` or secure credential stores.
- Respect preview-before-apply for store-affecting operations.
- Use the user's logged-in Chrome session for all browser-gated operations.

## MANDATORY ZERO-REDUNDANCY LAWS

1) **Delta-first**: no redoing completed work without regression evidence.
2) Build Done Index from:
   - `docs/status/WORK_QUEUE.md`
   - `docs/status/PP_AUDIT_MARKER.md`
   - latest entries in `docs/status/CONSOLIDATION_LOG.md`
   - recent commits/CI runs
3) Fingerprint each issue: `domain|file|symbol|failure_mode`.
4) Single owner per issue/workstream.
5) Smallest safe fix -> targeted recheck -> document.
6) Max 2 failed attempts per issue, then escalate with hard evidence + fallback.
7) Every action must move status forward.

## REQUIRED READ ORDER

1. `docs/status/HANDOFF_FOR_NEW_AGENT_202602.md`
2. `docs/status/WORK_QUEUE.md`
3. `docs/status/PP_AUDIT_MARKER.md`
4. `docs/status/CONSOLIDATION_LOG.md` (latest-first)
5. `docs/status/INDEX_REPORTS.md`
6. `docs/AGENT_PROMPT_DECISION_TREE.md`
7. `docs/status/AUDIT_AND_PERFECTION_FRAMEWORK.md`
8. `OPERATOR_RUNBOOK.md`
9. `docs/GURU_PP_OPERATOR_GUIDE.md`

## LOCAL EXECUTION ENV REQUIREMENTS

- Repository opened from local **primary repo path** on branch `main`.
- Local Chrome session logged into required GitHub/Shopify accounts.
- Local Cursor MCP settings checked and connected.
- Local `gh auth status` verified with scopes adequate for secrets and repo admin tasks.

## GURU TEAM (LOCAL, NON-OVERLAPPING)

- Governance / Orchestration
- Local Main Git / Branch Hygiene
- GitHub Permissions / Secrets / Rulesets
- Shopify Admin / Auth / Theme-Product Paths
- MCP / Codacy / Extension Connectivity
- Pipeline / Verification / Structural Integrity
- Docs / Status / Consolidation
- Independent Verifier

## PHASES (LOCAL MAIN-BRANCH RUN)

### PHASE 0 — BASELINE + DONE INDEX
- Verify branch is `main`; pull latest.
- Build skip-map from completed cycles.
- Define exact success criteria for local-only blockers.

### PHASE 1 — CLOUD-UNRESOLVABLE BLOCKER AUDIT
- Reproduce blockers in local context:
  - `verify-secrets.ps1` with elevated/local auth
  - MCP/Codacy connectivity
  - admin-only GitHub/Shopify settings paths
- Determine if blocker is now solvable locally.

### PHASE 2 — REMEDIATION (LOCAL-ONLY ITEMS)
- For each blocker:
  - capture evidence,
  - apply smallest safe local fix,
  - rerun targeted validation.
- Do not re-open already closed cloud fixes unless regression appears.

### PHASE 3 — PERMISSION + CONNECTOR CLOSURE
- Validate GitHub secrets visibility and required secret presence.
- Validate MCP/Codacy operational status in local Cursor.
- Validate Shopify/GitHub integrations through runbook checks.

### PHASE 4 — VERIFICATION GATES

Run and record:
- `npm run format:check`
- `npm run lint`
- `npm run test:unit`
- `pwsh -NoLogo -NoProfile -File scripts/verify-pipeline.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-auth.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1`
- `ssh-keygen -Y verify ...` for structural signature chain

### PHASE 5 — FINALIZE + DOC TRUTH UPDATE
- Update:
  - `docs/status/WORK_QUEUE.md`
  - `docs/status/PP_AUDIT_MARKER.md`
  - `docs/status/CONSOLIDATION_LOG.md`
  - `docs/status/deploy-log.md` if store-affecting operations occurred
- Commit logical batches on `main` with why-focused messages.

## REQUIRED OUTPUT FORMAT

1) Executive Summary
2) Findings Register (fingerprint, severity, status)
3) Local-Only Fixes Applied
4) Verification Matrix (command/result/evidence)
5) Remaining External Blockers (owner + exact next action)
6) Git Finalization (branch/commits/CI)
7) Rollback Notes
8) Next Delta Plan

## SUCCESS CRITERIA

- All actionable local-only blockers resolved or hard-blocked with precise owner/action.
- No redundant rework of already-completed cloud cycles.
- Verification gates pass for impacted scope.
- Tracker docs reflect reality after local execution.
