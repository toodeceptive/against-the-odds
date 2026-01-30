# GitHub Authentication Configuration

## Overview

This document describes the GitHub authentication setup for the Against The Odds project. **No secrets are stored in this repository.**

## Authentication Methods

### Primary Method: Personal Access Token (PAT)

**Recommended for automated operations and CI/CD**

#### Creating a PAT

1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Set expiration (recommended: 90 days with auto-renewal)
4. Select scopes:
   - `repo` (Full control of private repositories)
   - `workflow` (Update GitHub Action workflows)
   - `write:packages` (Upload packages to GitHub Package Registry)
   - `read:org` (Read org and team membership, read org projects)
5. Generate token and **copy immediately** (won't be shown again)

#### Storing PAT Securely

**Windows Credential Manager (Recommended)**

```powershell
# Store PAT in Windows Credential Manager
cmdkey /generic:git:https://github.com /user:YOUR_GITHUB_USERNAME /pass:YOUR_PAT
```

**Environment Variable (Alternative)**

```powershell
# Set in user environment variables (not system-wide)
[System.Environment]::SetEnvironmentVariable('GITHUB_TOKEN', 'YOUR_PAT', 'User')
```

**Git Credential Manager (Automatic)**

- First push will prompt for credentials
- Enter username and PAT (not password)
- Credentials stored automatically in Windows Credential Manager

#### Testing Authentication

```powershell
# Test with git push
git push origin main

# Test with GitHub CLI (if installed)
gh auth status

# Test API access
curl -H "Authorization: token YOUR_PAT" https://api.github.com/user
```

### Alternative Method: SSH Keys

**Recommended for manual operations**

#### Generating SSH Key

```powershell
# Generate new SSH key
ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/github_ao

# Start SSH agent
Start-Service ssh-agent

# Add key to agent
ssh-add ~/.ssh/github_ao
```

#### Adding SSH Key to GitHub

1. Copy public key: `Get-Content ~/.ssh/github_ao.pub`
2. Go to GitHub Settings → SSH and GPG keys → New SSH key
3. Paste public key and save

#### Configuring Git for SSH

```powershell
# Update remote URL to SSH
git remote set-url origin git@github.com:toodeceptive/against-the-odds.git

# Test connection
ssh -T git@github.com
```

## Current Configuration

- **Remote URL**: `https://github.com/toodeceptive/against-the-odds.git`
- **Protocol**: HTTPS (recommended for automated operations)
- **Credential Helper**: Windows Credential Manager
- **Status**: ✅ Configured

## Security Best Practices

1. **Never commit tokens to repository**
   - Use `.env.local` (gitignored) for local development
   - Use GitHub Secrets for CI/CD workflows
   - Use Windows Credential Manager for local automation

2. **Rotate tokens regularly**
   - Set expiration dates
   - Revoke unused tokens
   - Monitor token usage in GitHub settings

3. **Use minimal required scopes**
   - Only grant necessary permissions
   - Review token scopes periodically

4. **Audit token usage**
   - Check GitHub security log regularly
   - Monitor for unauthorized access

## Troubleshooting

### Authentication Failures

**Issue**: `fatal: Authentication failed`

**Solutions**:

1. Verify PAT is valid and not expired
2. Check credential manager: `cmdkey /list`
3. Clear cached credentials: `cmdkey /delete:git:https://github.com`
4. Re-authenticate with new credentials

### Permission Denied

**Issue**: `Permission denied (publickey)` or `403 Forbidden`

**Solutions**:

1. Verify token has correct scopes
2. Check repository access permissions
3. Verify SSH key is added to GitHub account
4. Test with: `gh auth status` or `git ls-remote origin`

## Next Steps

1. Create PAT with required scopes
2. Store PAT securely using one of the methods above
3. Test authentication with `git push`
4. Configure GitHub Actions secrets (if needed)
5. Document any additional authentication requirements

## References

- [GitHub Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [Git Credential Manager](https://github.com/GitCredentialManager/git-credential-manager)
- [GitHub CLI Authentication](https://cli.github.com/manual/gh_auth)
