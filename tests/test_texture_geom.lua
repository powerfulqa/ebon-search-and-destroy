-- tests/test_texture_geom.lua
-- Unit tests for TextureAdd pre-transform geometry guards and DrawPath byte decoding.
--
-- SOURCE:
--   EbonOverlay/EbonOverlay.lua -- TextureAdd (ScaleX/ScaleY guards, ShearFactor, Sin/Cos)
--   EbonOverlay/EbonOverlay.lua -- DrawPath (12-byte binary coord decoding)
--
-- If either function changes in the source, update the mirrors below to match.

io.write("-- test_texture_geom\n")

local Max16 = 2^16 - 1  -- 65535 -- mirrors DrawPath's Max constant

-- ---------------------------------------------------------------------------
-- Mirror: TextureAdd geometry pre-checks
-- Returns: {ScaleX, ScaleY, ShearFactor, Sin, Cos}, or nil + reason string.
-- Mirrors: EbonOverlay/EbonOverlay.lua, TextureAdd body (before ApplyTransform call)
-- ---------------------------------------------------------------------------
local function compute_geom(Ax, Ay, Bx, By, Cx, Cy)
	local ABx, ABy = Ax - Bx, Ay - By
	local BCx, BCy = Bx - Cx, By - Cy
	local ScaleX = (BCx*BCx + BCy*BCy)^0.5
	if ScaleX == 0 then
		return nil, "scalex_zero"
	end
	local ScaleY = (ABx*BCy - BCx*ABy) / ScaleX
	if ScaleY == 0 then
		return nil, "scaley_zero"
	end
	local ShearFactor = -(ABx*BCx + ABy*BCy) / (ScaleX*ScaleX)
	local Sin = BCy / ScaleX
	local Cos = -BCx / ScaleX
	return {ScaleX=ScaleX, ScaleY=ScaleY, ShearFactor=ShearFactor, Sin=Sin, Cos=Cos}
end

-- ---------------------------------------------------------------------------
-- Mirror: DrawPath coordinate decoding
-- Returns array of {Ax,Ay, Bx,By, Cx,Cy} triangles, or {} for short data.
-- Mirrors: EbonOverlay/EbonOverlay.lua, DrawPath
-- ---------------------------------------------------------------------------
local function decode_path(PathData)
	local triangles = {}
	for Index = 1, #PathData - 11, 12 do
		local Ax1,Ax2,Ay1,Ay2,Bx1,Bx2,By1,By2,Cx1,Cx2,Cy1,Cy2 =
			PathData:byte(Index, Index+11)
		triangles[#triangles+1] = {
			Ax=(Ax1*256+Ax2)/Max16, Ay=(Ay1*256+Ay2)/Max16,
			Bx=(Bx1*256+Bx2)/Max16, By=(By1*256+By2)/Max16,
			Cx=(Cx1*256+Cx2)/Max16, Cy=(Cy1*256+Cy2)/Max16,
		}
	end
	return triangles
end

-- ---------------------------------------------------------------------------
-- 1. ScaleX == 0: B and C are the same point (degenerate edge BC)
-- ---------------------------------------------------------------------------
do
	local g, reason = compute_geom(0,0, 0.5,0.5, 0.5,0.5)
	assert_nil  (g,      "scalex_zero: B==C should be rejected")
	assert_equal(reason, "scalex_zero", "scalex_zero: reason")
end

-- ---------------------------------------------------------------------------
-- 2. ScaleY == 0: A lies exactly on line BC (collinear points)
--    A=(0.5,0) B=(0,0) C=(1,0): all y==0, cross product is 0
-- ---------------------------------------------------------------------------
do
	local g, reason = compute_geom(0.5,0, 0,0, 1,0)
	assert_nil  (g,      "scaley_zero: collinear A-on-BC should be rejected")
	assert_equal(reason, "scaley_zero", "scaley_zero: reason")
end

-- ---------------------------------------------------------------------------
-- 3. Valid right-angle triangle A=(0,1) B=(0,0) C=(1,0)
--    AB = (0,1), BC = (-1,0)
--    ScaleX = 1, ScaleY = 1, ShearFactor = 0, Sin = 0, Cos = 1
-- ---------------------------------------------------------------------------
do
	local g = compute_geom(0,1, 0,0, 1,0)
	assert_not_nil(g, "right_angle: should produce geometry")
	if g then
		assert_equal(g.ScaleX,      1, "right_angle: ScaleX")
		assert_equal(g.ScaleY,      1, "right_angle: ScaleY")
		assert_equal(g.ShearFactor, 0, "right_angle: ShearFactor")
		assert_equal(g.Sin,         0, "right_angle: Sin")
		assert_equal(g.Cos,         1, "right_angle: Cos")
	end
end

-- ---------------------------------------------------------------------------
-- 4. Sin^2 + Cos^2 == 1 (rotation unit-vector invariant) for a random triangle
-- ---------------------------------------------------------------------------
do
	local g = compute_geom(0.2, 0.8, 0.1, 0.3, 0.7, 0.4)
	assert_not_nil(g, "sin_cos_unit: should produce geometry")
	if g then
		local len_sq = g.Sin*g.Sin + g.Cos*g.Cos
		-- Allow floating-point epsilon
		assert_true(math.abs(len_sq - 1) < 1e-9, "sin_cos_unit: Sin^2+Cos^2 must == 1")
	end
end

-- ---------------------------------------------------------------------------
-- 5. DrawPath: too-short data (<12 bytes) produces no triangles
-- ---------------------------------------------------------------------------
do
	local tris = decode_path(string.rep("\0", 11))
	assert_equal(#tris, 0, "drawpath_short: <12 bytes should decode to 0 triangles")
end

-- ---------------------------------------------------------------------------
-- 6. DrawPath: exactly 12 bytes == 1 triangle
-- ---------------------------------------------------------------------------
do
	local tris = decode_path(string.rep("\0", 12))
	assert_equal(#tris, 1, "drawpath_exact12: 12 bytes == 1 triangle")
end

-- ---------------------------------------------------------------------------
-- 7. DrawPath: 25 bytes == 2 triangles (24 used, 1 leftover byte ignored)
--    The loop guard #PathData - 11 ensures partial segments are always skipped.
-- ---------------------------------------------------------------------------
do
	local tris = decode_path(string.rep("\0", 25))
	assert_equal(#tris, 2, "drawpath_partial: 25 bytes == 2 triangles (1 leftover ignored)")
end

-- ---------------------------------------------------------------------------
-- 8. DrawPath: coordinate encoding round-trip
--    Encode a known point (x=0.5, y=0.75) and verify decode reproduces it
--    within 1/Max16 precision (the quantisation step).
--    0.5  -> raw = round(0.5  * 65535) = 32767 or 32768; /65535 ~= 0.5
--    0.75 -> raw = round(0.75 * 65535) = 49151.25 -> 49151; /65535
-- ---------------------------------------------------------------------------
do
	local function encode_coord(v)
		local raw = math.floor(v * Max16 + 0.5)
		raw = math.max(0, math.min(Max16, raw))
		return math.floor(raw / 256), raw % 256
	end
	local ax1, ax2 = encode_coord(0.5)
	local ay1, ay2 = encode_coord(0.75)
	-- Build a 12-byte path: A=(0.5, 0.75), B=(0,0), C=(0,0)
	local bytes = {ax1,ax2, ay1,ay2, 0,0, 0,0, 0,0, 0,0}
	local path = string.char(table.unpack(bytes))
	local tris = decode_path(path)
	assert_equal(#tris, 1, "roundtrip: should decode 1 triangle")
	if tris[1] then
		assert_true(math.abs(tris[1].Ax - 0.5)  < 1/Max16 + 1e-9,
			"roundtrip: Ax ~= 0.5  (got " .. tostring(tris[1].Ax) .. ")")
		assert_true(math.abs(tris[1].Ay - 0.75) < 1/Max16 + 1e-9,
			"roundtrip: Ay ~= 0.75 (got " .. tostring(tris[1].Ay) .. ")")
	end
end

-- ---------------------------------------------------------------------------
-- 9. DrawPath: all decoded coordinates are in [0, 1]
--    Max bytes (0xFF 0xFF) -> (255*256+255)/65535 == 1.0 exactly
--    Min bytes (0x00 0x00) -> 0.0 exactly
-- ---------------------------------------------------------------------------
do
	-- Max value
	local path_max = string.rep("\xFF\xFF", 6)  -- 12 bytes, all 0xFF
	local tris = decode_path(path_max)
	assert_equal(#tris, 1, "coord_range/max: should decode 1 triangle")
	if tris[1] then
		for _, field in ipairs({"Ax","Ay","Bx","By","Cx","Cy"}) do
			assert_true(tris[1][field] >= 0 and tris[1][field] <= 1,
				"coord_range/max: " .. field .. " must be in [0,1]")
		end
	end
	-- Min value
	local path_min = string.rep("\x00\x00", 6)
	local tris2 = decode_path(path_min)
	if tris2[1] then
		for _, field in ipairs({"Ax","Ay","Bx","By","Cx","Cy"}) do
			assert_equal(tris2[1][field], 0, "coord_range/min: " .. field .. " must be 0")
		end
	end
end
