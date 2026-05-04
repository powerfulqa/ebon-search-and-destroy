--[[****************************************************************************
 *  EbonSearch - Rare NPC scanner for Project Ebonhold (WoW 3.3.5a)
 *  Author:   Serv (powerfulqa)
 *  Source:   https://github.com/powerfulqa/ebon-search-and-destroy
 *  License:  GPLv3; attribution preservation is required (see LICENSE).
 *
 *  EbonSearch.lua - Scans NPCs near you for specific rare NPC IDs.
 ******************************************************************************]]


local AddOnName, me = ...;
EbonSearch = me;
local L = me.L;

me.Frame = CreateFrame( "Frame" );
me.Version = GetAddOnMetadata( AddOnName, "Version" ):match( "^([%d.]+)" );

-- Provenance: stamp author + source URL into globals so /run introspection
-- and addon-management tools can identify the origin of any forked or
-- repackaged copy. The double-underscore-prefix convention is shared with
-- EbonClearance and BarWarden for cross-addon consistency. me.Author /
-- me.URL are the single source of truth read by the config-panel byline.
me.Author = "Serv";
me.URL    = "https://github.com/powerfulqa/ebon-search-and-destroy";
_G["EBONSEARCH_IDENT"]    = "EbonSearch";
_G["EBONSEARCH_AUTHOR"]   = me.Author;
_G["EBONSEARCH_ORIGIN"]   = me.URL;
_G["__EbonSearch_origin"] = me.URL;
_G["__EbonSearch_author"] = me.Author;

-- Salted, deterministic 24-bit hash. Not cryptographic; the goal is trivial
-- verifiability of EbonSearch origin in any derivative work. Salt format
-- and watermark export mirror EbonClearance / BarWarden. Do NOT refactor
-- the salt string away; its presence in code is the point.
local function ES_Fingerprint( payload )
	local SALT = "EbonSearch|Serv|powerfulqa|2026";
	local s = ( payload or "" ) .. "|" .. SALT;
	local h = 5381;
	for i = 1, #s do
		h = ( ( h * 33 ) + string.byte( s, i ) ) % 16777216;
	end
	return string.format( "%06x", h );
end
_G["__EbonSearch_watermark"] = ES_Fingerprint( "EbonSearch@" .. me.Version );

me.Options = {
	Version = me.Version;
	DisableCache = true;
	ZoneBlacklist = {}; -- [Ebonhold] v2.0.0: [ ZoneName ] = true to suppress scanning in that zone
	MinimapAngle = math.pi * 0.75; -- [Ebonhold] v2.0.0: minimap button position angle (radians, clockwise from top)
	FilterWildlife = true; -- [Ebonhold] v2.1.7: suppress known non-rare wildlife misfires (e.g. Barrens Plainsstrider/Giraffe)
	WildlifeBlacklist = {}; -- [Ebonhold] v2.2.0: [ Name ] = true, user-editable via /esd wildlife add/remove; merged with builtin list at runtime
	WildlifeBlacklistNorm = {}; -- [Ebonhold] v2.2.3: [ normalized_name ] = true, lookup-side mirror for case-insensitive match; rebuilt in Synchronize from WildlifeBlacklist
};
me.OptionsCharacter = {
Version = me.Version;
NPCs = {};
NPCWorldIDs = {};
Achievements = {};
};
me.OptionsCharacterDefault = {
Version = me.Version;
	NPCs = {
	    -- Eastern Kingdoms
	    [ 16392 ] = "Captain Armando Ossex", -- Alterac Mountains
	    [ 13776 ] = "Corporal Teeka Bloodsnarl", -- Alterac Mountains
	    [ 2422 ] = "Glommus", -- Alterac Mountains
	    [ 3985 ] = "Grandpa Vishas", -- Alterac Mountains
	    [ 13219 ] = "Jekyll Flandring", -- Alterac Mountains
	    [ 13841 ] = "Lieutenant Haggerdin", -- Alterac Mountains
	    [ 2421 ] = "Muckrake", -- Alterac Mountains
	    [ 13085 ] = "Myrokos Silentform", -- Alterac Mountains
	    [ 3984 ] = "Nancy Vishas", -- Alterac Mountains
	    [ 2447 ] = "Narillasanz", -- Alterac Mountains
	    [ 13777 ] = "Sergeant Durgen Stormpike", -- Alterac Mountains
	    [ 2420 ] = "Targ", -- Alterac Mountains
	    [ 13217 ] = "Thanthaldis Snowgleam", -- Alterac Mountains
	    [ 13602 ] = "The Abominable Greench", -- Alterac Mountains
	    [ 13840 ] = "Warmaster Laggrond", -- Alterac Mountains
	    [ 2782 ] = "Caretaker Alaric", -- Arathi Highlands
	    [ 2780 ] = "Caretaker Nevlin", -- Arathi Highlands
	    [ 2781 ] = "Caretaker Weston", -- Arathi Highlands
	    [ 2835 ] = "Cedrik Prose", -- Arathi Highlands
	    [ 2598 ] = "Darbel Montrose", -- Arathi Highlands
	    [ 2601 ] = "Foulbelly", -- Arathi Highlands
	    [ 2611 ] = "Fozruk", -- Arathi Highlands
	    [ 2612 ] = "Lieutenant Valorcall", -- Arathi Highlands
	    [ 2597 ] = "Lord Falconcrest", -- Arathi Highlands
	    [ 2783 ] = "Marez Cowl", -- Arathi Highlands
	    [ 2599 ] = "Otto", -- Arathi Highlands
	    [ 2607 ] = "Prince Galen Trollbane", -- Arathi Highlands
	    [ 2602 ] = "Ruul Onestone", -- Arathi Highlands
	    [ 2851 ] = "Urda", -- Arathi Highlands
	    [ 2558 ] = "Witherbark Berserker", -- Arathi Highlands
	    [ 2745 ] = "Ambassador Infernus", -- Badlands
	    [ 2754 ] = "Anathemus", -- Badlands
	    [ 7057 ] = "Digmaster Shovelphlange", -- Badlands
	    [ 2861 ] = "Gorrik", -- Badlands
	    [ 2726 ] = "Scorched Guardian", -- Badlands
	    [ 2749 ] = "Siege Golem", -- Badlands
	    [ 2931 ] = "Zaricotl", -- Badlands
	    [ 8609 ] = "Alexandra Constantine", -- Blasted Lands
	    [ 7666 ] = "Archmage Allistarj", -- Blasted Lands
	    [ 12396 ] = "Doomguard Commander", -- Blasted Lands
	    [ 8716 ] = "Dreadlord", -- Blasted Lands
	    [ 8717 ] = "Felguard Elite", -- Blasted Lands
	    [ 7665 ] = "Grol the Destroyer", -- Blasted Lands
	    [ 7728 ] = "Kirith the Damned", -- Blasted Lands
	    [ 7667 ] = "Lady Sevine", -- Blasted Lands
	    [ 8718 ] = "Manahound", -- Blasted Lands
	    [ 7851 ] = "Nethergarde Elite", -- Blasted Lands
	    [ 2299 ] = "Borgus Stoutarm", -- Burning Steppes
	    [ 9459 ] = "Cyrus Therepentous", -- Burning Steppes
	    [ 14529 ] = "Franklin the Friendly", -- Burning Steppes
	    [ 9520 ] = "Grark Lorkrub", -- Burning Steppes
	    [ 8976 ] = "Hematos", -- Burning Steppes
	    [ 13177 ] = "Vahgruk", -- Burning Steppes
	    [ 10119 ] = "Volchan", -- Burning Steppes
	    [ 1271 ] = "Old Icebeard", -- Dun Morogh
	    [ 6231 ] = "Techbot", -- Dun Morogh
	    [ 1388 ] = "Vagash", -- Dun Morogh
	    [ 2409 ] = "Felicia Maline", -- Duskwood
	    [ 1200 ] = "Morbent Fel", -- Duskwood
	    [ 16116 ] = "Archmage Angela Dosantos", -- Eastern Plaguelands
	    [ 11896 ] = "Borelgore", -- Eastern Plaguelands
	    [ 16115 ] = "Commander Eligor Dawnbringer", -- Eastern Plaguelands
	    [ 13118 ] = "Crimson Bodyguard", -- Eastern Plaguelands
	    [ 12337 ] = "Crimson Courier", -- Eastern Plaguelands
	    [ 11898 ] = "Crusader Lord Valdelmar", -- Eastern Plaguelands
	    [ 11897 ] = "Duskwing", -- Eastern Plaguelands
	    [ 14494 ] = "Eris Havenfire", -- Eastern Plaguelands
	    [ 16113 ] = "Father Inigo Montoy", -- Eastern Plaguelands
	    [ 12636 ] = "Georgia", -- Eastern Plaguelands
	    [ 10828 ] = "High General Abbendis", -- Eastern Plaguelands
	    [ 16132 ] = "Huntsman Leopold", -- Eastern Plaguelands
	    [ 12617 ] = "Khaelyn Steelwing", -- Eastern Plaguelands
	    [ 16112 ] = "Korfax, Champion of the Light", -- Eastern Plaguelands
	    [ 16133 ] = "Mataus the Wrathcaster", -- Eastern Plaguelands
	    [ 11878 ] = "Nathanos Blightcaller", -- Eastern Plaguelands
	    [ 16184 ] = "Nerubian Overseer", -- Eastern Plaguelands
	    [ 16135 ] = "Rayne", -- Eastern Plaguelands
	    [ 16134 ] = "Rimblat Earthshatter", -- Eastern Plaguelands
	    [ 16131 ] = "Rohan the Assassin", -- Eastern Plaguelands
	    [ 16114 ] = "Scarlet Commander Marjhan", -- Eastern Plaguelands
	    [ 15162 ] = "Scarlet Inquisitor", -- Eastern Plaguelands
	    [ 12263 ] = "Slaughterhouse Protector", -- Eastern Plaguelands
	    [ 1855 ] = "Tirion Fordring", -- Eastern Plaguelands
	    [ 12262 ] = "Ziggurat Protector", -- Eastern Plaguelands
	    [ 448 ] = "Hogger", -- Elwynn Forest
	    [ 14388 ] = "Rogue Black Drake", -- Elwynn Forest
	    [ 2304 ] = "Captain Ironhill", -- Hillsbrad Foothills
	    [ 2432 ] = "Darla Harris", -- Hillsbrad Foothills
	    [ 2215 ] = "High Executor Darthalia", -- Hillsbrad Foothills
	    [ 2276 ] = "Magistrate Henry Maleb", -- Hillsbrad Foothills
	    [ 15199 ] = "Sergeant Hartman", -- Hillsbrad Foothills
	    [ 14275 ] = "Tamra Stormpike", -- Hillsbrad Foothills
	    [ 7075 ] = "Writhing Mage", -- Hillsbrad Foothills
	    [ 2389 ] = "Zarise", -- Hillsbrad Foothills
	    [ 14267 ] = "Emogg the Crusher", -- Loch Modan
	    [ 2477 ] = "Gradok", -- Loch Modan
	    [ 2478 ] = "Haren Swifthoof", -- Loch Modan
	    [ 2932 ] = "Magregan Deepshadow", -- Loch Modan
	    [ 4872 ] = "Obsidian Golem", -- Loch Modan
	    [ 1572 ] = "Thorgrum Borrelson", -- Loch Modan
	    [ 7170 ] = "Thragomm", -- Loch Modan
	    [ 7009 ] = "Arantir", -- Redridge Mountains
	    [ 931 ] = "Ariena Stormfeather", -- Redridge Mountains
	    [ 349 ] = "Corporal Keeshan", -- Redridge Mountains
	    [ 14357 ] = "Lake Thresher", -- Redridge Mountains
	    [ 397 ] = "Morganth", -- Redridge Mountains
	    [ 335 ] = "Singe", -- Redridge Mountains
	    [ 8447 ] = "Clunk", -- Searing Gorge
	    [ 8504 ] = "Dark Iron Sentry", -- Searing Gorge
	    [ 3305 ] = "Grisha", -- Searing Gorge
	    [ 8282 ] = "Highlord Mastrogonde", -- Searing Gorge
	    [ 8479 ] = "Kalaran Windblade", -- Searing Gorge
	    [ 2941 ] = "Lanie Reed", -- Searing Gorge
	    [ 5833 ] = "Margol the Rager", -- Searing Gorge
	    [ 8400 ] = "Obsidion", -- Searing Gorge
	    [ 14621 ] = "Overseer Maltorius", -- Searing Gorge
	    [ 2106 ] = "Apothecary Berard", -- Silverpine Forest
	    [ 2226 ] = "Karos Razok", -- Silverpine Forest
	    [ 12123 ] = "Reef Shark", -- Silverpine Forest
	    [ 2529 ] = "Son of Arugal", -- Silverpine Forest
	    [ 1947 ] = "Thule Ravenclaw", -- Silverpine Forest
	    [ 14912 ] = "Captured Hakkari Zealot", -- Stranglethorn Vale
	    [ 813 ] = "Colonel Kurzen", -- Stranglethorn Vale
	    [ 2635 ] = "Elder Saltwater Crocolisk", -- Stranglethorn Vale
	    [ 14910 ] = "Exzhal", -- Stranglethorn Vale
	    [ 14905 ] = "Falthir the Sightless", -- Stranglethorn Vale
	    [ 1492 ] = "Gorlash", -- Stranglethorn Vale
	    [ 2858 ] = "Gringer", -- Stranglethorn Vale
	    [ 2859 ] = "Gyll", -- Stranglethorn Vale
	    [ 731 ] = "King Bangalash", -- Stranglethorn Vale
	    [ 1559 ] = "King Mukla", -- Stranglethorn Vale
	    [ 469 ] = "Lieutenant Doren", -- Stranglethorn Vale
	    [ 14904 ] = "Maywiki of Zuldazar", -- Stranglethorn Vale
	    [ 1060 ] = "Mogh the Undying", -- Stranglethorn Vale
	    [ 14875 ] = "Molthor", -- Stranglethorn Vale
	    [ 15080 ] = "Servant of the Hand", -- Stranglethorn Vale
	    [ 16096 ] = "Steamwheedle Bruiser", -- Stranglethorn Vale
	    [ 730 ] = "Tethis", -- Stranglethorn Vale
	    [ 1387 ] = "Thysta", -- Stranglethorn Vale
	    [ 15070 ] = "Vinchaxa", -- Stranglethorn Vale
	    [ 6026 ] = "Breyk", -- Swamp of Sorrows
	    [ 14445 ] = "Lord Captain Wyrmak", -- Swamp of Sorrows
	    [ 12900 ] = "Somnus", -- Swamp of Sorrows
	    [ 12496 ] = "Dreamtracker", -- The Hinterlands
	    [ 4469 ] = "Emerald Ooze", -- The Hinterlands
	    [ 7977 ] = "Gammerita", -- The Hinterlands
	    [ 4314 ] = "Gorkas", -- The Hinterlands
	    [ 8215 ] = "Grimungous", -- The Hinterlands
	    [ 8018 ] = "Guthrum Thunderfist", -- The Hinterlands
	    [ 4468 ] = "Jade Sludge", -- The Hinterlands
	    [ 7996 ] = "Qiaga the Keeper", -- The Hinterlands
	    [ 5718 ] = "Rothos", -- The Hinterlands
	    [ 7995 ] = "Vile Priestess Hexx", -- The Hinterlands
	    [ 11022 ] = "Alexi Barov", -- Tirisfal Glades
	    [ 1852 ] = "Araj the Summoner", -- Western Plaguelands
	    [ 12596 ] = "Bibilfaz Featherwhistle", -- Western Plaguelands
	    [ 1805 ] = "Flesh Golem", -- Western Plaguelands
	    [ 12425 ] = "Flint Shadowmore", -- Western Plaguelands
	    [ 1843 ] = "Foreman Jerris", -- Western Plaguelands
	    [ 1846 ] = "High Protector Lorik", -- Western Plaguelands
	    [ 1842 ] = "Highlord Taelan Fordring", -- Western Plaguelands
	    [ 1850 ] = "Putridius", -- Western Plaguelands
	    [ 1788 ] = "Skeletal Warlord", -- Western Plaguelands
	    [ 11023 ] = "Weldon Barov", -- Western Plaguelands
	    [ 626 ] = "Foreman Thistlenettle", -- Westfall
	    [ 7053 ] = "Klaven Mortwake", -- Westfall
	    [ 523 ] = "Thor", -- Westfall
	    [ 12899 ] = "Axtroz", -- Wetlands
	    [ 1364 ] = "Balgaras the Foul", -- Wetlands
	    [ 1571 ] = "Shellei Brondir", -- Wetlands
	
	    -- Kalimdor
	    [ 11901 ] = "Andruk", -- Ashenvale
	    [ 4267 ] = "Daelyshia", -- Ashenvale
	    [ 12498 ] = "Dreamstalker", -- Ashenvale
	    [ 14753 ] = "Illiyana Moonblaze", -- Ashenvale
	    [ 12737 ] = "Mastok Wrilehiss", -- Ashenvale
	    [ 5314 ] = "Phantim", -- Ashenvale
	    [ 3691 ] = "Raene Wolfrunner", -- Ashenvale
	    [ 14733 ] = "Sentinel Farsong", -- Ashenvale
	    [ 14715 ] = "Silverwing Elite", -- Ashenvale
	    [ 12616 ] = "Vhulgra", -- Ashenvale
	    [ 12836 ] = "Wandering Protector", -- Ashenvale
	    [ 14464 ] = "Avalanchion", -- Azshara
	    [ 193 ] = "Blue Dragonspawn", -- Azshara
	    [ 13278 ] = "Duke Hydraxis", -- Azshara
	    [ 6140 ] = "Hetaera", -- Azshara
	    [ 12577 ] = "Jarrodenus", -- Azshara
	    [ 8610 ] = "Kroum", -- Azshara
	    [ 6134 ] = "Lord Arkkoroc", -- Azshara
	    [ 6646 ] = "Monnos the Elder", -- Azshara
	    [ 8756 ] = "Raytaf", -- Azshara
	    [ 13896 ] = "Scalebeard", -- Azshara
	    [ 8757 ] = "Shahiar", -- Azshara
	    [ 8758 ] = "Zaman", -- Azshara
	    [ 3841 ] = "Caylais Moonfeather", -- Darkshore
	    [ 6669 ] = "The Threshwackonator 4100", -- Darkshore
	    [ 6706 ] = "Baritanas Skyriver", -- Desolace
	    [ 13697 ] = "Cavindra", -- Desolace
	    [ 5760 ] = "Lord Azrethoc", -- Desolace
	    [ 6726 ] = "Thalon", -- Desolace
	    [ 13718 ] = "The Nameless Prophet", -- Desolace
	    [ 5824 ] = "Captain Flat Tusk", -- Durotar
	    [ 5822 ] = "Felweaver Scornn", -- Durotar
	    [ 4321 ] = "Baldruc", -- Dustwallow Marsh
	    [ 4339 ] = "Brimgore", -- Dustwallow Marsh
	    [ 15552 ] = "Doctor Weavil", -- Dustwallow Marsh
	    [ 10321 ] = "Emberstrife", -- Dustwallow Marsh
	    [ 15591 ] = "Minion of Weavil", -- Dustwallow Marsh
	    [ 11899 ] = "Shardi", -- Dustwallow Marsh
	    [ 16072 ] = "Tidelord Rrurgaz", -- Dustwallow Marsh
	    [ 11900 ] = "Brakkar", -- Felwood
	    [ 7104 ] = "Dessecus", -- Felwood
	    [ 7137 ] = "Immolatus", -- Felwood
	    [ 14467 ] = "Kroshius", -- Felwood
	    [ 9516 ] = "Lord Banehollow", -- Felwood
	    [ 12578 ] = "Mishellena", -- Felwood
	    [ 12801 ] = "Arcane Chimaerok", -- Feralas
	    [ 12497 ] = "Dreamroarer", -- Feralas
	    [ 8019 ] = "Fyldren Moonfeather", -- Feralas
	    [ 7875 ] = "Hadoken Swiftstrider", -- Feralas
	    [ 5357 ] = "Land Walker", -- Feralas
	    [ 5312 ] = "Lethlas", -- Feralas
	    [ 12803 ] = "Lord Lakmaeran", -- Feralas
	    [ 10204 ] = "Misha", -- Feralas
	    [ 10182 ] = "Rexxar", -- Feralas
	    [ 8020 ] = "Shyn", -- Feralas
	    [ 4319 ] = "Thyssiana", -- Feralas
	    [ 12740 ] = "Faustron", -- Moonglade
	    [ 11832 ] = "Keeper Remulos", -- Moonglade
	    [ 10897 ] = "Sindrayl", -- Moonglade
	    [ 14865 ] = "Felinni", -- Mulgore
	    [ 5785 ] = "Sister Hatelash", -- Mulgore
	    [ 17765 ] = "Alliance Silithyst Sentinel", -- Silithus
	    [ 15444 ] = "Arcanist Nozzlespring", -- Silithus
	    [ 15177 ] = "Cloud Skydancer", -- Silithus
	    [ 15196 ] = "Deathclasp", -- Silithus
	    [ 16091 ] = "Dirk Thunderwood", -- Silithus
	    [ 14347 ] = "Highlord Demitrian", -- Silithus
	    [ 17766 ] = "Horde Silithyst Sentinel", -- Silithus
	    [ 15614 ] = "J.D. Shadesong", -- Silithus
	    [ 15443 ] = "Janela Stouthammer", -- Silithus
	    [ 15693 ] = "Jonathan the Revelator", -- Silithus
	    [ 15500 ] = "Keyl Swiftclaw", -- Silithus
	    [ 15612 ] = "Krug Skullsplit", -- Silithus
	    [ 14473 ] = "Lapress", -- Silithus
	    [ 15613 ] = "Merok Longstride", -- Silithus
	    [ 14536 ] = "Nelson the Nice", -- Silithus
	    [ 14475 ] = "Rex Ashil", -- Silithus
	    [ 15178 ] = "Runk Windtamer", -- Silithus
	    [ 15903 ] = "Sergeant Carnes", -- Silithus
	    [ 14471 ] = "Setis", -- Silithus
	    [ 15615 ] = "Shadow Priestess Shai", -- Silithus
	    [ 14454 ] = "The Windreaver", -- Silithus
	    [ 15541 ] = "Twilight Marauder Morna", -- Silithus
	    [ 15182 ] = "Vish Kozus", -- Silithus
	    [ 15540 ] = "Windcaller Kaldon", -- Silithus
	    [ 14474 ] = "Zora", -- Silithus
	    [ 11921 ] = "Besseleth", -- Stonetalon Mountains
	    [ 12579 ] = "Bloodfury Ripper", -- Stonetalon Mountains
	    [ 5931 ] = "Foreman Rigger", -- Stonetalon Mountains
	    [ 4409 ] = "Gatekeeper Kordurus", -- Stonetalon Mountains
	    [ 8518 ] = "Rynthariel the Keymaster", -- Stonetalon Mountains
	    [ 5930 ] = "Sister Riven", -- Stonetalon Mountains
	    [ 5928 ] = "Sorrow Wing", -- Stonetalon Mountains
	    [ 5932 ] = "Taskmaster Whipfang", -- Stonetalon Mountains
	    [ 4407 ] = "Teloren", -- Stonetalon Mountains
	    [ 4312 ] = "Tharm", -- Stonetalon Mountains
	    [ 7823 ] = "Bera Stonehammer", -- Tanaris
	    [ 7824 ] = "Bulkrek Ragefist", -- Tanaris
	    [ 8197 ] = "Chronalis", -- Tanaris
	    [ 5469 ] = "Dune Smasher", -- Tanaris
	    [ 5432 ] = "Giant Surf Glider", -- Tanaris
	    [ 8196 ] = "Occulus", -- Tanaris
	    [ 8198 ] = "Tick", -- Tanaris
	    [ 8199 ] = "Warleader Krazzilak", -- Tanaris
	    [ 2166 ] = "Oakenscowl", -- Teldrassil
	    [ 3838 ] = "Vesprystus", -- Teldrassil
	    [ 7895 ] = "Ambassador Bloodrage", -- The Barrens
	    [ 12865 ] = "Ambassador Malcin", -- The Barrens
	    [ 3672 ] = "Boahn", -- The Barrens
	    [ 16227 ] = "Bragok", -- The Barrens
	    [ 5827 ] = "Brontus", -- The Barrens
	    [ 5851 ] = "Captain Gerogg Hammertoe", -- The Barrens
	    [ 14781 ] = "Captain Shatterskull", -- The Barrens
	    [ 3638 ] = "Devouring Ectoplasm", -- The Barrens
	    [ 3615 ] = "Devrak", -- The Barrens
	    [ 3270 ] = "Elder Mystic Razorsnout", -- The Barrens
	    [ 3398 ] = "Gesharahan", -- The Barrens
	    [ 7288 ] = "Grand Foreman Puzik Gallywix", -- The Barrens
	    [ 5859 ] = "Hagg Taurenbane", -- The Barrens
	    [ 5828 ] = "Humar the Pridelord", -- The Barrens
	    [ 14754 ] = "Kelm Hargunth", -- The Barrens
	    [ 3655 ] = "Mad Magglish", -- The Barrens
	    [ 5841 ] = "Rocklance", -- The Barrens
	    [ 5830 ] = "Sister Rathtalon", -- The Barrens
	    [ 5831 ] = "Swiftmane", -- The Barrens
	    [ 5864 ] = "Swinegart Spearhide", -- The Barrens
	    [ 5842 ] = "Takk the Leaper", -- The Barrens
	    [ 7233 ] = "Taskmaster Fizzule", -- The Barrens
	    [ 3652 ] = "Trigore the Lasher", -- The Barrens
	    [ 10992 ] = "Enraged Panther", -- Thousand Needles
	    [ 5934 ] = "Heartrazor", -- Thousand Needles
	    [ 5935 ] = "Ironeye the Invincible", -- Thousand Needles
	    [ 4317 ] = "Nyse", -- Thousand Needles
	    [ 5937 ] = "Vile Sting", -- Thousand Needles
	    [ 14461 ] = "Baron Charr", -- Un'Goro Crater
	    [ 9376 ] = "Blazerunner", -- Un'Goro Crater
	    [ 6583 ] = "Gruff", -- Un'Goro Crater
	    [ 10583 ] = "Gryfe", -- Un'Goro Crater
	    [ 6584 ] = "King Mosh", -- Un'Goro Crater
	    [ 14527 ] = "Simone the Inconspicuous", -- Un'Goro Crater
	    [ 6560 ] = "Stone Guardian", -- Un'Goro Crater
	    [ 6500 ] = "Tyrant Devilsaur", -- Un'Goro Crater
	    [ 14531 ] = "Artorius the Amiable", -- Winterspring
	    [ 10202 ] = "Azurous", -- Winterspring
	    [ 10807 ] = "Brumeran", -- Winterspring
	    [ 14348 ] = "Earthcaller Franzahl", -- Winterspring
	    [ 10196 ] = "General Colbatann", -- Winterspring
	    [ 10929 ] = "Haleh", -- Winterspring
	    [ 10738 ] = "High Chief Winterfall", -- Winterspring
	    [ 10198 ] = "Kashoch the Reaver", -- Winterspring
	    [ 10201 ] = "Lady Hederine", -- Winterspring
	    [ 11138 ] = "Maethrya", -- Winterspring
	    [ 10663 ] = "Manaclaw", -- Winterspring
	    [ 14457 ] = "Princess Tempestria", -- Winterspring
	    [ 10664 ] = "Scryer", -- Winterspring
	    [ 10662 ] = "Spellmaw", -- Winterspring
	    [ 10806 ] = "Ursius", -- Winterspring
	    [ 11139 ] = "Yugrek", -- Winterspring
	
	    -- Unknown/Other
	
	};
	NPCWorldIDs = {
	    -- Eastern Kingdoms
	    [ 16392 ] = 2, -- Alterac Mountains
	    [ 13776 ] = 2, -- Alterac Mountains
	    [ 2422 ] = 2, -- Alterac Mountains
	    [ 3985 ] = 2, -- Alterac Mountains
	    [ 13219 ] = 2, -- Alterac Mountains
	    [ 13841 ] = 2, -- Alterac Mountains
	    [ 2421 ] = 2, -- Alterac Mountains
	    [ 13085 ] = 2, -- Alterac Mountains
	    [ 3984 ] = 2, -- Alterac Mountains
	    [ 2447 ] = 2, -- Alterac Mountains
	    [ 13777 ] = 2, -- Alterac Mountains
	    [ 2420 ] = 2, -- Alterac Mountains
	    [ 13217 ] = 2, -- Alterac Mountains
	    [ 13602 ] = 2, -- Alterac Mountains
	    [ 13840 ] = 2, -- Alterac Mountains
	    [ 2782 ] = 2, -- Arathi Highlands
	    [ 2780 ] = 2, -- Arathi Highlands
	    [ 2781 ] = 2, -- Arathi Highlands
	    [ 2835 ] = 2, -- Arathi Highlands
	    [ 2598 ] = 2, -- Arathi Highlands
	    [ 2601 ] = 2, -- Arathi Highlands
	    [ 2611 ] = 2, -- Arathi Highlands
	    [ 2612 ] = 2, -- Arathi Highlands
	    [ 2597 ] = 2, -- Arathi Highlands
	    [ 2783 ] = 2, -- Arathi Highlands
	    [ 2599 ] = 2, -- Arathi Highlands
	    [ 2607 ] = 2, -- Arathi Highlands
	    [ 2602 ] = 2, -- Arathi Highlands
	    [ 2851 ] = 2, -- Arathi Highlands
	    [ 2558 ] = 2, -- Arathi Highlands
	    [ 2745 ] = 2, -- Badlands
	    [ 2754 ] = 2, -- Badlands
	    [ 7057 ] = 2, -- Badlands
	    [ 2861 ] = 2, -- Badlands
	    [ 2726 ] = 2, -- Badlands
	    [ 2749 ] = 2, -- Badlands
	    [ 2931 ] = 2, -- Badlands
	    [ 8609 ] = 2, -- Blasted Lands
	    [ 7666 ] = 2, -- Blasted Lands
	    [ 12396 ] = 2, -- Blasted Lands
	    [ 8716 ] = 2, -- Blasted Lands
	    [ 8717 ] = 2, -- Blasted Lands
	    [ 7665 ] = 2, -- Blasted Lands
	    [ 7728 ] = 2, -- Blasted Lands
	    [ 7667 ] = 2, -- Blasted Lands
	    [ 8718 ] = 2, -- Blasted Lands
	    [ 7851 ] = 2, -- Blasted Lands
	    [ 2299 ] = 2, -- Burning Steppes
	    [ 9459 ] = 2, -- Burning Steppes
	    [ 14529 ] = 2, -- Burning Steppes
	    [ 9520 ] = 2, -- Burning Steppes
	    [ 8976 ] = 2, -- Burning Steppes
	    [ 13177 ] = 2, -- Burning Steppes
	    [ 10119 ] = 2, -- Burning Steppes
	    [ 1271 ] = 2, -- Dun Morogh
	    [ 6231 ] = 2, -- Dun Morogh
	    [ 1388 ] = 2, -- Dun Morogh
	    [ 2409 ] = 2, -- Duskwood
	    [ 1200 ] = 2, -- Duskwood
	    [ 16116 ] = 2, -- Eastern Plaguelands
	    [ 11896 ] = 2, -- Eastern Plaguelands
	    [ 16115 ] = 2, -- Eastern Plaguelands
	    [ 13118 ] = 2, -- Eastern Plaguelands
	    [ 12337 ] = 2, -- Eastern Plaguelands
	    [ 11898 ] = 2, -- Eastern Plaguelands
	    [ 11897 ] = 2, -- Eastern Plaguelands
	    [ 14494 ] = 2, -- Eastern Plaguelands
	    [ 16113 ] = 2, -- Eastern Plaguelands
	    [ 12636 ] = 2, -- Eastern Plaguelands
	    [ 10828 ] = 2, -- Eastern Plaguelands
	    [ 16132 ] = 2, -- Eastern Plaguelands
	    [ 12617 ] = 2, -- Eastern Plaguelands
	    [ 16112 ] = 2, -- Eastern Plaguelands
	    [ 16133 ] = 2, -- Eastern Plaguelands
	    [ 11878 ] = 2, -- Eastern Plaguelands
	    [ 16184 ] = 2, -- Eastern Plaguelands
	    [ 16135 ] = 2, -- Eastern Plaguelands
	    [ 16134 ] = 2, -- Eastern Plaguelands
	    [ 16131 ] = 2, -- Eastern Plaguelands
	    [ 16114 ] = 2, -- Eastern Plaguelands
	    [ 15162 ] = 2, -- Eastern Plaguelands
	    [ 12263 ] = 2, -- Eastern Plaguelands
	    [ 1855 ] = 2, -- Eastern Plaguelands
	    [ 12262 ] = 2, -- Eastern Plaguelands
	    [ 448 ] = 2, -- Elwynn Forest
	    [ 14388 ] = 2, -- Elwynn Forest
	    [ 2304 ] = 2, -- Hillsbrad Foothills
	    [ 2432 ] = 2, -- Hillsbrad Foothills
	    [ 2215 ] = 2, -- Hillsbrad Foothills
	    [ 2276 ] = 2, -- Hillsbrad Foothills
	    [ 15199 ] = 2, -- Hillsbrad Foothills
	    [ 14275 ] = 2, -- Hillsbrad Foothills
	    [ 7075 ] = 2, -- Hillsbrad Foothills
	    [ 2389 ] = 2, -- Hillsbrad Foothills
	    [ 14267 ] = 2, -- Loch Modan
	    [ 2477 ] = 2, -- Loch Modan
	    [ 2478 ] = 2, -- Loch Modan
	    [ 2932 ] = 2, -- Loch Modan
	    [ 4872 ] = 2, -- Loch Modan
	    [ 1572 ] = 2, -- Loch Modan
	    [ 7170 ] = 2, -- Loch Modan
	    [ 7009 ] = 2, -- Redridge Mountains
	    [ 931 ] = 2, -- Redridge Mountains
	    [ 349 ] = 2, -- Redridge Mountains
	    [ 14357 ] = 2, -- Redridge Mountains
	    [ 397 ] = 2, -- Redridge Mountains
	    [ 335 ] = 2, -- Redridge Mountains
	    [ 8447 ] = 2, -- Searing Gorge
	    [ 8504 ] = 2, -- Searing Gorge
	    [ 3305 ] = 2, -- Searing Gorge
	    [ 8282 ] = 2, -- Searing Gorge
	    [ 8479 ] = 2, -- Searing Gorge
	    [ 2941 ] = 2, -- Searing Gorge
	    [ 5833 ] = 2, -- Searing Gorge
	    [ 8400 ] = 2, -- Searing Gorge
	    [ 14621 ] = 2, -- Searing Gorge
	    [ 2106 ] = 2, -- Silverpine Forest
	    [ 2226 ] = 2, -- Silverpine Forest
	    [ 12123 ] = 2, -- Silverpine Forest
	    [ 2529 ] = 2, -- Silverpine Forest
	    [ 1947 ] = 2, -- Silverpine Forest
	    [ 14912 ] = 2, -- Stranglethorn Vale
	    [ 813 ] = 2, -- Stranglethorn Vale
	    [ 2635 ] = 2, -- Stranglethorn Vale
	    [ 14910 ] = 2, -- Stranglethorn Vale
	    [ 14905 ] = 2, -- Stranglethorn Vale
	    [ 1492 ] = 2, -- Stranglethorn Vale
	    [ 2858 ] = 2, -- Stranglethorn Vale
	    [ 2859 ] = 2, -- Stranglethorn Vale
	    [ 731 ] = 2, -- Stranglethorn Vale
	    [ 1559 ] = 2, -- Stranglethorn Vale
	    [ 469 ] = 2, -- Stranglethorn Vale
	    [ 14904 ] = 2, -- Stranglethorn Vale
	    [ 1060 ] = 2, -- Stranglethorn Vale
	    [ 14875 ] = 2, -- Stranglethorn Vale
	    [ 15080 ] = 2, -- Stranglethorn Vale
	    [ 16096 ] = 2, -- Stranglethorn Vale
	    [ 730 ] = 2, -- Stranglethorn Vale
	    [ 1387 ] = 2, -- Stranglethorn Vale
	    [ 15070 ] = 2, -- Stranglethorn Vale
	    [ 6026 ] = 2, -- Swamp of Sorrows
	    [ 14445 ] = 2, -- Swamp of Sorrows
	    [ 12900 ] = 2, -- Swamp of Sorrows
	    [ 12496 ] = 2, -- The Hinterlands
	    [ 4469 ] = 2, -- The Hinterlands
	    [ 7977 ] = 2, -- The Hinterlands
	    [ 4314 ] = 2, -- The Hinterlands
	    [ 8215 ] = 2, -- The Hinterlands
	    [ 8018 ] = 2, -- The Hinterlands
	    [ 4468 ] = 2, -- The Hinterlands
	    [ 7996 ] = 2, -- The Hinterlands
	    [ 5718 ] = 2, -- The Hinterlands
	    [ 7995 ] = 2, -- The Hinterlands
	    [ 11022 ] = 2, -- Tirisfal Glades
	    [ 1852 ] = 2, -- Western Plaguelands
	    [ 12596 ] = 2, -- Western Plaguelands
	    [ 1805 ] = 2, -- Western Plaguelands
	    [ 12425 ] = 2, -- Western Plaguelands
	    [ 1843 ] = 2, -- Western Plaguelands
	    [ 1846 ] = 2, -- Western Plaguelands
	    [ 1842 ] = 2, -- Western Plaguelands
	    [ 1850 ] = 2, -- Western Plaguelands
	    [ 1788 ] = 2, -- Western Plaguelands
	    [ 11023 ] = 2, -- Western Plaguelands
	    [ 626 ] = 2, -- Westfall
	    [ 7053 ] = 2, -- Westfall
	    [ 523 ] = 2, -- Westfall
	    [ 12899 ] = 2, -- Wetlands
	    [ 1364 ] = 2, -- Wetlands
	    [ 1571 ] = 2, -- Wetlands
	
	    -- Kalimdor
	    [ 11901 ] = 1, -- Ashenvale
	    [ 4267 ] = 1, -- Ashenvale
	    [ 12498 ] = 1, -- Ashenvale
	    [ 14753 ] = 1, -- Ashenvale
	    [ 12737 ] = 1, -- Ashenvale
	    [ 5314 ] = 1, -- Ashenvale
	    [ 3691 ] = 1, -- Ashenvale
	    [ 14733 ] = 1, -- Ashenvale
	    [ 14715 ] = 1, -- Ashenvale
	    [ 12616 ] = 1, -- Ashenvale
	    [ 12836 ] = 1, -- Ashenvale
	    [ 14464 ] = 1, -- Azshara
	    [ 193 ] = 1, -- Azshara
	    [ 13278 ] = 1, -- Azshara
	    [ 6140 ] = 1, -- Azshara
	    [ 12577 ] = 1, -- Azshara
	    [ 8610 ] = 1, -- Azshara
	    [ 6134 ] = 1, -- Azshara
	    [ 6646 ] = 1, -- Azshara
	    [ 8756 ] = 1, -- Azshara
	    [ 13896 ] = 1, -- Azshara
	    [ 8757 ] = 1, -- Azshara
	    [ 8758 ] = 1, -- Azshara
	    [ 3841 ] = 1, -- Darkshore
	    [ 6669 ] = 1, -- Darkshore
	    [ 6706 ] = 1, -- Desolace
	    [ 13697 ] = 1, -- Desolace
	    [ 5760 ] = 1, -- Desolace
	    [ 6726 ] = 1, -- Desolace
	    [ 13718 ] = 1, -- Desolace
	    [ 5824 ] = 1, -- Durotar
	    [ 5822 ] = 1, -- Durotar
	    [ 4321 ] = 1, -- Dustwallow Marsh
	    [ 4339 ] = 1, -- Dustwallow Marsh
	    [ 15552 ] = 1, -- Dustwallow Marsh
	    [ 10321 ] = 1, -- Dustwallow Marsh
	    [ 15591 ] = 1, -- Dustwallow Marsh
	    [ 11899 ] = 1, -- Dustwallow Marsh
	    [ 16072 ] = 1, -- Dustwallow Marsh
	    [ 11900 ] = 1, -- Felwood
	    [ 7104 ] = 1, -- Felwood
	    [ 7137 ] = 1, -- Felwood
	    [ 14467 ] = 1, -- Felwood
	    [ 9516 ] = 1, -- Felwood
	    [ 12578 ] = 1, -- Felwood
	    [ 12801 ] = 1, -- Feralas
	    [ 12497 ] = 1, -- Feralas
	    [ 8019 ] = 1, -- Feralas
	    [ 7875 ] = 1, -- Feralas
	    [ 5357 ] = 1, -- Feralas
	    [ 5312 ] = 1, -- Feralas
	    [ 12803 ] = 1, -- Feralas
	    [ 10204 ] = 1, -- Feralas
	    [ 10182 ] = 1, -- Feralas
	    [ 8020 ] = 1, -- Feralas
	    [ 4319 ] = 1, -- Feralas
	    [ 12740 ] = 1, -- Moonglade
	    [ 11832 ] = 1, -- Moonglade
	    [ 10897 ] = 1, -- Moonglade
	    [ 14865 ] = 1, -- Mulgore
	    [ 5785 ] = 1, -- Mulgore
	    [ 17765 ] = 1, -- Silithus
	    [ 15444 ] = 1, -- Silithus
	    [ 15177 ] = 1, -- Silithus
	    [ 15196 ] = 1, -- Silithus
	    [ 16091 ] = 1, -- Silithus
	    [ 14347 ] = 1, -- Silithus
	    [ 17766 ] = 1, -- Silithus
	    [ 15614 ] = 1, -- Silithus
	    [ 15443 ] = 1, -- Silithus
	    [ 15693 ] = 1, -- Silithus
	    [ 15500 ] = 1, -- Silithus
	    [ 15612 ] = 1, -- Silithus
	    [ 14473 ] = 1, -- Silithus
	    [ 15613 ] = 1, -- Silithus
	    [ 14536 ] = 1, -- Silithus
	    [ 14475 ] = 1, -- Silithus
	    [ 15178 ] = 1, -- Silithus
	    [ 15903 ] = 1, -- Silithus
	    [ 14471 ] = 1, -- Silithus
	    [ 15615 ] = 1, -- Silithus
	    [ 14454 ] = 1, -- Silithus
	    [ 15541 ] = 1, -- Silithus
	    [ 15182 ] = 1, -- Silithus
	    [ 15540 ] = 1, -- Silithus
	    [ 14474 ] = 1, -- Silithus
	    [ 11921 ] = 1, -- Stonetalon Mountains
	    [ 12579 ] = 1, -- Stonetalon Mountains
	    [ 5931 ] = 1, -- Stonetalon Mountains
	    [ 4409 ] = 1, -- Stonetalon Mountains
	    [ 8518 ] = 1, -- Stonetalon Mountains
	    [ 5930 ] = 1, -- Stonetalon Mountains
	    [ 5928 ] = 1, -- Stonetalon Mountains
	    [ 5932 ] = 1, -- Stonetalon Mountains
	    [ 4407 ] = 1, -- Stonetalon Mountains
	    [ 4312 ] = 1, -- Stonetalon Mountains
	    [ 7823 ] = 1, -- Tanaris
	    [ 7824 ] = 1, -- Tanaris
	    [ 8197 ] = 1, -- Tanaris
	    [ 5469 ] = 1, -- Tanaris
	    [ 5432 ] = 1, -- Tanaris
	    [ 8196 ] = 1, -- Tanaris
	    [ 8198 ] = 1, -- Tanaris
	    [ 8199 ] = 1, -- Tanaris
	    [ 2166 ] = 1, -- Teldrassil
	    [ 3838 ] = 1, -- Teldrassil
	    [ 7895 ] = 1, -- The Barrens
	    [ 12865 ] = 1, -- The Barrens
	    [ 3672 ] = 1, -- The Barrens
	    [ 16227 ] = 1, -- The Barrens
	    [ 5827 ] = 1, -- The Barrens
	    [ 5851 ] = 1, -- The Barrens
	    [ 14781 ] = 1, -- The Barrens
	    [ 3638 ] = 1, -- The Barrens
	    [ 3615 ] = 1, -- The Barrens
	    [ 3270 ] = 1, -- The Barrens
	    [ 3398 ] = 1, -- The Barrens
	    [ 7288 ] = 1, -- The Barrens
	    [ 5859 ] = 1, -- The Barrens
	    [ 5828 ] = 1, -- The Barrens
	    [ 14754 ] = 1, -- The Barrens
	    [ 3655 ] = 1, -- The Barrens
	    [ 5841 ] = 1, -- The Barrens
	    [ 5830 ] = 1, -- The Barrens
	    [ 5831 ] = 1, -- The Barrens
	    [ 5864 ] = 1, -- The Barrens
	    [ 5842 ] = 1, -- The Barrens
	    [ 7233 ] = 1, -- The Barrens
	    [ 3652 ] = 1, -- The Barrens
	    [ 10992 ] = 1, -- Thousand Needles
	    [ 5934 ] = 1, -- Thousand Needles
	    [ 5935 ] = 1, -- Thousand Needles
	    [ 4317 ] = 1, -- Thousand Needles
	    [ 5937 ] = 1, -- Thousand Needles
	    [ 14461 ] = 1, -- Un'Goro Crater
	    [ 9376 ] = 1, -- Un'Goro Crater
	    [ 6583 ] = 1, -- Un'Goro Crater
	    [ 10583 ] = 1, -- Un'Goro Crater
	    [ 6584 ] = 1, -- Un'Goro Crater
	    [ 14527 ] = 1, -- Un'Goro Crater
	    [ 6560 ] = 1, -- Un'Goro Crater
	    [ 6500 ] = 1, -- Un'Goro Crater
	    [ 14531 ] = 1, -- Winterspring
	    [ 10202 ] = 1, -- Winterspring
	    [ 10807 ] = 1, -- Winterspring
	    [ 14348 ] = 1, -- Winterspring
	    [ 10196 ] = 1, -- Winterspring
	    [ 10929 ] = 1, -- Winterspring
	    [ 10738 ] = 1, -- Winterspring
	    [ 10198 ] = 1, -- Winterspring
	    [ 10201 ] = 1, -- Winterspring
	    [ 11138 ] = 1, -- Winterspring
	    [ 10663 ] = 1, -- Winterspring
	    [ 14457 ] = 1, -- Winterspring
	    [ 10664 ] = 1, -- Winterspring
	    [ 10662 ] = 1, -- Winterspring
	    [ 10806 ] = 1, -- Winterspring
	    [ 11139 ] = 1, -- Winterspring
	
	    -- Unknown/Other
	
	};
Achievements = {
[ 1312 ] = true; -- Bloody Rare (Outlands)
[ 2257 ] = true; -- Frostbitten (Northrend)
};
};

me.Achievements = { --- Criteria data for each achievement.
	[ 1312 ] = { WorldID = 3; }; -- Bloody Rare (Outlands)
	[ 2257 ] = { WorldID = 4; }; -- Frostbitten (Northrend)
};
me.ContinentIDs = {}; --- [ Localized continent name ] = Continent ID (mirrors WorldMapContinent.dbc)

me.NpcIDMax = 0xFFFFF; --- Largest ID that will fit in a GUID's 20-bit NPC ID field.
me.Frame.UpdateRate = 0.5; -- [Ebonhold] nameplate detection




--- Prints a message in the default chat window.
function me.Print ( Message, Color )
	if ( not Color ) then
		Color = NORMAL_FONT_COLOR;
	end
	DEFAULT_CHAT_FRAME:AddMessage( L.PRINT_FORMAT:format( Message ), Color.r, Color.g, Color.b );
end


do
	local Tooltip = CreateFrame( "GameTooltip", "EbonSearchTooltip" );
	-- Add template text lines
	local Text = Tooltip:CreateFontString();
	Tooltip:AddFontStrings( Text, Tooltip:CreateFontString() );
	--- Checks the cache for a given NpcID.
	-- @return Localized name of the NPC if cached, or nil if not.
	function me.TestID ( NpcID )
		Tooltip:SetOwner( WorldFrame, "ANCHOR_NONE" );
		Tooltip:SetHyperlink( ( "unit:0xF5300%05X000000" ):format( NpcID ) );
		if ( Tooltip:IsShown() ) then
			return Text:GetText();
		end
	end
end


local CacheListBuild;
do
	local TempList, AlreadyListed = {}, {};
	--- Compiles a cache list into a printable list string.
	-- @param Relist  True to relist NPC names that have already been printed.
	-- @return List string, or nil if the list was empty.
	function CacheListBuild ( self, Relist )
		if ( next( self ) ) then
			-- Build and sort list
			for NpcID, Name in pairs( self ) do
				if ( Relist or not AlreadyListed[ NpcID ] ) then
					if ( not Relist ) then -- Filtered to show NPCs only once
						AlreadyListed[ NpcID ] = true; -- Don't list again
					end
					-- Add quotes to all entries
					TempList[ #TempList + 1 ] = L.CACHELIST_ENTRY_FORMAT:format( Name );
				end
			end

			wipe( self );
			if ( #TempList > 0 ) then
				sort( TempList );
				local ListString = table.concat( TempList, L.CACHELIST_SEPARATOR );
				wipe( TempList );
				return ListString;
			end
		end
	end
end
local CacheList = {};
do
	--- Fills a cache list with all added NPCs, active or not.
	local function CacheListPopulate ( self )
		for NpcID in pairs( me.OptionsCharacter.NPCs ) do
			self[ NpcID ] = me.TestID( NpcID );
		end
		for AchievementID in pairs( me.OptionsCharacter.Achievements ) do
			for CriteriaID, NpcID in pairs( me.Achievements[ AchievementID ].Criteria ) do
				if ( me.Options.AchievementsAddFound or not select( 3, GetAchievementCriteriaInfo( CriteriaID ) ) ) then -- Not completed
					self[ NpcID ] = me.TestID( NpcID );
				end
			end
		end
	end
	local FirstPrint = true;
	--- Prints a standard message listing cached mobs.
	-- Will also print details about the cache the first time it's called.
	-- @param ForcePrint  Overrides the user's option to not print cache warnings.
	-- @param FullListing  Adds all cached NPCs before printing, active or not.
	-- @return True if list printed.
	function me.CacheListPrint ( ForcePrint, FullListing )
		if ( ForcePrint or me.Options.CacheWarnings ) then
			if ( FullListing ) then
				CacheListPopulate( CacheList );
			end
			local ListString = CacheListBuild( CacheList, ForcePrint or FullListing ); -- Allow printing an NPC a second time if forced or full listing
			if ( ListString ) then
				me.Print( L[ FirstPrint and "CACHED_LONG_FORMAT" or "CACHED_FORMAT" ]:format( ListString ), ForcePrint and RED_FONT_COLOR );
				FirstPrint = false;
				return true;
			end
		else
			wipe( CacheList );
		end
	end
end




local next, assert = next, assert;

local ScanIDs = {}; --- [ NpcID ] = Number of concurrent scans for this ID
local TrackedNames = {}; --- [ Name ] = NpcID for active scans
local TrackedNamesDirty = true;
local SessionNPCNames = {}; --- [ NpcID ] = Name for runtime-only tracking when cache writes are disabled
me.SessionNPCNames = SessionNPCNames; -- [Ebonhold] exposed so Config.Search.NPCUpdate can iterate it
local RecentDetections = {}; --- [ GuidOrName ] = GetTime() timestamp
local RecentDetectionWindow = 3;

-- [Ebonhold] v2.2.3: lookup-side normalization for wildlife/zone blacklists.
-- Trims surrounding whitespace, collapses internal runs, and lowercases.
-- 3.3.5a Lua 5.1 string.lower is ASCII-only; acceptable since wildlife names are English.
local function NormalizeName ( Name )
	if ( type( Name ) ~= "string" ) then return nil; end
	Name = Name:gsub( "^%s+", "" ):gsub( "%s+$", "" ):gsub( "%s+", " " );
	return Name:lower();
end

-- [Ebonhold] v2.1.7: names that misfire as rare on Ebonhold but are regular wildlife.
-- Add new entries here when new false-positives are confirmed server-wide; do NOT blacklist entire zones.
-- [Ebonhold] v2.2.0: user-reportable misfires go via /esd wildlife add instead of code changes.
local WILDLIFE_BLACKLIST_BUILTIN = {
	["Plainsstrider"]        = true,
	["Ornery Plainsstrider"] = true,
	["Giraffe"]              = true,
	["Barris Giraffe"]       = true,
	["Reef Shark"]           = true,
	["Rot Hide Bruiser"]     = true,
	["Vile Fin Shredder"]    = true,
};

-- [Ebonhold] v2.2.3: normalized mirror for case-insensitive lookup. Built once at file
-- load; the user list (me.Options.WildlifeBlacklistNorm) gets a parallel mirror in
-- Synchronize. Verbatim WILDLIFE_BLACKLIST_BUILTIN stays for human readability and
-- existing tests; the gate consults the normalized form.
local WILDLIFE_BLACKLIST_BUILTIN_NORM = {};
for Name in pairs( WILDLIFE_BLACKLIST_BUILTIN ) do
	local Key = NormalizeName( Name );
	if ( Key ) then WILDLIFE_BLACKLIST_BUILTIN_NORM[ Key ] = true; end
end

-- [Ebonhold] v2.1.7: ring buffer of the last N classification hits in ProcessUnitForRares.
-- [Ebonhold] v2.2.3: extended to record the path that hit the gate and the reject stage
-- (nil = the candidate passed through the classification check; non-nil = which gate stage
-- rejected). Same 10-entry ring buffer; selective logging keeps it useful (we do NOT log
-- recent/dup_toast/not_tracked rejections - they would flood the buffer at scan tick rate).
-- Printed by /esd misfire for in-game misfire debugging.
local MisfireLog     = {};
local MisfireLogSize = 10;
local MisfireLogNext = 1;
local function LogMisfireHit ( Name, Classification, Path, Stage )
	MisfireLog[ MisfireLogNext ] = {
		name = Name, classification = Classification,
		path = Path, stage = Stage, time = GetTime()
	};
	MisfireLogNext = ( MisfireLogNext % MisfireLogSize ) + 1;
end

local function TrackedNamesRebuild ()
	wipe( TrackedNames );
	for NpcID, Name in pairs( me.OptionsCharacter.NPCs ) do
		if ( Name ) then
			TrackedNames[ Name ] = NpcID;
		end
	end
	for NpcID, Name in pairs( SessionNPCNames ) do
		if ( Name ) then
			TrackedNames[ Name ] = NpcID;
		end
	end
	for NpcID in pairs( ScanIDs ) do
		local Name = me.OptionsCharacter.NPCs[ NpcID ] or SessionNPCNames[ NpcID ] or L.NPCs[ NpcID ];
		if ( Name ) then
			TrackedNames[ Name ] = NpcID;
		end
	end
	TrackedNamesDirty = false;
end

local function GetTrackedNpcIDByName ( Name )
	if ( TrackedNamesDirty ) then
		TrackedNamesRebuild();
	end
	return TrackedNames[ Name ];
end

--- Begins searching for an NPC.
-- @return True if successfully added.
local function ScanAdd ( NpcID )
	local Name = me.TestID( NpcID );
	if ( Name ) then -- Already seen
		CacheList[ NpcID ] = Name;
	else -- Increment
		if ( ScanIDs[ NpcID ] ) then
			ScanIDs[ NpcID ] = ScanIDs[ NpcID ] + 1;
		else
			if ( not next( ScanIDs ) ) then -- First
				me.Frame:Show();
			end
			ScanIDs[ NpcID ] = 1;
			if ( me.Overlays and me.Overlays.Add ) then
				me.Overlays.Add( NpcID );
			end
		end
		TrackedNamesDirty = true;
		return true; -- Successfully added
	end
end
--- Stops searching for an NPC when nothing is searching for it.
local function ScanRemove ( NpcID )
	local Count = assert( ScanIDs[ NpcID ], "Attempt to remove inactive scan." );
	if ( Count > 1 ) then
		ScanIDs[ NpcID ] = Count - 1;
	else
		ScanIDs[ NpcID ] = nil;
		if ( me.Overlays and me.Overlays.Remove ) then
			me.Overlays.Remove( NpcID );
		end
		if ( not next( ScanIDs ) ) then -- Last
			me.Frame:Hide();
		end
	end
	TrackedNamesDirty = true;
end




--- @return True if the given WorldID is active on the current world.
local function IsWorldIDActive ( WorldID )
	return not WorldID or WorldID == me.WorldID; -- False/nil active on all worlds
end

local NPCActivate, NPCDeactivate;
do
	local NPCsActive = {};
	--- Starts actual scan for NPC if on the right world.
	function NPCActivate ( NpcID, WorldID )
		if ( not NPCsActive[ NpcID ] and IsWorldIDActive( WorldID ) and ScanAdd( NpcID ) ) then
			NPCsActive[ NpcID ] = true;
			me.Config.Search.UpdateTab( "NPC" );
			return true; -- Successfully activated
		end
	end
	--- Ends actual scan for NPC.
	function NPCDeactivate ( NpcID )
		if ( NPCsActive[ NpcID ] ) then
			if ( me.OptionsCharacter.NPCWorldIDs[ NpcID ] ) then
				return; -- [Ebonhold] world-guarded NPCs stay active despite cache
			end
			NPCsActive[ NpcID ] = nil;
			ScanRemove( NpcID );
			me.Config.Search.UpdateTab( "NPC" );
			return true; -- Successfully deactivated
		end
	end
	--- @return True if a custom NPC is actively being searched for.
	function me.NPCIsActive ( NpcID )
		return NPCsActive[ NpcID ];
	end
end
--- Adds an NPC name and ID to settings and begins searching.
-- @param NpcID  Numeric ID of the NPC (See Wowhead.com).
-- @param Name  Temporary name to identify this NPC by in the search table.
-- @param WorldID  Number or localized string WorldID to limit this search to.
-- @return True if custom NPC added.
function me.NPCAdd ( NpcID, Name, WorldID )
	NpcID = assert( tonumber( NpcID ), "NpcID must be numeric." );
	local Options = me.OptionsCharacter;
	if ( not Options.NPCs[ NpcID ] ) then
		assert( type( Name ) == "string", "Name must be a string." );
		assert( WorldID == nil or type( WorldID ) == "string" or type( WorldID ) == "number", "Invalid WorldID." );
		if ( not me.Options.DisableCache ) then
			Options.NPCs[ NpcID ], Options.NPCWorldIDs[ NpcID ] = Name, WorldID;
		else
			SessionNPCNames[ NpcID ] = Name;
		end
		TrackedNamesDirty = true;
		if ( not NPCActivate( NpcID, WorldID ) ) then -- Didn't activate
			me.Config.Search.UpdateTab( "NPC" ); -- Just add row
		end
		return true;
	end
end
--- Removes an NPC from settings and stops searching for it.
-- @param NpcID  Numeric ID of the NPC.
-- @return True if custom NPC removed.
function me.NPCRemove ( NpcID )
	NpcID = tonumber( NpcID );
	local Options = me.OptionsCharacter;
	SessionNPCNames[ NpcID ] = nil;
	if ( Options.NPCs[ NpcID ] ) then
		Options.NPCs[ NpcID ], Options.NPCWorldIDs[ NpcID ] = nil;
		if ( not NPCDeactivate( NpcID ) ) then -- Wasn't active
			me.Config.Search.UpdateTab( "NPC" ); -- Just remove row
		end
		return true;
	end
end




--- Starts searching for an achievement's NPC if it meets all settings.
local function AchievementNPCActivate ( Achievement, NpcID, CriteriaID )
	if ( Achievement.Active and not Achievement.NPCsActive[ NpcID ]
		and ( me.Options.AchievementsAddFound or not select( 3, GetAchievementCriteriaInfo( CriteriaID ) ) ) -- Not completed
		and ScanAdd( NpcID )
	) then
		Achievement.NPCsActive[ NpcID ] = CriteriaID;
		me.Config.Search.UpdateTab( Achievement.ID );
		return true;
	end
end
--- Stops searching for an achievement's NPC.
local function AchievementNPCDeactivate ( Achievement, NpcID )
	if ( Achievement.NPCsActive[ NpcID ] ) then
		Achievement.NPCsActive[ NpcID ] = nil;
		ScanRemove( NpcID );
		me.Config.Search.UpdateTab( Achievement.ID );
		return true;
	end
end
--- Starts actual scans for achievement NPCs if on the right world.
local function AchievementActivate ( Achievement )
	if ( not Achievement.Active and IsWorldIDActive( Achievement.WorldID ) ) then
		Achievement.Active = true;
		for CriteriaID, NpcID in pairs( Achievement.Criteria ) do
			AchievementNPCActivate( Achievement, NpcID, CriteriaID );
		end
		return true;
	end
end
-- Ends actual scans for achievement NPCs.
local function AchievementDeactivate ( Achievement )
	if ( Achievement.Active ) then
		Achievement.Active = nil;
		for NpcID in pairs( Achievement.NPCsActive ) do
			AchievementNPCDeactivate( Achievement, NpcID );
		end
		return true;
	end
end
--- @param Achievement  Achievement data table from me.Achievements.
-- @return True if the achievement NPC is being searched for.
function me.AchievementNPCIsActive ( Achievement, NpcID )
	return Achievement.NPCsActive[ NpcID ] ~= nil;
end
--- Adds a kill-related achievement to track.
-- @param AchievementID  Numeric ID of achievement.
-- @return True if achievement added.
function me.AchievementAdd ( AchievementID )
	AchievementID = assert( tonumber( AchievementID ), "AchievementID must be numeric." );
	local Achievement = me.Achievements[ AchievementID ];
	if ( Achievement and not me.OptionsCharacter.Achievements[ AchievementID ] ) then
		if ( not next( me.OptionsCharacter.Achievements ) ) then -- First
			me.Frame:RegisterEvent( "ACHIEVEMENT_EARNED" );
			me.Frame:RegisterEvent( "CRITERIA_UPDATE" );
		end
		me.OptionsCharacter.Achievements[ AchievementID ] = true;
		me.Config.Search.AchievementSetEnabled( AchievementID, true );
		AchievementActivate( Achievement );
		return true;
	end
end
--- Removes an achievement from settings and stops tracking it.
-- @param AchievementID  Numeric ID of achievement.
-- @return True if achievement removed.
function me.AchievementRemove ( AchievementID )
	if ( me.OptionsCharacter.Achievements[ AchievementID ] ) then
		AchievementDeactivate( me.Achievements[ AchievementID ] );
		me.OptionsCharacter.Achievements[ AchievementID ] = nil;
		if ( not next( me.OptionsCharacter.Achievements ) ) then -- Last
			me.Frame:UnregisterEvent( "ACHIEVEMENT_EARNED" );
			me.Frame:UnregisterEvent( "CRITERIA_UPDATE" );
		end
		me.Config.Search.AchievementSetEnabled( AchievementID, false );
		return true;
	end
end




--- Enables printing cache lists on login.
-- @return True if changed.
function me.SetCacheWarnings ( Enable )
	if ( not Enable ~= not me.Options.CacheWarnings ) then
		me.Options.CacheWarnings = Enable or nil;

		me.Config.CacheWarnings:SetChecked( Enable );
		return true;
	end
end
--- Enables tracking of unneeded achievement NPCs.
-- @return True if changed.
function me.SetAchievementsAddFound ( Enable )
	if ( not Enable ~= not me.Options.AchievementsAddFound ) then
		me.Options.AchievementsAddFound = Enable or nil;
		me.Config.Search.AddFoundCheckbox:SetChecked( Enable );

		for _, Achievement in pairs( me.Achievements ) do
			if ( AchievementDeactivate( Achievement ) ) then -- Was active
				AchievementActivate( Achievement );
			end
		end
		return true;
	end
end
--- Enables unmuting sound to play found alerts.
-- @return True if changed.
function me.SetAlertSoundUnmute ( Enable )
	if ( not Enable ~= not me.Options.AlertSoundUnmute ) then
		me.Options.AlertSoundUnmute = Enable or nil;

		me.Config.AlertSoundUnmute:SetChecked( Enable );
		return true;
	end
end
--- Sets the sound to play when NPCs are found.
-- @return True if changed.
function me.SetAlertSound ( AlertSound )
	assert( AlertSound == nil or type( AlertSound ) == "string", "AlertSound must be a string or nil." );
	if ( AlertSound ~= me.Options.AlertSound ) then
		me.Options.AlertSound = AlertSound;

		UIDropDownMenu_SetText( me.Config.AlertSound, AlertSound == nil and L.CONFIG_ALERT_SOUND_DEFAULT or AlertSound );
		return true;
	end
end




--- Resets the scanning list and reloads it from saved settings.
function me.Synchronize ( Options, OptionsCharacter )
	-- Load defaults if settings omitted; fall back to live SavedVars when no explicit Options given
	-- [Ebonhold] v2.0.0: EbonSearchDB nil-guard - me.OptionsDefault is not defined, avoids nil-index crash
	local IsDefaultScan, IsHunter;
	if ( not Options ) then
		Options = EbonSearchDB or me.Options;
	end
	if ( not OptionsCharacter ) then
		OptionsCharacter = me.OptionsCharacterDefault;
		IsDefaultScan, IsHunter = true, IsShiftKeyDown() or select( 2, UnitClass( "player" ) ) == "HUNTER";
	end

	-- Clear all scans
	-- [Ebonhold] v2.0.0: With DisableCache=true, NPCAdd writes to SessionNPCNames
	-- instead of me.OptionsCharacter.NPCs. Deactivate and wipe those too or they
	-- become orphans in ScanIDs and trip the assert below.
	for NpcID in pairs( SessionNPCNames ) do
		NPCDeactivate( NpcID );
	end
	wipe( SessionNPCNames );
	TrackedNamesDirty = true;
	for AchievementID in pairs( me.OptionsCharacter.Achievements ) do
		me.AchievementRemove( AchievementID );
	end
	for NpcID in pairs( me.OptionsCharacter.NPCs ) do
		me.NPCRemove( NpcID );
	end
	assert( not next( ScanIDs ), "Orphan NpcIDs in scan pool!" );

	me.SetCacheWarnings( Options.CacheWarnings );
	me.SetAchievementsAddFound( Options.AchievementsAddFound );
	me.SetAlertSoundUnmute( Options.AlertSoundUnmute );
	me.SetAlertSound( Options.AlertSound );
	-- [Ebonhold] v2.0.0: restore saved minimap button position angle
	if ( Options.MinimapAngle ) then
		me.Options.MinimapAngle = Options.MinimapAngle;
	end
	-- [Ebonhold] v2.2.0: restore zone blacklist across sessions
	if ( Options.ZoneBlacklist ) then
		wipe( me.Options.ZoneBlacklist );
		for Zone in pairs( Options.ZoneBlacklist ) do
			me.Options.ZoneBlacklist[ Zone ] = true;
		end
	end
	-- [Ebonhold] v2.2.0: restore user wildlife blacklist across sessions
	if ( Options.WildlifeBlacklist ) then
		wipe( me.Options.WildlifeBlacklist );
		for Name in pairs( Options.WildlifeBlacklist ) do
			me.Options.WildlifeBlacklist[ Name ] = true;
		end
	end
	-- [Ebonhold] v2.2.3: build the normalized lookup mirror from the verbatim user table.
	-- The verbatim table preserves whatever the user typed (so /esd wildlife list reads
	-- naturally); the gate consults the normalized mirror for case-insensitive matches.
	me.Options.WildlifeBlacklistNorm = {};
	for Name in pairs( me.Options.WildlifeBlacklist ) do
		local Key = NormalizeName( Name );
		if ( Key ) then me.Options.WildlifeBlacklistNorm[ Key ] = true; end
	end

	for NpcID, Name in pairs( OptionsCharacter.NPCs ) do
		-- If defaults, only add tamable custom mobs if the player is a hunter
		if ( not IsDefaultScan or IsHunter or not me.TamableIDs[ NpcID ] ) then
			me.NPCAdd( NpcID, Name, OptionsCharacter.NPCWorldIDs[ NpcID ] );
		end
	end
	for AchievementID in pairs( me.Achievements ) do
		-- If defaults, don't enable completed achievements unless explicitly allowed
		if ( OptionsCharacter.Achievements[ AchievementID ] and (
			not IsDefaultScan or Options.AchievementsAddFound or not select( 4, GetAchievementInfo( AchievementID ) ) -- Not completed
		) ) then
			me.AchievementAdd( AchievementID );
		end
	end
	me.CacheListPrint( false, true ); -- Populates cache list with inactive mobs too before printing
end




do
	local PetList = {};

	--- Prints the list of cached pets when leaving a city or inn.
	function me.Frame:PLAYER_UPDATE_RESTING ()
		if ( not IsResting() and next( PetList ) ) then
			if ( me.Options.CacheWarnings ) then
				local ListString = CacheListBuild( PetList );
				if ( ListString ) then
					me.Print( L.CACHED_PET_RESTING_FORMAT:format( ListString ), RED_FONT_COLOR );
				end
			else
				wipe( PetList );
			end
		end
	end

	--- @return True if the tamable mob is in its correct zone, else false with an optional reason string.
	local function OnFoundTamable ( NpcID, Name )
		local ExpectedZone = me.TamableIDs[ NpcID ];
		local ZoneIDBackup = GetCurrentMapAreaID() - 1;
		SetMapToCurrentZone();

		local InCorrectZone, InvalidReason =
			ExpectedZone == true -- Expected zone is unknown (instance mob, etc.)
			or ExpectedZone == GetCurrentMapAreaID() - 1;

		if ( not InCorrectZone ) then
			if ( IsResting() ) then -- Assume any tamable mob found in a city/inn is a hunter pet
				PetList[ NpcID ] = Name;  -- Suppress error message until the player stops resting
			else
				-- Get details about expected zone
				local ExpectedZoneName;
				SetMapByID( ExpectedZone );
				local Continent = GetCurrentMapContinent();
				if ( Continent >= 1 ) then
					local Zone = GetCurrentMapZone();
					if ( Zone == 0 ) then
						ExpectedZoneName = select( Continent, GetMapContinents() );
					else
						ExpectedZoneName = select( Zone, GetMapZones( Continent ) );
					end
				end
				InvalidReason = L.FOUND_TAMABLE_WRONGZONE_FORMAT:format(
					Name, GetZoneText(), ExpectedZoneName or L.FOUND_ZONE_UNKNOWN, ExpectedZone );
			end
		end

		SetMapByID( ZoneIDBackup ); -- Restore previous map view
		return InCorrectZone, InvalidReason;
	end
	local function TriggerFoundAlert ( NpcID, Name )
		local Button = me.Button;
		if ( Button and Button.SetNPC ) then
			Button:SetNPC( NpcID, Name ); -- Sends added and found overlay messages
			return true;
		end

		if ( me.Overlays ) then
			if ( me.Overlays.Add ) then
				me.Overlays.Add( NpcID );
			end
			if ( me.Overlays.Found ) then
				me.Overlays.Found( NpcID, Name );
			end
		end

		if ( Button and Button.PlaySound ) then
			Button.PlaySound( me.Options and me.Options.AlertSound or nil );
		else
			PlaySoundFile( [[Sound\Event Sounds\Event_wardrum_ogre.wav]] );
			PlaySoundFile( [[Sound\Events\scourge_horn.wav]] );
		end
	end
	--- Processes a confirmed-rare hit from the active-scan path: deactivates the scan,
	--- runs the tamable-zone check, and fires the alert. The gate (ShouldAlert) MUST run
	--- before this is called - this function does NOT re-validate wildlife/zone/etc.
	--- [Ebonhold] v2.2.3: renamed from OnFound. The split avoids NPCDeactivate firing on
	--- units that the gate would have rejected (the old OnFound deactivated before any
	--- validation ran, so a filtered unit silently dropped from the active scan).
	local function OnFoundValidated ( NpcID, Name )
		if ( type( Name ) ~= "string" ) then
			Name = me.OptionsCharacter.NPCs[ NpcID ] or L.NPCs[ NpcID ] or tostring( Name or NpcID );
		end

		-- Disable active scans
		NPCDeactivate( NpcID );
		for AchievementID in pairs( me.OptionsCharacter.Achievements ) do
			AchievementNPCDeactivate( me.Achievements[ AchievementID ], NpcID );
		end

		local Valid, InvalidReason = true;
		local Tamable = me.TamableIDs[ NpcID ];
		if ( Tamable ) then
			Valid, InvalidReason = OnFoundTamable( NpcID, Name );
		end

		if ( Valid ) then
			me.Print( L[ Tamable and "FOUND_TAMABLE_FORMAT" or "FOUND_FORMAT" ]:format( Name ), GREEN_FONT_COLOR );
			TriggerFoundAlert( NpcID, Name );
		elseif ( InvalidReason ) then
			me.Print( InvalidReason );
		end
	end

	local pairs = pairs;
	local GetAchievementCriteriaInfo = GetAchievementCriteriaInfo;
	local GetTime = GetTime;
	local NameplateScanFrame = CreateFrame( "Frame", nil, UIParent ); -- [Ebonhold] always-on cached-nameplate scanner
	NameplateScanFrame.UpdateRate = 0.3;
	local NameplateNextUpdate = 0;

	-- [Ebonhold] true when toast is already showing or queued for this NPC.
	local function IsToastAlreadyQueuedOrShown ( NpcID, Name )
		local Button = me.Button;
		if ( not Button ) then
			return false;
		end
		if ( Button.ID == NpcID or Button.NpcName == Name ) then
			return true;
		end
		if ( Button.PendingID == NpcID or Button.PendingName == Name ) then
			return true;
		end
		return false;
	end

	local function WasRecentlyDetected ( Name )
		-- [Ebonhold] v2.1.1: key by Name, not GUID. UnitGUID on 3.3.5a nameplates is
		-- unreliable and can return nil on subsequent calls for the same unit, causing
		-- different keys on each check and defeating the debounce entirely.
		if ( not Name ) then
			return;
		end
		local Now = GetTime();
		local Last = RecentDetections[ Name ];
		if ( Last and ( Now - Last ) < RecentDetectionWindow ) then
			return true;
		end
		RecentDetections[ Name ] = Now;

		for Key, Timestamp in pairs( RecentDetections ) do
			if ( ( Now - Timestamp ) > ( RecentDetectionWindow * 3 ) ) then
				RecentDetections[ Key ] = nil;
			end
		end
	end

	-- [Ebonhold] v2.2.3: unified trigger filter gate.
	-- Every detection path (target, mouseover, nameplate scan, NAME_PLATE_UNIT_ADDED,
	-- TestID cache fallback) now goes through this single function. Replaces the
	-- ad-hoc filter chains that lived in ProcessUnitForRares and GetNameplateTrackedMatch.
	--
	-- Ordering rationale:
	--   - Wildlife BEFORE classification: Ebonhold-changed wildlife (Plainsstrider, Reef
	--     Shark, etc.) is server-classified "rare", so a classification check first never
	--     rejects them.
	--   - Recent-detection AFTER UnitID checks: WasRecentlyDetected has a side effect
	--     (writes the timestamp). We only want to mark "seen" for confirmed candidates,
	--     not for every nameplate that gets scanned. Otherwise legit rares get debounced
	--     against unrelated nearby mobs that share a tracked-name string.
	--   - UnitID-dependent checks last and skipped when UnitID is nil (path E case):
	--     the cache fallback works from the WoW client's NPC name cache via me.TestID,
	--     so it has no unit token. Wildlife/zone/recent still apply.
	--
	-- PathTag values: "target", "mouseover", "scan", "trackedscan", "npua", "cache".
	-- Zone blacklist is skipped for "target" and "mouseover" - manually targeting a rare
	-- in a passively-blacklisted zone should still fire (preserves v2.0.0 intent).
	--
	-- Returns: NpcID, Name on success; nil, RejectStage on rejection.
	local function ShouldAlert ( NpcID, Name, UnitID, PathTag )
		-- 1. Resolve Name from unit token if needed
		if ( not Name and UnitID ) then
			Name = UnitName( UnitID );
		end
		if ( not Name ) then return nil, "nil_name"; end

		-- 2. Wildlife blacklist (normalized lookup)
		if ( me.Options.FilterWildlife ~= false ) then
			local Key = NormalizeName( Name );
			local UserNorm = me.Options.WildlifeBlacklistNorm;
			if ( Key and ( WILDLIFE_BLACKLIST_BUILTIN_NORM[ Key ] or ( UserNorm and UserNorm[ Key ] ) ) ) then
				LogMisfireHit( Name, "-", PathTag, "wildlife" );
				return nil, "wildlife";
			end
		end

		-- 3. Zone blacklist (passive paths only - manual target/mouseover bypasses)
		if ( PathTag ~= "target" and PathTag ~= "mouseover" ) then
			if ( me.Options.ZoneBlacklist and me.Options.ZoneBlacklist[ GetRealZoneText() ] ) then
				return nil, "zone";
			end
		end

		-- 4. Resolve NpcID from name if not provided
		if ( not NpcID ) then
			NpcID = GetTrackedNpcIDByName( Name );
		end
		if ( not NpcID ) then return nil, "not_tracked"; end

		-- 5. WorldID check (when configured for this NPC)
		local WorldID = me.OptionsCharacter.NPCWorldIDs and me.OptionsCharacter.NPCWorldIDs[ NpcID ];
		if ( WorldID and WorldID ~= me.WorldID ) then return nil, "world_mismatch"; end

		-- 6. UnitID-dependent checks (skip for path E - cache fallback has no unit token)
		if ( UnitID ) then
			if ( not UnitExists( UnitID ) ) then return nil, "no_unit"; end
			if ( UnitPlayerControlled( UnitID ) ) then return nil, "player_ctrl"; end
			local Classification = UnitClassification( UnitID );
			local ClsPass = ( Classification == "rare" or Classification == "rareelite" );
			-- [Ebonhold] v2.1.7 preservation: log the classification candidate. nil stage
			-- means "passed the gate at this point"; "classification" means rejected here.
			LogMisfireHit( Name, Classification, PathTag, ClsPass and nil or "classification" );
			if ( not ClsPass ) then return nil, "classification"; end
			local Reaction = UnitReaction( UnitID, "player" );
			if ( not Reaction or Reaction > 4 ) then return nil, "reaction"; end
		end

		-- 7. Recent-detection debounce (has side effect - only mark "seen" once we're a real candidate)
		if ( WasRecentlyDetected( Name ) ) then return nil, "recent"; end

		-- 8. Toast dedup
		if ( IsToastAlreadyQueuedOrShown( NpcID, Name ) ) then return nil, "dup_toast"; end

		return NpcID, Name;
	end
	-- [Ebonhold] nameplate detection. Path B in the gate: active-scan-only nameplate
	-- iteration, runs every 0.3s from the main frame OnUpdate. ScanIDs[NpcID] gates
	-- whether we have an active search for the matched NPC; the rest is the unified gate.
	local function ScanNameplates ()
		if ( not next( ScanIDs ) ) then return; end
		for i = 1, 40 do
			local PlateUnit = "nameplate" .. i;
			local NpcID, Name = ShouldAlert( nil, nil, PlateUnit, "scan" );
			if ( NpcID and ScanIDs[ NpcID ] ) then
				OnFoundValidated( NpcID, Name );
				return true;
			end
		end
	end

	-- [Ebonhold] scan tracked NPCs from nameplates. Path C in the gate: covers the full
	-- TrackedNames set (vanilla rares from OptionsCharacter.NPCs that may not be in
	-- ScanIDs). Uses direct TriggerFoundAlert (NOT OnFoundValidated) to avoid
	-- NPCDeactivate removing cached entries from active scans - preserves the
	-- copilot-instructions.md:121 rule about no OnFound side effects on this path.
	local function ScanTrackedNameplates ()
		for i = 1, 40 do
			local PlateUnit = "nameplate" .. i;
			local NpcID, Name = ShouldAlert( nil, nil, PlateUnit, "trackedscan" );
			if ( NpcID ) then
				me.Print( L.FOUND_FORMAT:format( Name ), GREEN_FONT_COLOR );
				TriggerFoundAlert( NpcID, Name );
				return true;
			end
		end
	end
	--- Scans all active criteria and removes any completed NPCs.
	local function AchievementCriteriaUpdate ()
		if ( not me.Options.AchievementsAddFound ) then
			for AchievementID in pairs( me.OptionsCharacter.Achievements ) do
				local Achievement = me.Achievements[ AchievementID ];
				for NpcID, CriteriaID in pairs( Achievement.NPCsActive ) do
					local _, _, Complete = GetAchievementCriteriaInfo( CriteriaID );
					if ( Complete ) then
						AchievementNPCDeactivate( Achievement, NpcID );
					end
				end
			end
		end
	end
	local CriteriaUpdated = false;
	--- Stops tracking individual achievement NPCs when the player gets kill credit.
	function me.Frame:CRITERIA_UPDATE ()
		CriteriaUpdated = true;
	end

	local NextUpdate = 0;
	--- Scans all NPCs on a timer and alerts if any are found.
	function me.Frame:OnUpdate ( Elapsed )
		NextUpdate = NextUpdate - Elapsed;
		if ( NextUpdate <= 0 ) then
			NextUpdate = self.UpdateRate; -- [Ebonhold] nameplate detection

			if ( CriteriaUpdated ) then -- CRITERIA_UPDATE bucket
				CriteriaUpdated = false;
				AchievementCriteriaUpdate();
			end

			if ( not next( ScanIDs ) ) then
				return;
			end

			local ok, foundOrErr = pcall( ScanNameplates );
			local Found = ok and foundOrErr;
			if ( not Found ) then
				-- Path E: TestID cache fallback. Inherited from upstream _NPCScan, retained
				-- for Outland/Northrend rares whose names enter the WoW client's NPC name
				-- cache (e.g. when nearby players target them). Pre-v2.2.3 this path
				-- bypassed every filter - any rare in active ScanIDs whose name happened
				-- to be cached would fire regardless of wildlife/zone state.
				for NpcID in pairs( ScanIDs ) do
					local Name = me.TestID( NpcID );
					if ( Name and Name == L.NPCs[ NpcID ] ) then
						local AllowedID = ShouldAlert( NpcID, Name, nil, "cache" );
						if ( AllowedID ) then
							OnFoundValidated( NpcID, Name );
							break;
						end
					end
				end
			end
		end
	end

	-- [Ebonhold] independent nameplate scan tick for cached NPCs that are not in ScanIDs.
	NameplateScanFrame:SetScript( "OnUpdate", function ( self, Elapsed )
		if ( not self:IsShown() ) then
			self:Show();
		end
		NameplateNextUpdate = NameplateNextUpdate - Elapsed;
		if ( NameplateNextUpdate <= 0 ) then
			NameplateNextUpdate = self.UpdateRate;
			pcall( ScanTrackedNameplates );
		end
	end );

	-- [Ebonhold] v2.0.0: scan target and mouseover units for rare matches.
	-- Catches rares that are targeted/moused-over even when nameplates are hidden or off.
	-- [Ebonhold] v2.2.3: collapsed into a single ShouldAlert gate call. Path A in the
	-- gate; zone blacklist is intentionally bypassed for "target"/"mouseover" PathTags
	-- so manual targeting of a rare in a passively-blacklisted zone still alerts.
	local function ProcessUnitForRares ( UnitID )
		local PathTag = ( UnitID == "target" ) and "target" or "mouseover";
		local NpcID, Name = ShouldAlert( nil, nil, UnitID, PathTag );
		if ( not NpcID ) then return; end
		me.Print( L.FOUND_FORMAT:format( Name ), GREEN_FONT_COLOR );
		TriggerFoundAlert( NpcID, Name );
	end

	-- [Ebonhold] v2.0.0: register target/mouseover events on the always-on scan frame.
	-- [Ebonhold] v2.1.1: NAME_PLATE_UNIT_ADDED fires the instant a nameplate becomes active,
	-- giving zero-tick detection instead of waiting up to 0.3s for the OnUpdate fallback.
	NameplateScanFrame:RegisterEvent( "PLAYER_TARGET_CHANGED" );
	NameplateScanFrame:RegisterEvent( "UPDATE_MOUSEOVER_UNIT" );
	NameplateScanFrame:RegisterEvent( "NAME_PLATE_UNIT_ADDED" );
	NameplateScanFrame:SetScript( "OnEvent", function ( self, Event, UnitToken )
		if ( Event == "PLAYER_TARGET_CHANGED" ) then
			pcall( ProcessUnitForRares, "target" );
		elseif ( Event == "UPDATE_MOUSEOVER_UNIT" ) then
			pcall( ProcessUnitForRares, "mouseover" );
		elseif ( Event == "NAME_PLATE_UNIT_ADDED" ) then
			-- Fast path D: zero-tick detection on nameplate appearance. Branches on
			-- ScanIDs membership: active scans go through OnFoundValidated (which
			-- deactivates the search); cached-only matches use direct TriggerFoundAlert.
			pcall( function ()
				local NpcID, Name = ShouldAlert( nil, nil, UnitToken, "npua" );
				if ( not NpcID ) then return; end
				if ( ScanIDs[ NpcID ] ) then
					OnFoundValidated( NpcID, Name );
				else
					me.Print( L.FOUND_FORMAT:format( Name ), GREEN_FONT_COLOR );
					TriggerFoundAlert( NpcID, Name );
				end
			end );
		end
	end );

	NameplateScanFrame:Show();
end




--- Loads defaults, validates settings, and starts scan.
-- Used instead of ADDON_LOADED to give overlay mods a chance to load and register for messages.
function me.Frame:PLAYER_LOGIN ( Event )
	self[ Event ] = nil;

	local Options = EbonSearchDB;
	local OptionsCharacter = EbonSearchCharacterDB;
	-- [Ebonhold] force defaults if saved vars look truncated
	local npcCount = 0;
	if ( OptionsCharacter and OptionsCharacter.NPCs ) then
		for _ in pairs( OptionsCharacter.NPCs ) do npcCount = npcCount + 1; end
	end
	if ( npcCount < 10 ) then
		OptionsCharacter = nil; -- force Synchronize to use defaults
	end
	EbonSearchDB = me.Options;
	EbonSearchCharacterDB = me.OptionsCharacter;

	-- Update settings incrementally
	if ( Options and Options.Version ~= me.Version ) then
		if ( Options.Version == "3.0.9.2" ) then -- 3.1.0.1: Added options for finding already found and tamable mobs
			Options.CacheWarnings = true;
			Options.Version = "3.1.0.1";
		end
		Options.Version = me.Version;
	end
	-- Character settings
	if ( OptionsCharacter and OptionsCharacter.Version ~= me.Version ) then
		local Version = OptionsCharacter.Version;
		if ( Version == "3.0.9.2" ) then -- 3.1.0.1: Remove NPCs that are duplicated by achievements
			local NPCs = OptionsCharacter.IDs;
			OptionsCharacter.IDs = nil;
			OptionsCharacter.NPCs = NPCs;
			OptionsCharacter.Achievements = {};
			local AchievementNPCs = {};
			for AchievementID, Achievement in pairs( me.Achievements ) do
				for _, NpcID in pairs( Achievement.Criteria ) do
					AchievementNPCs[ NpcID ] = AchievementID;
				end
			end
			for Name, NpcID in pairs( NPCs ) do
				if ( AchievementNPCs[ NpcID ] ) then
					NPCs[ Name ] = nil;
					OptionsCharacter.Achievements[ AchievementNPCs[ NpcID ] ] = true;
				end
			end
			Version = "3.1.0.1";
		end
		if ( Version == "3.1.0.1" or Version == "3.2.0.1" or Version == "3.2.0.2" ) then
			-- 3.2.0.3: Added default scan for Skoll
			OptionsCharacter.NPCs[ L.NPCs[ 35189 ] ] = 35189;
			Version = "3.2.0.3";
		end
		if ( "3.2.0.3" <= Version and Version <= "3.3.0.1" ) then
			-- 3.3.0.2: Added default scan for Arcturis
			OptionsCharacter.NPCs[ L.NPCs[ 38453 ] ] = 38453;
			Version = "3.3.0.2";
		end
		if ( Version == "3.3.0.2" or Version == "3.3.0.3" or Version == "3.3.0.4" ) then
			-- 3.3.5.1: Custom NPC scans are indexed by ID instead of name, and can now be map-specific
			local DefaultWorldIDs = me.OptionsCharacterDefault.NPCWorldIDs;
			local NPCsNew, NPCWorldIDs = {}, {};
			for Name, NpcID in pairs( OptionsCharacter.NPCs ) do
				NPCsNew[ NpcID ] = Name;
				NPCWorldIDs[ NpcID ] = DefaultWorldIDs[ NpcID ];
			end
			OptionsCharacter.NPCs, OptionsCharacter.NPCWorldIDs = NPCsNew, NPCWorldIDs;
			Version = "3.3.5.1";
		end
		OptionsCharacter.Version = me.Version;
	end

	me.Overlays.Register();
	-- [Ebonhold] v2.0.0: call Synchronize directly; table-file PLAYER_LOGIN handlers
	-- fire after this and use NPCActivate's NPCsActive guard for deduplication.
	-- The earlier deferred 0.1s timer caused orphan-scan crashes because table files
	-- added to SessionNPCNames before Synchronize could clear them.
	me.Synchronize( Options, OptionsCharacter );
end
do
	local FirstWorld = true;
	--- Starts world-specific scans when entering a world.
	function me.Frame:PLAYER_ENTERING_WORLD ()
		-- Print cached pets if player ported out of a city
		self:PLAYER_UPDATE_RESTING();

		-- Since real MapIDs aren't available to addons, a "WorldID" is a universal ContinentID or the map's localized name.
		local MapName = GetInstanceInfo();
		me.WorldID = me.ContinentIDs[ MapName ] or MapName;

		-- Activate scans on this world
		for NpcID, WorldID in pairs( me.OptionsCharacter.NPCWorldIDs ) do
			NPCActivate( NpcID, WorldID );
		end
		for AchievementID in pairs( me.OptionsCharacter.Achievements ) do
			local Achievement = me.Achievements[ AchievementID ];
			if ( Achievement.WorldID ) then
				AchievementActivate( Achievement );
			end
		end

		-- [Ebonhold] timing fix: re-activate NPCs added during PLAYER_LOGIN
		-- before WorldID was known and therefore rejected
		for NpcID in pairs( me.OptionsCharacter.NPCs ) do
			if ( not ScanIDs[ NpcID ] ) then
				NPCActivate( NpcID, me.OptionsCharacter.NPCWorldIDs[ NpcID ] );
			end
		end

		if ( FirstWorld or not me.Options.CacheWarnings ) then -- Full listing of cached mobs gets printed on login
			FirstWorld = false;
			wipe( CacheList );
		else -- Print list of cached mobs specific to new world
			local ListString = CacheListBuild( CacheList );
			if ( ListString ) then
				me.Print( L.CACHED_WORLD_FORMAT:format( ListString, MapName ) );
			end
		end
	end
end
--- Stops world-specific scans when leaving a world.
function me.Frame:PLAYER_LEAVING_WORLD ()
	-- Stop scans that were only active on the previous world
	for NpcID in pairs( me.OptionsCharacter.NPCWorldIDs ) do
		NPCDeactivate( NpcID );
	end
	for AchievementID in pairs( me.OptionsCharacter.Achievements ) do
		local Achievement = me.Achievements[ AchievementID ];
		if ( Achievement.WorldID ) then
			AchievementDeactivate( Achievement );
		end
	end
	me.WorldID = nil;
end
--- Stops tracking achievements when they finish.
function me.Frame:ACHIEVEMENT_EARNED ( _, AchievementID )
	if ( not me.Options.AchievementsAddFound ) then
		me.AchievementRemove( AchievementID );
	end
end
--- Sets the OnUpdate handler only after zone info is known.
function me.Frame:ZONE_CHANGED_NEW_AREA ( Event )
	self:UnregisterEvent( Event );
	self[ Event ] = nil;

	self:SetScript( "OnUpdate", self.OnUpdate );
end
--- Global event handler.
function me.Frame:OnEvent ( Event, ... )
	if ( self[ Event ] ) then
		return self[ Event ]( self, Event, ... );
	end
end




--- Slash command chat handler to open the options pane and manage the NPC list.
function me.SlashCommand ( Input )
	local Command, Arguments = Input:match( "^(%S+)%s*(.-)%s*$" );
	if ( Command ) then
		Command = Command:upper();
		if ( Command == L.CMD_ADD ) then
			local ID, Name = Arguments:match( "^(%d+)%s+(.+)$" );
			if ( ID ) then
				ID = tonumber( ID );
				me.NPCRemove( ID );
				if ( me.NPCAdd( ID, Name ) ) then
					me.CacheListPrint( true );
				end
				return;
			end
		elseif ( Command == L.CMD_REMOVE ) then
			local ID = tonumber( Arguments );
			if ( not ID ) then -- Search custom names
				for NpcID, Name in pairs( me.OptionsCharacter.NPCs ) do
					if ( Name == Arguments ) then
						ID = NpcID;
						break;
					end
				end
			end
			if ( not me.NPCRemove( ID ) ) then
				me.Print( L.CMD_REMOVENOTFOUND_FORMAT:format( Arguments ), RED_FONT_COLOR );
			end
			return;
		elseif ( Command == L.CMD_CACHE ) then -- Force print full cache list
			if ( not me.CacheListPrint( true, true ) ) then -- Nothing in cache
				me.Print( L.CMD_CACHE_EMPTY, GREEN_FONT_COLOR );
			end
			return;
		elseif ( Command == "CLEARCACHE" ) then
			for NpcID in pairs( me.OptionsCharacter.NPCs ) do
				me.NPCRemove( NpcID );
			end
			wipe( me.OptionsCharacter.NPCs );
			wipe( me.OptionsCharacter.NPCWorldIDs );
			wipe( SessionNPCNames );
			wipe( RecentDetections );
			TrackedNamesDirty = true;
			me.Print( "Cache cleared", GREEN_FONT_COLOR );
			return;
		end
		-- Invalid subcommand
		me.Print( L.CMD_HELP );

	else -- No subcommand
		InterfaceOptionsFrame_OpenToCategory( me.Config.Search );
	end
end




-- Create reverse lookup of continent names
for Index, Name in ipairs( { GetMapContinents() } ) do
	me.ContinentIDs[ Name ] = Index;
end
-- Save achievement criteria data
for AchievementID, Achievement in pairs( me.Achievements ) do
	Achievement.ID = AchievementID;
	Achievement.Criteria = {}; -- [ CriteriaID ] = NpcID;
	Achievement.NPCsActive = {}; -- [ NpcID ] = CriteriaID;
	for Criteria = 1, GetAchievementNumCriteria( AchievementID ) do
		local _, CriteriaType, _, _, _, _, _, AssetID, _, CriteriaID = GetAchievementCriteriaInfo( AchievementID, Criteria );
		if ( CriteriaType == 0 ) then -- Mob kill type
			Achievement.Criteria[ CriteriaID ] = AssetID;
		end
	end
end


local Frame = me.Frame;
Frame:Hide();
Frame:SetScript( "OnEvent", Frame.OnEvent );
if ( not IsLoggedIn() ) then
	Frame:RegisterEvent( "PLAYER_LOGIN" );
else
	Frame:PLAYER_LOGIN( "PLAYER_LOGIN" );
end
Frame:RegisterEvent( "PLAYER_ENTERING_WORLD" );
Frame:RegisterEvent( "PLAYER_LEAVING_WORLD" );
Frame:RegisterEvent( "PLAYER_UPDATE_RESTING" );
-- Set OnUpdate script after zone info loads
if ( GetZoneText() == "" ) then -- Zone information unknown (initial login)
	Frame:RegisterEvent( "ZONE_CHANGED_NEW_AREA" );
else -- Zone information is known
	Frame:ZONE_CHANGED_NEW_AREA( "ZONE_CHANGED_NEW_AREA" );
end

-- [Ebonhold] v2.0.0: unified /esd command - no-args opens Interface Options,
-- subcommands handle zone blacklist management.
SLASH_ESD1 = "/esd";
SlashCmdList["ESD"] = function ( Input )
	if ( not me.Options.ZoneBlacklist ) then
		me.Options.ZoneBlacklist = {};
	end
	local Command = Input:match( "^(%S+)" );

	if ( not Command ) then
		-- No arguments: open Interface Options panel
		InterfaceOptionsFrame_OpenToCategory( me.Config );
		InterfaceOptionsFrame_OpenToCategory( me.Config ); -- twice to ensure correct tab selection
		return;
	end

	local Rest1 = Input:match( "^%S+%s+(.+)$" );
	local Sub = Rest1 and Rest1:match( "^(%S+)" );
	local Rest2 = Rest1 and Rest1:match( "^%S+%s+(.+)$" );
	local Action = Rest2 and Rest2:match( "^(%S+)" );
	local ZoneArg = Rest2 and Rest2:match( "^%S+%s+(.+)$" );
	Command = Command:upper();
	Sub     = Sub     and Sub:upper()     or "";
	Action  = Action  and Action:upper()  or "";

	if ( Command == "ZONE" and Sub == "BLACKLIST" ) then
		if ( Action == "ADD" ) then
			local Zone = ZoneArg or GetRealZoneText();
			me.Options.ZoneBlacklist[ Zone ] = true;
			me.Print( "Zone blacklisted: |cffFFFF00" .. Zone .. "|r", GREEN_FONT_COLOR );
			if ( me.Config and me.Config.ZoneBlacklist ) then
				me.Config.ZoneBlacklist.Refresh();
			end
		elseif ( Action == "REMOVE" ) then
			local Zone = ZoneArg or GetRealZoneText();
			me.Options.ZoneBlacklist[ Zone ] = nil;
			me.Print( "Zone removed: |cffFFFF00" .. Zone .. "|r", GREEN_FONT_COLOR );
			if ( me.Config and me.Config.ZoneBlacklist ) then
				me.Config.ZoneBlacklist.Refresh();
			end
		elseif ( Action == "LIST" ) then
			me.Print( "Blacklisted zones:" );
			local count = 0;
			for Zone in pairs( me.Options.ZoneBlacklist ) do
				me.Print( "  |cffFFFF00" .. Zone .. "|r" );
				count = count + 1;
			end
			if ( count == 0 ) then me.Print( "  (none)" ); end
		else
			me.Print( "/esd zone blacklist [add|remove|list] [zone name]" );
		end
	elseif ( Command == "WILDLIFE" ) then
		-- [Ebonhold] v2.2.0: user-editable wildlife blacklist; merges with WILDLIFE_BLACKLIST_BUILTIN at detection time.
		-- Usage: /esd wildlife add <name>  |  /esd wildlife remove <name>  |  /esd wildlife list
		-- <name> is the full creature name as it appears in-game (multi-word names are supported).
		if ( Sub == "ADD" ) then
			local Name = Rest2;
			if ( Name and Name ~= "" ) then
				-- [Ebonhold] v2.2.3: keep the verbatim and normalized tables in sync.
				-- Verbatim preserves whatever the user typed (for /esd wildlife list);
				-- normalized is what the gate consults so case differences don't matter.
				me.Options.WildlifeBlacklist[ Name ] = true;
				local Key = NormalizeName( Name );
				if ( Key ) then me.Options.WildlifeBlacklistNorm[ Key ] = true; end
				me.Print( "Wildlife blacklisted: |cffFFFF00" .. Name .. "|r  (use /esd wildlife remove to undo)", GREEN_FONT_COLOR );
			else
				me.Print( "/esd wildlife add <creature name>" );
			end
		elseif ( Sub == "REMOVE" ) then
			local Name = Rest2;
			if ( Name and Name ~= "" ) then
				-- [Ebonhold] v2.2.3: resolve through normalized form so a user can undo
				-- "add Giraffe" with "remove giraffe" or "remove GIRAFFE". Removes every
				-- verbatim entry whose normalized form matches.
				local Key = NormalizeName( Name );
				if ( Key ) then
					for Existing in pairs( me.Options.WildlifeBlacklist ) do
						if ( NormalizeName( Existing ) == Key ) then
							me.Options.WildlifeBlacklist[ Existing ] = nil;
						end
					end
					me.Options.WildlifeBlacklistNorm[ Key ] = nil;
				else
					me.Options.WildlifeBlacklist[ Name ] = nil;
				end
				me.Print( "Wildlife un-blacklisted: |cffFFFF00" .. Name .. "|r", GREEN_FONT_COLOR );
			else
				me.Print( "/esd wildlife remove <creature name>" );
			end
		elseif ( Sub == "LIST" ) then
			me.Print( "User wildlife blacklist:" );
			local count = 0;
			for Name in pairs( me.Options.WildlifeBlacklist ) do
				me.Print( "  |cffFFFF00" .. Name .. "|r" );
				count = count + 1;
			end
			if ( count == 0 ) then me.Print( "  (none -- only built-in entries active)" ); end
		else
			me.Print( "/esd wildlife [add|remove|list] <creature name>" );
		end
	elseif ( Command == L.CMD_ADD ) then
		local ID, Name = ( Rest1 or "" ):match( "^(%d+)%s+(.+)$" );
		if ( ID ) then
			ID = tonumber( ID );
			me.NPCRemove( ID );
			if ( me.NPCAdd( ID, Name ) ) then
				me.CacheListPrint( true );
			end
		else
			me.Print( L.CMD_HELP );
		end
	elseif ( Command == L.CMD_REMOVE ) then
		local ID = tonumber( Rest1 );
		if ( not ID ) then
			for NpcID, Name in pairs( me.OptionsCharacter.NPCs ) do
				if ( Name == Rest1 ) then
					ID = NpcID;
					break;
				end
			end
		end
		if ( not me.NPCRemove( ID ) ) then
			me.Print( L.CMD_REMOVENOTFOUND_FORMAT:format( Rest1 or "" ), RED_FONT_COLOR );
		end
	elseif ( Command == L.CMD_CACHE ) then
		if ( not me.CacheListPrint( true, true ) ) then
			me.Print( L.CMD_CACHE_EMPTY, GREEN_FONT_COLOR );
		end
	elseif ( Command == "CLEAR" ) then
		for NpcID in pairs( me.OptionsCharacter.NPCs ) do
			me.NPCRemove( NpcID );
		end
		wipe( me.OptionsCharacter.NPCs );
		wipe( me.OptionsCharacter.NPCWorldIDs );
		wipe( SessionNPCNames );
		wipe( RecentDetections );
		TrackedNamesDirty = true;
		me.Print( "All custom NPCs cleared.", GREEN_FONT_COLOR );
	elseif ( Command == "DEBUG" and Sub == "OVERLAYS" ) then
		-- [Ebonhold] Dev: dump last ApplyTransform sample from EbonOverlay
		if ( EbonOverlay and EbonOverlay.PrintDebugTransform ) then
			EbonOverlay.PrintDebugTransform();
		else
			me.Print( "EbonOverlay not loaded.", RED_FONT_COLOR );
		end
	elseif ( Command == "MISFIRE" ) then
		-- [Ebonhold] v2.1.7: dump last classification hits for misfire debugging.
		-- [Ebonhold] v2.2.3: extended with path tag (target/mouseover/scan/trackedscan/
		-- npua/cache) and reject stage. stage="-" means the candidate passed the gate at
		-- the classification check; "wildlife"/"classification" mean rejected at that stage.
		me.Print( "|cff66ccffEbonSearch|r misfire log (last " .. MisfireLogSize .. " gate-relevant hits):" );
		local count = 0;
		for i = 1, MisfireLogSize do
			local entry = MisfireLog[ i ];
			if ( entry ) then
				count = count + 1;
				local age = math.floor( GetTime() - entry.time );
				me.Print( string.format( "  |cffFFFF00%s|r / cls=%s / path=%s / stage=%s  (%ds ago)",
					entry.name,
					entry.classification or "?",
					entry.path or "?",
					entry.stage or "-",
					age ) );
			end
		end
		if ( count == 0 ) then me.Print( "  (no entries yet -- walk near a rare or use /esd debug targets)." ); end
	else
		me.Print( "|cff66ccffEbonhold|r Search & Destroy v" .. me.Version );
		me.Print( "  |cffFFFF00/esd|r                             -- open options panel" );
		me.Print( "  /esd add <NpcID> <Name>           -- add custom NPC to track" );
		me.Print( "  /esd remove <NpcID or Name>       -- remove custom NPC" );
		me.Print( "  /esd cache                        -- list cached (unreachable) NPCs" );
		me.Print( "  /esd clear                        -- clear all custom NPCs" );
		me.Print( "  /esd zone blacklist add [zone]    -- blacklist current or named zone" );
		me.Print( "  /esd zone blacklist remove [zone] -- un-blacklist zone" );
		me.Print( "  /esd zone blacklist list           -- list all blacklisted zones" );
		me.Print( "  /esd wildlife add <name>          -- suppress a misfire by creature name" );
		me.Print( "  /esd wildlife remove <name>       -- un-suppress a creature name" );
		me.Print( "  /esd wildlife list                -- list user-added wildlife entries" );
		me.Print( "  /esd debug overlays               -- dev: dump last UV transform sample" );
		me.Print( "  /esd misfire                      -- dev: last " .. MisfireLogSize .. " ProcessUnitForRares classification hits" );
	end
end;
-- /npcscan is a backward-compatible alias for the ESD handler
SlashCmdList[ "_EBONSEARCH" ] = SlashCmdList[ "ESD" ];