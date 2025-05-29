local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then


#****************************************************************************
#**
#**  File     :  /lua/AI/aiarchetype-rushland.lua
#**
#**  Summary  : Rush AI
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AIBuildUnits = import('/lua/ai/aibuildunits.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')

local AIAddBuilderTable = import('/lua/ai/AIAddBuilderTable.lua')

function GetHighestBuilder(aiBrain)
    local returnVal = -1
    local base = false

    local returnVal = 0
    local aiType = false
    
    for k,v in BaseBuilderTemplates do
        if v.FirstBaseFunction then
            local baseVal, baseType = v.FirstBaseFunction(aiBrain)
            #LOG( '*DEBUG: testing ' .. k .. ' - Val ' .. baseVal )
            if baseVal > returnVal then
                returnVal = baseVal
                base = k
                aiType = baseType
            end
        end
    end
    
    if base then
        return base, returnVal, aiType
    end
    
    return false
end

function EvaluatePlan( aiBrain )
    local base, returnVal = GetHighestBuilder(aiBrain)
    
    return returnVal
end


function ExecutePlan(aiBrain)
	local Gametype = ScenarioInfo.type
	if Gametype == 'campaign' then
		
	else
    aiBrain:SetConstantEvaluate(false)
    WaitSeconds(1)
    if not aiBrain.BuilderManagers.MAIN.FactoryManager:HasBuilderList() then
        aiBrain:SetResourceSharing(true)

        aiBrain:SetupUnderEnergyStatTrigger(0.1)
        aiBrain:SetupUnderMassStatTrigger(0.1)
        
        SetupMainBase(aiBrain)
        
        # Get units out of pool and assign them to the managers
        local mainManagers = aiBrain.BuilderManagers.MAIN
        
        local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
        for k,v in pool:GetPlatoonUnits() do
            if EntityCategoryContains( categories.ENGINEER, v ) then
                mainManagers.EngineerManager:AddUnit(v)
            elseif EntityCategoryContains( categories.FACTORY * categories.STRUCTURE, v ) then
                mainManagers.FactoryManager:AddFactory( v )
            end
        end

        ForkThread(UnitCapWatchThread, aiBrain)
    end
    if aiBrain.PBM then
        aiBrain:PBMSetEnabled(false)
    end
	end
end

function SetupMainBase(aiBrain)
    local base, returnVal, baseType = GetHighestBuilder(aiBrain)

    local per = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
    if per != 'adaptive' then
        ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality = baseType
    end

    #LOG('*AI DEBUG: ARMY ', repr(aiBrain:GetArmyIndex()), ': Initiating Archetype using ' .. base)
    AIAddBuilderTable.AddGlobalBaseTemplate(aiBrain, 'MAIN', base)
    aiBrain:ForceManagerSort()
end

function UnitCapWatchThread(aiBrain)
    KillPD = false
    while true do
        WaitSeconds(60)
        if GetArmyUnitCostTotal(aiBrain:GetArmyIndex()) > (GetArmyUnitCap(aiBrain:GetArmyIndex()) - 10) then
            if not KillPD then
                local units = aiBrain:GetListOfUnits(categories.TECH1 * categories.ENERGYPRODUCTION * categories.STRUCTURE, true)
                for k, v in units do
                    v:Kill()
                end
                KillPD = true
            else

                local units = aiBrain:GetListOfUnits(categories.TECH1 * categories.DEFENSE * categories.DIRECTFIRE * categories.STRUCTURE, true)
                for k, v in units do
                    v:Kill()
                end
                KillPD = false
            end
        end
    end
end

else

end
