# Brand Theme Customization — Guru Expert Synthesis

**Date:** 2026-02-01  
**Source:** Against the Odds brand images (logo, slogan, motto, AO mark)  
**Purpose:** Single source of truth for Shopify theme customization so the store matches the street-art / graffiti-inspired AO identity.

---

## 1. Executive summary (multi-expert synthesis)

- **Design lead:** Urban, street-art, graffiti-inspired. Bold typography, paint splatters/drips, dark bases with bright accents.
- **Frontend/UX:** Dark backgrounds (black/charcoal) with high contrast; primary text off-white/cream; accent colors for CTAs and emphasis.
- **Content/Creative:** Logo lockups and slogan graphics are hero-ready; motto "THE ODDS WERE NEVER EVEN" and "WE ALL PROFIT" are key conversion messages.
- **Technical:** Use CSS custom properties for palette and typography; optional grunge/splatter textures; ensure contrast (WCAG) for body text on dark.

---

## 2. Color palette (design tokens)

Extracted from the provided brand images.

| Token                          | Hex                                                                          | Usage                                            |
| ------------------------------ | ---------------------------------------------------------------------------- | ------------------------------------------------ |
| **Background (primary)**       | `#0d0d0d`                                                                    | Page/section backgrounds, header/footer          |
| **Background (surface)**       | `#1a1a1a`                                                                    | Cards, modals, elevated surfaces                 |
| **Background (textured)**      | Dark charcoal with subtle grain (use `#141414` + texture image or CSS grain) |
| **Text (primary)**             | `#f5f0e8`                                                                    | Headings, primary copy (cream/off-white)         |
| **Text (secondary)**           | `#b8b0a0`                                                                    | Muted copy, captions                             |
| **Accent — Cyan/Teal**         | `#00d4ff`                                                                    | Links, underlines, splatter accent (logo/slogan) |
| **Accent — Electric blue**     | `#2563eb`                                                                    | Buttons, highlights (logo blue streak)           |
| **Accent — Neon pink/Magenta** | `#ec4899`                                                                    | Slogan accent, hover states                      |
| **Accent — Violet**            | `#a855f7`                                                                    | "WERE NEVER" emphasis, alternate CTA             |
| **Accent — Yellow**            | `#facc15`                                                                    | "got it" / "profit" emphasis, badges             |
| **Accent — Red**               | `#dc2626`                                                                    | Underline accent (slogan), sale/urgency          |
| **Outline/Stroke**             | `#000000`                                                                    | Text outlines, borders (graffiti look)           |
| **White**                      | `#ffffff`                                                                    | Logo text fill, high-contrast labels             |

Use **cyan + yellow** or **blue + pink** as primary accent pairs for CTAs and key messaging.

---

## 3. Typography

- **Headings / Display:** Bold, hand-drawn or brush-style feel. Prefer:
  - **Bebas Neue** or **Oswald** (bold, condensed) for “graffiti block” impact.
  - **Permanent Marker** or **Rock Salt** for a more handwritten accent (use sparingly).
- **Body:** Sans-serif with good readability on dark; slightly warm neutral. Examples:
  - **Inter**, **DM Sans**, or **Space Grotesk** for body and UI.
- **Hierarchy:** Large, bold display for hero and motto; smaller but still bold for section headings; clean sans for body.

---

## 4. Brand assets and placement

| Asset                                               | Suggested use                                         |
| --------------------------------------------------- | ----------------------------------------------------- |
| **Against the Odds — Full Logo (Blue/Pink)**        | Header logo, footer logo, favicon source              |
| **Against the Odds — Full Logo (Blue/Yellow)**      | Alternate hero or collection headers                  |
| **Full Slogan** ("If y'all drop it… We all profit") | Hero banner, about section, email signup              |
| **We All Profit (partial slogan)**                  | CTA sections, cart/checkout confidence, footer        |
| **AO — Logo acronym**                               | Favicon, app icon, small placements                   |
| **AO + The Odds Were Never Even (logo + motto)**    | Hero lockup, about, brand story section               |
| **The Odds Were Never Even (motto only)**           | Section divider, footer tagline, product storytelling |

Ensure all logo/slogan images have **transparent backgrounds** where provided so they sit cleanly on dark theme backgrounds.

---

## 5. Visual style and components

- **Backgrounds:** Prefer dark (`--ao-bg`) with optional subtle texture (noise or concrete) for hero/footer.
- **Buttons:** Primary = accent (e.g. cyan or yellow); outline or ghost for secondary; bold, slightly rounded; optional subtle “paint drip” bottom border or shadow.
- **Links:** Accent color (cyan/violet); optional underline that echoes the slogan’s painted underline.
- **Section dividers:** Use splatter/drip SVG or small image strips in accent colors between sections.
- **Cards (product, collection):** Dark surface, cream text, accent on hover (border or glow).
- **Imagery:** Product shots can sit on dark or light; marketing sections should favor dark + accent overlays to match brand.

---

## 6. Accessibility and contrast

- **Body text** on dark: use `#f5f0e8` (or lighter) on `#0d0d0d`; check WCAG AA (contrast ≥ 4.5:1).
- **Accent buttons:** Ensure button text on cyan/yellow/pink meets contrast (e.g. black or dark text on light accents).
- **Focus states:** Visible focus ring in accent color (e.g. cyan) for keyboard users.

---

## 7. Implementation checklist

- [ ] Pull live theme: `.\scripts\shopify\theme-pull.ps1`
- [ ] Copy `ao-brand-customization` assets and styles into theme (see `APPLY_INSTRUCTIONS.md` in package)
- [ ] Upload brand images to theme `assets/` (or Shopify Files) and reference in sections
- [ ] Set theme color/font settings to AO palette and typography (or use `ao-brand.css` variables)
- [ ] Set header logo to full logo asset; add motto/slogan to hero and footer as per manifest
- [ ] Run theme dev: `.\scripts\shopify\theme-dev.ps1` and verify contrast and layout
- [ ] Commit and push to connected branch for deploy

---

## 8. References

- Theme source: `src/shopify/themes/aodrop-theme/`
- Customization package: `src/shopify/themes/ao-brand-customization/`
- Content and assets: `docs/launch/05_content_and_assets.md`
- Shopify workflow: `docs/UPDATE_SHOPIFY_FROM_CURSOR.md`
