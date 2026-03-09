## Project Status (2026-03-09)

### Completed v1.x ✅
- Rare NPC table generation pipeline (`tools/extract_npcscan_rare_tables.ps1` → `_NPCScan/generated_npcscan_rare_tables.lua`)
- Nameplate scanning using `nameplate1..40` + `UnitName()` + `UnitClassification()` + `UnitReaction()` filters (no GUID parsing)
- `DisableCache = true` by default; `/npcscan clearcache` wipes session + persistent state
- Full alert chain (sound + button + purple nameplate overlay) validated on Bayne, Farmer Solliden
- `v1.2.7` – nameplate1..40 scanning + DisableCache
- `v1.2.8` – debug / locale cleanup

### v2.0.0-alpha1 ✅ (2026-03-09)
- **Project renamed**: Ebonhold Search and Destroy - TOC Title/Notes updated on `_NPCScan` and `_NPCScanOverlay`
- **Multi-alert queue** (`_NPCScan.Button.lua`):
  - `AlertQueue` replaces single `PendingID/PendingName` slot
  - `Enqueue(ID, Name)` deduplicates, appends, shows immediately or on combat-end
  - `DequeueShow()` pops next item and calls `Update()`
  - `NavNext` arrow button anchored right of alert card; tooltip shows queued count; skips to next alert
  - `PLAYER_REGEN_ENABLED` drains queue when PendingID is absent
  - `OnHide` auto-advances queue on dismiss
- **ProcessUnit scanning** (`_NPCScan.lua`):
  - `ProcessUnitForRares(UnitID)` checks `UnitClassification`, `UnitReaction`, `UnitName` then fires `TriggerFoundAlert`
  - `PLAYER_TARGET_CHANGED` → `ProcessUnitForRares("target")` - catches rares targeted directly
  - `UPDATE_MOUSEOVER_UNIT` → `ProcessUnitForRares("mouseover")` - catches rares moused-over with nameplates off
  - Registered on the always-on `NameplateScanFrame` (not gated by `ScanIDs`)
- **Zone blacklist** (`_NPCScan.lua`):
  - `me.Options.ZoneBlacklist = {}` persisted in `_NPCScanOptions` SavedVariables
  - `ScanNameplates()` and `ScanTrackedNameplates()` both early-exit when `GetRealZoneText()` is blacklisted
  - `/esd zone blacklist add [zone]` - blacklist current or named zone
  - `/esd zone blacklist remove [zone]` - un-blacklist
  - `/esd zone blacklist list` - list all blacklisted zones

### Detection state
- ✅ `UnitReaction(unit) <= 4` filters friendlies; hostile rares confirmed with `reaction = 2` on this server
- ✅ `UnitClassification(unit) == "rare" or "rareelite"` filters normal mobs
- ✅ Tracked rare **names** stored in an O(1) lookup table built from generated rare data
- ✅ Target + mouseover fallback scanning for nameplate-off scenarios (v2.0.0)
- ❌ GUID NPC ID parsing intentionally disabled (private core GUIDs like `0xF13000060B684A99` don't embed NPC ID)

### Open items (v2.x backlog)
- LDB minimap icon + zone radar tooltip (SilverDragon-style)
- Full AceConfig panel replacing InterfaceOptions hand-roll
- RareScanner-style rich card button (parchment layout, filter buttons)
- Configurable in-game name list UI (add/remove rares without editing Lua)
- Field-test Outland / Northrend "legacy TestID" paths with nameplates OFF
