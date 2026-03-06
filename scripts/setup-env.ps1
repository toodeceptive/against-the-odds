# Environment setup script
# Helps configure environment variables securely

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Environment Setup Script ===" -ForegroundColor Cyan
Write-Host ""

# Check if .env.local exists
$envLocalPath = ".env.local"
if (Test-Path $envLocalPath) {
    Write-Host ".env.local already exists." -ForegroundColor Yellow
    $response = Read-Host "Overwrite? (y/n)"
    if ($response -ne "y") {
        Write-Host "Exiting without changes." -ForegroundColor Yellow
        exit 0
    }
}

# Copy example file
if (Test-Path ".env.example") {
    Copy-Item ".env.example" $envLocalPath
    Write-Host "[OK] Created .env.local from .env.example" -ForegroundColor Green
} else {
    Write-Host "[FAIL] .env.example not found" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Please edit .env.local and fill in your values:" -ForegroundColor Yellow
Write-Host "1. GitHub Personal Access Token" -ForegroundColor White
Write-Host "2. Shopify API credentials" -ForegroundColor White
Write-Host "3. Any other required API keys" -ForegroundColor White
Write-Host ""
Write-Host "Credentials remain in .env.local only; this repo does not support storing secrets in User-scope environment variables." -ForegroundColor Cyan

Write-Host ""
Write-Host "[OK] Environment setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Edit .env.local with your actual values" -ForegroundColor White
Write-Host "2. Never commit .env.local to the repository" -ForegroundColor White
Write-Host "3. Run .\scripts\setup\full-setup.ps1 for guided credential setup and verification" -ForegroundColor White
Write-Host "4. Use GitHub Secrets for CI/CD workflows" -ForegroundColor White
