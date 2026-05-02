# Ebonhold Search and Destroy v2.2.4

[![Release](https://img.shields.io/github/v/release/powerfulqa/ebon-search-and-destroy?label=release&color=blue)](https://github.com/powerfulqa/ebon-search-and-destroy/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/powerfulqa/ebon-search-and-destroy/total?color=brightgreen)](https://github.com/powerfulqa/ebon-search-and-destroy/releases)
[![WoW](https://img.shields.io/badge/WoW-3.3.5a-orange)](https://github.com/powerfulqa/ebon-search-and-destroy)
[![Interface](https://img.shields.io/badge/Interface-30300-yellow)](https://github.com/powerfulqa/ebon-search-and-destroy)
[![License](https://img.shields.io/github/license/powerfulqa/ebon-search-and-destroy)](LICENSE)

### [⬇ Download latest version](https://github.com/powerfulqa/ebon-search-and-destroy/releases/latest/download/EbonSearch.Ebonhold.zip)

A rare NPC scanner and map overlay addon for **Project Ebonhold** (WotLK 3.3.5a private server).
Forked from _NPCScan 7.x (Saiket) and adapted for Ebonhold's GUID format and roguelite run structure.

---

## Features

- **Nameplate scanning** - polls `nameplate1..40` every frame using `UnitName`, `UnitReaction`, and `UnitClassification`
- **Target / mouseover detection** - catches rares via `PLAYER_TARGET_CHANGED` and `UPDATE_MOUSEOVER_UNIT`
- **Name-based matching** - GUID NPC ID extraction is disabled (Ebonhold GUIDs do not encode NPC ID)
- **DisableCache = true** by default - every session scans fresh; no persistent suppression of found NPCs
- **Multi-alert queue** - alerts stack; use the NavNext button to cycle through multiple finds
- **Alert button** - click to target the rare and auto-place a skull raid marker; drag to reposition
- **Unified trigger gate** - every detection path (target, mouseover, nameplate scan, NAME_PLATE_UNIT_ADDED, TestID cache fallback) consults a single `ShouldAlert` filter chain so wildlife/zone/classification/reaction coverage stays consistent; `/esd misfire` reports path + reject stage for diagnostics
- **Wildlife filter** - built-in list of known false-positive wildlife names (Plainsstrider, Reef Shark, etc.); user-extendable via `/esd wildlife add` without a code release; case-insensitive matching so `add giraffe` suppresses `Giraffe` at runtime
- **Zone blacklist** - suppress scanning in specific zones via right-click or slash command; passive paths skip blacklisted zones, manual target/mouseover still alerts
- **Map overlay** - EbonOverlay draws patrol paths on World Map and Minimap for tracked rares
- **Discovery pins** - gold map pin placed at the player's position each time a rare is detected, persisted across sessions
- **Minimap button** - drag to reposition (position saved); left-click to open options; right-click to toggle zone blacklist
- **Rare database** - sourced from the Questie-X-WotLKDB and Questie-X-EbonholdDB feeds via `tools/extract_npcscan_rare_tables.ps1`

---

## Install

1. Copy `EbonSearch/` and `EbonOverlay/` into `Interface/AddOns/`
2. Reload UI: `/reload`
3. Type `/esd` to open options

---

## Commands

| Command | Description |
|---|---|
| `/esd` | Open options panel |
| `/esd add <NpcID> <Name>` | Add a custom NPC to track |
| `/esd remove <NpcID or Name>` | Remove a custom NPC |
| `/esd cache` | List NPCs that are cached (unreachable this session) |
| `/esd clear` | Remove all custom NPCs and reset session state |
| `/esd zone blacklist add [zone]` | Blacklist current zone (or named zone) |
| `/esd zone blacklist remove [zone]` | Un-blacklist a zone |
| `/esd zone blacklist list` | List all blacklisted zones |
| `/esd wildlife add <name>` | Suppress a misfire by creature name (persists across sessions) |
| `/esd wildlife remove <name>` | Un-suppress a creature name |
| `/esd wildlife list` | List user-added wildlife suppression entries |
| `/esd debug overlays` | Dump last triangle's Det + UV values to chat (dev tool) |
| `/esd misfire` | Print last 10 classification hits from the nameplate scanner (dev tool) |

> `/npcscan` is retained as a backward-compatible alias for `/esd`. It is not the primary command.

---

## Development

Build-time unit tests run with standard Lua 5.x (no WoW client needed):

```powershell
lua tests/run_tests.lua
```

134 tests across 5 suites: `test_overlay_math`, `test_detection`, `test_texture_geom`, `test_tracked_names`, `test_wildlife_blacklist`. GitHub Actions (`.github/workflows/tests.yml`) runs these automatically on every push and pull request.

---

## File Structure

```text
Interface/AddOns/
├── EbonSearch/
│   ├── EbonSearch.toc
│   ├── EbonSearch.lua
│   ├── EbonSearch.Button.lua
│   ├── EbonSearch.Config.lua
│   ├── EbonSearch.Config.Search.lua
│   ├── EbonSearch.MinimapButton.lua
│   ├── EbonSearch.Overlays.lua
│   ├── EbonSearch.TamableIDs.lua
│   ├── EbonSearch.WowheadRares.lua
│   ├── generated_npcscan_rare_tables.lua
│   ├── Locales/
│   └── Libs/
└── EbonOverlay/
    ├── EbonOverlay.toc
    ├── EbonOverlay.lua
    ├── EbonOverlay.Config.lua
    ├── EbonOverlay.Modules.lua
    ├── EbonOverlay.PathData.lua
    ├── EbonOverlay.ZoneData.lua
    ├── Modules/
    ├── Locales/
    └── Libs/
```

---

## How detection works

The addon uses two detection methods running simultaneously:

**Nameplate scanner** (primary, Classic world rares)
Polls `nameplate1..40` unit tokens every frame. When a nameplate appears that matches a rare name from the Ebonhold/Classic database, an alert fires immediately. Built this way for Ebonhold specifically, because the server's GUIDs don't encode NPC IDs, making the old ID-based approach unreliable.

**Tooltip cache scan** (secondary, Outland and Northrend rares)
The original _NPCScan detection method. Checks the WoW client's internal creature cache using a tooltip hyperlink query (`TestID`). Runs alongside the nameplate scanner and handles Outland and Northrend rares where the original Wowhead rare list is the source of truth. Unchanged from the upstream addon.

Both methods feed into the same alert pipeline - queue, toast button, skull marker, and discovery pin.

---

## Server Compatibility

| Feature | Status |
|---|---|
| Unit token nameplates (`nameplate1..40`) | ✅ |
| Target / mouseover events | ✅ |
| Name-based rare matching | ✅ |
| GUID NPC ID extraction | ❌ not supported on this core |
| WorldFrame:GetChildren() nameplates | ❌ replaced by unit tokens |

---

## Acknowledgements

- **_NPCScan 7.x** - Saiket (original foundation)
- **SilverDragon** - Torhal (WotLK 3.3.5 patterns)
- **RareScanner** - Sariel (detection patterns)
- **Rare database** - PE-Questie / Xurkon (Ebonhold NPC data)
- **Ebonhold adaptations** - Serv (powerfulqa)

---

## Changelog

### v2.2.4 (2026-05-02)
- **Branded AddOns-list title**: TOC `## Title` for both addons now uses the standard WoW colour-code format - addon name in Ebonhold light blue (`|cff66ccff`), version badge in yellow (`|cffFFFF00[v2.2.4]|r`). Folder-matching short names (`EbonSearch`, `EbonOverlay`) replace the verbose `Ebonhold Search and Destroy` / `... (Overlay)` titles for a cleaner AddOns panel entry.
- TOC files carry a maintenance comment reminding you to keep the `[vX.Y.Z]` suffix in `## Title` synced with `## Version` on every bump.

### v2.2.3 (2026-04-28)
- **Unified `ShouldAlert` trigger gate**: every detection path (target, mouseover, ScanNameplates, ScanTrackedNameplates, NAME_PLATE_UNIT_ADDED, TestID cache fallback) now consults a single filter chain instead of five hand-rolled ones. Closes the architectural cause of recurring false-positive churn across v2.1.x/v2.2.x.
- **Path E (TestID cache fallback) now filtered**: previously fired with zero filtering whenever an active-scan NPC's name happened to be in the WoW client cache. Wildlife and zone blacklists now apply.
- **`OnFound` split**: gate runs *before* `NPCDeactivate`, so a filtered unit no longer silently drops from the active scan.
- **Case-insensitive wildlife matching**: `NormalizeName` (trim + collapse + lowercase) on the lookup side; verbatim `WildlifeBlacklist` preserved so `/esd wildlife list` reads naturally; normalized mirror rebuilt at `PLAYER_LOGIN`. Fixes the foot-gun where `/esd wildlife add giraffe` (lowercase) didn't suppress `Giraffe` at runtime.
- **`/esd misfire` extended**: ring-buffer entries now record path tag (`target`, `mouseover`, `scan`, `trackedscan`, `npua`, `cache`) and reject stage (`wildlife`, `classification`, etc.) for diagnosing future false-positives.
- Removed `GetNameplateTrackedMatch`; all three callers now use the gate.
- 24 new unit tests covering `NormalizeName` behaviour, case-insensitive lookup, add/remove case-fold round-trip, and `Synchronize` migration of mixed-case saved entries (163/163 passing).

### v2.2.2 (2026-04-28)
- **Refreshed rare table from Questie-X**: extractor repointed from `Xurkon/PE-Questie` (superseded) to `Xurkon/Questie-X-WotLKDB` (TBC + WotLK coverage) and `Xurkon/Questie-X-EbonholdDB`. Generated table grew from 328 -> 522 entries.
- **Tighter rank/zone filters**: WotLK source narrowed to `rank in {2, 4}` (Rare Elite + Rare per cmangos schema) with a curation whitelist for rank=1 entries (loaded from previous committed list via `git show HEAD:`) so established community-rares survive while fresh rank=1 elites are dropped. Default-deny zone resolution drops every unmapped TBC/WotLK instance and sub-zone (Karazhan, Black Temple, ICC, Coilfang, etc.) that was leaking through as `Zone NNNN`.
- **261 new rares added**: spot-checked - Mezzir the Howler, Bog Lurker, Marticar, Doomsayer Jurim, Icehorn, Arcturis, Skoll, Gondria, Mekthorg the Wild, Putridus the Ancient, etc.
- **67 entries removed**: mostly questgivers (Rexxar, Misha, Nathanos, Keeper Remulos) and Naxxramas adds. Real rares lost to upstream rank=0 retagging (Ursius, Brumeran, Borelgore, Duskwing, Vagash) remain covered by `OptionsCharacterDefault.NPCs`.
- Famous Northrend rares (Loque'nahak, Time-Lost Proto-Drake, Vyragosa, Skoll) remain tracked via `EbonSearch.WowheadRares.lua` and the legacy TestID cache scanner - unchanged.
- Parser rewritten to handle the WotLK DB's `_d[id] = {...}` prefix and multi-line entries via brace balancing.
- `.gitignore` collapsed to `tools/tmp_*.lua` wildcard so future extractor downloads are auto-ignored.

### v2.2.1 (2026-03-25)
- **Wildlife blacklist bypass in nameplate scan paths**: `GetNameplateTrackedMatch` had no wildlife check, so `ScanTrackedNameplates` (OnUpdate) and `NAME_PLATE_UNIT_ADDED` (event fast path) bypassed `WILDLIFE_BLACKLIST_BUILTIN` entirely. Any mob both blacklisted and present in the generated rare tables (e.g. Reef Shark, ID 12123) would fire on every nameplate appearance despite the v2.1.8 blacklist fix.
- One unified wildlife guard inside `GetNameplateTrackedMatch` covers all three callers (`ScanNameplates`, `ScanTrackedNameplates`, `NAME_PLATE_UNIT_ADDED`).
- 5 regression tests added (139/139 passing).

### v2.2.0 (2026-03-25)
- **User-editable wildlife blacklist**: `/esd wildlife add <name>` suppresses any misfire by creature name without a code release; entries persist across sessions in `EbonSearchDB`
- Built-in wildlife entries (`WILDLIFE_BLACKLIST_BUILTIN`) retained for confirmed server-wide misfires; user entries merge at detection time
- **Fixed ZoneBlacklist persistence**: blacklisted zones were silently lost on every `/reload` and relog; both `ZoneBlacklist` and `WildlifeBlacklist` are now restored from `EbonSearchDB` in `Synchronize()`
- Added 9 unit tests for wildlife filter merge logic (134/134 passing)

### v2.1.8 (2026-03-25)
- Suppressed `Rot Hide Bruiser` and `Vile Fin Shredder` false-positive wildlife misfires
- Suppressed `Reef Shark` false-positive wildlife misfire

### v2.1.7 (2026-03-24)
- **Barrens wildlife misfire fix**: `ProcessUnitForRares` now resolves `UnitName()` before `UnitClassification()` and rejects known false-rare wildlife (Plainsstrider, Ornery Plainsstrider, Giraffe, Barris Giraffe) via `WILDLIFE_BLACKLIST_BUILTIN`
- Added `FilterWildlife = true` option (default on); set to `false` to temporarily disable
- Added `/esd misfire` dev command: prints the last 10 non-blacklisted classification hits for diagnosing false positives

### v2.1.6 (2026-03-22)
- Fixed locale parse error in `Locale-enUS.lua` command string; added localization regression test

### v2.1.5 (2026-03-19)
- Bumped TOC Interface version; updated README

### v2.1.4 (2026-03-10)
- Fixed blocky minimap overlay paths: `ApplyTransform` now hides triangles whose UV values exceed ±100 (degenerate extreme-zoom triangles) instead of clamping all UVs to `[0,1]`. Clamping was distorting every rotated triangle
- Root cause confirmed via in-game debug: Det is healthy (0.24–0.96) on all normal triangles; crash-inducing values (e.g. `±28212`) only appear at extreme zoom and are correctly rejected by the new guard
- Added `/esd debug overlays` dev command: dumps last `ApplyTransform` sample (Det, all 8 UVs, max|UV|, hidden flag) to chat
- Added 112/112 Lua unit tests (`tests/`) and GitHub Actions CI

### v2.1.3 (2026-03-10)
- Intermediate fix: reject triangles with `Det < 1e-5`; reverted, threshold was too aggressive and killed legitimate path triangles

### v2.1.2 (2026-03-10)
- Hotfix: Clamp minimap TexCoord values to `[0, 1]` to prevent a `SetTexCoord` crash caused by extreme UV values (e.g. `-31242`) produced by minimap zoom math

### v2.1.1 (2026-03-10)
- Names everywhere (fixed ID prints in overlay alerts)
- Single-line alerts (no double-spam from overlay + scanner)
- Overlay pins + confirm message (`NpcName sighted - Recorded on Map`)
- WotLK 3.3.5a GUID debounce hardened: `WasRecentlyDetected` now keys by Name only (`UnitGUID` unreliable on this core)
- `NAME_PLATE_UNIT_ADDED` event fast-path: instant alert on nameplate appearance, no wait for next OnUpdate tick
- Dynamic target keybind (`EbonSearch_TargetButton`); bind any key to target the last detected rare

### v2.0.0 (2026-02-12)
- Initial fork from _NPCScan 7.x; renamed to EbonSearch / EbonOverlay
- Nameplate scanner (`nameplate1..40`), multi-alert queue, zone blacklist, discovery pins, minimap button
