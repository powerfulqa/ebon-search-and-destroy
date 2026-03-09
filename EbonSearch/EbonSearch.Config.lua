--[[****************************************************************************
  * EbonSearch                                                         *
  * EbonSearch.Config.lua - Adds an options pane to the Interface Options menu.  *
  ****************************************************************************]]


local EbonSearch = select( 2, ... );
local L = EbonSearch.L;
local me = CreateFrame( "Frame" );
EbonSearch.Config = me;

me.CacheWarnings = CreateFrame( "CheckButton", "EbonSearchConfigCacheWarningsCheckbox", me, "InterfaceOptionsCheckButtonTemplate" );

local AlertOptions = CreateFrame( "Frame", "EbonSearchConfigAlert", me, "OptionsBoxTemplate" );
me.Test = CreateFrame( "Button", "EbonSearchTest", AlertOptions, "GameMenuButtonTemplate" );
me.AlertSoundUnmute = CreateFrame( "CheckButton", "EbonSearchConfigUnmuteCheckbox", AlertOptions, "InterfaceOptionsCheckButtonTemplate" );
me.AlertSound = CreateFrame( "Frame", "EbonSearchConfigSoundDropdown", AlertOptions, "UIDropDownMenuTemplate" );




--- Builds a standard tooltip for a control.
function me:ControlOnEnter ()
	GameTooltip:SetOwner( self, "ANCHOR_TOPRIGHT" );
	GameTooltip:SetText( self.tooltipText, nil, nil, nil, nil, 1 );
end


--- Sets the CacheWarnings option when its checkbox is clicked.
function me.CacheWarnings.setFunc ( Enable )
	EbonSearch.SetCacheWarnings( Enable == "1" );
end

--- Plays a fake found alert and shows the target button.
function me.Test:OnClick ()
	local Name = L.CONFIG_TEST_NAME;
	EbonSearch.Print( L.FOUND_FORMAT:format( Name ), GREEN_FONT_COLOR );
	EbonSearch.Print( L.CONFIG_TEST_HELP_FORMAT:format( GetModifiedClick( "_EBONSEARCH_BUTTONDRAG" ) ) );

	EbonSearch.Button:SetNPC( "player", Name );
end
--- Sets the AlertSoundUnmute option when its checkbox is clicked.
function me.AlertSoundUnmute.setFunc ( Enable )
	EbonSearch.SetAlertSoundUnmute( Enable == "1" );
end
--- Sets an alert sound chosen from the LibSharedMedia dropdown.
function me.AlertSound:OnSelect ( NewValue )
	EbonSearch.Button.PlaySound( NewValue ); -- Play sample
	EbonSearch.SetAlertSound( NewValue );
end
--- Builds a dropdown menu for alert sounds with LibSharedMedia options.
function me.AlertSound:initialize ()
	local Value = EbonSearch.Options.AlertSound;

	local Info = UIDropDownMenu_CreateInfo();
	Info.func = self.OnSelect;
	Info.text = L.CONFIG_ALERT_SOUND_DEFAULT;
	Info.checked = Value == nil;
	UIDropDownMenu_AddButton( Info );

	local LSM = LibStub( "LibSharedMedia-3.0" );
	for _, Key in ipairs( LSM:List( LSM.MediaType.SOUND ) ) do
		Info.text, Info.arg1 = Key, Key;
		Info.checked = Value == Key;
		UIDropDownMenu_AddButton( Info );
	end
end


--- Reverts to default options.
function me:default ()
	EbonSearch.Synchronize(); -- Resets all
end




me.name = L.CONFIG_TITLE;
me:Hide();

-- Pane title
local Title = me:CreateFontString( nil, "ARTWORK", "GameFontNormalLarge" );
Title:SetPoint( "TOPLEFT", 16, -16 );
Title:SetText( L.CONFIG_TITLE );
local SubText = me:CreateFontString( nil, "ARTWORK", "GameFontHighlightSmall" );
SubText:SetPoint( "TOPLEFT", Title, "BOTTOMLEFT", 0, -8 );
SubText:SetPoint( "RIGHT", -32, 0 );
SubText:SetHeight( 32 );
SubText:SetJustifyH( "LEFT" );
SubText:SetJustifyV( "TOP" );
SubText:SetText( L.CONFIG_DESC );


-- Miscellaneous checkboxes
me.CacheWarnings:SetPoint( "TOPLEFT", SubText, "BOTTOMLEFT", -2, -8 );
_G[ me.CacheWarnings:GetName().."Text" ]:SetText( L.CONFIG_CACHEWARNINGS );
me.CacheWarnings.tooltipText = L.CONFIG_CACHEWARNINGS_DESC;


-- Alert options section
AlertOptions:SetPoint( "TOPLEFT", me.CacheWarnings, "BOTTOMLEFT", 0, -16 );
AlertOptions:SetPoint( "BOTTOMRIGHT", -14, 16 );
_G[ AlertOptions:GetName().."Title" ]:SetText( L.CONFIG_ALERT );

-- Test button
me.Test:SetPoint( "TOPLEFT", 16, -16 );
me.Test:SetScript( "OnClick", me.Test.OnClick );
me.Test:SetScript( "OnEnter", me.ControlOnEnter );
me.Test:SetScript( "OnLeave", GameTooltip_Hide );
me.Test:SetText( L.CONFIG_TEST );
me.Test.tooltipText = L.CONFIG_TEST_DESC;

me.AlertSoundUnmute:SetPoint( "TOPLEFT", me.Test, "BOTTOMLEFT", -2, -16 );
_G[ me.AlertSoundUnmute:GetName().."Text" ]:SetText( L.CONFIG_ALERT_UNMUTE );
me.AlertSoundUnmute.tooltipText = L.CONFIG_ALERT_UNMUTE_DESC;

me.AlertSound:SetPoint( "TOPLEFT", me.AlertSoundUnmute, "BOTTOMLEFT", -12, -18 );
me.AlertSound:SetPoint( "RIGHT", -12, 0 );
me.AlertSound:EnableMouse( true );
me.AlertSound:SetScript( "OnEnter", me.ControlOnEnter );
me.AlertSound:SetScript( "OnLeave", GameTooltip_Hide );
UIDropDownMenu_JustifyText( me.AlertSound, "LEFT" );
_G[ me.AlertSound:GetName().."Middle" ]:SetPoint( "RIGHT", -16, 0 );
local Label = me.AlertSound:CreateFontString( nil, "ARTWORK", "GameFontNormalSmall" );
Label:SetPoint( "BOTTOMLEFT", me.AlertSound, "TOPLEFT", 16, 3 );
Label:SetText( L.CONFIG_ALERT_SOUND );
me.AlertSound.tooltipText = L.CONFIG_ALERT_SOUND_DESC;
UIDropDownMenu_SetText( me.AlertSound, L.CONFIG_ALERT_SOUND_DEFAULT );


InterfaceOptions_AddCategory( me );

-- [Ebonhold] v2.0.0: Zone Blacklist section ----------------------------------
do
	local ZBL = CreateFrame( "Frame", "EbonSearchConfigZoneBlacklist", me );
	me.ZoneBlacklist = ZBL;

	-- Section header
	local Header = ZBL:CreateFontString( nil, "ARTWORK", "GameFontNormal" );
	Header:SetPoint( "TOPLEFT", me.AlertSound, "BOTTOMLEFT", 12, -24 );
	Header:SetText( "Zone Blacklist" );

	local SubDesc = ZBL:CreateFontString( nil, "ARTWORK", "GameFontHighlightSmall" );
	SubDesc:SetPoint( "TOPLEFT", Header, "BOTTOMLEFT", 0, -4 );
	SubDesc:SetText( "Scanning is suppressed in blacklisted zones." );

	-- Scroll frame for zone list
	local ScrollFrame = CreateFrame( "ScrollFrame", "EbonSearchConfigZBLScroll", me, "UIPanelScrollFrameTemplate" );
	ScrollFrame:SetPoint( "TOPLEFT", SubDesc, "BOTTOMLEFT", 0, -6 );
	ScrollFrame:SetPoint( "BOTTOMRIGHT", -32, 62 );
	ScrollFrame:SetHeight( 80 );

	local ListFrame = CreateFrame( "Frame", nil, ScrollFrame );
	ListFrame:SetSize( ScrollFrame:GetWidth(), 1 );
	ScrollFrame:SetScrollChild( ListFrame );

	local function BuildList ()
		-- Clear old rows
		for _, child in ipairs( { ListFrame:GetChildren() } ) do
			child:Hide();
			child:SetParent( nil );
		end
		local y = 0;
		local blacklist = EbonSearch.Options and EbonSearch.Options.ZoneBlacklist or {};
		local zones = {};
		for z in pairs( blacklist ) do zones[ #zones + 1 ] = z; end
		table.sort( zones );
		for _, zone in ipairs( zones ) do
			local row = CreateFrame( "Frame", nil, ListFrame );
			row:SetSize( ListFrame:GetWidth(), 18 );
			row:SetPoint( "TOPLEFT", 0, -y );
			local label = row:CreateFontString( nil, "ARTWORK", "GameFontHighlightSmall" );
			label:SetPoint( "LEFT", 2, 0 );
			label:SetText( "|cffFFFF00" .. zone .. "|r" );
			local btn = CreateFrame( "Button", nil, row, "UIPanelCloseButton" );
			btn:SetSize( 16, 16 );
			btn:SetPoint( "RIGHT", -2, 0 );
			btn:SetScript( "OnClick", function ()
				EbonSearch.Options.ZoneBlacklist[ zone ] = nil;
				EbonSearch.Print( "Zone removed: |cffFFFF00" .. zone .. "|r", GREEN_FONT_COLOR );
				BuildList();
			end );
			row:Show();
			y = y + 18;
		end
		if ( #zones == 0 ) then
			local empty = ListFrame:CreateFontString( nil, "ARTWORK", "GameFontDisableSmall" );
			empty:SetPoint( "TOPLEFT", 2, 0 );
			empty:SetText( "(none)" );
		end
		ListFrame:SetHeight( math.max( y, 18 ) );
	end

	ZBL.Refresh = BuildList;

	-- Add Current Zone button
	local AddBtn = CreateFrame( "Button", "EbonSearchConfigZBLAddBtn", me, "GameMenuButtonTemplate" );
	AddBtn:SetSize( 130, 22 );
	AddBtn:SetPoint( "BOTTOMLEFT", ScrollFrame, "BOTTOMLEFT", 0, -28 );
	AddBtn:SetText( "Add Current Zone" );
	AddBtn:SetScript( "OnClick", function ()
		local zone = GetRealZoneText();
		if ( zone and zone ~= "" ) then
			if ( not EbonSearch.Options.ZoneBlacklist ) then
				EbonSearch.Options.ZoneBlacklist = {};
			end
			EbonSearch.Options.ZoneBlacklist[ zone ] = true;
			EbonSearch.Print( "Zone blacklisted: |cffFFFF00" .. zone .. "|r", GREEN_FONT_COLOR );
			BuildList();
		end
	end );

	-- Refresh list whenever panel is shown
	me:HookScript( "OnShow", function ()
		BuildList();
	end );
end