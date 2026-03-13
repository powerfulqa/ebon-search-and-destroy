--[[****************************************************************************
  * EbonOverlay                                                 *
  * Locales/Locale-enUS.lua - Localized string constants (en-US).              *
  ****************************************************************************]]


-- See http://wow.curseforge.com/addons/npcscan-overlay/localization/enUS/
EbonOverlayLocalization = setmetatable( {
	NPCS = { -- Note: Don't use a metatable default; Missing keys must return nil
		[ 1140 ] = "Razormaw Matriarch",
		[ 5842 ] = "Takk the Leaper",
		[ 6581 ] = "Ravasaur Matriarch",
		[ 14232 ] = "Dart",
		[ 18684 ] = "Bro'Gaz the Clanless",
		[ 32491 ] = "Time-Lost Proto Drake",
		[ 33776 ] = "Gondria",
		[ 35189 ] = "Skoll",
		[ 38453 ] = "Arcturis",
	};

	CONFIG_ALPHA = "Alpha",
	CONFIG_DESC = "Choose which maps show mob path overlays.  Most map addons use the World Map setting.",
	CONFIG_SHOWALL = "Always show all paths",
	CONFIG_SHOWALL_DESC = "Normally, paths are hidden for mobs you aren't tracking.  Turn this on to always show every known patrol route.",
	CONFIG_TITLE = "Overlay",
	CONFIG_TITLE_STANDALONE = "|cff66ccffEbonhold|r Overlay",
	CONFIG_ZONE = "Zone:",
	MODULE_ALPHAMAP3 = "AlphaMap3 AddOn",
	MODULE_BATTLEFIELDMINIMAP = "Battlefield-Minimap Popout",
	MODULE_MINIMAP = "Minimap",
	MODULE_RANGERING_DESC = "The range ring only appears in zones with tracked rares.",
	MODULE_RANGERING_FORMAT = "Show %dyd ring for approximate detection range",
	MODULE_WORLDMAP = "Main World Map",
	MODULE_WORLDMAP_KEY = "|cff3399ffEbon|r|cffFFCC00Overlay|r",
	MODULE_WORLDMAP_KEY_FORMAT = "• %s",
	MODULE_WORLDMAP_TOGGLE = "|cff3399ffEbon|r|cffFFCC00Overlay|r",
	MODULE_WORLDMAP_TOGGLE_DESC = "Shows |cff3399ffEbon|r|cffFFCC00Overlay|r patrol paths for tracked NPCs.",

	-- Phrases localized by default UI
	CONFIG_ENABLE = ENABLE;
}, {
	__index = function ( self, Key )
		if ( Key ~= nil ) then
			rawset( self, Key, Key );
			return Key;
		end
	end;
} );


SLASH__EBONSEARCH_OVERLAY1 = "/npcscanoverlay";
SLASH__EBONSEARCH_OVERLAY2 = "/EbonOverlay";
SLASH__EBONSEARCH_OVERLAY3 = "/overlay";