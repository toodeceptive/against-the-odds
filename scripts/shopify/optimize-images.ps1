# Optimize brand (and optionally theme) images using sharp. Web (default) or embroidery-ready preset.
# Run from repo root: .\scripts\shopify\optimize-images.ps1 [-Theme] [-Preset embroidery] [-MaxWidth 2000] [-Quality 85]

param(
    [switch]$Theme = $false,
    [string]$Preset = '',
    [int]$MaxWidth = 0,
    [int]$Quality = 0
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) {
    (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
} else {
    (Get-Location).Path
}
Set-Location $repoPath

$env:ATO_REPO_ROOT = $repoPath
$nodeArgs = @()
if ($Preset) { $nodeArgs += "--preset=$Preset" }
if ($MaxWidth -gt 0) { $nodeArgs += "--max-width=$MaxWidth" }
if ($Quality -gt 0) { $nodeArgs += "--quality=$Quality" }
if ($Theme) { $nodeArgs += "--theme" }

$scriptDir = Join-Path $repoPath "scripts\shopify"
& node (Join-Path $scriptDir "optimize-images.mjs") @nodeArgs
$exitCode = $LASTEXITCODE
$env:ATO_REPO_ROOT = $null
exit $exitCode
