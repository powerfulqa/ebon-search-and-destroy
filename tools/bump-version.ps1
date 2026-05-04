# bump-version.ps1
# Single-source version bump for the ebon-search-and-destroy repo.
#
# All in-game version display (config-panel byline, watermark, minimap tooltip)
# reads from `## Version:` in each .toc via GetAddOnMetadata, so this script
# only needs to keep the literal-text duplicates in sync. Everything else
# updates automatically on the next /reload.
#
# Touchpoints (7 lines, 3 files):
#   EbonSearch/EbonSearch.toc        - ## Title [vX.Y.Z], ## Version, ## X-Date
#   EbonOverlay/EbonOverlay.toc      - ## Title [vX.Y.Z], ## Version, ## X-Date
#   README.md                        - H1 "# Ebonhold Search and Destroy vX.Y.Z"
#
# Usage:
#   .\tools\bump-version.ps1 2.2.5            # bump to 2.2.5 (date = today)
#   .\tools\bump-version.ps1 2.2.5 -DryRun    # show diffs, write nothing
#
# The repo's test suite (tests/test_version_sync.lua) verifies all 7 lines
# stay aligned, so a forgotten file or typo will fail CI. After running:
#   git diff                                  # eyeball the change
#   lua tests/run_tests.lua                   # confirm version-sync passes
#   git commit -am "chore(vX.Y.Z): bump"
#   git tag vX.Y.Z

param(
    [Parameter(Mandatory, Position=0)]
    [ValidatePattern('^\d+\.\d+\.\d+$')]
    [string]$Version,

    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$repo  = Split-Path -Parent $PSScriptRoot
$today = Get-Date -Format 'yyyy-MM-dd'

$targets = @(
    @{
        Path     = Join-Path $repo 'EbonSearch\EbonSearch.toc'
        Patterns = @(
            @{ Find = '^## Version:.*$';        Replace = "## Version: $Version" }
            @{ Find = '\[v\d+\.\d+\.\d+\]';     Replace = "[v$Version]" }
            @{ Find = '^## X-Date:.*$';         Replace = "## X-Date: $today" }
        )
    },
    @{
        Path     = Join-Path $repo 'EbonOverlay\EbonOverlay.toc'
        Patterns = @(
            @{ Find = '^## Version:.*$';        Replace = "## Version: $Version" }
            @{ Find = '\[v\d+\.\d+\.\d+\]';     Replace = "[v$Version]" }
            @{ Find = '^## X-Date:.*$';         Replace = "## X-Date: $today" }
        )
    },
    @{
        Path     = Join-Path $repo 'README.md'
        Patterns = @(
            @{ Find = '^# Ebonhold Search and Destroy v\d+\.\d+\.\d+'
               Replace = "# Ebonhold Search and Destroy v$Version" }
        )
    }
)

$totalChanges = 0
foreach ($t in $targets) {
    if (-not (Test-Path $t.Path)) {
        Write-Warning "Skipping $($t.Path) - not found"
        continue
    }
    $rel       = Resolve-Path -Relative $t.Path
    $original  = Get-Content -LiteralPath $t.Path -Raw
    $updated   = $original
    $fileHits  = 0
    foreach ($p in $t.Patterns) {
        $before = $updated
        $updated = [regex]::Replace($updated, $p.Find, $p.Replace, 'Multiline')
        if ($updated -ne $before) { $fileHits++ }
    }
    if ($updated -eq $original) {
        Write-Host "  unchanged  $rel"
        continue
    }
    $totalChanges += $fileHits
    if ($DryRun) {
        Write-Host "  would edit $rel ($fileHits line(s))" -ForegroundColor Yellow
        # Print a tiny diff so the user can sanity-check
        $origLines = $original -split "`r?`n"
        $newLines  = $updated  -split "`r?`n"
        for ($i = 0; $i -lt $origLines.Count; $i++) {
            if ($origLines[$i] -ne $newLines[$i]) {
                Write-Host "    -  $($origLines[$i])" -ForegroundColor Red
                Write-Host "    +  $($newLines[$i])"  -ForegroundColor Green
            }
        }
    } else {
        # Preserve original line endings; Set-Content -NoNewline keeps the file
        # exactly as-was apart from the regex substitution.
        Set-Content -LiteralPath $t.Path -Value $updated -NoNewline -Encoding utf8
        Write-Host "  updated    $rel ($fileHits line(s))" -ForegroundColor Green
    }
}

if ($totalChanges -eq 0) {
    Write-Host "`nNothing to do - all files already at v$Version."
    exit 0
}

if ($DryRun) {
    Write-Host "`nDry run complete. $totalChanges line(s) would change. Re-run without -DryRun to apply."
} else {
    Write-Host "`nBumped to v$Version (date $today). Next steps:"
    Write-Host "  lua tests\run_tests.lua         # version-sync test should pass"
    Write-Host "  git diff                         # eyeball"
    Write-Host "  git commit -am `"chore(v$Version): bump`""
    Write-Host "  git tag v$Version"
    Write-Host "  git push --follow-tags"
}
