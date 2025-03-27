local NewAIBrain = AIBrain 
local GetCSKPath = function() for i, mod in __active_mods do if mod.CSKProjectModName == "CSK" then return mod.location end end end
local CSKPath = GetCSKPath()
local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.CSKProjectModName == "CSK-Units" then return mod.location end end end
local CSKUnitsPath = GetCSKUnitsPath()
local GetFBPOrbitalPath = function() for i, mod in __active_mods do if mod.FBPProjectModName == "FBP-Orbital" then return mod.location end end end
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
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, 2, 2, 2)
		else
		end
        AddBuildRestriction(self:GetArmyIndex(), categories.TECH2)
		AddBuildRestriction(self:GetArmyIndex(), categories.TECH3)
		AddBuildRestriction(self:GetArmyIndex(), categories.EXPERIMENTAL)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.MASSEXTRACTION) -- Make Sure to make Mass Extractors to be Upgradable for the AI
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
		
		local Centers = ScenarioInfo.Options.CentersIncluded
		local Storages = ScenarioInfo.Options.PointStorage
		local HQCenter = ScenarioInfo.Options.HQComCentersIncluded
		
		local UnitRestrictions = ScenarioInfo.Options.RestrictedCategories
		
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
		--categories.SUPPORTFACTORY
		if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
		Sync.T2WaitTime=Tech2
		WaitSeconds(Tech2)
        RemoveBuildRestriction(self:GetArmyIndex(), categories.TECH2 + categories.ALLUNITS - categories.TECH3 - categories.EXPERIMENTAL - categories.ELITE - categories.HERO - categories.TITAN )
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end
		Sync.Techlevel2 = false
		Sync.Techlevel3 = true
		Sync.T3WaitTime=Tech2+Tech3
		WaitSeconds(Tech3)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.TECH3 + categories.ALLUNITS - categories.EXPERIMENTAL - categories.ELITE - categories.HERO - categories.TITAN)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end
		Sync.Techlevel3 = false
		Sync.Techlevel4 = true
		Sync.TEXPWaitTime=Tech2+Tech3+Elite
		WaitSeconds(Elite)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.ELITE + categories.ALLUNITS - categories.EXPERIMENTAL - categories.HERO - categories.TITAN)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end
		Sync.Techlevel4 = false
		Sync.Techlevel5 = true
		Sync.TEliteWaitTime=Tech2+Tech3+Elite+Experimental
		WaitSeconds(Experimental)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.ELITE + categories.ALLUNITS - categories.HERO - categories.TITAN)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end
		Sync.Techlevel5 = false
		Sync.Techlevel6 = true
		Sync.THeroWaitTime=Tech2+Tech3+Experimental+Elite+Hero
		WaitSeconds(Hero)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.HERO + categories.ALLUNITS - categories.TITAN)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end
		Sync.Techlevel6 = false
		Sync.Techlevel7 = true
		Sync.TTitanWaitTime=Tech2+Tech3+Experimental+Elite+Hero+Titan
		WaitSeconds(Titan)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.TITAN + categories.ALLUNITS)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end
		Sync.Techlevel7 = false
		Sync.Techlevel8 = true
		Sync.ClosePanel = true
		else
		Sync.T2WaitTime=Tech2
		WaitSeconds(Tech2)
        RemoveBuildRestriction(self:GetArmyIndex(), categories.TECH2 + categories.ALLUNITS - categories.TECH3 - categories.EXPERIMENTAL)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end
		Sync.Techlevel2 = false
		Sync.Techlevel3 = true
		Sync.T3WaitTime=Tech2+Tech3
		WaitSeconds(Tech3)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.TECH3 + categories.ALLUNITS - categories.EXPERIMENTAL)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end
		Sync.Techlevel3 = false
		Sync.Techlevel5 = true
		Sync.TEXPWaitTime=Tech2+Tech3+Experimental
		WaitSeconds(Experimental)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.EXPERIMENTAL + categories.ALLUNITS)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end
		Sync.Techlevel5 = false
		Sync.Techlevel6 = true
		Sync.ClosePanel = true
		end
    end,
	
	
	CSKGetOptions = function(self, PointGenCentersInclude, PointStoragesInclude, HQCenterInclude)
	
		if PointGenCentersInclude == 1 then
		RemoveBuildRestriction(self:GetArmyIndex(), categories.COMMANDCENTER)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.TACTICALCENTER)
		self:ForkThread(self.CheckRefCenterStep1)
		self:ForkThread(self.CheckTacCenterStep1)
		elseif PointGenCentersInclude == 2 then
		AddBuildRestriction(self:GetArmyIndex(), categories.COMMANDCENTER)
		AddBuildRestriction(self:GetArmyIndex(), categories.TACTICALCENTER)
		else
		
		end
		if PointStoragesInclude == 1 then
        RemoveBuildRestriction(self:GetArmyIndex(), categories.COMMANDPOINTSTORAGE)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.TACTICALPOINTSTORAGE)
		self:ForkThread(self.CheckRefPointStorageStep1)
		self:ForkThread(self.CheckTacPointStorageStep1)
		elseif PointStoragesInclude == 2 then
		AddBuildRestriction(self:GetArmyIndex(), categories.COMMANDPOINTSTORAGE)
		AddBuildRestriction(self:GetArmyIndex(), categories.TACTICALPOINTSTORAGE)
		else
		
		end
		if HQCenterInclude == 1 then
        RemoveBuildRestriction(self:GetArmyIndex(), categories.HQCOMMUNICATIONCENTER)
		self:ForkThread(self.CheckHQCenterStep1)
		Sync.HQComCenterDisabled = false
		elseif HQCenterInclude == 2 then
		AddBuildRestriction(self:GetArmyIndex(), categories.HQCOMMUNICATIONCENTER)
		Sync.HQComCenterDisabled = true
		else
		
		end
	
	end,
	
	CheckHQCenterStep1 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.HQCOMMUNICATIONCENTER, true)
			if table.getn(labs) >= 1 then
				AddBuildRestriction(self:GetArmyIndex(), categories.HQCOMMUNICATIONCENTER)
				self:ForkThread(self.CheckHQCenterStep2)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckHQCenterStep2 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.HQCOMMUNICATIONCENTER, true)
			if table.getn(labs) < 1  then
				RemoveBuildRestriction(self:GetArmyIndex(), categories.HQCOMMUNICATIONCENTER)
				self:ForkThread(self.CheckHQCenterStep1)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckRefPointStorageStep1 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.COMMANDPOINTSTORAGE, true)
			if table.getn(labs) >= 1 then
				AddBuildRestriction(self:GetArmyIndex(), categories.COMMANDPOINTSTORAGE)
				self:ForkThread(self.CheckRefPointStorageStep2)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckRefPointStorageStep2 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.COMMANDPOINTSTORAGE, true)
			if table.getn(labs) < 1  then	
				RemoveBuildRestriction(self:GetArmyIndex(), categories.COMMANDPOINTSTORAGE)
				self:ForkThread(self.CheckRefPointStorageStep1)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckTacPointStorageStep1 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.TACTICALPOINTSTORAGE, true)
			if table.getn(labs) >= 1 then
				AddBuildRestriction(self:GetArmyIndex(), categories.TACTICALPOINTSTORAGE)
				self:ForkThread(self.CheckTacPointStorageStep2)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckTacPointStorageStep2 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.TACTICALPOINTSTORAGE, true)
			if table.getn(labs) < 1  then
				RemoveBuildRestriction(self:GetArmyIndex(), categories.TACTICALPOINTSTORAGE)
				self:ForkThread(self.CheckTacPointStorageStep1)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	-- Integrate a Limit to the Command Centers to make them not buildable after 5
	-- If one or more are being destroyed the Center will be buildable agian. 
	
	CheckRefCenterStep1 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.COMMANDCENTER, true)
			if table.getn(labs) >= 5 then
				AddBuildRestriction(self:GetArmyIndex(), categories.COMMANDCENTER)
				self:ForkThread(self.CheckRefCenterStep2)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckRefCenterStep2 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.COMMANDCENTER, true)
			if table.getn(labs) < 5  then
				RemoveBuildRestriction(self:GetArmyIndex(), categories.COMMANDCENTER)
				self:ForkThread(self.CheckRefCenterStep1)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	-- Integrate a Limit to the Tactical Centers to make them not buildable after 5
	-- If one or more are being destroyed the Center will be buildable agian. 

	CheckTacCenterStep1 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.TACTICALCENTER, true)
			if table.getn(labs) >= 5 then
				AddBuildRestriction(self:GetArmyIndex(), categories.TACTICALCENTER)
				self:ForkThread(self.CheckTacCenterStep2)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckTacCenterStep2 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.TACTICALCENTER, true)
			if table.getn(labs) < 5  then
				RemoveBuildRestriction(self:GetArmyIndex(), categories.TACTICALCENTER)
				self:ForkThread(self.CheckTacCenterStep1)
				break
			end
			WaitSeconds(1)
			end
    end,
	
} 