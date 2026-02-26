# Local Main Cloud Escalation Execution Pack (2026-02-26)

## Purpose

Provide a single escalation pack for local-main closure when cloud/session constraints prevent full blocker resolution in one pass.

## Scope

- GitHub CLI auth and secrets visibility closure
- Codacy MCP + Codacy CLI availability
- Browser-gated GitHub admin checks
- Strict verification gates and blocker ownership

## Current Execution State

- `gh` is installed at `C:\Program Files\GitHub CLI\gh.exe`.
- `gh` auth is still incomplete in this session (`gh auth login` pending completion).
- `scripts/github/verify-secrets.ps1 -FailOnPermissionDenied` now supports strict failure behavior and detects fallback `gh` path.
- `scripts/run-runbook.ps1 -StrictSecrets` fails due missing `SHOPIFY_ACCESS_TOKEN` in `.env.local`.
- Browser checks completed for:
  - `https://github.com/toodeceptive/against-the-odds/settings/branches`
  - `https://github.com/toodeceptive/against-the-odds/settings/security_analysis`
- Structural signature verify currently fails with:
  - `Couldn't parse signature: missing header`

## Command Evidence Matrix

| Command                                                                                   | Result                                      |
| ----------------------------------------------------------------------------------------- | ------------------------------------------- |
| `npm run quality`                                                                         | PASS                                        |
| `pwsh -NoLogo -NoProfile -File scripts/verify-pipeline.ps1`                               | FAIL (`run-runbook` credential gate)        |
| `pwsh -NoLogo -NoProfile -File scripts/run-runbook.ps1 -StrictSecrets`                    | FAIL (`SHOPIFY_ACCESS_TOKEN` missing)       |
| `pwsh -NoLogo -NoProfile -File scripts/github/verify-auth.ps1`                            | PASS                                        |
| `pwsh -NoLogo -NoProfile -File scripts/github/verify-secrets.ps1 -FailOnPermissionDenied` | FAIL (gh not authenticated)                 |
| `ssh-keygen -Y verify ...`                                                                | FAIL (invalid/incomplete signature payload) |

## Escalation Owners and Next Actions

1. **Local operator (GitHub auth)**
   - Run `& "C:\Program Files\GitHub CLI\gh.exe" auth login`
   - Run `& "C:\Program Files\GitHub CLI\gh.exe" auth refresh -h github.com -s repo,workflow,read:org`

2. **Local operator (credentials)**
   - Add `SHOPIFY_ACCESS_TOKEN` to `.env.local`
   - Re-run strict runbook and pipeline gate

3. **GitHub admin**
   - Align branch protection/rulesets per `.github/settings.optimization.md`
   - Confirm code scanning settings on security analysis page

4. **Local operator (structural signature)**
   - Run `pwsh -NoLogo -NoProfile -File scripts/infra/sign-structural-state.ps1`
   - Re-run `ssh-keygen -Y verify ...`

## Codacy MCP/CLI Note

- In cloud sessions, Codacy tool availability may vary.
- Local closure path:
  - Confirm `codacy` server in `.cursor/mcp.json`
  - Reset MCP in extension
  - Verify Copilot MCP settings in GitHub
  - Run `codacy_cli_analyze` on all edited files
