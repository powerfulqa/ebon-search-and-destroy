$ErrorActionPreference='Stop'

# NPC data sourced from Questie-X (Xurkon's WotLK + Ebonhold forks of Questie).
# Files are fetched fresh and not committed to this repo.
#
# Source URLs:
#   WotLK NPC DB         : Xurkon/Questie-X-WotLKDB    (Database/Wotlk/wotlkNpcDB.lua)
#   WotLK NPC corrections: Xurkon/Questie-X-WotLKDB    (Database/Corrections/wotlkNPCFixes.lua)
#   Ebonhold NPC DB      : Xurkon/Questie-X-EbonholdDB (Ebonhold/EbonholdNpcDB.lua)
#   Ebonhold Quest DB    : Xurkon/Questie-X-EbonholdDB (Ebonhold/EbonholdQuestDB.lua)
#
# Schema (from QuestieDB.npcKeys at top of wotlkNpcDB.lua, zero-indexed by Split-TopLevel):
#   f[0]=name, f[1]=minLevelHealth, f[2]=maxLevelHealth, f[3]=minLevel, f[4]=maxLevel,
#   f[5]=rank, f[6]=spawns, f[7]=waypoints, f[8]=zoneID, f[9]=questStarts, ...
#
# rank values (cmangos): 0=normal, 1=elite, 2=rareelite, 3=worldboss, 4=rare.
# Existing strategy kept: extract rank in {1,2}, then apply manualExcludeRaw and zone filters.

$tmpWotlkNpcPath    = Join-Path $PSScriptRoot 'tmp_wotlkNpcDB.lua'
$tmpWotlkFixesPath  = Join-Path $PSScriptRoot 'tmp_wotlkNPCFixes.lua'
$tmpEbonholdNpcPath = Join-Path $PSScriptRoot 'tmp_EbonholdNpcDB.lua'
$tmpEbonholdQuestPath = Join-Path $PSScriptRoot 'tmp_EbonholdQuestDB.lua'

Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Xurkon/Questie-X-WotLKDB/refs/heads/main/Database/Wotlk/wotlkNpcDB.lua' -OutFile $tmpWotlkNpcPath
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Xurkon/Questie-X-WotLKDB/refs/heads/main/Database/Corrections/wotlkNPCFixes.lua' -OutFile $tmpWotlkFixesPath
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Xurkon/Questie-X-EbonholdDB/refs/heads/main/Ebonhold/EbonholdNpcDB.lua' -OutFile $tmpEbonholdNpcPath
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Xurkon/Questie-X-EbonholdDB/refs/heads/main/Ebonhold/EbonholdQuestDB.lua' -OutFile $tmpEbonholdQuestPath

# Curation whitelist: read the previously-committed generated rare list from git HEAD
# and harvest its NPC IDs. These are rares the addon has historically tracked. The
# rank filter below uses this set to preserve curation: rank=1 entries from upstream
# Questie are only accepted when they were already on the curated list, so we get
# fresh rank=2/4 additions without losing established rank=1 community-rares (which
# upstream tags inconsistently between rank=1 'elite' and rank=2 'rare elite').
$repoRoot = Split-Path $PSScriptRoot -Parent
$rank1Whitelist = New-Object 'System.Collections.Generic.HashSet[int]'
$gitHead = & git -C $repoRoot show 'HEAD:EbonSearch/generated_npcscan_rare_tables.lua' 2>$null
if($LASTEXITCODE -eq 0 -and $gitHead){
  $headText = ($gitHead -join "`n")
  $raresMatch = [regex]::Match($headText, '(?ms)^local rares = \{(.+?)^\}')
  if($raresMatch.Success){
    foreach($lm in [regex]::Matches($raresMatch.Groups[1].Value, '\[\s*(\d+)\s*\]\s*=\s*"')){
      [void]$rank1Whitelist.Add([int]$lm.Groups[1].Value)
    }
  }
}

# Splits a Lua table body on top-level commas, respecting strings and braces.
function Split-TopLevel([string]$s){
  $parts = New-Object System.Collections.Generic.List[string]
  $sb = New-Object System.Text.StringBuilder
  $curly=0; $inS=$false; $inD=$false
  for($i=0;$i -lt $s.Length;$i++){
    $c=$s[$i]
    if($c -eq "'" -and -not $inD){ $inS = -not $inS; [void]$sb.Append($c); continue }
    if($c -eq '"' -and -not $inS){ $inD = -not $inD; [void]$sb.Append($c); continue }
    if(-not $inS -and -not $inD){
      if($c -eq '{'){ $curly++ }
      elseif($c -eq '}'){ $curly-- }
      elseif($c -eq ',' -and $curly -eq 0){ $parts.Add($sb.ToString().Trim()); $sb.Clear() | Out-Null; continue }
    }
    [void]$sb.Append($c)
  }
  $tail=$sb.ToString().Trim(); if($tail.Length -gt 0){ $parts.Add($tail) }
  return ,$parts.ToArray()
}

# Walks a full text from $openIdx (which must point at '{') and returns the index of the matching '}'.
# Returns -1 if unmatched. Honors single/double-quoted strings and Lua-style backslash escapes.
function Find-MatchingBrace([string]$text, [int]$openIdx){
  $depth = 0
  $inS = $false; $inD = $false; $esc = $false
  for($i = $openIdx; $i -lt $text.Length; $i++){
    $c = $text[$i]
    if($esc){ $esc = $false; continue }
    if($c -eq '\' -and ($inS -or $inD)){ $esc = $true; continue }
    if($c -eq "'" -and -not $inD){ $inS = -not $inS; continue }
    if($c -eq '"' -and -not $inS){ $inD = -not $inD; continue }
    if($inS -or $inD){ continue }
    if($c -eq '{'){ $depth++ }
    elseif($c -eq '}'){
      $depth--
      if($depth -eq 0){ return $i }
    }
  }
  return -1
}

$zoneMap=@{}
function AddZone([int]$id,[string]$name,[int]$world,[bool]$outdoor,[string]$expansion){
  $zoneMap[$id]=[pscustomobject]@{ Name=$name; World=$world; Outdoor=$outdoor; Expansion=$expansion }
}

# Classic Eastern Kingdoms / Kalimdor (outdoor + cities)
$classicEk = @(
  @(1,"Dun Morogh",2,$true),@(3,"Badlands",2,$true),@(4,"Blasted Lands",2,$true),@(8,"Swamp of Sorrows",2,$true),@(10,"Duskwood",2,$true),@(11,"Wetlands",2,$true),
  @(12,"Elwynn Forest",2,$true),@(28,"Western Plaguelands",2,$true),@(33,"Stranglethorn Vale",2,$true),@(36,"Alterac Mountains",2,$true),
  @(38,"Loch Modan",2,$true),@(40,"Westfall",2,$true),@(41,"Deadwind Pass",2,$true),@(44,"Redridge Mountains",2,$true),@(45,"Arathi Highlands",2,$true),
  @(46,"Burning Steppes",2,$true),@(47,"The Hinterlands",2,$true),@(51,"Searing Gorge",2,$true),@(85,"Tirisfal Glades",2,$true),@(130,"Silverpine Forest",2,$true),
  @(139,"Eastern Plaguelands",2,$true),@(267,"Hillsbrad Foothills",2,$true),@(1497,"Undercity",2,$true),@(1519,"Stormwind City",2,$true),@(1537,"Ironforge",2,$true),
  @(2257,"Deeprun Tram",2,$true),@(2597,"Alterac Valley",2,$false)
)
$classicKal = @(
  @(7,"Durotar",1,$true),@(14,"Durotar",1,$true),@(15,"Dustwallow Marsh",1,$true),@(16,"Azshara",1,$true),@(17,"The Barrens",1,$true),
  @(141,"Teldrassil",1,$true),@(148,"Darkshore",1,$true),@(215,"Mulgore",1,$true),@(331,"Ashenvale",1,$true),@(357,"Feralas",1,$true),
  @(361,"Felwood",1,$true),@(405,"Desolace",1,$true),@(406,"Stonetalon Mountains",1,$true),@(440,"Tanaris",1,$true),@(490,"Un'Goro Crater",1,$true),
  @(493,"Moonglade",1,$true),@(618,"Winterspring",1,$true),@(1377,"Silithus",1,$true),@(1637,"Orgrimmar",1,$true),@(1638,"Thunder Bluff",1,$true),
  @(1657,"Darnassus",1,$true),@(3277,"Warsong Gulch",1,$false),@(400,"Thousand Needles",1,$true)
)

# Classic instances (drop)
$classicInstances = @(
  @(1581,"The Deadmines",2),@(1583,"Blackrock Spire",2),@(1584,"Blackrock Depths",2),@(1585,"Blackrock Mountain",2),@(1477,"The Temple of Atal'Hakkar",2),
  @(1337,"Uldaman",2),@(722,"Razorfen Downs",1),@(491,"Razorfen Kraul",1),@(796,"Scarlet Monastery",2),@(717,"The Stockade",2),
  @(719,"Blackfathom Deeps",1),@(721,"Gnomeregan",2),@(1176,"Zul'Farrak",1),@(2017,"Stratholme",2),@(2057,"Scholomance",2),
  @(209,"Shadowfang Keep",2),@(718,"Wailing Caverns",1),@(1977,"Zul'Gurub",2),@(2100,"Maraudon",1),@(2159,"Onyxia's Lair",1),
  @(2437,"Ragefire Chasm",1),@(2557,"Dire Maul",1),@(2677,"Blackwing Lair",2),@(2717,"Molten Core",2),@(3428,"Ahn'Qiraj",1),
  @(3429,"Ruins of Ahn'Qiraj",1),@(3456,"Naxxramas",2)
)

# Outland and Northrend outdoor zones (now legitimately included from wotlkNpcDB).
$outlandOutdoor = @(
  @(3483,"Hellfire Peninsula"),@(3518,"Nagrand"),@(3519,"Terokkar Forest"),@(3520,"Shadowmoon Valley"),@(3521,"Zangarmarsh"),@(3522,"Blade's Edge Mountains"),
  @(3523,"Netherstorm"),@(3524,"Azuremyst Isle"),@(3525,"Bloodmyst Isle"),@(3703,"Shattrath City")
)
$northrendOutdoor = @(
  @(65,"Dragonblight"),@(66,"Zul'Drak"),@(67,"The Storm Peaks"),@(210,"Icecrown"),@(3537,"Borean Tundra"),@(394,"Grizzly Hills"),
  @(495,"Howling Fjord"),@(3711,"Sholazar Basin"),@(4264,"Hrothgar's Landing"),@(4265,"Crystalsong Forest"),@(4395,"Dalaran")
)

foreach($z in $classicEk){ AddZone ([int]$z[0]) ([string]$z[1]) ([int]$z[2]) ([bool]$z[3]) 'Classic' }
foreach($z in $classicKal){ AddZone ([int]$z[0]) ([string]$z[1]) ([int]$z[2]) ([bool]$z[3]) 'Classic' }
foreach($z in $classicInstances){ AddZone ([int]$z[0]) ([string]$z[1]) ([int]$z[2]) $false 'Classic' }
foreach($z in $outlandOutdoor){ AddZone ([int]$z[0]) ([string]$z[1]) 0 $true 'Outland' }
foreach($z in $northrendOutdoor){ AddZone ([int]$z[0]) ([string]$z[1]) 0 $true 'Northrend' }

# Manual exclusions: NPC IDs that should never end up in the rare table even if upstream
# tags them rank 1/2. Add new known false-positives here as they surface in the diff.
# Numbers can be separated by commas, whitespace, or newlines - all numeric tokens are
# extracted via regex below, so trailing commas are not required.
$manualExcludeIDs = New-Object 'System.Collections.Generic.HashSet[int]'
$manualExcludeRaw = @'
2571, 2569, 2570, 2738, 2584, 2583, 2585, 2590, 2591, 2588,
2256, 2255, 2254, 2416, 2287,
2643, 2646, 2641, 2644, 2681, 2645, 2642, 2647, 4465,
12477, 12478, 12479, 12474, 12476, 12475, 5320, 5317, 5319,
2738, 2584, 2583, 2585,
3528, 1895, 3532, 1894, 3530, 1891,
3630, 3631, 3632, 3633, 3634, 3641,
2344, 2345, 2346,
7068, 7069, 7070, 7071, 7072,
4280, 4281, 4282, 4283, 4284, 4285,
1836, 1838, 1839, 1841, 1832, 1834, 10608, 1827,
9451, 9449, 9450, 9452, 9448, 9447,
11102, 16378, 11885,
619, 594, 1726, 1725,
1054, 1051, 6523, 1052, 1053,
1045, 1046, 1047, 1048, 1049, 1050,
7040, 7041, 7042, 7043, 7044, 7045, 7046,
6208, 6209, 6210, 6213,
4464, 4462, 4064, 4065, 436,
5860, 5861, 5862, 8419,
15308,
14285, 14284, 15126, 15127, 15128, 15130,
11440, 11442, 11443,
7873, 6132, 7874,
4394, 4374, 4368, 4366, 4371, 4370, 4364,
7461, 7462, 7463,
7437, 7436, 7435,
11777, 11778, 11781, 11782, 11785, 11786, 11787, 11788,
4686, 4687, 5466, 5467, 5358, 5360, 5359, 5361,
12239, 12240, 12241,
5646, 5647, 5645,
4788, 4789, 4803, 4802,
6129, 6131, 6130, 6144, 6143,
6146, 6147, 6148,
13322,
4050, 4052, 4061, 4056, 15184, 15185,
15609, 15610, 15611, 15442, 15617, 15616,
15804, 15805, 15769, 15770, 15771,
5915, 5916,
7135, 7136,
6498, 6499, 6502, 6503, 6504, 6501,
877, 879, 873, 875, 871,
11355, 11346,
13084, 15446, 11865, 15431, 15432, 857, 15701, 15539, 12197, 1573, 15457, 15453, 14982, 15450, 15437, 15707, 15452, 15434, 15448, 15456, 15451, 15445, 15383, 15455, 14365, 14363, 14367,
352, 14981, 14721, 466, 15008, 14394, 15708, 8383, 14439, 14423, 14438, 7410, 11867,
15512, 15533, 3890, 15535, 15458, 15006, 15525, 3310, 16788, 11871, 15460, 15528, 15477, 14720, 14942, 15529, 15459, 14392, 11868, 14376, 14375, 14377, 15522, 15515, 15532, 15700,
11870, 347, 2804, 4551, 13839, 14402, 14403, 14404, 15703, 15007,
11869, 16818, 14441, 14440, 14442, 10360, 12198, 15702, 7427, 2995,
2302, 5118, 5782, 14380, 14379, 14378, 11866, 907, 15709,
32398, 32377, 32386
4846, 4845, 4844, 4856, 4851,
6733, 2892,
14390, 14393,
14911, 14876, 15076,
596, 623, 624, 625, 234,
3338, 5797, 5799, 5800, 5798, 10378, 14717,
15961, 16817, 16818, 14823, 15197, 15195,
5186, 5185, 5435, 5434, 12125, 12124,
7428, 7429,
12800, 12802
'@
foreach($m in [regex]::Matches($manualExcludeRaw,'\d+')){ [void]$manualExcludeIDs.Add([int]$m.Value) }

# Parses any Questie-style NPC DB. Handles both `_d[id] = {...}` (WotLK) and `[id] = {...}`
# (Ebonhold) prefixes. Tolerates multi-line entries via brace-balanced matching.
# $acceptRanks selects which cmangos rank values to keep:
#   wotlkNpcDB     -> @(2, 4)   = rare elite + rare (rank 1 is too noisy on its own)
#   EbonholdNpcDB  -> @(1, 2)   = trust Ebonhold curation; their custom rares can be either
# $rank1Whitelist (optional): NPC IDs that should also be accepted at rank=1. Used to
# preserve previously-curated rares that upstream tags as rank=1 elite (e.g. Emberstrife,
# Spellmaw, many Outland/Northrend community rares).
function ParseNpcDb([string]$path,[string]$source,[int[]]$acceptRanks,[System.Collections.Generic.HashSet[int]]$rank1Whitelist){
  $items=@{}
  $text = Get-Content $path -Raw
  $regex = [regex]'(?m)^\s*(?:_d)?\[(\d+)\]\s*=\s*\{'
  foreach($m in $regex.Matches($text)){
    $id = [int]$m.Groups[1].Value
    $openIdx = $m.Index + $m.Length - 1   # position of '{'
    $closeIdx = Find-MatchingBrace $text $openIdx
    if($closeIdx -lt 0){ continue }
    $inside = $text.Substring($openIdx + 1, $closeIdx - $openIdx - 1)
    $f = Split-TopLevel $inside
    if($f.Count -lt 9){ continue }

    $name = $f[0].Trim()
    if($name.Length -ge 2 -and $name.StartsWith("'") -and $name.EndsWith("'")){
      $name = $name.Substring(1, $name.Length - 2)
    } elseif($name.Length -ge 2 -and $name.StartsWith('"') -and $name.EndsWith('"')){
      $name = $name.Substring(1, $name.Length - 2)
    }
    $name = $name -replace "\\'","'"
    if($name -eq 'nil' -or $name.Length -eq 0){ continue }

    $rank = 0; [void][int]::TryParse($f[5].Trim(), [ref]$rank)
    $spawns = $f[6].Trim()
    $zoneRaw = $f[8].Trim()
    if($spawns -eq 'nil'){ continue }

    $accept = $acceptRanks -contains $rank
    if(-not $accept -and $rank -eq 1 -and $rank1Whitelist -and $rank1Whitelist.Contains($id)){
      $accept = $true
    }
    if(-not $accept){ continue }

    $spawnZone = $null
    $mz = [regex]::Match($spawns, '\[(\d+)\]')
    if($mz.Success){ $spawnZone = [int]$mz.Groups[1].Value }
    $zid = $null; $tmp = 0
    if([int]::TryParse($zoneRaw, [ref]$tmp)){ $zid = $tmp }
    $items[$id] = [pscustomobject]@{ Id = $id; Name = $name; SpawnZone = $spawnZone; ZoneID = $zid; Source = $source }
  }
  return $items
}

# Returns id -> rank for every NPC entry in the DB (regardless of whether rank is 1/2).
# Used to enforce "Ebonhold rank wins" - if Ebonhold DB classifies an ID as non-rare, it
# is dropped from the merged set even when the WotLK DB called it rank 1/2.
function ParseNpcRanks([string]$path){
  $ranks=@{}
  $text = Get-Content $path -Raw
  $regex = [regex]'(?m)^\s*(?:_d)?\[(\d+)\]\s*=\s*\{'
  foreach($m in $regex.Matches($text)){
    $id = [int]$m.Groups[1].Value
    $openIdx = $m.Index + $m.Length - 1
    $closeIdx = Find-MatchingBrace $text $openIdx
    if($closeIdx -lt 0){ continue }
    $inside = $text.Substring($openIdx + 1, $closeIdx - $openIdx - 1)
    $f = Split-TopLevel $inside
    if($f.Count -ge 6){
      $rank = 0
      [void][int]::TryParse($f[5].Trim(), [ref]$rank)
      $ranks[$id] = $rank
    }
  }
  return $ranks
}

# Walks the Ebonhold quest DB looking for "Kill N rare" / "Rare slain" / "rare in"
# objectives, and returns the set of NPC IDs referenced from those objectives that are
# also in $rankRareIDs. Brace-balanced so it tolerates nested objective tables.
function ParseQuestRareIds([string]$path,[System.Collections.Generic.HashSet[int]]$rankRareIDs){
  $questIds = New-Object 'System.Collections.Generic.HashSet[int]'
  $text = Get-Content $path -Raw
  $regex = [regex]'\[(\d+)\]\s*=\s*\{'
  foreach($m in $regex.Matches($text)){
    $openIdx = $m.Index + $m.Length - 1
    $closeIdx = Find-MatchingBrace $text $openIdx
    if($closeIdx -lt $openIdx){ continue }
    $body = $text.Substring($openIdx + 1, $closeIdx - $openIdx - 1)
    if($body -match '(?i)Kill\s+\d+\s+Rare|Rare slain|rare in '){
      $listMatches = [regex]::Matches($body,'\{\s*((?:\d+\s*,\s*)+\d+)\s*\}')
      foreach($lm in $listMatches){
        $numMatches = [regex]::Matches($lm.Groups[1].Value,'\d+')
        if($numMatches.Count -ge 2){
          foreach($nm in $numMatches){
            $n = [int]$nm.Value
            if($rankRareIDs.Contains($n)){ [void]$questIds.Add($n) }
          }
        }
      }
    }
  }
  return $questIds
}

$wotlk    = ParseNpcDb $tmpWotlkNpcPath 'wotlk' @(2, 4) $rank1Whitelist
$ebon     = ParseNpcDb $tmpEbonholdNpcPath 'ebonhold' @(1, 2) $null
$ebonRanks = ParseNpcRanks $tmpEbonholdNpcPath

# Merge wotlk first, then let ebonhold overlay (Ebonhold-tagged data wins).
$merged=@{}
foreach($k in $wotlk.Keys){ $merged[$k]=$wotlk[$k] }
foreach($k in $ebon.Keys ){ $merged[$k]=$ebon[$k]  }

# Pool of every ID that came in at rank 1/2 from either DB (used by quest filter).
$rankRareIDs = New-Object 'System.Collections.Generic.HashSet[int]'
foreach($k in $wotlk.Keys){ [void]$rankRareIDs.Add([int]$k) }
foreach($k in $ebon.Keys ){ [void]$rankRareIDs.Add([int]$k) }

# Pull in IDs referenced by Ebonhold "Kill 1 Rare in <zone>" quests, even if they're
# only present in one DB. The IDs must already be rank 1/2 somewhere (rankRareIDs).
$questIds = ParseQuestRareIds $tmpEbonholdQuestPath $rankRareIDs
foreach($qid in $questIds){
  if(-not $merged.ContainsKey($qid)){
    if($ebon.ContainsKey($qid)){ $merged[$qid]=$ebon[$qid] }
    elseif($wotlk.ContainsKey($qid)){ $merged[$qid]=$wotlk[$qid] }
  }
}

# Manual exclusions (early pass).
foreach($x in $manualExcludeIDs){
  if($merged.ContainsKey([int]$x)){ $merged.Remove([int]$x) | Out-Null }
  if($merged.ContainsKey([string]$x)){ $merged.Remove([string]$x) | Out-Null }
}

# Ebonhold rank wins for inclusion criteria when ID exists in Ebonhold DB.
foreach($id in @($merged.Keys)){
  if($ebonRanks.ContainsKey([int]$id)){
    $r=[int]$ebonRanks[[int]$id]
    if($r -ne 1 -and $r -ne 2){
      $merged.Remove([int]$id) | Out-Null
    }
  }
}

$ebonIDs = New-Object 'System.Collections.Generic.HashSet[int]'
foreach($k in $ebon.Keys){ [void]$ebonIDs.Add([int]$k) }

$final=@{}
foreach($id in $merged.Keys){
  $e=$merged[$id]
  if($manualExcludeIDs.Contains([int]$id)){ continue }
  $zone = if($e.SpawnZone){ [int]$e.SpawnZone } elseif($e.ZoneID){ [int]$e.ZoneID } else { 0 }
  $resolved = $null
  if($zoneMap.ContainsKey($zone)){ $resolved = $zoneMap[$zone] }

  # Default-deny on zone resolution. Drops NPCs whose primary spawn zone isn't in
  # our explicit map (catches every TBC/WotLK instance + sub-zone that would have
  # leaked through as 'Zone NNNN' before). Ebonhold-tagged NPCs are exempt - we
  # trust Ebonhold curation, even when the zone isn't in our outdoor table.
  if(-not $ebonIDs.Contains([int]$id)){
    if(-not $resolved){ continue }            # unmapped zone (TBC/WotLK instance, sub-zone)
    if(-not $resolved.Outdoor){ continue }    # known indoor zone (Classic instances)
  }

  $world = if($resolved){ [int]$resolved.World } else { 0 }
  $zname = if($resolved){ [string]$resolved.Name } else { "Zone $zone" }
  $final[$id]=[pscustomobject]@{ Id=[int]$id; Name=$e.Name; ZoneName=$zname; World=$world }
}

# Final safety pass: ensure manual exclusions are removed regardless of earlier merges.
foreach($x in $manualExcludeIDs){
  if($final.ContainsKey([int]$x)){ $final.Remove([int]$x) | Out-Null }
  if($final.ContainsKey([string]$x)){ $final.Remove([string]$x) | Out-Null }
}

# World 0 holds Outland + Northrend zones (no EK/Kalimdor parent continent in the zone
# table) plus any zones whose ID didn't resolve. The label reflects the typical contents.
$groups=@{2='Eastern Kingdoms';1='Kalimdor';0='Outland & Northrend'}
$out = New-Object System.Collections.Generic.List[string]

# local rares: id -> name, grouped by continent then zone
$out.Add('local rares = {')
foreach($w in @(2,1,0)){
  $out.Add("    -- $($groups[$w])")
  $items=@($final.Values | Where-Object { $_.World -eq $w } | Sort-Object ZoneName,Name,Id)
  foreach($e in $items){ $safe=$e.Name -replace '"','\\"'; $out.Add(('    [ {0} ] = "{1}", -- {2}' -f $e.Id,$safe,$e.ZoneName)) }
  $out.Add('')
}
$out.Add('}')
$out.Add('')

# local rareZones: id -> zone name, grouped by zone name
$out.Add('local rareZones = {')
$allItems=@($final.Values | Sort-Object ZoneName,Name,Id)
$lastZone=$null
foreach($e in $allItems){
  if($e.ZoneName -ne $lastZone){
    if($null -ne $lastZone){ $out.Add('') }
    $out.Add("    -- $($e.ZoneName)")
    $lastZone=$e.ZoneName
  }
  $safeZone=$e.ZoneName -replace '"','\\"'
  $out.Add(('    [ {0} ] = "{1}",' -f $e.Id,$safeZone))
}
$out.Add('}')
$out.Add('')

# LoadRares function and login guard
$out.Add('local function LoadRares()')
$out.Add('    local me = EbonSearch;')
$out.Add('    me.NPCZones = rareZones;')
$out.Add('    for id, name in pairs( rares ) do')
$out.Add('        if not me.OptionsCharacter.NPCs[ id ] then')
$out.Add('            me.NPCAdd( id, name );')
$out.Add('        end')
$out.Add('    end')
$out.Add('end')
$out.Add('')
$out.Add("-- [Ebonhold] v2.0.0: /reload path - PLAYER_LOGIN won't fire again when already logged in")
$out.Add('if IsLoggedIn() then')
$out.Add('    LoadRares();')
$out.Add('else')
$out.Add('    local frame = CreateFrame("Frame");')
$out.Add('    frame:RegisterEvent("PLAYER_LOGIN");')
$out.Add('    frame:SetScript("OnEvent", LoadRares);')
$out.Add('end')

$outPath = Join-Path $repoRoot 'EbonSearch\generated_npcscan_rare_tables.lua'
Set-Content $outPath ($out -join "`n") -NoNewline

Write-Output "TOTAL_FINAL=$($final.Count)"
Write-Output "WORLD2=$((@($final.Values | Where-Object { $_.World -eq 2 })).Count)"
Write-Output "WORLD1=$((@($final.Values | Where-Object { $_.World -eq 1 })).Count)"
Write-Output "WORLD0=$((@($final.Values | Where-Object { $_.World -eq 0 })).Count)"
Write-Output "WOTLK_RARES=$($wotlk.Count)"
Write-Output "EBONHOLD_RARES=$($ebon.Count)"
Write-Output "QUEST_RARE_IDS=$($questIds.Count)"
Write-Output "MERGED_PRE_FILTER=$($merged.Count)"
Write-Output "WHITELIST_SIZE=$($rank1Whitelist.Count)"
Write-Output "WROTE=$outPath"
