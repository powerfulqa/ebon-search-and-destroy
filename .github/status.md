## Project Status (2026-03-05)

### Completed
- Rare NPC table generation pipeline is now in place and committed.
  - Extractor: `tools/extract_npcscan_rare_tables.ps1`
  - Generated output: `_NPCScan/generated_npcscan_rare_tables.lua`
  - Addon load integration: `_NPCScan/_NPCScan.toc`
- Extractor output path now writes directly into `_NPCScan/` (no repo-root generated table output).
- Release published: `v1.2.1` (tag points to commit `e26a556bd81e13bfd0ac83035e76ee1718801af0`).

### Current detection state
- Nameplate scanner uses reaction + classification + name filter (no GUID parsing).
- `UnitReaction <= 4` filters friendly NPCs.
- `UnitClassification == "rare"` or `"rareelite"` filters non-rares.
- Tracked names are indexed for O(1) lookup from scan tables.
- GUID parsing remains intentionally unused due to non-standard server GUID format.

### Overlay / data integrity
- Storm Peaks patrol path rendering fix remains in place.
- `_NPCScanOverlay/*Data.lua` binary handling safeguard remains required in `.gitattributes`.

### Open items
- Field-test Outland/Northrend legacy TestID path with nameplates OFF.
- Review/clean unrelated local `MobMap.lua` edit (not part of rare NPC pipeline work).
