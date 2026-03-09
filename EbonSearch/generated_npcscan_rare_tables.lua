local rares = {
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

}

local rareWorldIDs = {
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

}

local rareZones = {
    -- Azshara
    [ 193 ] = "Azshara",

    -- Redridge Mountains
    [ 335 ] = "Redridge Mountains",
    [ 349 ] = "Redridge Mountains",
    [ 397 ] = "Redridge Mountains",

    -- Elwynn Forest
    [ 448 ] = "Elwynn Forest",

    -- Stranglethorn Vale
    [ 469 ] = "Stranglethorn Vale",

    -- Westfall
    [ 523 ] = "Westfall",
    [ 626 ] = "Westfall",

    -- Stranglethorn Vale
    [ 730 ] = "Stranglethorn Vale",
    [ 731 ] = "Stranglethorn Vale",
    [ 813 ] = "Stranglethorn Vale",

    -- Redridge Mountains
    [ 931 ] = "Redridge Mountains",

    -- Stranglethorn Vale
    [ 1060 ] = "Stranglethorn Vale",

    -- Duskwood
    [ 1200 ] = "Duskwood",

    -- Dun Morogh
    [ 1271 ] = "Dun Morogh",

    -- Wetlands
    [ 1364 ] = "Wetlands",

    -- Stranglethorn Vale
    [ 1387 ] = "Stranglethorn Vale",

    -- Dun Morogh
    [ 1388 ] = "Dun Morogh",

    -- Stranglethorn Vale
    [ 1492 ] = "Stranglethorn Vale",
    [ 1559 ] = "Stranglethorn Vale",

    -- Wetlands
    [ 1571 ] = "Wetlands",

    -- Loch Modan
    [ 1572 ] = "Loch Modan",

    -- Western Plaguelands
    [ 1788 ] = "Western Plaguelands",
    [ 1805 ] = "Western Plaguelands",
    [ 1842 ] = "Western Plaguelands",
    [ 1843 ] = "Western Plaguelands",
    [ 1846 ] = "Western Plaguelands",
    [ 1850 ] = "Western Plaguelands",
    [ 1852 ] = "Western Plaguelands",

    -- Eastern Plaguelands
    [ 1855 ] = "Eastern Plaguelands",

    -- Silverpine Forest
    [ 1947 ] = "Silverpine Forest",
    [ 2106 ] = "Silverpine Forest",

    -- Teldrassil
    [ 2166 ] = "Teldrassil",

    -- Hillsbrad Foothills
    [ 2215 ] = "Hillsbrad Foothills",

    -- Silverpine Forest
    [ 2226 ] = "Silverpine Forest",

    -- Hillsbrad Foothills
    [ 2276 ] = "Hillsbrad Foothills",

    -- Burning Steppes
    [ 2299 ] = "Burning Steppes",

    -- Hillsbrad Foothills
    [ 2304 ] = "Hillsbrad Foothills",
    [ 2389 ] = "Hillsbrad Foothills",

    -- Duskwood
    [ 2409 ] = "Duskwood",

    -- Alterac Mountains
    [ 2420 ] = "Alterac Mountains",
    [ 2421 ] = "Alterac Mountains",
    [ 2422 ] = "Alterac Mountains",

    -- Hillsbrad Foothills
    [ 2432 ] = "Hillsbrad Foothills",

    -- Alterac Mountains
    [ 2447 ] = "Alterac Mountains",

    -- Loch Modan
    [ 2477 ] = "Loch Modan",
    [ 2478 ] = "Loch Modan",

    -- Silverpine Forest
    [ 2529 ] = "Silverpine Forest",

    -- Arathi Highlands
    [ 2558 ] = "Arathi Highlands",
    [ 2597 ] = "Arathi Highlands",
    [ 2598 ] = "Arathi Highlands",
    [ 2599 ] = "Arathi Highlands",
    [ 2601 ] = "Arathi Highlands",
    [ 2602 ] = "Arathi Highlands",
    [ 2607 ] = "Arathi Highlands",
    [ 2611 ] = "Arathi Highlands",
    [ 2612 ] = "Arathi Highlands",

    -- Stranglethorn Vale
    [ 2635 ] = "Stranglethorn Vale",

    -- Badlands
    [ 2726 ] = "Badlands",
    [ 2745 ] = "Badlands",
    [ 2749 ] = "Badlands",
    [ 2754 ] = "Badlands",

    -- Arathi Highlands
    [ 2780 ] = "Arathi Highlands",
    [ 2781 ] = "Arathi Highlands",
    [ 2782 ] = "Arathi Highlands",
    [ 2783 ] = "Arathi Highlands",
    [ 2835 ] = "Arathi Highlands",
    [ 2851 ] = "Arathi Highlands",

    -- Stranglethorn Vale
    [ 2858 ] = "Stranglethorn Vale",
    [ 2859 ] = "Stranglethorn Vale",

    -- Badlands
    [ 2861 ] = "Badlands",
    [ 2931 ] = "Badlands",

    -- Loch Modan
    [ 2932 ] = "Loch Modan",

    -- Searing Gorge
    [ 2941 ] = "Searing Gorge",

    -- The Barrens
    [ 3270 ] = "The Barrens",

    -- Searing Gorge
    [ 3305 ] = "Searing Gorge",

    -- The Barrens
    [ 3398 ] = "The Barrens",
    [ 3615 ] = "The Barrens",
    [ 3638 ] = "The Barrens",
    [ 3652 ] = "The Barrens",
    [ 3655 ] = "The Barrens",
    [ 3672 ] = "The Barrens",

    -- Ashenvale
    [ 3691 ] = "Ashenvale",

    -- Teldrassil
    [ 3838 ] = "Teldrassil",

    -- Darkshore
    [ 3841 ] = "Darkshore",

    -- Alterac Mountains
    [ 3984 ] = "Alterac Mountains",
    [ 3985 ] = "Alterac Mountains",

    -- Ashenvale
    [ 4267 ] = "Ashenvale",

    -- Stonetalon Mountains
    [ 4312 ] = "Stonetalon Mountains",

    -- The Hinterlands
    [ 4314 ] = "The Hinterlands",

    -- Thousand Needles
    [ 4317 ] = "Thousand Needles",

    -- Feralas
    [ 4319 ] = "Feralas",

    -- Dustwallow Marsh
    [ 4321 ] = "Dustwallow Marsh",
    [ 4339 ] = "Dustwallow Marsh",

    -- Stonetalon Mountains
    [ 4407 ] = "Stonetalon Mountains",
    [ 4409 ] = "Stonetalon Mountains",

    -- The Hinterlands
    [ 4468 ] = "The Hinterlands",
    [ 4469 ] = "The Hinterlands",

    -- Loch Modan
    [ 4872 ] = "Loch Modan",

    -- Feralas
    [ 5312 ] = "Feralas",

    -- Ashenvale
    [ 5314 ] = "Ashenvale",

    -- Feralas
    [ 5357 ] = "Feralas",

    -- Tanaris
    [ 5432 ] = "Tanaris",
    [ 5469 ] = "Tanaris",

    -- The Hinterlands
    [ 5718 ] = "The Hinterlands",

    -- Desolace
    [ 5760 ] = "Desolace",

    -- Mulgore
    [ 5785 ] = "Mulgore",

    -- Durotar
    [ 5822 ] = "Durotar",
    [ 5824 ] = "Durotar",

    -- The Barrens
    [ 5827 ] = "The Barrens",
    [ 5828 ] = "The Barrens",
    [ 5830 ] = "The Barrens",
    [ 5831 ] = "The Barrens",

    -- Searing Gorge
    [ 5833 ] = "Searing Gorge",

    -- The Barrens
    [ 5841 ] = "The Barrens",
    [ 5842 ] = "The Barrens",
    [ 5851 ] = "The Barrens",
    [ 5859 ] = "The Barrens",
    [ 5864 ] = "The Barrens",

    -- Stonetalon Mountains
    [ 5928 ] = "Stonetalon Mountains",
    [ 5930 ] = "Stonetalon Mountains",
    [ 5931 ] = "Stonetalon Mountains",
    [ 5932 ] = "Stonetalon Mountains",

    -- Thousand Needles
    [ 5934 ] = "Thousand Needles",
    [ 5935 ] = "Thousand Needles",
    [ 5937 ] = "Thousand Needles",

    -- Swamp of Sorrows
    [ 6026 ] = "Swamp of Sorrows",

    -- Azshara
    [ 6134 ] = "Azshara",
    [ 6140 ] = "Azshara",

    -- Dun Morogh
    [ 6231 ] = "Dun Morogh",

    -- Un'Goro Crater
    [ 6500 ] = "Un'Goro Crater",
    [ 6560 ] = "Un'Goro Crater",
    [ 6583 ] = "Un'Goro Crater",
    [ 6584 ] = "Un'Goro Crater",

    -- Azshara
    [ 6646 ] = "Azshara",

    -- Darkshore
    [ 6669 ] = "Darkshore",

    -- Desolace
    [ 6706 ] = "Desolace",
    [ 6726 ] = "Desolace",

    -- Redridge Mountains
    [ 7009 ] = "Redridge Mountains",

    -- Westfall
    [ 7053 ] = "Westfall",

    -- Badlands
    [ 7057 ] = "Badlands",

    -- Hillsbrad Foothills
    [ 7075 ] = "Hillsbrad Foothills",

    -- Felwood
    [ 7104 ] = "Felwood",
    [ 7137 ] = "Felwood",

    -- Loch Modan
    [ 7170 ] = "Loch Modan",

    -- The Barrens
    [ 7233 ] = "The Barrens",
    [ 7288 ] = "The Barrens",

    -- Blasted Lands
    [ 7665 ] = "Blasted Lands",
    [ 7666 ] = "Blasted Lands",
    [ 7667 ] = "Blasted Lands",
    [ 7728 ] = "Blasted Lands",

    -- Tanaris
    [ 7823 ] = "Tanaris",
    [ 7824 ] = "Tanaris",

    -- Blasted Lands
    [ 7851 ] = "Blasted Lands",

    -- Feralas
    [ 7875 ] = "Feralas",

    -- The Barrens
    [ 7895 ] = "The Barrens",

    -- The Hinterlands
    [ 7977 ] = "The Hinterlands",
    [ 7995 ] = "The Hinterlands",
    [ 7996 ] = "The Hinterlands",
    [ 8018 ] = "The Hinterlands",

    -- Feralas
    [ 8019 ] = "Feralas",
    [ 8020 ] = "Feralas",

    -- Tanaris
    [ 8196 ] = "Tanaris",
    [ 8197 ] = "Tanaris",
    [ 8198 ] = "Tanaris",
    [ 8199 ] = "Tanaris",

    -- The Hinterlands
    [ 8215 ] = "The Hinterlands",

    -- Searing Gorge
    [ 8282 ] = "Searing Gorge",
    [ 8400 ] = "Searing Gorge",
    [ 8447 ] = "Searing Gorge",
    [ 8479 ] = "Searing Gorge",
    [ 8504 ] = "Searing Gorge",

    -- Stonetalon Mountains
    [ 8518 ] = "Stonetalon Mountains",

    -- Blasted Lands
    [ 8609 ] = "Blasted Lands",

    -- Azshara
    [ 8610 ] = "Azshara",

    -- Blasted Lands
    [ 8716 ] = "Blasted Lands",
    [ 8717 ] = "Blasted Lands",
    [ 8718 ] = "Blasted Lands",

    -- Azshara
    [ 8756 ] = "Azshara",
    [ 8757 ] = "Azshara",
    [ 8758 ] = "Azshara",

    -- Burning Steppes
    [ 8976 ] = "Burning Steppes",

    -- Un'Goro Crater
    [ 9376 ] = "Un'Goro Crater",

    -- Burning Steppes
    [ 9459 ] = "Burning Steppes",

    -- Felwood
    [ 9516 ] = "Felwood",

    -- Burning Steppes
    [ 9520 ] = "Burning Steppes",
    [ 10119 ] = "Burning Steppes",

    -- Feralas
    [ 10182 ] = "Feralas",

    -- Winterspring
    [ 10196 ] = "Winterspring",
    [ 10198 ] = "Winterspring",
    [ 10201 ] = "Winterspring",
    [ 10202 ] = "Winterspring",

    -- Feralas
    [ 10204 ] = "Feralas",

    -- Dustwallow Marsh
    [ 10321 ] = "Dustwallow Marsh",

    -- Un'Goro Crater
    [ 10583 ] = "Un'Goro Crater",

    -- Winterspring
    [ 10662 ] = "Winterspring",
    [ 10663 ] = "Winterspring",
    [ 10664 ] = "Winterspring",
    [ 10738 ] = "Winterspring",
    [ 10806 ] = "Winterspring",
    [ 10807 ] = "Winterspring",

    -- Eastern Plaguelands
    [ 10828 ] = "Eastern Plaguelands",

    -- Moonglade
    [ 10897 ] = "Moonglade",

    -- Winterspring
    [ 10929 ] = "Winterspring",

    -- Thousand Needles
    [ 10992 ] = "Thousand Needles",

    -- Tirisfal Glades
    [ 11022 ] = "Tirisfal Glades",

    -- Western Plaguelands
    [ 11023 ] = "Western Plaguelands",

    -- Winterspring
    [ 11138 ] = "Winterspring",
    [ 11139 ] = "Winterspring",

    -- Moonglade
    [ 11832 ] = "Moonglade",

    -- Eastern Plaguelands
    [ 11878 ] = "Eastern Plaguelands",
    [ 11896 ] = "Eastern Plaguelands",
    [ 11897 ] = "Eastern Plaguelands",
    [ 11898 ] = "Eastern Plaguelands",

    -- Dustwallow Marsh
    [ 11899 ] = "Dustwallow Marsh",

    -- Felwood
    [ 11900 ] = "Felwood",

    -- Ashenvale
    [ 11901 ] = "Ashenvale",

    -- Stonetalon Mountains
    [ 11921 ] = "Stonetalon Mountains",

    -- Silverpine Forest
    [ 12123 ] = "Silverpine Forest",

    -- Eastern Plaguelands
    [ 12262 ] = "Eastern Plaguelands",
    [ 12263 ] = "Eastern Plaguelands",
    [ 12337 ] = "Eastern Plaguelands",

    -- Blasted Lands
    [ 12396 ] = "Blasted Lands",

    -- Western Plaguelands
    [ 12425 ] = "Western Plaguelands",

    -- The Hinterlands
    [ 12496 ] = "The Hinterlands",

    -- Feralas
    [ 12497 ] = "Feralas",

    -- Ashenvale
    [ 12498 ] = "Ashenvale",

    -- Azshara
    [ 12577 ] = "Azshara",

    -- Felwood
    [ 12578 ] = "Felwood",

    -- Stonetalon Mountains
    [ 12579 ] = "Stonetalon Mountains",

    -- Western Plaguelands
    [ 12596 ] = "Western Plaguelands",

    -- Ashenvale
    [ 12616 ] = "Ashenvale",

    -- Eastern Plaguelands
    [ 12617 ] = "Eastern Plaguelands",
    [ 12636 ] = "Eastern Plaguelands",

    -- Ashenvale
    [ 12737 ] = "Ashenvale",

    -- Moonglade
    [ 12740 ] = "Moonglade",

    -- Feralas
    [ 12801 ] = "Feralas",
    [ 12803 ] = "Feralas",

    -- Ashenvale
    [ 12836 ] = "Ashenvale",

    -- The Barrens
    [ 12865 ] = "The Barrens",

    -- Wetlands
    [ 12899 ] = "Wetlands",

    -- Swamp of Sorrows
    [ 12900 ] = "Swamp of Sorrows",

    -- Alterac Mountains
    [ 13085 ] = "Alterac Mountains",

    -- Eastern Plaguelands
    [ 13118 ] = "Eastern Plaguelands",

    -- Burning Steppes
    [ 13177 ] = "Burning Steppes",

    -- Alterac Mountains
    [ 13217 ] = "Alterac Mountains",
    [ 13219 ] = "Alterac Mountains",

    -- Azshara
    [ 13278 ] = "Azshara",

    -- Alterac Mountains
    [ 13602 ] = "Alterac Mountains",

    -- Desolace
    [ 13697 ] = "Desolace",
    [ 13718 ] = "Desolace",

    -- Alterac Mountains
    [ 13776 ] = "Alterac Mountains",
    [ 13777 ] = "Alterac Mountains",
    [ 13840 ] = "Alterac Mountains",
    [ 13841 ] = "Alterac Mountains",

    -- Azshara
    [ 13896 ] = "Azshara",

    -- Loch Modan
    [ 14267 ] = "Loch Modan",

    -- Hillsbrad Foothills
    [ 14275 ] = "Hillsbrad Foothills",

    -- Silithus
    [ 14347 ] = "Silithus",

    -- Winterspring
    [ 14348 ] = "Winterspring",

    -- Redridge Mountains
    [ 14357 ] = "Redridge Mountains",

    -- Elwynn Forest
    [ 14388 ] = "Elwynn Forest",

    -- Swamp of Sorrows
    [ 14445 ] = "Swamp of Sorrows",

    -- Silithus
    [ 14454 ] = "Silithus",

    -- Winterspring
    [ 14457 ] = "Winterspring",

    -- Un'Goro Crater
    [ 14461 ] = "Un'Goro Crater",

    -- Azshara
    [ 14464 ] = "Azshara",

    -- Felwood
    [ 14467 ] = "Felwood",

    -- Silithus
    [ 14471 ] = "Silithus",
    [ 14473 ] = "Silithus",
    [ 14474 ] = "Silithus",
    [ 14475 ] = "Silithus",

    -- Eastern Plaguelands
    [ 14494 ] = "Eastern Plaguelands",

    -- Un'Goro Crater
    [ 14527 ] = "Un'Goro Crater",

    -- Burning Steppes
    [ 14529 ] = "Burning Steppes",

    -- Winterspring
    [ 14531 ] = "Winterspring",

    -- Silithus
    [ 14536 ] = "Silithus",

    -- Searing Gorge
    [ 14621 ] = "Searing Gorge",

    -- Ashenvale
    [ 14715 ] = "Ashenvale",
    [ 14733 ] = "Ashenvale",
    [ 14753 ] = "Ashenvale",

    -- The Barrens
    [ 14754 ] = "The Barrens",
    [ 14781 ] = "The Barrens",

    -- Mulgore
    [ 14865 ] = "Mulgore",

    -- Stranglethorn Vale
    [ 14875 ] = "Stranglethorn Vale",
    [ 14904 ] = "Stranglethorn Vale",
    [ 14905 ] = "Stranglethorn Vale",
    [ 14910 ] = "Stranglethorn Vale",
    [ 14912 ] = "Stranglethorn Vale",
    [ 15070 ] = "Stranglethorn Vale",
    [ 15080 ] = "Stranglethorn Vale",

    -- Eastern Plaguelands
    [ 15162 ] = "Eastern Plaguelands",

    -- Silithus
    [ 15177 ] = "Silithus",
    [ 15178 ] = "Silithus",
    [ 15182 ] = "Silithus",
    [ 15196 ] = "Silithus",

    -- Hillsbrad Foothills
    [ 15199 ] = "Hillsbrad Foothills",

    -- Silithus
    [ 15443 ] = "Silithus",
    [ 15444 ] = "Silithus",
    [ 15500 ] = "Silithus",
    [ 15540 ] = "Silithus",
    [ 15541 ] = "Silithus",

    -- Dustwallow Marsh
    [ 15552 ] = "Dustwallow Marsh",
    [ 15591 ] = "Dustwallow Marsh",

    -- Silithus
    [ 15612 ] = "Silithus",
    [ 15613 ] = "Silithus",
    [ 15614 ] = "Silithus",
    [ 15615 ] = "Silithus",
    [ 15693 ] = "Silithus",
    [ 15903 ] = "Silithus",

    -- Dustwallow Marsh
    [ 16072 ] = "Dustwallow Marsh",

    -- Silithus
    [ 16091 ] = "Silithus",

    -- Stranglethorn Vale
    [ 16096 ] = "Stranglethorn Vale",

    -- Eastern Plaguelands
    [ 16112 ] = "Eastern Plaguelands",
    [ 16113 ] = "Eastern Plaguelands",
    [ 16114 ] = "Eastern Plaguelands",
    [ 16115 ] = "Eastern Plaguelands",
    [ 16116 ] = "Eastern Plaguelands",
    [ 16131 ] = "Eastern Plaguelands",
    [ 16132 ] = "Eastern Plaguelands",
    [ 16133 ] = "Eastern Plaguelands",
    [ 16134 ] = "Eastern Plaguelands",
    [ 16135 ] = "Eastern Plaguelands",
    [ 16184 ] = "Eastern Plaguelands",

    -- The Barrens
    [ 16227 ] = "The Barrens",

    -- Alterac Mountains
    [ 16392 ] = "Alterac Mountains",

    -- Silithus
    [ 17765 ] = "Silithus",
    [ 17766 ] = "Silithus",
}

local function LoadRares()
    local me = EbonSearch;
    me.NPCZones = rareZones;
    for id, name in pairs( rares ) do
        if not me.OptionsCharacter.NPCs[ id ] then
            me.NPCAdd( id, name );
        end
    end
end

-- [Ebonhold] v2.0.0: /reload path - PLAYER_LOGIN won't fire again when already logged in
if IsLoggedIn() then
    LoadRares();
else
    local frame = CreateFrame("Frame");
    frame:RegisterEvent("PLAYER_LOGIN");
    frame:SetScript("OnEvent", LoadRares);
end