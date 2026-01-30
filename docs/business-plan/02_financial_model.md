# Against The Odds — Financial Model (Assumptions-Driven)

This is a **planning model** meant to be easy to update as you learn from sampling, production quotes, and live store data. It intentionally avoids external “market facts”; every input below is an explicit **assumption** (A#) with a range, and every output is a **derived calculation** (D# / T#) from those assumptions.

## Assumptions (every input is explicit)

Notes:
- **Currency**: all $ values are **USD (assumption A0)**.
- **Taxes**: sales tax / VAT is excluded from revenue and costs (**assumption A00**: “taxes excluded”).
- **Primary SKU**: initial model assumes a hoodie as the primary SKU, consistent with `data/products/example-hoodie.json`.

| ID | Category | Assumption (what it means) | Base (A#) | Range (A#) | Notes |
|---|---|---|---:|---:|---|
| A0 | Meta | Currency | $USD | $USD | Reporting currency only. |
| A00 | Meta | Taxes excluded | Yes | Yes | Model excludes sales taxes collected/remitted. |
| A30 | Meta | Forecast horizon (months) | 12 | 12 | Planning horizon for T1/T2. |
| A1 | Pricing | Retail price per unit (hoodie) | $79.99 | $69.99–$89.99 | Base taken from `example-hoodie.json` (planning price can change). |
| A2 | Pricing | Discount rate (% off retail; blended) | 8% | 0%–15% | Includes promos and discount codes. |
| A3 | Basket | Items per order (units/order) | 1.00 | 1.00–1.20 | Early merch often starts near 1.00; adjust with bundles/upsells. |
| A4 | Shipping | Shipping revenue charged per order | $6.00 | $0.00–$10.00 | If you “free ship” above threshold, effective A4 drops. |
| A5 | COGS | Blank garment cost per unit | $27.00 | $22.00–$32.00 | Replace with vendor quote after sampling. |
| A6 | COGS | Decoration cost per unit (print/embroidery) | $10.00 | $6.00–$14.00 | Depends on technique, stitch count, placements. |
| A7 | COGS | Packaging per unit (polybag/box/inserts) | $2.00 | $1.00–$3.00 | Include branded inserts if used. |
| A8 | Logistics | Inbound freight + duties per unit | $1.50 | $0.75–$3.00 | Factory → your fulfillment location. |
| A9 | Logistics | Outbound shipping cost per order | $7.50 | $6.00–$9.00 | What you pay the carrier/3PL for shipping label. |
| A10 | Payments | Payment processing % of total collected | 2.9% | 2.5%–3.5% | Apply to product + shipping collected. |
| A11 | Payments | Payment processing fixed fee per order | $0.30 | $0.20–$0.40 | Per successful charge. |
| A12 | Returns | Returns allowance (% of net product revenue) | 4% | 2%–8% | Simplifies refunds/return shipping/damage leakage into one planning line. |
| A13 | Returns (ops) | Physical return rate (% of orders returned) | 5% | 2%–10% | Ops metric; separate from A12 allowance. |
| A14 | Returns (ops) | Handling cost per return | $5.00 | $2.00–$8.00 | Labor/materials/processing (excluding refund). |
| A15 | Marketing | Blended marketing cost per order (CAC) | $20.00 | $10.00–$35.00 | Use a blended planning CAC across paid + creator + content boosts. |
| A17 | Fixed | Shopify + apps per month | $120 | $50–$250 | Update based on actual plan/app stack. |
| A19 | Ops | Production lead time (weeks) | 8 | 6–10 | Based on manufacturing workflow total timing bands in `docs/MANUFACTURING.md` (planning assumption). |
| A20 | Ops | Inbound freight time (weeks) | 2 | 1–3 | Time from “ready to ship” to inventory available. |
| A21 | Inventory cash | Supplier payment terms (deposit / balance) | 50% / 50% | 30%–60% / 40%–70% | Deposit at PO; balance before shipment release (planning assumption). |
| A22 | Inventory | MOQ per production run (units) | 150 | 50–300 | Use manufacturer quote once selected. |
| A23 | Inventory | Target inventory coverage (weeks of sales) | 8 | 6–10 | Planning target to reduce stockouts early. |
| F1 | Forecast | Base monthly order ramp (months 1→12) | 20, 30, 45, 60, 80, 100, 125, 150, 175, 200, 225, 250 | 0.7×–1.3× | **Base schedule is an assumption set**; apply multiplier for downside/upside planning. |

## Unit Economics (Per Order, base case)

All figures below are **derived outputs** from assumptions above; they are **not additional assumptions**.

### Revenue per order (derived)
- **D1 Net product revenue / order** = \(A1 \times (1 - A2) \times A3\) = **$73.59** (derived from A1–A3)
- **D2 Shipping revenue / order** = \(A4\) = **$6.00** (derived from A4)
- **D3 Total revenue collected / order** = \(D1 + D2\) = **$79.59** (derived)

### Variable costs per order (derived)
- **D4 Product COGS / order (excl outbound ship)** = \((A5 + A6 + A7 + A8) \times A3\) = **$40.50** (derived from A3, A5–A8)
- **D5 Outbound shipping cost / order** = \(A9\) = **$7.50** (derived from A9)
- **D6 Payment processing / order** = \(A10 \times D3 + A11\) = **$2.61** (derived from A10–A11, D3)
- **D7 Returns allowance / order** = \(A12 \times D1\) = **$2.94** (derived from A12, D1)

### Profit per order (derived)
- **D8 Gross profit / order** = \(D3 - (D4 + D5 + D6 + D7)\) = **$26.04** (derived)
- **D9 Gross margin %** = \(D8 / D3\) = **32.7%** (derived)
- **D10 Marketing cost / order** = \(A15\) = **$20.00** (derived from A15)
- **D11 Contribution profit / order (after marketing)** = \(D8 - D10\) = **$6.04** (derived)

Interpretation:
- If **D11 stays positive**, you can scale orders while funding fixed costs and some working capital internally.
- If **D11 turns negative**, growth increases cash burn (you must fix pricing/COGS/CAC before scaling).

## Forecast (A30-month horizon; simple, base case)

This is a **simple P&L-style forecast** (T1) derived from the unit economics above and the base order ramp (**F1 base schedule**). It **does not** include inventory cash prepayments (see “Cash + inventory timing”).

Assumption links:
- **Orders**: from **F1 base schedule**
- **Revenue/COGS/Processing/Returns**: derived from **D1–D8** at the order level
- **Marketing**: set to \(A15 \times \text{Orders}\) (derived planning rule)
- **Fixed**: **A17** per month

### T1 Base forecast table (derived)

| Month | Orders | Revenue | COGS (product+outbound) | Processing | Returns allowance | Gross profit | Marketing | Fixed | Operating profit |
|---|---|---|---|---|---|---|---|---|---|
| 1 | 20 | $1,592 | $960 | $52.16 | $58.87 | $521 | $400 | $120 | $0.78 |
| 2 | 30 | $2,388 | $1,440 | $78.24 | $88.31 | $781 | $600 | $120 | $61.17 |
| 3 | 45 | $3,582 | $2,160 | $117 | $132 | $1,172 | $900 | $120 | $152 |
| 4 | 60 | $4,775 | $2,880 | $156 | $177 | $1,562 | $1,200 | $120 | $242 |
| 5 | 80 | $6,367 | $3,840 | $209 | $235 | $2,083 | $1,600 | $120 | $363 |
| 6 | 100 | $7,959 | $4,800 | $261 | $294 | $2,604 | $2,000 | $120 | $484 |
| 7 | 125 | $9,949 | $6,000 | $326 | $368 | $3,255 | $2,500 | $120 | $635 |
| 8 | 150 | $11,939 | $7,200 | $391 | $442 | $3,906 | $3,000 | $120 | $786 |
| 9 | 175 | $13,928 | $8,400 | $456 | $515 | $4,557 | $3,500 | $120 | $937 |
| 10 | 200 | $15,918 | $9,600 | $522 | $589 | $5,208 | $4,000 | $120 | $1,088 |
| 11 | 225 | $17,908 | $10,800 | $587 | $662 | $5,859 | $4,500 | $120 | $1,239 |
| 12 | 250 | $19,898 | $12,000 | $652 | $736 | $6,510 | $5,000 | $120 | $1,390 |

Derived annual totals (T2, from T1):
- **T2 Total orders (12 months)**: **1,460** (derived from F1)
- **T2 Total revenue (12 months)**: **$116,203** (derived from T1)
- **T2 Total operating profit (12 months)**: **$7,377** (derived from T1)

## Cash + inventory timing notes (working capital is the real constraint)

The P&L above can show “profit” while cash is negative, because **inventory is paid before it is sold**.

Key timing assumptions:
- **A19 Production lead time**: 6–10 weeks (base 8 weeks)
- **A20 Inbound freight time**: 1–3 weeks (base 2 weeks)
- **A21 Payment terms**: 30%–60% deposit at PO (base 50%), remaining 40%–70% before shipment release (base 50%)

Implications (planning guidance, derived qualitatively from A19–A21):
- **D30 Cash lead time (weeks) = A19 + A20** → base **10 weeks**, range **7–13 weeks** (derived). This creates a working-capital “gap” even when contribution margin (D11) is positive.
- **Stockouts vs. cash**: if you buy too little, you cap demand; if you buy too much, you tie up cash in inventory. Use a coverage target (**A23**) until you have stable sell-through data.

Practical cash planning checklist (use as you get real quotes):
- **At PO**: plan cash for **deposit = A21 deposit % × (unit cost × units)**.
- **At ship**: plan cash for **balance = remaining % × (unit cost × units)** plus inbound freight (A8) if not included.
- **After arrival**: you’ll convert inventory to cash as orders come in, but payment processors may hold funds/fees (A10–A11).

## Sensitivity (Best / Base / Worst)

This section shows how sensitive the business is to a few drivers. Values below are **scenario assumptions** (S#) using the same structure as A#.

### S1–S3 driver values (scenario assumptions)
| Driver | Best (S1) | Base (A#) | Worst (S3) |
|---|---:|---:|---:|
| Price (A1) | $89.99 | $79.99 | $69.99 |
| Discount rate (A2) | 0% | 8% | 15% |
| Shipping revenue (A4) | $6.00 | $6.00 | $3.00 |
| Product COGS components (A5–A8, combined) | Lower | Base | Higher |
| Outbound shipping cost (A9) | $6.50 | $7.50 | $9.00 |
| Processing % / fee (A10/A11) | 2.5% / $0.20 | 2.9% / $0.30 | 3.5% / $0.40 |
| Returns allowance (A12) | 2% | 4% | 8% |
| CAC (A15) | $10.00 | $20.00 | $35.00 |

### D20–D22 per-order outcomes (derived from S1/S2/S3)
| Output (per order) | Best (D20) | Base (D11/D9) | Worst (D22) |
|---|---:|---:|---:|
| Total revenue / order | $95.99 | $79.59 | $62.49 |
| Gross profit / order | $50.59 | $26.04 | -$5.86 |
| Gross margin % | 52.7% | 32.7% | -9.4% |
| Contribution profit / order (after CAC) | $40.59 | $6.04 | -$40.86 |

What this means operationally:
- **Worst-case shows why inventory buys must be conservative** until you lock in real unit costs and CAC.
- The fastest levers to improve contribution are usually **COGS (A5–A8), CAC (A15), and discounting (A2)**—price (A1) helps, but can impact conversion/brand perception.

