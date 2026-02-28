# Codacy MCP Setup and Troubleshooting

Codacy provides static analysis via its MCP (Model Context Protocol) server. When available in Cursor, agents run `codacy_cli_analyze` after edits and on dependency changes (Trivy scan). **CI still runs format, lint, unit tests, and Trivy** regardless of Codacy MCP availability.

## Configuration

- **MCP config**: [.cursor/mcp.json](../.cursor/mcp.json) — Codacy server `codacy` with `npx -y @codacy/codacy-mcp@latest`
- **Agent rules**: [.cursor/rules/codacy.mdc](../.cursor/rules/codacy.mdc) — when to run analysis; **graceful fallback** when MCP unavailable (run `npm run quality` instead; do not block)
- **Token** (optional): For Codacy Cloud integration, add `CODACY_ACCOUNT_TOKEN` to `.env.local` and use `envmcp` like the GitHub server, or set in Cursor MCP env. Local `codacy_cli_analyze` may work without it for some tools.

## When Codacy MCP is "not in session"

If Cursor reports that the Codacy MCP Server is not available or not in the MCP list:

1. **Reset MCP** on the Codacy extension or in Cursor MCP settings.
2. **Check Copilot MCP settings** (if using VS Code with Copilot):
   - [GitHub Settings → Copilot → Enable MCP servers](https://github.com/settings/copilot/features)
   - [Organization settings](https://github.com/organizations/{organization-name}/settings/copilot/features) (admins only)
3. **Ensure the Codacy extension is installed** — see [.cursor/extensions.json](../.cursor/extensions.json) for recommended extensions.
4. **Restart Cursor** after changes to `.cursor/mcp.json` or extension install.

If none of the above works, contact Codacy support. Agents will continue to follow `.cursor/rules/codacy.mdc` and suggest these steps when MCP tools are unavailable.

## Local Codacy CLI (when MCP unavailable)

Run Codacy analysis locally via the CLI:

```powershell
bash .codacy/cli.sh analyze
```

**Windows**: Ensure Git Bash or WSL is available. If `cli.sh` fails with `$'\r': command not found`, convert line endings: `(Get-Content .codacy/cli.sh -Raw) -replace "`r`n", "`n" | Set-Content .codacy/cli.sh -NoNewline -Encoding utf8`

## Local quality checks (without Codacy)

When Codacy MCP is not loaded, run these for equivalent CI coverage:

```powershell
npm run format:check   # Prettier
npm run lint           # ESLint
npm run test:unit      # Vitest
npm audit              # Dependency vulnerabilities
```

CI also runs Trivy (fs scan) and secret scanning. See [.github/workflows/ci.yml](../.github/workflows/ci.yml).

## Codacy config in repo

Analysis config lives in [.codacy/](../.codacy/) — `codacy.yaml` (tool versions) is tracked for reproducibility. Generated files (`tools-configs/`, `logs/`, `cli-config.yaml`) are gitignored in `.codacy/.gitignore`.

### Code style for .codacy/codacy.yaml

`.codacy/codacy.yaml` is formatted by **Prettier** (same as other YAML in the repo). This avoids CI/Codacy Cloud failures:

- **Pre-commit**: lint-staged runs Prettier on `**/*.{yml,yaml}` (including `.codacy/`) when you commit
- **CI**: `npm run format:check` verifies `.codacy/codacy.yaml` is formatted
- **Codacy Cloud**: [.codacy.yml](../.codacy.yml) at repo root excludes `.codacy/**` from Codacy analysis to prevent duplicate/conflicting style checks

If CI fails with "code style issues in .codacy/codacy.yaml", run `npx prettier --write .codacy/codacy.yaml` and commit.

## GitHub Code Scanning / SARIF (July 2025 change)

If you use **Codacy Cloud** with GitHub Code Scanning (SARIF upload), analysis may fail with:

> Code Scanning could not process the submitted SARIF file: A delivery cannot contain multiple runs with the same category.

**Cause**: GitHub changed Code Scanning policy (July 2025) to reject multiple SARIF runs per category. Codacy's tools were still uploading multi-run SARIF as of the change.

**Workarounds** (until Codacy updates):

1. **Codacy Cloud**: Disable SARIF upload to GitHub in Codacy repository settings (if available).
2. **Codacy Analysis CLI Action**: If you use `codacy/codacy-analysis-cli-action` with `format: sarif` and upload to CodeQL, temporarily remove that workflow or disable the upload step.
3. **This repo**: We do not use Codacy in CI; CI runs format, lint, test, Trivy, and secret-scan directly. Codacy MCP is optional for local analysis.

See [codacy/codacy-analysis-cli#541](https://github.com/codacy/codacy-analysis-cli/issues/541) and [codacy/codacy-analysis-cli-action#142](https://github.com/codacy/codacy-analysis-cli-action/issues/142) for upstream status.
