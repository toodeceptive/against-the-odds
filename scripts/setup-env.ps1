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

# Optionally set environment variables in Windows
$response = Read-Host "Set environment variables in Windows? (y/n)"
if ($response -eq "y") {
    Write-Host ""
    Write-Host "Reading .env.local..." -ForegroundColor Yellow
    
    $envContent = Get-Content $envLocalPath
    foreach ($line in $envContent) {
        if ($line -match '^([A-Z_]+)=(.*)$' -and -not $line.StartsWith('#')) {
            $varName = $matches[1]
            $varValue = $matches[2]
            
            if (-not [string]::IsNullOrWhiteSpace($varValue) -and $varValue -ne "your_*_here") {
                [System.Environment]::SetEnvironmentVariable($varName, $varValue, 'User')
                Write-Host "  Set: $varName" -ForegroundColor Green
            }
        }
    }
    
    Write-Host ""
    Write-Host "[OK] Environment variables set in Windows (User scope)" -ForegroundColor Green
    Write-Host "Note: You may need to restart your terminal for changes to take effect." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[OK] Environment setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Edit .env.local with your actual values" -ForegroundColor White
Write-Host "2. Never commit .env.local to the repository" -ForegroundColor White
Write-Host "3. Use GitHub Secrets for CI/CD workflows" -ForegroundColor White
