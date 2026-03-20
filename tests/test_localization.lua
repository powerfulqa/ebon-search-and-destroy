-- tests/test_localization.lua
-- Regression tests for localization file loading and critical string keys.
--
-- This catches parser/init regressions (for example, unescaped quotes in
-- locale strings) before they reach in-game startup.

io.write("-- test_localization\n")

do
	local addon = {}
	local old_unknown = _G.UNKNOWN
	local old_unit_type = _G.UNIT_TYPE_LEVEL_TEMPLATE

	-- Minimal WoW globals used by Locale-enUS.lua.
	_G.UNKNOWN = "UNKNOWN"
	_G.UNIT_TYPE_LEVEL_TEMPLATE = "%s %s"

	local chunk, load_err = loadfile("EbonSearch/Locales/Locale-enUS.lua")
	assert_not_nil(chunk, "locale/loadfile: enUS locale should compile")
	if chunk then
		local ok, runtime_err = pcall(chunk, nil, addon)
		assert_true(ok, "locale/runtime: enUS locale chunk should execute")
		assert_nil(runtime_err, "locale/runtime: no runtime error expected")
	end

	assert_not_nil(addon.L, "locale/table: addon.L should be created")
	if addon.L then
		assert_equal(addon.L.CMD_ADD, "ADD", "locale/key: CMD_ADD should exist")
		assert_equal(addon.L.SEARCH_TITLE, "Search", "locale/key: SEARCH_TITLE should exist")
		assert_true(type(addon.L.CMD_HELP) == "string", "locale/key: CMD_HELP should be a string")
		assert_true(addon.L.CMD_HELP:find("/esd add", 1, true) ~= nil,
			"locale/key: CMD_HELP should contain /esd add command")
	end

	-- Restore global values to avoid side effects on other tests.
	_G.UNKNOWN = old_unknown
	_G.UNIT_TYPE_LEVEL_TEMPLATE = old_unit_type
end
