param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$AddOnsPath = 'G:\Project Ebonhold\Ebonhold\Interface\AddOns'
)

$ErrorActionPreference = 'Stop'

$sourceNpcScan = Join-Path $RepoRoot 'EbonSearch'
$sourceOverlay = Join-Path $RepoRoot 'EbonOverlay'

$destNpcScan = Join-Path $AddOnsPath 'EbonSearch'
$destOverlay = Join-Path $AddOnsPath 'EbonOverlay'
$destOverlayLegacy = Join-Path $AddOnsPath '_NPCScanOverlay'

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

# Remove old _NPCScan folder from WoW if it still exists (renamed to EbonSearch)
$destLegacyNpcScan = Join-Path $AddOnsPath '_NPCScan'
if (Test-Path $destLegacyNpcScan) {
    Write-Host "Removing legacy _NPCScan folder from AddOns..."
    Remove-Item -Path $destLegacyNpcScan -Recurse -Force
}

Write-Host "Syncing EbonSearch..."
robocopy $sourceNpcScan $destNpcScan /MIR /R:1 /W:1 /FFT /NFL /NDL /NJH /NJS /NP | Out-Null
$npcScanCode = $LASTEXITCODE

Write-Host "Syncing EbonOverlay..."
robocopy $sourceOverlay $destOverlay /MIR /R:1 /W:1 /FFT /NFL /NDL /NJH /NJS /NP | Out-Null
$overlayCode = $LASTEXITCODE

if ((Test-Path $destOverlayLegacy) -and ($destOverlayLegacy -ne $destOverlay)) {
    Write-Host "Removing legacy overlay folder: _NPCScanOverlay"
    Remove-Item -Path $destOverlayLegacy -Recurse -Force
}

if ($npcScanCode -ge 8 -or $overlayCode -ge 8) {
    throw "Deploy failed. robocopy exit codes: EbonSearch=$npcScanCode EbonOverlay=$overlayCode"
}

Write-Host "Deploy complete. robocopy exit codes: EbonSearch=$npcScanCode EbonOverlay=$overlayCode"
