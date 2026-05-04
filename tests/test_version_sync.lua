-- tests/test_version_sync.lua
-- Cross-file version consistency check.
--
-- After every release bump, seven literal-text version touchpoints must agree:
-- two .toc files (each with a `## Title [vX.Y.Z]`, `## Version: X.Y.Z`,
-- `## X-Date: YYYY-MM-DD`) plus the README H1. tools/bump-version.ps1 keeps
-- them aligned automatically; this test fails CI if any one drifts (e.g. a
-- hand-edited toc, a missed file, a typo).
--
-- The runtime byline / watermark / minimap-tooltip version reads from
-- GetAddOnMetadata(...,"Version") at game time, so this test only validates
-- the literal duplicates in plaintext files. The Lua source itself never
-- carries a version number.

io.write("-- test_version_sync\n")

local function read_file(path)
	local f, err = io.open(path, "r")
	if not f then return nil, err end
	local s = f:read("*a")
	f:close()
	return s
end

local function extract_toc(path)
	local content, err = read_file(path)
	if not content then return nil, err end
	local title_v = content:match("## Title:[^\n]*%[v([%d%.]+)%]")
	local version = content:match("## Version:%s*([%d%.]+)")
	local date    = content:match("## X%-Date:%s*([%d%-]+)")
	return { title_v = title_v, version = version, date = date }
end

do
	local search,  err1 = extract_toc("EbonSearch/EbonSearch.toc")
	local overlay, err2 = extract_toc("EbonOverlay/EbonOverlay.toc")

	assert_not_nil(search,  "toc/read: EbonSearch.toc must be readable")
	assert_not_nil(overlay, "toc/read: EbonOverlay.toc must be readable")

	if search and overlay then
		-- Each .toc must be internally consistent: the [vX.Y.Z] suffix in
		-- ## Title must match the literal ## Version field.
		assert_equal(search.title_v, search.version,
			"toc/internal: EbonSearch [v...] in Title must match ## Version")
		assert_equal(overlay.title_v, overlay.version,
			"toc/internal: EbonOverlay [v...] in Title must match ## Version")

		-- Both addons in this repo ship in lockstep -- versions must match.
		assert_equal(search.version, overlay.version,
			"toc/cross: EbonSearch and EbonOverlay must share the same ## Version")

		-- ISO date format guard. Catches accidental locale formatting.
		assert_true(search.date and search.date:match("^%d%d%d%d%-%d%d%-%d%d$") ~= nil,
			"toc/date: EbonSearch ## X-Date must be YYYY-MM-DD")
		assert_true(overlay.date and overlay.date:match("^%d%d%d%d%-%d%d%-%d%d$") ~= nil,
			"toc/date: EbonOverlay ## X-Date must be YYYY-MM-DD")

		-- README H1 must match the toc version.
		local readme = read_file("README.md")
		assert_not_nil(readme, "readme/read: README.md must be readable")
		if readme then
			local readme_v = readme:match("^# Ebonhold Search and Destroy v([%d%.]+)")
			assert_not_nil(readme_v,
				"readme/h1: H1 must match '# Ebonhold Search and Destroy vX.Y.Z'")
			if readme_v then
				assert_equal(readme_v, search.version,
					"readme/sync: README H1 version must match toc ## Version")
			end
		end
	end
end
