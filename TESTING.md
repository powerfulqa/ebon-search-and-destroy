# EbonSearch & EbonOverlay: Test Plan

Applies to: **EbonSearch v2.1.5+ / EbonOverlay v2.1.5+** (Interface 30300, WotLK 3.3.5a)

---

## 0. Automated Unit Tests

**Run before every push.** No WoW client required. Standard Lua 5.x only.

```powershell
# From repo root (Lua 5.x must be in PATH):
lua tests/run_tests.lua
```

| Suite | What it covers | Tests |
|---|---|---|
| `test_overlay_math.lua` | `ApplyTransform` Det guards, UV bounds, no-clamp regression | 9 |
| `test_detection.lua` | `WasRecentlyDetected` debounce window, expiry, stale pruning | 9 |
| `test_texture_geom.lua` | `TextureAdd` ScaleX/Y guards, `DrawPath` byte decoding, coord round-trip | 9 |
| `test_tracked_names.lua` | `TrackedNamesRebuild`, zone blacklist, dirty flag, duplicates | 13 |
| `test_localization.lua` | `Locale-enUS.lua` parse and key regression | 8 |
| `test_wildlife_blacklist.lua` | Wildlife filter merge logic, user list add/remove, `FilterWildlife` bypass | 9 |
| **Total** | | **134** |

All 134 tests must pass before moving on to in-game manual testing. GitHub Actions (`.github/workflows/tests.yml`) runs these automatically on every push and PR.

Lua is installed at `C:\Users\ch\AppData\Local\Programs\Lua\bin\lua.exe`. If it is not in PATH:
```powershell
$env:PATH += ";C:\Users\ch\AppData\Local\Programs\Lua\bin"
lua tests/run_tests.lua
```

---

Run the manual sections below for whatever file you just changed. Each section lists its trigger files at the top.

---

## 1. Overlay Shape Sanity

**Run after changes to:** `EbonOverlay/EbonOverlay.lua`, `EbonOverlay/Modules/Minimap.lua`, `EbonOverlay/Modules/WorldMap.lua`

**Reference NPCs:** Time-Lost Proto-Drake (Storm Peaks), Vyragosa (Storm Peaks)

### 1a: Path Geometry

1. Open the world map at **default zoom**.
2. Disable all other map addons (Mapster, Carbonite, etc.); leave only EbonOverlay active.
3. Toggle each NPC overlay entry in the legend one at a time.

**Pass criteria:**
- Paths are smooth, curved polygon chains, not large solid rectangles.
- No visible gaps between adjacent triangles in a patrol route.
- Zoom fully in and fully out once; paths hold their shape throughout.

### 1b: Cross-Zone Repeat

Repeat §1a in:
- **Nagrand (Outland)**: any mapped rare.
- **Icecrown (Northrend)**: any mapped rare.

**Pass criteria:** same smooth polygon style, no extra artefacts or missing segments.

---

## 2. TexCoord Safety

**Run after changes to:** `EbonOverlay/EbonOverlay.lua` (`ApplyTransform`, `TextureAdd`)

> **v2.1.4 behaviour:** `ApplyTransform` computes raw UV coordinates and passes them
> directly to `SetTexCoord`. The only guard is the **UV magnitude guard**: if any UV
> has `|value| > 100`, the triangle is **hidden** (not clamped). Normal path triangles
> produce UVs in the range ~[−5, 5] and must remain unclamped to render correctly.

### 2a: No TexCoord Errors

1. Enable `/console scriptErrors 1`.
2. Fly around Storm Peaks with the world map open. Open and close the map 10–15 times while zooming in and out.

**Pass criteria:**
- No Lua error dialog mentioning `TexCoord` or `SetTexCoord`.
- No visible corruption or solid colour blocks covering large areas of the map.

### 2b: Invariants (regression guard)

These must hold in every version. Verify them by reading `ApplyTransform` before shipping:

| Rule | Rationale |
|------|-----------|
| **Keep** `Det == 0 or Det ~= Det → hide` | Eliminates zero-area and NaN-Det triangles |
| **Keep** `math.abs(UV) > 100 → hide` | Blocks pathological UVs from extreme zoom without corrupting normal paths |
| **Do NOT** add UV clamping to `[0,1]` | Normal rotated triangles have UVs in ~[−5, 5]; clamping makes paths blocky |
| **Do NOT** add new Det threshold early-returns without explicit path renders | Any new Det threshold risks hiding valid triangles |
| **TexCoord values must never be NaN:** | The Det check catches NaN-Det; near-zero Det that isn't exactly 0 produces huge UVs caught by the >100 guard |

**Automated check:** run `/esd debug overlays` while the world map is open over a mapped zone (see §4).

---

## 3. Detection Pipeline

**Run after changes to:** `EbonSearch/EbonSearch.lua`, `EbonSearch/EbonSearch.Button.lua`

> **Prereqs:** `/console scriptErrors 1` enabled. `DisableCache = true` (default, confirmed in `me.Options`).
> Debounce window: `RecentDetectionWindow = 3` seconds (`EbonSearch.lua`).
> Detection is nameplate-driven: `nameplate1..40` OnUpdate loop.

### 3a: Vanilla / Old World (TrackedNames path)

1. Pick a Classic-era rare whose name is in `TrackedNames` (drawn from `OptionsCharacterDefault.NPCs`) but has **no ScanIDs entry**. Any Eastern Kingdoms or Kalimdor rare works.
2. Approach until its nameplate appears.

**Pass criteria:**
- Exactly **one** chat line: `EbonSearch: Found "<Name>"!`
- No overlay confirmation message (unless this NPC has PathData).
- No duplicate alert on re-approach within 3 seconds.
- After waiting > 3 seconds, approaching again fires exactly one more alert.

### 3b: Outland / Northrend (ScanIDs + patrol path)

Use a rare with patrol data, e.g. **Time-Lost Proto-Drake** or **Vyragosa** (Storm Peaks).

Test both trigger paths independently:

| Trigger | How to force | Expected |
|---------|-------------|----------|
| `NAME_PLATE_UNIT_ADDED` fast-path | Fly in from outside nameplate range | One `Found "<Name>"!` line |
| Periodic nameplate scan (OnUpdate tick) | Stand still with the rare already on screen after `/reload` | One `Found "<Name>"!` line |

Additional checks for both paths:
- One EbonOverlay confirmation message (if the zone has a path or pin).
- A gold map pin appears in EbonOverlay. No duplicate pins on re-detection.
- No Lua errors in the chat frame.

### 3c: Debounce by Name Only

Trigger the same rare 3 times in quick succession:
- Fly in and out of nameplate range rapidly.
- `/reload` while positioned near the rare, then immediately let it detect.

**Pass criteria:**
- At most **one** alert per `RecentDetectionWindow` (3 s) for the same rare.
- `RecentDetections` is keyed by **Name only**. Verify in code that `WasRecentlyDetected` receives `Name` (a string), never the result of `UnitGUID("nameplateN")` (unreliable on 3.3.5a, returns `nil` between ticks).
- `/esd clear` wipes `RecentDetections` and allows immediate re-detection.

---

## 4. Dev Helper: `/esd debug overlays`

**Implemented in:** `EbonOverlay/EbonOverlay.lua` (`me.DebugTransform`, `me.PrintDebugTransform`)
**Wired in:** `EbonSearch/EbonSearch.lua` (slash command handler)

Open the world map over a zone that has mapped NPCs, then run:

```
/esd debug overlays
```

**Expected output** (values will vary; these are representative normals):

```
EbonOverlay debug overlays
  Det    = 0.001234  (guard: Det==0 or NaN -> hide)
  UL UV  = -1.234567, 0.987654
  LL UV  = -2.345678, 1.876543
  UR UV  = -0.123456, -0.234567
  LR UV  = -1.234567, 0.654321
  max|UV| = 2.345678  (guard: >100 -> hide)
  guard fired (hidden) = false
  UV mode = pass-through (no clamp): PASS
```

**Interpretation:**

| Field | Healthy value | Problem if... |
|-------|--------------|---------------|
| `Det` | Small non-zero float, e.g. `0.000500` | `0` or `NaN` means degenerate triangles are reaching the guard (should not happen) |
| UV magnitudes | Typically `0.5`–`5.0` | Any value `> 100` means the guard should fire and hide that triangle |
| `max|UV|` shown in green | `< 100` | Red means the sample triangle was blocked by the UV guard |
| `guard fired (hidden)` | `false` | `true` means the sample was suppressed. Check what zone/zoom triggered it. |
| `UV mode` | `PASS` (green) | `BLOCKED` means the most recent triangle was hidden — investigate UV source |

If output reads `no sample yet`, the map was not open over a zone with rendered path data when the command ran. Navigate to a zone with mapped NPCs and try again.

---

## 5. Wildlife Blacklist

**Run after changes to:** `EbonSearch/EbonSearch.lua` (`ProcessUnitForRares`, `WILDLIFE_BLACKLIST_BUILTIN`, `WildlifeBlacklist`)

### 5a: Built-in suppression still active

Walk through the Barrens with FilterWildlife enabled (default).

**Pass criteria:**
- No alert fires for Plainsstrider, Ornery Plainsstrider, Giraffe, Barris Giraffe, Reef Shark, Rot Hide Bruiser, or Vile Fin Shredder.
- Actual Barrens rares (e.g. Lar'korwi Mate) still fire an alert.

### 5b: User-added entry via `/esd wildlife add`

1. `/esd wildlife add <creature name>` for a creature currently misfiring.
2. Approach the creature.

**Pass criteria:**
- No alert fires.
- `/esd wildlife list` shows the entry.
- `/reload` and approach again — entry still suppresses (persisted in `EbonSearchDB`).

### 5c: Remove user entry

1. `/esd wildlife remove <creature name>`.
2. Approach the creature.

**Pass criteria:**
- Alert fires again (suppression lifted).
- `/esd wildlife list` no longer shows the entry.

---

## 6. Regression Quick-Reference

| Symptom | Likely cause | Where to check |
|---------|-------------|----------------|
| Blocky rectangular paths | UV clamping re-added, or `SetTexCoord` called with `[0,1]` clamped values | `ApplyTransform`; ensure no clamp before `SetTexCoord` |
| All paths disappear at all zooms | `>100` threshold too small, or Det guard changed | Guard conditions in `ApplyTransform` |
| Solid colour blocks covering map areas | UV values `> 100` reaching `SetTexCoord` | Check `math.abs` calls in the UV guard |
| Double alert for same rare | Debounce keyed by GUID instead of Name | `WasRecentlyDetected`; key argument must be `Name` |
| Alert never fires | `TrackedNamesDirty` not reset, or zone is blacklisted | `TrackedNamesRebuild`, `ZoneBlacklist` check in `ScanTrackedNameplates` |
| Overlay pin duplicated | `StoreDiscovery` called multiple times for same detection | `EbonSearch.Overlays.lua` → `Found()` guard |
| `/esd debug overlays` prints `EbonOverlay not loaded` | Load order issue; EbonOverlay not enabled | Check `.toc` load order and addon enabled state |
