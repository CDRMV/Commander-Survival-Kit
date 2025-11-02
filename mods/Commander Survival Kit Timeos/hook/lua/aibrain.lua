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
		local number = 0
		local Centers = ScenarioInfo.Options.CentersIncluded
		local Storages = ScenarioInfo.Options.PointStorage
		local HQCenter = ScenarioInfo.Options.HQComCentersIncluded
		local Gametype = ScenarioInfo.type
		self:ForkThread(self.LockTechlevelThread)
		if Gametype == 'campaign' then
		ForkThread( function()
		while true do
		if Sync.PointGenerationCentersDisabled == nil and Sync.PointStoragesDisabled == nil and Sync.HQComCenterDisabled2 == nil then
		
		else
		if number == 0 then
		Centers = Sync.PointGenerationCentersDisabled
		Storages = Sync.PointStoragesDisabled
		HQCenter = Sync.HQComCenterDisabled2
		number = 1
		end
		end
		if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
		if Sync.TransferT2WaitTime and Sync.TransferT3WaitTime and Sync.TransferEXPWaitTime and Sync.TransferEliteWaitTime and Sync.TransferHeroWaitTime and Sync.TransferTitanWaitTime then
		self:ForkThread(self.UnlockTechlevelThread, true, Sync.TransferT2WaitTime, Sync.TransferT3WaitTime, Sync.TransferEXPWaitTime, Sync.TransferEliteWaitTime, Sync.TransferHeroWaitTime, Sync.TransferTitanWaitTime, Centers, Storages, HQCenter)
		break
		end
		else
		if Sync.TransferT2WaitTime and Sync.TransferT3WaitTime and Sync.TransferEXPWaitTime then
		self:ForkThread(self.UnlockTechlevelThread, true, Sync.TransferT2WaitTime, Sync.TransferT3WaitTime, Sync.TransferEXPWaitTime, nil, nil, nil, Centers, Storages, HQCenter)
		break
		end
		end
		WaitSeconds(0.1)
		end
		end)
		else
		self:ForkThread(self.UnlockTechlevelThread, false, nil, nil, nil, nil, nil, nil, Centers, Storages, HQCenter)
		end
    end,
	
	OnCreateAI = function(self, planName)
		NewAIBrain.OnCreateAI(self)
		local Centers = ScenarioInfo.Options.CentersIncluded
		local Storages = ScenarioInfo.Options.PointStorage
		local HQCenter = ScenarioInfo.Options.HQComCentersIncluded
		local Gametype = ScenarioInfo.type
		self:ForkThread(self.LockTechlevelThread)
		if Gametype == 'campaign' then
		ForkThread( function()
		while true do
		if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
		if Sync.TransferT2WaitTime and Sync.TransferT3WaitTime and Sync.TransferEXPWaitTime and Sync.TransferEliteWaitTime and Sync.TransferHeroWaitTime and Sync.TransferTitanWaitTime then
		self:ForkThread(self.UnlockTechlevelThread, true, Sync.TransferT2WaitTime, Sync.TransferT3WaitTime, Sync.TransferEXPWaitTime, Sync.TransferEliteWaitTime, Sync.TransferHeroWaitTime, Sync.TransferTitanWaitTime, 2, 2, 2)
		break
		end
		else
		if Sync.TransferT2WaitTime and Sync.TransferT3WaitTime and Sync.TransferEXPWaitTime then
		local Centers = ScenarioInfo.Options.CentersIncluded
		local Storages = ScenarioInfo.Options.PointStorage
		local HQCenter = ScenarioInfo.Options.HQComCentersIncluded
		self:ForkThread(self.UnlockTechlevelThread, true, Sync.TransferT2WaitTime, Sync.TransferT3WaitTime, Sync.TransferEXPWaitTime, nil, nil, nil, 2, 2, 2)
		break
		end
		end
		WaitSeconds(0.1)
		end
		end)
		else
		self:ForkThread(self.UnlockTechlevelThread, false, nil, nil, nil, nil, nil, nil, Centers, Storages, HQCenter)
		end
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
	
	UnlockTechlevelThread = function(self, boolean, T2, T3, EXP, E, H, T, Centers, Storages, HQCenter)
	local number = 0
	if number == 0 then
	number = 1
		local Tech2 = nil
		local Tech3 = nil
		local Experimental = nil
		local Elite = nil
		local Hero = nil
		local Titan = nil
	
	
		if boolean == false then
		Tech2 = ScenarioInfo.Options.WaitTimeTech2
		Tech3 = ScenarioInfo.Options.WaitTimeTech3
		Experimental = ScenarioInfo.Options.WaitTimeEXP
		Elite = ScenarioInfo.Options.WaitTimeElite
		Hero = ScenarioInfo.Options.WaitTimeHero
		Titan = ScenarioInfo.Options.WaitTimeTitan


		elseif boolean == true then
		-----------------------------------------------------------------------------------------------------------------------
		-- This If Statement is temporary to make the mod functional in Steam, DVD and Loud.
		-- It will be removed if the Lobby Options are added to support them
		-----------------------------------------------------------------------------------------------------------------------
		Tech2 = T2
		Tech3 = T3
		Experimental = EXP
		
		LOG('Centers: ', Centers)
		LOG('Storages: ', Storages)
		LOG('HQCenter: ', HQCenter)
		
		if Centers and Storages and HQCenter then

		else
		Centers = 1
		Storages = 2
		HQCenter = 2
		end
		
		if E and H and T then
		Elite = E
		Hero = H
		Titan = T
		else
		Elite = 0
		Hero = 0
		Titan = 0
		end
		end
		Sync.ClosePanel = false
			
		LOG('Tech2: ', Tech2)
		LOG('Tech3: ', Tech3)
		LOG('Experimental: ', Experimental)
		LOG('Elite: ', Elite)
		LOG('Hero: ', Hero)
		LOG('Titan: ', Titan)
		LOG('Centers: ', Centers)
		LOG('Storages: ', Storages)
		LOG('HQCenter: ', HQCenter)
	
		

		if Tech2 and Tech3 and Experimental and Elite and Hero and Titan then
		
		-----------------------------------------------------------------------------------------------------------------------
		--categories.SUPPORTFACTORY
		if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
		
		ForkThread( function()
		while true do
					local MathFloor = math.floor
			local hours = MathFloor(GetGameTimeSeconds() / 3600)
			local Seconds = GetGameTimeSeconds() - hours * 3600
			if Seconds < Tech2 then
			Sync.Techlevel2 = true
			Sync.T2WaitTime=Tech2
			end
			if Seconds > Tech2 and Seconds < (Tech2 + Tech3) then
			Sync.Techlevel2 = false
			Sync.Techlevel3 = true
			Sync.T3WaitTime=Tech2+Tech3
			end
			if Seconds > (Tech2 + Tech3) and Seconds < (Tech2 + Tech3 + Elite) then
			Sync.Techlevel3 = false
			Sync.Techlevel4 = true
			Sync.TEliteWaitTime=Tech2+Tech3+Elite
			end
			if Seconds > (Tech2 + Tech3 + Elite) and Seconds < (Tech2 + Tech3 + Elite + Experimental) then
			Sync.Techlevel4 = false
			Sync.Techlevel5 = true
			Sync.TEXPWaitTime=Tech2+Tech3+Elite+Experimental
			end
			if Seconds > (Tech2 + Tech3 + Elite + Experimental) and Seconds < (Tech2 + Tech3 + Elite + Experimental + Hero) then
			Sync.Techlevel5 = false
			Sync.Techlevel6 = true
			Sync.THeroWaitTime=Tech2+Tech3+Elite+Experimental+Hero
			end
			if Seconds > (Tech2 + Tech3 + Elite + Experimental + Hero) and Seconds < (Tech2 + Tech3 + Elite + Experimental + Hero + Titan) then
			Sync.Techlevel6 = false
			Sync.Techlevel7 = true
			Sync.TTitanWaitTime=Tech2+Tech3+Elite+Experimental+Hero+Titan
			end
			if Seconds > (Tech2 + Tech3 + Elite + Experimental + Hero + Titan) then
			Sync.ClosePanel = true
			end
		WaitSeconds(1)
		end
		
		end)
		
		
		WaitSeconds(Tech2)
        RemoveBuildRestriction(self:GetArmyIndex(), categories.TECH2 + categories.ALLUNITS - categories.TECH3 - categories.EXPERIMENTAL - categories.ELITE - categories.HERO - categories.TITAN )
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end
		
		WaitSeconds(Tech3)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.TECH3 + categories.ALLUNITS - categories.EXPERIMENTAL - categories.ELITE - categories.HERO - categories.TITAN)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end

		WaitSeconds(Elite)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.ELITE + categories.ALLUNITS - categories.EXPERIMENTAL - categories.HERO - categories.TITAN)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end

		WaitSeconds(Experimental)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.ELITE + categories.ALLUNITS - categories.HERO - categories.TITAN)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end

		WaitSeconds(Hero)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.HERO + categories.ALLUNITS - categories.TITAN)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end

		WaitSeconds(Titan)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.TITAN + categories.ALLUNITS)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end
		else
		
		ForkThread( function()
		while true do
			local MathFloor = math.floor
			local hours = MathFloor(GetGameTimeSeconds() / 3600)
			local Seconds = GetGameTimeSeconds() - hours * 3600
			if Seconds < Tech2 then
			Sync.Techlevel2 = true
			Sync.T2WaitTime=Tech2
			end
			if Seconds > Tech2 and Seconds < (Tech2 + Tech3) then
			Sync.Techlevel2 = false
			Sync.Techlevel3 = true
			Sync.T3WaitTime=Tech2+Tech3
			end
			if Seconds > (Tech2 + Tech3) and Seconds < (Tech2 + Tech3 + Experimental) then
			Sync.Techlevel3 = false
			Sync.Techlevel5 = true
			Sync.TEXPWaitTime=Tech2+Tech3+Experimental
			end
			if Seconds > (Tech2 + Tech3 + Experimental) then
			Sync.ClosePanel = true
			end
		WaitSeconds(1)
		end
		
		end)
		
		
		WaitSeconds(Tech2)
        RemoveBuildRestriction(self:GetArmyIndex(), categories.TECH2 + categories.ALLUNITS - categories.TECH3 - categories.EXPERIMENTAL)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end
		WaitSeconds(Tech3)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.TECH3 + categories.ALLUNITS - categories.EXPERIMENTAL)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end
		WaitSeconds(Experimental)
		RemoveBuildRestriction(self:GetArmyIndex(), categories.EXPERIMENTAL + categories.ALLUNITS)
		if CSKPath then
		self:ForkThread(self.CSKGetOptions, Centers, Storages, HQCenter)
		else
		
		end

		end
		else
		
		end
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