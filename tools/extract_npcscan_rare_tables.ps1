$ErrorActionPreference='Stop'

# NPC data sourced from PE-Questie - https://github.com/Xurkon/PE-Questie
# Files are fetched fresh and not committed to this repo
$tmpClassicNpcPath = Join-Path $PSScriptRoot 'tmp_classicNpcDB.lua'
$tmpEbonholdNpcPath = Join-Path $PSScriptRoot 'tmp_EbonholdNpcDB.lua'
$tmpEbonholdQuestPath = Join-Path $PSScriptRoot 'tmp_EbonholdQuestDB.lua'

Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Xurkon/PE-Questie/refs/heads/main/Database/Classic/classicNpcDB.lua' -OutFile $tmpClassicNpcPath
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Xurkon/PE-Questie/refs/heads/main/Database/Ebonhold/Ebonhold/EbonholdNpcDB.lua' -OutFile $tmpEbonholdNpcPath
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Xurkon/PE-Questie/refs/heads/main/Database/Ebonhold/Ebonhold/EbonholdQuestDB.lua' -OutFile $tmpEbonholdQuestPath

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

# Outland and Northrend outdoor zones (drop unless in Ebonhold DB)
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

$instanceZoneIDs = New-Object 'System.Collections.Generic.HashSet[int]'
foreach($z in $classicInstances){ [void]$instanceZoneIDs.Add([int]$z[0]) }
[void]$instanceZoneIDs.Add(718) # Wailing Caverns
[void]$instanceZoneIDs.Add(722) # Razorfen Downs
[void]$instanceZoneIDs.Add(491) # Razorfen Kraul

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

function ParseNpcDb([string]$path,[string]$source){
  $items=@{}
  Get-Content $path | % {
    $line=$_.Trim()
    if($line -match '^\[(\d+)\]\s*=\s*\{(.+)\},?\s*$'){
      $id=[int]$Matches[1]; $inside=$Matches[2]; $f=Split-TopLevel $inside
      if($f.Count -ge 9){
        $name=$f[0].Trim(); if($name.StartsWith("'") -and $name.EndsWith("'")){ $name=$name.Substring(1,$name.Length-2) }
        $name=$name -replace "\\'","'"
        $rank=0; [void][int]::TryParse($f[5].Trim(),[ref]$rank)
        $spawns=$f[6].Trim(); $zoneRaw=$f[8].Trim()
        if(($rank -eq 1 -or $rank -eq 2) -and $spawns -ne 'nil'){
          $spawnZone=$null
          $m=[regex]::Match($spawns,'\[(\d+)\]'); if($m.Success){ $spawnZone=[int]$m.Groups[1].Value }
          $zid=$null; $tmp=0; if([int]::TryParse($zoneRaw,[ref]$tmp)){ $zid=$tmp }
          $items[$id]=[pscustomobject]@{Id=$id;Name=$name;SpawnZone=$spawnZone;ZoneID=$zid;Source=$source}
        }
      }
    }
  }
  return $items
}

function ParseNpcRanks([string]$path){
  $ranks=@{}
  Get-Content $path | % {
    $line=$_.Trim()
    if($line -match '^\[(\d+)\]\s*=\s*\{(.+)\},?\s*$'){
      $id=[int]$Matches[1]; $inside=$Matches[2]; $f=Split-TopLevel $inside
      if($f.Count -ge 6){
        $rank=0
        [void][int]::TryParse($f[5].Trim(),[ref]$rank)
        $ranks[$id]=$rank
      }
    }
  }
  return $ranks
}

$classic=ParseNpcDb $tmpClassicNpcPath 'classic'
$ebon=ParseNpcDb $tmpEbonholdNpcPath 'ebonhold'
$ebonRanks=ParseNpcRanks $tmpEbonholdNpcPath
$merged=@{}
$classic.Keys | % { $merged[$_]=$classic[$_] }
$ebon.Keys | % { $merged[$_]=$ebon[$_] }
$rankRareIDs = New-Object 'System.Collections.Generic.HashSet[int]'
$classic.Keys | % { [void]$rankRareIDs.Add([int]$_) }
$ebon.Keys | % { [void]$rankRareIDs.Add([int]$_) }

$qText=Get-Content $tmpEbonholdQuestPath -Raw
$questBlocks=[regex]::Matches($qText,'\[(\d+)\]\s*=\s*\{([\s\S]*?)\n\s*\},\s*(?=\n\s*--|\n\s*\[|\n\s*\})')
$questIds = New-Object 'System.Collections.Generic.HashSet[int]'
foreach($qb in $questBlocks){
  $body=$qb.Groups[2].Value
  $isRare = $body -match '(?i)Kill\s+\d+\s+Rare|Rare slain|rare in '

  if($isRare){
    # Pull all numeric lists inside braces and keep list-like groups (>=2 IDs)
    $listMatches=[regex]::Matches($body,'\{\s*((?:\d+\s*,\s*)+\d+)\s*\}')
    foreach($lm in $listMatches){
      $nums=[regex]::Matches($lm.Groups[1].Value,'\d+') | % { [int]$_.Value }
      if($nums.Count -ge 2){
        foreach($n in $nums){ if($rankRareIDs.Contains($n)){ [void]$questIds.Add($n) } }
      }
    }
  }
}
foreach($qid in $questIds){ if(-not $merged.ContainsKey($qid)){ if($ebon.ContainsKey($qid)){ $merged[$qid]=$ebon[$qid] } elseif($classic.ContainsKey($qid)){ $merged[$qid]=$classic[$qid] } } }

# Manual exclusions: remove early from merged using int and string key forms.
foreach($x in $manualExcludeIDs){
  if($merged.ContainsKey([int]$x)){ $merged.Remove([int]$x) | Out-Null }
  if($merged.ContainsKey([string]$x)){ $merged.Remove([string]$x) | Out-Null }
}

# Ebonhold rank always wins for inclusion criteria when ID exists in Ebonhold DB.
foreach($id in @($merged.Keys)){
  if($ebonRanks.ContainsKey([int]$id)){
    $r=[int]$ebonRanks[[int]$id]
    if($r -ne 1 -and $r -ne 2){
      $merged.Remove([int]$id) | Out-Null
    }
  }
}

$final=@{}
$ebonIDs = New-Object 'System.Collections.Generic.HashSet[int]'
$ebon.Keys | % { [void]$ebonIDs.Add([int]$_) }
foreach($id in $merged.Keys){
  $e=$merged[$id]
  if($manualExcludeIDs.Contains([int]$id)){ continue }
  $zone = if($e.SpawnZone){ [int]$e.SpawnZone } elseif($e.ZoneID){ [int]$e.ZoneID } else { 0 }

  # Classic-only NPCs must not have an instance spawn zone.
  if((-not $ebonIDs.Contains([int]$id)) -and $e.Source -eq 'classic'){
    $spawnZoneForFilter = if($e.SpawnZone){ [int]$e.SpawnZone } else { 0 }
    if($instanceZoneIDs.Contains($spawnZoneForFilter)){ continue }
  }

  $resolved = $null
  if($zoneMap.ContainsKey($zone)){ $resolved = $zoneMap[$zone] }

  if($resolved){
    if((-not $ebonIDs.Contains([int]$id)) -and ($resolved.Expansion -eq 'Outland' -or $resolved.Expansion -eq 'Northrend')){ continue }
    if(-not $resolved.Outdoor){ continue }
  }

  $world = if($resolved){ [int]$resolved.World } else { 0 }
  $zname = if($resolved){ [string]$resolved.Name } else { "Zone $zone" }
  $final[$id]=[pscustomobject]@{Id=[int]$id;Name=$e.Name;ZoneName=$zname;World=$world}
}

# Final safety pass: ensure manual exclusions are removed regardless of earlier merges.
foreach($x in $manualExcludeIDs){
  if($final.ContainsKey([int]$x)){ $final.Remove([int]$x) | Out-Null }
  if($final.ContainsKey([string]$x)){ $final.Remove([string]$x) | Out-Null }
}

$groups=@{2='Eastern Kingdoms';1='Kalimdor';0='Unknown/Other'}
$out = New-Object System.Collections.Generic.List[string]
$out.Add('NPCs = {')
foreach($w in @(2,1,0)){
  $out.Add("    -- $($groups[$w])")
  $items=@($final.Values | ? { $_.World -eq $w } | Sort-Object ZoneName,Name,Id)
  foreach($e in $items){ $safe=$e.Name -replace '"','\\"'; $out.Add(('    [ {0} ] = "{1}", -- {2}' -f $e.Id,$safe,$e.ZoneName)) }
  $out.Add('')
}
$out.Add('}')
$out.Add('')
$out.Add('NPCWorldIDs = {')
foreach($w in @(2,1,0)){
  $out.Add("    -- $($groups[$w])")
  $items=@($final.Values | ? { $_.World -eq $w } | Sort-Object ZoneName,Name,Id)
  foreach($e in $items){ $out.Add(('    [ {0} ] = {1}, -- {2}' -f $e.Id,$e.World,$e.ZoneName)) }
  $out.Add('')
}
$out.Add('}')

$outPath='generated_npcscan_rare_tables.lua'
Set-Content $outPath ($out -join "`n") -NoNewline
Write-Output "TOTAL_FINAL=$($final.Count)"
Write-Output "WORLD2=$((@($final.Values | ? { $_.World -eq 2 })).Count)"
Write-Output "WORLD1=$((@($final.Values | ? { $_.World -eq 1 })).Count)"
Write-Output "WORLD0=$((@($final.Values | ? { $_.World -eq 0 })).Count)"
Write-Output "QUEST_RARE_IDS=$($questIds.Count)"
Write-Output "WROTE=$outPath"
