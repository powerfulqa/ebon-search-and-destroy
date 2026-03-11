-- tests/test_overlay_math.lua
-- Unit tests for EbonOverlay ApplyTransform logic.
--
-- SOURCE: EbonOverlay/EbonOverlay.lua -- inner local function of TextureAdd do-block.
-- If ApplyTransform changes in the source, update compute_uvs() below to match,
-- then re-verify all test expectations.
--
-- Tested invariants (v2.1.4):
--   1.  Det == 0                    -> reject  (degenerate / collinear triangle)
--   2.  Det is NaN (Det ~= Det)     -> reject
--   3.  Det underflows to 0         -> reject  (1e-200 * 1e-200 = 0 in IEEE 754)
--   4.  |any UV| > 100              -> reject  (near-zero Det or extreme map zoom)
--   5.  |any UV| == 100             -> PASS    (guard is >, not >=)
--   6.  |any UV| == 101             -> reject
--   7.  Normal axis-aligned case    -> UVs in [0,1], pass through unclamped
--   8.  Rotated triangle            -> UVs outside [0,1] - confirms NO clamping applied
--   9.  No UV is ever NaN after Det guard passes

io.write("-- test_overlay_math\n")

-- ---------------------------------------------------------------------------
-- Pure-math mirror of ApplyTransform
-- Mirrors: EbonOverlay/EbonOverlay.lua, ApplyTransform(A,B,C,D,E,F)
-- Returns: array {ULx,ULy, LLx,LLy, URx,URy, LRx,LRy}, or nil + reason string.
-- ---------------------------------------------------------------------------
local function compute_uvs(A, B, C, D, E, F)
	local Det = A * E - B * D
	-- Guard 1: degenerate or NaN determinant
	if Det == 0 or Det ~= Det then
		return nil, "det_degenerate"
	end
	local AF, BF, CD, CE = A * F, B * F, C * D, C * E
	local ULx = (BF - CE)         / Det
	local ULy = (CD - AF)         / Det
	local LLx = (BF - CE - B)     / Det
	local LLy = (CD - AF + A)     / Det
	local URx = (BF - CE + E)     / Det
	local URy = (CD - AF - D)     / Det
	local LRx = (BF - CE + E - B) / Det
	local LRy = (CD - AF - D + A) / Det
	-- Guard 2: UV magnitude > 100 (near-zero Det or extreme minimap zoom)
	if math.abs(ULx) > 100 or math.abs(ULy) > 100 or
	   math.abs(LLx) > 100 or math.abs(LLy) > 100 or
	   math.abs(URx) > 100 or math.abs(URy) > 100 or
	   math.abs(LRx) > 100 or math.abs(LRy) > 100 then
		return nil, "uv_overflow"
	end
	return {ULx, ULy, LLx, LLy, URx, URy, LRx, LRy}
end

-- ---------------------------------------------------------------------------
-- 1. Det == 0: all-zero inputs
-- ---------------------------------------------------------------------------
do
	local uvs, reason = compute_uvs(0, 0, 0, 0, 0, 0)
	assert_nil  (uvs,    "det_zero/all_zero: uvs should be nil")
	assert_equal(reason, "det_degenerate", "det_zero/all_zero: reason")
end

-- ---------------------------------------------------------------------------
-- 2. Det == 0: collinear vectors  A=1 B=2 D=1 E=2  ->  Det = 1*2 - 2*1 = 0
-- ---------------------------------------------------------------------------
do
	local uvs, reason = compute_uvs(1, 2, 0, 1, 2, 0)
	assert_nil  (uvs,    "det_zero/collinear: uvs should be nil")
	assert_equal(reason, "det_degenerate", "det_zero/collinear: reason")
end

-- ---------------------------------------------------------------------------
-- 3. Det underflows to IEEE 754 zero: 1e-200 * 1e-200 = 1e-400 -> 0.0
-- ---------------------------------------------------------------------------
do
	local uvs, reason = compute_uvs(1e-200, 0, 0.5, 0, 1e-200, 0.5)
	assert_nil  (uvs,    "det_zero/underflow: uvs should be nil")
	assert_equal(reason, "det_degenerate", "det_zero/underflow: reason")
end

-- ---------------------------------------------------------------------------
-- 4. UV overflow: tiny but non-zero Det produces UVs >> 100
--    A=1e-6 E=1e-6  ->  Det=1e-12;  with C=F=0.5:  ULx = (0 - 0.5e-6)/1e-12 = -5e5
-- ---------------------------------------------------------------------------
do
	local uvs, reason = compute_uvs(1e-6, 0, 0.5, 0, 1e-6, 0.5)
	assert_nil  (uvs,    "uv_overflow/near_zero_det: uvs should be nil")
	assert_equal(reason, "uv_overflow", "uv_overflow/near_zero_det: reason")
end

-- ---------------------------------------------------------------------------
-- 5. Identity-like axis-aligned transform: A=1 B=0 C=0 D=0 E=1 F=0
--    Det=1, expected UVs:  UL=(0,0)  LL=(0,1)  UR=(1,0)  LR=(1,1)
-- ---------------------------------------------------------------------------
do
	local uvs = compute_uvs(1, 0, 0, 0, 1, 0)
	assert_not_nil(uvs, "identity: should produce UVs")
	if uvs then
		assert_equal(uvs[1], 0, "identity: ULx")
		assert_equal(uvs[2], 0, "identity: ULy")
		assert_equal(uvs[3], 0, "identity: LLx")
		assert_equal(uvs[4], 1, "identity: LLy")
		assert_equal(uvs[5], 1, "identity: URx")
		assert_equal(uvs[6], 0, "identity: URy")
		assert_equal(uvs[7], 1, "identity: LRx")
		assert_equal(uvs[8], 1, "identity: LRy")
	end
end

-- ---------------------------------------------------------------------------
-- 6. Rotated triangle (realistic WoW patrol path proportions)
--    A=-0.5 B=-1 C=1 D=1 E=0 F=0  ->  Det=1
--    UL=(0,1)  LL=(1,0.5)  UR=(0,0)  LR=(1,-0.5)
--    All |UV| <= 1 -> passes guard; LRy=-0.5 proves no [0,1] clamping.
-- ---------------------------------------------------------------------------
do
	local uvs = compute_uvs(-0.5, -1, 1, 1, 0, 0)
	assert_not_nil(uvs, "rotated: should produce UVs")
	if uvs then
		assert_equal(uvs[1], 0,    "rotated: ULx")
		assert_equal(uvs[2], 1,    "rotated: ULy")
		assert_equal(uvs[3], 1,    "rotated: LLx")
		assert_equal(uvs[4], 0.5,  "rotated: LLy")
		assert_equal(uvs[5], 0,    "rotated: URx")
		assert_equal(uvs[6], 0,    "rotated: URy")
		assert_equal(uvs[7], 1,    "rotated: LRx")
		assert_equal(uvs[8], -0.5, "rotated: LRy")
		for i = 1, 8 do
			assert_true(math.abs(uvs[i]) <= 100, "rotated: UV["..i.."] within ±100")
			assert_true(uvs[i] == uvs[i],        "rotated: UV["..i.."] not NaN")
		end
	end
end

-- ---------------------------------------------------------------------------
-- 7. UV boundary: |UV| == 100 must PASS (guard is >, not >=)
--    A=1 B=0 C=0 D=0 E=1 F=100  ->  ULy = (CD-AF)/Det = (0-100)/1 = -100
-- ---------------------------------------------------------------------------
do
	local uvs = compute_uvs(1, 0, 0, 0, 1, 100)
	assert_not_nil(uvs, "uv_boundary/100: exactly 100 must pass (> not >=)")
end

-- ---------------------------------------------------------------------------
-- 8. UV boundary: |UV| == 101 must be rejected
--    A=1 B=0 C=0 D=0 E=1 F=101  ->  ULy = -101
-- ---------------------------------------------------------------------------
do
	local uvs, reason = compute_uvs(1, 0, 0, 0, 1, 101)
	assert_nil  (uvs,    "uv_boundary/101: 101 must be rejected")
	assert_equal(reason, "uv_overflow", "uv_boundary/101: reason")
end

-- ---------------------------------------------------------------------------
-- 9. No UV clamping: rotated triangle must produce UVs outside [0,1]
--    This is the critical regression guard -- if someone re-adds UV clamping
--    to [0,1] the rotated triangle test (LRy=-0.5) will catch it.
-- ---------------------------------------------------------------------------
do
	local uvs = compute_uvs(-0.5, -1, 1, 1, 0, 0)
	if uvs then
		local has_outside_01 = false
		for i = 1, 8 do
			if uvs[i] < 0 or uvs[i] > 1 then has_outside_01 = true end
		end
		assert_true(has_outside_01,
			"no_uv_clamp: rotated triangle must produce at least one UV outside [0,1] (LRy expected -0.5)")
	end
end
