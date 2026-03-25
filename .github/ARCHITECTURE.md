## Context for EbonSearch / EbonOverlay

**Project**: Ebonhold Search and Destroy v2.1.5+
**Client**: WotLK 3.3.5a (Interface 30300), Project Ebonhold private server
**Forked from**: _NPCScan 7.x (Saiket), renamed and adapted in v2.0.0

---

### Why the fork was necessary

Ebonhold's private core uses raw hex GUIDs (`0xF13000060B684A99`) that do **not** encode NPC ID in a retail-compatible way. GUID-based NPC ID extraction is therefore disabled permanently. Detection is name-driven using `nameplate1..40` unit tokens.

---

### Architecture

- **Detection**: OnUpdate loop over `nameplate1..40` - `UnitExists` → `UnitName` → match against rare name table
- **Fast-path detection**: `NAME_PLATE_UNIT_ADDED` event → instant check on nameplate appearance (no OnUpdate delay)
- **Secondary detection**: `PLAYER_TARGET_CHANGED` / `UPDATE_MOUSEOVER_UNIT` events
- **Alert pipeline**: `TriggerFoundAlert` / `OnFound` → `me.Button:SetNPC(ID, Name)` → `Overlays.Found(ID, Name)` → `NPCFound(NpcID, Name)`
- **Overlay**: EbonOverlay draws patrol paths; `EbonOverlay.PathData.lua` contains binary triangle coordinate strings - **never re-save as UTF-8**
- **UV guard** (`ApplyTransform`): triangles whose computed UV values exceed `±100` are hidden (degenerate extreme-zoom artefacts). Do **not** clamp UVs to `[0,1]` — legitimate rotated triangles produce UVs in ~`[-5, 5]` and clamping distorts them.
- **Rare data**: generated from PE-Questie DB via `tools/extract_npcscan_rare_tables.ps1` → `EbonSearch/generated_npcscan_rare_tables.lua`
- **Minimap button**: 31x31 frame, 3-layer stack (BACKGROUND/ARTWORK/OVERLAY), dragon icon (`INV_Misc_Head_Dragon_Bronze`), drag-to-reposition

### Detection Pipeline (v2.1.1)

```
NAME_PLATE_UNIT_ADDED  →  TriggerFoundAlert  →  Button:SetNPC(Name)  →  Overlays.Found(ID, Name)  ✓
ScanTrackedNameplates (0.3s)  →  WasRecentlyDetected(Name)  →  BLOCKED (debounced)          ✓
me.Frame:ScanNameplates (0.5s)  →  WasRecentlyDetected(Name)  →  BLOCKED (debounced)         ✓
```

### Debounce Key (v2.1.1)

- **Key**: `Name` only — `UnitGUID("nameplateN")` is unreliable on WotLK 3.3.5a and returns `nil` between ticks, creating a different key each call and bypassing debounce
- `WasRecentlyDetected(Name)` — 3-second window; keyed by stable NPC name string
- All 5 call sites updated; `Guid` variable retained for logging only

---

### Key constraints (never change)

- **Never** re-enable GUID → NPC ID parsing
- **Never** revert to `WorldFrame:GetChildren()` nameplate scanning
- **Never** re-save `EbonOverlay/EbonOverlay.PathData.lua` as UTF-8 (binary strings will corrupt)
- `DisableCache = true` is the default; do not change unless explicitly asked
- Primary slash command is `/esd`; `/npcscan` is a backward-compat alias only - do not advertise it

---

### Commands

- Primary: `/esd` (subcommands: `add`, `remove`, `cache`, `clear`, `zone blacklist add|remove|list`, `wildlife add|remove|list`)
- Dev: `/esd debug overlays` — dumps last `ApplyTransform` sample (Det, 8 UVs, max|UV|, hidden flag) to chat; useful for verifying UV guard behaviour without a profiler
- Dev: `/esd misfire` — prints last 10 `ProcessUnitForRares` classification hits for diagnosing false positives
- Legacy alias: `/npcscan` → routes to the same ESD handler

---

### Current Release Status (v2.1.5+)

| Component | Status |
|---|---|
| Nameplate scanner (`nameplate1..40`) | Ready |
| `NAME_PLATE_UNIT_ADDED` fast-path detection | Ready |
| Target / mouseover detection | Ready |
| Multi-alert queue + NavNext button | Ready |
| Alert toast: click to target + auto skull marker | Ready |
| Zone blacklist (right-click minimap or `/esd zone blacklist`) — persists across sessions | Ready |
| Wildlife filter + user-editable blacklist (`/esd wildlife add|remove|list`) | Ready |
| Minimap button with persisted drag position | Ready |
| EbonOverlay patrol paths on World Map + Minimap | Ready |
| Discovery pins (gold marker at detection position, persisted) | Ready |
| Rare DB from PE-Questie Ebonhold data | Ready |
| NPC Name threaded through full alert pipeline | Ready |
| Debounce keyed by Name only (GUID unreliable on 3.3.5a) | Ready |
| Dynamic target keybind (`EbonSearch_TargetButton`) | Ready |
| `/esd debug overlays` + `/esd misfire` dev commands | Ready |
| 134 Lua unit tests + GitHub Actions CI | Ready |

### Known limitations

- Discovery pins only appear on zones covered by EbonOverlay's WorldMap module
- Overlay path data only exists for classic/TBC/WotLK rares in the original PathData set
- Ebonhold custom rares get a gold pin but no patrol path

---

### Addon folders (repo root)

```
EbonSearch/    <- was _NPCScan/
EbonOverlay/   <- was _NPCScanOverlay/
tools/         <- extractor + deploy scripts
tests/         <- Lua unit tests (run with `lua tests/run_tests.lua`)
```

---

### Test Infrastructure

- **Runner**: `tests/run_tests.lua` — assertion library + path-agnostic suite loader
- **Suites** (112 tests total):
  - `test_overlay_math.lua` — `ApplyTransform` Det guards, UV bounds, no-clamp regression (9 tests)
  - `test_detection.lua` — `WasRecentlyDetected` debounce window, expiry, stale pruning (9 tests)
  - `test_texture_geom.lua` — `TextureAdd` ScaleX/Y guards, `DrawPath` byte decoding, coord round-trip (9 tests)
  - `test_tracked_names.lua` — `TrackedNamesRebuild`, zone blacklist, dirty flag, duplicates (13 tests)
  - `test_localization.lua` — `Locale-enUS.lua` parse and key regression (8 tests)
  - `test_wildlife_blacklist.lua` — wildlife filter merge, user list add/remove, `FilterWildlife` bypass (9 tests)
- **CI**: `.github/workflows/tests.yml` — `lua5.4` on `ubuntu-latest`; triggers on push/PR touching `EbonSearch/**`, `EbonOverlay/**`, `tests/**`
- **Run locally**: `lua tests/run_tests.lua` from repo root (requires Lua 5.x in PATH)

---

### Key commits

- `v2.0.0-alpha1` - ProcessUnit + multi-alert queue + zone blacklist
- `v2.0.0-beta1` - namespace rename (_NPCScan → EbonSearch, _NPCScanOverlay → EbonOverlay)
- `54727a2` - PathData binary corruption fix (UTF-8 re-encoding)
- `0e1612f` - Ebonhold branding (light-blue colour codes)
- `b9530ec` - `/esd` slash command overhaul; `/npcscan` backward-compat alias
- `cfa9832` - Minimap icon restored to dragon (INV_Misc_Head_Dragon_Bronze)
- `9923527` - Docs rewrite (README, COPILOT, copilot-instructions)
- `25e84ea` - Toast QueueBadge overlap fix; Overlay Phase 2 discovery positions
- `334f6af` - Minimap angle persisted across login/reload
- `70fa40c` - NPCFound chat feedback
- `a5e9553` - Gold map pins for all detections including no-PathData NPCs
- `963b018` - Toast click: skull raid marker on targeted rare
- `13c9d7f` - Em dash removal across repo
- `e395100` - v2.0.0 release prep (TOC bump, README, tag)
- `da2aa7e` - v2.1.0: dynamic target keybind (EbonSearch_TargetButton); Name threading through overlay chain
- `54ceb68` - v2.1.1: NAME_PLATE_UNIT_ADDED fast-path; WasRecentlyDetected Name-only debounce; debug print cleanup
- `c379a1a` - v2.1.3: ApplyTransform Det < 1e-5 reject (reverted — too aggressive, killed legit path triangles)
- `a223726` - v2.1.4: ApplyTransform UV magnitude guard (>100 = hide); fixes blocky paths; confirmed via in-game debug
- `d1ed74d` - 112/112 Lua unit tests; `/esd debug overlays` dev command; GitHub Actions CI

---

### Credits

- Upstream: _NPCScan 7.x (Saiket)
- Patterns: SilverDragon (Torhal), RareScanner (Sariel)
- Rare data: Questie Ebonhold DB (Xurkon)
- Ebonhold adaptations: Serv (powerfulqa)
