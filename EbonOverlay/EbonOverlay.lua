--[[****************************************************************************
  * EbonOverlay                                                 *
  * EbonOverlay.lua - Adds mob patrol paths to your map.                  *
  ****************************************************************************]]


EbonSearch = EbonSearch or {};
local EbonSearch = EbonSearch;
local AddOnName, me = ...;
EbonOverlay = me;

me.Version = GetAddOnMetadata( AddOnName, "Version" ):match( "^([%d.]+)" );

me.Options = {
	Version = me.Version;
	Modules = {};
	ModulesAlpha = {};
	ModulesExtra = {};
	Discoveries = {}; -- [Ebonhold] Phase 2: { [Map] = { [NpcID] = {X, Y} } }
};

me.OptionsDefault = {
	Version = me.Version;
	Modules = {};
	ModulesAlpha = {};
	ModulesExtra = {};
	ShowAll = false;
	Discoveries = {}; -- [Ebonhold] Phase 2
};


me.NPCMaps = {}; -- [ NpcID ] = MapName;
me.NPCsEnabled = {};
me.NPCsFoundX = {};
me.NPCsFoundY = {};
me.NPCsFoundIgnored = {
	[ 32487 ] = true; -- Putridus the Ancient
};
me.Achievements = { -- Achievements whos criteria mobs are all mapped
	[ 1312 ] = true; -- Bloody Rare (Outlands)
	[ 2257 ] = true; -- Frostbitten (Northrend)
};

me.Colors = {
	RAID_CLASS_COLORS.SHAMAN,
	RAID_CLASS_COLORS.DEATHKNIGHT,
	GREEN_FONT_COLOR,
	RAID_CLASS_COLORS.DRUID,
	RAID_CLASS_COLORS.PALADIN,
};

me.DetectionRadius = 100; -- yards

local TexturesUnused = CreateFrame( "Frame" );

local MESSAGE_REGISTER = "EbonOverlay_RegisterScanner";
local MESSAGE_ADD = "EbonOverlay_Add";
local MESSAGE_REMOVE = "EbonOverlay_Remove";
local MESSAGE_FOUND = "EbonOverlay_Found";




--[[****************************************************************************
  * Function: EbonOverlay.SafeCall                                        *
  * Description: Catches errors and throws them without ending execution.      *
  ****************************************************************************]]
do
	local function Catch ( Success, ... )
		if ( not Success ) then
			geterrorhandler()( ... );
		end
		return Success, ...;
	end
	local pcall = pcall;
	function me.SafeCall ( Function, ... )
		return Catch( pcall( Function, ... ) );
	end
end


--[[****************************************************************************
  * Function: EbonOverlay:TextureCreate                                   *
  * Description: Prepares an unused texture on the given frame.                *
  ****************************************************************************]]
function me:TextureCreate ( Layer, R, G, B, A )
	local Texture = #TexturesUnused > 0 and TexturesUnused[ #TexturesUnused ];
	if ( Texture ) then
		TexturesUnused[ #TexturesUnused ] = nil;
		Texture:SetParent( self );
		Texture:SetDrawLayer( Layer );
		Texture:ClearAllPoints();
		Texture:Show();
	else
		Texture = self:CreateTexture( nil, Layer );
	end
	Texture:SetVertexColor( R, G, B, A or 1 );
	Texture:SetBlendMode( "BLEND" );

	self[ #self + 1 ] = Texture;
	return Texture;
end
--[[****************************************************************************
  * Function: EbonOverlay:TextureAdd                                      *
  * Description: Draw a triangle texture with vertices at relative coords.     *
  ****************************************************************************]]
do
	local ApplyTransform;
	local Texture;
	do
		local Det, AF, BF, CD, CE;
		local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy;
		function ApplyTransform( A, B, C, D, E, F )
			Det = A * E - B * D;
			-- Hard-reject degenerate transform; clamping just smears it across the map
			if ( Det == 0 or Det ~= Det ) then
				Texture:Hide();
				return;
			end
			AF, BF, CD, CE = A * F, B * F, C * D, C * E;

			ULx, ULy = ( BF - CE ) / Det, ( CD - AF ) / Det;
			LLx, LLy = ( BF - CE - B ) / Det, ( CD - AF + A ) / Det;
			URx, URy = ( BF - CE + E ) / Det, ( CD - AF - D ) / Det;
			LRx, LRy = ( BF - CE + E - B ) / Det, ( CD - AF - D + A ) / Det;

			-- Hard-reject NaN UVs (inf/inf from near-zero Det slips past == 0 check)
			if (
				ULx ~= ULx or ULy ~= ULy or
				LLx ~= LLx or LLy ~= LLy or
				URx ~= URx or URy ~= URy or
				LRx ~= LRx or LRy ~= LRy
			) then
				Texture:Hide();
				return;
			end

			Texture:SetTexCoord( ULx, ULy, LLx, LLy, URx, URy, LRx, LRy );
		end
	end
	local MinX, MinY, WindowX, WindowY;
	local ABx, ABy, BCx, BCy;
	local ScaleX, ScaleY, ShearFactor, Sin, Cos;
	local Parent, Width, Height;
	local SinScaleX, SinScaleY, CosScaleX, CosScaleY;
	local BorderScale, BorderOffset = 512 / 510, -1 / 512; -- Removes one-pixel transparent border
	function me:TextureAdd ( Layer, R, G, B, Ax, Ay, Bx, By, Cx, Cy )
		ABx, ABy, BCx, BCy = Ax - Bx, Ay - By, Bx - Cx, By - Cy;
		ScaleX = ( BCx * BCx + BCy * BCy ) ^ 0.5;
		if ( ScaleX == 0 ) then
			return;
		end
		ScaleY = ( ABx * BCy - BCx * ABy ) / ScaleX;
		if ( ScaleY == 0 ) then
			return;
		end
		ShearFactor = -( ABx * BCx + ABy * BCy ) / ( ScaleX * ScaleX );
		Sin, Cos = BCy / ScaleX, -BCx / ScaleX;


		-- Get a texture
		Texture = me.TextureCreate( self, Layer, R, G, B );
		Texture:SetTexture( [[Interface\AddOns\EbonOverlay\Skin\Triangle]] );


		-- Note: The texture region is made as small as possible to improve framerates.
		MinX, MinY = min( Ax, Bx, Cx ), min( Ay, By, Cy );
		WindowX, WindowY = max( Ax, Bx, Cx ) - MinX, max( Ay, By, Cy ) - MinY;

		Width, Height = self:GetWidth(), self:GetHeight();
		Texture:SetPoint( "TOPLEFT", MinX * Width, -MinY * Height );
		Texture:SetSize( WindowX * Width, WindowY * Height );


		--[[ Transform parallelogram so its corners lie on the tri's points:
		local Matrix = Identity;
		-- Remove transparent border
		Matrix = Matrix:Scale( BorderScale, BorderScale );
		Matrix = Matrix:Translate( BorderOffset, BorderOffset );

		Matrix = Matrix:Shear( ShearFactor ); -- Shear the image so its bottom left corner aligns with point A
		Matrix = Matrix:Scale( ScaleX, ScaleY ); -- Scale X by the length of line BC, and Y by the length of the perpendicular line from BC to point A
		Matrix = Matrix:Rotate( Sin, Cos ); -- Align the top of the triangle with line BC.

		Matrix = Matrix:Translate( Bx - MinX, By - MinY ); -- Move origin to overlap point B
		Matrix = Matrix:Scale( 1 / WindowX, 1 / WindowY ); -- Adjust for change in texture size

		ApplyTransform( unpack( Matrix, 1, 6 ) );
		]]

		-- Common operations
		WindowX, WindowY = BorderScale / WindowX, BorderScale / WindowY;
		SinScaleX, SinScaleY = -Sin * ScaleX, Sin * ScaleY;
		CosScaleX, CosScaleY =  Cos * ScaleX, Cos * ScaleY;

		ApplyTransform(
			WindowX * CosScaleX,
			WindowX * ( SinScaleY + CosScaleX * ShearFactor ),
			WindowX * ( ( SinScaleY + CosScaleX * ( 1 + ShearFactor ) ) * BorderOffset + Bx - MinX ) / BorderScale,
			WindowY * SinScaleX,
			WindowY * ( CosScaleY + SinScaleX * ShearFactor ),
			WindowY * ( ( CosScaleY + SinScaleX * ( 1 + ShearFactor ) ) * BorderOffset + By - MinY ) / BorderScale );
	end
end
--[[****************************************************************************
  * Function: EbonOverlay:TextureRemoveAll                                *
  * Description: Removes all triangle textures from a frame.                   *
  ****************************************************************************]]
function me:TextureRemoveAll ()
	for Index = #self, 1, -1 do
		local Texture = self[ Index ];
		self[ Index ] = nil;
		Texture:Hide();
		Texture:SetParent( TexturesUnused );
		TexturesUnused[ #TexturesUnused + 1 ] = Texture;
	end
end


--[[****************************************************************************
  * Function: EbonOverlay:DrawPath                                        *
  * Description: Draws the given NPC's path onto a frame.                      *
  ****************************************************************************]]
do
	local Max = 2 ^ 16 - 1;
	local Ax1, Ax2, Ay1, Ay2, Bx1, Bx2, By1, By2, Cx1, Cx2, Cy1, Cy2;
	function me:DrawPath ( PathData, Layer, R, G, B )
		for Index = 1, #PathData - 11, 12 do  -- guard: only iterate complete 12-byte segments
			Ax1, Ax2, Ay1, Ay2, Bx1, Bx2, By1, By2, Cx1, Cx2, Cy1, Cy2 = PathData:byte( Index, Index + 11 );
			me.TextureAdd( self, Layer, R, G, B,
				( Ax1 * 256 + Ax2 ) / Max, ( Ay1 * 256 + Ay2 ) / Max,
				( Bx1 * 256 + Bx2 ) / Max, ( By1 * 256 + By2 ) / Max,
				( Cx1 * 256 + Cx2 ) / Max, ( Cy1 * 256 + Cy2 ) / Max );
		end
	end
end
--[[****************************************************************************
  * Function: EbonOverlay:DrawFound                                       *
  * Description: Adds a found NPC's range circle onto a frame.                 *
  ****************************************************************************]]
do
	local RingWidth = 1.14; -- Ratio of texture width to ring width
	local GlowWidth = 1.25;
	local Width, Height, Size;
	local Texture;
	function me:DrawFound ( X, Y, RadiusX, Layer, R, G, B )
		Width, Height = self:GetWidth(), self:GetHeight();

		X, Y = X * Width, -Y * Height;
		Size = RadiusX * 2 * Width;

		Texture = me.TextureCreate( self, Layer, R, G, B );
		Texture:SetTexture( [[Interface\Minimap\Ping\ping2]] );
		Texture:SetTexCoord( 0, 1, 0, 1 );
		Texture:SetBlendMode( "ADD" );
		Texture:SetPoint( "CENTER", self, "TOPLEFT", X, Y );
		Texture:SetSize( Size * RingWidth, Size * RingWidth );

		Texture = me.TextureCreate( self, Layer, R, G, B, 0.5 );
		Texture:SetTexture( [[Textures\SunCenter]] );
		Texture:SetTexCoord( 0, 1, 0, 1 );
		Texture:SetBlendMode( "ADD" );
		Texture:SetPoint( "CENTER", self, "TOPLEFT", X, Y );
		Texture:SetSize( Size * GlowWidth, Size * GlowWidth );
	end
end
--[[****************************************************************************
  * Function: EbonOverlay:DrawDiscoveryMarker                             *
  * Description: Draws a small gold pin at a fractional map position for       *
  *   NPCs that have no patrol path data.                                      *
  ****************************************************************************]]
do
	local Width, Height, Texture;
	function me:DrawDiscoveryMarker ( X, Y, Layer )
		Width, Height = self:GetWidth(), self:GetHeight();
		X, Y = X * Width, -Y * Height;

		-- Gold ring
		Texture = me.TextureCreate( self, Layer, 1, 0.82, 0 );
		Texture:SetTexture( [[Interface\Minimap\Ping\ping2]] );
		Texture:SetTexCoord( 0, 1, 0, 1 );
		Texture:SetBlendMode( "ADD" );
		Texture:SetPoint( "CENTER", self, "TOPLEFT", X, Y );
		Texture:SetSize( 18, 18 );

		-- Centre glow
		Texture = me.TextureCreate( self, Layer, 1, 0.82, 0, 0.9 );
		Texture:SetTexture( [[Textures\SunCenter]] );
		Texture:SetTexCoord( 0, 1, 0, 1 );
		Texture:SetBlendMode( "ADD" );
		Texture:SetPoint( "CENTER", self, "TOPLEFT", X, Y );
		Texture:SetSize( 10, 10 );
	end
end
--[[****************************************************************************
  * Function: EbonOverlay:ApplyZone                                       *
  * Description: Passes the NpcID, color, PathData, ZoneWidth, and ZoneHeight  *
  *   of all NPCs in a zone to a callback function.                            *
  ****************************************************************************]]
function me:ApplyZone ( Map, Callback )
	local MapData = me.PathData[ Map ];
	if ( MapData ) then
		local ColorIndex = 0;

		for NpcID, PathData in pairs( MapData ) do
			ColorIndex = ColorIndex + 1;
			if ( me.Options.ShowAll or me.NPCsEnabled[ NpcID ] ) then
				local Color = me.Colors[ ( ColorIndex - 1 ) % #me.Colors + 1 ];
				Callback( self, PathData, me.NPCsFoundX[ NpcID ], me.NPCsFoundY[ NpcID ], Color.r, Color.g, Color.b, NpcID );
			end
		end
	end
end




--[[****************************************************************************
  * Function: EbonOverlay.NPCAdd                                          *
  ****************************************************************************]]
function me.NPCAdd ( NpcID )
	local Map = me.NPCMaps[ NpcID ];
	if ( Map and not me.NPCsEnabled[ NpcID ] ) then
		me.NPCsEnabled[ NpcID ] = true;

		if ( not me.Options.ShowAll ) then
			me.Modules.UpdateMap( Map );
		end
		return true;
	end
end
--[[****************************************************************************
  * Function: EbonOverlay.NPCRemove                                       *
  ****************************************************************************]]
function me.NPCRemove ( NpcID )
	if ( me.NPCsEnabled[ NpcID ] ) then
		me.NPCsEnabled[ NpcID ] = nil;

		if ( not me.Options.ShowAll ) then
			me.Modules.UpdateMap( me.NPCMaps[ NpcID ] );
		end
		return true;
	end
end
--[[****************************************************************************
  * Function: EbonOverlay.NPCFound                                        *
  ****************************************************************************]]
function me.NPCFound ( NpcID, Name )
	-- [Ebonhold] debug: trace NPCFound entry to verify pin path
	print( "NPCFound", Name or NpcID, "Map:", me.NPCMaps[ NpcID ] and "yes (path data)" or "no (pin only)" );
	-- [Ebonhold] Phase 2: helpers
	local function NpcName ()
		if ( Name and Name ~= "" ) then return Name; end
		local L = EbonSearch and EbonSearch.L;
		return ( L and L.NPCs and L.NPCs[ NpcID ] )
			or ( EbonSearch and EbonSearch.OptionsCharacter and EbonSearch.OptionsCharacter.NPCs and EbonSearch.OptionsCharacter.NPCs[ NpcID ] )
			or tostring( NpcID );
	end
	local function ChatPrint ( msg )
		if ( EbonSearch and EbonSearch.Print ) then
			EbonSearch.Print( "|cff66ccffEbonOverlay:|r " .. msg );
		end
	end
	local function StoreDiscovery ( Map, X, Y )
		if ( not me.Options.Discoveries ) then me.Options.Discoveries = {}; end
		if ( not me.Options.Discoveries[ Map ] ) then me.Options.Discoveries[ Map ] = {}; end
		me.Options.Discoveries[ Map ][ NpcID ] = { X, Y };
	end

	local Map = me.NPCMaps[ NpcID ];
	if ( Map and not me.NPCsFoundIgnored[ NpcID ] ) then
		SetMapToCurrentZone();

		if ( Map == GetCurrentMapAreaID() - 1 ) then
			local X, Y = GetPlayerMapPosition( "player" );
			if ( X ~= 0 and Y ~= 0 ) then
				me.NPCsFoundX[ NpcID ], me.NPCsFoundY[ NpcID ] = X, Y;
				StoreDiscovery( Map, X, Y );
				me.Modules.UpdateMap( Map ); -- always repaint so pin appears
				return true;
			end
		end
	elseif ( not Map ) then
		-- [Ebonhold] Phase 2: no path data - still capture position and draw a map pin
		SetMapToCurrentZone();
		local CurrentMap = GetCurrentMapAreaID() - 1;
		local X, Y = GetPlayerMapPosition( "player" );
		print( "=== NPCFound DEBUG ===" );
		print( "npc:", NpcName() );
		print( "x,y:", X, Y );
		print( "CurrentMap:", CurrentMap );
		if ( X ~= 0 and Y ~= 0 and CurrentMap > 0 ) then
			print( "StoreDiscovery CALL" );
			local success, err = pcall( StoreDiscovery, CurrentMap, X, Y );
			print( "StoreDiscovery result:", success, err or "no error" );
			print( "UpdateMap CALL", CurrentMap );
			local success2, err2 = pcall( me.Modules.UpdateMap, CurrentMap );
			print( "UpdateMap result:", success2, err2 or "no error" );
		else
			print( "skipped: x/y zero or invalid map" );
			ChatPrint( "No map data for |cffFFFF00" .. NpcName() .. "|r: position could not be determined" );
		end
		print( "=== END DEBUG ===" );
	end
end
do
	local ScannerAddOn;
--[[****************************************************************************
  * Function: EbonOverlay[ MESSAGE_REGISTER ]                             *
  ****************************************************************************]]
	me[ MESSAGE_REGISTER ] = function ( _, Event, AddOn )
		me:UnregisterMessage( Event );
		me[ Event ] = nil;
		ScannerAddOn = assert( AddOn, "Registration message must provide an addon identifier." );

		-- Quit showing all by default and let the scanning addon control visibility
		for NpcID in pairs( me.NPCsEnabled ) do
			me.NPCRemove( NpcID );
		end

		me:RegisterMessage( MESSAGE_ADD );
		me:RegisterMessage( MESSAGE_REMOVE );
	end;
--[[****************************************************************************
  * Function: EbonOverlay[ MESSAGE_ADD ]                                  *
  ****************************************************************************]]
	me[ MESSAGE_ADD ] = function ( _, _, NpcID, AddOn )
		if ( AddOn == ScannerAddOn ) then
			me.NPCAdd( assert( tonumber( NpcID ), "Add message Npc ID must be a number." ) );
		end
	end;
--[[****************************************************************************
  * Function: EbonOverlay[ MESSAGE_REMOVE ]                               *
  ****************************************************************************]]
	me[ MESSAGE_REMOVE ] = function ( _, _, NpcID, AddOn )
		if ( AddOn == ScannerAddOn ) then
			me.NPCRemove( assert( tonumber( NpcID ), "Remove message Npc ID must be a number." ) );
		end
	end;
--[[****************************************************************************
  * Function: EbonOverlay[ MESSAGE_FOUND ]                                *
  ****************************************************************************]]
	me[ MESSAGE_FOUND ] = function ( _, _, NpcID, _, Name )
		me.NPCFound( assert( tonumber( NpcID ), "Found message Npc ID must be a number." ), Name );
	end;
end




--[[****************************************************************************
  * Function: EbonOverlay.SetShowAll                                      *
  * Description: Enables always showing all paths.                             *
  ****************************************************************************]]
function me.SetShowAll ( Enable )
	Enable = not not Enable;
	if ( Enable ~= me.Options.ShowAll ) then
		me.Options.ShowAll = Enable;

		me.Config.ShowAll:SetChecked( Enable );

		-- Update all affected maps
		for Map, MapData in pairs( me.PathData ) do
			-- If a map has a disabled path, it must be redrawn
			for NpcID in pairs( MapData ) do
				if ( not me.NPCsEnabled[ NpcID ] ) then
					me.Modules.UpdateMap( Map );
					break;
				end
			end
		end

		return true;
	end
end


--[[****************************************************************************
  * Function: EbonOverlay.Synchronize                                     *
  * Description: Reloads enabled modules from saved settings.                  *
  ****************************************************************************]]
function me.Synchronize ( Options )
	-- Load defaults if settings omitted
	if ( not Options ) then
		Options = me.OptionsDefault;
	end

	me.SetShowAll( Options.ShowAll );
	me.Modules.OnSynchronize( Options );
end
--[[****************************************************************************
  * Function: EbonOverlay:ADDON_LOADED                                    *
  ****************************************************************************]]
function me:ADDON_LOADED ( Event, AddOn )
	if ( AddOn == AddOnName ) then
		me[ Event ] = nil;
		me:UnregisterEvent( Event );

		-- Build a reverse lookup of NPC IDs to zones, and add them all by default
		for Map, MapData in pairs( me.PathData ) do
			for NpcID in pairs( MapData ) do
				me.NPCMaps[ NpcID ] = Map;
				me.NPCAdd( NpcID );
			end
		end

		local Options = EbonOverlayDB;
		EbonOverlayDB = me.Options;
		if ( Options and not Options.ModulesExtra ) then -- 3.3.5.1: Moved module options to options sub-tables
			Options.ModulesExtra = {};
		end
		me.Synchronize( Options ); -- Loads defaults if nil

		-- [Ebonhold] Phase 2: restore saved discovery positions so overlay markers are
		-- visible from session start without needing to re-detect the NPC.
		if ( Options and Options.Discoveries ) then
			me.Options.Discoveries = Options.Discoveries;
			for _, NpcTable in pairs( Options.Discoveries ) do
				for NpcID, pos in pairs( NpcTable ) do
					me.NPCsFoundX[ NpcID ] = pos[ 1 ];
					me.NPCsFoundY[ NpcID ] = pos[ 2 ];
				end
			end
		end

		me:RegisterMessage( MESSAGE_REGISTER );
		me:RegisterMessage( MESSAGE_FOUND );
	end
end




LibStub( "AceEvent-3.0" ):Embed( me );
me:RegisterEvent( "ADDON_LOADED" );