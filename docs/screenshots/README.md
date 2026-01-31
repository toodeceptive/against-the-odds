# Screenshots

**Purpose**: Default directory for automation and manual screenshots. Content (`.png`, `.jpg`) is gitignored; only this README is tracked.

**Usage**:
- **Desktop automation** ([src/desktop-automation/config.js](../../src/desktop-automation/config.js), screen-capture.js): writes to `docs/screenshots/` with generated filenames.
- **Browser automation** ([src/browser-automation/shopify-admin.js](../../src/browser-automation/shopify-admin.js)): can save screenshots here.
- **Manual**: Save UI/store screenshots here for docs or debugging; do not commit binary content if large or sensitive.

**Naming**: Prefer descriptive names (e.g. `store-home-2026-01.png`) or let automation use timestamps/IDs.

_Defined: 2026-01-31 (Track F)._
