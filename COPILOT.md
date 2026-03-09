## Context for EbonSearch / EbonOverlay

**Project**: Ebonhold Search and Destroy v2.0.0
**Client**: WotLK 3.3.5a (Interface 30300), Project Ebonhold private server
**Forked from**: _NPCScan 7.x (Saiket), renamed and adapted in v2.0.0

---

### Why the fork was necessary

Ebonhold's private core uses raw hex GUIDs (`0xF13000060B684A99`) that do **not** encode NPC ID in a retail-compatible way. GUID-based NPC ID extraction is therefore disabled permanently. Detection is name-driven using `nameplate1..40` unit tokens.

---

### Architecture

- **Detection**: OnUpdate loop over `nameplate1..40` — `UnitExists` → `UnitName` → match against rare name table
- **Secondary detection**: `PLAYER_TARGET_CHANGED` / `UPDATE_MOUSEOVER_UNIT` events
- **Alert pipeline**: `ProcessUnit` → `OnFound` → `me.Button:SetNPC`
- **Overlay**: EbonOverlay draws patrol paths; `EbonOverlay.PathData.lua` contains binary triangle coordinate strings — **never re-save as UTF-8**
- **Rare data**: generated from PE-Questie DB via `tools/extract_npcscan_rare_tables.ps1` → `EbonSearch/generated_npcscan_rare_tables.lua`
- **Minimap button**: 31×31 frame, 3-layer stack (BACKGROUND/ARTWORK/OVERLAY), dragon icon (`INV_Misc_Head_Dragon_Bronze`), drag-to-reposition

---

### Key constraints (never change)

- **Never** re-enable GUID → NPC ID parsing
- **Never** revert to `WorldFrame:GetChildren()` nameplate scanning
- **Never** re-save `EbonOverlay/EbonOverlay.PathData.lua` as UTF-8 (binary strings will corrupt)
- `DisableCache = true` is the default; do not change unless explicitly asked

---

### Commands

- Primary: `/esd` (subcommands: `add`, `remove`, `cache`, `clear`, `zone blacklist add|remove|list`)
- Legacy alias: `/npcscan` → routes to the same ESD handler

---

### Addon folders (repo root)

```
EbonSearch/    ← was _NPCScan/
EbonOverlay/   ← was _NPCScanOverlay/
tools/         ← extractor + deploy scripts
```

---

### Key commits

- `v2.0.0-alpha1` — ProcessUnit + multi-alert queue + zone blacklist
- `v2.0.0-beta1` — namespace rename (_NPCScan → EbonSearch, _NPCScanOverlay → EbonOverlay)
- `54727a2` — PathData binary corruption fix (UTF-8 re-encoding)
- `b9530ec` — /esd slash command overhaul; /npcscan backward-compat alias
- `0e1612f` — Ebonhold branding (light blue colour codes in display strings)
- `cfa9832` — Minimap icon restored to dragon (INV_Misc_Head_Dragon_Bronze)

---

### Credits

- Upstream: _NPCScan 7.x (Saiket)
- Patterns: SilverDragon (Torhal), RareScanner (Sariel)
- Rare data: Questie Ebonhold DB (Xurkon)
- Ebonhold adaptations: Serv (powerfulqa)
