# Quick Start Guide

## Getting Started with Against The Odds Development

### Prerequisites

- Node.js and npm installed
- Git configured
- PowerShell on Windows, or `pwsh` on Linux/macOS for PowerShell-backed scripts
- Shopify Partner account (for store development)

For cross-platform script execution, prefer `node scripts/shared/run-powershell.cjs <script.ps1>` when you are not already using an npm or Cursor task wrapper.

### Initial Setup

1. **Clone the repository** (if not already done):

   ```sh
   git clone https://github.com/toodeceptive/against-the-odds.git
   cd against-the-odds
   ```

2. **Set up environment variables**:

   ```sh
   # Copy example file (use cp on bash/zsh, Copy-Item on PowerShell)
   cp .env.example .env.local

   # Edit .env.local with your credentials
   # - GitHub token
   # - Shopify API credentials
   ```

3. **Install dependencies**:

   ```powershell
   npm install
   ```

4. **Set up Shopify CLI**:

   ```sh
   npx shopify auth login
   ```

5. **Verify setup**:

   ```sh
   npm run quality
   npm run verify:pipeline
   ```

### Common Tasks

**Sync products to Shopify**:

```powershell
.\scripts\shopify\sync-products.ps1 -DryRun
.\scripts\shopify\sync-products.ps1

# Legacy wrapper: repo -> Shopify import
.\scripts\products\sync.ps1 -Direction import
```

**Track manufacturing samples**:

```powershell
.\scripts\manufacturing\track-samples.ps1 -Action list
```

**Run performance checks**:

```powershell
.\scripts\monitoring\performance-check.ps1
```

**Generate documentation**:

```powershell
.\scripts\docs\auto-generate.ps1
```

### Next Steps

- Review [Project Management Guide](../PROJECT_MANAGEMENT.md)
- Set up [Shopify Integration](../SHOPIFY_SETUP.md)
- Read [Manufacturing Workflow](../MANUFACTURING.md)

---

_Last updated: 2026-01-31_
