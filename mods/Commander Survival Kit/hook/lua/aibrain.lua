local ResearchAIBrain = AIBrain 


AIBrain = Class(ResearchAIBrain) {
    OnCreateHuman = function(self, planName)
		local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.name == "Commander Survival Kit Units" then return mod.location end end end
		local CSKUnitsPath = GetCSKUnitsPath()
		
    	ResearchAIBrain.OnCreateHuman(self)
		self:ForkThread(self.CheckforHQCentersIncludedThread)
		if CSKUnitsPath then
		self:ForkThread(self.CheckforCSKUnitsHQCentersIncludedThread)
		else
		
		end
		self:ForkThread(self.CheckforCentersIncludedThread)
		self:ForkThread(self.CheckforPointStoragesIncludedThread)
		self:ForkThread(self.CheckforKillPointRewardsIncludedThread)
    end,
	
	CheckforCSKUnitsHQCentersIncludedThread = function(self)
			self:ForkThread(self.CheckCSKUnitsHQCenterStep1)
    end,

	
	CheckforCentersIncludedThread = function(self)
		local Centers = ScenarioInfo.Options.CentersIncluded
        if Centers == 1 then
            RemoveBuildRestriction(self:GetArmyIndex(), categories.COMMANDCENTER)
			RemoveBuildRestriction(self:GetArmyIndex(), categories.TACTICALCENTER)
			self:ForkThread(self.GetCommandCenterPointsThread)
			self:ForkThread(self.GetTacticalCenterPointsThread)
			self:ForkThread(self.CheckRefCenterStep1)
			self:ForkThread(self.CheckTacCenterStep1)
        elseif Centers == 2 then 
            AddBuildRestriction(self:GetArmyIndex(), categories.COMMANDCENTER)
			AddBuildRestriction(self:GetArmyIndex(), categories.TACTICALCENTER)
		elseif Centers == nil then
			RemoveBuildRestriction(self:GetArmyIndex(), categories.COMMANDCENTER)
			RemoveBuildRestriction(self:GetArmyIndex(), categories.TACTICALCENTER)
			self:ForkThread(self.GetCommandCenterPointsThread)
			self:ForkThread(self.GetTacticalCenterPointsThread)
			self:ForkThread(self.CheckRefCenterStep1)
			self:ForkThread(self.CheckTacCenterStep1)
        end
    end,
	
	CheckforPointStoragesIncludedThread = function(self)
		local Storages = ScenarioInfo.Options.PointStorage
        if Storages == 1 then
            RemoveBuildRestriction(self:GetArmyIndex(), categories.COMMANDPOINTSTORAGE)
			RemoveBuildRestriction(self:GetArmyIndex(), categories.TACTICALPOINTSTORAGE)
			self:ForkThread(self.CheckRefPointStorageStep1)
			self:ForkThread(self.CheckTacPointStorageStep1)
        elseif Storages == 2 then 
            AddBuildRestriction(self:GetArmyIndex(), categories.COMMANDPOINTSTORAGE)
			AddBuildRestriction(self:GetArmyIndex(), categories.TACTICALPOINTSTORAGE)
		elseif Storages == nil then
			RemoveBuildRestriction(self:GetArmyIndex(), categories.COMMANDPOINTSTORAGE)
			RemoveBuildRestriction(self:GetArmyIndex(), categories.TACTICALPOINTSTORAGE)
			self:ForkThread(self.CheckRefPointStorageStep1)
			self:ForkThread(self.CheckTacPointStorageStep1)
        end
    end,
	
	CheckforHQCentersIncludedThread = function(self)
		local Centers = ScenarioInfo.Options.HQComCentersIncluded
        if Centers == 1 then
            RemoveBuildRestriction(self:GetArmyIndex(), categories.HQCOMMUNICATIONCENTER)
			self:ForkThread(self.CheckHQCenterStep1)
			self:ForkThread(self.CheckHQCenterStep2)
			Sync.HQComCenterDisabled = false
        elseif Centers == 2 then 
            AddBuildRestriction(self:GetArmyIndex(), categories.HQCOMMUNICATIONCENTER)
			Sync.HQComCenterDisabled = true
		elseif Centers == nil then
		    AddBuildRestriction(self:GetArmyIndex(), categories.HQCOMMUNICATIONCENTER)
			Sync.HQComCenterDisabled = true
			--RemoveBuildRestriction(self:GetArmyIndex(), categories.HQCOMMUNICATIONCENTER)
			--self:ForkThread(self.CheckHQCenterStep1)
			--self:ForkThread(self.CheckHQCenterStep2)
			--Sync.HQComCenterDisabled = false
        end
    end,
	
	CheckforKillPointRewardsIncludedThread = function(self)
		local KillPointRewards = ScenarioInfo.Options.KillPointsIncluded
        if KillPointRewards == 1 then
			self:ForkThread(self.GetKillPointsThread)
        else 

        end
    end,
	
    #Abilites from research labs
    GetCommandCenterPointsThread = function(self)
		local count = 0
        while true do
			local labs = self:GetListOfUnits(categories.COMMANDCENTER, true)
			if table.getn(labs) == 0 then
			    count = 0
				Sync.ReinforcementPointsCount = count
			elseif table.getn(labs) == 1 then
			    count = 1
				Sync.ReinforcementPointsCount = count	
			elseif table.getn(labs) == 2 then
			    count = 2
				Sync.ReinforcementPointsCount = count	
			elseif table.getn(labs) == 3 then
			    count = 3
				Sync.ReinforcementPointsCount = count		
			elseif table.getn(labs) == 4 then
			    count = 4
				Sync.ReinforcementPointsCount = count		
			elseif table.getn(labs) == 5 then
			    count = 5
				Sync.ReinforcementPointsCount = count	
			end
            WaitSeconds(1)
        end
    end,
	
	GetTacticalCenterPointsThread = function(self)
		local count = 0
        while true do
			local labs = self:GetListOfUnits(categories.TACTICALCENTER, true)
			if table.getn(labs) == 0 then
			    count = 0
				Sync.TacticalPointsCount = count
			elseif table.getn(labs) == 1 then
			    count = 1
				Sync.TacticalPointsCount = count	
			elseif table.getn(labs) == 2 then
			    count = 2
				Sync.TacticalPointsCount = count		
			elseif table.getn(labs) == 3 then
			    count = 3
				Sync.TacticalPointsCount = count		
			elseif table.getn(labs) == 4 then
			    count = 4
				Sync.TacticalPointsCount = count		
			elseif table.getn(labs) == 5 then
			    count = 5
				Sync.TacticalPointsCount = count	
			end
            WaitSeconds(1)
        end
    end,
	
	

	
	-- Integrate a Limit to the HQ Communication Centers to make them not buildable after 1
	-- If one or more are being destroyed the Center will be buildable agian. 
	
	CheckCSKUnitsHQCenterStep1 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.REINFORCEMENTCENTER, true)
			if table.getn(labs) >= 1 then
				AddBuildRestriction(self:GetArmyIndex(), categories.REINFORCEMENTCENTER)
				self:ForkThread(self.CheckCSKUnitsHQCenterStep2)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckCSKUnitsHQCenterStep2 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.REINFORCEMENTCENTER, true)
			if table.getn(labs) < 1  then
				RemoveBuildRestriction(self:GetArmyIndex(), categories.REINFORCEMENTCENTER)
				self:ForkThread(self.CheckCSKUnitsHQCenterStep1)
				break
			end
			WaitSeconds(1)
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
	
		
    #Abilites counts from kills
    GetKillPointsThread = function(self)
	    local ratio = 20
        while true do
			local unitKills = self:GetArmyStat("Enemies_Killed", 0.0).Value
			local acuKills = self:GetBlueprintStat("Enemies_Killed", categories.COMMAND)
			local subKills = self:GetBlueprintStat("Enemies_Killed", categories.SUBCOMMANDER)
			local expKills = self:GetBlueprintStat("Enemies_Killed", categories.EXPERIMENTAL)
			local colleted = unitKills/ratio + acuKills*10 + subKills*3 + expKills*2
			Sync.ResearchUpdatedAbilityCount = math.floor(colleted)
            WaitSeconds(1)
        end
    end,
	

} 