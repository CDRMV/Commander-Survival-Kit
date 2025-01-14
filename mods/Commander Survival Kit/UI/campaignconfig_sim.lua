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

function CheckforAirStrikeOrigin()
import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforAirStrikeOrigin", GetforAirStrikeOrigin)


end

function CheckforDropDefenseOrigin()
import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforDropDefenseOrigin", GetforDropDefenseOrigin)
end

function CheckforAirRefOrigin()
import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforAirRefOrigin", GetforAirRefOrigin)
end

function CheckforLandRefOrigin()
import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforLandRefOrigin", GetforLandRefOrigin)
end

function CheckforNavalRefOrigin()
import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforNavalRefOrigin", GetforNavalRefOrigin)
end

function GetforAirStrikeOrigin(data)

    local value = data.Args.selection
	import('/lua/defaultunits.lua').GetAirStrikeOrigin(value)


end

function GetforDropDefenseOrigin(data)

    local value = data.Args.selection
	import('/lua/defaultunits.lua').GetDropDefenseOrigin(value)


end

function GetforAirRefOrigin(data)

    local value = data.Args.selection
	import('/lua/defaultunits.lua').GetAirRefOrigin(value)


end

function GetforLandRefOrigin(data)

    local value = data.Args.selection
	import('/lua/defaultunits.lua').GetLandRefOrigin(value)


end

function GetforNavalRefOrigin(data)

    local value = data.Args.selection
	import('/lua/defaultunits.lua').GetNavalRefOrigin(value)


end


function CheckforKillRewardIncluded(data)

    local value = data.Args.selection
	if value == 1 then
    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
		Sync.KillRewardIncluded = true
    end
	
	else
	    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
		Sync.KillRewardIncluded = false
		end
	end


end

function CheckforAirStrikeMechanic(data)

    local value = data.Args.selection
	if value == 1 then
    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
		Sync.AirStrikeMechanic = true
    end
	
	else
	    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
		Sync.AirStrikeMechanic = false
		end
	end


end




end

