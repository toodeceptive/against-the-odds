# Against The Odds — Business Plan

## Assumptions & Open Questions
- **Brand scope**: AO launches as a premium streetwear brand (not print-on-demand); initial focus is a flagship hoodie drop.
- **Pricing**: initial hoodie MSRP is anchored around the current product template (~$80); final pricing will be set after sample quality + landed COGS are confirmed.
- **Manufacturing**: first production partner not selected yet; plan assumes 3–5 suppliers will be sampled and scored before committing.
- **MOQ + lead time**: unknown until quotes arrive; plan assumes an 8–12 week window from “design locked” to “goods received” (samples + production).
- **Decoration method**: print vs embroidery vs mixed; impacts COGS, durability, and perceived premium—TBD based on samples.
- **Fulfillment model**: self-fulfill vs 3PL is undecided; affects working capital, speed, and CX.
- **Inventory approach**: initial drop will be either (a) small on-hand inventory or (b) pre-order window; decision depends on MOQ/cashflow and lead times.
- **Returns policy**: baseline returns/refunds approach TBD; must align with premium positioning while protecting margin.
- **Growth channels**: organic short-form + creators/affiliates are the primary bet; paid spend is optional and should be gated by CAC payback evidence.
- **Measurement**: analytics stack, attribution, and KPI cadence must be finalized before launch to avoid “flying blind.”
- **Team capacity**: assume a small founding team covering creative, ops, and engineering; responsibilities and weekly cadence need to be explicitly assigned.
- **Security hygiene**: ensure no credentials are ever committed; tighten docs and workflows where they risk encouraging secrets-in-repo.

## Mission + Brand Story
AO exists to represent the person who keeps building when the odds say they shouldn’t.

The brand story is a content engine, not just marketing copy: every product drop is tied to a narrative arc (training, comeback, rebuilding, discipline). The goal is to earn repeat customers through **identity + quality**, not discounts.

**Mission**: build a premium streetwear brand that customers wear as a signal of resilience and ambition—delivered with serious operational execution.

## Customer & Problem
### Target customer (initial)
- **18–34**, streetwear-aware, social-first, brand-story receptive.
- Adjacent audiences: fitness/gym culture, creator communities, entrepreneurs, and “comeback story” fans.

### The problem
- Most motivational apparel is **low-trust**: inconsistent blanks, weak print durability, generic designs, and shallow storytelling.
- Even when the story is strong, many merch launches fail operationally: poor sizing/fit consistency, slow fulfillment, no structured iteration cycle.

### What the customer is really buying
- A premium, durable staple that fits the streetwear standard.
- A brand they can identify with and share.
- Confidence that the drop will arrive as promised and match the photos.

## Product & Offer
### Product strategy
- **Start narrow**: one flagship product done extremely well (hoodie), minimal color/size complexity.
- **Build repeatability**: launch cadence driven by a drop playbook (creative → catalog → manufacturing → fulfillment → iteration).
- **Expand only after proof**: new SKUs (tees, hats, outerwear) only after quality, CAC, and ops reliability are validated.

### What we ship (repo-aligned)
- **Shopify DTC storefront**: `aodrop.com` is the commerce surface area.
- **Product-as-data**: product definitions live in `data/products/*.json` and can be imported/exported to Shopify using PowerShell scripts (auditability + repeatability).
- **Operational runbooks**: manufacturing and launch readiness are documented and executable (sample tracking, evaluation, scripts, checklists).

### Offer structure (initial)
- Flagship hoodie at premium price point (final MSRP TBD based on landed costs and brand positioning).
- Limited drop, scarcity by design (inventory controlled).
- Email/SMS capture as part of the drop funnel; post-purchase flow designed for repeat buying.

## Positioning & Differentiation
### Positioning statement (working)
**Premium streetwear for people building through adversity**—designed to last, delivered with operational rigor.

### Differentiation (what’s defensible early)
- **System advantage**: AO treats product + ops like software:
  - Source-controlled catalog (JSON) → consistent product setup, faster iteration, fewer store mistakes.
  - Documented manufacturing workflow → fewer “first drop” failures.
- **Narrative advantage**: “Against The Odds” naturally maps to high-volume content themes (training arcs, comeback stories, behind-the-scenes).
- **Quality as the brand**: premium feel, fit, and durability are the retention lever; marketing is the accelerant, not the foundation.

## Market & Competition
AO competes in the premium streetwear and creator-adjacent apparel space where attention is abundant but trust is scarce.

### Competitive set (high-level)
- **Creator merch**: often wins on distribution but loses on product quality and repeatability.
- **Streetwear incumbents**: strong brand equity; harder to beat on status, but many are not built on a fresh, culturally resonant narrative.
- **Print-on-demand brands**: low operational overhead but typically weaker quality control and brand differentiation.

### Wedge
AO’s initial wedge is **high-conviction storytelling + high-trust execution**:
- Quality + consistency creates retention.
- Systems reduce operational mistakes and accelerate iteration.
- Story and creator channels drive efficient top-of-funnel.

## Go-to-Market Overview
### GTM principles
- **Prove demand before scaling spend**: organic + creators first; paid only when CAC payback is demonstrably healthy.
- **Turn operations into content**: samples, quality tests, design decisions, and drop prep are the marketing.
- **Capture and re-market**: email/SMS is mandatory pre-launch; most brands leak demand without it.

### Primary channels (launch)
- **Short-form organic**: TikTok/IG Reels/YouTube Shorts (daily/near-daily cadence around story + BTS).
- **Creators/affiliates**: micro-creators with aligned narratives; track performance via codes/UTMs; pay on results early.
- **Owned**: email/SMS list build with drop countdown and early access.

### Shopify execution (repo reality)
- Store runs on Shopify (`aodrop.com`), with theme development supported via Shopify CLI workflows.
- Catalog operations are designed around local JSON artifacts and scripted sync to reduce manual admin work and increase repeatability.

## Operations Overview
### Operating system (what exists today)
- **Product catalog**: JSON product definitions in `data/products/` (variants, options, status, etc.).
- **Shopify sync**: PowerShell scripts to import/export/sync products, enabling a version-controlled catalog and repeatable drop setup.
- **Manufacturing workflow**: documented stages (design → manufacturer research → samples → evaluation → selection → production).
- **Sample tracking**: sample requests and evaluations are recorded in `data/samples/samples.json` via `scripts/manufacturing/track-samples.ps1`.

### Manufacturing plan (initial)
- Request samples from **3–5 manufacturers**.
- Score samples on quality, price, delivery responsiveness, and brand alignment.
- Select one primary production partner; keep a second source warm as risk mitigation.

### Quality control
- Define a simple QC checklist per SKU (stitching, print durability, sizing tolerance, wash test).
- Reject/redo standards must be agreed with the manufacturer pre-production (especially for premium positioning).

### Fulfillment + returns (decision pending)
- Short-term: self-fulfill is viable for small drops; 3PL becomes attractive as volume rises.
- Returns policy must balance trust (premium brand) and unit economics; operationally plan for a lightweight process (RMA intake, inspection, restock/disposition).

### Customer support
- Pre-build macros and an FAQ aligned to the most likely friction points: sizing, shipping timelines, returns, drop timing.

## Team & Roles
AO can start lean, but roles must be explicit to avoid gaps.

- **Founder / GM**: brand direction, drop calendar, financial decisions, partnerships.
- **Creative lead**: design, photography/mockups, content creative, brand voice.
- **Ops lead**: manufacturer pipeline, samples, QC standards, production and fulfillment readiness.
- **Engineering / Shopify ops**: theme and store setup, product JSON workflow, scripted sync, measurement instrumentation.

Near-term hires/contractors (as volume demands):
- Part-time **content editor** (short-form throughput), **photographer**, and **fulfillment help** (pick/pack days).

## Risks & Mitigations (summary)
| Risk | Why it matters | Mitigation (practical) |
|---|---|---|
| **Supplier quality variance** | Kills retention and brand trust | Sample 3–5 suppliers; scorecards; QC checklist; small first PO |
| **MOQ / working capital pressure** | Inventory ties up cash | Keep SKU narrow; negotiate MOQs; consider pre-order; stage POs |
| **Delivery delays** | Missed drop windows | Buffer timelines; set honest ship expectations; second-source backup |
| **Low conversion on first drop** | Demand risk | Lean into organic + creators; strengthen PDP; list capture + retarget |
| **Over-reliance on one channel** | Volatility | Diversify: organic + creators + owned + selective paid |
| **Operational mistakes (Shopify/catalog)** | Breaks launch | Use JSON-as-source; scripted sync; pre-launch checklist and dry runs |
| **Security/process hygiene** | Credential leaks are existential | Keep secrets out of repo; enforce `.env.local` hygiene; rotate if exposure occurs |

## 30 / 60 / 90 Day Plan
### Next 30 days (foundation + proof)
- Lock brand direction for Drop 01 (creative, story angle, design variants).
- Build manufacturer shortlist and request samples; track everything in `data/samples/`.
- Define hoodie spec (blank weight/fit target, decoration method candidates).
- Set up pre-launch list capture on Shopify (simple landing/PDP draft, email/SMS capture, early access plan).

### 60 days (commit + build)
- Evaluate samples; pick manufacturer; confirm MOQ, lead time, landed cost, and QC standards.
- Finalize product JSON and Shopify listings; stage as draft products; verify sync workflow.
- Produce content backlog: BTS samples, fit checks, durability tests, story pieces.
- Define fulfillment + returns process (self vs 3PL) and write the operational checklist.

### 90 days (launch + iterate)
- Place first production order and finalize launch calendar.
- Launch Drop 01 with creators + list + organic push.
- Weekly KPI review (traffic → CVR → AOV → refund/return rate → margin).
- Capture customer feedback (fit, fabric, delivery) and feed into Drop 02 improvements.

