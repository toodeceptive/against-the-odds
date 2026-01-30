# Against The Odds — Launch Checklist

## Pre-launch
### Store foundation (Shopify)
- [ ] **Domain + brand basics**: `aodrop.com` connected, SSL active, favicon/logo uploaded, brand colors/typography consistent.
- [ ] **Theme readiness**: theme set, mobile checked, speed passable, backups/rollback plan documented (duplicate theme before launch).
- [ ] **Navigation**: header + footer menus include Shop/Collections, About, FAQ, Contact, Shipping, Returns, Privacy, Terms.
- [ ] **Primary pages live**:
  - [ ] Home (clear value prop + hero product + email capture)
  - [ ] Collection page(s) (Drop 1)
  - [ ] Product page template (high-trust layout)
  - [ ] About (brand story + why AO exists)
  - [ ] FAQ (sizing, shipping times, returns, restock policy)
  - [ ] Contact (email + expected response time)
  - [ ] Size guide (specific measurements; link from PDP)

### Product + merchandising
- [ ] **SKUs complete**: variants (size/color), pricing, cost (COGS) entered, inventory counts correct.
- [ ] **Media**: at least 6–10 images per hero product (front/back/detail/fit) + 1 short PDP video if possible.
- [ ] **Copy**: benefits + specs (fabric weight, fit notes, care instructions), shipping/returns summary on PDP.
- [ ] **Policies on PDP**: returns window, shipping time estimate, restock policy (explicit).
- [ ] **Collections**: featured collection set on home; tags set for filtering (optional).

### Policies (drafts are fine but must be present + accurate)
- [ ] **Refund/Returns policy** published and matches ops reality.
- [ ] **Shipping policy** published (processing time, carrier, zones, tracking, lost packages).
- [ ] **Privacy policy** published.
- [ ] **Terms of service** published.
- [ ] **Accessibility statement** (recommended) published or included in footer.

### Checkout, payments, tax, shipping
- [ ] **Payments**: primary gateway enabled (Shopify Payments / PayPal / etc.), payouts verified.
- [ ] **Test orders**: at least 2 successful test checkouts (card + alternative method if offered).
- [ ] **Taxes**: configured for target regions; edge cases reviewed.
- [ ] **Shipping rates**: standard + expedited configured; rates make sense vs margins.
- [ ] **Order notifications**: staff email, confirmation, shipping confirmation templates reviewed.
- [ ] **Fraud settings**: review thresholds set; manual review process defined.

### Email + lifecycle (Shopify Email or Klaviyo)
- [ ] **List capture**: waitlist/launch signup form connected; incentive text accurate.
- [ ] **Flows live (minimum)**:
  - [ ] Welcome series (3)
  - [ ] Abandoned cart (3)
  - [ ] Browse abandonment (2) (optional but recommended)
  - [ ] Post-purchase (3)
- [ ] **Campaign templates**: launch email template + “low stock” + “last call” ready.
- [ ] **Deliverability basics**: sender domain configured (SPF/DKIM where applicable), from-name consistent.

### Analytics, attribution, and monitoring
- [ ] **UTM standard** documented and used everywhere (email links, creator links, bio link).
- [ ] **Creator tracking**:
  - [ ] unique discount codes created per creator (e.g., `AO_MAYA`)
  - [ ] link template prepared: `utm_source=creator&utm_medium=ig_reel&utm_campaign=drop1&utm_content=<handle>`
- [ ] **GA4** installed (or Shopify analytics baseline verified).
- [ ] **Pixels (optional)**: Meta + TikTok installed if planning retargeting later (not required for launch).
- [ ] **Monitoring routine defined** (who checks what, when):
  - [ ] Shopify live view + conversion funnel
  - [ ] Checkout errors / abandoned checkout spike
  - [ ] Order notification health
  - [ ] Site uptime / theme issues (mobile especially)

### Ops readiness
- [ ] **Inventory plan**: packaging, labels, inserts, and stock counts verified.
- [ ] **Fulfillment SOP**: pick/pack steps, label purchase, tracking upload process.
- [ ] **Returns SOP**: intake, inspection, restock vs defect handling.
- [ ] **Customer support**: canned responses for shipping, sizing, returns, damaged items.

### Internal quality gates (repo)
- [ ] Run: `npm run lint`
- [ ] Run: `npm run test:all`
- [ ] Optional: `.\scripts\health\comprehensive-check.ps1`

## Launch day
### Before going live (T-120m to T-30m)
- [ ] **Confirm inventory** in Shopify matches physical counts.
- [ ] **Disable password / open storefront** (if previously gated).
- [ ] **Final PDP check**: pricing, variants, shipping/returns summary, size guide link.
- [ ] **Warm email deliverability**: send a test email to 3–5 inboxes (Gmail/Outlook).
- [ ] **Creator posting schedule** confirmed; assets approved; links/codes re-checked.

### Go-live (T=0)
- [ ] **Email #1**: “Drop is live” sent to list (with UTMs).
- [ ] **Organic post**: hero product + story hook + CTA to shop.
- [ ] **Stories**: FAQ sticker, sizing reminder, shipping expectations, “limited drop” (only if true).
- [ ] **Monitor** (first 60 minutes):
  - [ ] live sessions, add-to-cart rate, checkout start rate
  - [ ] checkout errors / payment failures
  - [ ] orders coming through + confirmation emails delivered

### First 6 hours
- [ ] **Pin FAQ** to stories/highlights.
- [ ] **Customer support triage**: respond to sizing/shipping questions quickly.
- [ ] **Creator wave 1** reposts (with permission).

## First 2 weeks post-launch
### Week 1 (stabilize + learn)
- [ ] **Daily KPI snapshot**: sessions, CVR, AOV, revenue, top sources, top pages.
- [ ] **Abandoned checkout review**: identify blockers (shipping cost, payment methods, errors).
- [ ] **Post-purchase flow**: ensure shipping confirmations + tracking sending correctly.
- [ ] **UGC + reviews**: request UGC, start review collection 7–10 days post-delivery.
- [ ] **Creator performance review**: rank by clicks/orders; double down on top 20%.
- [ ] **Customer interviews**: 5–10 short calls/messages (why bought, hesitations, improvements).

### Week 2 (iterate + prep next push)
- [ ] **Site iteration**: update PDP copy/FAQs based on real questions.
- [ ] **Inventory decision**: restock vs close drop (based on sell-through + margins).
- [ ] **Email cadence**: 1 campaign/week + ongoing flows; segment by purchasers vs waitlist.
- [ ] **Content**: publish “packing orders / community” story; showcase customer photos.
- [ ] **Post-mortem**: what worked / didn’t; finalize learnings in `docs/launch/04_analytics_and_kpis.md` (if used as KPI source of truth).

