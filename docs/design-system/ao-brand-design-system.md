# AO Brand Design System

Design tokens and style guidance derived from the Against the Odds (AO) logo set: full logo (blue/pink, blue/yellow), “We All Profit,” “The Odds Were Never Even,” AO acronym, and full slogan (“If y’all drop it, We all got it…”).

## Aesthetic

- **Mood:** Urban, street art, rebellious, energetic, bold, grunge
- **Keywords:** Graffiti, spray paint, chalk, high contrast, vibrant accents, distressed texture

---

## Color Palette

### Base

| Token                | Hex                      | Usage                           |
| -------------------- | ------------------------ | ------------------------------- |
| `--ao-bg`            | `#0c0d0f`                | Page background (dark charcoal) |
| `--ao-surface`       | `#14181e`                | Cards, panels                   |
| `--ao-surface-light` | `#1c222a`                | Elevated surfaces               |
| `--ao-text`          | `#f5f5f0`                | Primary text (off-white)        |
| `--ao-text-muted`    | `#a0a8b4`                | Secondary text                  |
| `--ao-border`        | `rgba(255,255,255,0.08)` | Dividers, borders               |

### Accent (from logo splatters and motto)

| Token         | Hex       | Usage                                           |
| ------------- | --------- | ----------------------------------------------- |
| `--ao-cyan`   | `#22d3ee` | AO outline, “EVEN,” underlines (primary accent) |
| `--ao-blue`   | `#3b82f6` | Logo blue splatter, links                       |
| `--ao-yellow` | `#facc15` | “Got it,” yellow splatter, CTAs                 |
| `--ao-pink`   | `#ec4899` | Logo pink, “WERE NEVER”                         |
| `--ao-purple` | `#a855f7` | “We All Profit” bar, secondary accent           |
| `--ao-teal`   | `#14b8a6` | Neon teal from AO acronym                       |

### Legacy (existing hub)

| Token              | Hex       | Notes                            |
| ------------------ | --------- | -------------------------------- |
| `--ao-accent`      | `#f0c86a` | Gold accent (aligns with yellow) |
| `--ao-accent-dark` | `#c9a046` | Hover state                      |

---

## Typography

- **Display / Headlines:** Bold, uppercase or title case, slight distress or heavy weight. Suggestions: **Bebas Neue**, **Oswald**, **Archivo Black**, or system **Impact**.
- **Body:** Clean, readable sans-serif. Suggestions: **DM Sans**, **Inter**, **Segoe UI**.
- **Taglines / Mottos:** Same as display; can use all caps: “THE ODDS WERE NEVER EVEN”, “WE ALL PROFIT”.

### Font Stack (CSS)

```css
--ao-font-display: 'Bebas Neue', 'Oswald', 'Archivo Black', Impact, sans-serif;
--ao-font-body: 'DM Sans', 'Inter', 'Segoe UI', system-ui, sans-serif;
```

---

## Graphic Elements

- **Splatter / drip:** Use sparingly as section backgrounds, dividers, or hero overlays (SVG or PNG).
- **Texture:** Subtle dark grain or concrete-style texture on `--ao-bg` or `--ao-surface`.
- **Outlines:** Thick dark outline on light text (or light on dark) for key headlines to echo logo treatment.

---

## Usage in Shopify Theme

1. **Colors:** Map theme settings (e.g. accent, background, text) to the tokens above in `config/settings_schema.json` and in `base.css` or `theme.css`.
2. **Typography:** Load display + body fonts (Google Fonts or theme assets); apply `--ao-font-display` to headings and `--ao-font-body` to body.
3. **Buttons / CTAs:** Primary = `--ao-yellow` or `--ao-cyan` on dark; outline style with thick border for “graffiti” feel.
4. **Slogans:** Use full slogan or motto in hero/footer; style with accent underlines (e.g. cyan under “We all got it”, teal under “We all profit”).

---

## Asset References

- Full logo (blue/pink, blue/yellow): hero, header
- “We All Profit”: footer or CTA section
- “The Odds Were Never Even”: tagline under logo or hero
- AO acronym: favicon, compact header
- Full slogan: about/community section

See `assets/brand/` and image set referenced in the theme customization README.
