# Infrastructure — Structural Integrity

Required by structural integrity contract. See [AGENTS.md](../AGENTS.md), [docs/VERSION_POLICY.md](../docs/VERSION_POLICY.md).

## Files

- **STRUCTURAL_STATE.json** — Content hashes of designated structural files (canonical ordering).
- **STRUCTURAL_SIGNATURE.txt** — Detached signature of STRUCTURAL_STATE (ssh-keygen -Y sign). CI verifies only; never generated in CI.
- **structural.pub** — Public key for verification. Private key stays local (e.g. `~/.ssh/structural_key`).
- **allowed_signers** — Generated from structural.pub for `ssh-keygen -Y verify` (principal from key comment).

## Regenerating after structural changes

1. Edit structural files (AGENTS.md, CODEOWNERS, docs/OWNERSHIP_REGISTRY.md, docs/SSOT_ATO.md, docs/VERSION_POLICY.md, .github/workflows/ci.yml).
2. Run from repo root:
   - **Unix / Git Bash / WSL**: `bash scripts/infra/sign-structural-state.sh`
   - **PowerShell**: `.\scripts\infra\sign-structural-state.ps1` (on Windows, use Git Bash or WSL if sign step fails)
3. Commit `infra/STRUCTURAL_STATE.json` and `infra/STRUCTURAL_SIGNATURE.txt` (or `STRUCTURAL_SIGNATURE_NEW.txt` if the former was locked; arch_guard accepts either).

## Verification (CI)

`arch_guard` job runs `ssh-keygen -Y verify` on every PR/push to main.
