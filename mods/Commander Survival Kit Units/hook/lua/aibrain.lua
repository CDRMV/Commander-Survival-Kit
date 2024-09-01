local CenterAIBrain = AIBrain 

AIBrain = Class(CenterAIBrain) {
    OnCreateHuman = function(self, planName)
    	CenterAIBrain.OnCreateHuman(self)
		self:ForkThread(self.CenterThread)
    end,
	
	CenterThread = function(self)
			self:ForkThread(self.CheckRefCenterStep1)
    end,

	
	CheckRefCenterStep1 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.REINFORCEMENTCENTER, true)
			if table.getn(labs) >= 1 then
				AddBuildRestriction(self:GetArmyIndex(), categories.REINFORCEMENTCENTER)
				self:ForkThread(self.CheckRefCenterStep2)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckRefCenterStep2 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.REINFORCEMENTCENTER, true)
			if table.getn(labs) < 1  then
				RemoveBuildRestriction(self:GetArmyIndex(), categories.REINFORCEMENTCENTER)
				self:ForkThread(self.CheckRefCenterStep1)
				break
			end
			WaitSeconds(1)
			end
    end,

	

} 