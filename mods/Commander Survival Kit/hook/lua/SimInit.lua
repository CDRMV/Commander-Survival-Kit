do
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
end 

end