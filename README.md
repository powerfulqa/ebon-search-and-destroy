# _NPCScan Wrath Private Server Fork

## Features
- `nameplate1..40` UnitName() scanning (Wrath 3.3.5 private cores)
- `DisableCache = true` by default — every scan is fresh
- `/npcscan clearcache` wipes session + persistent state
- Purple nameplate overlay + sound + alert button
- Tagged releases: v1.2.7 (name scan), v1.2.8 (debug cleanup)

## Server Compatibility
✅ Unit tokens work (`UnitName("nameplate1")`)
✅ GUID format: `0xF13000060B684A99` (NPC ID not embedded)
❌ GUID NPC ID extraction (name-based only)
❌ WorldFrame:GetChildren() nameplates (unit tokens only)

## Install
1. Copy to `Interface/AddOns/_NPCScan/`
2. `/reload`
3. `/npcscan clearcache`

## Your WoW files (copy these)

```text
Interface/AddOns/_NPCScan/
├── _NPCScan.lua          (v1.2.8)
├── Locales/
│   └── Locale-enUS.lua   (debug print removed)
└── ... (keep your other existing files)
```

Then run `/reload` and `/npcscan clearcache`.
