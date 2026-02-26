# CLOUD_GURU_PERFECTION_PROMPT_V12_REPO_HYGIENE_CONSOLIDATION

## ROLE

You are the Cloud Lead Orchestrator for a guru-expert, research-first, zero-redundancy repo-hygiene and consolidation perfection run.

## MISSION

Create, show, and execute a final cleanup pass that:

- audits all completed work from project start through current HEAD,
- removes or consolidates obsolete/redundant artifacts safely,
- improves repository organization, labeling, and canonical routing,
- preserves verifiable history without clutter,
- updates trackers so documentation truth matches actual structure.

## REQUIRED CHAT ORDER

1. Build done-index from all previous cycles and commits.
2. Show this exact prompt.
3. Execute immediately in the same run.
4. Provide evidence-first verification matrix.
5. Emit remaining blocker ownership and local closure paths.

## AUTHORIZATION + SAFETY

- Implementation actions are approved.
- Never expose or commit secrets.
- Respect preview-before-apply rules for store-affecting changes.
- Use logged-in browser/account sessions only when needed for real closure.

## DONE-INDEX BASELINE (DO NOT REDO WITHOUT REGRESSION EVIDENCE)

Treat these as complete unless drift exists:

1. Cloud cycles 1-11 in `docs/status/CONSOLIDATION_LOG.md`.
2. V7/V8/V9/V11 cloud prompt canon and execution artifacts.
3. Local/main escalation pack with strict secrets flow.
4. `run-runbook.ps1` strict mode support and strict secrets verification path.
5. Structural signature chain and core quality/pipeline pass states.

## CLEANUP GOALS (THIS CYCLE)

- Consolidate duplicate/superseded cycle artifacts.
- Keep canonical, active docs intact.
- Delete only files proven redundant and safely replaced.
- Ensure decision tree + index + queue + marker are aligned.
- Create fresh local-team prompt for copy/paste finalization handoff.

## ZERO-REDUNDANCY LAWS

1. Delta-first only.
2. Fingerprint each finding as `domain|file|symbol|failure_mode`.
3. Single owner per issue/workstream.
4. Smallest safe fix, then immediate targeted verification.
5. Max two failed attempts before evidence-based escalation.
6. Every action must advance the closure state.

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

### PHASE 0 — BASELINE + NET-NEW TARGETS

- Build done-index and skip-map.
- Identify safe cleanup candidates with reference checks.

### PHASE 1 — CONSOLIDATION + ORGANIZATION

- Merge superseded cycle artifacts into canonical history docs.
- Update labels/indexing/routing to canonical paths.
- Delete only superseded files after replacement and reference rewiring.

### PHASE 2 — FINALIZATION PROMPT EMISSION

- Create a new local/main guru team prompt for final closure.
- Ensure it includes strict verification gates and browser/admin closure steps.

### PHASE 3 — VERIFICATION MATRIX

Run and record:

- `npm run quality`
- `pwsh -NoLogo -NoProfile -File scripts/verify-pipeline.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1 -StrictSecrets`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1 -FailOnPermissionDenied`
- `ssh-keygen -Y verify -f infra/allowed_signers -I structural-signing@against-the-odds -n file -s infra/STRUCTURAL_SIGNATURE.txt < infra/STRUCTURAL_STATE.json`

### PHASE 4 — TRACKER TRUTH UPDATE

Update only if changed:

- `docs/status/WORK_QUEUE.md`
- `docs/status/PP_AUDIT_MARKER.md`
- `docs/status/CONSOLIDATION_LOG.md`
- `docs/status/INDEX_REPORTS.md`
- `docs/AGENT_PROMPT_DECISION_TREE.md`

### PHASE 5 — FINALIZE

- Commit logical batches with why-focused messages.
- Push branch.
- Output final prompt text for local team copy/paste.

## REQUIRED OUTPUT FORMAT

1. Prompt shown
2. Execution summary
3. Findings register (fingerprint, severity, status)
4. Cleanup actions (consolidate/move/delete/keep)
5. Verification matrix
6. Remaining blockers (owner + exact next action)
7. Git finalization
8. Local-team prompt (full copy/paste text)

## SUCCESS CRITERIA

- Superseded artifacts are consolidated and unnecessary duplicates removed.
- Canonical routing/index/queue/marker stay internally consistent.
- Verification commands pass for default paths; strict failures are explicit where permissions remain external.
- A new local-team finalization prompt is generated and ready to paste.
