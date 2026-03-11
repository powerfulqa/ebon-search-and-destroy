-- tests/test_tracked_names.lua
-- Unit tests for TrackedNamesRebuild / GetTrackedNpcIDByName lookup logic
-- and zone blacklist scan suppression.
--
-- SOURCE: EbonSearch/EbonSearch.lua
--   * TrackedNamesRebuild   (builds TrackedNames from NPCs + SessionNPCNames + ScanIDs)
--   * GetTrackedNpcIDByName (lazy rebuild on dirty flag)
--   * Zone blacklist guard  (ScanNameplates + ScanTrackedNameplates early-return)
--
-- All WoW API calls are stubbed; no game client needed.

io.write("-- test_tracked_names\n")

-- ---------------------------------------------------------------------------
-- Mirrors: TrackedNamesRebuild + GetTrackedNpcIDByName
-- Returns a fresh lookup function bound to its own isolated state tables.
--   NPCs           = { [NpcID] = Name }  (OptionsCharacter.NPCs)
--   SessionNPCNames= { [NpcID] = Name }  (DisableCache runtime names)
--   ScanIDs        = { [NpcID] = count } (active scan registry)
--   L_NPCs         = { [NpcID] = Name }  (locale table, L.NPCs)
-- ---------------------------------------------------------------------------
local function make_tracker(NPCs, SessionNPCNames, ScanIDs, L_NPCs)
	NPCs            = NPCs            or {}
	SessionNPCNames = SessionNPCNames or {}
	ScanIDs         = ScanIDs         or {}
	L_NPCs          = L_NPCs          or {}

	local TrackedNames = {}
	local dirty = true

	local function rebuild()
		-- wipe
		for k in pairs(TrackedNames) do TrackedNames[k] = nil end
		for NpcID, Name in pairs(NPCs) do
			if Name then TrackedNames[Name] = NpcID end
		end
		for NpcID, Name in pairs(SessionNPCNames) do
			if Name then TrackedNames[Name] = NpcID end
		end
		for NpcID in pairs(ScanIDs) do
			local Name = NPCs[NpcID] or SessionNPCNames[NpcID] or L_NPCs[NpcID]
			if Name then TrackedNames[Name] = NpcID end
		end
		dirty = false
	end

	local function get(Name)
		if dirty then rebuild() end
		return TrackedNames[Name]
	end

	local function mark_dirty()
		dirty = true
	end

	return get, TrackedNames, mark_dirty
end

-- ---------------------------------------------------------------------------
-- Mirror: zone blacklist scan guard
-- Returns true if the scan should be suppressed for this zone.
-- Mirrors: the ZoneBlacklist early-return in ScanNameplates / ScanTrackedNameplates
-- ---------------------------------------------------------------------------
local function is_zone_blacklisted(ZoneBlacklist, CurrentZone)
	return ZoneBlacklist and ZoneBlacklist[CurrentZone] == true
end

-- ===========================================================================
-- TrackedNames tests
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- 1. NPCs table: names are found by lookup
-- ---------------------------------------------------------------------------
do
	local get = make_tracker({[1234]="Bayne"})
	assert_equal(get("Bayne"), 1234, "npc_table: Bayne should resolve to 1234")
end

-- ---------------------------------------------------------------------------
-- 2. Unknown name returns nil
-- ---------------------------------------------------------------------------
do
	local get = make_tracker({[1234]="Bayne"})
	assert_nil(get("Nobody"), "unknown_name: should return nil")
end

-- ---------------------------------------------------------------------------
-- 3. SessionNPCNames (DisableCache path) are included
-- ---------------------------------------------------------------------------
do
	local get = make_tracker({}, {[5678]="Gondria"})
	assert_equal(get("Gondria"), 5678, "session_names: Gondria should resolve via SessionNPCNames")
end

-- ---------------------------------------------------------------------------
-- 4. ScanIDs entries resolved via L.NPCs locale fallback
-- ---------------------------------------------------------------------------
do
	local get = make_tracker({}, {}, {[9999]=1}, {[9999]="Vyragosa"})
	assert_equal(get("Vyragosa"), 9999, "scan_ids_locale: Vyragosa via L_NPCs fallback")
end

-- ---------------------------------------------------------------------------
-- 5. ScanIDs entries resolved via NPCs before L.NPCs
-- ---------------------------------------------------------------------------
do
	local get = make_tracker({[9999]="Vyragosa"}, {}, {[9999]=1}, {[9999]="WrongName"})
	assert_equal(get("Vyragosa"),  9999,       "scan_ids_npc_priority: NPCs wins over L_NPCs")
	assert_nil  (get("WrongName"),             "scan_ids_npc_priority: L_NPCs name should be shadowed")
end

-- ---------------------------------------------------------------------------
-- 6. Dirty flag: result updates after mark_dirty + table change
-- ---------------------------------------------------------------------------
do
	local NPCs = {[1]="Alpha"}
	local get, _, mark_dirty = make_tracker(NPCs)
	assert_equal(get("Alpha"), 1, "dirty_flag: initial lookup")
	NPCs[2] = "Beta"
	mark_dirty()
	assert_equal(get("Beta"), 2, "dirty_flag: Beta visible after dirty+rebuild")
end

-- ---------------------------------------------------------------------------
-- 7. Last-write wins when same name maps to two IDs (SessionNPCNames over NPCs)
--    Lua table iteration order is undefined, but both IDs reference the same Name,
--    so the test just confirms the lookup returns a valid NpcID (not nil).
-- ---------------------------------------------------------------------------
do
	-- NPC 10 and Session 20 both claim the name "Dupe" -- session overrides
	local get = make_tracker({[10]="Dupe"}, {[20]="Dupe"})
	local id = get("Dupe")
	assert_not_nil(id, "duplicate_name: should resolve to one of the two IDs, not nil")
	assert_true(id == 10 or id == 20, "duplicate_name: resolved ID must be 10 or 20 (got " .. tostring(id) .. ")")
end

-- ---------------------------------------------------------------------------
-- 8. nil Name entries are skipped (not inserted as TrackedNames[false] / error)
-- ---------------------------------------------------------------------------
do
	local get, tracked = make_tracker({[99]=nil})
	get("anything") -- force rebuild
	assert_nil(tracked[false], "nil_name_skip: nil name must not insert a false key")
	assert_nil(tracked[""],    "nil_name_skip: nil name must not insert an empty-string key")
end

-- ===========================================================================
-- Zone blacklist tests
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- 9. Blacklisted zone suppresses scan
-- ---------------------------------------------------------------------------
do
	local bl = {["Icecrown"]=true}
	assert_true (is_zone_blacklisted(bl, "Icecrown"),  "blacklist/hit: Icecrown should be suppressed")
	assert_false(is_zone_blacklisted(bl, "Nagrand"),   "blacklist/miss: Nagrand should not be suppressed")
end

-- ---------------------------------------------------------------------------
-- 10. nil ZoneBlacklist (not yet initialised) never suppresses
-- ---------------------------------------------------------------------------
do
	assert_false(is_zone_blacklisted(nil, "Icecrown"), "blacklist/nil_table: nil blacklist must never suppress")
end

-- ---------------------------------------------------------------------------
-- 11. Empty ZoneBlacklist never suppresses
-- ---------------------------------------------------------------------------
do
	assert_false(is_zone_blacklisted({}, "The Storm Peaks"), "blacklist/empty: empty table must not suppress")
end

-- ---------------------------------------------------------------------------
-- 12. Zone name is case-sensitive (consistent with GetRealZoneText() output)
-- ---------------------------------------------------------------------------
do
	local bl = {["The Storm Peaks"]=true}
	assert_false(is_zone_blacklisted(bl, "the storm peaks"), "blacklist/case: lowercase must not match")
	assert_true (is_zone_blacklisted(bl, "The Storm Peaks"), "blacklist/case: exact case must match")
end

-- ---------------------------------------------------------------------------
-- 13. Removing a zone from blacklist un-suppresses it
-- ---------------------------------------------------------------------------
do
	local bl = {["Icecrown"]=true}
	assert_true(is_zone_blacklisted(bl, "Icecrown"), "blacklist/remove_before: Icecrown suppressed")
	bl["Icecrown"] = nil
	assert_false(is_zone_blacklisted(bl, "Icecrown"), "blacklist/remove_after: Icecrown no longer suppressed")
end
