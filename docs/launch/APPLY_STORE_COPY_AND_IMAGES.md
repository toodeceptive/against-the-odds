# Apply Store Copy and Brand Images

Use this checklist to put **all store text and images** live, aligned with your personal AO designs and [STORE_COPY_AND_CONTENT.md](STORE_COPY_AND_CONTENT.md).

---

## 1. Store details (Shopify Admin)

1. Go to **Settings → Store details**.
2. Set:
   - **Store name:** Against the Odds
   - **Store description (short):** _Paste "Short description (meta)" from STORE_COPY_AND_CONTENT.md._
   - **Store description (long):** _Paste "Long description (About / SEO)" from STORE_COPY_AND_CONTENT.md._

This drives meta description and any place Shopify uses the store’s “about” blurb.

---

## 2. Theme Editor — sections and text

1. Go to **Online Store → Themes → Customize** (or **Edit** on your theme).
2. Ensure the theme uses **ao-brand.css** and body class **ao-brand-theme** (see [APPLY_INSTRUCTIONS.md](../../src/shopify/themes/ao-brand-customization/APPLY_INSTRUCTIONS.md)).
3. On the **Homepage** (or the template you use for “coming soon”):
   - Add section **AO Hero**. Fill in:
     - Headline: `THE ODDS WERE NEVER EVEN`
     - Subhead: `Premium streetwear for people who keep going.`
     - Button label: `Join the drop list`
     - Button link: e.g. `#newsletter` or your signup URL.
   - For **Brand images**, use the image pickers to select:
     - **Logo:** Your main AO logo (e.g. blue/pink or blue/yellow from assets).
     - **Slogan graphic:** Full slogan art (“If y'all drop it… We all profit”).
     - **Motto graphic:** “The Odds Were Never Even” art.
   - If you prefer **only** images (no headline/subhead), leave headline/subhead blank and only set the logo/slogan/motto images.
4. Add section **AO About** (or use on an About page):
   - Title and body are pre-filled from STORE_COPY_AND_CONTENT.md; edit if you want.
   - Optionally set the logo image picker.
5. In your **Footer** (or at bottom of homepage):
   - Add section **AO Footer**, or use the footer block that already exists and add **AO Footer** above/below it.
   - Set tagline: `THE ODDS WERE NEVER EVEN · WE ALL PROFIT`
   - Set short bio: `Premium streetwear for people who keep going.`
   - Optionally set logo and copyright line.

All other copy (newsletter title, button labels, etc.) can be edited in the same Theme Editor where those sections/blocks appear.

---

## 3. Brand images in the theme

- **Option A — From repo:** Run `.\scripts\shopify\copy-brand-images-to-theme.ps1` (or `theme-update-store.ps1`) so files from **assets/brand/** are copied into the theme’s **assets** folder. Then in Theme Editor, use the image pickers to select those assets (e.g. logo, slogan, motto).
- **Option B — Upload in Admin:** In **Content → Files** (or inside Theme Editor when you click “Select image”), upload your AO logo, slogan, and motto graphics. Then assign them in the AO Hero, AO About, and AO Footer sections.

Use the same visuals you use on your Printify merch so the site and products feel like one brand.

---

## 4. About page (full story)

1. **Online Store → Pages → Add page** (or edit existing “About”).
2. Title: `About Against the Odds`
3. Body: _Paste the “About page (full)” body from STORE_COPY_AND_CONTENT.md._
4. Save.

You can also add an **AO About** section on this page and keep the page body in sync with the section body.

---

## 5. Meta and SEO

- In Theme Editor, open **Theme settings** (or the global SEO block if your theme has one). Set:
  - **Meta title (home):** Against the Odds — Premium Streetwear for People Who Keep Going
  - **Meta description:** _From “Meta & SEO” in STORE_COPY_AND_CONTENT.md._
- If your theme has **OG image**, use your main AO logo or a hero image that matches your designs.

---

## 6. After your Printify test products arrive

- Add product photos (and any design mockups) to **Products** in Shopify (or via product JSON and sync).
- Keep hero and about imagery consistent with the same palette (dark bg, cyan/yellow/pink accents) so the store and merch feel unified.
- You can add a short line in the footer or about section like “First drop coming soon” and then switch to “Shop the drop” when you’re live.

---

**Single source for all copy:** [STORE_COPY_AND_CONTENT.md](STORE_COPY_AND_CONTENT.md)
**Brand palette and assets:** [BRAND_THEME_CUSTOMIZATION_20260201.md](../status/BRAND_THEME_CUSTOMIZATION_20260201.md), [ASSETS_MANIFEST.md](../../src/shopify/themes/ao-brand-customization/ASSETS_MANIFEST.md)
