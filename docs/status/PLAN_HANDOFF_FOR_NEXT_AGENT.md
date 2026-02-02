# Handoff for next plan (new agent chat)

**Date:** 2026-01-30 (updated 2026-02)
**Purpose:** Give the next plan agent (new Cursor chat using the "plan" feature) everything needed to create a **new** plan without redundancy, from fresh perspectives, considering all work done so far and future optimizations.

**New agent entry (2026-02):** Current agent branches and workflows are **finalized and closed**. For the **new agent** that will plan and finish remaining work, read **[HANDOFF_FOR_NEW_AGENT_202602.md](HANDOFF_FOR_NEW_AGENT_202602.md)** first — it is the single entry point for current state, what's complete, what's blocked, and what to plan and do.

**Plan runs:** For any plan chat (Security & Platform, Fresh Team, or next team), read [PLAN_AGENT_ENTRY.md](PLAN_AGENT_ENTRY.md) first if present — single entry, Expert Team binding rules, and comprehensive-pass questions.

---

## 1. What was done (do not redo)

- **Expert Team Security and Platform Plan** (consolidated; rules and workflow implemented) — see `.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md` and `.cursor/rules/`; created and fully implemented:
  - **Shopify:** No unattended headless automation of Shopify Admin (ToS). Theme via Cursor → GitHub → Shopify GitHub App; products via dry-run → approve in chat → sync (Admin API) or user's browser (Cursor browser MCP) with approval before save.
  - **Local-only:** Only `.env.local` at repo root is required on PC; nothing else from the repo must be stored elsewhere.
  - **Cursor data boundary:** Secrets only in `.env.local`; never in chat or logs; non-secret repo content may be sent to Cursor for AI. Documented in `docs/security/CURSOR_DATA_BOUNDARY.md`.
  - **Unified approval flow:** Single artifact `docs/status/pending-approval.md`; agent writes snapshot → user opens file (or runs task "Open pending approval") → user approves in chat → agent applies and clears pending-approval.
  - **Deliverables created:** CURSOR_DATA_BOUNDARY.md, SECURITY_COMPLIANCE_REPORT.md, LOCAL_PC_SPECS.md, Cursor task "Open pending approval", workflow/rule updates, browser-first/no-headless notes in docs, deprecation notes in `tests/e2e/shopify-admin.spec.js` and `src/browser-automation/shopify-admin.js`.
- **Prior work (do not redo):** Phase 0 sign-off; full system analysis; architecture/code-quality; workflow audit; test/coverage reports; coverage remediation plan; verification sign-off; MASTER_EXECUTION_REPORT.

---

## 2. Where to look (canonical sources)

| Topic                         | Location                                                                                                                         |
| ----------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| Canonical plan                | `.cursor/plans/FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md` (only plan file; open in Cursor and use Build)                         |
| Conversation and build record | `docs/status/CONVERSATION_AUDIT.md`                                                                                              |
| Security and compliance       | `docs/status/SECURITY_COMPLIANCE_REPORT.md`                                                                                      |
| Cursor data boundary          | `docs/security/CURSOR_DATA_BOUNDARY.md`                                                                                          |
| Pending approval flow         | `docs/status/pending-approval.md`, `docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md`, `.cursor/rules/shopify-preview-approval.mdc`         |
| Local PC / env                | `docs/status/LOCAL_PC_SPECS.md`, `docs/CREDENTIALS_SETUP.md`                                                                     |
| Other plans (reference)       | `.cursor/plans/` — single plan only: FINAL_REPO_ORGANIZATION_AND_AUDIT.plan.md (open in Cursor and use Build)                    |
| Root-level status docs        | Many (AUDIT_REPORT, BUG_FIXES, COMPLETION_REPORT, etc.) — legacy; canonical status lives in `docs/status/` and `.cursor/plans/`. |

---

## 3. What the next plan should do

- **Create the plan again as a new team of agents**, without redundancy, considering:
  - **All work done so far:** Prior Phase 0 / analysis, Expert Team plan and its implementation, verification, and this handoff.
  - **Current state:** Safe ops (Shopify ToS, browser-first, pending-approval flow, Cursor boundary) are in place; tests and docs are aligned.
  - **Future work:** e.g. raise coverage to 90%; E2E after `npx playwright install`; optional doc consolidation; further optimizations.
- **Fresh perspectives:** New agent roles or angles (e.g. performance, DX, cost, maintainability) that do not duplicate the guru roles already executed (GitHub, Shopify, Cursor, Local PC, Security).
- **Further optimizations:** Identify improvements that build on (and do not re-run) existing analysis and implementation.

---

## 4. Questions for a more comprehensive pass

The next plan agent may ask (or answer) as needed:

1. **Scope:** Should the new plan include code changes (e.g. refactors, new scripts) or only process/docs/agent-flow?
2. **Coverage and E2E:** Target coverage (e.g. 90%); whether E2E should run in CI after Playwright install; any new test scenarios.
3. **Docs:** Whether to consolidate root-level status/report files into `docs/status/` or an index; any new runbooks or checklists.
4. **Integrations:** GitHub Actions, Shopify GitHub App, or Cursor tasks — any new workflows or automation.
5. **Security and compliance:** Any new platforms or tools that need a data-boundary or ToS check (beyond what’s in SECURITY_COMPLIANCE_REPORT and CURSOR_DATA_BOUNDARY).
6. **Success criteria:** How the new plan’s success will be measured (e.g. checklist, verification report, user sign-off).

---

## 5. Summary

- **Done:** Expert Team Security and Platform Plan is implemented; safe ops, unified approval flow, and guru deliverables are in place.
- **Next:** In a new agent chat, use the "plan" feature to create a **new** plan — new team, no redundancy, fresh perspectives — that considers this handoff and all prior/current/future work for further optimizations.
- **Single entry for next agent:** Read this file first, then the Expert Team plan and CONVERSATION_AUDIT; ask any other questions needed for a comprehensive pass.
