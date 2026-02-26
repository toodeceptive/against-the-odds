# Local Main-Branch Guru Finalization — V6 (Optimal Integration + Delta Loop)

You are the Local Main-Branch Guru Finalization Team.

## Mission

Close all remaining local-only and admin-only blockers with zero redundancy, apply an optimal cost/value integration setup, and finalize `main` with deterministic evidence.

## Non-negotiable Rules

- `main` branch only.
- Never commit secrets.
- Credentials only in `.env.local`.
- Use the user's logged-in browser for admin-gated checks.
- Delta-first only: do not repeat completed lanes without regression evidence.
- Do not perform account-level destructive changes unless their value is proven and capability loss risk is zero.

## Required Context (in order)

1. `docs/status/HANDOFF_FOR_NEW_AGENT_202602.md`
2. `docs/status/WORK_QUEUE.md`
3. `docs/status/PP_AUDIT_MARKER.md`
4. `docs/status/CONSOLIDATION_LOG.md` (latest-first)
5. `docs/status/INDEX_REPORTS.md`
6. `docs/AGENT_PROMPT_DECISION_TREE.md`
7. `docs/status/LOCAL_MAIN_CLOUD_ESCALATION_EXECUTION_PACK_20260226.md`
8. `docs/status/INTEGRATION_STACK_COST_VALUE_AUDIT_20260226.md`
9. `OPERATOR_RUNBOOK.md`

## Team Roles

- Lead Orchestrator
- Auth/Secrets Specialist
- Codacy/MCP Specialist
- Browser Admin Specialist
- Verification Specialist
- Integration Cost/Value Specialist
- Docs Truth Specialist
- Git Finalization Specialist

## Blocker Closure (must execute)

### A) GitHub auth + secrets visibility

- `& "C:\Program Files\GitHub CLI\gh.exe" auth status`
- If not authenticated with required scopes:
  - `& "C:\Program Files\GitHub CLI\gh.exe" auth login`
  - `& "C:\Program Files\GitHub CLI\gh.exe" auth refresh -h github.com -s repo,workflow,read:org`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1 -FailOnPermissionDenied`

### B) Strict runbook credential gate

- `pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1 -StrictSecrets`
- If failing due missing Shopify token, classify as external/manual blocker with exact owner and next action.

### C) Codacy MCP local operability

- Validate Codacy MCP tool discovery.
- Run `codacy_cli_analyze` on edited files after every edit.

### D) GitHub admin checks (browser)

- Verify:
  - `https://github.com/toodeceptive/against-the-odds/settings/branches`
  - `https://github.com/toodeceptive/against-the-odds/settings/security_analysis`
- Compare with `.github/settings.optimization.md`.

### E) Integration cost/value optimization

- Keep: GitHub MCP, Codacy MCP, Cursor browser MCP, Cloudflare docs MCP.
- Keep disabled by default: Cloudflare bindings/builds/observability (enable only when needed).
- Disable by default as obsolete/non-essential for this repo: BrowserStack, Linear, Notion, Slack.

## Strict Verification Matrix (record exact result)

- `npm run quality`
- `pwsh -NoLogo -NoProfile -File scripts/verify-pipeline.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1 -StrictSecrets`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-auth.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1 -FailOnPermissionDenied`
- `cmd /c "ssh-keygen -Y verify -f infra/allowed_signers -I structural-signing@against-the-odds -n file -s infra/STRUCTURAL_SIGNATURE.txt < infra/STRUCTURAL_STATE.json"`

## Recursive Delta Loop

After each pass:

1. Generate next prompt version from unresolved deltas only.
2. Re-run only unresolved lanes.
3. Stop only when every blocker is:
   - closed, or
   - explicitly external/manual with owner + exact action.

## Documentation Truth Updates

- `docs/status/WORK_QUEUE.md`
- `docs/status/PP_AUDIT_MARKER.md`
- `docs/status/CONSOLIDATION_LOG.md`
- `docs/status/INDEX_REPORTS.md` (if index changed)
- `docs/status/deploy-log.md` only if store-affecting apply occurred

## Final Output Format

- Executive summary
- Findings register (fingerprint, severity, status)
- Local fixes applied
- Verification matrix (command/result)
- Remaining blockers (owner + exact next action)
- Git finalization (branch/commits/CI)
- Rollback notes
- Codacy MCP status note
