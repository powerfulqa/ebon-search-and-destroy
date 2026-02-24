# Tools

## PathData/ZoneData generator

This script generates standalone Lua files from a JSON input describing vanilla rare NPC spawn points.

### Input

Create or edit tools/vanilla_rares.json with this structure:

```json
{
  "zones": [
    {
      "mapID": 1,
      "width": 1100,
      "height": 900,
      "zoneName": "Elwynn Forest",
      "npcs": [
        { "id": 2938, "name": "Bhag'thera", "x": 0.51, "y": 0.62 },
        { "id": 2942, "name": "Morgan the Collector", "x": 0.44, "y": 0.38 }
      ]
    }
  ]
}
```

Notes:
- x/y are normalized coordinates in the range 0.0 to 1.0.
- mapID, width, height use the values from WoW 3.3.5a map data.

### Run

From the repo root:

```sh
node tools/generate_pathdata.js
```

### Output

The script writes:
- tools/output/PathData_vanilla.lua
- tools/output/ZoneData_vanilla.lua

PathData encodes a minimal single-point path for each NPC using a 12-byte record where all three points are identical.

### Updating data

To add or update a spawn:
1. Edit tools/vanilla_rares.json.
2. Ensure x/y are normalized (divide in-game map percentages by 100).
3. Re-run the script.

## Addon deploy script

Use this script to sync the repo addons into your live WoW AddOns folder with the required names:
- `_NPCScan` -> `_NPCScan`
- `_NPCScanOverlay` -> `_NPCScan.Overlay`

### Run (default paths)

From the repo root:

```powershell
powershell -ExecutionPolicy Bypass -File tools/deploy-addons.ps1
```

Defaults:
- RepoRoot: parent folder of `tools/`
- AddOnsPath: `G:\Project Ebonhold\Ebonhold\Interface\AddOns`

### Run (custom paths)

```powershell
powershell -ExecutionPolicy Bypass -File tools/deploy-addons.ps1 -RepoRoot "C:\Users\Chris\ebon-search-and-destroy" -AddOnsPath "G:\Project Ebonhold\Ebonhold\Interface\AddOns"
```
