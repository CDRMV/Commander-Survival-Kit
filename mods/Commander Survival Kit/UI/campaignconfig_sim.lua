do



local function CurrentTacticalPointsHandle(data)

    local value = data.Args.selection
import('/mods/Commander Survival Kit/UI/Layout/Values.lua').GetCurrentTacticalPointsHandle(value)

end

function CheckforCurrentTacticalPointsHandle()

import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforCurrentTacticalPointsHandle", CurrentTacticalPointsHandle)


end

local function CurrentReinforcementPointsHandle(data)

    local value = data.Args.selection
import('/mods/Commander Survival Kit/Lua/SimInit.lua').CurrentTacticalPointsHandle(value)

end

function CheckforCurrentReinforcementPointsHandle()

import('/lua/SimPlayerQuery.lua').AddQueryListener("CheckforCurrentReinforcementPointsHandle", CurrentTacticalPointsHandle)


end

local function GetPointStoragesIncludedValue(data)

    local value = data.Args.selection

	if value == 1 then
    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
			local RefPointStorage = ArmyBrains[GetFocusArmy()]:GetListOfUnits(categories.COMMANDPOINTSTORAGE, true)
			if table.getn(RefPointStorage) >= 1 then
				AddBuildRestriction(GetFocusArmy(), categories.COMMANDPOINTSTORAGE)
			else
				RemoveBuildRestriction(GetFocusArmy(), categories.COMMANDPOINTSTORAGE)
			end
			local TacPointStorage = ArmyBrains[GetFocusArmy()]:GetListOfUnits(categories.TACTICALPOINTSTORAGE, true)
			if table.getn(TacPointStorage) >= 1 then
				AddBuildRestriction(GetFocusArmy(), categories.TACTICALPOINTSTORAGE)
			else
				RemoveBuildRestriction(GetFocusArmy(), categories.TACTICALPOINTSTORAGE)
			end
			Sync.PointStoragesDisabled = 1
    end
	
	else
	    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
		AddBuildRestriction(GetFocusArmy(), categories.COMMANDPOINTSTORAGE)
		AddBuildRestriction(GetFocusArmy(), categories.TACTICALPOINTSTORAGE)
		Sync.PointStoragesDisabled = 2
		end
	end
end

local function GetPointGenerationCentersIncludedValue(data)

    local value = data.Args.selection

	if value == 1 then
    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
			local RefGenerationCenters = ArmyBrains[GetFocusArmy()]:GetListOfUnits(categories.COMMANDCENTER, true)
			if table.getn(RefGenerationCenters) >= 5 then
				AddBuildRestriction(GetFocusArmy(), categories.COMMANDCENTER)
			else
				RemoveBuildRestriction(GetFocusArmy(), categories.COMMANDCENTER)
			end
			local TacGenerationCenters = ArmyBrains[GetFocusArmy()]:GetListOfUnits(categories.TACTICALCENTER, true)
			if table.getn(TacGenerationCenters) >= 5 then
				AddBuildRestriction(GetFocusArmy(), categories.TACTICALCENTER)
			else
				RemoveBuildRestriction(GetFocusArmy(), categories.TACTICALCENTER)
			end
			Sync.PointGenerationCentersDisabled = 1
    end
	
	else
	    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
		AddBuildRestriction(GetFocusArmy(), categories.COMMANDCENTER)
		AddBuildRestriction(GetFocusArmy(), categories.TACTICALCENTER)
		Sync.PointGenerationCentersDisabled = 2
		end
	end
end

local function GetHQCommunicationCenterIncludedValue(data)

    local value = data.Args.selection
	LOG('value', value)
	if value == 1 then
    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
		local HQComCenter = ArmyBrains[GetFocusArmy()]:GetListOfUnits(categories.HQCOMMUNICATIONCENTER, true)
			if table.getn(HQComCenter) >= 1 then
				AddBuildRestriction(GetFocusArmy(), categories.HQCOMMUNICATIONCENTER)
			else
				RemoveBuildRestriction(GetFocusArmy(), categories.HQCOMMUNICATIONCENTER)
			end
		Sync.HQComCenterDisabled = false
		Sync.HQComCenterDisabled2 = 1
    end
	
	else
	    if ArmyBrains[GetFocusArmy()].BrainType == 'Human' and not ArmyIsOutOfGame(GetFocusArmy()) then
		AddBuildRestriction(GetFocusArmy(), categories.HQCOMMUNICATIONCENTER)
		Sync.HQComCenterDisabled = true
		Sync.HQComCenterDisabled2 = 2
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

