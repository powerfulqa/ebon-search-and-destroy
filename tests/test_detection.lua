-- tests/test_detection.lua
-- Unit tests for EbonSearch WasRecentlyDetected debounce logic.
--
-- SOURCE: EbonSearch/EbonSearch.lua -- WasRecentlyDetected (inside ScanNameplates do-block)
-- If WasRecentlyDetected changes in the source, update make_debounce() below to match.
--
-- Tested invariants (v2.1.1+):
--   1.  First detection of a name is never blocked
--   2.  Re-detection within RecentDetectionWindow (3 s) IS blocked
--   3.  Key is Name only -- nil input returns nil (GUID path permanently removed)
--   4.  Call exactly AT the window boundary is NOT blocked  (< not <=)
--   5.  Call 0.1 s before expiry IS blocked
--   6.  Call after the window expires is NOT blocked (fires again)
--   7.  Different names do not interfere with each other
--   8.  Stale entries (> window*3 old) are pruned by the next call
--   9.  Rapid re-detections within the window are all blocked after the first

io.write("-- test_detection\n")

-- ---------------------------------------------------------------------------
-- Factory: isolated debounce instance with injectable clock
-- Mirrors: EbonSearch/EbonSearch.lua, WasRecentlyDetected + RecentDetections locals
-- Returns: was_detected_fn, RecentDetections_table
--   * clock_fn  replaces GetTime()
--   * window    replaces RecentDetectionWindow (default 3)
-- ---------------------------------------------------------------------------
local function make_debounce(clock_fn, window)
	window = window or 3
	local RecentDetections = {}
	local function WasRecentlyDetected(Name)
		if not Name then
			return
		end
		local Now  = clock_fn()
		local Last = RecentDetections[Name]
		if Last and (Now - Last) < window then
			return true
		end
		RecentDetections[Name] = Now
		for Key, Timestamp in pairs(RecentDetections) do
			if (Now - Timestamp) > (window * 3) then
				RecentDetections[Key] = nil
			end
		end
	end
	return WasRecentlyDetected, RecentDetections
end

-- ---------------------------------------------------------------------------
-- 1. First call: never blocked
-- ---------------------------------------------------------------------------
do
	local t = 0
	local wd = make_debounce(function() return t end)
	assert_false(wd("Bayne"), "first_call: should not be blocked")
end

-- ---------------------------------------------------------------------------
-- 2. Second call within window: blocked
--    T=0 registers; T=1 should return true  (1 < 3)
-- ---------------------------------------------------------------------------
do
	local t = 0
	local wd = make_debounce(function() return t end)
	wd("Bayne")   -- first call at T=0; not blocked, registers timestamp
	t = 1
	assert_true(wd("Bayne"), "within_window: T=1 should be blocked (window=3)")
end

-- ---------------------------------------------------------------------------
-- 3. nil name: returns nil, not blocked by nil key
--    Critical: UnitGUID("nameplateN") returns nil between ticks on 3.3.5a;
--    if nil were treated as a key the debounce would block ALL nameplates.
-- ---------------------------------------------------------------------------
do
	local t = 0
	local wd = make_debounce(function() return t end)
	local result = wd(nil)
	assert_nil(result, "nil_name: should return nil, not block by nil key (GUID path removed)")
end

-- ---------------------------------------------------------------------------
-- 4. Exactly at window boundary: NOT blocked  (Now - Last = 3, which is NOT < 3)
-- ---------------------------------------------------------------------------
do
	local t = 0
	local wd = make_debounce(function() return t end)
	wd("Vyragosa")   -- T=0
	t = 3            -- advance to exactly the window size
	assert_false(wd("Vyragosa"), "at_boundary: T=3 should not be blocked (< not <=)")
end

-- ---------------------------------------------------------------------------
-- 5. Just before expiry: blocked  (2.9 < 3)
-- ---------------------------------------------------------------------------
do
	local t = 0
	local wd = make_debounce(function() return t end)
	wd("Skoll")
	t = 2.9
	assert_true(wd("Skoll"), "before_expiry: T=2.9 should be blocked")
end

-- ---------------------------------------------------------------------------
-- 6. After window expires: detection fires again  (T=5 > window=3)
-- ---------------------------------------------------------------------------
do
	local t = 0
	local wd = make_debounce(function() return t end)
	wd("Time-Lost Proto-Drake")
	t = 5
	assert_false(wd("Time-Lost Proto-Drake"), "after_expiry: T=5 should not be blocked")
end

-- ---------------------------------------------------------------------------
-- 7. Different names do not interfere
-- ---------------------------------------------------------------------------
do
	local t = 0
	local wd = make_debounce(function() return t end)
	wd("Dirkee")                          -- registered; blocked within window
	assert_false(wd("Loque'nahak"),        "different_names: distinct names should not interfere")
	assert_true (wd("Dirkee"),             "different_names: same name still blocked")
end

-- ---------------------------------------------------------------------------
-- 8. Stale entries pruned after window*3  (default: 9 s)
--    OldRare registered at T=0; at T=10 (> 9) the next call should prune it.
-- ---------------------------------------------------------------------------
do
	local t = 0
	local wd, recent = make_debounce(function() return t end)
	wd("OldRare")                  -- T=0: registers entry
	t = 10                         -- advance past window*3 = 9
	wd("NewRare")                  -- triggers the pruning loop
	assert_nil(recent["OldRare"], "pruning: OldRare (T=0) should be pruned after T=10 (> window*3=9)")
	assert_not_nil(recent["NewRare"], "pruning: NewRare (T=10) should survive")
end

-- ---------------------------------------------------------------------------
-- 9. Rapid re-detections: all blocked after the first within the window
-- ---------------------------------------------------------------------------
do
	local t = 0
	local wd = make_debounce(function() return t end)
	wd("Gondria")  -- first: not blocked, registers T=0
	for _, dt in ipairs({0.1, 0.5, 1.0, 2.0, 2.9}) do
		t = dt
		assert_true(wd("Gondria"),
			"rapid_redetect: T=" .. tostring(dt) .. " should be blocked")
	end
end
