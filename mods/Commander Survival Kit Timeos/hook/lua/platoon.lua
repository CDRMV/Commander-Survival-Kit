
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then
CopyOfOldPlatoonClass = Platoon
Platoon = Class(CopyOfOldPlatoonClass) {
    UnitUpgradeAI = function(self)
		
		local GetCSKTimeosPath = function() for i, mod in __active_mods do if mod.uid == "5t3edt-btz6-9437-h6ui-967gt56fa8118T01" then return mod.location end end end
		local CSKTimeosPath = GetCSKTimeosPath()
		local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.uid == "5t3edt-btz6-9437-h6ui-967gt56facsku120" then return mod.location end end end
		local CSKUnitsPath = GetCSKUnitsPath()
		local GetFBPOrbitalPath = function() for i, mod in __active_mods do if mod.uid == "5t3edt-btz6-9437-h6ui-967gt56fa5" then return mod.location end end end
		local FBPOrbitalPath = GetFBPOrbitalPath()
		
		if CSKTimeosPath then
		
		local Tech2 = ScenarioInfo.Options.WaitTimeTech2
		local Tech3 = ScenarioInfo.Options.WaitTimeTech3
		local Experimental = ScenarioInfo.Options.WaitTimeEXP
		local Elite = ScenarioInfo.Options.WaitTimeElite
		local Hero = ScenarioInfo.Options.WaitTimeHero
		local Titan = ScenarioInfo.Options.WaitTimeTitan
		
		if Tech2 == nil and Tech3 == nil and Experimental == nil and Elite == nil and Hero == nil and Titan == nil then
		Tech2 = 300
		Tech3 = 300
		Experimental = 300
		Elite = 300
		Hero = 300
		Titan = 300
		end
		
		if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
		ForkThread( 
        function()
            WaitSeconds(Tech2)
			self:DoUpgrades()
			WaitSeconds(Tech3)
			self:DoUpgrades()
			WaitSeconds(Elite)
			self:DoUpgrades()
			WaitSeconds(Experimental)
			self:DoUpgrades()
			WaitSeconds(Hero)
			self:DoUpgrades()
			WaitSeconds(Titan)
			self:DoUpgrades()
        end
		)
		else
		ForkThread( 
        function()
            WaitSeconds(Tech2)
			self:DoUpgrades()
			WaitSeconds(Tech3)
			self:DoUpgrades()
			WaitSeconds(Experimental)
			self:DoUpgrades()
        end
		)
		end
		
		else
		self:DoUpgrades()
		
		end
    end,
    DoUpgrades = function(self)
        local aiBrain = self:GetBrain()
        local platoonUnits = self:GetPlatoonUnits()
        local factionIndex = aiBrain:GetFactionIndex()
        self:Stop()
        for k, v in platoonUnits do
            local upgradeID
            if EntityCategoryContains(categories.MOBILE, v ) then
                upgradeID = aiBrain:FindUpgradeBP(v:GetUnitId(), UnitUpgradeTemplates[factionIndex])
            else
                upgradeID = aiBrain:FindUpgradeBP(v:GetUnitId(), StructureUpgradeTemplates[factionIndex])
            end
            if upgradeID then
                IssueUpgrade({v}, upgradeID)
            end
        end
        local upgrading = true
        while aiBrain:PlatoonExists(self) and upgrading do
            WaitSeconds(3)
            upgrading = false
            for k, v in platoonUnits do
                if v and not v:IsDead() then
                    upgrading = true
                end
            end
        end
        if not aiBrain:PlatoonExists(self) then
            return
        end
        WaitTicks(1)
        self:PlatoonDisband()
    end,
}

else

CopyOfOldPlatoonClass = Platoon
Platoon = Class(CopyOfOldPlatoonClass) {
    
    UnitUpgradeAI = function(self)
		
		local GetCSKTimeosPath = function() for i, mod in __active_mods do if mod.uid == "5t3edt-btz6-9437-h6ui-967gt56fa8118T01" then return mod.location end end end
		local CSKTimeosPath = GetCSKTimeosPath()
		local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.uid == "5t3edt-btz6-9437-h6ui-967gt56facsku120" then return mod.location end end end
		local CSKUnitsPath = GetCSKUnitsPath()
		local GetFBPOrbitalPath = function() for i, mod in __active_mods do if mod.uid == "5t3edt-btz6-9437-h6ui-967gt56fa5" then return mod.location end end end
		local FBPOrbitalPath = GetFBPOrbitalPath()
		
		if CSKTimeosPath then
		
		local Tech2 = ScenarioInfo.Options.WaitTimeTech2
		local Tech3 = ScenarioInfo.Options.WaitTimeTech3
		local Experimental = ScenarioInfo.Options.WaitTimeEXP
		local Elite = ScenarioInfo.Options.WaitTimeElite
		local Hero = ScenarioInfo.Options.WaitTimeHero
		local Titan = ScenarioInfo.Options.WaitTimeTitan
		
		if Tech2 == nil and Tech3 == nil and Experimental == nil and Elite == nil and Hero == nil and Titan == nil then
		Tech2 = 300
		Tech3 = 300
		Experimental = 300
		Elite = 300
		Hero = 300
		Titan = 300
		end
		
		if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
		ForkThread( 
        function()
            WaitSeconds(Tech2)
			self:DoUpgrades()
			WaitSeconds(Tech3)
			self:DoUpgrades()
			WaitSeconds(Elite)
			self:DoUpgrades()
			WaitSeconds(Experimental)
			self:DoUpgrades()
			WaitSeconds(Hero)
			self:DoUpgrades()
			WaitSeconds(Titan)
			self:DoUpgrades()
        end
		)
		else
		ForkThread( 
        function()
            WaitSeconds(Tech2)
			self:DoUpgrades()
			WaitSeconds(Tech3)
			self:DoUpgrades()
			WaitSeconds(Experimental)
			self:DoUpgrades()
        end
		)
		end
		
		else
		self:DoUpgrades()
		
		end
    end,
	
	DoUpgrades = function(self)
        local aiBrain = self:GetBrain()
        local platoonUnits = self:GetPlatoonUnits()
        local factionIndex = aiBrain:GetFactionIndex()
        local FactionToIndex  = { UEF = 1, AEON = 2, CYBRAN = 3, SERAPHIM = 4, NOMADS = 5}
        local UnitBeingUpgradeFactionIndex = nil
        local upgradeIssued = false

        self:Stop()
        --LOG('* UnitUpgradeAI: PlatoonName:'..tostring(self.BuilderName))
        for k, v in platoonUnits do
            --LOG('* UnitUpgradeAI: Upgrading unit '..v.UnitId..' ('..v.Blueprint.FactionCategory..')')
            local upgradeID
            -- Get the factionindex from the unit to get the right update (in case we have captured this unit from another faction)
            UnitBeingUpgradeFactionIndex = FactionToIndex[v.Blueprint.FactionCategory] or factionIndex
            --LOG('* UnitUpgradeAI: UnitBeingUpgradeFactionIndex '..UnitBeingUpgradeFactionIndex)
            if self.PlatoonData.OverideUpgradeBlueprint then
                local tempUpgradeID = self.PlatoonData.OverideUpgradeBlueprint[UnitBeingUpgradeFactionIndex]
                if not tempUpgradeID then
                    --WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] *UnitUpgradeAI WARNING: OverideUpgradeBlueprint ' .. tostring(v.UnitId) .. ' failed. (Override unitID is empty' )
                elseif type(tempUpgradeID) ~= 'string' then
                    WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] *UnitUpgradeAI WARNING: OverideUpgradeBlueprint ' .. tostring(v.UnitId) .. ' failed. (Override unit not present.)' )
                elseif v:CanBuild(tempUpgradeID) then
                    upgradeID = tempUpgradeID
                else
                    -- in case the unit can't upgrade with OverideUpgradeBlueprint, warn the programmer
                    -- this can happen if the AI relcaimed a factory and tries to upgrade to a support factory without having a HQ factory from the reclaimed factory faction.
                    -- in this case we fall back to HQ upgrade template and upgrade to a HQ factory instead of support.
                    -- Output: WARNING: [platoon.lua, line:xxx] *UnitUpgradeAI WARNING: OverideUpgradeBlueprint UnitId:CanBuild(tempUpgradeID) failed. (Override tree not available, upgrading to default instead.)
                    WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] *UnitUpgradeAI WARNING: OverideUpgradeBlueprint ' .. tostring(v.UnitId) .. ':CanBuild( '..tempUpgradeID..' ) failed. (Override tree not available, upgrading to default instead.)' )
                end
            end
            if not upgradeID and EntityCategoryContains(categories.MOBILE, v) then
                upgradeID = aiBrain:FindUpgradeBP(v.UnitId, UpgradeTemplates.UnitUpgradeTemplates[UnitBeingUpgradeFactionIndex])
                -- if we can't find a UnitUpgradeTemplate for this unit, warn the programmer
                if not upgradeID then
                    -- Output: WARNING: [platoon.lua, line:xxx] *UnitUpgradeAI ERROR: Can\'t find UnitUpgradeTemplate for mobile unit: ABC1234
                    WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] *UnitUpgradeAI ERROR: Can\'t find UnitUpgradeTemplate for mobile unit: ' .. tostring(v.UnitId) )
                end
            elseif not upgradeID then
                upgradeID = aiBrain:FindUpgradeBP(v.UnitId, UpgradeTemplates.StructureUpgradeTemplates[UnitBeingUpgradeFactionIndex])
                -- if we can't find a StructureUpgradeTemplate for this unit, warn the programmer
                if not upgradeID then
                    -- Output: WARNING: [platoon.lua, line:xxx] *UnitUpgradeAI ERROR: Can\'t find StructureUpgradeTemplate for structure: ABC1234
                    WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] *UnitUpgradeAI ERROR: Can\'t find StructureUpgradeTemplate for structure: ' .. tostring(v.UnitId) .. '  faction: ' .. tostring(v.Blueprint.FactionCategory) )
                end
            end
            if upgradeID and EntityCategoryContains(categories.STRUCTURE, v) and not v:CanBuild(upgradeID) then
                -- in case the unit can't upgrade with upgradeID, warn the programmer
                -- Output: WARNING: [platoon.lua, line:xxx] *UnitUpgradeAI ERROR: ABC1234:CanBuild(upgradeID) failed!
                WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] *UnitUpgradeAI ERROR: ' .. tostring(v.UnitId) .. ':CanBuild( '..upgradeID..' ) failed!' )
                continue
            end
            if upgradeID then
                upgradeIssued = true
                IssueUpgrade({v}, upgradeID)
                --LOG('-- Upgrading unit '..v.UnitId..' ('..v.Blueprint.FactionCategory..') with '..upgradeID)
            end
        end
        if not upgradeIssued then
            self:PlatoonDisband()
            return
        end
        local upgrading = true
        while aiBrain:PlatoonExists(self) and upgrading do
            WaitSeconds(3)
            upgrading = false
            for k, v in platoonUnits do
                if v and not v.Dead then
                    upgrading = true
                end
            end
        end
        if not aiBrain:PlatoonExists(self) then
            return
        end
        WaitTicks(1)
        self:PlatoonDisband()
		
    end,
}	
end