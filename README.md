# Against The Odds (AO)

Official Against The Odds brand website and Shopify store. Complete development infrastructure with automated workflows, Shopify integration, and comprehensive project management.

## 🚀 Quick Start

```powershell
# Clone the repository
git clone https://github.com/toodeceptive/against-the-odds.git
cd against-the-odds

# Set up environment
Copy-Item .env.example .env.local
# Edit .env.local with your credentials

# Install dependencies
npm install

# Set up Shopify CLI
npm install -g @shopify/cli @shopify/theme
shopify auth login

# Verify setup
.\scripts\shopify\test-connection.ps1
```

## 📋 Project Overview

- **Store**: [aodrop.com](https://aodrop.com) (Shopify)
- **Repository**: [GitHub](https://github.com/toodeceptive/against-the-odds)
- **Status**: Setup complete, ready for development

### Key Features

- ✅ Complete GitHub integration with automated workflows
- ✅ Shopify API integration and theme development
- ✅ Product management system (import/export/sync)
- ✅ Manufacturing workflow and sample tracking
- ✅ Performance monitoring and automated maintenance
- ✅ Comprehensive testing framework
- ✅ Quality gates and code standards

## 📁 Project Structure

```
against-the-odds/
├── .github/workflows/     # CI/CD automation
├── config/               # Configuration files
├── data/                 # Product and manufacturer data
├── docs/                 # Documentation
├── scripts/              # Automation scripts
├── src/shopify/          # Shopify themes and apps
└── tests/                # Test suites
```

## 🛠️ Development

### Prerequisites

- Node.js and npm
- Git
- PowerShell (Windows)
- Python 3.x (for Playwright webServer)
- Shopify Partner account

### Common Tasks

**Product Management**:

```powershell
# Sync products to Shopify
.\scripts\products\sync.ps1 -Direction import

# Export products from Shopify
.\scripts\products\export.ps1
```

**Manufacturing**:

```powershell
# Track samples
.\scripts\manufacturing\track-samples.ps1 -Action list

# Add new sample request
.\scripts\manufacturing\track-samples.ps1 -Action add -Manufacturer "Company Name"
```

**Monitoring**:

```powershell
# Performance check
.\scripts\monitoring\performance-check.ps1

# Security scan
.\scripts\maintenance\security-scan.ps1
```

**Documentation**:

```powershell
# Generate documentation
.\scripts\docs\auto-generate.ps1
```

## 📚 Documentation

- [Setup Guide](docs/SETUP_GITHUB.md) - GitHub and development setup
- [Shopify Integration](docs/SHOPIFY_SETUP.md) - Complete Shopify setup guide
- [Project Management](docs/PROJECT_MANAGEMENT.md) - Task and issue management
- [Manufacturing Workflow](docs/MANUFACTURING.md) - Sample tracking and production
- [Monitoring](docs/MONITORING.md) - Performance and health monitoring
- [Quick Start Guide](docs/guides/quick-start.md) - Getting started quickly

## 🔐 Environment Variables

Required environment variables (set in `.env.local`):

```env
# GitHub
GITHUB_TOKEN=your_token_here
GITHUB_USERNAME=toodeceptive
GITHUB_REPO=against-the-odds

# Shopify
SHOPIFY_API_KEY=your_api_key
SHOPIFY_API_SECRET=your_api_secret
SHOPIFY_ACCESS_TOKEN=your_access_token
SHOPIFY_STORE_DOMAIN=aodrop.com
```

## 🧪 Testing

```powershell
# Run all tests
npm test

# Unit tests only
npm run test:unit

# E2E tests (run `npx playwright install` once if needed)
npm run test:e2e

# With coverage
npm run test:coverage
```

Desktop automation tests (`tests/desktop-automation/`) run on Windows only and are gated accordingly. Shopify admin E2E tests require `SHOPIFY_STORE_DOMAIN` and Playwright browsers; see `docs/SHOPIFY_SETUP.md`.

## 📦 Scripts

All automation scripts are in the `scripts/` directory:

- `git/` - Git automation (sync, commit, push)
- `shopify/` - Shopify integration (sync, theme, API)
- `products/` - Product management (import, export, sync)
- `manufacturing/` - Sample tracking and evaluation
- `monitoring/` - Performance and health checks
- `maintenance/` - Dependency updates and security
- `docs/` - Documentation generation

## 🔄 Workflows

GitHub Actions workflows automate:

- **CI**: Continuous integration on every push
- **Deploy**: Automated deployment to production
- **Sync**: Repository synchronization
- **Shopify**: Product and theme sync
- **Quality**: Code quality checks
- **Maintenance**: Automated maintenance tasks

## 🎯 Next Steps

1. **Merch Design**: Apply branding to hoodie designs
2. **Manufacturer Research**: Find and evaluate manufacturers
3. **Samples**: Request and evaluate samples
4. **Production**: Place production orders
5. **Launch**: Prepare store for product launch

## 📝 License

UNLICENSED - Private project

## 🤝 Contributing

This is a private project. For questions or issues, contact the project owner.

---

**Against The Odds** - Official brand repository
