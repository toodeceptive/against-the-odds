# Against The Odds — Store Copy & Content

Single source of truth for all store text and meta. Use in Shopify **Settings → Store details**, **Theme Editor** sections, and theme locale/JSON. Aligns with [BRAND_THEME_CUSTOMIZATION_20260201.md](../status/BRAND_THEME_CUSTOMIZATION_20260201.md) and your personal AO designs (logos, slogan, motto). When your Printify test products arrive, add any product-specific taglines or design names here so the store and merch stay aligned.

---

## Store identity (Shopify Settings → Store details)

| Field | Copy |
|-------|------|
| **Store name** | Against the Odds |
| **Short description (meta)** | Premium streetwear for people who keep going. Built for the ones who live against the odds. |
| **Long description (About / SEO)** | Against the Odds (AO) is a story-led premium streetwear brand for bet-on-yourself customers. We make apparel that signals resilience and ambition—without feeling like generic motivational merch. The odds were never even. We all profit. |

---

## Bio (footer, about block, social)

**Short (one line)**
Premium essentials for people who keep going.

**Medium (footer / about teaser)**
Against the Odds is built for builders, grinders, and anyone who shows up anyway. Quality-first hoodies and gear that feel earned—limited drops, no fluff.

**Long (About page / brand story)**
We started AO because we got tired of merch that talks big and wears thin. Against the Odds is for people who train like it’s personal, build in silence, and don’t need permission to bet on themselves. Every piece is made to hold up: heavyweight fabric, clean construction, and designs that mean something. Limited drops. No restocks until we say so. If y’all drop it, we all got it. If y’all rock it, we all profit.

---

## Homepage & key pages

### Hero (above fold)

- **Headline:** THE ODDS WERE NEVER EVEN
- **Subhead:** Premium streetwear for people who keep going.
- **CTA:** Join the drop list

*(Pre-launch: keep “Opening soon” + newsletter signup; swap headline to “THE ODDS WERE NEVER EVEN” and subhead to the line above.)*

### Newsletter / coming soon block

- **Title:** Opening soon
- **Body:** Sign up to be the first to know when we drop. Early access, no spam.
- **Button:** Sign up

### About page (full)

**Title:** About Against the Odds

**Body:**
Against the Odds (AO) is a story-led premium streetwear brand. We’re for people who bet on themselves—builders, grinders, and anyone who shows up anyway.

We don’t do generic motivational merch. We do heavyweight hoodies and gear built to last, with designs that actually mean something. Limited drops. No fluff.

*The odds were never even. If y’all drop it, we all got it. If y’all rock it, we all profit.*

— AO

### Contact / FAQ teaser (optional)

- **Contact:** Use Shopify Contact form or your preferred support email.
- **FAQ one-liner:** Shipping, returns, and restocks — see our policies below.

---

## Footer

- **Tagline:** THE ODDS WERE NEVER EVEN · WE ALL PROFIT
- **Links:** About · Contact · Shipping & Returns · Privacy Policy (use Shopify policy URLs)
- **Copyright:** © [year] Against the Odds. All rights reserved.
- **Optional line:** Premium streetwear for people who keep going.

---

## Meta & SEO

| Use | Copy |
|-----|------|
| **Meta title (home)** | Against the Odds — Premium Streetwear for People Who Keep Going |
| **Meta description** | Premium streetwear built for the ones who live against the odds. Limited drops. Quality-first. Join the drop list. |
| **OG title** | Against the Odds — Premium Streetwear |
| **OG description** | The odds were never even. We all profit. Premium essentials for people who keep going. |

---

## Policy page intros (optional; add above default Shopify policy text)

- **Shipping:** We ship US-first. Standard and expedited options at checkout.
- **Returns:** Quality matters. See our full returns policy for exchanges and refunds.
- **Privacy:** We use your info only to run the store and the drop list. No selling your data.

---

## Slogans & motto (from your designs — use as-is in art or copy)

- **Full slogan:** If y'all drop it, we all got it. If y'all rock it, we all profit.
- **Short:** We all profit.
- **Motto:** The odds were never even.

---

## Image placement (match your personal designs)

Use the assets in `assets/brand/` and `src/shopify/themes/aodrop-theme/assets/` (see [ASSETS_MANIFEST.md](../../src/shopify/themes/ao-brand-customization/ASSETS_MANIFEST.md)):

| Placement | Asset |
|-----------|--------|
| Header logo | Against the Odds full logo (blue/pink or blue/yellow) |
| Hero | Full slogan and/or logo + motto lockup |
| About section | Logo + motto or full slogan |
| Footer | We All Profit or motto only |
| Favicon | AO acronym logo |

After your Printify test products arrive, add product photos to the theme and product JSON; keep hero and about imagery aligned with the same graffiti/street-art palette (dark bg, cyan/yellow/pink accents).

---

## Applying this copy

1. **Store details:** Shopify Admin → Settings → Store details — paste Store name and Short/Long description.
2. **Theme Editor:** For each section (hero, newsletter, footer), paste the text from the tables above.
3. **About page:** Create page **About** in Shopify Admin → Online Store → Pages; paste the About page body.
4. **Theme files:** If your theme uses locale files (e.g. `locales/en.default.schema.json` or section settings), you can reference this doc when editing those files after a theme pull.
