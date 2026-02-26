# Integration Stack Cost/Value Audit (2026-02-26)

## Objective

Define the most logical, reliable, and cost-aware integration setup for this repository without reducing core agentic capability.

## Evidence Basis

- Repo integration footprint (`.cursor/mcp.json`, `.cursor/extensions.json`, docs, scripts)
- Live MCP connectivity/auth checks
- Strict verification run outputs in this session
- Current public pricing signals (BrowserStack, Linear, Notion, Slack, Cloudflare, Codacy)

## Current State Matrix

| Integration                                  | Live status                  | Cost signal                           | Repo dependency        | Decision                                                       | Action now                    |
| -------------------------------------------- | ---------------------------- | ------------------------------------- | ---------------------- | -------------------------------------------------------------- | ----------------------------- |
| GitHub MCP (`user-github`)                   | Functional                   | Included in GitHub account            | High                   | Keep active                                                    | Kept                          |
| Codacy MCP + CLI (`user-codacy`)             | Functional after reinstall   | Free plan available                   | Medium-high            | Keep active                                                    | Kept and verified             |
| Cursor browser MCP                           | Functional                   | Included in Cursor                    | High                   | Keep active                                                    | Kept                          |
| Cloudflare docs MCP                          | Functional                   | Free docs access                      | Medium                 | Keep active                                                    | Kept                          |
| Cloudflare bindings/builds/observability MCP | Not authenticated            | Paid/plan-dependent operational value | Low-medium (on demand) | Keep disabled by default; enable only for Cloudflare ops tasks | Left disabled                 |
| BrowserStack MCP                             | Unauthorized (`401`)         | High cost vs local alternatives       | Low                    | Disable/remove from default stack                              | Marked obsolete for this repo |
| Linear MCP                                   | Not authenticated            | Per-seat paid beyond free tier        | Low                    | Disable/remove from default stack                              | Marked obsolete for this repo |
| Notion MCP                                   | Not authenticated            | Per-seat paid beyond free tier        | Low                    | Disable/remove from default stack                              | Marked obsolete for this repo |
| Slack MCP                                    | Not authenticated            | Per-seat paid beyond free tier        | Low                    | Disable/remove from default stack                              | Marked obsolete for this repo |
| Printful lanes (agent roles/scripts)         | Available by workflow design | User-approved paid platform           | Medium                 | Keep on-demand                                                 | Kept                          |

## Recommended Ideal Setup

### Tier 1: Always-on core

- GitHub MCP
- Codacy MCP + CLI
- Cursor browser MCP
- Cloudflare docs MCP

### Tier 2: On-demand enablement only

- Cloudflare bindings/builds/observability
- Printful upload/order lanes

### Tier 3: Disabled by default

- BrowserStack MCP
- Linear MCP
- Notion MCP
- Slack MCP

## Best-Practice Replacements

- BrowserStack -> Playwright (`npm run test:e2e`, `npm run test:shopify`) + Cursor browser MCP for live admin checks
- Linear -> GitHub Issues + Projects
- Notion -> `docs/status/*` and versioned markdown runbooks
- Slack -> GitHub notifications, PR reviews, and issue comments

## Safety and Capability Guardrail

No project-critical capability is removed by this setup. Core CI, verification, auth checks, and browser-admin flows remain intact. Store-affecting and admin-affecting changes continue to require approval gates.

## Implementation Notes (this run)

- Project-level MCP config is already minimal and correct in `.cursor/mcp.json` (GitHub + Codacy only).
- BrowserStack/Linear/Notion/Slack are not required by repository automation and are treated as optional external connectors.
- This audit intentionally avoids irreversible account-level deletions in-session to prevent accidental capability loss.
