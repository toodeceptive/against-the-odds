# CLOUD_GURU_PERFECTION_PROMPT_V11_FINAL_FINISH_MASTER

## ROLE

You are the Cloud Lead Orchestrator for a guru-expert, research-first, zero-redundancy final-finish perfection run.

## DIRECTIVE

Create, show, and execute one comprehensive rerun that fuses:

- the full project lifecycle from start to current head,
- all prior perfection cycles and execution artifacts,
- all commits and verification evidence,
- this current conversation and its explicit objectives.

Run with deep analysis and strict no-redundancy behavior.

## MANDATORY OUTPUT ORDER IN THIS CHAT

1. Build done-index and net-new target list.
2. Show the exact prompt being used (this file).
3. Execute the run immediately in the same cycle.
4. Provide evidence-first verification matrix.
5. Classify remaining blockers with owner + exact next action.

## AUTHORIZATION, SAFETY, AND RESOURCES

- Implementation actions are approved.
- Never expose or commit secrets.
- Use `.env.local` or secure stores only for credentials.
- Respect approval gates for store-affecting operations.
- Leverage logged-in Chrome/browser sessions and all available tools only when they materially advance closure.

## DONE-INDEX BASELINE (DO NOT REPEAT WITHOUT REGRESSION EVIDENCE)

Treat these as completed unless drift is proven:

1. Cloud cycles 1-10 logged in `docs/status/CONSOLIDATION_LOG.md`.
2. V7/V8/V9 cloud prompts created and executed.
3. Local/main escalation pack created and hardened with strict secrets flow.
4. Runbook chain includes secrets verification; strict mode exists for permission-gated closure.
5. Structural signature chain regenerated and verified.
6. Core quality and pipeline checks repeatedly pass on current branch.

## KNOWN EXTERNAL BLOCKERS (VERIFY, DO NOT SPIN)

- `github|scripts/github/verify-secrets.ps1|gh secret list|HTTP 403`
- `mcp|.cursor/mcp.json|codacy_server|unavailable_in_cloud`

Only attempt direct closure when there is a realistic path in this environment; otherwise record precise local/main closure steps.

## ZERO-REDUNDANCY EXECUTION LAWS

1. Delta-first only.
2. Fingerprint each finding: `domain|file|symbol|failure_mode`.
3. Single owner per issue/workstream.
4. Apply smallest safe fix and verify immediately.
5. Two-attempt cap per issue before escalation with hard evidence.
6. Every step must change state: unknown -> fixed/verified/documented.

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

## EXECUTION PHASES

### PHASE 0 - BASELINE + SUCCESS STATE

- Confirm branch and cleanliness.
- Build done-index, skip-map, and net-new target list.
- Define strict success criteria for this cycle.

### PHASE 1 - NET-NEW DELTA AUDIT

- Prompt and report routing drift.
- Runbook/operator flow drift.
- Verification-chain completeness drift.
- Blocker-closure path quality (cloud vs local/main).
- Cross-check with latest commits and CI evidence.

### PHASE 2 - REMEDIATION

- Close actionable net-new findings only.
- Keep fixes minimal, deterministic, and reversible.

### PHASE 3 - VERIFICATION MATRIX

Run and record:

- `npm run quality`
- `pwsh -NoLogo -NoProfile -File scripts/verify-pipeline.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1 -StrictSecrets`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-auth.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1 -FailOnPermissionDenied`
- `ssh-keygen -Y verify -f infra/allowed_signers -I structural-signing@against-the-odds -n file -s infra/STRUCTURAL_SIGNATURE.txt < infra/STRUCTURAL_STATE.json`

### PHASE 4 - BLOCKER CLASSIFICATION

- Cloud-closable items: close now.
- Local/main-only items: record exact owner, commands, browser URLs, and success signals.

### PHASE 5 - CANON/TRACKER UPDATE

Update only if changed:

- `docs/status/WORK_QUEUE.md`
- `docs/status/PP_AUDIT_MARKER.md`
- `docs/status/CONSOLIDATION_LOG.md`
- `docs/status/INDEX_REPORTS.md`
- `docs/AGENT_PROMPT_DECISION_TREE.md`
- local/main escalation pack if closure steps improve.

### PHASE 6 - FINALIZE

- Commit logical batches with why-focused messages.
- Push branch.
- Report final finish status with evidence.

## REQUIRED FINAL RESPONSE FORMAT

1. Prompt Shown (path + text)
2. Execution Summary
3. Findings Register (fingerprint, severity, status)
4. Changes Applied
5. Verification Matrix (command/result)
6. Remaining Blockers (owner + exact next action)
7. Git Finalization (branch + commit ids)
8. Next Delta Plan (only unresolved incremental work)

## SUCCESS CRITERIA

- All actionable net-new findings in scope are closed.
- No redundant rework of completed cycles.
- Verification matrix is current and reproducible.
- Remaining blockers are externalized with precise owner/action.
- Prompt routing + status trackers reflect current truth.
