local ResearchAIBrain = AIBrain 

AIBrain = Class(ResearchAIBrain) {
    OnCreateHuman = function(self, planName)
    	ResearchAIBrain.OnCreateHuman(self)
		self:ForkThread(self.AbilityGeneratedThread)
		self:ForkThread(self.AbilityCollectThread)
		ForkThread(import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').BrainCheck, self)
		ForkThread(import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').BrainCheck, self)
    end,
	
    #Abilites from research labs
    AbilityGeneratedThread = function(self)
		local count = 0
        while true do
			local labs = self:GetListOfUnits(categories.COMMANDCENTER, true)
			if table.getn(labs) == 0 then
			    count = 0
				Sync.ResearchLabsCount = count
				LOG('Test:', count)
				RemoveBuildRestriction(self:GetArmyIndex(), categories.COMMANDCENTER)
			elseif table.getn(labs) == 1 then
			    count = 1
				Sync.ResearchLabsCount = count
				LOG('Test:', count)		
				RemoveBuildRestriction(self:GetArmyIndex(), categories.COMMANDCENTER)
			elseif table.getn(labs) == 2 then
			    count = 2
				Sync.ResearchLabsCount = count
				LOG('Test:', count)		
				RemoveBuildRestriction(self:GetArmyIndex(), categories.COMMANDCENTER)
			elseif table.getn(labs) == 3 then
			    count = 3
				Sync.ResearchLabsCount = count
				LOG('Test:', count)		
				RemoveBuildRestriction(self:GetArmyIndex(), categories.COMMANDCENTER)
			elseif table.getn(labs) == 4 then
			    count = 4
				Sync.ResearchLabsCount = count
				LOG('Test:', count)		
				RemoveBuildRestriction(self:GetArmyIndex(), categories.COMMANDCENTER)
			elseif table.getn(labs) == 5 then
			    count = 5
				Sync.ResearchLabsCount = count
				LOG('Test:', count)		
				AddBuildRestriction(self:GetArmyIndex(), categories.COMMANDCENTER)
			end
            WaitSeconds(1)
        end
    end,
		
    #Abilites counts from kills
    AbilityCollectThread = function(self)
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