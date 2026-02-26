# Local Main-Branch Guru Finalization — V7 (Delta-Only Externals Closure)

Use this only after V6 has been executed once.

## Purpose

Close remaining unresolved deltas without re-running completed lanes.

## Delta-Only Rules

- Do not re-run any step marked PASS in the previous matrix.
- Touch only unresolved blockers and their direct dependencies.
- Preserve all non-negotiable safety rules from V6.

## Current Priority Deltas

1. Missing local `SHOPIFY_ACCESS_TOKEN` for strict runbook closure.
2. Missing `gh` authenticated session with `read:org` scope for strict secrets closure.
3. Structural signature payload invalid (`missing header`) unless intentionally regenerated.
4. Branch protection/check alignment against `.github/settings.optimization.md`.

## Execute Only These Steps

1. Credentials lane:
   - ensure `.env.local` has `SHOPIFY_ACCESS_TOKEN` and optional `GITHUB_TOKEN`.
   - run `pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1 -StrictSecrets`.

2. GitHub auth lane:
   - run `& "C:\Program Files\GitHub CLI\gh.exe" auth status`.
   - run `& "C:\Program Files\GitHub CLI\gh.exe" auth refresh -h github.com -s repo,workflow,read:org`.
   - run `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1 -FailOnPermissionDenied`.

3. Structural lane (only if needed):
   - `pwsh -NoLogo -NoProfile -File scripts/infra/sign-structural-state.ps1`
   - `cmd /c "ssh-keygen -Y verify -f infra/allowed_signers -I structural-signing@against-the-odds -n file -s infra/STRUCTURAL_SIGNATURE.txt < infra/STRUCTURAL_STATE.json"`

4. Admin policy lane (browser):
   - verify branch protection/rules and code scanning settings match policy docs.

## Exit Condition

Stop when each remaining delta is either:

- PASS with command evidence, or
- External/manual blocker with owner + exact next action.

## Required Output

- Delta resolution summary
- Updated verification matrix (delta rows only)
- Remaining external/manual blockers
- Docs updated (`WORK_QUEUE`, `PP_AUDIT_MARKER`, `CONSOLIDATION_LOG`, `INDEX_REPORTS`)
