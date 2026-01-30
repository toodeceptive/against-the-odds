# AO Drop 01 — Hoodie Print Specification

**Product**: Hoodie
**SKU**: AO-DROP01-HOODIE
**Sample Size**: L
**Date**: 2026-01-29
**Version**: 1.0

---

## Product Information

- **Garment**: Blank hoodie (black)
- **Sample Size**: L
- **Color**: Black
- **Material**: [Manufacturer standard]

---

## Design Placement 1: Front — "Against the Odds" Logo

- **Location**: Center chest
- **Approx Print Size**: 10–12 in wide (25–30.5 cm), scaled to fit chest
- **Placement Measurement**:
  - Center horizontally on chest
  - Positioned at standard chest logo height (typically 2–3 in below collar)
- **Color**: Per final logo spec (define in the spec pack)
- **Method**: Screen print or DTG (manufacturer recommendation)

### Artwork Files

- **Vector**: `artwork/hoodie/front_logo.ai` (or `.pdf`, `.svg`)
- **Raster Preview**: `artwork/hoodie/front_logo.png` (300 DPI, transparent)

---

## Design Placement 2: Back — Slogan "The Odds Were Never Even"

- **Location**: Upper back (recommended) or full back
  - **Option A (Recommended)**: Upper back, 2–3 in below collar seam
  - **Option B**: Full back, centered
- **Approx Size**:
  - Upper back: 10–12 in wide
  - Full back: 12–14 in wide
- **Placement Measurement**:
  - Center horizontally
  - Upper back: 2–3 in (5–7.6 cm) below collar seam
  - Full back: Center vertically and horizontally
- **Typography**: Final font choice included in vector (text outlined)
- **Method**: Screen print or DTG

### Artwork Files

- **Vector**: `artwork/hoodie/back_slogan.ai` (or `.pdf`, `.svg`)
- **Raster Preview**: `artwork/hoodie/back_slogan.png` (300 DPI, transparent)

---

## Design Placement 3: Right Sleeve — AO Logo + QR + Spray Overlay

**Requirement**: QR must be **operational** (scannable) while **subtle** (partially obscured by spray paint).

- **Location**: Right sleeve outer side, between shoulder seam and mid-forearm
- **Placement Measurement**:
  - Center horizontally on sleeve
  - Positioned approximately 3–4 in (7.6–10 cm) below shoulder seam
- **Base Layer**: "AO" 2-letter logo
- **Overlay**: QR code placed **over the AO logo**
- **Mask/Finish**: Spray paint layer placed over QR (and some of AO), creating a "revealed but gritty" effect
- **Method**: Screen print (multi-layer) or DTG

### QR Code Requirements (so it stays scannable)

- **Error Correction**: **H** (high)
- **Minimum Physical Size**: Start at **1.25–1.5 in** (3.2–3.8 cm) square
- **Quiet Zone**: Keep a clean margin around the QR (at least **4 modules**) — do _not_ spray/texture the quiet zone
- **Contrast**: QR "dark modules" should remain clearly darker than the hoodie fabric; avoid low-contrast grays
- **Testing**:
  - Test scan on at least 2 phones (iPhone/Android) at 12–24 inches distance
  - Test after applying the spray overlay in the mockup/art file

### "Spray Paint Hide" Strategy (practical)

- Spray effect should obscure **~15–35%** of QR modules (not the quiet zone), relying on error correction H.
- Prefer a spray texture that blocks **clusters** rather than thin haze (thin haze reduces contrast and can break scans).
- Keep at least **one full finder pattern** (the big corner squares) fully clear; ideally keep all 3 mostly intact.

### QR Destination

- **Recommended**: `https://aodrop.com` or a dedicated landing page like `https://aodrop.com/scan`
- **Optional**: UTM parameters per manufacturer for tracking:
  - Manufacturer 1: `https://aodrop.com/scan?utm_source=manufacturer1&utm_medium=merch&utm_campaign=drop01`
  - Manufacturer 2: `https://aodrop.com/scan?utm_source=manufacturer2&utm_medium=merch&utm_campaign=drop01`

### Artwork Files

- **Vector**: `artwork/hoodie/sleeve_ao_qr_spray.ai` (or `.pdf`, `.svg`)
- **Raster Preview**: `artwork/hoodie/sleeve_ao_qr_spray.png` (300 DPI, transparent)

---

## Print Method Notes

- **Front/Back**: Screen print or DTG (manufacturer recommendation)
- **Sleeve** (AO + QR + spray overlay): Screen print (multi-layer) or DTG
- **Number of Colors**:
  - Front/Back: 1–2 colors
  - Sleeve: Multi-layer (AO base, QR overlay, spray texture)
- **Special Instructions**:
  - Sleeve design requires careful layer registration for spray overlay effect
  - QR code must remain scannable after spray overlay application
  - Test QR scannability before production approval

---

## Color Specifications

- **Logo Colors**: Per final logo spec (define exact Pantone/HEX in final artwork)
- **Background**: Black hoodie fabric
- **Pantone Reference**: [To be defined in final artwork]
- **Spray Overlay**: Grayscale/texture overlay (define opacity and style in artwork)

---

## Quality Requirements

- **Durability**: All prints must withstand washing and wear
- **Visibility**: All text/logos must be clearly visible on black fabric
- **Placement Accuracy**: ±0.25 in (6 mm) tolerance
- **QR Scannability**: QR code must scan reliably at 12–24 inches distance after spray overlay
- **Finish**: Clean edges, no print defects, proper layer registration on sleeve

---

## Mockup References

- Front: `mockups/hoodie_front_mockup.png`
- Back: `mockups/hoodie_back_mockup.png`
- Right Sleeve: `mockups/hoodie_sleeve_mockup.png`

---

## Manufacturer Confirmation Checklist

- [ ] Print method confirmed (screen print vs DTG) per placement
- [ ] Exact placement measurements confirmed for all placements
- [ ] Logo/slogan sizes confirmed
- [ ] Color specifications confirmed
- [ ] Sleeve multi-layer registration confirmed
- [ ] QR code scannability tested and confirmed
- [ ] Spray overlay effect achievable with chosen print method
- [ ] Proof approval step before production
- [ ] Estimated turnaround time: **\_** days
- [ ] Cost per sample: $**\_**
- [ ] Minimum order quantity (for future production): **\_**

---

## Notes

- Sleeve design is the most complex placement - ensure manufacturer can execute multi-layer print with spray overlay effect
- QR code scannability is critical - test thoroughly before production
- Upper back placement is recommended for slogan (more readable than full back)
- Ensure all placements account for hoodie construction and seams

---

**Next Steps**:

1. Review artwork files
2. Confirm specifications with manufacturer
3. Test QR code scannability (print test at scale)
4. Approve proof before production
5. Order 1 sample for evaluation
