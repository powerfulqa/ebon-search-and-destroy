-- EbonSearch & EbonOverlay -- build-time unit test runner
-- Usage (from repo root):  lua tests/run_tests.lua
--        (from tests/ dir): lua run_tests.lua
-- No external dependencies required; plain Lua 5.1/5.4 compatible.

-- Resolve directory this script lives in so dofile() works from any cwd.
local _src = debug.getinfo(1, "S").source:match("^@(.+)$") or ""
local _dir = _src:match("^(.*[/\\])") or ""

local _pass, _fail = 0, 0

-- ---------------------------------------------------------------------------
-- Minimal assertion helpers (exposed as globals for test files)
-- ---------------------------------------------------------------------------

function assert_true(cond, msg)
	if cond then
		_pass = _pass + 1
		io.write(string.format("  PASS  %s\n", tostring(msg)))
	else
		_fail = _fail + 1
		io.write(string.format("  FAIL  %s\n", tostring(msg)))
	end
end

function assert_false(cond, msg)
	assert_true(not cond, msg)
end

function assert_equal(a, b, msg)
	if a == b then
		_pass = _pass + 1
		io.write(string.format("  PASS  %s\n", tostring(msg)))
	else
		_fail = _fail + 1
		io.write(string.format("  FAIL  %s  (got=%s  want=%s)\n", tostring(msg), tostring(a), tostring(b)))
	end
end

function assert_nil(v, msg)
	if v == nil then
		_pass = _pass + 1
		io.write(string.format("  PASS  %s\n", tostring(msg)))
	else
		_fail = _fail + 1
		io.write(string.format("  FAIL  %s  (got=%s, want nil)\n", tostring(msg), tostring(v)))
	end
end

function assert_not_nil(v, msg)
	assert_true(v ~= nil, tostring(msg) .. " (got nil)")
end

-- ---------------------------------------------------------------------------
-- Run suites
-- ---------------------------------------------------------------------------

dofile(_dir .. "test_overlay_math.lua")
dofile(_dir .. "test_texture_geom.lua")
dofile(_dir .. "test_tracked_names.lua")
dofile(_dir .. "test_detection.lua")
dofile(_dir .. "test_localization.lua")

-- ---------------------------------------------------------------------------
-- Summary
-- ---------------------------------------------------------------------------

local total  = _pass + _fail
local status = _fail == 0 and "OK" or "FAILED"
io.write(string.format("\n[%s]  %d/%d passed", status, _pass, total))
if _fail > 0 then
	io.write(string.format("  (%d failed)", _fail))
end
io.write("\n")
os.exit(_fail > 0 and 1 or 0)
