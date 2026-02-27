# AO Agent — Prodigy Protocol mode

**Purpose**: Run Against The Odds (AO) tasks in Prodigy Protocol mode. Invoked by `-pp` or `/pp` in Cursor chat.

---

## Protocol

1. **Invoke** the prodigy-protocol skill (`.cursor/skills/prodigy-protocol/SKILL.md`).
2. **Apply** the PP workflow: purpose → parse → task tree → execute → audit loop.
3. **Parse** the user's message (after `/pp` or `-pp`) as the task directive.
4. **Build** a minimal task tree (typically 2–6 steps).
5. **Execute** the smallest verifiable step first; validate; audit; report.

---

## Repo context

| Item         | Path or reference                  |
| ------------ | ---------------------------------- |
| **Repo**     | against-the-odds                   |
| **Store**    | aodrop.com                         |
| **Theme**    | `src/shopify/themes/aodrop-theme/` |
| **Products** | `data/products/*.json`             |

---

## Safety rules

- [shopify-preview-approval.mdc](.cursor/rules/shopify-preview-approval.mdc) — Preview before store-affecting apply.
- [env-credentials.mdc](.cursor/rules/env-credentials.mdc) — No secrets in commits; `.env.local` only.
- [use-user-browser.mdc](.cursor/rules/use-user-browser.mdc) — Use user's browser for credentials/setup when needed.

---

## References

| Doc                                                                            | Purpose                            |
| ------------------------------------------------------------------------------ | ---------------------------------- |
| [AGENTS.md](AGENTS.md)                                                         | Agent permission and safety rules  |
| [OPERATOR_RUNBOOK.md](OPERATOR_RUNBOOK.md)                                     | Daily checks, Shopify flow         |
| [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md) | Preview → approve → apply workflow |
| `scripts/verify-pipeline.ps1`                                                  | Pipeline script verification       |
| `npm run quality`                                                              | Format + lint + unit tests         |

---

## Flow

1. **Parse intent** — Extract explicit goal, latent requirements, constraints, success criteria.
2. **Build task tree** — Decompose into 2–6 smallest verifiable steps.
3. **Execute** — Run one step; validate; audit.
4. **Report** — What changed, why, how to verify.
5. **Loop** — Continue until task complete or blocked.
