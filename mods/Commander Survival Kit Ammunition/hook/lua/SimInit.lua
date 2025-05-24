

do

local SimFile = '/mods/Commander Survival Kit Ammunition/UI/info_sim.lua'

local oldBeginSession = BeginSession
function BeginSession()
    oldBeginSession()
	ForkThread(import(SimFile).CheckEnableButton)

end




end