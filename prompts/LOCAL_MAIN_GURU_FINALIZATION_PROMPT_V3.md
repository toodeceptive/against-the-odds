# Local Main-Branch Guru Finalization Prompt (V3 — 2026-02-26)

**Role**: Local Main-Branch Guru Finalization Team.

**Goal**: Close remaining local-only and admin-only work with zero redundancy, then finalize the repo cleanly on main.

---

## 1. Non-negotiable Rules

- Use **main** branch only.
- Never commit secrets. Credentials in `.env.local` only.
- Use user's logged-in Chrome for browser-gated admin checks.
- Respect preview-before-apply for store-affecting actions.
- **Delta-first**: Do not redo completed work unless regression evidence exists.

---

## 2. Required Context (read first, in order)

1. `docs/status/HANDOFF_FOR_NEW_AGENT_202602.md`
2. `docs/status/WORK_QUEUE.md`
3. `docs/status/PP_AUDIT_MARKER.md`
4. `docs/status/CONSOLIDATION_LOG.md` (latest-first)
5. `docs/status/INDEX_REPORTS.md`
6. `docs/status/LOCAL_MAIN_FINALIZATION_PLAN_20260226.md`
7. `docs/AGENT_PROMPT_DECISION_TREE.md`
8. `OPERATOR_RUNBOOK.md`

---

## 3. Primary Goals

- Close GitHub secrets visibility blocker with elevated local auth (when operator completes `gh auth login`).
- Restore Codacy MCP availability in local Cursor (reset MCP; verify Copilot settings).
- Validate admin-only GitHub settings in browser (branch protection + code scanning).
- Run strict final verification gates.
- Finalize docs/status truth, commit, push, and verify CI.

---

## 4. Blocker Closure Steps (skip if already done)

### A. GitHub secrets visibility (403 blocker)

- Run: `gh auth status`
- Run: `gh auth refresh -h github.com -s repo,workflow,read:org` (after login)
- Run: `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1 -FailOnPermissionDenied`
- Run: `pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1 -StrictSecrets`

**Success**: No 403 from `gh secret list`; strict secrets check exits 0; strict runbook exits 0.

### B. Codacy MCP local restore

- Open local Cursor MCP settings.
- Verify codacy server from `.cursor/mcp.json` is enabled.
- Reset/reconnect MCP.
- Validate Codacy MCP tools are discoverable and runnable.

**Success**: Codacy tools available for file analysis.

### C. Admin browser checks (GitHub)

- Open: `https://github.com/toodeceptive/against-the-odds/settings/branches`
- Open: `https://github.com/toodeceptive/against-the-odds/settings/security_analysis`

**Success**: Branch protection and code scanning settings match repo policy/docs.

---

## 5. Strict Verification Gates (run all)

```
npm run quality
pwsh -NoLogo -NoProfile -File scripts/verify-pipeline.ps1
pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1 -StrictSecrets
pwsh -NoLogo -NoProfile -File scripts/github/verify-auth.ps1
pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1 -FailOnPermissionDenied
ssh-keygen -Y verify -f infra/allowed_signers -I structural-signing@against-the-odds -n file -s infra/STRUCTURAL_SIGNATURE.txt < infra/STRUCTURAL_STATE.json
```

Use `-SkipRunbook` for verify-pipeline if `.env.local` lacks Shopify creds. Credential-gated commands may fail; document result.

---

## 6. Documentation Truth Update

After closure, update:

- `docs/status/WORK_QUEUE.md`
- `docs/status/PP_AUDIT_MARKER.md`
- `docs/status/CONSOLIDATION_LOG.md`
- `docs/status/INDEX_REPORTS.md` (if paths changed)
- `docs/status/deploy-log.md` only if store-affecting apply occurred

---

## 7. Git Finalize

- Commit logical batches with why-focused messages.
- Push main.
- Confirm CI green.

---

## 8. Required Final Output Format

- **Executive summary**
- **Findings register** (fingerprint, severity, status)
- **Local fixes applied**
- **Verification matrix** (command/result)
- **Remaining blockers** (if any) with owner + exact next action
- **Git finalization** (branch/commits/CI)
- **Rollback notes**

---

## Codacy MCP Note

MCP resources may be unavailable in cloud session. For local closure: reset MCP in the extension; verify Copilot MCP settings in GitHub. Then review, audit, analyze, and utilize results to create another non-redundant prompt and execute again if needed.
