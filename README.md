# ebon-search-and-destroy
WotLK 3.3.5a _NPCScan fork for a custom server environment.

## What it does
Scans for rare NPCs and fires a toast button when one is detected. Uses two parallel detection methods:
- **Nameplate scan** — passive always-on scanner reads nameplate FontStrings directly via C_NamePlate.GetNamePlates()
- **TestID/namecache scan** — original method for out-of-range detection, works for Outland/Northrend rares

## Repo structure
- `_NPCScan/` — main addon source
- `_NPCScanOverlay/` — overlay addon source
- `tools/deploy-addons.ps1` — deploys both addons to your WoW `Interface/AddOns` folder
- `tools/extract_npcscan_rare_tables.ps1` — regenerates rare NPC tables from PE-Questie into `_NPCScan/`

## Deploy
```powershell
powershell -ExecutionPolicy Bypass -File tools/deploy-addons.ps1
```

## Automated rare NPC extraction workflow

### Run
From repo root:

```powershell
powershell -ExecutionPolicy Bypass -File tools/extract_npcscan_rare_tables.ps1
```

### What it does
- Downloads fresh PE-Questie DB files used as source of truth for rare NPC data.
- Filters/merges rare NPC entries (including Ebonhold data) into _NPCScan table format.
- Writes generated output to:
	- `_NPCScan/generated_npcscan_rare_tables.lua`

### Commit + release flow
After validating generated output:

```powershell
git add _NPCScan/generated_npcscan_rare_tables.lua _NPCScan/_NPCScan.toc tools/extract_npcscan_rare_tables.ps1
git commit -m "chore: refresh generated rare npc tables"
git push origin main

# release tag example
git tag -a vX.Y.Z -m "vX.Y.Z"
git push origin vX.Y.Z
```

## WoW version
WotLK 3.3.5a — Interface: 30300
