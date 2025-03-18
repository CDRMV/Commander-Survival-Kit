local GetCSKTimeosPath = function() for i, mod in __active_mods do if mod.name == "Commander Survival Kit Timeos" then return mod.location end end end
local CSKTimeosPath = GetCSKTimeosPath()

do
test = 0

function CurrentTacticalPointsHandle(value)
test = value
end
ArmyBrains = {}
Area = {
	x0 = 0,
	y0 = 0,
	x1 = 0,
	y1 = 0,
}
local SimFile = '/mods/Commander Survival Kit/UI/campaignconfig_sim.lua'

local oldBeginSession = BeginSession
function BeginSession()
    oldBeginSession()
	LOG('x0: ', Area.x0)
	LOG('y0: ', Area.y0)
	LOG('x1: ', Area.x1)
	LOG('y1: ', Area.y1)
	if ScenarioInfo.type == 'campaign' or ScenarioInfo.type == 'campaign_coop' then
	
	elseif ScenarioInfo.type == 'skirmish' then
	import('/lua/ScenarioFramework.lua').SetPlayableArea(Area, true)
	end
	import('/mods/Commander Survival Kit/UI/Layout/Values.lua').GetCSKManagerNumberValue(0)
	ForkThread(import(SimFile).CheckforCurrentTacticalPointsHandle)
    ForkThread(import(SimFile).CheckForPointStoragesIncluded)
	ForkThread(import(SimFile).CheckforPointGenerationCentersIncluded)
	ForkThread(import(SimFile).CheckforHQCommunicationCenterIncluded)
	ForkThread(import(SimFile).CheckforKillRewardIncluded)
	ForkThread(import(SimFile).CheckforAirStrikeMechanic)
	ForkThread(import(SimFile).CheckforAirStrikeOrigin)
	ForkThread(import(SimFile).CheckforDropDefenseOrigin)
	ForkThread(import(SimFile).CheckforAirRefOrigin)
	ForkThread(import(SimFile).CheckforLandRefOrigin)
	ForkThread(import(SimFile).CheckforNavalRefOrigin)
	Sync.Start = true
	Sync.Load = false
end

local oldOnPostLoad = OnPostLoad
function OnPostLoad()
    oldOnPostLoad()
	Sync.Start = false
	Sync.Load = true
	local humanIndex = 1
    for _, brain in ArmyBrains do
        if brain.BrainType == 'Human' then
			local HQComCenter = brain:GetListOfUnits(categories.HQCOMMUNICATIONCENTER, true)
			if table.getn(HQComCenter) >= 1 then
				Sync.HQComCenterDetected = true
			end
			local RefCenter = brain:GetListOfUnits(categories.COMMANDCENTER, true)
			if table.getn(RefCenter) == 1 then
				Sync.RefCenterDetected = true	
			elseif table.getn(RefCenter) == 2 then
				Sync.RefCenterDetected = true
			elseif table.getn(RefCenter) == 3 then
				Sync.RefCenterDetected = true		
			elseif table.getn(RefCenter) == 4 then
				Sync.RefCenterDetected = true		
			elseif table.getn(RefCenter) == 5 then
				Sync.RefCenterDetected = true
			end
			local TacCenter = brain:GetListOfUnits(categories.TACTICALCENTER, true)
			if table.getn(TacCenter) == 1 then
				Sync.TACCenterDetected = true	
			elseif table.getn(TacCenter) == 2 then
				Sync.TACCenterDetected = true
			elseif table.getn(TacCenter) == 3 then
				Sync.TACCenterDetected = true		
			elseif table.getn(TacCenter) == 4 then
				Sync.TACCenterDetected = true		
			elseif table.getn(TacCenter) == 5 then
				Sync.TACCenterDetected = true
			end
			local RefStorage = brain:GetListOfUnits(categories.COMMANDPOINTSTORAGE, true)
			if table.getn(RefStorage) == 1 then
				Sync.ReinforcementPointStorageLVL1 = true
				Sync.RefPointStorageDetected = true
			end
			local TacStorage = brain:GetListOfUnits(categories.TACTICALPOINTSTORAGE, true)
			if table.getn(TacStorage) == 1 then
				Sync.TacticalPointStorageLVL1 = true
				Sync.TACPointStorageDetected = true
			end
			local RefStorage2 = brain:GetListOfUnits(categories.COMMANDPOINTSTORAGELVL2, true)
			if table.getn(RefStorage2) == 1 then
				Sync.ReinforcementPointStorageLVL2 = true
				Sync.RefPointStorageDetected = true
			end
			local TacStorage2 = brain:GetListOfUnits(categories.TACTICALPOINTSTORAGELVL2, true)
			if table.getn(TacStorage2) == 1 then
				Sync.TacticalPointStorageLVL2 = true
				Sync.TACPointStorageDetected = true
			end
			local RefStorage3 = brain:GetListOfUnits(categories.COMMANDPOINTSTORAGELVL3, true)
			if table.getn(RefStorage3) == 1 then
				Sync.ReinforcementPointStorageLVL3 = true
				Sync.RefPointStorageDetected = true
			end
			local TacStorage3 = brain:GetListOfUnits(categories.TACTICALPOINTSTORAGELVL3, true)
			if table.getn(TacStorage3) == 1 then
				Sync.TacticalPointStorageLVL3 = true
				Sync.TACPointStorageDetected = true
			end
			local RefStorage4 = brain:GetListOfUnits(categories.COMMANDPOINTSTORAGELVL4, true)
			if table.getn(RefStorage4) == 1 then
				Sync.ReinforcementPointStorageLVL4 = true
				Sync.RefPointStorageDetected = true
			end
			local TacStorage4 = brain:GetListOfUnits(categories.TACTICALPOINTSTORAGELVL4, true)
			if table.getn(TacStorage4) == 1 then
				Sync.TacticalPointStorageLVL4 = true
				Sync.TACPointStorageDetected = true
			end
			local RefStorage5 = brain:GetListOfUnits(categories.COMMANDPOINTSTORAGELVL5, true)
			if table.getn(RefStorage5) == 1 then
				Sync.ReinforcementPointCountLVL5 = true
				Sync.RefPointStorageDetected = true
			end
			local TacStorage5 = brain:GetListOfUnits(categories.TACTICALPOINTSTORAGELVL5, true)
			if table.getn(TacStorage5) == 1 then
				Sync.TacticalPointStorageLVL5 = true
				Sync.TACPointStorageDetected = true
			end
        end
    end
end


end