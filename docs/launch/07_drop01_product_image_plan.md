# AO Drop 01 — Product Image + Print Plan (2 manufacturer samples)

## Goal

Produce the **final print-ready artwork + mockups** for Drop 01 so you can order **1 hoodie from 2 manufacturers** using the same spec pack and compare:

- print quality + durability
- placement accuracy
- blank quality + fit
- turnaround time

## Garment baseline (assumptions to confirm with each manufacturer)

- **Product**: blank hoodie (black)
- **Sample size**: pick one size to standardize the comparison (recommend **L** unless you prefer M)
- **Decoration method target**:
  - **Front/back**: screen print or DTG (manufacturer recommendation)
  - **Sleeve** (AO + QR + spray overlay): screen print (multi-layer) or DTG

## Design placements (required)

### 1) Front — “Against the Odds” final logo

- **Location**: center chest
- **Approx print size**: 10–12 in wide (25–30.5 cm), scaled to fit chest
- **Color**: per final logo spec (define in the spec pack)
- **Deliverable**: vector + transparent PNG (see Deliverables section)

### 2) Back — slogan “The Odds Were Never Even”

- **Location**: upper back or full back (choose one and keep consistent)
  - Option A (recommended): **upper back**, 2–3 in below collar seam
  - Option B: **full back**, centered
- **Approx size**:
  - Upper back: 10–12 in wide
  - Full back: 12–14 in wide
- **Typography**: final font choice included in vector (text outlined)

### 3) Right sleeve — AO 2-letter logo + QR, “spray paint hidden”

**Requirement**: QR must be **operational** (scannable) while **subtle** (partially obscured by spray paint).

- **Location**: right sleeve outer side, between shoulder seam and mid-forearm
- **Base layer**: “AO” 2-letter logo
- **Overlay**: QR code placed **over the AO logo**
- **Mask/finish**: spray paint layer placed over QR (and some of AO), creating a “revealed but gritty” effect

#### QR code requirements (so it stays scannable)

- **Error correction**: **H** (high)
- **Minimum physical size**: start at **1.25–1.5 in** (3.2–3.8 cm) square
- **Quiet zone**: keep a clean margin around the QR (at least **4 modules**) — do _not_ spray/texture the quiet zone
- **Contrast**: QR “dark modules” should remain clearly darker than the hoodie fabric; avoid low-contrast grays
- **Testing**:
  - Test scan on at least 2 phones (iPhone/Android) at 12–24 inches distance
  - Test after applying the spray overlay in the mockup/art file

#### “Spray paint hide” strategy (practical)

- Spray effect should obscure **~15–35%** of QR modules (not the quiet zone), relying on error correction H.
- Prefer a spray texture that blocks **clusters** rather than thin haze (thin haze reduces contrast and can break scans).
- Keep at least **one full finder pattern** (the big corner squares) fully clear; ideally keep all 3 mostly intact.

#### QR destination (decide once; keep consistent)

- Recommended: `https://aodrop.com` or a dedicated landing page like `https://aodrop.com/scan`
- If you want manufacturer-specific tracking, encode the same URL but use **UTM params** per manufacturer in the QR (optional).

---

## Asset + File Deliverables (the “spec pack” you send to both manufacturers)

Create a folder: `assets/drop01/` (or external drive folder if you don’t want binaries in repo) with:

### Print-ready artwork (per placement)

- **Vector**: `.ai` / `.pdf` / `.svg`
  - All text **outlined**
  - One artboard per placement (front, back, sleeve)
- **Raster preview**: transparent `.png`
  - 300 DPI at final print dimensions

### Color + sizing spec sheet (one page)

- Exact print dimensions (in + cm)
- Placement measurements (distance from seam/collar)
- Color definitions (Pantone or HEX + notes)
- Print method notes (screen print vs DTG) and number of colors/layers

### Mockups for review + manufacturer communication

- Hoodie front mockup (blank photo + overlaid front logo)
- Hoodie back mockup (blank photo + overlaid slogan)
- Right sleeve close-up mockup (AO + QR + spray overlay)

---

## Workflow (fastest path)

### Step A — Gather base images

Use one of:

1. Manufacturer blank hoodie photos (front/back/right sleeve)
2. Your existing blank hoodie mockups (preferred if already in repo)

### Step B — Build layered artwork (recommended tool: Figma/Photoshop/Photopea)

For each placement, keep layers:

- base hoodie image
- placement guide (seams / centerline)
- artwork layer(s)
- QR layer
- spray overlay layer

### Step C — Validate the QR

1. Export the sleeve design at final size
2. Print it on paper at scale
3. Scan with phone(s)
4. Adjust spray mask until it scans reliably while still looking “hidden”

### Step D — Package for both manufacturers (1 hoodie each)

Send each manufacturer:

- spec sheet PDF
- vector files (front/back/sleeve)
- PNG previews
- mockups

Ask both to confirm:

- print method recommendation
- exact placement measurements they will use
- proof approval step before production

---

## Acceptance criteria (before ordering samples)

- Front/back/sleeve mockups look correct on the blank hoodie images
- Sleeve QR scans reliably in real-world conditions (not just on-screen)
- Both manufacturers have acknowledged the same placement + size specs
