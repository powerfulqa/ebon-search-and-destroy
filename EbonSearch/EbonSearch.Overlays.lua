--[[****************************************************************************
  * EbonSearch                                                         *
  * EbonSearch.Overlays.lua - Integration with NPC map overlay mods.       *
  ****************************************************************************]]


local AddOnName, EbonSearch = ...;
local me = LibStub( "AceEvent-3.0" ):Embed( {} );
EbonSearch.Overlays = me;

local MESSAGE_REGISTER = "EbonOverlay_RegisterScanner";
local MESSAGE_ADD = "EbonOverlay_Add";
local MESSAGE_REMOVE = "EbonOverlay_Remove";
local MESSAGE_FOUND = "EbonOverlay_Found";




--- Announces to overlay mods that EbonSearch will take over control of shown paths.
function me.Register ()
	me:SendMessage( MESSAGE_REGISTER, AddOnName );
end


--- Enables overlay maps for a given NPC ID.
function me.Add ( NpcID )
	me:SendMessage( MESSAGE_ADD, NpcID, AddOnName );
end
--- Disables overlay maps for a given NPC ID.
function me.Remove ( NpcID )
	me:SendMessage( MESSAGE_REMOVE, NpcID, AddOnName );
end
-- Lets overlay mods know the NPC ID was found.
function me.Found ( NpcID, Name )
	me:SendMessage( MESSAGE_FOUND, NpcID, AddOnName, Name );
end