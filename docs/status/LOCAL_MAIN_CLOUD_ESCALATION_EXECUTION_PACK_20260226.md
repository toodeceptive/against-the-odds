# Local Main-Branch Cloud-Escalation Execution Pack (2026-02-26)

## Purpose

This pack is the execution output of:

- `prompts/LOCAL_MAIN_GURU_PERFECTION_PROMPT_V1_CLOUD_ESCALATION.md`

It is designed for a **new local/main-branch guru team chat** to close issues that are cloud-unresolvable due to permissions, local tooling, or account-scoped browser sessions.

## Done Index (Cloud Cycles 1-7, do not repeat)

Already completed and verified:

- CodeQL default-vs-advanced conflict resolved; CodeQL workflow healthy.
- Shopify credential recovery completed locally in `.env.local` (not committed).
- Runbook and Shopify connection scripts made deterministic.
- Structural signature chain regenerated and verified.
- V8 project-wide delta rerun executed with net-new hardening.

Reference:

- `docs/status/WORK_QUEUE.md`
- `docs/status/PP_AUDIT_MARKER.md`
- `docs/status/CONSOLIDATION_LOG.md`

## Blockers Requiring Local/Main Execution

### 1) GitHub secrets visibility 403

- Fingerprint: `github|scripts/github/verify-secrets.ps1|gh secret list|HTTP 403`
- Why cloud cannot close:
  - Cloud session token/app lacks required admin scopes for secrets listing.
  - Requires local `gh` auth with elevated scopes and/or admin browser session.
- Local owner: GitHub permissions/admin operator.

Local closure steps:

1. `gh auth status`
2. `gh auth login` (scopes: `repo`, `workflow`, admin scopes as needed)
3. `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1 -FailOnPermissionDenied`
4. If still blocked, verify directly in browser:
   - `https://github.com/toodeceptive/against-the-odds/settings/secrets/actions`
5. Confirm required secrets exist:
   - `SHOPIFY_STORE_DOMAIN`
   - `SHOPIFY_ACCESS_TOKEN`
   - `SHOPIFY_THEME_ID`

Success signal:

- `verify-secrets.ps1 -FailOnPermissionDenied` can list secrets (no 403) and returns exit `0`.

### 2) Codacy MCP unavailable in cloud

- Fingerprint: `mcp|.cursor/mcp.json|codacy_server|unavailable_in_cloud`
- Why cloud cannot close:
  - MCP connectivity is environment/session dependent.
  - Requires local Cursor MCP feature + extension/server wiring.
- Local owner: local Cursor/MCP operator.

Local closure steps:

1. Open local Cursor settings and verify MCP enabled.
2. Verify `codacy` server from `.cursor/mcp.json` is active.
3. Reset/reconnect MCP server in Cursor.
4. Validate Codacy tools are available in chat/tooling.
5. If still unavailable, follow troubleshooting in `.cursor/rules/codacy.mdc` and escalate to Codacy support.

Success signal:

- Codacy MCP tools are discoverable and runnable on edited files.

### 3) Admin/browser-only governance checks

- Fingerprint: `github|admin_settings|branch_protection_codeql|browser_only_validation`
- Why cloud cannot close:
  - Requires repository admin UI access and account-scoped browser session.
- Local owner: GitHub admin operator.

Local closure steps:

1. Branch protections:
   - `https://github.com/toodeceptive/against-the-odds/settings/branches`
2. Code scanning settings:
   - `https://github.com/toodeceptive/against-the-odds/settings/security_analysis`
3. Confirm protections/checks match repo policy and docs.

Success signal:

- UI settings match expected policy, no drift.

## Local Verification Gates (Run on `main`)

Execute and capture evidence:

- `npm run format:check`
- `npm run lint`
- `npm run test:unit`
- `pwsh -NoLogo -NoProfile -File scripts/verify-pipeline.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1 -StrictSecrets`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-auth.ps1`
- `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1 -FailOnPermissionDenied`
- `ssh-keygen -Y verify -f infra/allowed_signers -I structural-signing@against-the-odds -n file -s infra/STRUCTURAL_SIGNATURE.txt < infra/STRUCTURAL_STATE.json`

## Finalization (Local/Main Team)

After local closure:

1. Update:
   - `docs/status/WORK_QUEUE.md`
   - `docs/status/PP_AUDIT_MARKER.md`
   - `docs/status/CONSOLIDATION_LOG.md`
   - `docs/status/deploy-log.md` if any store-affecting apply occurred
2. Commit logical batches on `main`.
3. Push `main`.
4. Confirm CI green.

## Cloud Execution Evidence (for this pack generation run)

Observed in cloud during this execution pass:

- `verify-secrets.ps1` still reports 403 warning on `gh secret list`.
- MCP resources remain unavailable in this cloud session.
- Core project gates pass (`verify-pipeline`, runbook, quality), confirming blockers are local/admin scoped rather than core code regressions.
