# Against The Odds — Analytics & KPIs

## North-star metrics
Pick 1–2 “truth” metrics that define success, and review them weekly:

- **Revenue**: gross sales, net sales (after discounts/returns), and contribution margin (if you can compute it reliably).
- **Conversion rate**: sessions → purchases (use a consistent definition and time window).
- **AOV** (average order value): gross sales / orders.

For launch, keep it simple:
- **Primary**: Net sales and orders.
- **Secondary**: Conversion rate and AOV.

## Funnel metrics
Track the purchase funnel with clear definitions so it’s debuggable:

- **Sessions**: visits to storefront.
- **Product views**: sessions that view at least one product.
- **Add to cart**: sessions with at least one add-to-cart.
- **Checkout started**: sessions that begin checkout.
- **Purchase**: completed order.

Suggested derived KPIs:
- **Product view rate** = product views / sessions
- **ATC rate** = add to cart / product views
- **Checkout start rate** = checkout started / add to cart
- **Checkout completion rate** = purchases / checkout started

Operational use:
- If **sessions are high but ATC is low**: merchandising, pricing, trust, sizing/fit clarity, shipping clarity.
- If **checkout start is high but purchase is low**: shipping rates, payment options, discount logic, mobile issues.

## Retention metrics
Early-stage retention can be light, but still measurable:

- **Repeat purchase rate (30/60/90 days)**: customers with ≥2 purchases / customers.
- **Time to second purchase** (median).
- **Refund/return rate**: refunds or returns / orders (by product/SKU when possible).
- **Support contact rate**: support tickets / orders (proxy for product/ops friction).

If you don’t yet have enough repeat volume, start with:
- **Post-purchase NPS/CSAT** (simple 1-question survey) and qualitative feedback tags.

## Attribution plan (UTMs / creator codes)
Keep attribution tool-agnostic by standardizing **UTMs** and (optionally) **creator discount codes**.

### UTM conventions (required)
Use lowercase, hyphenated values. Maintain a small “allowed values” list.

- `utm_source`: platform or referrer (e.g., `instagram`, `tiktok`, `youtube`, `email`, `google`, `affiliate`)
- `utm_medium`: channel type (e.g., `organic`, `paid`, `influencer`, `cpc`, `newsletter`)
- `utm_campaign`: launch or promo name (e.g., `launch-2026-02`, `drop-hoodie-v1`)
- `utm_content`: creative identifier (e.g., `video-a`, `carousel-1`, `hook-3`)
- `utm_term`: optional (keywords or audience)

Example (pattern only; do not hardcode sensitive links here):
`?utm_source=instagram&utm_medium=influencer&utm_campaign=launch-2026-02&utm_content=video-a`

### Creator codes (optional but recommended)
Create a discount code per creator and keep a mapping table (not secrets, but keep it clean):
- **Code format**: `AO-<creator>-10` (example pattern)
- **Rules**: expiration date, usage limits, stackability policy.

Operational rule:
- If you use creator codes, require creators to use **both** the code and the UTM link whenever possible; UTMs power analytics, codes help reconcile attribution in edge cases.

## Event taxonomy (minimum viable)
You do not need a huge taxonomy to run a good launch. Track a small set of events with stable names and a few key properties.

### Required events (minimum)
- `page_view`
  - properties: `page_type` (home, collection, product, cart, checkout), `url`
- `product_view`
  - properties: `product_id`/`handle`, `variant_id` (if known)
- `add_to_cart`
  - properties: `product_id`/`handle`, `variant_id`, `quantity`, `price`
- `begin_checkout`
  - properties: `cart_value`, `items_count`
- `purchase`
  - properties: `order_id`, `revenue`, `currency`, `discount_total`, `shipping_total`, `tax_total`, `items_count`

### Nice-to-have (if easy)
- `view_collection` (collection handle)
- `remove_from_cart` (product/variant)
- `apply_discount` (code)
- `search` (query)
- `newsletter_signup`
- `support_contact` (channel, reason)

### Identity rules
- Use a **stable anonymous ID** per browser/device.
- If/when a customer is known, link to a **customer ID** (avoid storing raw emails in analytics events).

## Weekly review cadence
Run a lightweight weekly “growth + ops” review (30–45 minutes).

### Inputs (prep)
- Orders, net sales, refunds/returns
- Funnel rates (view → ATC → checkout → purchase)
- Top landing pages + top products
- Attribution summary (UTM campaign/source + creator code performance)
- Support tags volume (top 3 reasons)
- Site health (from `docs/MONITORING.md` and `scripts/monitoring/performance-check.ps1`)

### Agenda (repeatable)
1. **What changed vs last week** (numbers + why)
2. **Top bottleneck** (pick one funnel step to improve)
3. **Top ops issue** (pick one returns/support driver)
4. **Experiment plan** (1–2 changes only; define expected impact)
5. **Action items** (owner + due date; log in GitHub Issues)

### Definition of “good enough”
- Trends are explainable and tied to actions; no one is arguing about metric definitions.

## Dashboard checklist
Create (or validate) a dashboard that answers these questions without digging:

- **Sales**: gross sales, net sales, orders, AOV
- **Funnel**: sessions, product views, ATC, checkout started, purchases
- **Conversion**: overall + by device (mobile/desktop)
- **Attribution**: performance by `utm_source`, `utm_campaign`, and creator code (if used)
- **Merch**: top products by revenue + refund/return rate
- **Ops**: fulfillment time (if available), support contact rate, top support reasons
- **Quality**: site uptime and response time trends (tie to `docs/MONITORING.md`)

Operational guardrail:
- Write metric definitions directly in the dashboard description or adjacent doc so they don’t drift.

