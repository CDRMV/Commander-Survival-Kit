do

local SimFile = '/mods/Commander Survival Kit/UI/campaignconfig_sim.lua'
local oldBeginSession = BeginSession
function BeginSession()
    oldBeginSession()
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