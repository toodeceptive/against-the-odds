<#
.SYNOPSIS
  Apply session-start hook to superpowers plugin cache.
.DESCRIPTION
  Copies the chosen hook script to the superpowers hooks directory.
  Options: disable (no injection), ao (AO backup with superpowers), or restore from backup.
.PARAMETER Mode
  disable = no-op, empty context
  ao      = AO backup (superpowers using-superpowers skill)
.EXAMPLE
  .\apply-session-start-hook.ps1 -Mode disable
#>
param(
    [ValidateSet('disable', 'ao')]
    [string]$Mode = 'disable'
)
$ErrorActionPreference = 'Stop'
$hooksDir = Join-Path $env:USERPROFILE '.cursor\plugins\cache\cursor-public\superpowers'
if (-not (Test-Path $hooksDir)) {
    Write-Error "Superpowers plugin not found at $hooksDir"
}
$targetDir = Get-ChildItem -Path $hooksDir -Directory | Where-Object { $_.Name -match '^[a-f0-9]{40}$' } | Select-Object -First 1
if (-not $targetDir) {
    Write-Error "Could not find plugin hash directory under $hooksDir"
}
$dest = Join-Path $targetDir.FullName 'hooks\session-start.sh'
$src = switch ($Mode) {
    'disable' { Join-Path $PSScriptRoot 'session-start-disable.sh' }
    'ao'      { Join-Path $PSScriptRoot 'session-start-ao-hook.sh' }
}
if (-not (Test-Path $src)) {
    Write-Error "Source not found: $src"
}
# For ao mode, we need the script to run FROM the plugin hooks dir so PLUGIN_ROOT is correct.
# session-start-ao-hook.sh expects to be in hooks/ - copy it
Copy-Item -Path $src -Destination $dest -Force
Write-Host "Applied $Mode to $dest"
