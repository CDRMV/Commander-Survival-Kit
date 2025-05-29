

do

local SimFile = '/mods/Commander Survival Kit Timeos/UI/campaignconfig_sim.lua'

local oldBeginSession = BeginSession
function BeginSession()
    oldBeginSession()
	if ScenarioInfo.type == 'campaign' then
	ForkThread(import(SimFile).CheckforT2WaitTime)
    ForkThread(import(SimFile).CheckforT3WaitTime)
	ForkThread(import(SimFile).CheckforEXPWaitTime)
	ForkThread(import(SimFile).CheckforEliteWaitTime)
    ForkThread(import(SimFile).CheckforHeroWaitTime)
	ForkThread(import(SimFile).CheckforTitanWaitTime)
	elseif ScenarioInfo.type == 'skirmish' or ScenarioInfo.type == 'campaign_coop'  then

	end

end

end