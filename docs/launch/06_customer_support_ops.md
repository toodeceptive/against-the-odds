# Against The Odds — Customer Support Ops

## Support channels + SLAs

Keep support simple at launch: one primary channel, one backup channel, and clear response targets.

### Channels (recommended)

- **Primary**: Email support (support inbox)
- **Secondary**: Contact form on site that routes to the same inbox
- **Optional**: Social DMs for intake only (reply with “please email support” template so you don’t lose threads)

### Hours + SLAs

Define your operating window and publish it in your support auto-reply.

- **Hours**: business days (set your local timezone)
- **First response time target**:
  - 0–24 hours during business days
  - 24–48 hours on weekends/holidays
- **Resolution targets** (guidelines):
  - Simple status/order questions: same day
  - Address changes/cancellations: within 2 hours when possible (time-sensitive)
  - Refunds/returns: 1–2 business days (depends on policy and carrier scan)

### “Time-sensitive” rules

- **Address changes**: only before label purchase / carrier pickup.
- **Cancellations**: only before fulfillment begins.
- Use a pinned internal note: “When in doubt, pause fulfillment and ask ops.”

## Ticket taxonomy

Use a small taxonomy that maps directly to store operations and product quality. This makes weekly review and fixes possible.

### Primary categories

- **Order status**: where is my order?
- **Address change**: update address / delivery instructions
- **Cancellation**: request cancel
- **Returns/exchanges**: eligibility, labels, timelines
- **Refunds**: refund status, partial refunds
- **Product questions**: sizing, materials, care, restock
- **Discounts/promos**: code not working, stacking, eligibility
- **Shipping issues**: lost/delayed, damaged in transit
- **Quality issue**: defective item (print, stitching, sizing variance)
- **Website/checkout**: payment failure, cart issues, page bugs

### Required tags/fields (minimum)

- **Order number** (if applicable)
- **Customer email**
- **Product/SKU + size** (if applicable)
- **Issue severity**: low/medium/high
- **Outcome**: resolved, refund issued, replacement sent, escalated

Operational note:

- Map “Website/checkout” issues to a GitHub issue with repro steps and device/browser details.

## Macros

Macros should be short, empathetic, and policy-aligned (see `docs/launch/03_shopify_store_ops.md` for policy requirements). Keep placeholders in brackets so agents don’t forget to fill them.

### 1) Order status

Subject: Update on your order [ORDER_NUMBER]

Body:
Hi [NAME] — thanks for reaching out.

I’m checking on order [ORDER_NUMBER]. Current status: [STATUS].  
If you have a tracking link, it’s here: [TRACKING_LINK].

If anything changes or the carrier misses the estimate, reply here and we’ll help.

— AO Support

### 2) Address change (time-sensitive)

Subject: Address update for [ORDER_NUMBER]

Body:
Hi [NAME] — we can help with that.

Please confirm the full updated address (including unit number):  
[NEW_ADDRESS]

If the order hasn’t entered fulfillment yet, we’ll update it and confirm. If it has, we’ll share next steps (carrier intercept / return-to-sender options).

— AO Support

### 3) Return request

Subject: Return request for [ORDER_NUMBER]

Body:
Hi [NAME] — thanks for reaching out.

To start a return, please confirm:

- Item(s) and size(s): [ITEMS]
- Condition: [NEW/UNWORN?]
- Reason for return: [REASON]

If the request is within our returns window and meets policy conditions, we’ll send the next steps.

— AO Support

### 4) Damaged/defective item

Subject: We’ll make this right — [ORDER_NUMBER]

Body:
Hi [NAME] — sorry about that. We’ll make it right.

Please reply with:

- A photo of the issue
- A photo of the shipping label (or order number)
- A quick description of what happened

Once we have that, we’ll confirm whether we’re sending a replacement, refund, or other resolution.

— AO Support

### 5) Discount code not working

Subject: Discount code help

Body:
Hi [NAME] — happy to help.

Please share:

- The code you tried: [CODE]
- What’s in your cart: [ITEMS]
- Screenshot of the error (if possible)

We’ll confirm eligibility and get you a working option.

— AO Support

## Escalation policy

Escalate quickly when risk is high (chargebacks, privacy, safety, or systemic checkout failure).

### Severity levels

- **P0 (critical)**: checkout broken, widespread payment failures, potential data exposure, account compromise
  - Action: escalate immediately; pause promotions; consider pausing sales if customers can’t reliably purchase.
- **P1 (high)**: carrier outage causing many delays, batch of defective items, high refund spikes
  - Action: escalate same day; update customer messaging and store banners.
- **P2 (normal)**: single-order issues, routine returns

### Escalation destinations (tool-agnostic)

- **Store ops owner**: anything touching refunds, fulfillment, inventory, policies
- **Tech owner**: website/checkout bugs, theme issues (see `scripts/shopify/update-theme.ps1` and rollback steps in `docs/launch/03_shopify_store_ops.md`)
- **Security owner**: suspected token leak, account compromise (see `docs/security/00_security_checklist.md`)

### Escalation triggers

- Multiple customers report the same checkout/discount issue
- A creator campaign drives traffic but conversion collapses
- Payment provider errors increase
- A customer claims unauthorized access or data exposure
- Threats, harassment, or legal demands

## Feedback loop

Support is a sensor. Convert repeated issues into fixes.

### Daily (10 minutes)

- Review new tickets and tag them.
- Note any repeated issues (top 3).
- If any P0/P1 indicators appear, escalate immediately.

### Weekly (ties into analytics review)

- Share a one-page support summary:
  - ticket volume
  - top 3 categories
  - top 3 product issues (size/quality)
  - refunds/returns drivers
  - 1–2 recommended fixes
- Create GitHub issues for:
  - theme/checkout bugs (include repro steps)
  - policy documentation gaps
  - product description/sizing clarity improvements (cross-link `docs/launch/05_content_and_assets.md`)

### Metrics (minimum)

- First response time (median)
- Resolution time (median)
- Tickets per 100 orders
- Refund/return reasons by category
