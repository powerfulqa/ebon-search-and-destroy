# Ebonhold Search and Destroy

## Features
- `nameplate1..40` + target/mouseover scanning (Wrath 3.3.5 private core)
- `DisableCache = true` by default — every scan is fresh
- Multi-alert queue with NavNext button
- Zone blacklist: `/esd zone blacklist add|remove|list`
- Purple nameplate overlay + sound + screen flash + alert button
- Rare data sourced from PE-Questie Ebonhold DB via extractor script
- Tagged releases: v2.0.0-alpha1 (ProcessUnit + queue + zone blacklist), v2.0.0-beta1 (namespace rename)

## Server Compatibility
✅ Unit tokens work (`UnitName("nameplate1")`)
✅ GUID format: `0xF13000060B684A99` (NPC ID not embedded)
✅ Target/mouseover detection via `PLAYER_TARGET_CHANGED` / `UPDATE_MOUSEOVER_UNIT`
❌ GUID NPC ID extraction (name-based only)
❌ WorldFrame:GetChildren() nameplates (unit tokens only)

## Install
1. Copy `EbonSearch/` and `EbonOverlay/` to `Interface/AddOns/`
2. `/reload`
3. `/esd` — zone blacklist commands available

## Your WoW files (copy these)

```text
Interface/AddOns/EbonSearch/
├── EbonSearch.lua        (v2.0.0)
```

## Acknowledgements

- **Foundation**: _NPCScan 7.x by Saiket
- **Patterns**: SilverDragon 3.3.5 (Torhal), RareScanner (Sariel)
- **Rare database**: PE-Questie Ebonhold DB (Xurkon)
- **Ebonhold adaptations**: Serv
├── Locales/
│   └── Locale-enUS.lua   (debug print removed)
└── ... (keep your other existing files)
```

Then run `/reload` and `/npcscan clearcache`.
