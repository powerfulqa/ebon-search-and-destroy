-- tests/test_wildlife_blacklist.lua
-- Unit tests for the wildlife blacklist merge logic (v2.2.0).
--
-- SOURCE: EbonSearch/EbonSearch.lua
--   * WILDLIFE_BLACKLIST_BUILTIN  -- hardcoded server-wide misfires
--   * me.Options.WildlifeBlacklist -- user-editable, persisted in EbonSearchDB
--   * ProcessUnitForRares check:
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
