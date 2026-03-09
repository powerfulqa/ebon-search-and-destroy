## Context for EbonSearch (formerly _NPCScan)

**Root cause**: Private 3.3.5 server GUIDs (`0xF13000060B684A99`) don't embed NPC ID.
**Solution**: `nameplate1..40` UnitName() + target/mouseover matching.
**Key commits**: v2.0.0-alpha1 (ProcessUnit + queue + zone blacklist), v2.0.0-beta1 (namespace rename)
**Status**: ✅ Detection + sound + overlay + multi-alert queue working
**Addon folder**: `EbonSearch/` (was `_NPCScan/`), `EbonOverlay/` (was `_NPCScanOverlay/`)

**Credits**
- Upstream: _NPCScan 7.x (Saiket)
- Patterns: SilverDragon (Torhal), RareScanner (Sariel)
- Rare data: Questie Ebonhold DB (Xurkon)
- Ebonhold core: Serv

**Never** revert to GUID NPC ID extraction or WorldFrame:GetChildren().
