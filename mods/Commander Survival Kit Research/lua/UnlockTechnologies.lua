
local aiThread
local uiThread
local ifnoThread
	
#only human runs these stuffs
BrainCheck = function(brain)
	WaitSeconds(5)
	aiBrain = brain
	ForkThread(ResearchLabAIThread, aiBrain)
end
	

UnlockTech2 = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH2)
end

UnlockTech3 = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH3)
end

UnlockTech2Structures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH2 * categories.STRUCTURE * categories.FACTORY)
	import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH2 * categories.ENGINEER)
end

UnlockTech2EconomyStructures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH2 * categories.STRUCTURE * categories.ECONOMY)
end

UnlockTech2IntelStructures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH2 * categories.STRUCTURE * categories.INTELLIGENCE)
end

UnlockTech2DefenseStructures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH2 * categories.STRUCTURE * categories.DEFENSE * categories.SHIELD)
	import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH2 * categories.STRUCTURE * categories.DEFENSE * categories.ANTIMISSILE)
end

UnlockTech2DirectfireDefenseStructures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH2 * categories.STRUCTURE * categories.DEFENSE * categories.DIRECTFIRE)
end

UnlockTech2AADefenseStructures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH2 * categories.STRUCTURE * categories.DEFENSE * categories.ANTIAIR)
end

UnlockTech2ArtilleryStructures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH2 * categories.STRUCTURE * categories.DEFENSE * categories.ARTILLERY)
end

UnlockTech2MissileStructures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH2 * categories.STRUCTURE * categories.DEFENSE * categories.TACTICALMISSILEPLATFORM)
end

UnlockTech3Structures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH3 * categories.STRUCTURE * categories.FACTORY)
	import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH3 * categories.ENGINEER)
end


UnlockTech3EconomyStructures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH3 * categories.STRUCTURE * categories.ECONOMY)
end

UnlockTech3IntelStructures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH3 * categories.STRUCTURE * categories.INTELLIGENCE)
end

UnlockTech3DefenseStructures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH3 * categories.STRUCTURE * categories.DEFENSE * categories.SHIELD)
	import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH3 * categories.STRUCTURE * categories.DEFENSE * categories.ANTIMISSILE)
end

UnlockTech3DirectfireDefenseStructures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH3 * categories.STRUCTURE * categories.DEFENSE * categories.DIRECTFIRE)
end

UnlockTech3AADefenseStructures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH3 * categories.STRUCTURE * categories.DEFENSE * categories.ANTIAIR)
end

UnlockTech3ArtilleryStructures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH3 * categories.STRUCTURE * categories.DEFENSE * categories.ARTILLERY)
end

UnlockTech3MissileStructures = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.TECH3 * categories.STRUCTURE * categories.DEFENSE * categories.TACTICALMISSILEPLATFORM)
end


UnlockExperimental = function()
    import('/lua/ScenarioFramework.lua').RemoveRestriction(aiBrain:GetArmyIndex(), categories.EXPERIMENTAL)
end
	
ResearchLabUIThread = function()
    uiThread = ForkThread(function() 
	    while true do
    		local labs = aiBrain:GetListOfUnits(categories.RESEARCHCENTER, false)
			if labs then
			    if table.getn(labs) > 0 then
				    for k,v in labs do
					    if v:GetFractionComplete() == 1 then
						    Sync.HasResearchLab = true
							if not ifnoThread then
							    ForkThread(IfNoResearchLabThread, aiBrain)
							end
							KillThread(uiThread)
							uiThread = nil
						end
					end
				end
			end
			WaitSeconds(1)
		end
	end)
end

ResearchLabAIThread = function(self)
    aiThread = ForkThread(function() 
	    while true do
		    local labs = self:GetListOfUnits(categories.RESEARCHCENTER, false)
			if labs then
			    if table.getn(labs) > 0 then
				    for k,v in labs do
					    if v:GetFractionComplete() == 1 then
						    Sync.HasResearchLab = true
							if not ifnoThread then
							    ForkThread(IfNoResearchLabThread, self)
							end
							KillThread(aiThread)
							aiThread = nil
						end
					end
				end
			end
			WaitSeconds(1)
		end
	end)
end
	
IfNoResearchLabThread = function(self)
    ifnoThread = ForkThread(function()
	    while true do
		    local labs = self:GetListOfUnits(categories.RESEARCHCENTER, false)
			if labs then
			    if table.getn(labs) == 0 then
				    Sync.LostResearchLab = true
					if not aiThread then
					    ForkThread(ResearchLabAIThread, self)
					end
					KillThread(ifnoThread)
					ifnoThread = nil
				end
			end
			WaitSeconds(2)
		end
	end)
end
	