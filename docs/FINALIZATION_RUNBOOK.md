# Against The Odds — Finalization Runbook (Project + Business Plan)

**Purpose**: Provide a single, step-by-step playbook to finalize the Against The Odds project _and_ produce an investor/customer-ready business plan.

This runbook assumes you will use the new **Finalization Team** prompts in `prompts/` and keep outputs in `docs/business-plan/` and `docs/launch/`.

---

## Definition of Done (DoD)

### Business plan package (required)

- **Exec summary**: 1–2 pages
- **Narrative plan**: problem → customer → positioning → product → ops → GTM → risks
- **Financial model**: unit economics + 12-month forecast + inventory assumptions
- **Go-to-market plan**: launch timeline + channel plan + KPIs + content calendar
- **Operations plan**: manufacturing + QC + fulfillment + returns + customer support
- **Legal pack (draft)**: ToS, Privacy Policy, Refund/Returns, Shipping policy + risk register

### Tech / launch readiness (required)

- **Credentials setup complete**: `.env.local` configured (never committed)
- **Integrations verified**:
  - Shopify connection test passes: `scripts/shopify/test-connection.ps1`
  - GitHub auth/secrets verified (as applicable): `scripts/github/*`
- **Quality gates green**:
  - `npm run lint`
  - `npm run test:all`
  - `npm run format:check` (optional but recommended)
- **Operational check**:
  - `scripts/health/comprehensive-check.ps1`
  - `scripts/quality/check-all.ps1`

### Store ops / security / measurement (required)

- **Shopify store ops documented**: theme workflow, product readiness, rollback plan
- **Release + environments documented**: branches, CI, Shopify themes, rollback
- **Analytics plan exists**: KPIs + UTM/creator tracking + review cadence
- **Security checklist complete**: secrets hygiene + rotation plan + incident steps

---

## Output Locations (single source of truth)

Create/maintain these files (agents will be instructed to write here):

- `docs/business-plan/00_exec_summary.md`
- `docs/business-plan/01_business_plan.md`
- `docs/business-plan/02_financial_model.md`
- `docs/business-plan/03_gtm_plan.md`
- `docs/business-plan/04_ops_plan.md`
- `docs/business-plan/05_legal_pack.md`
- `docs/launch/00_launch_checklist.md`
- `docs/launch/01_store_readiness.md`
- `docs/launch/02_release_and_environments.md`
- `docs/launch/03_shopify_store_ops.md`
- `docs/launch/04_analytics_and_kpis.md`
- `docs/launch/05_content_and_assets.md`
- `docs/launch/06_customer_support_ops.md`
- `docs/security/00_security_checklist.md`

---

## Recommended Agent Team (run in parallel)

Use separate Cursor instances (or separate chat contexts) with these prompts:

- **Chief of Staff / Orchestrator**: `prompts/finalization-chief-of-staff.md`
- **Business Plan Lead**: `prompts/finalization-business-plan-lead.md`
- **Finance Modeler**: `prompts/finalization-finance-modeler.md`
- **GTM / Growth Lead**: `prompts/finalization-gtm-growth-lead.md`
- **Ops / Manufacturing Lead**: `prompts/finalization-ops-manufacturing-lead.md`
- **Legal / Risk Lead**: `prompts/finalization-legal-risk-lead.md`
- **Tech Release Manager**: `prompts/finalization-tech-release-manager.md`
- **Release / Branch / Environments Lead**: `prompts/finalization-release-branch-manager.md`
- **Shopify Store Ops / Theme Release Lead**: `prompts/finalization-shopify-store-ops.md`
- **Security / Compliance Lead**: `prompts/finalization-security-compliance.md`
- **Analytics / Instrumentation Lead**: `prompts/finalization-analytics-instrumentation.md`
- **Content / Creative Lead**: `prompts/finalization-content-creative.md`
- **Customer Support / Community Lead**: `prompts/finalization-customer-support-community.md`

Always provide these context files to every agent:

- `README.md`
- `docs/status/INDEX_REPORTS.md`
- `NEXT_STEPS.md`
- `docs/MANUFACTURING.md`
- `docs/PROJECT_MANAGEMENT.md`

---

## Execution Phases

### Phase A — Stabilize the repo (Tech Release Manager)

Goal: everything reproducible and “green” locally.

Deliverables:

- `docs/launch/01_store_readiness.md` (status + gaps + commands used)
- A short punch-list of remaining technical blockers (if any)

### Phase B — Build the business plan backbone (Business Plan Lead + Finance)

Goal: produce a coherent, consistent narrative + numbers.

Deliverables:

- `docs/business-plan/00_exec_summary.md`
- `docs/business-plan/01_business_plan.md`
- `docs/business-plan/02_financial_model.md`

### Phase C — GTM + Ops + Legal (parallel specialists)

Goal: make the plan executable and defensible.

Deliverables:

- `docs/business-plan/03_gtm_plan.md`
- `docs/business-plan/04_ops_plan.md`
- `docs/business-plan/05_legal_pack.md`
- `docs/launch/00_launch_checklist.md`

### Phase D — Orchestrator synthesis

Goal: ensure consistency across docs, assumptions, and timelines.

Deliverables:

- One “final pass” update to all plan docs to remove contradictions
- A single-page “Top Risks & Mitigations” section inside `05_legal_pack.md`

---

## Acceptance Checks (quick)

Before calling it “finalized”, confirm:

- Business plan docs exist in the locations above and agree on:
  - target customer
  - pricing and margin assumptions
  - timeline (samples → production → launch)
  - channel mix and KPI definitions
- Technical checks pass as listed in DoD
- No secrets are committed (especially `.env.local`)
