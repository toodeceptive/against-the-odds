# Optimize GitHub repository settings

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== GitHub Repository Optimization ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "Repository Optimization Recommendations:" -ForegroundColor Yellow
Write-Host ""

Write-Host "1. Repository Settings:" -ForegroundColor Cyan
Write-Host "   - Description: Official Against The Odds (AO) brand website and Shopify store" -ForegroundColor White
Write-Host "   - Topics: e-commerce, shopify, streetwear, brand, merchandise" -ForegroundColor White
Write-Host "   - Website: https://aodrop.com" -ForegroundColor White
Write-Host ""

Write-Host "2. Branch Protection:" -ForegroundColor Cyan
Write-Host "   - Protect 'main' branch" -ForegroundColor White
Write-Host "   - Require pull request reviews" -ForegroundColor White
Write-Host "   - Require status checks to pass" -ForegroundColor White
Write-Host "   - Require branches to be up to date" -ForegroundColor White
Write-Host ""

Write-Host "3. GitHub Actions:" -ForegroundColor Cyan
Write-Host "   - Configure required secrets (see verify-secrets.ps1)" -ForegroundColor White
Write-Host "   - Enable workflow permissions" -ForegroundColor White
Write-Host ""

Write-Host "4. Repository Features:" -ForegroundColor Cyan
Write-Host "   - Enable Issues" -ForegroundColor White
Write-Host "   - Enable Projects" -ForegroundColor White
Write-Host "   - Enable Wiki (optional)" -ForegroundColor White
Write-Host "   - Enable Discussions (optional)" -ForegroundColor White
Write-Host ""

Write-Host "Manual Steps Required:" -ForegroundColor Yellow
Write-Host "1. Go to: https://github.com/toodeceptive/against-the-odds/settings" -ForegroundColor White
Write-Host "2. Update repository description and topics" -ForegroundColor White
Write-Host "3. Configure branch protection rules" -ForegroundColor White
Write-Host "4. Set up GitHub Actions secrets" -ForegroundColor White
Write-Host ""

Write-Host "For detailed instructions, see: .github/settings.optimization.md" -ForegroundColor Cyan
