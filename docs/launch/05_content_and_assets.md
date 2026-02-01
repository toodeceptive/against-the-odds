# Against The Odds — Content & Assets

## Content pillars

Aligned with `docs/business-plan/03_gtm_plan.md`, we rotate these pillars weekly (minimum viable cadence: **5 short-form posts/week + daily stories**), with a single goal pre-launch: **email capture (“join the drop list”)**.

### P1 — Brand story (identity + meaning)

- **Who it’s for**: Builders (Segment A), supporters/gifters (Segment D)
- **Core message**: “Premium essentials for people who keep going—built for the ones who live against the odds.”
- **Angles**:
  - Founder POV: origin, what “Against The Odds” means
  - “Building in silence” / “show up anyway” micro-stories
  - Values: resilience, discipline, earned confidence (not gimmicky)
- **Primary CTA**: join waitlist for early access

### P2 — Product truth (quality + fit + details)

- **Who it’s for**: Fitness (Segment B), streetwear (Segment C), skeptics (“it’s just another hoodie”)
- **Proof points**: fabric weight, construction, stitching, fit notes, durability/wash test
- **Angles**:
  - “What makes a premium hoodie premium?”
  - Fit checks on 2–3 bodies/heights
  - Wash/shrink test clips; “holds shape” demo
- **Primary CTA**: waitlist + sizing/fit guide page

### P3 — Proof (UGC + testimonials + creator try-ons)

- **Who it’s for**: all segments; strongest for conversion
- **Angles**:
  - Creator try-ons (repost + remix)
  - Comment screenshots / review snippets (once live)
  - “I wore it for a week” honest founder wear test
- **Primary CTA**: early access / shop the drop (launch week)

### P4 — Lifestyle (routines, gym/work, “earned confidence”)

- **Who it’s for**: Builders (A) + Fitness (B)
- **Angles**:
  - Day-in-the-life + routines; discipline content
  - Styling reels: gym-to-street, travel, late-night work sessions
- **Primary CTA**: follow + join list

### P5 — Drop energy (countdowns, BTS, packing, scarcity)

- **Who it’s for**: streetwear (C) + anyone needing urgency
- **Angles**:
  - Behind-the-scenes manufacturing/QC, packaging, labels
  - Countdown stories; “early access to list first”
  - “Low stock / last call” only when true
- **Primary CTA**: early access / shop now

## Asset checklist

Use this as the **source-of-truth checklist** for Drop 1. Mark each item with: **Owner**, **Status**, **Due date**, **File location**.

### Brand identity (must-have)

- **Logo pack** (see note below):
  - Primary lockup + AO mark + wordmark
  - Variants: black/white, light/dark backgrounds
  - Formats: **SVG (vector)** + **transparent PNG** (at least 1024px)
- **Favicon set**: 32/48/180/512 png + `favicon.ico`
- **Brand basics**: color palette, typefaces, spacing rules (1 page is enough)
- **Packaging look** (even if minimal): mailer/box, sticker, thank-you insert
- **Shopify theme customization**: Palette, typography, and component styles are defined in **docs/status/BRAND_THEME_CUSTOMIZATION_20260201.md**. Apply the package in **src/shopify/themes/ao-brand-customization/** (see APPLY_INSTRUCTIONS.md and ASSETS_MANIFEST.md) after pulling the live theme.

### Product page photo/video (must-have)

- **Product photo set (hoodie)**:
  - 1–2 hero images (clean)
  - Front/back
  - 3/4 angle
  - Closeups: logo/print/embroidery, stitching, cuffs/hem, inside label
  - On-body: 2–3 fits/poses; at least 2 body sizes if possible
- **Size/fit assets**:
  - Fit guide image (height/weight/size worn)
  - Simple size chart graphic (can be generated from measurements)
- **1 product truth video** (15–30s): fabric + fit + “why it’s different”
- **Care/durability proof**:
  - 1 wash/shrink test clip (or photo of before/after measurements)

### Organic social content (must-have)

- **Hook bank** (20–30 hooks) aligned to pillars/segments
- **Template set** (CapCut/Premiere/Canva):
  - 9:16 reels template (subtitles, title card, end card CTA)
  - 1 carousel template (IG) for values/FAQ
- **Weekly content plan** for 4 weeks (see shoot plan section)

### Email assets (must-have)

- **Welcome series creative** (3): story → product truth → early access CTA
- **Launch week campaign creative** (3–5): early access, launch live, FAQ/objection, low-stock/last-call (only if true)
- **On-site capture graphics**: header bar + popup creative (1–2 variants)

### Creator / affiliate assets (must-have for creator motion)

- **Creator brief (1 page)** (included below)
- **UTM + discount code templates**
- **Usage rights language** (repost + paid usage optional)

### Nice-to-have (non-blocking for Drop 1)

- Paid retargeting creative (UGC-style)
- Pinterest stills (repurposed from hero frames)
- Longer YouTube (5–8 min) “making the hoodie / story”

### Important note: existing logos in repo root

There are logo images in the repository root (multiple `.png` files). Treat them as **inputs**, but standardize Drop 1 around a single **finalized logo pack** (SVG + transparent PNG variants) and put it in the repo paths defined below.

## Production workflow

This workflow is designed for a solo operator + light contractor support. The goal is **repeatability** (one core shoot → many deliverables).

### 1) Pre-production (1–2 days)

- **Define week theme**: pick pillar focus (P1–P5) and segment emphasis (A–D).
- **Write brief** (1 page):
  - Message, offer (waitlist/early access), required shots, deliverables, deadlines.
- **Shot list + scripts**:
  - 5–8 short scripts (10–25 seconds each)
  - 10–15 b-roll shots (closeups + lifestyle)
- **Casting + locations**:
  - At minimum: founder + 1 friend/creator; 1 indoor + 1 outdoor spot.
- **Prep product**: lint roll, steam, tag placement, backup sizes.

### 2) Production (shoot day)

- **Capture priority (in order)**:
  1. Product truth closeups (controlled lighting)
  2. Fit checks (multiple sizes/heights if possible)
  3. Lifestyle routines (gym/work)
  4. Drop energy BTS (packing, QC, labels)
- **Technical baseline**:
  - 9:16 vertical primary; 4K if available; consistent lighting; clean audio for talking-head.
  - Record “room tone” + 10–15 seconds of clean b-roll for transitions.

### 3) Post-production (same day + next day)

- **Ingest & backup** (external storage first; see below)
- **Rough cut**: pick 5 “core videos” for the week
- **Edit standards**:
  - Burned-in captions
  - Hook in first 1–2 seconds
  - CTA end card (waitlist / early access / shop)
  - Export: 1080×1920 H.264; keep originals in source folder
- **Repurpose**:
  - Each core video → 1–2 cutdowns + 3–5 story frames
  - Pull 3–6 stills for carousels / email

### 4) Review, approval, and publish

- **QA checklist**:
  - Claims: no unverified durability/material claims
  - Pricing/shipping/stock: match store reality
  - Links: UTM links correct; creator codes correct
- **Scheduling**:
  - Batch schedule posts 3–5 days ahead
  - Keep 1 “reactive slot” for UGC, FAQs, or trend-based hooks

### 5) Storage, naming, and source of truth

**Naming convention**

- `YYYY-MM-DD_pillar_segment_platform_topic_takeXX.ext`
  - Example: `2026-01-28_P2_B_IG_fitcheck_take02.mp4`

**What lives in the repo (committed)**

- Lightweight, durable artifacts: briefs, shot lists, scripts, templates, final exports, and selection thumbnails.
- Suggested paths (create as needed):
  - `assets/brand/` (final logo pack, favicon, brand basics PDF)
  - `assets/creator-kit/` (brief, talking points, CTA copy, UTM templates)
  - `assets/content/templates/` (Canva links + exported templates; CapCut project notes)
  - `assets/content/exports/drop1/` (final exported videos/images used for posting)
  - `assets/product/drop1/` (final product photos + web-optimized variants)
  - `docs/launch/content/` (weekly calendars, hook bank, shot lists)

**What stays in external storage (not committed)**

- Raw footage, project files, and large originals:
  - Camera originals (4K clips), audio wavs, Lightroom catalogs
  - Premiere/Final Cut/CapCut project files, After Effects
  - High-res photos before web optimization
- Recommended external structure (Drive/Dropbox/Frame.io/S3):
  - `AO_Content/Drop1/RAW/YYYY-MM-DD/`
  - `AO_Content/Drop1/PROJECTS/YYYY-MM-DD/`
  - `AO_Content/Drop1/EXPORTS/YYYY-MM-DD/` (mirror what’s in-repo)

**Rule of thumb**: if it’s required to rebuild, audit, or repost content, it belongs in-repo (or at least referenced via link). If it’s raw/heavy/replaceable, keep it external.

## Creator kit

Use this as the standard creator brief for seeding + affiliates (micro-creators 10k–250k followers, niches: fitness, discipline, founder grind, streetwear try-ons).

### 1-page creator brief (copy/paste)

**Brand**: Against The Odds (AO) — premium essentials for people who keep going.

**What to say (talking points)**

- “Against the odds” = showing up anyway (resilience, discipline, earned confidence)
- Quality-first hoodie: fit + weight + construction details (be specific only if confirmed)
- Limited drop energy: early access + limited run (don’t claim “limited” unless true)

**Deliverables (minimum)**

- **1** vertical try-on video (15–30s) (TikTok or IG Reel)
- **1** story sequence (3–5 frames) OR **1** additional cutdown (7–12s)
- Optional bonus: “how it fits” (front/back, side, closeup) + 1 still photo

**Posting window**

- Tease: T-2 to T-1 day (optional)
- Launch: Day 0–2 (preferred)
- Follow-up: Day 3–5 (optional)

**CTA copy (choose one)**

- Pre-launch: “Join the drop list for early access.”
- Launch: “Shop the drop with my code `AO_<NAME>`.”

**Tracking templates**

- Discount code: `AO_<NAME>` (e.g., `AO_MAYA`)
- UTM template:
  - `?utm_source=creator&utm_medium=<platform>_reel&utm_campaign=drop1&utm_content=<creator_handle>`

**Do / Don’t**

- Do: show closeups (fabric, stitching), fit from multiple angles, honest POV
- Don’t: make unverified claims (e.g., “10oz”, “won’t shrink”) unless we’ve validated specs/tests

**Usage rights**

- Permission for AO to repost on owned channels.
- Optional: paid usage/whitelisting only with explicit written approval.

**How to deliver files**

- Upload to shared folder (Drive/Dropbox/Frame.io) as:
  - `AO_<NAME>_<platform>_<deliverable>_<date>.mp4`

## 4-week shoot plan

This shoot plan supports the GTM calendar (weeks 1–4) and ensures we capture enough “evergreen” content to repurpose.

### Weekly cadence (minimum viable)

- **1 shoot block/week** (2–4 hours)
- **Deliverables/week**:
  - 5 core vertical videos (15–30s) → cut into 5 posts + stories
  - 15–25 b-roll clips (3–8s) for transitions and future edits
  - 10–20 still frames (from video or photos) for carousels/email

### Week 1 — Story + identity (P1 + P4)

**Goal**: awareness + waitlist growth.

- **Shoot blocks**:
  - Founder talking-head: “Against The Odds means…” (2–3 variants)
  - Routine montage (gym/work): late nights, training, packing, journaling
- **Shot list highlights**:
  - Tight face + hands shots; natural light; minimal set
  - Hoodie worn “in real life” (not polished)
- **Outputs**:
  - 2 story videos (founder POV)
  - 2 lifestyle routine reels
  - 1 “for people who…” montage

### Week 2 — Product truth (P2)

**Goal**: overcome “just another hoodie” objection; validate premium quality.

- **Shoot blocks**:
  - Controlled product closeups: fabric, seams, cuffs, inside label
  - Fit checks: at least 2 sizes; front/back/side; movement test
  - Wash/shrink test: before/after measurement or visual comparison
- **Outputs**:
  - 1 “premium hoodie = …” explainer
  - 1 fit guide reel (height/size worn)
  - 1 durability/wash test reel
  - 1 styling reel (3 outfits)
  - 1 FAQ reel (shipping/returns/restock policy)

### Week 3 — Proof (P3) + BTS trust (P5-lite)

**Goal**: social proof + creator UGC pipeline.

- **Shoot blocks**:
  - Founder “wore it for a week” honest review
  - Packaging/QC BTS: labels, folding, inserts, order prep
  - UGC capture: invite 1–2 micro-creators for try-on filming (or remote UGC)
- **Outputs**:
  - 2 repost-ready creator try-ons (or founder stand-ins until creators land)
  - 1 BTS/QC trust reel
  - 1 proof montage (comment/reaction style)
  - 1 “early access date” announcement clip

### Week 4 — Countdown + conversion (P5 + best-of P2/P3)

**Goal**: convert waitlist → orders.

- **Shoot blocks**:
  - Countdown clips (T-7, T-3, T-1, Launch Day)
  - Objection handler: “Is it worth it?” (price/quality/shipping)
  - Sizing reminder: quick fit check + size chart overlay
  - Launch day: “drop is live” + live reactions + packing orders (when orders start)
- **Outputs**:
  - 1 drop announcement (date/time)
  - 1 objection handler reel
  - 1 sizing reminder reel
  - 1 launch day hero reel
  - 1 “top questions answered” reel

### Shoot-day packing list (minimum)

- Phone + tripod + small LED light
- Lavalier mic (or best available audio)
- Lint roller + steamer
- 2–3 outfits (styling) + clean background option
- Printed shot list + CTA reminders
