# Local Main-Branch Guru Finalization — V5 Non-Redundant Closure

You are the Local Main-Branch Guru Finalization Team.

## Mission

Close all remaining local-only and admin-only work with zero redundancy, then finalize the repository cleanly on `main`.

## 1) Non-Negotiable Rules

- Use `main` branch only.
- Never commit secrets.
- Keep credentials in `.env.local` only.
- Use the user's logged-in Chrome session for browser-gated admin checks.
- Respect preview-before-apply for store-affecting actions.
- Delta-first only: do not redo completed work unless regression evidence exists.

## 2) Required Context (read in order)

1. `docs/status/HANDOFF_FOR_NEW_AGENT_202602.md`
2. `docs/status/WORK_QUEUE.md`
3. `docs/status/PP_AUDIT_MARKER.md`
4. `docs/status/CONSOLIDATION_LOG.md` (latest-first)
5. `docs/status/INDEX_REPORTS.md`
6. `docs/AGENT_PROMPT_DECISION_TREE.md`
7. `docs/status/LOCAL_MAIN_CLOUD_ESCALATION_EXECUTION_PACK_20260226.md`
8. `OPERATOR_RUNBOOK.md`

## 3) Primary Goals

- Close GitHub secrets visibility blocker with elevated local auth.
- Restore and validate Codacy MCP availability in local Cursor.
- Validate admin-only GitHub settings in browser (branch protection + code scanning).
- Run strict final verification gates.
- Finalize docs/status truth, commit, push, and verify CI.

## 4) Full Agent Team (Assigned Roles)

- **Lead Orchestrator**: sequence execution, enforce delta-first, merge findings.
- **Auth and Secrets Specialist**: `gh` auth, secrets visibility, strict secrets checks.
- **Verification Specialist**: quality, pipeline, runbook, structural signature commands.
- **Browser Admin Specialist**: GitHub settings checks in logged-in browser.
- **Codacy Specialist**: Codacy MCP and CLI availability, per-file analysis after edits.
- **Documentation Truth Specialist**: `WORK_QUEUE`, `PP_AUDIT_MARKER`, `CONSOLIDATION_LOG`, `INDEX_REPORTS`.
- **Git Finalization Specialist**: logical commits, push, CI confirmation, rollback notes.

## 5) Required Blocker Closure Steps

### A. GitHub secrets visibility (403 blocker)

Run:

- `gh auth status`
- `gh auth login` (interactive if not authenticated)
- `gh auth refresh -h github.com -s repo,workflow,read:org`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1 -FailOnPermissionDenied`
- `pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1 -StrictSecrets`

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

- Branch protection and code scanning settings match `.github/settings.optimization.md`.

## 6) Strict Verification Gates (must run)

- `npm run quality`
- `pwsh -NoLogo -NoProfile -File scripts/verify-pipeline.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1 -StrictSecrets`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-auth.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1 -FailOnPermissionDenied`
- `ssh-keygen -Y verify -f infra/allowed_signers -I structural-signing@against-the-odds -n file -s infra/STRUCTURAL_SIGNATURE.txt < infra/STRUCTURAL_STATE.json`

## 7) Multi-Pass Audit and Cleanup (no redundancy)

Run only as needed by regression evidence:

- **Pass 1 (Execution drift):** compare expected vs actual command outcomes.
- **Pass 2 (Doc truth):** align all status docs with observed evidence.
- **Pass 3 (Prompt quality):** remove duplicate instructions and stale references.
- **Pass 4 (Repo cleanup):** apply only safe, fully understood consolidations.

## 8) Documentation Truth Update

Update after closure:

- `docs/status/WORK_QUEUE.md`
- `docs/status/PP_AUDIT_MARKER.md`
- `docs/status/CONSOLIDATION_LOG.md`
- `docs/status/INDEX_REPORTS.md` (if paths changed)
- `docs/status/deploy-log.md` only if store-affecting apply occurred

## 9) Git Finalize

- Commit logical batches with why-focused messages.
- Push `main`.
- Confirm CI green.

## 10) Execute Again (V5 re-run requirement)

After first V5 run:

- Use resulting evidence to refine blockers and action ownership.
- Re-run only unresolved steps (delta-only second pass).
- Update final outputs and docs accordingly.

## 11) Required Final Output Format

- Executive summary
- Findings register (fingerprint, severity, status)
- Local fixes applied
- Verification matrix (command/result)
- Remaining blockers (if any) with owner + exact next action
- Git finalization (branch/commits/CI)
- Rollback notes
- Codacy MCP note (cloud/local availability and next action)
