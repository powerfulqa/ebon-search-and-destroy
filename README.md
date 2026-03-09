# Ebonhold Search and Destroy

A rare NPC scanner and map overlay addon for **Project Ebonhold** (WotLK 3.3.5a private server).
Forked from _NPCScan 7.x (Saiket) and adapted for Ebonhold's GUID format and roguelite run structure.

---

## Features

- **Nameplate scanning** — polls `nameplate1..40` every frame using `UnitName`, `UnitReaction`, and `UnitClassification`
- **Target / mouseover detection** — catches rares via `PLAYER_TARGET_CHANGED` and `UPDATE_MOUSEOVER_UNIT`
- **Name-based matching** — GUID NPC ID extraction is disabled (Ebonhold GUIDs do not encode NPC ID)
- **DisableCache = true** by default — every session scans fresh; no persistent suppression of found NPCs
- **Multi-alert queue** — alerts stack; use the NavNext button to cycle through multiple finds
- **Alert button** — click to target the found mob; drag to reposition
- **Zone blacklist** — suppress scanning in specific zones
- **Map overlay** — EbonOverlay draws patrol paths on World Map and Minimap for tracked rares
- **Minimap button** — drag to reposition; click to open options
- **Rare database** — sourced from the PE-Questie Ebonhold DB via `tools/extract_npcscan_rare_tables.ps1`

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

> `/npcscan` is retained as a backward-compatible alias for `/esd`. It is not the primary command.

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

- **_NPCScan 7.x** — Saiket (original foundation)
- **SilverDragon** — Torhal (WotLK 3.3.5 patterns)
- **RareScanner** — Sariel (detection patterns)
- **Rare database** — PE-Questie / Xurkon (Ebonhold NPC data)
- **Ebonhold adaptations** — Serv (powerfulqa)