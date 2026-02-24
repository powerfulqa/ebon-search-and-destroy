param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$AddOnsPath = 'G:\Project Ebonhold\Ebonhold\Interface\AddOns'
)

$ErrorActionPreference = 'Stop'

$sourceNpcScan = Join-Path $RepoRoot '_NPCScan'
$sourceOverlay = Join-Path $RepoRoot '_NPCScanOverlay'

$destNpcScan = Join-Path $AddOnsPath '_NPCScan'
$destOverlay = Join-Path $AddOnsPath '_NPCScan.Overlay'

if (-not (Test-Path $RepoRoot)) {
    throw "Repo path not found: $RepoRoot"
}
if (-not (Test-Path $AddOnsPath)) {
    throw "AddOns path not found: $AddOnsPath"
}
if (-not (Test-Path $sourceNpcScan)) {
    throw "Source addon folder not found: $sourceNpcScan"
}
if (-not (Test-Path $sourceOverlay)) {
    throw "Source addon folder not found: $sourceOverlay"
}

Write-Host "Syncing _NPCScan..."
robocopy $sourceNpcScan $destNpcScan /MIR /R:1 /W:1 /FFT /NFL /NDL /NJH /NJS /NP | Out-Null
$npcScanCode = $LASTEXITCODE

Write-Host "Syncing _NPCScan.Overlay..."
robocopy $sourceOverlay $destOverlay /MIR /R:1 /W:1 /FFT /NFL /NDL /NJH /NJS /NP | Out-Null
$overlayCode = $LASTEXITCODE

if ($npcScanCode -ge 8 -or $overlayCode -ge 8) {
    throw "Deploy failed. robocopy exit codes: _NPCScan=$npcScanCode Overlay=$overlayCode"
}

Write-Host "Deploy complete. robocopy exit codes: _NPCScan=$npcScanCode Overlay=$overlayCode"
