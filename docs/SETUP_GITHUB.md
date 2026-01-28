# GitHub Setup Guide

## Complete GitHub Repository Setup for Against The Odds

This guide provides step-by-step instructions for setting up complete GitHub integration with automated workflows, CI/CD, and project management.

## Prerequisites

- GitHub account: `toodeceptive`
- Repository: `against-the-odds`
- Local repository initialized and synced
- Git Credential Manager installed (Windows default)

## Step 1: Authentication Setup

### Option A: Personal Access Token (Recommended)

1. **Create PAT**:
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Name: `Against The Odds - Automated Access`
   - Expiration: 90 days (or custom)
   - Scopes: `repo`, `workflow`, `write:packages`, `read:org`
   - Generate and copy token

2. **Store PAT Securely**:
   ```powershell
   # Method 1: Windows Credential Manager
   cmdkey /generic:git:https://github.com /user:toodeceptive /pass:YOUR_PAT
   
   # Method 2: Environment Variable (User scope)
   [System.Environment]::SetEnvironmentVariable('GITHUB_TOKEN', 'YOUR_PAT', 'User')
   ```

3. **Test Authentication**:
   ```powershell
   cd C:\Users\LegiT\against-the-odds
   git push origin main
   ```

### Option B: SSH Keys (Alternative)

See `config/github-auth.md` for SSH key setup instructions.

## Step 2: Repository Configuration

### Branch Structure

```powershell
# Create develop branch
git checkout -b develop
git push -u origin develop

# Create feature branch template
git checkout -b feature/template
git push -u origin feature/template
```

### Branch Protection Rules (GitHub Web Interface)

1. Go to: https://github.com/toodeceptive/against-the-odds/settings/branches
2. Add rule for `main` branch:
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require conversation resolution before merging
   - ✅ Include administrators
   - ✅ Restrict pushes that create files larger than 100MB

3. Add rule for `develop` branch:
   - ✅ Require pull request reviews (1 reviewer)
   - ✅ Require status checks to pass

### Repository Settings

1. **General Settings**:
   - Description: "Official Against The Odds (AO) brand website and store"
   - Topics: `e-commerce`, `shopify`, `brand-website`, `merchandise`
   - Visibility: Public (or Private based on preference)

2. **Features**:
   - ✅ Issues
   - ✅ Projects
   - ✅ Wiki (optional)
   - ✅ Discussions (optional)

3. **Actions Settings**:
   - ✅ Allow all actions and reusable workflows
   - ✅ Allow GitHub Actions to create and approve pull requests

## Step 3: GitHub Actions Secrets

For CI/CD workflows that need authentication:

1. Go to: https://github.com/toodeceptive/against-the-odds/settings/secrets/actions
2. Add secrets:
   - `GITHUB_TOKEN` - Personal Access Token (if needed for workflows)
   - `SHOPIFY_API_KEY` - Shopify Admin API key
   - `SHOPIFY_API_SECRET` - Shopify API secret
   - `SHOPIFY_ACCESS_TOKEN` - Store access token
   - `SHOPIFY_STORE_DOMAIN` - `aodrop.com`

## Step 4: Issue Templates

Issue templates are automatically created in `.github/ISSUE_TEMPLATE/`:
- `task.md` - Task tracking template
- `bug.md` - Bug report template
- `feature.md` - Feature request template

## Step 5: GitHub Projects Setup

1. Go to: https://github.com/toodeceptive/against-the-odds/projects
2. Create new project: "Against The Odds - Development"
3. Configure columns:
   - Backlog
   - To Do
   - In Progress
   - Review
   - Done
4. Enable automation:
   - Auto-move issues based on labels
   - Auto-close issues when PR merged

## Step 6: Workflow Verification

After setting up GitHub Actions workflows:

1. **Test CI Workflow**:
   ```powershell
   # Make a test commit
   git checkout -b test/ci-workflow
   echo "# Test" >> TEST.md
   git add TEST.md
   git commit -m "test: verify CI workflow"
   git push origin test/ci-workflow
   ```

2. **Check Actions Tab**:
   - Go to: https://github.com/toodeceptive/against-the-odds/actions
   - Verify workflow runs successfully

3. **Create Test PR**:
   - Create pull request from `test/ci-workflow` to `main`
   - Verify status checks appear
   - Merge after verification

## Step 7: Automation Scripts

Automation scripts are located in `scripts/git/`:
- `auto-commit.ps1` - Automated commit with safety checks
- `auto-push.ps1` - Automated push with conflict detection
- `sync-repo.ps1` - Complete sync workflow

## Verification Checklist

- [ ] PAT created and stored securely
- [ ] Authentication tested with `git push`
- [ ] Branch protection rules configured
- [ ] Repository settings configured
- [ ] GitHub Actions secrets added
- [ ] Issue templates created
- [ ] GitHub Projects board set up
- [ ] CI workflow tested and verified
- [ ] Automation scripts functional

## Troubleshooting

### Authentication Issues

See `config/github-auth.md` for detailed troubleshooting.

### Workflow Failures

1. Check Actions tab for error messages
2. Verify secrets are correctly set
3. Check workflow file syntax
4. Review workflow logs

### Permission Issues

1. Verify PAT has correct scopes
2. Check repository access permissions
3. Verify branch protection rules aren't blocking

## Next Steps

1. Complete Shopify integration (see `docs/SHOPIFY_SETUP.md`)
2. Set up environment configuration (see `.env.example`)
3. Configure automated workflows
4. Set up project management system

## References

- [GitHub Authentication](https://docs.github.com/en/authentication)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Branch Protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches)
- [GitHub Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
