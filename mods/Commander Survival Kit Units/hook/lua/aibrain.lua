local CenterAIBrain = AIBrain 

AIBrain = Class(CenterAIBrain) {
    OnCreateHuman = function(self, planName)
    	CenterAIBrain.OnCreateHuman(self)
		self:ForkThread(self.CheckforCSKUnitsHQCentersIncludedThread)
    end,
	
	CheckforCSKUnitsHQCentersIncludedThread = function(self)
			self:ForkThread(self.CheckCSKUnitsHQCenterStep1)
    end,

	
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

	

} 