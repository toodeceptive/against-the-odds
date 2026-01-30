# Quick Start Guide

## Getting Started with Against The Odds Development

### Prerequisites

- Node.js and npm installed
- Git configured
- PowerShell (Windows)
- Shopify Partner account (for store development)

### Initial Setup

1. **Clone the repository** (if not already done):

   ```powershell
   git clone https://github.com/toodeceptive/against-the-odds.git
   cd against-the-odds
   ```

2. **Set up environment variables**:

   ```powershell
   # Copy example file
   Copy-Item .env.example .env.local

   # Edit .env.local with your credentials
   # - GitHub token
   # - Shopify API credentials
   ```

3. **Install dependencies**:

   ```powershell
   npm install
   ```

4. **Set up Shopify CLI**:

   ```powershell
   npm install -g @shopify/cli @shopify/theme
   shopify auth login
   ```

5. **Verify setup**:

   ```powershell
   # Test GitHub connection
   git push

   # Test Shopify connection
   .\scripts\shopify\fetch-store-data.ps1
   ```

### Common Tasks

**Sync products to Shopify**:

```powershell
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
