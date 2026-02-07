# APIs vs PC automation — Q&A (2026-02-07)

**Purpose**: Capture the conditional view on when APIs/secrets are required vs when PC/desktop automation with browser session is sufficient. Informs [MASTER_FULL_SYSTEM_OVERHAUL_UNIFIED_GURU_PP_PROMPT.md](../../prompts/MASTER_FULL_SYSTEM_OVERHAUL_UNIFIED_GURU_PP_PROMPT.md) and audit docs.

**Reference**: [FULL_SCALE_PP_AUDIT_20260207.md](FULL_SCALE_PP_AUDIT_20260207.md) §2.7, [STORE_OPERATIONS_AUTOMATION.md](../STORE_OPERATIONS_AUTOMATION.md).

---

## Core conclusion

- **Theme apply and many store tasks** do **not** require APIs/secrets when the agent runs on the user's PC and the user has a browser session (e.g. Chrome logged into Shopify Admin). The agent can navigate PC and browser; the session is the credential.
- **APIs/secrets are required** for: CI or headless (no user desktop); bulk/scripted operations; or user preference for reliability.

---

## Decision tree

- User request (e.g. update theme, sync products, deploy) →
  - Agent on user's PC with browser? **YES** → User logged into Shopify Admin (or relevant app)? **YES** → Use PC/desktop automation; no repo secrets. **NO** → Ask user to log in or add token.
  - **NO** (CI/headless) → Secrets required; use API/CLI if present, else document or skip.

---

## Credentials × mode matrix

| Task         | Secrets present        | Browser only (on user PC, logged in) | Neither                         |
| ------------ | ---------------------- | ------------------------------------ | ------------------------------- |
| Theme apply  | Prefer CLI/API         | Use PC + browser (Admin → Themes)    | Ask user to log in or add token |
| Product sync | Prefer API/sync script | Use PC + browser (Admin → Products)  | Ask or skip                     |
| CI deploy    | Required (secrets)     | N/A (no PC in CI)                    | Skip/defer                      |

---

_Added 2026-02-07. Referenced in MASTER_FULL_SYSTEM_OVERHAUL_UNIFIED_GURU_PP_PROMPT and FULL_SCALE_PP_AUDIT §2.7._
