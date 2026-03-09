--[[****************************************************************************
  * EbonSearch                                                                   *
  * EbonSearch.MinimapButton.lua - Minimap icon with zone-radar tooltip.         *
  * [Ebonhold] v2.0.0: standalone minimap button, no LibDBIcon dependency.       *
  ****************************************************************************]]

local EbonSearch = select( 2, ... );

-- Minimap button angle is stored in Options so it persists across sessions.
-- Angle is in radians measured clockwise from the top of the minimap.
local MIN_ANGLE_DEFAULT = math.pi * 0.75; -- bottom-left quadrant

do
	local icon = CreateFrame( "Button", "EbonSearchMinimapButton", Minimap );
	EbonSearch.MinimapButton = icon;

	icon:SetSize( 31, 31 );
	icon:SetFrameStrata( "MEDIUM" );
	icon:SetFrameLevel( 8 );
	icon:EnableMouse( true );
	icon:SetMovable( true );
	icon:RegisterForClicks( "AnyUp" );
	icon:RegisterForDrag( "LeftButton" );

	-- Icon texture — sized to fit inside the ~30px circular hole of the border ring
	local tex = icon:CreateTexture( nil, "BACKGROUND" );
	tex:SetSize( 20, 20 );
	tex:SetPoint( "CENTER" );
	tex:SetTexture( "Interface\\Icons\\Ability_Spy" ); -- eye/scan icon

	-- Hover highlight (standard minimap button glow)
	local hilite = icon:CreateTexture( nil, "HIGHLIGHT" );
	hilite:SetSize( 24, 24 );
	hilite:SetPoint( "CENTER" );
	hilite:SetTexture( "Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight" );
	hilite:SetBlendMode( "ADD" );

	-- Border ring: 56×56, offset so its centre aligns with the 31×31 button centre
	-- TOPLEFT of border sits 12px left and 12px above button TOPLEFT
	local border = icon:CreateTexture( nil, "OVERLAY" );
	border:SetSize( 56, 56 );
	border:SetPoint( "TOPLEFT", icon, "TOPLEFT", -12, 12 );
	border:SetTexture( "Interface\\Minimap\\MiniMap-TrackingBorder" );

	-- Position helpers --------------------------------------------------------
	local RADIUS = 80; -- px from minimap centre

	local function SetAngle ( angle )
		if ( not EbonSearch.Options ) then return; end
		EbonSearch.Options.MinimapAngle = angle;
		icon:SetPoint( "CENTER", Minimap, "CENTER",
			RADIUS * math.cos( angle ),
		   -RADIUS * math.sin( angle ) );
	end

	local function GetAngle ()
		return ( EbonSearch.Options and EbonSearch.Options.MinimapAngle )
			or MIN_ANGLE_DEFAULT;
	end

	-- Drag to reposition -------------------------------------------------------
	icon:SetScript( "OnDragStart", function ( self )
		self:SetScript( "OnUpdate", function ( self )
			local mx, my = Minimap:GetCenter();
			local cx, cy = GetCursorPosition();
			local scale  = UIParent:GetEffectiveScale();
			cx, cy = cx / scale, cy / scale;
			SetAngle( math.atan2( mx - cx, cy - my ) );
		end );
	end );
	icon:SetScript( "OnDragStop", function ( self )
		self:SetScript( "OnUpdate", nil );
	end );

	-- Tooltip ------------------------------------------------------------------
	icon:SetScript( "OnEnter", function ( self )
		GameTooltip:SetOwner( self, "ANCHOR_LEFT" );
		GameTooltip:ClearLines();
		GameTooltip:AddLine( "|cff3399ffEbonhold Search & Destroy|r" );

		local zone = GetRealZoneText();
		local blacklist = EbonSearch.Options and EbonSearch.Options.ZoneBlacklist or {};
		if ( blacklist[ zone ] ) then
			GameTooltip:AddLine( "|cffFF4444Scanning DISABLED in:|r |cffFFFF00" .. zone .. "|r" );
		else
			GameTooltip:AddLine( "Scanning in: |cffFFFF00" .. ( zone ~= "" and zone or "Unknown" ) .. "|r" );
		end

		-- Count active scans
		local count = 0;
		local npcs  = EbonSearch.OptionsCharacter and EbonSearch.OptionsCharacter.NPCs;
		if ( npcs ) then
			for _ in pairs( npcs ) do count = count + 1; end
		end
		GameTooltip:AddLine( "Tracking " .. count .. " rare(s)" );

		GameTooltip:AddLine( " " );
		GameTooltip:AddLine( "|cff808080Left-click|r: open options" );
		GameTooltip:AddLine( "|cff808080Right-click|r: toggle zone blacklist" );
		GameTooltip:AddLine( "|cff808080Drag|r: reposition" );
		GameTooltip:Show();
	end );
	icon:SetScript( "OnLeave", GameTooltip_Hide );

	-- Clicks -------------------------------------------------------------------
	icon:SetScript( "OnClick", function ( self, button )
		if ( button == "LeftButton" ) then
			InterfaceOptionsFrame_OpenToCategory( EbonSearch.Config );
			InterfaceOptionsFrame_OpenToCategory( EbonSearch.Config );
		elseif ( button == "RightButton" ) then
			local zone = GetRealZoneText();
			if ( zone and zone ~= "" ) then
				if ( not EbonSearch.Options.ZoneBlacklist ) then
					EbonSearch.Options.ZoneBlacklist = {};
				end
				if ( EbonSearch.Options.ZoneBlacklist[ zone ] ) then
					EbonSearch.Options.ZoneBlacklist[ zone ] = nil;
					EbonSearch.Print( "Zone scanning resumed: |cffFFFF00" .. zone .. "|r", GREEN_FONT_COLOR );
				else
					EbonSearch.Options.ZoneBlacklist[ zone ] = true;
					EbonSearch.Print( "Zone blacklisted: |cffFFFF00" .. zone .. "|r", GREEN_FONT_COLOR );
				end
				if ( EbonSearch.Config and EbonSearch.Config.ZoneBlacklist ) then
					EbonSearch.Config.ZoneBlacklist.Refresh();
				end
			end
		end
	end );

	-- Position on PLAYER_LOGIN (Options available) -----------------------------
	local initFrame = CreateFrame( "Frame" );
	initFrame:RegisterEvent( "PLAYER_LOGIN" );
	initFrame:SetScript( "OnEvent", function ( self )
		self:UnregisterEvent( "PLAYER_LOGIN" );
		SetAngle( GetAngle() );
	end );

	-- Default angle for fresh installs (Options not populated at file-load time)
	icon:SetPoint( "CENTER", Minimap, "CENTER",
		RADIUS * math.cos( MIN_ANGLE_DEFAULT ),
	   -RADIUS * math.sin( MIN_ANGLE_DEFAULT ) );
end
