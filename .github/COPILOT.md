## Context for EbonSearch / EbonOverlay

**Project**: Ebonhold Search and Destroy v2.1.4
**Client**: WotLK 3.3.5a (Interface 30300), Project Ebonhold private server
**Forked from**: _NPCScan 7.x (Saiket), renamed and adapted in v2.0.0

---

### Why the fork was necessary

Ebonhold's private core uses raw hex GUIDs (`0xF13000060B684A99`) that do **not** encode NPC ID in a retail-compatible way. GUID-based NPC ID extraction is therefore disabled permanently. Detection is name-driven using `nameplate1..40` unit tokens.

---

### Architecture

- **Detection**: OnUpdate loop over `nameplate1..40` - `UnitExists` → `UnitName` → match against rare name table
- **Fast-path detection**: `NAME_PLATE_UNIT_ADDED` event → instant check on nameplate appearance
- **Secondary detection**: `PLAYER_TARGET_CHANGED` / `UPDATE_MOUSEOVER_UNIT` events
- **Alert pipeline**: `TriggerFoundAlert` / `OnFound` → `me.Button:SetNPC(ID, Name)` → `Overlays.Found(ID, Name)` → `NPCFound(NpcID, Name)`
- **Overlay**: EbonOverlay draws patrol paths; `EbonOverlay.PathData.lua` contains binary triangle coordinate strings - **never re-save as UTF-8**
- **UV guard** (`ApplyTransform`): triangles whose computed UV values exceed ±100 are hidden. Do **not** clamp UVs to `[0,1]` — legitimate rotated triangles produce UVs in ~`[-5, 5]`.
- **Debounce**: `WasRecentlyDetected(Name)` — 3-second window keyed by Name only (`UnitGUID` unreliable on 3.3.5a)
- **Rare data**: generated from PE-Questie DB via `tools/extract_npcscan_rare_tables.ps1` → `EbonSearch/generated_npcscan_rare_tables.lua`
- **Minimap button**: 31x31 frame, 3-layer stack (BACKGROUND/ARTWORK/OVERLAY), dragon icon (`INV_Misc_Head_Dragon_Bronze`), drag-to-reposition

---

### Key constraints (never change)

- **Never** re-enable GUID → NPC ID parsing
- **Never** revert to `WorldFrame:GetChildren()` nameplate scanning
- **Never** re-save `EbonOverlay/EbonOverlay.PathData.lua` as UTF-8 (binary strings will corrupt)
- `DisableCache = true` is the default; do not change unless explicitly asked
- Primary slash command is `/esd`; `/npcscan` is a backward-compat alias only - do not advertise it

---

### Commands

- Primary: `/esd` (subcommands: `add`, `remove`, `cache`, `clear`, `zone blacklist add|remove|list`)
- Dev: `/esd debug overlays` — dumps last `ApplyTransform` sample to chat
- Legacy alias: `/npcscan` → routes to the same ESD handler

---

### v2.1.4 Release Status

| Component | Status |
|---|---|
| Nameplate scanner (`nameplate1..40`) | Ready |
| `NAME_PLATE_UNIT_ADDED` fast-path detection | Ready |
| Target / mouseover detection | Ready |
| Multi-alert queue + NavNext button | Ready |
| Alert toast: click to target + auto skull marker | Ready |
| Zone blacklist (right-click minimap or `/esd zone blacklist`) | Ready |
| Minimap button with persisted drag position | Ready |
| EbonOverlay patrol paths on World Map + Minimap | Ready |
| Discovery pins (gold marker at detection position, persisted) | Ready |
| Rare DB from PE-Questie Ebonhold data | Ready |
| NPC Name threaded through full alert pipeline | Ready |
| Debounce keyed by Name only (GUID unreliable on 3.3.5a) | Ready |
| Dynamic target keybind (`EbonSearch_TargetButton`) | Ready |
| `/esd debug overlays` dev command | Ready |
| 112 Lua unit tests + GitHub Actions CI | Ready |

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
tests/         <- Lua unit tests (`lua tests/run_tests.lua`)
```

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
- `da2aa7e` - v2.1.0: dynamic target keybind; Name threading through overlay chain
- `54ceb68` - v2.1.1: NAME_PLATE_UNIT_ADDED fast-path; WasRecentlyDetected Name-only debounce
- `a223726` - v2.1.4: ApplyTransform UV magnitude guard (>100 = hide); fixes blocky paths
- `d1ed74d` - 112/112 Lua unit tests; `/esd debug overlays` dev command; GitHub Actions CI

---

### Credits

- Upstream: _NPCScan 7.x (Saiket)
- Patterns: SilverDragon (Torhal), RareScanner (Sariel)
- Rare data: Questie Ebonhold DB (Xurkon)
- Ebonhold adaptations: Serv (powerfulqa)
