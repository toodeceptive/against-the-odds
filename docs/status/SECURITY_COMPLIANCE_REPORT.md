# Security and Compliance Report

**Date:** 2026-01-30  
**Scope:** Expert Team Security and Platform Plan (platform gurus + security pass).  
**Purpose:** Confirm rules/docs alignment, record Shopify and local-only decisions, list one-off hardening.

---

## 1. Rules and docs alignment

- **Secrets:** [.cursor/rules/env-credentials.mdc](../../.cursor/rules/env-credentials.mdc) and [docs/security/AGENT_AND_REPO_SECURITY.md](../security/AGENT_AND_REPO_SECURITY.md) state secrets only in `.env.local` (local) or GitHub Actions secrets (CI); never commit or log. Aligned.
- **Preview before apply:** [.cursor/rules/shopify-preview-approval.mdc](../../.cursor/rules/shopify-preview-approval.mdc) and [docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md](../AGENT_WORKFLOW_CURSOR_SHOPIFY.md) require snapshot to [docs/status/pending-approval.md](pending-approval.md), then explicit user approval in chat, then apply and clear pending-approval. Aligned.
- **Cursor data boundary:** [docs/security/CURSOR_DATA_BOUNDARY.md](../security/CURSOR_DATA_BOUNDARY.md) documents: secrets only in `.env.local`; non-secret repo content may be sent to Cursor for AI; browser MCP uses local Chrome. Aligned.
- **Security checklist:** [docs/security/00_security_checklist.md](../security/00_security_checklist.md) covers secrets hygiene, access control (GitHub/Shopify), CI secrets, dependencies, backups, incident response. No conflict with this report.

---

## 2. Shopify decision (ToS and safe operations)

- **Headless admin automation:** Unattended headless browser automation of Shopify Admin is **not** explicitly permitted under Shopify API terms. We do **not** use it for store-affecting changes.
- **Approved approaches:** (1) **Theme:** Edit in Cursor → preview → approve → push to GitHub → Shopify GitHub App deploys. (2) **Products (bulk):** Edit JSON in repo → dry-run → approve in chat → run sync once (Admin API from your PC with custom app token). (3) **Products/settings (one-off):** Use **your open browser** (Cursor browser MCP); you watch; agent stops before Save and asks “does this look good?” before finalizing.
- **Deprecation:** [tests/e2e/shopify-admin.spec.js](../../tests/e2e/shopify-admin.spec.js) and [src/browser-automation/shopify-admin.js](../../src/browser-automation/shopify-admin.js) carry a note: unattended headless automation of Shopify Admin is not recommended per Shopify API terms; use for manual or user-in-browser flows only.

---

## 3. Local-only requirement

- **Required on your PC (never in repo):** **`.env.local`** at repo root only. No other repo content is required to be stored in a different desktop folder. See [docs/CREDENTIALS_SETUP.md](../CREDENTIALS_SETUP.md) and [.cursor/rules/env-credentials.mdc](../../.cursor/rules/env-credentials.mdc).
- **Optional local-only:** Shopify CLI auth (`shopify auth login`) in your user profile; theme dev preview runs locally.

---

## 4. GitHub and CI

- **Actions:** Prefer `GITHUB_TOKEN` for workflows; PAT only where needed (e.g. local scripts). Workflows use `permissions: contents: read` (or minimal); SHOPIFY\_\* secrets only in workflows that need them (e.g. shopify-sync.yml). Aligned with [docs/security/00_security_checklist.md](../security/00_security_checklist.md).
- **Branch strategy:** CI triggers on `main` and `develop`; deploy and theme flow via Shopify GitHub App. Documented in runbook and workflow docs.

---

## 5. One-off hardening (recommended)

- [ ] Confirm `.gitignore` includes `.env.local` (and that no `.env.local` is ever committed).
- [ ] Optional: add pre-commit or CI secret scan (blocklist for `ghp_`, `shpat_`, `shpss_`, etc.) and document in [docs/security/](../security/).
- [ ] Re-run `npm audit` after dependency changes; track in [docs/security/00_security_checklist.md](../security/00_security_checklist.md).

---

## 6. Summary

- **Rules and docs:** Aligned with env-credentials, shopify-preview-approval, AGENT_WORKFLOW_CURSOR_SHOPIFY, AGENT_AND_REPO_SECURITY, CURSOR_DATA_BOUNDARY, and 00_security_checklist.
- **Shopify:** No headless admin automation; API + user’s browser only; deprecation note in shopify-admin spec and JS.
- **Local-only:** `.env.local` only; nothing else required on desktop.
- **Hardening:** Optional items above; no critical gaps identified in this pass.
