import re

src = r'c:\Users\ch\ebon-search-and-destroy\EbonSearch\generated_npcscan_rare_tables.lua'
out = r'c:\Users\ch\ebon-search-and-destroy\EbonSearch\generated_npcscan_rare_tables.lua'

lines = open(src, encoding='utf-8-sig').readlines()

# Extract id->zone from the `rares` block only (stops at rareWorldIDs)
entries = {}
in_rares = False
for line in lines:
    if line.strip().startswith('local rares = {'):
        in_rares = True
    elif in_rares and line.strip().startswith('local rareWorldIDs'):
        break
    if in_rares:
        m = re.search(r'\[\s*(\d+)\s*\]\s*=\s*"[^"]+",\s*--\s*(.+)', line)
        if m:
            entries[int(m.group(1))] = m.group(2).strip()

print(f"Extracted {len(entries)} zone-annotated entries")

# Build the rareZones Lua block
zone_lines = ['local rareZones = {']
current_zone = None
for npc_id in sorted(entries):
    zone = entries[npc_id]
    if zone != current_zone:
        if current_zone is not None:
            zone_lines.append('')
        zone_lines.append(f'    -- {zone}')
        current_zone = zone
    zone_lines.append(f'    [ {npc_id} ] = "{zone}",')
zone_lines.append('}')
zone_block = '\n'.join(zone_lines)

# Read full file content
content = open(src, encoding='utf-8-sig').read()

# Replace or insert the rareZones block before LoadRares
marker = 'local function LoadRares()'
if 'local rareZones = {' in content:
    # Replace existing block
    content = re.sub(r'local rareZones = \{.*?\}', zone_block, content, flags=re.DOTALL)
else:
    content = content.replace(marker, zone_block + '\n\n' + marker)

# Ensure LoadRares sets EbonSearch.NPCZones
old_load = '''local function LoadRares()
    local me = EbonSearch;
    for id, name in pairs( rares ) do
        if not me.OptionsCharacter.NPCs[ id ] then
            me.NPCAdd( id, name );
        end
    end
end'''
new_load = '''local function LoadRares()
    local me = EbonSearch;
    me.NPCZones = rareZones;
    for id, name in pairs( rares ) do
        if not me.OptionsCharacter.NPCs[ id ] then
            me.NPCAdd( id, name );
        end
    end
end'''

if old_load in content:
    content = content.replace(old_load, new_load)
    print("Patched LoadRares to expose NPCZones")
else:
    print("WARNING: LoadRares pattern not matched - check manually")

open(out, 'w', encoding='utf-8', newline='\n').write(content)
print("Done.")
