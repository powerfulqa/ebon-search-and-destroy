## Context for _NPCScan debugging

**Root cause**: Private 3.3.5 server GUIDs (`0xF13000060B684A99`) don't embed NPC ID. 
**Solution**: `nameplate1..40` UnitName() matching in OnUpdate loop.
**Key commits**: v1.2.7 (name scan), v1.2.8 (debug cleanup)
**Status**: ✅ Detection + sound + overlay working on Bayne/Farmer Solliden
**Next features**: Zone-specific scanning, configurable name list

**Never** revert to GUID NPC ID extraction or WorldFrame:GetChildren().
