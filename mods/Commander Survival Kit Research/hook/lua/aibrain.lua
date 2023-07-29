local ResearchAIBrain = AIBrain 

AIBrain = Class(ResearchAIBrain) {
    OnCreateHuman = function(self, planName)
    	ResearchAIBrain.OnCreateHuman(self)
		self:ForkThread(self.ResearchPointGeneratedThread)
		self:ForkThread(self.ResearchPointCollectThread)
    end,
	
    #Abilites from research labs
    ResearchPointGeneratedThread = function(self)
		local count = 0
        while true do
			local labs = self:GetListOfUnits(categories.RESEARCHCENTER, true)
			if table.getn(labs) == 0 then
			    count = 0
				Sync.ResearchCentersCount = count
				LOG('Test:', count)
			elseif table.getn(labs) == 1 then
			    count = 1
				Sync.ResearchCentersCount = count
				LOG('Test:', count)		
			elseif table.getn(labs) == 2 then
			    count = 2
				Sync.ResearchCentersCount = count
				LOG('Test:', count)		
			elseif table.getn(labs) == 3 then
			    count = 3
				Sync.ResearchCentersCount = count
				LOG('Test:', count)		
			elseif table.getn(labs) == 4 then
			    count = 4
				Sync.ResearchCentersCount = count
				LOG('Test:', count)		
			elseif table.getn(labs) == 5 then
			    count = 5
				Sync.ResearchCentersCount = count
				LOG('Test:', count)		
			end
            WaitSeconds(10)
        end
    end,
		
    #Abilites counts from kills
    ResearchPointCollectThread = function(self)
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