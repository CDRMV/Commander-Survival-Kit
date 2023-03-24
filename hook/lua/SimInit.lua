do

local TTT_Path = import('/lua/game.lua').TTT_ModPath
local TTTSimFile = TTT_Path..'/TimeSelection_Sim.lua'
local oldBeginSession = BeginSession
function BeginSession()
    oldBeginSession()
    ForkThread( import(TTTSimFile).InitUnlockTechOverTime )
end 

end