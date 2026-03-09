--[[****************************************************************************
  * EbonSearch by Saiket                                                         *
  * Locales/Locale-deDE.lua - Localized string constants (de-DE).              *
  ****************************************************************************]]


if ( GetLocale() ~= "deDE" ) then
	return;
end


-- See http://wow.curseforge.com/addons/npcscan/localization/deDE/
local EbonSearch = select( 2, ... );
EbonSearch.L.NPCs = setmetatable( {
	[ 18684 ] = "Bro'Gaz der Klanlose",
	[ 32491 ] = "Zeitverlorener Protodrache",
	[ 33776 ] = "Gondria",
	[ 35189 ] = "Skoll",
	[ 38453 ] = "Arcturis",
}, { __index = EbonSearch.L.NPCs; } );