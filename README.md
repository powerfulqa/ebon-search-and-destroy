# Ebonhold Search and Destroy v2.0.0

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
- **Zone blacklist** - suppress scanning in specific zones via right-click or slash command
- **Map overlay** - EbonOverlay draws patrol paths on World Map and Minimap for tracked rares
- **Discovery pins** - gold map pin placed at the player's position each time a rare is detected, persisted across sessions
- **Minimap button** - drag to reposition (position saved); left-click to open options; right-click to toggle zone blacklist
- **Rare database** - sourced from the PE-Questie Ebonhold DB via `tools/extract_npcscan_rare_tables.ps1`

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
| `/esd clearcache` | Alias for `/esd clear` |
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

## How detection works

The addon uses two detection methods running simultaneously:

**Nameplate scanner** (primary, Classic world rares)
Polls `nameplate1..40` unit tokens every frame. When a nameplate appears that matches a rare name from the Ebonhold/Classic database, an alert fires immediately. This was built specifically for Ebonhold because the server's GUIDs do not encode NPC IDs in the standard way, making the old ID-based approach unreliable for Classic world rares.

**Tooltip cache scan** (secondary, Outland and Northrend rares)
The original _NPCScan detection method. Checks the WoW client's internal creature cache using a tooltip hyperlink query (`TestID`). Runs alongside the nameplate scanner and handles Outland and Northrend rares where the original Wowhead rare list is the source of truth. This method was not changed from the upstream addon.

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