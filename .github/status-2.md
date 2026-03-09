# Ebonhold Search and Destroy - Status

## v2.0.0 - Ready for release

### What is shipping

| Component | Status |
|---|---|
| Nameplate scanner (`nameplate1..40`) | Ready |
| Target / mouseover detection | Ready |
| Multi-alert queue + NavNext button | Ready |
| Alert toast: click to target + auto skull marker | Ready |
| Zone blacklist (right-click minimap or `/esd zone blacklist`) | Ready |
| Minimap button with persisted drag position | Ready |
| EbonOverlay patrol paths on World Map + Minimap | Ready |
| Discovery pins (gold marker at detection position, persisted) | Ready |
| Rare DB from PE-Questie Ebonhold data | Ready |

### Key constraints (do not change)

- `DisableCache = true` - every run starts fresh, no persistent NPC suppression
- Detection is name-based only - GUID NPC ID extraction is disabled (Ebonhold GUIDs)
- `EbonOverlay.PathData.lua` must never be re-saved as UTF-8 (binary triangle data)
- Primary slash command is `/esd`; `/npcscan` is a backward-compat alias only

### Known limitations

- Discovery pins only appear on zones covered by EbonOverlay's WorldMap module
- Overlay path data only exists for classic/TBC/WotLK rares in the original PathData set
- Ebonhold custom rares get a gold pin but no patrol path

### Commit log (v2.0.0 series)

- `0e1612f` - Ebonhold branding (light-blue colour codes)
- `b9530ec` - `/esd` slash command overhaul; `/npcscan` backward-compat alias
- `cfa9832` - Minimap icon restored to dragon
- `9923527` - Docs rewrite (README, COPILOT, copilot-instructions)
- `25e84ea` - Toast QueueBadge overlap fix; Overlay Phase 2 discovery positions
- `334f6af` - Minimap angle persisted across login/reload
- `70fa40c` - NPCFound chat feedback
- `a5e9553` - Gold map pins for all detections including no-PathData NPCs
- `963b018` - Toast click: skull raid marker on targeted rare
- `13c9d7f` - Em dash removal across repo
