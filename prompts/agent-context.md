# Agent Context Information

## Project Overview

**Project Name**: Against The Odds (AO)  
**Type**: E-commerce brand website and Shopify store  
**Repository**: https://github.com/toodeceptive/against-the-odds.git  
**Store Domain**: aodrop.com

## System Environment

### Operating System

- **OS**: Windows 10/11
- **Shell**: PowerShell
- **Node.js**: Required for automation scripts
- **Git**: Version control

### Key Applications

- **Cursor IDE**: Primary development environment
- **Google Chrome**: Browser (Shopify admin access)
- **PowerShell**: System automation
- **Git Bash/CMD**: Terminal access

### Development Tools

- **Node.js**: JavaScript runtime
- **npm**: Package manager
- **Playwright**: Browser automation
- **Vitest**: Testing framework

## Project Structure

```
C:\Users\LegiT\against-the-odds\
├── .cursor/              # Cursor IDE configuration
├── .github/              # GitHub workflows and templates
├── config/               # Configuration files
├── data/                 # Product and manufacturer data
├── docs/                 # Documentation
├── scripts/              # Automation scripts
├── src/                  # Source code
│   ├── browser-automation/  # Browser automation
│   ├── desktop-automation/   # Desktop automation
│   └── shopify/              # Shopify theme (Connect from GitHub)
│       └── themes/aodrop-theme/  # Theme at root for shopify-theme branch
├── tests/                # Test files
└── prompts/              # Agent prompts
```

## Important Files and Locations

### Configuration

- `.env.local` - Local environment variables (gitignored)
- `.env.example` - Environment template
- `config/shopify/.shopify-cli.yml` - Shopify CLI config
- `.cursor/settings.json` - Cursor workspace settings

### Scripts

- `scripts/setup/` - Environment setup
- `scripts/shopify/` - Shopify integration
- `scripts/github/` - GitHub operations
- `scripts/health/` - Health monitoring
- `scripts/sync/` - Synchronization

### Documentation

- `docs/ENVIRONMENT_SETUP.md` - Environment setup guide
- `docs/BROWSER_AUTOMATION.md` - Browser automation guide
- `docs/TROUBLESHOOTING.md` - Troubleshooting guide
- `README.md` - Project overview

## Credentials and Secrets

### Known Credentials

- **Shopify Client ID**: `your_shopify_api_key_here`
- **Shopify Store**: `aodrop.com`
- **GitHub Username**: `toodeceptive`
- **GitHub Repo**: `against-the-odds`

### Credentials to Retrieve

- **SHOPIFY_ACCESS_TOKEN**: From Shopify Admin > Apps > Development
- **SHOPIFY_THEME_ID**: From Shopify Admin > Themes
- **GITHUB_TOKEN**: Personal Access Token

### Storage Locations

- `.env.local` - Local development (gitignored)
- Windows Credential Manager - Secure storage
- GitHub Secrets - For CI/CD workflows

## Common Issues and Solutions

### Configuration Issues

- **Symptom**: Missing environment variables
- **Fix**: Run `scripts/setup/auto-configure-env.ps1`
- **Verify**: `scripts/setup/verify-credentials.ps1`

### Authentication Issues

- **Symptom**: API calls return 401/403
- **Fix**: Refresh tokens, verify credentials
- **Tools**: `scripts/shopify/browser/get-access-token.ps1`

### Synchronization Issues

- **Symptom**: Local and remote out of sync
- **Fix**: `scripts/sync/sync-all.ps1`
- **Verify**: `scripts/sync/verify-all.ps1`

### Application Errors

- **Symptom**: Application crashes or errors
- **Fix**: Check logs, restart application
- **Tools**: Desktop automation for UI interaction

## Automation Capabilities

### Desktop Automation

- Screen capture and viewing
- OCR text extraction
- Mouse and keyboard control
- Window management
- Issue detection
- Automated debugging and fixing

### Browser Automation

- Playwright for web automation
- Shopify admin automation
- Credential extraction
- Data extraction

### System Automation

- PowerShell scripts
- File system operations
- Process management
- Configuration management

## Integration Points

### GitHub

- Repository: `https://github.com/toodeceptive/against-the-odds.git`
- Authentication: PAT or SSH
- Workflows: CI/CD automation
- Secrets: For Actions workflows

### Shopify

- Store: `aodrop.com`
- Admin API: `https://aodrop.com/admin/api/2026-01`
- CLI: For theme development
- Browser: For admin UI automation

### Cursor IDE

- Workspace: `C:\Users\LegiT\against-the-odds`
- Settings: `.cursor/settings.json`
- Tasks: `.cursor/tasks.json`
- Context: `.cursor/context/`

## Current Project Status

### Completed

- GitHub repository setup
- Shopify integration infrastructure
- Automation scripts (26+ scripts)
- Testing framework
- Documentation system
- Health monitoring
- Desktop automation system (in progress)

### In Progress

- Desktop automation implementation
- Agent prompt system
- Application-specific automation

### Next Steps

- Complete desktop automation
- Test with real scenarios
- Refine agent prompts
- Expand application coverage

## Safety Considerations

### Sensitive Operations

- Credential changes require confirmation
- File deletions require confirmation
- System changes require confirmation
- Application restarts require confirmation

### Data Protection

- Never expose credentials in logs
- Use secure storage for secrets
- Encrypt sensitive data
- Audit all operations

### Rollback Support

- All fixes support rollback
- State tracking for recovery
- Backup before major changes
- Log all operations

## Quick Reference

### Common Commands

```powershell
# Environment setup
.\scripts\setup\auto-configure-env.ps1

# Health check
.\scripts\health\comprehensive-check.ps1

# Sync everything
.\scripts\sync\sync-all.ps1

# Test connections
.\scripts\shopify\test-connection.ps1
.\scripts\github\verify-auth.ps1
```

### Common Issues

- **.env.local missing**: Run setup script
- **Credentials invalid**: Re-extract or update
- **Sync issues**: Run sync verification
- **Application errors**: Use desktop automation to investigate

This context provides essential information for agents to effectively work with the project.
