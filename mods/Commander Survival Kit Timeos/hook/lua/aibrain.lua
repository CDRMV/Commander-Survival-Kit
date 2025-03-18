local NewAIBrain = AIBrain 
local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.name == "Commander Survival Kit Units" then return mod.location end end end
local CSKUnitsPath = GetCSKUnitsPath()
local GetFBPOrbitalPath = function() for i, mod in __active_mods do if mod.name == "Future Battlefield Pack Orbital" then return mod.location end end end
local FBPOrbitalPath = GetFBPOrbitalPath()

AIBrain = Class(NewAIBrain) {

    OnCreateHuman = function(self, planName)
    	NewAIBrain.OnCreateHuman(self)
		self:ForkThread(self.LockTechlevelThread)
		self:ForkThread(self.UnlockTechlevelThread)
    end,
	
	OnCreateAI = function(self, planName)
		NewAIBrain.OnCreateAI(self)
		self:ForkThread(self.LockTechlevelThread)
		self:ForkThread(self.UnlockTechlevelThread)
    end,
	
	LockTechlevelThread = function(self)
		
        AddBuildRestriction(self:GetArmyIndex(), categories.TECH2)
		AddBuildRestriction(self:GetArmyIndex(), categories.TECH3)
		AddBuildRestriction(self:GetArmyIndex(), categories.EXPERIMENTAL)
		
		if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
		AddBuildRestriction(self:GetArmyIndex(), categories.ELITE)
		AddBuildRestriction(self:GetArmyIndex(), categories.HERO)
		AddBuildRestriction(self:GetArmyIndex(), categories.TITAN)
		else
		
		end
    end,
	
	UnlockTechlevelThread = function(self)
		local Tech2 = ScenarioInfo.Options.WaitTimeTech2
		local Tech3 = ScenarioInfo.Options.WaitTimeTech3
		local Experimental = ScenarioInfo.Options.WaitTimeEXP
		local Elite = ScenarioInfo.Options.WaitTimeElite
		local Hero = ScenarioInfo.Options.WaitTimeHero
		local Titan = ScenarioInfo.Options.WaitTimeTitan
		
		local UnitRestrictions = ScenarioInfo.Options.RestrictedCategories
		LOG('UnitRestrictions: ', UnitRestrictions)
		
		-----------------------------------------------------------------------------------------------------------------------
		-- This If Statement is temporary to make the mod functional in Steam, DVD and Loud.
		-- It will be removed if the Lobby Options are added to support them
		-----------------------------------------------------------------------------------------------------------------------
		
		if Tech2 == nil and Tech3 == nil and Experimental == nil and Elite == nil and Hero == nil and Titan == nil then
		Tech2 = 300
		Tech3 = 300
		Experimental = 300
		Elite = 300
		Hero = 300
		Titan = 300
		end
		Sync.ClosePanel = false
		Sync.Techlevel2 =true
		Sync.Techlevel3 = false
		Sync.Techlevel4 = false
		Sync.Techlevel5 = false
		Sync.Techlevel6 = false
		Sync.Techlevel7 = false
		-----------------------------------------------------------------------------------------------------------------------

		if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
		Sync.T2WaitTime=Tech2
		WaitSeconds(Tech2)
        RemoveBuildRestriction(self:GetArmyIndex(), categories.TECH2 + categories.ALLUNITS - categories.TECH3)
		Sync.Techlevel2 = false
		Sync.Techlevel3 = true
		Sync.T3WaitTime=Tech2+Tech3
		WaitSeconds(Tech3)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.TECH3 + categories.ALLUNITS)
		Sync.Techlevel3 = false
		Sync.Techlevel4 = true
		Sync.TEXPWaitTime=Tech2+Tech3+Experimental
		WaitSeconds(Experimental)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.EXPERIMENTAL + categories.ALLUNITS)
		Sync.Techlevel4 = false
		Sync.Techlevel5 = true
		Sync.TEliteWaitTime=Tech2+Tech3+Experimental+Elite
		WaitSeconds(Elite)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.ELITE + categories.ALLUNITS)
		Sync.Techlevel5 = false
		Sync.Techlevel6 = true
		Sync.THeroWaitTime=Tech2+Tech3+Experimental+Elite+Hero
		WaitSeconds(Hero)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.HERO + categories.ALLUNITS)
		Sync.Techlevel6 = false
		Sync.Techlevel7 = true
		Sync.TTitanWaitTime=Tech2+Tech3+Experimental+Elite+Hero+Titan
		WaitSeconds(Titan)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.TITAN + categories.ALLUNITS)
		Sync.Techlevel7 = false
		Sync.Techlevel8 = true
		Sync.ClosePanel = true
		else
		Sync.T2WaitTime=Tech2
		WaitSeconds(Tech2)
        RemoveBuildRestriction(self:GetArmyIndex(), categories.TECH2 + categories.ALLUNITS - categories.TECH3)
		Sync.Techlevel2 = false
		Sync.Techlevel3 = true
		Sync.T3WaitTime=Tech2+Tech3
		WaitSeconds(Tech3)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.TECH3 + categories.ALLUNITS)
		Sync.Techlevel3 = false
		Sync.Techlevel4 = true
		Sync.TEXPWaitTime=Tech2+Tech3+Experimental
		WaitSeconds(Experimental)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.EXPERIMENTAL + categories.ALLUNITS)
		Sync.Techlevel4 = false
		Sync.Techlevel5 = true
		Sync.ClosePanel = true
		end
    end,
	
} 