-- tests/test_wildlife_blacklist.lua
-- Unit tests for the wildlife blacklist merge logic (v2.2.0+).
--
-- SOURCE: EbonSearch/EbonSearch.lua
--   * WILDLIFE_BLACKLIST_BUILTIN  -- hardcoded server-wide misfires
--   * me.Options.WildlifeBlacklist -- user-editable, persisted in EbonSearchDB
--   * ProcessUnitForRares check (target/mouseover path):
--       if FilterWildlife ~= false and (WILDLIFE_BLACKLIST_BUILTIN[Name] or WildlifeBlacklist[Name]) then return end
--   * GetNameplateTrackedMatch check (nameplate scan paths: ScanTrackedNameplates,
--     NAME_PLATE_UNIT_ADDED, ScanNameplates) -- v2.2.1 regression fix:
--       if FilterWildlife ~= false and (WILDLIFE_BLACKLIST_BUILTIN[Name] or WildlifeBlacklist[Name]) then return end
--
-- Tested invariants:
--   1.  Builtin entries are suppressed when FilterWildlife is true (default)
--   2.  User-added entries are suppressed when FilterWildlife is true
--   3.  Non-blacklisted names are NOT suppressed
--   4.  FilterWildlife = false bypasses both builtin and user lists
--   5.  Builtin and user lists are independent: removing from user does not affect builtin
--   6.  Entry added to user list is immediately active (no rebuild needed)
--   7.  Entry removed from user list is immediately inactive
--   8.  Empty string name does not accidentally match real entries
--   9.  nil name does not suppress (matches existing nil-guard pattern)
--  10.  Blacklisted mob that is also in TrackedNames is suppressed by nameplate path
--       (regression: Reef Shark in generated tables fired through ScanTrackedNameplates)

io.write("-- test_wildlife_blacklist\n")

-- ---------------------------------------------------------------------------
-- Minimal factory: isolated wildlife filter with injectable state
-- Mirrors: ProcessUnitForRares filter line in EbonSearch.lua
-- Returns: is_suppressed(Name) fn
-- ---------------------------------------------------------------------------
local function make_filter(builtin, user_blacklist, filter_enabled)
	-- filter_enabled nil → true (same as FilterWildlife default)
	return function(Name)
		if filter_enabled == false then return false end
		if not Name then return false end
		return builtin[Name] or user_blacklist[Name] or false
	end
end

-- ---------------------------------------------------------------------------
-- 1. Builtin entries are suppressed (FilterWildlife default = true)
-- ---------------------------------------------------------------------------
do
	local builtin = { ["Plainsstrider"] = true, ["Reef Shark"] = true }
	local user    = {}
	local f = make_filter(builtin, user, nil)
	assert_true(f("Plainsstrider"), "builtin: Plainsstrider should be suppressed")
	assert_true(f("Reef Shark"),    "builtin: Reef Shark should be suppressed")
end

-- ---------------------------------------------------------------------------
-- 2. User-added entries are suppressed
-- ---------------------------------------------------------------------------
do
	local builtin = {}
	local user    = { ["Coastal Threshadon"] = true }
	local f = make_filter(builtin, user, nil)
	assert_true(f("Coastal Threshadon"), "user: user-added entry should be suppressed")
end

-- ---------------------------------------------------------------------------
-- 3. Non-blacklisted names are NOT suppressed
-- ---------------------------------------------------------------------------
do
	local builtin = { ["Plainsstrider"] = true }
	local user    = { ["Coastal Threshadon"] = true }
	local f = make_filter(builtin, user, nil)
	assert_false(f("Time-Lost Proto-Drake"), "non_blacklisted: actual rare should not be suppressed")
	assert_false(f("Skoll"),                 "non_blacklisted: Skoll should not be suppressed")
end

-- ---------------------------------------------------------------------------
-- 4. FilterWildlife = false bypasses all checks
-- ---------------------------------------------------------------------------
do
	local builtin = { ["Plainsstrider"] = true, ["Reef Shark"] = true }
	local user    = { ["Coastal Threshadon"] = true }
	local f = make_filter(builtin, user, false)
	assert_false(f("Plainsstrider"),       "filter_off: builtin entry should pass when filter disabled")
	assert_false(f("Coastal Threshadon"), "filter_off: user entry should pass when filter disabled")
end

-- ---------------------------------------------------------------------------
-- 5. Builtin and user lists are independent
-- ---------------------------------------------------------------------------
do
	local builtin = { ["Plainsstrider"] = true }
	local user    = { ["Plainsstrider"] = true }  -- also in user list
	-- Remove from user list; builtin should still suppress it
	user["Plainsstrider"] = nil
	local f = make_filter(builtin, user, nil)
	assert_true(f("Plainsstrider"), "independence: removing from user does not affect builtin entry")
end

-- ---------------------------------------------------------------------------
-- 6. Entry added to user list is immediately active
-- ---------------------------------------------------------------------------
do
	local builtin = {}
	local user    = {}
	local f = make_filter(builtin, user, nil)
	assert_false(f("Barracuda"),  "immediate_add: before add should not be suppressed")
	user["Barracuda"] = true
	assert_true(f("Barracuda"),   "immediate_add: after add should be suppressed")
end

-- ---------------------------------------------------------------------------
-- 7. Entry removed from user list is immediately inactive
-- ---------------------------------------------------------------------------
do
	local builtin = {}
	local user    = { ["Barracuda"] = true }
	local f = make_filter(builtin, user, nil)
	assert_true(f("Barracuda"),   "immediate_remove: before remove should be suppressed")
	user["Barracuda"] = nil
	assert_false(f("Barracuda"),  "immediate_remove: after remove should not be suppressed")
end

-- ---------------------------------------------------------------------------
-- 8. Empty string name does not accidentally match real entries
-- ---------------------------------------------------------------------------
do
	local builtin = { [""] = true }  -- pathological: never happens in practice
	local user    = {}
	local f = make_filter(builtin, user, nil)
	-- The real nil-guard in ProcessUnitForRares catches nil before this point.
	-- Empty string is a distinct key; test that non-empty names are unaffected.
	assert_false(f("Skoll"), "empty_key: Skoll should not match an empty-string builtin entry")
end

-- ---------------------------------------------------------------------------
-- 9. nil name: filter returns false (not suppressed); nil-guard in caller
-- ---------------------------------------------------------------------------
do
	local builtin = { ["Plainsstrider"] = true }
	local user    = {}
	local f = make_filter(builtin, user, nil)
	assert_false(f(nil), "nil_name: nil name should not be suppressed (nil-guard)")
end

-- ---------------------------------------------------------------------------
-- v2.2.3 normalization tests
-- Mirrors NormalizeName + WildlifeBlacklistNorm lookup logic in EbonSearch.lua.
-- ---------------------------------------------------------------------------
local function NormalizeName(Name)
	if type(Name) ~= "string" then return nil end
	Name = Name:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
	return Name:lower()
end

local function build_norm(verbatim_table)
	local out = {}
	for k in pairs(verbatim_table) do
		local key = NormalizeName(k)
		if key then out[key] = true end
	end
	return out
end

local function make_norm_filter(builtin_norm, user_norm, filter_enabled)
	return function(Name)
		if filter_enabled == false then return false end
		if not Name then return false end
		local key = NormalizeName(Name)
		if not key then return false end
		return builtin_norm[key] or (user_norm and user_norm[key]) or false
	end
end

-- 11. NormalizeName: lowercases, trims, collapses internal whitespace
do
	assert_equal(NormalizeName("Plainsstrider"),       "plainsstrider", "norm: plain word lowercases")
	assert_equal(NormalizeName("REEF SHARK"),          "reef shark",    "norm: uppercase lowercases")
	assert_equal(NormalizeName("  Reef Shark  "),      "reef shark",    "norm: leading/trailing spaces trimmed")
	assert_equal(NormalizeName("Reef    Shark"),       "reef shark",    "norm: internal spaces collapsed")
	assert_equal(NormalizeName("\tReef\tShark\t"),     "reef shark",    "norm: tabs treated as whitespace")
	assert_nil(NormalizeName(nil),                                       "norm: nil returns nil")
	assert_nil(NormalizeName(123),                                       "norm: non-string returns nil")
end

-- 12. Builtin lookup is case-insensitive via normalized table
do
	local builtin_verbatim = { ["Plainsstrider"] = true, ["Reef Shark"] = true }
	local builtin_norm     = build_norm(builtin_verbatim)
	local f                = make_norm_filter(builtin_norm, {}, nil)
	assert_true(f("Plainsstrider"),  "norm_builtin: exact case match")
	assert_true(f("plainsstrider"),  "norm_builtin: lowercase variant matches")
	assert_true(f("PLAINSSTRIDER"),  "norm_builtin: uppercase variant matches")
	assert_true(f("Reef Shark"),     "norm_builtin: multi-word exact case")
	assert_true(f("reef shark"),     "norm_builtin: multi-word lowercase")
	assert_true(f("  REEF SHARK  "), "norm_builtin: multi-word with whitespace + case")
	assert_false(f("Time-Lost Proto-Drake"), "norm_builtin: non-blacklisted rare unaffected")
end

-- 13. User add/remove resolves through normalized form (case-fold roundtrip)
do
	-- User adds "Giraffe" (typed); we mirror to norm
	local user_verbatim = { ["Giraffe"] = true }
	local user_norm     = build_norm(user_verbatim)
	local f             = make_norm_filter({}, user_norm, nil)
	assert_true(f("Giraffe"),  "norm_user: add Giraffe matches Giraffe")
	assert_true(f("giraffe"),  "norm_user: add Giraffe matches lowercase")
	assert_true(f("GIRAFFE"),  "norm_user: add Giraffe matches uppercase")

	-- User removes "GIRAFFE" (different casing); mirror remove from both tables
	local key = NormalizeName("GIRAFFE")
	for existing in pairs(user_verbatim) do
		if NormalizeName(existing) == key then user_verbatim[existing] = nil end
	end
	user_norm[key] = nil

	assert_false(f("Giraffe"), "norm_user: case-different remove drops the match")
	-- Verbatim table should also be empty (the original-case entry removed)
	assert_nil(user_verbatim["Giraffe"], "norm_user: verbatim entry cleaned up")
end

-- 14. Synchronize migration: existing saved entries with mixed case still match
do
	-- Simulate a SavedVar restored from a v2.2.0 user (verbatim only, no Norm yet).
	-- Synchronize rebuilds the Norm mirror at login; verify the rebuild matches lookups.
	local saved_verbatim = { ["plainsstrider"] = true, ["Reef Shark"] = true, ["BARRACUDA"] = true }
	local rebuilt_norm   = build_norm(saved_verbatim)
	local f              = make_norm_filter({}, rebuilt_norm, nil)

	-- All entries reachable regardless of original casing
	assert_true(f("Plainsstrider"),  "migration: mixed-case saved entry matches Title Case")
	assert_true(f("Reef Shark"),     "migration: title-case saved entry matches itself")
	assert_true(f("Barracuda"),      "migration: ALL CAPS saved entry matches normal case")
	assert_true(f("plainsstrider"),  "migration: lowercase saved entry matches lowercase")
	assert_false(f("Skoll"),         "migration: non-blacklisted name unaffected")
end

-- ---------------------------------------------------------------------------
-- 10. Nameplate path: blacklisted mob in TrackedNames is suppressed
--     Regression: Reef Shark (ID 12123) is in generated rare tables so it lands
--     in TrackedNames; before v2.2.1 GetNameplateTrackedMatch had no wildlife
--     check, causing ScanTrackedNameplates / NAME_PLATE_UNIT_ADDED to fire alerts
--     for it even though it was in WILDLIFE_BLACKLIST_BUILTIN.
-- ---------------------------------------------------------------------------
do
	-- Simulate GetNameplateTrackedMatch filter: name resolved, then wildlife check,
	-- then TrackedNames lookup.  Mirror the fixed logic in EbonSearch.lua.
	local function make_nameplate_filter(builtin, user_blacklist, tracked_names, filter_enabled)
		return function(Name)
			if not Name then return nil end
			-- wildlife guard (v2.2.1 fix)
			if filter_enabled ~= false then
				if builtin[Name] or user_blacklist[Name] then
					return nil  -- suppressed: no NpcID returned
				end
			end
			return tracked_names[Name]  -- NpcID or nil
		end
	end

	local builtin  = { ["Reef Shark"] = true }
	local user     = {}
	local tracked  = { ["Reef Shark"] = 12123, ["Time-Lost Proto-Drake"] = 32491 }

	-- With filter on: Reef Shark is blacklisted, so no NpcID returned
	local f = make_nameplate_filter(builtin, user, tracked, nil)
	assert_true(f("Reef Shark") == nil,
		"nameplate_path: Reef Shark in TrackedNames should be suppressed by wildlife blacklist")
	-- Non-blacklisted rare in same table must still return its ID
	assert_true(f("Time-Lost Proto-Drake") == 32491,
		"nameplate_path: non-blacklisted rare should still match in TrackedNames")

	-- With filter off: Reef Shark bypasses blacklist and returns its ID
	local f_off = make_nameplate_filter(builtin, user, tracked, false)
	assert_true(f_off("Reef Shark") == 12123,
		"nameplate_path: filter_off should let blacklisted mob through TrackedNames")

	-- User-blacklisted mob in TrackedNames is also suppressed
	local user2   = { ["Coastal Threshadon"] = true }
	local tracked2 = { ["Coastal Threshadon"] = 99999, ["Time-Lost Proto-Drake"] = 32491 }
	local f2 = make_nameplate_filter({}, user2, tracked2, nil)
	assert_true(f2("Coastal Threshadon") == nil,
		"nameplate_path: user-blacklisted mob in TrackedNames should be suppressed")
	assert_true(f2("Time-Lost Proto-Drake") == 32491,
		"nameplate_path: non-blacklisted rare unaffected by user blacklist")
end
