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
				for NpcID in pairs( ScanIDs ) do
					local Name = me.TestID( NpcID );
					if ( Name ) then
						OnFound( NpcID, Name );
						break;
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
	NameplateScanFrame:Show();
end




--- Loads defaults, validates settings, and starts scan.
-- Used instead of ADDON_LOADED to give overlay mods a chance to load and register for messages.