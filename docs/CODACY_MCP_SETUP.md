# Codacy MCP Setup and Troubleshooting

Codacy provides static analysis via its MCP (Model Context Protocol) server. When available in Cursor, agents run `codacy_cli_analyze` after edits and on dependency changes (Trivy scan). **CI still runs format, lint, unit tests, and Trivy** regardless of Codacy MCP availability.

## Configuration

- **MCP config**: [.cursor/mcp.json](../.cursor/mcp.json) — Codacy is configured as `codacy` with `npx -y @codacy/codacy-mcp@latest`
- **Agent rules**: [.cursor/rules/codacy.mdc](../.cursor/rules/codacy.mdc) — when to run analysis, fallbacks when MCP is unavailable

## When Codacy MCP is "not in session"

If Cursor reports that the Codacy MCP Server is not available or not in the MCP list:

1. **Reset MCP** on the Codacy extension or in Cursor MCP settings.
2. **Check Copilot MCP settings** (if using VS Code with Copilot):
   - [GitHub Settings → Copilot → Enable MCP servers](https://github.com/settings/copilot/features)
   - [Organization settings](https://github.com/organizations/{organization-name}/settings/copilot/features) (admins only)
3. **Ensure the Codacy extension is installed** — see [.cursor/extensions.json](../.cursor/extensions.json) for recommended extensions.
4. **Restart Cursor** after changes to `.cursor/mcp.json` or extension install.

If none of the above works, contact Codacy support. Agents will continue to follow `.cursor/rules/codacy.mdc` and suggest these steps when MCP tools are unavailable.

## Local quality checks (without Codacy MCP)

When Codacy MCP is not loaded, run these manually for equivalent CI coverage:

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
