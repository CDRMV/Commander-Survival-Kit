do

local function GetPointStoragesIncludedValue(data)

    local value = data.Args.selection

	if value == 1 then
    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
		RemoveBuildRestriction(GetFocusArmy(), categories.COMMANDPOINTSTORAGE)
		RemoveBuildRestriction(GetFocusArmy(), categories.TACTICALPOINTSTORAGE)
    end
	
	else
	    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
		AddBuildRestriction(GetFocusArmy(), categories.COMMANDPOINTSTORAGE)
		AddBuildRestriction(GetFocusArmy(), categories.TACTICALPOINTSTORAGE)
		end
	end
end

local function GetPointGenerationCentersIncludedValue(data)

    local value = data.Args.selection

	if value == 1 then
    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
		RemoveBuildRestriction(GetFocusArmy(), categories.COMMANDCENTER)
		RemoveBuildRestriction(GetFocusArmy(), categories.TACTICALCENTER)
    end
	
	else
	    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
		AddBuildRestriction(GetFocusArmy(), categories.COMMANDCENTER)
		AddBuildRestriction(GetFocusArmy(), categories.TACTICALCENTER)
		end
	end
end

local function GetHQCommunicationCenterIncludedValue(data)

    local value = data.Args.selection
	LOG('value', value)
	if value == 1 then
    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
		RemoveBuildRestriction(GetFocusArmy(), categories.HQCOMMUNICATIONCENTER)
		Sync.HQComCenterDisabled = false
    end
	
	else
	    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
		AddBuildRestriction(GetFocusArmy(), categories.HQCOMMUNICATIONCENTER)
		Sync.HQComCenterDisabled = true
		end
	end
end

function CheckForPointStoragesIncluded()

import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforPointStoragesIncluded", GetPointStoragesIncludedValue)


end

function CheckforPointGenerationCentersIncluded()

import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforPointGenerationCentersIncluded", GetPointGenerationCentersIncludedValue)


end

function CheckforHQCommunicationCenterIncluded()

import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforHQCommunicationCenterIncluded", GetHQCommunicationCenterIncludedValue)


end





end