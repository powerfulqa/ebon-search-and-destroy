local rares = {
    -- Eastern Kingdoms
    [ 14222 ] = "Araga", -- Alterac Mountains
    [ 16392 ] = "Captain Armando Ossex", -- Alterac Mountains
    [ 13776 ] = "Corporal Teeka Bloodsnarl", -- Alterac Mountains
    [ 14223 ] = "Cranky Benj", -- Alterac Mountains
    [ 3985 ] = "Grandpa Vishas", -- Alterac Mountains
    [ 14221 ] = "Gravis Slipknot", -- Alterac Mountains
    [ 13219 ] = "Jekyll Flandring", -- Alterac Mountains
    [ 14281 ] = "Jimmy the Bleeder", -- Alterac Mountains
    [ 13841 ] = "Lieutenant Haggerdin", -- Alterac Mountains
    [ 13085 ] = "Myrokos Silentform", -- Alterac Mountains
    [ 3984 ] = "Nancy Vishas", -- Alterac Mountains
    [ 2447 ] = "Narillasanz", -- Alterac Mountains
    [ 13777 ] = "Sergeant Durgen Stormpike", -- Alterac Mountains
    [ 2452 ] = "Skhowl", -- Alterac Mountains
    [ 2258 ] = "Stone Fury", -- Alterac Mountains
    [ 13217 ] = "Thanthaldis Snowgleam", -- Alterac Mountains
    [ 13602 ] = "The Abominable Greench", -- Alterac Mountains
    [ 13840 ] = "Warmaster Laggrond", -- Alterac Mountains
    [ 2609 ] = "Geomancer Flintdagger", -- Arathi Highlands
    [ 2779 ] = "Prince Nazjak", -- Arathi Highlands
    [ 2600 ] = "Singer", -- Arathi Highlands
    [ 2851 ] = "Urda", -- Arathi Highlands
    [ 14224 ] = "7:XT", -- Badlands
    [ 2745 ] = "Ambassador Infernus", -- Badlands
    [ 2754 ] = "Anathemus", -- Badlands
    [ 2753 ] = "Barnabus", -- Badlands
    [ 2850 ] = "Broken Tooth", -- Badlands
    [ 7057 ] = "Digmaster Shovelphlange", -- Badlands
    [ 2861 ] = "Gorrik", -- Badlands
    [ 2752 ] = "Rumbler", -- Badlands
    [ 2744 ] = "Shadowforge Commander", -- Badlands
    [ 2749 ] = "Siege Golem", -- Badlands
    [ 2751 ] = "War Golem", -- Badlands
    [ 2931 ] = "Zaricotl", -- Badlands
    [ 8298 ] = "Akubar the Seer", -- Blasted Lands
    [ 8609 ] = "Alexandra Constantine", -- Blasted Lands
    [ 7666 ] = "Archmage Allistarj", -- Blasted Lands
    [ 8301 ] = "Clack the Reaver", -- Blasted Lands
    [ 8302 ] = "Deatheye", -- Blasted Lands
    [ 12396 ] = "Doomguard Commander", -- Blasted Lands
    [ 8716 ] = "Dreadlord", -- Blasted Lands
    [ 8304 ] = "Dreadscorn", -- Blasted Lands
    [ 8717 ] = "Felguard Elite", -- Blasted Lands
    [ 7665 ] = "Grol the Destroyer", -- Blasted Lands
    [ 8303 ] = "Grunter", -- Blasted Lands
    [ 7667 ] = "Lady Sevine", -- Blasted Lands
    [ 8297 ] = "Magronos the Unyielding", -- Blasted Lands
    [ 8718 ] = "Manahound", -- Blasted Lands
    [ 8296 ] = "Mojo the Twisted", -- Blasted Lands
    [ 7851 ] = "Nethergarde Elite", -- Blasted Lands
    [ 8300 ] = "Ravage", -- Blasted Lands
    [ 8299 ] = "Spiteflayer", -- Blasted Lands
    [ 2299 ] = "Borgus Stoutarm", -- Burning Steppes
    [ 9459 ] = "Cyrus Therepentous", -- Burning Steppes
    [ 10077 ] = "Deathmaw", -- Burning Steppes
    [ 14529 ] = "Franklin the Friendly", -- Burning Steppes
    [ 9520 ] = "Grark Lorkrub", -- Burning Steppes
    [ 8979 ] = "Gruklash", -- Burning Steppes
    [ 8976 ] = "Hematos", -- Burning Steppes
    [ 8981 ] = "Malfunctioning Reaver", -- Burning Steppes
    [ 10078 ] = "Terrorspark", -- Burning Steppes
    [ 8978 ] = "Thauris Balgarr", -- Burning Steppes
    [ 13177 ] = "Vahgruk", -- Burning Steppes
    [ 10119 ] = "Volchan", -- Burning Steppes
    [ 1130 ] = "Bjarn", -- Dun Morogh
    [ 1137 ] = "Edan the Howler", -- Dun Morogh
    [ 8503 ] = "Gibblewilt", -- Dun Morogh
    [ 1260 ] = "Great Father Arctikus", -- Dun Morogh
    [ 1119 ] = "Hammerspine", -- Dun Morogh
    [ 1271 ] = "Old Icebeard", -- Dun Morogh
    [ 1132 ] = "Timber", -- Dun Morogh
    [ 771 ] = "Commander Felstrom", -- Duskwood
    [ 2409 ] = "Felicia Maline", -- Duskwood
    [ 507 ] = "Fenros", -- Duskwood
    [ 503 ] = "Lord Malathrom", -- Duskwood
    [ 521 ] = "Lupos", -- Duskwood
    [ 1200 ] = "Morbent Fel", -- Duskwood
    [ 574 ] = "Naraxis", -- Duskwood
    [ 534 ] = "Nefaru", -- Duskwood
    [ 16116 ] = "Archmage Angela Dosantos", -- Eastern Plaguelands
    [ 16115 ] = "Commander Eligor Dawnbringer", -- Eastern Plaguelands
    [ 13118 ] = "Crimson Bodyguard", -- Eastern Plaguelands
    [ 12337 ] = "Crimson Courier", -- Eastern Plaguelands
    [ 11898 ] = "Crusader Lord Valdelmar", -- Eastern Plaguelands
    [ 10827 ] = "Deathspeaker Selendre", -- Eastern Plaguelands
    [ 10817 ] = "Duggan Wildhammer", -- Eastern Plaguelands
    [ 10820 ] = "Duke Ragereaver", -- Eastern Plaguelands
    [ 14494 ] = "Eris Havenfire", -- Eastern Plaguelands
    [ 16113 ] = "Father Inigo Montoy", -- Eastern Plaguelands
    [ 12636 ] = "Georgia", -- Eastern Plaguelands
    [ 10825 ] = "Gish the Unmoving", -- Eastern Plaguelands
    [ 10828 ] = "High General Abbendis", -- Eastern Plaguelands
    [ 16132 ] = "Huntsman Leopold", -- Eastern Plaguelands
    [ 12617 ] = "Khaelyn Steelwing", -- Eastern Plaguelands
    [ 16112 ] = "Korfax, Champion of the Light", -- Eastern Plaguelands
    [ 10826 ] = "Lord Darkscythe", -- Eastern Plaguelands
    [ 16133 ] = "Mataus the Wrathcaster", -- Eastern Plaguelands
    [ 11878 ] = "Nathanos Blightcaller", -- Eastern Plaguelands
    [ 16184 ] = "Nerubian Overseer", -- Eastern Plaguelands
    [ 10824 ] = "Ranger Lord Hawkspear", -- Eastern Plaguelands
    [ 16135 ] = "Rayne", -- Eastern Plaguelands
    [ 16134 ] = "Rimblat Earthshatter", -- Eastern Plaguelands
    [ 16131 ] = "Rohan the Assassin", -- Eastern Plaguelands
    [ 16114 ] = "Scarlet Commander Marjhan", -- Eastern Plaguelands
    [ 15162 ] = "Scarlet Inquisitor", -- Eastern Plaguelands
    [ 1855 ] = "Tirion Fordring", -- Eastern Plaguelands
    [ 472 ] = "Fedfennel", -- Elwynn Forest
    [ 100 ] = "Gruff Swiftbite", -- Elwynn Forest
    [ 448 ] = "Hogger", -- Elwynn Forest
    [ 99 ] = "Morgaine the Sly", -- Elwynn Forest
    [ 471 ] = "Mother Fang", -- Elwynn Forest
    [ 79 ] = "Narg the Taskmaster", -- Elwynn Forest
    [ 61 ] = "Thuros Lightfingers", -- Elwynn Forest
    [ 14280 ] = "Big Samras", -- Hillsbrad Foothills
    [ 14279 ] = "Creepthess", -- Hillsbrad Foothills
    [ 2432 ] = "Darla Harris", -- Hillsbrad Foothills
    [ 2215 ] = "High Executor Darthalia", -- Hillsbrad Foothills
    [ 14277 ] = "Lady Zephris", -- Hillsbrad Foothills
    [ 2276 ] = "Magistrate Henry Maleb", -- Hillsbrad Foothills
    [ 14276 ] = "Scargil", -- Hillsbrad Foothills
    [ 14275 ] = "Tamra Stormpike", -- Hillsbrad Foothills
    [ 7075 ] = "Writhing Mage", -- Hillsbrad Foothills
    [ 2389 ] = "Zarise", -- Hillsbrad Foothills
    [ 1398 ] = "Boss Galgosh", -- Loch Modan
    [ 14267 ] = "Emogg the Crusher", -- Loch Modan
    [ 2477 ] = "Gradok", -- Loch Modan
    [ 1425 ] = "Grizlak", -- Loch Modan
    [ 2478 ] = "Haren Swifthoof", -- Loch Modan
    [ 2476 ] = "Large Loch Crocolisk", -- Loch Modan
    [ 14268 ] = "Lord Condar", -- Loch Modan
    [ 1399 ] = "Magosh", -- Loch Modan
    [ 14266 ] = "Shanda the Spinner", -- Loch Modan
    [ 1572 ] = "Thorgrum Borrelson", -- Loch Modan
    [ 7170 ] = "Thragomm", -- Loch Modan
    [ 7009 ] = "Arantir", -- Redridge Mountains
    [ 931 ] = "Ariena Stormfeather", -- Redridge Mountains
    [ 14273 ] = "Boulderheart", -- Redridge Mountains
    [ 616 ] = "Chatter", -- Redridge Mountains
    [ 349 ] = "Corporal Keeshan", -- Redridge Mountains
    [ 584 ] = "Kazon", -- Redridge Mountains
    [ 14357 ] = "Lake Thresher", -- Redridge Mountains
    [ 14271 ] = "Ribchaser", -- Redridge Mountains
    [ 947 ] = "Rohh the Silent", -- Redridge Mountains
    [ 14269 ] = "Seeker Aqualon", -- Redridge Mountains
    [ 335 ] = "Singe", -- Redridge Mountains
    [ 14272 ] = "Snarlflare", -- Redridge Mountains
    [ 14270 ] = "Squiddic", -- Redridge Mountains
    [ 8279 ] = "Faulty War Golem", -- Searing Gorge
    [ 3305 ] = "Grisha", -- Searing Gorge
    [ 8282 ] = "Highlord Mastrogonde", -- Searing Gorge
    [ 8479 ] = "Kalaran Windblade", -- Searing Gorge
    [ 2941 ] = "Lanie Reed", -- Searing Gorge
    [ 8281 ] = "Scald", -- Searing Gorge
    [ 8280 ] = "Shleipnarr", -- Searing Gorge
    [ 8283 ] = "Slave Master Blackheart", -- Searing Gorge
    [ 8278 ] = "Smoldar", -- Searing Gorge
    [ 1920 ] = "Dalaran Spellscribe", -- Silverpine Forest
    [ 12431 ] = "Gorefang", -- Silverpine Forest
    [ 2226 ] = "Karos Razok", -- Silverpine Forest
    [ 12433 ] = "Krethis Shadowspinner", -- Silverpine Forest
    [ 12432 ] = "Old Vicejaw", -- Silverpine Forest
    [ 12123 ] = "Reef Shark", -- Silverpine Forest
    [ 1944 ] = "Rot Hide Bruiser", -- Silverpine Forest
    [ 1948 ] = "Snarlmane", -- Silverpine Forest
    [ 2529 ] = "Son of Arugal", -- Silverpine Forest
    [ 3581 ] = "Sewer Beast", -- Stormwind City
    [ 14912 ] = "Captured Hakkari Zealot", -- Stranglethorn Vale
    [ 14910 ] = "Exzhal", -- Stranglethorn Vale
    [ 14905 ] = "Falthir the Sightless", -- Stranglethorn Vale
    [ 14487 ] = "Gluggle", -- Stranglethorn Vale
    [ 1492 ] = "Gorlash", -- Stranglethorn Vale
    [ 2858 ] = "Gringer", -- Stranglethorn Vale
    [ 2859 ] = "Gyll", -- Stranglethorn Vale
    [ 731 ] = "King Bangalash", -- Stranglethorn Vale
    [ 14491 ] = "Kurmokk", -- Stranglethorn Vale
    [ 469 ] = "Lieutenant Doren", -- Stranglethorn Vale
    [ 2541 ] = "Lord Sakrasis", -- Stranglethorn Vale
    [ 14904 ] = "Maywiki of Zuldazar", -- Stranglethorn Vale
    [ 1060 ] = "Mogh the Undying", -- Stranglethorn Vale
    [ 14875 ] = "Molthor", -- Stranglethorn Vale
    [ 14490 ] = "Rippa", -- Stranglethorn Vale
    [ 14488 ] = "Roloch", -- Stranglethorn Vale
    [ 1552 ] = "Scale Belly", -- Stranglethorn Vale
    [ 15080 ] = "Servant of the Hand", -- Stranglethorn Vale
    [ 16096 ] = "Steamwheedle Bruiser", -- Stranglethorn Vale
    [ 1387 ] = "Thysta", -- Stranglethorn Vale
    [ 14492 ] = "Verifonix", -- Stranglethorn Vale
    [ 15070 ] = "Vinchaxa", -- Stranglethorn Vale
    [ 6026 ] = "Breyk", -- Swamp of Sorrows
    [ 14446 ] = "Fingat", -- Swamp of Sorrows
    [ 14447 ] = "Gilmorian", -- Swamp of Sorrows
    [ 1063 ] = "Jade", -- Swamp of Sorrows
    [ 14445 ] = "Lord Captain Wyrmak", -- Swamp of Sorrows
    [ 763 ] = "Lost One Chieftain", -- Swamp of Sorrows
    [ 1106 ] = "Lost One Cook", -- Swamp of Sorrows
    [ 14448 ] = "Molt Thorn", -- Swamp of Sorrows
    [ 12900 ] = "Somnus", -- Swamp of Sorrows
    [ 12496 ] = "Dreamtracker", -- The Hinterlands
    [ 4314 ] = "Gorkas", -- The Hinterlands
    [ 8215 ] = "Grimungous", -- The Hinterlands
    [ 8018 ] = "Guthrum Thunderfist", -- The Hinterlands
    [ 8213 ] = "Ironback", -- The Hinterlands
    [ 8214 ] = "Jalinde Summerdrake", -- The Hinterlands
    [ 8211 ] = "Old Cliff Jumper", -- The Hinterlands
    [ 8210 ] = "Razortalon", -- The Hinterlands
    [ 8216 ] = "Retherokk the Berserker", -- The Hinterlands
    [ 5718 ] = "Rothos", -- The Hinterlands
    [ 8212 ] = "The Reak", -- The Hinterlands
    [ 8218 ] = "Witherheart the Stalker", -- The Hinterlands
    [ 11022 ] = "Alexi Barov", -- Tirisfal Glades
    [ 10356 ] = "Bayne", -- Tirisfal Glades
    [ 1911 ] = "Deeb", -- Tirisfal Glades
    [ 1936 ] = "Farmer Solliden", -- Tirisfal Glades
    [ 1531 ] = "Lost Soul", -- Tirisfal Glades
    [ 1910 ] = "Muad", -- Tirisfal Glades
    [ 10357 ] = "Ressan the Needler", -- Tirisfal Glades
    [ 1533 ] = "Tormented Spirit", -- Tirisfal Glades
    [ 1852 ] = "Araj the Summoner", -- Western Plaguelands
    [ 12596 ] = "Bibilfaz Featherwhistle", -- Western Plaguelands
    [ 1805 ] = "Flesh Golem", -- Western Plaguelands
    [ 12425 ] = "Flint Shadowmore", -- Western Plaguelands
    [ 1843 ] = "Foreman Jerris", -- Western Plaguelands
    [ 1844 ] = "Foreman Marcrid", -- Western Plaguelands
    [ 1847 ] = "Foulmane", -- Western Plaguelands
    [ 1846 ] = "High Protector Lorik", -- Western Plaguelands
    [ 1842 ] = "Highlord Taelan Fordring", -- Western Plaguelands
    [ 1848 ] = "Lord Maldazzar", -- Western Plaguelands
    [ 1850 ] = "Putridius", -- Western Plaguelands
    [ 1837 ] = "Scarlet Judge", -- Western Plaguelands
    [ 1885 ] = "Scarlet Smith", -- Western Plaguelands
    [ 1851 ] = "The Husk", -- Western Plaguelands
    [ 11023 ] = "Weldon Barov", -- Western Plaguelands
    [ 520 ] = "Brack", -- Westfall
    [ 573 ] = "Foe Reaper 4000", -- Westfall
    [ 572 ] = "Leprithus", -- Westfall
    [ 1424 ] = "Master Digger", -- Westfall
    [ 506 ] = "Sergeant Brashclaw", -- Westfall
    [ 519 ] = "Slark", -- Westfall
    [ 523 ] = "Thor", -- Westfall
    [ 462 ] = "Vultros", -- Westfall
    [ 12899 ] = "Axtroz", -- Wetlands
    [ 1037 ] = "Dragonmaw Battlemaster", -- Wetlands
    [ 2108 ] = "Garneg Charskull", -- Wetlands
    [ 14425 ] = "Gnawbone", -- Wetlands
    [ 1112 ] = "Leech Widow", -- Wetlands
    [ 14424 ] = "Mirelow", -- Wetlands
    [ 1140 ] = "Razormaw Matriarch", -- Wetlands
    [ 1571 ] = "Shellei Brondir", -- Wetlands
    [ 14433 ] = "Sludginn", -- Wetlands

    -- Kalimdor
    [ 3773 ] = "Akkrilus", -- Ashenvale
    [ 11901 ] = "Andruk", -- Ashenvale
    [ 3735 ] = "Apothecary Falthis", -- Ashenvale
    [ 10641 ] = "Branch Snapper", -- Ashenvale
    [ 4267 ] = "Daelyshia", -- Ashenvale
    [ 12498 ] = "Dreamstalker", -- Ashenvale
    [ 14753 ] = "Illiyana Moonblaze", -- Ashenvale
    [ 10559 ] = "Lady Vespia", -- Ashenvale
    [ 12737 ] = "Mastok Wrilehiss", -- Ashenvale
    [ 10644 ] = "Mist Howler", -- Ashenvale
    [ 10643 ] = "Mugglefin", -- Ashenvale
    [ 10640 ] = "Oakpaw", -- Ashenvale
    [ 5314 ] = "Phantim", -- Ashenvale
    [ 10647 ] = "Prince Raze", -- Ashenvale
    [ 3691 ] = "Raene Wolfrunner", -- Ashenvale
    [ 10639 ] = "Rorgish Jowl", -- Ashenvale
    [ 14733 ] = "Sentinel Farsong", -- Ashenvale
    [ 14715 ] = "Silverwing Elite", -- Ashenvale
    [ 3792 ] = "Terrowulf Packlord", -- Ashenvale
    [ 12616 ] = "Vhulgra", -- Ashenvale
    [ 12836 ] = "Wandering Protector", -- Ashenvale
    [ 6648 ] = "Antilos", -- Azshara
    [ 14464 ] = "Avalanchion", -- Azshara
    [ 193 ] = "Blue Dragonspawn", -- Azshara
    [ 13278 ] = "Duke Hydraxis", -- Azshara
    [ 6651 ] = "Gatekeeper Rageroar", -- Azshara
    [ 6650 ] = "General Fangferror", -- Azshara
    [ 12577 ] = "Jarrodenus", -- Azshara
    [ 8610 ] = "Kroum", -- Azshara
    [ 6649 ] = "Lady Sesspira", -- Azshara
    [ 6134 ] = "Lord Arkkoroc", -- Azshara
    [ 6647 ] = "Magister Hawkhelm", -- Azshara
    [ 6652 ] = "Master Feardred", -- Azshara
    [ 6646 ] = "Monnos the Elder", -- Azshara
    [ 8756 ] = "Raytaf", -- Azshara
    [ 13896 ] = "Scalebeard", -- Azshara
    [ 8757 ] = "Shahiar", -- Azshara
    [ 8660 ] = "The Evalcharr", -- Azshara
    [ 6118 ] = "Varo'then's Ghost", -- Azshara
    [ 8758 ] = "Zaman", -- Azshara
    [ 2186 ] = "Carnivous the Breaker", -- Darkshore
    [ 3841 ] = "Caylais Moonfeather", -- Darkshore
    [ 2192 ] = "Firecaller Radison", -- Darkshore
    [ 7015 ] = "Flagglemurk the Cruel", -- Darkshore
    [ 2184 ] = "Lady Moongazer", -- Darkshore
    [ 7016 ] = "Lady Vespira", -- Darkshore
    [ 2191 ] = "Licillin", -- Darkshore
    [ 7017 ] = "Lord Sinslayer", -- Darkshore
    [ 2175 ] = "Shadowclaw", -- Darkshore
    [ 2172 ] = "Strider Clutchmother", -- Darkshore
    [ 14229 ] = "Accursed Slitherblade", -- Desolace
    [ 6706 ] = "Baritanas Skyriver", -- Desolace
    [ 13697 ] = "Cavindra", -- Desolace
    [ 18241 ] = "Crusty", -- Desolace
    [ 11688 ] = "Cursed Centaur", -- Desolace
    [ 14228 ] = "Giggler", -- Desolace
    [ 14227 ] = "Hissperak", -- Desolace
    [ 14226 ] = "Kaskk", -- Desolace
    [ 5760 ] = "Lord Azrethoc", -- Desolace
    [ 14225 ] = "Prince Kellen", -- Desolace
    [ 10182 ] = "Rokaro", -- Desolace
    [ 6726 ] = "Thalon", -- Desolace
    [ 13718 ] = "The Nameless Prophet", -- Desolace
    [ 5824 ] = "Captain Flat Tusk", -- Durotar
    [ 5823 ] = "Death Flayer", -- Durotar
    [ 5822 ] = "Felweaver Scornn", -- Durotar
    [ 5826 ] = "Geolord Mottle", -- Durotar
    [ 5808 ] = "Warlord Kolkanis", -- Durotar
    [ 5809 ] = "Watch Commander Zalaphil", -- Durotar
    [ 4321 ] = "Baldruc", -- Dustwallow Marsh
    [ 4339 ] = "Brimgore", -- Dustwallow Marsh
    [ 14230 ] = "Burgle Eye", -- Dustwallow Marsh
    [ 4380 ] = "Darkmist Widow", -- Dustwallow Marsh
    [ 14232 ] = "Dart", -- Dustwallow Marsh
    [ 14231 ] = "Drogoth the Roamer", -- Dustwallow Marsh
    [ 10321 ] = "Emberstrife", -- Dustwallow Marsh
    [ 14234 ] = "Hayoc", -- Dustwallow Marsh
    [ 15591 ] = "Minion of Weavil", -- Dustwallow Marsh
    [ 11899 ] = "Shardi", -- Dustwallow Marsh
    [ 16072 ] = "Tidelord Rrurgaz", -- Dustwallow Marsh
    [ 14340 ] = "Alshirr Banebreath", -- Felwood
    [ 11900 ] = "Brakkar", -- Felwood
    [ 14339 ] = "Death Howl", -- Felwood
    [ 7104 ] = "Dessecus", -- Felwood
    [ 7137 ] = "Immolatus", -- Felwood
    [ 9516 ] = "Lord Banehollow", -- Felwood
    [ 12578 ] = "Mishellena", -- Felwood
    [ 14344 ] = "Mongress", -- Felwood
    [ 14343 ] = "Olm the Wise", -- Felwood
    [ 14342 ] = "Ragepaw", -- Felwood
    [ 14345 ] = "The Ongar", -- Felwood
    [ 5347 ] = "Antilus the Soarer", -- Feralas
    [ 5349 ] = "Arash-ethis", -- Feralas
    [ 12801 ] = "Arcane Chimaerok", -- Feralas
    [ 5346 ] = "Bloodroar the Stalker", -- Feralas
    [ 5345 ] = "Diamond Head", -- Feralas
    [ 12497 ] = "Dreamroarer", -- Feralas
    [ 8019 ] = "Fyldren Moonfeather", -- Feralas
    [ 5354 ] = "Gnarl Leafbrother", -- Feralas
    [ 7875 ] = "Hadoken Swiftstrider", -- Feralas
    [ 5343 ] = "Lady Szallah", -- Feralas
    [ 5357 ] = "Land Walker", -- Feralas
    [ 5312 ] = "Lethlas", -- Feralas
    [ 12803 ] = "Lord Lakmaeran", -- Feralas
    [ 5352 ] = "Old Grizzlegut", -- Feralas
    [ 5350 ] = "Qirot", -- Feralas
    [ 8020 ] = "Shyn", -- Feralas
    [ 5356 ] = "Snarler", -- Feralas
    [ 4319 ] = "Thyssiana", -- Feralas
    [ 12740 ] = "Faustron", -- Moonglade
    [ 11832 ] = "Keeper Remulos", -- Moonglade
    [ 10897 ] = "Sindrayl", -- Moonglade
    [ 5787 ] = "Enforcer Emilgund", -- Mulgore
    [ 3056 ] = "Ghost Howl", -- Mulgore
    [ 3068 ] = "Mazzranache", -- Mulgore
    [ 5785 ] = "Sister Hatelash", -- Mulgore
    [ 5786 ] = "Snagglespear", -- Mulgore
    [ 5807 ] = "The Rake", -- Mulgore
    [ 17765 ] = "Alliance Silithyst Sentinel", -- Silithus
    [ 15444 ] = "Arcanist Nozzlespring", -- Silithus
    [ 15177 ] = "Cloud Skydancer", -- Silithus
    [ 15196 ] = "Deathclasp", -- Silithus
    [ 16091 ] = "Dirk Thunderwood", -- Silithus
    [ 14472 ] = "Gretheer", -- Silithus
    [ 14477 ] = "Grubthor", -- Silithus
    [ 14347 ] = "Highlord Demitrian", -- Silithus
    [ 17766 ] = "Horde Silithyst Sentinel", -- Silithus
    [ 14478 ] = "Huricanian", -- Silithus
    [ 15614 ] = "J.D. Shadesong", -- Silithus
    [ 15443 ] = "Janela Stouthammer", -- Silithus
    [ 15693 ] = "Jonathan the Revelator", -- Silithus
    [ 15500 ] = "Keyl Swiftclaw", -- Silithus
    [ 14476 ] = "Krellack", -- Silithus
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
    [ 14479 ] = "Twilight Lord Everun", -- Silithus
    [ 15541 ] = "Twilight Marauder Morna", -- Silithus
    [ 15182 ] = "Vish Kozus", -- Silithus
    [ 15540 ] = "Windcaller Kaldon", -- Silithus
    [ 14474 ] = "Zora", -- Silithus
    [ 5931 ] = "Foreman Rigger", -- Stonetalon Mountains
    [ 4015 ] = "Pridewing Patriarch", -- Stonetalon Mountains
    [ 5930 ] = "Sister Riven", -- Stonetalon Mountains
    [ 5928 ] = "Sorrow Wing", -- Stonetalon Mountains
    [ 5932 ] = "Taskmaster Whipfang", -- Stonetalon Mountains
    [ 4407 ] = "Teloren", -- Stonetalon Mountains
    [ 4312 ] = "Tharm", -- Stonetalon Mountains
    [ 4030 ] = "Vengeful Ancient", -- Stonetalon Mountains
    [ 7823 ] = "Bera Stonehammer", -- Tanaris
    [ 7824 ] = "Bulkrek Ragefist", -- Tanaris
    [ 8197 ] = "Chronalis", -- Tanaris
    [ 8202 ] = "Cyclok the Mad", -- Tanaris
    [ 5469 ] = "Dune Smasher", -- Tanaris
    [ 5432 ] = "Giant Surf Glider", -- Tanaris
    [ 8207 ] = "Greater Firebird", -- Tanaris
    [ 8205 ] = "Haarka the Ravenous", -- Tanaris
    [ 8203 ] = "Kregg Keelhaul", -- Tanaris
    [ 8208 ] = "Murderous Blisterpaw", -- Tanaris
    [ 8196 ] = "Occulus", -- Tanaris
    [ 8201 ] = "Omgorn the Lost", -- Tanaris
    [ 8204 ] = "Soriid the Devourer", -- Tanaris
    [ 8198 ] = "Tick", -- Tanaris
    [ 8199 ] = "Warleader Krazzilak", -- Tanaris
    [ 3535 ] = "Blackmoss the Fetid", -- Teldrassil
    [ 14430 ] = "Duskstalker", -- Teldrassil
    [ 14431 ] = "Fury Shelda", -- Teldrassil
    [ 14429 ] = "Grimmaw", -- Teldrassil
    [ 14432 ] = "Threggil", -- Teldrassil
    [ 14428 ] = "Uruson", -- Teldrassil
    [ 3838 ] = "Vesprystus", -- Teldrassil
    [ 7895 ] = "Ambassador Bloodrage", -- The Barrens
    [ 5834 ] = "Azzere the Skyblade", -- The Barrens
    [ 3672 ] = "Boahn", -- The Barrens
    [ 16227 ] = "Bragok", -- The Barrens
    [ 5838 ] = "Brokespear", -- The Barrens
    [ 5827 ] = "Brontus", -- The Barrens
    [ 5851 ] = "Captain Gerogg Hammertoe", -- The Barrens
    [ 14781 ] = "Captain Shatterskull", -- The Barrens
    [ 3615 ] = "Devrak", -- The Barrens
    [ 5849 ] = "Digger Flameforge", -- The Barrens
    [ 5865 ] = "Dishu", -- The Barrens
    [ 3270 ] = "Elder Mystic Razorsnout", -- The Barrens
    [ 5836 ] = "Engineer Whirleygig", -- The Barrens
    [ 5835 ] = "Foreman Grills", -- The Barrens
    [ 3398 ] = "Gesharahan", -- The Barrens
    [ 7288 ] = "Grand Foreman Puzik Gallywix", -- The Barrens
    [ 5859 ] = "Hagg Taurenbane", -- The Barrens
    [ 5847 ] = "Heggin Stonewhisker", -- The Barrens
    [ 5828 ] = "Humar the Pridelord", -- The Barrens
    [ 14754 ] = "Kelm Hargunth", -- The Barrens
    [ 5848 ] = "Malgin Barleybrew", -- The Barrens
    [ 3470 ] = "Rathorian", -- The Barrens
    [ 5841 ] = "Rocklance", -- The Barrens
    [ 3253 ] = "Silithid Harvester", -- The Barrens
    [ 5830 ] = "Sister Rathtalon", -- The Barrens
    [ 3295 ] = "Sludge Beast", -- The Barrens
    [ 5829 ] = "Snort the Heckler", -- The Barrens
    [ 5837 ] = "Stonearm", -- The Barrens
    [ 5831 ] = "Swiftmane", -- The Barrens
    [ 5864 ] = "Swinegart Spearhide", -- The Barrens
    [ 5842 ] = "Takk the Leaper", -- The Barrens
    [ 7233 ] = "Taskmaster Fizzule", -- The Barrens
    [ 5832 ] = "Thunderstomp", -- The Barrens
    [ 5933 ] = "Achellios the Banished", -- Thousand Needles
    [ 10992 ] = "Enraged Panther", -- Thousand Needles
    [ 14427 ] = "Gibblesnik", -- Thousand Needles
    [ 14426 ] = "Harb Foulmountain", -- Thousand Needles
    [ 5934 ] = "Heartrazor", -- Thousand Needles
    [ 5935 ] = "Ironeye the Invincible", -- Thousand Needles
    [ 4317 ] = "Nyse", -- Thousand Needles
    [ 4132 ] = "Silithid Ravager", -- Thousand Needles
    [ 5937 ] = "Vile Sting", -- Thousand Needles
    [ 14461 ] = "Baron Charr", -- Un'Goro Crater
    [ 9376 ] = "Blazerunner", -- Un'Goro Crater
    [ 6582 ] = "Clutchmother Zavas", -- Un'Goro Crater
    [ 6583 ] = "Gruff", -- Un'Goro Crater
    [ 10583 ] = "Gryfe", -- Un'Goro Crater
    [ 6584 ] = "King Mosh", -- Un'Goro Crater
    [ 6581 ] = "Ravasaur Matriarch", -- Un'Goro Crater
    [ 14527 ] = "Simone the Inconspicuous", -- Un'Goro Crater
    [ 6560 ] = "Stone Guardian", -- Un'Goro Crater
    [ 6500 ] = "Tyrant Devilsaur", -- Un'Goro Crater
    [ 14531 ] = "Artorius the Amiable", -- Winterspring
    [ 10202 ] = "Azurous", -- Winterspring
    [ 14348 ] = "Earthcaller Franzahl", -- Winterspring
    [ 10196 ] = "General Colbatann", -- Winterspring
    [ 10199 ] = "Grizzle Snowpaw", -- Winterspring
    [ 10929 ] = "Haleh", -- Winterspring
    [ 10198 ] = "Kashoch the Reaver", -- Winterspring
    [ 10201 ] = "Lady Hederine", -- Winterspring
    [ 11138 ] = "Maethrya", -- Winterspring
    [ 10663 ] = "Manaclaw", -- Winterspring
    [ 10197 ] = "Mezzir the Howler", -- Winterspring
    [ 14457 ] = "Princess Tempestria", -- Winterspring
    [ 10664 ] = "Scryer", -- Winterspring
    [ 10662 ] = "Spellmaw", -- Winterspring
    [ 11139 ] = "Yugrek", -- Winterspring

    -- Outland & Northrend
    [ 18692 ] = "Hemathion", -- Blade's Edge Mountains
    [ 10204 ] = "Misha", -- Blade's Edge Mountains
    [ 18690 ] = "Morcrush", -- Blade's Edge Mountains
    [ 22060 ] = "Fenissa the Assassin", -- Bloodmyst Isle
    [ 32358 ] = "Fumblub Gearwind", -- Borean Tundra
    [ 32361 ] = "Icehorn", -- Borean Tundra
    [ 32357 ] = "Old Crystalbark", -- Borean Tundra
    [ 32435 ] = "Vern", -- Dalaran
    [ 32417 ] = "Scarlet Highlord Daion", -- Dragonblight
    [ 32400 ] = "Tukemuth", -- Dragonblight
    [ 38453 ] = "Arcturis", -- Grizzly Hills
    [ 32422 ] = "Grocklar", -- Grizzly Hills
    [ 32429 ] = "Seething Hate", -- Grizzly Hills
    [ 32438 ] = "Syreian the Bonecarver", -- Grizzly Hills
    [ 18677 ] = "Mekthorg the Wild", -- Hellfire Peninsula
    [ 32495 ] = "Hildana Deathstealer", -- Icecrown
    [ 32487 ] = "Putridus the Ancient", -- Icecrown
    [ 20932 ] = "Nuramoc", -- Netherstorm
    [ 18694 ] = "Collidus the Warp-Watcher", -- Shadowmoon Valley
    [ 18686 ] = "Doomsayer Jurim", -- Shadowmoon Valley
    [ 18696 ] = "Kraator", -- Shadowmoon Valley
    [ 14865 ] = "Felinni", -- Terokkar Forest
    [ 18685 ] = "Okrek", -- Terokkar Forest
    [ 35189 ] = "Skoll", -- The Storm Peaks
    [ 18682 ] = "Bog Lurker", -- Zangarmarsh
    [ 18681 ] = "Coilfang Emissary", -- Zangarmarsh
    [ 18680 ] = "Marticar", -- Zangarmarsh
    [ 33776 ] = "Gondria", -- Zul'Drak

}

local rareZones = {
    -- Alterac Mountains
    [ 14222 ] = "Alterac Mountains",
    [ 16392 ] = "Alterac Mountains",
    [ 13776 ] = "Alterac Mountains",
    [ 14223 ] = "Alterac Mountains",
    [ 3985 ] = "Alterac Mountains",
    [ 14221 ] = "Alterac Mountains",
    [ 13219 ] = "Alterac Mountains",
    [ 14281 ] = "Alterac Mountains",
    [ 13841 ] = "Alterac Mountains",
    [ 13085 ] = "Alterac Mountains",
    [ 3984 ] = "Alterac Mountains",
    [ 2447 ] = "Alterac Mountains",
    [ 13777 ] = "Alterac Mountains",
    [ 2452 ] = "Alterac Mountains",
    [ 2258 ] = "Alterac Mountains",
    [ 13217 ] = "Alterac Mountains",
    [ 13602 ] = "Alterac Mountains",
    [ 13840 ] = "Alterac Mountains",

    -- Arathi Highlands
    [ 2609 ] = "Arathi Highlands",
    [ 2779 ] = "Arathi Highlands",
    [ 2600 ] = "Arathi Highlands",
    [ 2851 ] = "Arathi Highlands",

    -- Ashenvale
    [ 3773 ] = "Ashenvale",
    [ 11901 ] = "Ashenvale",
    [ 3735 ] = "Ashenvale",
    [ 10641 ] = "Ashenvale",
    [ 4267 ] = "Ashenvale",
    [ 12498 ] = "Ashenvale",
    [ 14753 ] = "Ashenvale",
    [ 10559 ] = "Ashenvale",
    [ 12737 ] = "Ashenvale",
    [ 10644 ] = "Ashenvale",
    [ 10643 ] = "Ashenvale",
    [ 10640 ] = "Ashenvale",
    [ 5314 ] = "Ashenvale",
    [ 10647 ] = "Ashenvale",
    [ 3691 ] = "Ashenvale",
    [ 10639 ] = "Ashenvale",
    [ 14733 ] = "Ashenvale",
    [ 14715 ] = "Ashenvale",
    [ 3792 ] = "Ashenvale",
    [ 12616 ] = "Ashenvale",
    [ 12836 ] = "Ashenvale",

    -- Azshara
    [ 6648 ] = "Azshara",
    [ 14464 ] = "Azshara",
    [ 193 ] = "Azshara",
    [ 13278 ] = "Azshara",
    [ 6651 ] = "Azshara",
    [ 6650 ] = "Azshara",
    [ 12577 ] = "Azshara",
    [ 8610 ] = "Azshara",
    [ 6649 ] = "Azshara",
    [ 6134 ] = "Azshara",
    [ 6647 ] = "Azshara",
    [ 6652 ] = "Azshara",
    [ 6646 ] = "Azshara",
    [ 8756 ] = "Azshara",
    [ 13896 ] = "Azshara",
    [ 8757 ] = "Azshara",
    [ 8660 ] = "Azshara",
    [ 6118 ] = "Azshara",
    [ 8758 ] = "Azshara",

    -- Badlands
    [ 14224 ] = "Badlands",
    [ 2745 ] = "Badlands",
    [ 2754 ] = "Badlands",
    [ 2753 ] = "Badlands",
    [ 2850 ] = "Badlands",
    [ 7057 ] = "Badlands",
    [ 2861 ] = "Badlands",
    [ 2752 ] = "Badlands",
    [ 2744 ] = "Badlands",
    [ 2749 ] = "Badlands",
    [ 2751 ] = "Badlands",
    [ 2931 ] = "Badlands",

    -- Blade's Edge Mountains
    [ 18692 ] = "Blade's Edge Mountains",
    [ 10204 ] = "Blade's Edge Mountains",
    [ 18690 ] = "Blade's Edge Mountains",

    -- Blasted Lands
    [ 8298 ] = "Blasted Lands",
    [ 8609 ] = "Blasted Lands",
    [ 7666 ] = "Blasted Lands",
    [ 8301 ] = "Blasted Lands",
    [ 8302 ] = "Blasted Lands",
    [ 12396 ] = "Blasted Lands",
    [ 8716 ] = "Blasted Lands",
    [ 8304 ] = "Blasted Lands",
    [ 8717 ] = "Blasted Lands",
    [ 7665 ] = "Blasted Lands",
    [ 8303 ] = "Blasted Lands",
    [ 7667 ] = "Blasted Lands",
    [ 8297 ] = "Blasted Lands",
    [ 8718 ] = "Blasted Lands",
    [ 8296 ] = "Blasted Lands",
    [ 7851 ] = "Blasted Lands",
    [ 8300 ] = "Blasted Lands",
    [ 8299 ] = "Blasted Lands",

    -- Bloodmyst Isle
    [ 22060 ] = "Bloodmyst Isle",

    -- Borean Tundra
    [ 32358 ] = "Borean Tundra",
    [ 32361 ] = "Borean Tundra",
    [ 32357 ] = "Borean Tundra",

    -- Burning Steppes
    [ 2299 ] = "Burning Steppes",
    [ 9459 ] = "Burning Steppes",
    [ 10077 ] = "Burning Steppes",
    [ 14529 ] = "Burning Steppes",
    [ 9520 ] = "Burning Steppes",
    [ 8979 ] = "Burning Steppes",
    [ 8976 ] = "Burning Steppes",
    [ 8981 ] = "Burning Steppes",
    [ 10078 ] = "Burning Steppes",
    [ 8978 ] = "Burning Steppes",
    [ 13177 ] = "Burning Steppes",
    [ 10119 ] = "Burning Steppes",

    -- Dalaran
    [ 32435 ] = "Dalaran",

    -- Darkshore
    [ 2186 ] = "Darkshore",
    [ 3841 ] = "Darkshore",
    [ 2192 ] = "Darkshore",
    [ 7015 ] = "Darkshore",
    [ 2184 ] = "Darkshore",
    [ 7016 ] = "Darkshore",
    [ 2191 ] = "Darkshore",
    [ 7017 ] = "Darkshore",
    [ 2175 ] = "Darkshore",
    [ 2172 ] = "Darkshore",

    -- Desolace
    [ 14229 ] = "Desolace",
    [ 6706 ] = "Desolace",
    [ 13697 ] = "Desolace",
    [ 18241 ] = "Desolace",
    [ 11688 ] = "Desolace",
    [ 14228 ] = "Desolace",
    [ 14227 ] = "Desolace",
    [ 14226 ] = "Desolace",
    [ 5760 ] = "Desolace",
    [ 14225 ] = "Desolace",
    [ 10182 ] = "Desolace",
    [ 6726 ] = "Desolace",
    [ 13718 ] = "Desolace",

    -- Dragonblight
    [ 32417 ] = "Dragonblight",
    [ 32400 ] = "Dragonblight",

    -- Dun Morogh
    [ 1130 ] = "Dun Morogh",
    [ 1137 ] = "Dun Morogh",
    [ 8503 ] = "Dun Morogh",
    [ 1260 ] = "Dun Morogh",
    [ 1119 ] = "Dun Morogh",
    [ 1271 ] = "Dun Morogh",
    [ 1132 ] = "Dun Morogh",

    -- Durotar
    [ 5824 ] = "Durotar",
    [ 5823 ] = "Durotar",
    [ 5822 ] = "Durotar",
    [ 5826 ] = "Durotar",
    [ 5808 ] = "Durotar",
    [ 5809 ] = "Durotar",

    -- Duskwood
    [ 771 ] = "Duskwood",
    [ 2409 ] = "Duskwood",
    [ 507 ] = "Duskwood",
    [ 503 ] = "Duskwood",
    [ 521 ] = "Duskwood",
    [ 1200 ] = "Duskwood",
    [ 574 ] = "Duskwood",
    [ 534 ] = "Duskwood",

    -- Dustwallow Marsh
    [ 4321 ] = "Dustwallow Marsh",
    [ 4339 ] = "Dustwallow Marsh",
    [ 14230 ] = "Dustwallow Marsh",
    [ 4380 ] = "Dustwallow Marsh",
    [ 14232 ] = "Dustwallow Marsh",
    [ 14231 ] = "Dustwallow Marsh",
    [ 10321 ] = "Dustwallow Marsh",
    [ 14234 ] = "Dustwallow Marsh",
    [ 15591 ] = "Dustwallow Marsh",
    [ 11899 ] = "Dustwallow Marsh",
    [ 16072 ] = "Dustwallow Marsh",

    -- Eastern Plaguelands
    [ 16116 ] = "Eastern Plaguelands",
    [ 16115 ] = "Eastern Plaguelands",
    [ 13118 ] = "Eastern Plaguelands",
    [ 12337 ] = "Eastern Plaguelands",
    [ 11898 ] = "Eastern Plaguelands",
    [ 10827 ] = "Eastern Plaguelands",
    [ 10817 ] = "Eastern Plaguelands",
    [ 10820 ] = "Eastern Plaguelands",
    [ 14494 ] = "Eastern Plaguelands",
    [ 16113 ] = "Eastern Plaguelands",
    [ 12636 ] = "Eastern Plaguelands",
    [ 10825 ] = "Eastern Plaguelands",
    [ 10828 ] = "Eastern Plaguelands",
    [ 16132 ] = "Eastern Plaguelands",
    [ 12617 ] = "Eastern Plaguelands",
    [ 16112 ] = "Eastern Plaguelands",
    [ 10826 ] = "Eastern Plaguelands",
    [ 16133 ] = "Eastern Plaguelands",
    [ 11878 ] = "Eastern Plaguelands",
    [ 16184 ] = "Eastern Plaguelands",
    [ 10824 ] = "Eastern Plaguelands",
    [ 16135 ] = "Eastern Plaguelands",
    [ 16134 ] = "Eastern Plaguelands",
    [ 16131 ] = "Eastern Plaguelands",
    [ 16114 ] = "Eastern Plaguelands",
    [ 15162 ] = "Eastern Plaguelands",
    [ 1855 ] = "Eastern Plaguelands",

    -- Elwynn Forest
    [ 472 ] = "Elwynn Forest",
    [ 100 ] = "Elwynn Forest",
    [ 448 ] = "Elwynn Forest",
    [ 99 ] = "Elwynn Forest",
    [ 471 ] = "Elwynn Forest",
    [ 79 ] = "Elwynn Forest",
    [ 61 ] = "Elwynn Forest",

    -- Felwood
    [ 14340 ] = "Felwood",
    [ 11900 ] = "Felwood",
    [ 14339 ] = "Felwood",
    [ 7104 ] = "Felwood",
    [ 7137 ] = "Felwood",
    [ 9516 ] = "Felwood",
    [ 12578 ] = "Felwood",
    [ 14344 ] = "Felwood",
    [ 14343 ] = "Felwood",
    [ 14342 ] = "Felwood",
    [ 14345 ] = "Felwood",

    -- Feralas
    [ 5347 ] = "Feralas",
    [ 5349 ] = "Feralas",
    [ 12801 ] = "Feralas",
    [ 5346 ] = "Feralas",
    [ 5345 ] = "Feralas",
    [ 12497 ] = "Feralas",
    [ 8019 ] = "Feralas",
    [ 5354 ] = "Feralas",
    [ 7875 ] = "Feralas",
    [ 5343 ] = "Feralas",
    [ 5357 ] = "Feralas",
    [ 5312 ] = "Feralas",
    [ 12803 ] = "Feralas",
    [ 5352 ] = "Feralas",
    [ 5350 ] = "Feralas",
    [ 8020 ] = "Feralas",
    [ 5356 ] = "Feralas",
    [ 4319 ] = "Feralas",

    -- Grizzly Hills
    [ 38453 ] = "Grizzly Hills",
    [ 32422 ] = "Grizzly Hills",
    [ 32429 ] = "Grizzly Hills",
    [ 32438 ] = "Grizzly Hills",

    -- Hellfire Peninsula
    [ 18677 ] = "Hellfire Peninsula",

    -- Hillsbrad Foothills
    [ 14280 ] = "Hillsbrad Foothills",
    [ 14279 ] = "Hillsbrad Foothills",
    [ 2432 ] = "Hillsbrad Foothills",
    [ 2215 ] = "Hillsbrad Foothills",
    [ 14277 ] = "Hillsbrad Foothills",
    [ 2276 ] = "Hillsbrad Foothills",
    [ 14276 ] = "Hillsbrad Foothills",
    [ 14275 ] = "Hillsbrad Foothills",
    [ 7075 ] = "Hillsbrad Foothills",
    [ 2389 ] = "Hillsbrad Foothills",

    -- Icecrown
    [ 32495 ] = "Icecrown",
    [ 32487 ] = "Icecrown",

    -- Loch Modan
    [ 1398 ] = "Loch Modan",
    [ 14267 ] = "Loch Modan",
    [ 2477 ] = "Loch Modan",
    [ 1425 ] = "Loch Modan",
    [ 2478 ] = "Loch Modan",
    [ 2476 ] = "Loch Modan",
    [ 14268 ] = "Loch Modan",
    [ 1399 ] = "Loch Modan",
    [ 14266 ] = "Loch Modan",
    [ 1572 ] = "Loch Modan",
    [ 7170 ] = "Loch Modan",

    -- Moonglade
    [ 12740 ] = "Moonglade",
    [ 11832 ] = "Moonglade",
    [ 10897 ] = "Moonglade",

    -- Mulgore
    [ 5787 ] = "Mulgore",
    [ 3056 ] = "Mulgore",
    [ 3068 ] = "Mulgore",
    [ 5785 ] = "Mulgore",
    [ 5786 ] = "Mulgore",
    [ 5807 ] = "Mulgore",

    -- Netherstorm
    [ 20932 ] = "Netherstorm",

    -- Redridge Mountains
    [ 7009 ] = "Redridge Mountains",
    [ 931 ] = "Redridge Mountains",
    [ 14273 ] = "Redridge Mountains",
    [ 616 ] = "Redridge Mountains",
    [ 349 ] = "Redridge Mountains",
    [ 584 ] = "Redridge Mountains",
    [ 14357 ] = "Redridge Mountains",
    [ 14271 ] = "Redridge Mountains",
    [ 947 ] = "Redridge Mountains",
    [ 14269 ] = "Redridge Mountains",
    [ 335 ] = "Redridge Mountains",
    [ 14272 ] = "Redridge Mountains",
    [ 14270 ] = "Redridge Mountains",

    -- Searing Gorge
    [ 8279 ] = "Searing Gorge",
    [ 3305 ] = "Searing Gorge",
    [ 8282 ] = "Searing Gorge",
    [ 8479 ] = "Searing Gorge",
    [ 2941 ] = "Searing Gorge",
    [ 8281 ] = "Searing Gorge",
    [ 8280 ] = "Searing Gorge",
    [ 8283 ] = "Searing Gorge",
    [ 8278 ] = "Searing Gorge",

    -- Shadowmoon Valley
    [ 18694 ] = "Shadowmoon Valley",
    [ 18686 ] = "Shadowmoon Valley",
    [ 18696 ] = "Shadowmoon Valley",

    -- Silithus
    [ 17765 ] = "Silithus",
    [ 15444 ] = "Silithus",
    [ 15177 ] = "Silithus",
    [ 15196 ] = "Silithus",
    [ 16091 ] = "Silithus",
    [ 14472 ] = "Silithus",
    [ 14477 ] = "Silithus",
    [ 14347 ] = "Silithus",
    [ 17766 ] = "Silithus",
    [ 14478 ] = "Silithus",
    [ 15614 ] = "Silithus",
    [ 15443 ] = "Silithus",
    [ 15693 ] = "Silithus",
    [ 15500 ] = "Silithus",
    [ 14476 ] = "Silithus",
    [ 15612 ] = "Silithus",
    [ 14473 ] = "Silithus",
    [ 15613 ] = "Silithus",
    [ 14536 ] = "Silithus",
    [ 14475 ] = "Silithus",
    [ 15178 ] = "Silithus",
    [ 15903 ] = "Silithus",
    [ 14471 ] = "Silithus",
    [ 15615 ] = "Silithus",
    [ 14454 ] = "Silithus",
    [ 14479 ] = "Silithus",
    [ 15541 ] = "Silithus",
    [ 15182 ] = "Silithus",
    [ 15540 ] = "Silithus",
    [ 14474 ] = "Silithus",

    -- Silverpine Forest
    [ 1920 ] = "Silverpine Forest",
    [ 12431 ] = "Silverpine Forest",
    [ 2226 ] = "Silverpine Forest",
    [ 12433 ] = "Silverpine Forest",
    [ 12432 ] = "Silverpine Forest",
    [ 12123 ] = "Silverpine Forest",
    [ 1944 ] = "Silverpine Forest",
    [ 1948 ] = "Silverpine Forest",
    [ 2529 ] = "Silverpine Forest",

    -- Stonetalon Mountains
    [ 5931 ] = "Stonetalon Mountains",
    [ 4015 ] = "Stonetalon Mountains",
    [ 5930 ] = "Stonetalon Mountains",
    [ 5928 ] = "Stonetalon Mountains",
    [ 5932 ] = "Stonetalon Mountains",
    [ 4407 ] = "Stonetalon Mountains",
    [ 4312 ] = "Stonetalon Mountains",
    [ 4030 ] = "Stonetalon Mountains",

    -- Stormwind City
    [ 3581 ] = "Stormwind City",

    -- Stranglethorn Vale
    [ 14912 ] = "Stranglethorn Vale",
    [ 14910 ] = "Stranglethorn Vale",
    [ 14905 ] = "Stranglethorn Vale",
    [ 14487 ] = "Stranglethorn Vale",
    [ 1492 ] = "Stranglethorn Vale",
    [ 2858 ] = "Stranglethorn Vale",
    [ 2859 ] = "Stranglethorn Vale",
    [ 731 ] = "Stranglethorn Vale",
    [ 14491 ] = "Stranglethorn Vale",
    [ 469 ] = "Stranglethorn Vale",
    [ 2541 ] = "Stranglethorn Vale",
    [ 14904 ] = "Stranglethorn Vale",
    [ 1060 ] = "Stranglethorn Vale",
    [ 14875 ] = "Stranglethorn Vale",
    [ 14490 ] = "Stranglethorn Vale",
    [ 14488 ] = "Stranglethorn Vale",
    [ 1552 ] = "Stranglethorn Vale",
    [ 15080 ] = "Stranglethorn Vale",
    [ 16096 ] = "Stranglethorn Vale",
    [ 1387 ] = "Stranglethorn Vale",
    [ 14492 ] = "Stranglethorn Vale",
    [ 15070 ] = "Stranglethorn Vale",

    -- Swamp of Sorrows
    [ 6026 ] = "Swamp of Sorrows",
    [ 14446 ] = "Swamp of Sorrows",
    [ 14447 ] = "Swamp of Sorrows",
    [ 1063 ] = "Swamp of Sorrows",
    [ 14445 ] = "Swamp of Sorrows",
    [ 763 ] = "Swamp of Sorrows",
    [ 1106 ] = "Swamp of Sorrows",
    [ 14448 ] = "Swamp of Sorrows",
    [ 12900 ] = "Swamp of Sorrows",

    -- Tanaris
    [ 7823 ] = "Tanaris",
    [ 7824 ] = "Tanaris",
    [ 8197 ] = "Tanaris",
    [ 8202 ] = "Tanaris",
    [ 5469 ] = "Tanaris",
    [ 5432 ] = "Tanaris",
    [ 8207 ] = "Tanaris",
    [ 8205 ] = "Tanaris",
    [ 8203 ] = "Tanaris",
    [ 8208 ] = "Tanaris",
    [ 8196 ] = "Tanaris",
    [ 8201 ] = "Tanaris",
    [ 8204 ] = "Tanaris",
    [ 8198 ] = "Tanaris",
    [ 8199 ] = "Tanaris",

    -- Teldrassil
    [ 3535 ] = "Teldrassil",
    [ 14430 ] = "Teldrassil",
    [ 14431 ] = "Teldrassil",
    [ 14429 ] = "Teldrassil",
    [ 14432 ] = "Teldrassil",
    [ 14428 ] = "Teldrassil",
    [ 3838 ] = "Teldrassil",

    -- Terokkar Forest
    [ 14865 ] = "Terokkar Forest",
    [ 18685 ] = "Terokkar Forest",

    -- The Barrens
    [ 7895 ] = "The Barrens",
    [ 5834 ] = "The Barrens",
    [ 3672 ] = "The Barrens",
    [ 16227 ] = "The Barrens",
    [ 5838 ] = "The Barrens",
    [ 5827 ] = "The Barrens",
    [ 5851 ] = "The Barrens",
    [ 14781 ] = "The Barrens",
    [ 3615 ] = "The Barrens",
    [ 5849 ] = "The Barrens",
    [ 5865 ] = "The Barrens",
    [ 3270 ] = "The Barrens",
    [ 5836 ] = "The Barrens",
    [ 5835 ] = "The Barrens",
    [ 3398 ] = "The Barrens",
    [ 7288 ] = "The Barrens",
    [ 5859 ] = "The Barrens",
    [ 5847 ] = "The Barrens",
    [ 5828 ] = "The Barrens",
    [ 14754 ] = "The Barrens",
    [ 5848 ] = "The Barrens",
    [ 3470 ] = "The Barrens",
    [ 5841 ] = "The Barrens",
    [ 3253 ] = "The Barrens",
    [ 5830 ] = "The Barrens",
    [ 3295 ] = "The Barrens",
    [ 5829 ] = "The Barrens",
    [ 5837 ] = "The Barrens",
    [ 5831 ] = "The Barrens",
    [ 5864 ] = "The Barrens",
    [ 5842 ] = "The Barrens",
    [ 7233 ] = "The Barrens",
    [ 5832 ] = "The Barrens",

    -- The Hinterlands
    [ 12496 ] = "The Hinterlands",
    [ 4314 ] = "The Hinterlands",
    [ 8215 ] = "The Hinterlands",
    [ 8018 ] = "The Hinterlands",
    [ 8213 ] = "The Hinterlands",
    [ 8214 ] = "The Hinterlands",
    [ 8211 ] = "The Hinterlands",
    [ 8210 ] = "The Hinterlands",
    [ 8216 ] = "The Hinterlands",
    [ 5718 ] = "The Hinterlands",
    [ 8212 ] = "The Hinterlands",
    [ 8218 ] = "The Hinterlands",

    -- The Storm Peaks
    [ 35189 ] = "The Storm Peaks",

    -- Thousand Needles
    [ 5933 ] = "Thousand Needles",
    [ 10992 ] = "Thousand Needles",
    [ 14427 ] = "Thousand Needles",
    [ 14426 ] = "Thousand Needles",
    [ 5934 ] = "Thousand Needles",
    [ 5935 ] = "Thousand Needles",
    [ 4317 ] = "Thousand Needles",
    [ 4132 ] = "Thousand Needles",
    [ 5937 ] = "Thousand Needles",

    -- Tirisfal Glades
    [ 11022 ] = "Tirisfal Glades",
    [ 10356 ] = "Tirisfal Glades",
    [ 1911 ] = "Tirisfal Glades",
    [ 1936 ] = "Tirisfal Glades",
    [ 1531 ] = "Tirisfal Glades",
    [ 1910 ] = "Tirisfal Glades",
    [ 10357 ] = "Tirisfal Glades",
    [ 1533 ] = "Tirisfal Glades",

    -- Un'Goro Crater
    [ 14461 ] = "Un'Goro Crater",
    [ 9376 ] = "Un'Goro Crater",
    [ 6582 ] = "Un'Goro Crater",
    [ 6583 ] = "Un'Goro Crater",
    [ 10583 ] = "Un'Goro Crater",
    [ 6584 ] = "Un'Goro Crater",
    [ 6581 ] = "Un'Goro Crater",
    [ 14527 ] = "Un'Goro Crater",
    [ 6560 ] = "Un'Goro Crater",
    [ 6500 ] = "Un'Goro Crater",

    -- Western Plaguelands
    [ 1852 ] = "Western Plaguelands",
    [ 12596 ] = "Western Plaguelands",
    [ 1805 ] = "Western Plaguelands",
    [ 12425 ] = "Western Plaguelands",
    [ 1843 ] = "Western Plaguelands",
    [ 1844 ] = "Western Plaguelands",
    [ 1847 ] = "Western Plaguelands",
    [ 1846 ] = "Western Plaguelands",
    [ 1842 ] = "Western Plaguelands",
    [ 1848 ] = "Western Plaguelands",
    [ 1850 ] = "Western Plaguelands",
    [ 1837 ] = "Western Plaguelands",
    [ 1885 ] = "Western Plaguelands",
    [ 1851 ] = "Western Plaguelands",
    [ 11023 ] = "Western Plaguelands",

    -- Westfall
    [ 520 ] = "Westfall",
    [ 573 ] = "Westfall",
    [ 572 ] = "Westfall",
    [ 1424 ] = "Westfall",
    [ 506 ] = "Westfall",
    [ 519 ] = "Westfall",
    [ 523 ] = "Westfall",
    [ 462 ] = "Westfall",

    -- Wetlands
    [ 12899 ] = "Wetlands",
    [ 1037 ] = "Wetlands",
    [ 2108 ] = "Wetlands",
    [ 14425 ] = "Wetlands",
    [ 1112 ] = "Wetlands",
    [ 14424 ] = "Wetlands",
    [ 1140 ] = "Wetlands",
    [ 1571 ] = "Wetlands",
    [ 14433 ] = "Wetlands",

    -- Winterspring
    [ 14531 ] = "Winterspring",
    [ 10202 ] = "Winterspring",
    [ 14348 ] = "Winterspring",
    [ 10196 ] = "Winterspring",
    [ 10199 ] = "Winterspring",
    [ 10929 ] = "Winterspring",
    [ 10198 ] = "Winterspring",
    [ 10201 ] = "Winterspring",
    [ 11138 ] = "Winterspring",
    [ 10663 ] = "Winterspring",
    [ 10197 ] = "Winterspring",
    [ 14457 ] = "Winterspring",
    [ 10664 ] = "Winterspring",
    [ 10662 ] = "Winterspring",
    [ 11139 ] = "Winterspring",

    -- Zangarmarsh
    [ 18682 ] = "Zangarmarsh",
    [ 18681 ] = "Zangarmarsh",
    [ 18680 ] = "Zangarmarsh",

    -- Zul'Drak
    [ 33776 ] = "Zul'Drak",
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