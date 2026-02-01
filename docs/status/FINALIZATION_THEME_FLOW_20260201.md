# Finalization — Theme Customization Flow & Preview

**Date:** 2026-02-01  
**Scope:** Guru expert review, optimization, and finalization of theme customization flow and visualized preview. Masterful, clean, perfected layout.

## Deliverables

### 1. Merge brand script (run after theme-pull)

- **scripts/shopify/merge-brand-into-theme.ps1** — Copies `ao-brand.css` and `ao-hero-brand.liquid` into aodrop-theme; patches `layout/theme.liquid` (stylesheet + body class) when present. Idempotent.

### 2. Automated flow

- **scripts/shopify/theme-pull-and-preview.ps1** — Pull → merge brand → theme dev (preview URL). Options: `-SkipPull`, `-PreviewOnly`. Documented in scripts/README and theme README.

### 3. Visualized preview

- **docs/guides/THEME_CUSTOMIZATION_FLOW.md** — Mermaid flow diagram, step table, one-command usage, reference links.
- **docs/guides/theme-preview-mock.html** — Local static mock of AO brand (no Shopify): design tokens, semantic HTML, focus-visible, spacing/rhythm, perfected layout. Open in browser to preview look before theme dev.

### 4. Optimizations applied

- **theme-preview-mock.html:** Design tokens aligned with ao-brand.css (`--ao-bg-elevated`, `--ao-page-width`, `--ao-spacing`); semantic structure (main, section, aria-labelledby); focus-visible for accessibility; flex layout for sticky footer; consistent spacing and CTA placement.
- **Docs:** Flow doc and theme README cross-linked; scripts/README updated with merge and pull-and-preview.

### 5. Guru quality gates

- Prettier: run on MD/HTML; PS1 not parsed by Prettier (expected).
- ESLint: no changes to JS; pre-existing warnings elsewhere.
- Tests: unit/integration pass or skipped (env).
- No secrets in changed files.

## Reference

- Brand spec: `docs/status/BRAND_THEME_CUSTOMIZATION_20260201.md`
- Flow: `docs/guides/THEME_CUSTOMIZATION_FLOW.md`
- Mock preview: `docs/guides/theme-preview-mock.html`
- Merge script: `scripts/shopify/merge-brand-into-theme.ps1`
- Pull + preview: `scripts/shopify/theme-pull-and-preview.ps1`
