# LOCAL_MAIN_GURU_FINALIZATION_PROMPT_V2_CLEAN_CONSOLIDATE_CLOSEOUT

You are the **Local Main-Branch Guru Finalization Team**.

Your job is to close all remaining local-only and admin-only work with zero redundancy, then finalize the repo cleanly on `main`.

## 1) Non-negotiable rules

- Use `main` branch only.
- Never commit secrets.
- Keep credentials in `.env.local` only.
- Use user's logged-in Chrome session for browser-gated admin checks.
- Respect preview-before-apply for store-affecting actions.
- Delta-first only: do not redo completed work unless regression evidence exists.

## 2) Required context (read first, in order)

1. `docs/status/HANDOFF_FOR_NEW_AGENT_202602.md`
2. `docs/status/WORK_QUEUE.md`
3. `docs/status/PP_AUDIT_MARKER.md`
4. `docs/status/CONSOLIDATION_LOG.md` (latest-first)
5. `docs/status/INDEX_REPORTS.md`
6. `docs/AGENT_PROMPT_DECISION_TREE.md`
7. `docs/status/LOCAL_MAIN_CLOUD_ESCALATION_EXECUTION_PACK_20260226.md`
8. `OPERATOR_RUNBOOK.md`

## 3) Primary goals

1. Close GitHub secrets visibility blocker with elevated local auth.
2. Restore Codacy MCP availability in local Cursor.
3. Validate admin-only GitHub settings in browser (branch protection + code scanning).
4. Run strict final verification gates.
5. Finalize docs/status truth, commit, push, and verify CI.

## 4) Required blocker closure steps

### A. GitHub secrets visibility (403 blocker)

- Run: `gh auth status`
- Run: `gh auth refresh -h github.com -s repo,workflow,read:org`
- Run strict check: `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1 -FailOnPermissionDenied`
- Run one-command strict flow: `pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1 -StrictSecrets`

Success signal:

- No 403 from `gh secret list`
- strict secrets check exits `0`
- strict runbook exits `0`

### B. Codacy MCP local restore

- Open local Cursor MCP settings.
- Verify `codacy` server from `.cursor/mcp.json` is enabled.
- Reset/reconnect MCP.
- Validate Codacy MCP tools are discoverable and runnable in chat.

Success signal:

- Codacy tools are available for file analysis runs.

### C. Admin browser checks (GitHub)

Open and verify:

- `https://github.com/toodeceptive/against-the-odds/settings/branches`
- `https://github.com/toodeceptive/against-the-odds/settings/security_analysis`

Success signal:

- Branch protection and code scanning settings match repo policy/docs.

## 5) Strict verification gates (must run)

- `npm run quality`
- `pwsh -NoLogo -NoProfile -File scripts/verify-pipeline.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1 -StrictSecrets`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-auth.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1 -FailOnPermissionDenied`
- `ssh-keygen -Y verify -f infra/allowed_signers -I structural-signing@against-the-odds -n file -s infra/STRUCTURAL_SIGNATURE.txt < infra/STRUCTURAL_STATE.json`

## 6) Documentation truth update (after closure)

Update:

- `docs/status/WORK_QUEUE.md`
- `docs/status/PP_AUDIT_MARKER.md`
- `docs/status/CONSOLIDATION_LOG.md`
- `docs/status/INDEX_REPORTS.md` (if paths changed)
- `docs/status/deploy-log.md` only if store-affecting apply occurred

## 7) Git finalize

- Commit logical batches with why-focused messages.
- Push `main`.
- Confirm CI green.

## 8) Required final output format

1. Executive summary
2. Findings register (fingerprint, severity, status)
3. Local fixes applied
4. Verification matrix (command/result)
5. Remaining blockers (if any) with owner + exact next action
6. Git finalization (branch/commits/CI)
7. Rollback notes
