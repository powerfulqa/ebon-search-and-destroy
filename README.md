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

## Deploy
```powershell
powershell -ExecutionPolicy Bypass -File tools/deploy-addons.ps1
```
## WoW version
WotLK 3.3.5a — Interface: 30300
