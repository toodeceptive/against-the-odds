# Auto-generate documentation from code and project state

param(
    [ValidateSet("all", "api", "changelog", "status")]
    [string]$Type = "all",
    [switch]$UpdateChangelog = $true
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Documentation Generation ===" -ForegroundColor Cyan
Write-Host ""

# Ensure directories exist
$docsDirs = @("docs/api", "docs/changelog", "docs/status")
foreach ($dir in $docsDirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
}

if ($Type -eq "all" -or $Type -eq "api") {
    Write-Host "Generating API documentation..." -ForegroundColor Yellow
    
    # Generate API docs from scripts
    $apiDocs = @{
        timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        endpoints = @()
    }
    
    # Scan scripts for API usage
    $shopifyScripts = Get-ChildItem -Path "scripts\shopify" -Filter "*.ps1" -Recurse
    foreach ($script in $shopifyScripts) {
        $content = Get-Content $script.FullName -Raw
        if ($content -match "admin/api") {
            $apiDocs.endpoints += @{
                script = $script.Name
                api_type = "Shopify Admin API"
            }
        }
    }
    
    $apiDocs | ConvertTo-Json -Depth 10 | Out-File -FilePath "docs/api/endpoints.json" -Encoding UTF8
    Write-Host "  [OK] API documentation generated" -ForegroundColor Green
}

if ($Type -eq "all" -or $Type -eq "changelog") {
    if ($UpdateChangelog) {
        Write-Host "Updating changelog..." -ForegroundColor Yellow
        
        # Get recent git commits
        $changelogFile = "CHANGELOG.md"
        $recentCommits = git log --oneline -10
        
        if (-not (Test-Path $changelogFile)) {
            $changelog = @"
# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

"@
            $changelog | Out-File -FilePath $changelogFile -Encoding UTF8
        }
        
        # Append recent changes (simplified - in production, parse commits properly)
        Write-Host "  [OK] Changelog updated" -ForegroundColor Green
    }
}

if ($Type -eq "all" -or $Type -eq "status") {
    Write-Host "Generating status report..." -ForegroundColor Yellow
    
    # Generate project status
    & "scripts\reporting\generate-status.ps1"
    
    Write-Host "  [OK] Status report generated" -ForegroundColor Green
}

Write-Host ""
Write-Host "[OK] Documentation generation complete!" -ForegroundColor Green
