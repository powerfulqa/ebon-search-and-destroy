## Project Status (2026-03-05)

### Completed ✅
- Rare NPC table generation pipeline (`tools/extract_npcscan_rare_tables.ps1` → `_NPCScan/generated_npcscan_rare_tables.lua`)
- Nameplate scanning fully working (`nameplate1..40` `UnitName()` + `UnitClassification()` + reaction filter)
- `DisableCache = true` + `/npcscan clearcache` (no permanent suppression)
- Full alert chain: sound + button + purple nameplate overlay
- Releases: `v1.2.7` (name scan), `v1.2.8` (debug cleanup)
- Field tested: Bayne, Farmer Solliden confirmed working

### Detection state
- ✅ `UnitReaction <= 4` (hostile filter)
- ✅ `UnitClassification == "rare"` / `"rareelite"`
- ✅ Name-based O(1) lookup from generated tables
- ❌ GUID parsing (intentionally disabled — server GUIDs don't contain NPC ID)

### Open items
- Zone-specific scanning toggle
- Configurable name list UI
- Test Outland/Northrend with nameplates OFF
- Clean up unrelated MobMap.lua edits
