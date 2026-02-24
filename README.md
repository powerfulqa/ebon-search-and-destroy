# ebon-search-and-destroy
WotLK 3.3.5a _NPCScan fork for Project Ebonhold private server.

## What it does
Scans for rare NPCs and fires a toast button when one is detected. Uses two parallel detection methods:
- **Nameplate scan** — passive always-on scanner reads nameplate FontStrings directly via C_NamePlate.GetNamePlates()
- **TestID/namecache scan** — original method for out-of-range detection, works for Outland/Northrend rares

## Repo structure
- `_NPCScan/` — main addon source
- `_NPCScanOverlay/` — overlay addon source
- `tools/deploy-addons.ps1` — deploys both addons to live game folder

## Deploy
```powershell
powershell -ExecutionPolicy Bypass -File tools/deploy-addons.ps1
```

## If detection stops working
Delete the saved vars file and reload:
G:\Project Ebonhold\Ebonhold\WTF\Account\SERV\Rogue-Lite (Live)\<CharName>\SavedVariables\_NPCScan.lua

## WoW version
WotLK 3.3.5a — Interface: 30300
