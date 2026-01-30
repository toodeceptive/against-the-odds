# Against The Odds — Operations Plan

## Assumptions (explicit)

- **Sales channel**: Shopify is the system of record for storefront, products, orders, and customers.
- **Product scope (initial)**: A small, curated set of apparel/accessories (e.g., hoodies/hats) with limited SKUs to control complexity.
- **Manufacturing model**: Cut-and-sew or blank + decoration via a third‑party manufacturer (not print-on-demand by default), with samples evaluated before any production PO.
- **Fulfillment stage**: Start with a lightweight fulfillment approach (self‑fulfill or small 3PL), with a planned path to scale; no bespoke warehouse software assumed.
- **Tooling alignment**: Operational data lives in repo-friendly formats where practical (e.g., `data/*` JSON), and sync scripts are used to keep Shopify and local product data consistent.

## Supply chain overview

### End-to-end flow

1. **Design & specs**
   - Produce final design files and print/embroider specs (colors, placement, sizes).
   - Maintain source assets and production-ready exports in the repo (or a controlled asset store) with a clear versioning convention.

2. **Manufacturer research & qualification**
   - Track manufacturer profiles in `data/manufacturers/` using a consistent template.
   - Qualify against MOQ, lead time, capability (fabric, blanks, decoration), certifications, and communication responsiveness.

3. **Sampling loop (required before production)**
   - Request samples from 3–5 candidates.
   - Track each sample request/delivery/evaluation using `scripts/manufacturing/track-samples.ps1` and the underlying `data/samples/samples.json` record.
   - Decision output: “recommended” manufacturer(s) and a locked spec for production.

4. **Production order + logistics**
   - Place a production order (PO) with selected manufacturer including quantities per size/color, packaging requirements, labeling, and QC expectations.
   - Arrange inbound freight to the chosen fulfillment node (home/office, micro-warehouse, or 3PL).

5. **Inbound receiving**
   - Receive goods, run receiving QC (see QC gates), and reconcile against PO (qty, variants, defects).
   - Update Shopify inventory once receiving QC passes.

### System-of-record and repo alignment

- **Manufacturer data**: `data/manufacturers/` (research + decision artifacts).
- **Sample tracking**: `data/samples/samples.json` managed by `scripts/manufacturing/track-samples.ps1`.
- **Product definitions**: `data/products/` JSON files.
- **Shopify sync**: `scripts/products/sync.ps1` (delegates to Shopify sync/export scripts) is the standard mechanism to keep product data aligned.

## Production plan

### Production stages (from “idea” to sellable inventory)

1. **Pre-production lock**
   - Lock the “production spec” after sample evaluation: materials, fit, measurements, decoration method, color matching, labels/hangtags, packaging, and carton packout.
   - Create a short “spec sheet” per SKU/collection; store alongside product JSON (or referenced from it).

2. **Pilot run (optional but recommended for first drop)**
   - If budget allows, do a small pilot run (or partial shipment) to validate repeatability vs. sample quality.

3. **Production run**
   - PO includes:
     - Size/color breakdown (by SKU)
     - Target ship date + incoterms (if applicable)
     - Tolerances (measurements, color variance)
     - Defect definitions and acceptable quality level (AQL) expectation
     - Packaging + labeling requirements (barcode/SKU labels if used)

4. **Inbound receiving + put-away**
   - Receive, inspect, quarantine defects, and put away by SKU/bin.
   - Only after receiving QC passes, publish/adjust Shopify inventory.

### QC gates (quality control)

**Gate 0 — Manufacturer qualification (before samples)**
- Verify capability, references, and ability to meet required QC standards.

**Gate 1 — Sample evaluation (must-pass)**
- Use `track-samples.ps1` “evaluate” to record:
  - Quality score, price score, delivery score, and a clear recommended/not‑recommended decision.
- Pass criteria (example):
  - Decoration durability acceptable (wash test / abrasion check as relevant)
  - Fit and measurements within tolerance
  - Color matching within acceptable variance
  - Stitching/construction consistent and clean

**Gate 2 — Pre-production confirmation**
- Manufacturer confirms:
  - Approved artwork files + placement
  - Material/fabric lot and trims
  - Size spec / measurement tolerances
  - Packaging, labeling, carton packout

**Gate 3 — In-process check (during production)**
- Manufacturer provides photo/video evidence or inspection report at ~20–30% completion for:
  - Print/embroidery alignment
  - Stitching quality
  - Label placement and correctness

**Gate 4 — Final inspection (pre-ship)**
- Confirm:
  - Quantity by SKU
  - Defect rate vs agreed threshold
  - Packaging/cartons intact and correctly labeled
  - Random measurement checks on a defined sample size

**Gate 5 — Receiving QC (upon arrival)**
- Reconcile PO vs received (counts and variants).
- Spot-check:
  - Damage in transit
  - Defects not caught upstream
  - Label/SKU consistency to prevent fulfillment errors
- Outcomes:
  - **Accept** (inventory publish)
  - **Quarantine** (hold subset for resolution)
  - **Reject/claim** (if materially nonconforming)

## Fulfillment plan

### Fulfillment options (choose per phase)

**Option A — Self-fulfillment (launch / low volume)**
- Best when: low SKU count, manageable daily order volume, desire for tight brand control.
- Process:
  - Pick/pack from small storage.
  - Purchase labels via Shopify shipping tools or integrated carrier service.
  - Daily drop-off or pickup schedule.
- Controls:
  - Packing checklist and scan/verify SKU before sealing.
  - Standard pack-out (tissue, sticker, insert) to reduce variability.

**Option B — 3PL (scale / higher volume)**
- Best when: growing order volume, need faster shipping zones, need operational leverage.
- Requirements to enable:
  - Clean SKU catalog and barcode/label conventions.
  - Inbound receiving documentation (ASN-like detail from manufacturer).
  - Agreed SLAs (same-day/next-day ship, cutoffs, return handling).

**Option C — Print-on-demand (POD) for selected items**
- Best when: testing new designs without inventory risk.
- Tradeoffs:
  - Higher COGS, less control over quality/packaging, brand experience constraints.

### Shopify + repo workflow alignment (ops)

- **Product setup**:
  - Maintain canonical product JSON in `data/products/`.
  - Use `scripts/products/sync.ps1 -Direction import` to publish or update products in Shopify when ready.
- **Ongoing reconciliation**:
  - Use `scripts/products/sync.ps1 -Direction export` to pull Shopify state back locally for audits and change tracking.
- **Inventory changes**:
  - Update inventory only after Gate 5 receiving QC passes; keep “in transit / quarantined” stock off-sale to avoid oversells.

## Returns & support

### Customer support model

- **Primary support channel**: Shopify contact form / support email inbox (single queue).
- **Triage categories**:
  - Order status/shipping
  - Wrong item/size
  - Damaged/defective
  - Return/exchange request
  - Chargeback/fraud escalation
- **Response targets (initial)**:
  - First response within 1–2 business days
  - Resolution within 3–5 business days (dependent on carrier/stock)

### Returns policy (operationally implementable)

- **Return window**: Explicitly define (e.g., 14–30 days from delivery) in store policy pages.
- **Eligibility**:
  - Unworn/unused, tags attached (where applicable)
  - Defective/damaged items eligible for replacement/refund regardless of window (reasonable exceptions)
- **Return flow**:
  1. Customer submits request with order number + reason + photos (if damaged/defective).
  2. Support approves and issues instructions/label (where offered) or customer ships back.
  3. Upon receipt, inspect (post-return QC) and decide: restock / refurbish / dispose.
  4. Trigger refund/exchange in Shopify and notify customer.

### Post-return QC (protect the brand)

- Verify:
  - Hygiene/condition
  - Stains/odor
  - Decoration integrity
  - Correct SKU/variant returned
- Restock only if it meets “sellable” criteria; otherwise mark as non-sellable and track loss reasons for supplier feedback.

## Operating cadence (weekly ops dashboard)

### Weekly cadence (repeatable rhythm)

- **Monday — Inventory + backlog review**
  - Review inventory health per SKU: on-hand, quarantined, in-transit, projected sell-through.
  - Review open customer tickets and aging (carryovers from prior week).
  - Decide reorder triggers and whether to pause ads/traffic if stock is constrained.

- **Tuesday — Production & supplier follow-ups**
  - Check sample/production timelines, especially for any “in transit” or “awaiting confirmation” states.
  - Update sample statuses and evaluations via `scripts/manufacturing/track-samples.ps1`.
  - Log supplier risks (delays, material substitutions) and mitigation actions.

- **Wednesday — Catalog & storefront integrity**
  - Run a product data check:
    - If local is source-of-truth: `scripts/products/sync.ps1 -Direction import -DryRun` (when supported downstream) to preview changes.
    - Export current Shopify product state for audit: `scripts/products/sync.ps1 -Direction export`.
  - Validate product pages: pricing, variants, imagery, shipping/returns messaging.

- **Thursday — Fulfillment + shipping performance**
  - Review fulfillment SLAs: ship time, delivery exceptions, carrier claims.
  - Audit pick/pack accuracy (wrong item/size rate).
  - Adjust packing SOP if repeat issues appear.

- **Friday — Metrics + next-week plan**
  - Review the “ops dashboard” metrics and set next week’s priorities.
  - Decide: reorder/PO timing, QC focus areas, catalog updates, and fulfillment adjustments.

### Ops dashboard (track weekly)

- **Demand & revenue signals**: orders/week, gross sales, top SKUs, conversion rate (high-level).
- **Inventory**: days-of-cover per SKU, stockouts, oversell incidents.
- **Quality**: defect rate (receiving QC), return rate by SKU, top defect reasons.
- **Fulfillment**: avg ship time, delivery exception rate, wrong-item rate.
- **Support**: ticket volume, first response time, resolution time, CSAT proxy (if available).

## Risks & mitigations

### Key operational risks

- **Supplier delays / missed ship dates**
  - *Mitigations*: dual-source (at least 2 qualified manufacturers), maintain a buffer timeline, stage production (pilot then full), keep launch dates flexible.

- **Quality drift from sample to production**
  - *Mitigations*: Gate 2 pre-production lock, Gate 3 in-process evidence, Gate 4 final inspection; specify tolerances and defect definitions in PO.

- **Inventory stockouts or oversells**
  - *Mitigations*: conservative initial buy, receiving QC before publishing inventory, reorder points based on sell-through, keep “quarantine/in-transit” off-sale.

- **Fulfillment errors (wrong item/size)**
  - *Mitigations*: SKU conventions, bin locations, pick/pack checklist, scan/verify step before shipment, periodic accuracy audits.

- **High return rate / unclear sizing**
  - *Mitigations*: publish detailed size charts and fit notes, collect feedback, adjust patterns/specs and/or product copy, tighten QC on measurements.

- **Carrier disruptions / delivery exceptions**
  - *Mitigations*: offer multiple carriers, proactive tracking monitoring, clear customer comms cadence, fast replacement policy for confirmed lost packages (as financially feasible).

- **Cashflow pressure from MOQs and prepayments**
  - *Mitigations*: negotiate payment terms, start with smaller SKU set, phased production, use preorder/waitlist (if aligned to brand) while protecting customer trust.

- **Tooling/script drift (paths, API versions, process mismatch)**
  - *Mitigations*: keep scripts documented and parameterized, run regular “ops checks” (weekly cadence), avoid hardcoding local paths in long-lived automation, pin/track API versions and update intentionally.

