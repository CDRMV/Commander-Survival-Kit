local ResearchAIBrain = AIBrain 

AIBrain = Class(ResearchAIBrain) {
    OnCreateHuman = function(self, planName)
    	ResearchAIBrain.OnCreateHuman(self)
		self:ForkThread(self.ResearchPointGeneratedThread)
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
			
} 