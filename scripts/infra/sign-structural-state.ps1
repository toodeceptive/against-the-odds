# Generate infra/STRUCTURAL_STATE.json and sign it.
# Run locally after structural changes; never in CI.
# See docs/VERSION_POLICY.md, AGENTS.md, infra/README.md
# Requires: ssh-keygen (OpenSSH)

$ErrorActionPreference = "Stop"
$repoRoot = if ($PSScriptRoot) {
    (Resolve-Path (Join-Path $PSScriptRoot ".." "..")).Path
} else {
    (Get-Location).Path
}
Set-Location $repoRoot

$infraDir = Join-Path $repoRoot "infra"
if (-not (Test-Path $infraDir)) { New-Item -ItemType Directory -Path $infraDir -Force | Out-Null }

# Canonical list of structural files (sorted)
$structuralFiles = @(
    "AGENTS.md",
    "CODEOWNERS",
    "docs/OWNERSHIP_REGISTRY.md",
    "docs/SSOT_ATO.md",
    "docs/VERSION_POLICY.md",
    ".github/workflows/ci.yml"
) | Sort-Object

$files = @{}
foreach ($rel in $structuralFiles) {
    $path = Join-Path $repoRoot $rel
    if (Test-Path $path) {
        $content = Get-Content -Path $path -Raw -Encoding UTF8
        $hash = [System.BitConverter]::ToString(
            [System.Security.Cryptography.SHA256]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($content))
        ) -replace "-", ""
        $files[$rel] = $hash.ToLowerInvariant()
    }
}

$state = @{
    version   = 1
    timestamp = (Get-Date -Format "o")
    files     = $files
}
$stateJson = $state | ConvertTo-Json -Depth 10
$statePath = Join-Path $infraDir "STRUCTURAL_STATE.json"
$stateJson | Set-Content -Path $statePath -Encoding UTF8 -NoNewline
Write-Host "[OK] Wrote $statePath" -ForegroundColor Green

# Sign with ssh-keygen
$keyPath = if ($env:USERPROFILE) {
    Join-Path $env:USERPROFILE ".ssh" "structural_key"
} else {
    Join-Path $env:HOME ".ssh" "structural_key"
}
$pubPath = Join-Path $infraDir "structural.pub"
$sigPath = Join-Path $infraDir "STRUCTURAL_SIGNATURE.txt"

# Ensure key exists
if (-not (Test-Path $keyPath)) {
    $keyDir = Split-Path $keyPath
    if (-not (Test-Path $keyDir)) { New-Item -ItemType Directory -Path $keyDir -Force | Out-Null }
    Write-Host "Generating signing key at $keyPath ..." -ForegroundColor Yellow
    ssh-keygen -t ed25519 -f $keyPath -N '""' -C "structural-signing@against-the-odds"
    Copy-Item "$keyPath.pub" $pubPath -Force
    Write-Host "[OK] Created key and saved public key to $pubPath" -ForegroundColor Green
} elseif (-not (Test-Path $pubPath)) {
    Copy-Item "$keyPath.pub" $pubPath -Force
    Write-Host "[OK] Saved public key to $pubPath" -ForegroundColor Green
}

# Sign (ssh-keygen -Y sign)
# Note: On Windows, native ssh-keygen may hang on stdin redirect.
# If this step fails, run: bash scripts/infra/sign-structural-state.sh (from Git Bash or WSL)
$cmd = "ssh-keygen -Y sign -f `"$keyPath`" -n file < `"$statePath`" > `"$sigPath`" 2>nul"
$job = Start-Job { param($c) cmd /c $c } -ArgumentList $cmd
$done = Wait-Job $job -Timeout 15
if ($done -and (Test-Path $sigPath) -and ((Get-Item $sigPath).Length -gt 0)) {
    Write-Host "[OK] Signed and wrote $sigPath" -ForegroundColor Green
} else {
    Stop-Job $job -ErrorAction SilentlyContinue
    Remove-Job $job -Force -ErrorAction SilentlyContinue
    if (Get-Command wsl -ErrorAction SilentlyContinue) {
        $root = (Get-Location).Path
        $wslRoot = "/mnt/" + $root[0].ToString().ToLower() + $root.Substring(2).Replace('\', '/')
        wsl -e bash -c "cd '$wslRoot' && ./scripts/infra/sign-structural-state.sh" 2>$null
        if ((Test-Path $sigPath) -and ((Get-Item $sigPath).Length -gt 0)) {
            Write-Host "[OK] Signed via WSL and wrote $sigPath" -ForegroundColor Green
        } else {
            Write-Host "Run: bash scripts/infra/sign-structural-state.sh (Git Bash or WSL)" -ForegroundColor Yellow
            exit 1
        }
    } else {
        Write-Host "Run: bash scripts/infra/sign-structural-state.sh (Git Bash or WSL)" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""
Write-Host "Next: Commit infra/STRUCTURAL_STATE.json, infra/STRUCTURAL_SIGNATURE.txt, infra/structural.pub" -ForegroundColor Cyan
