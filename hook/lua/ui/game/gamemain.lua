do

local TTT_Path = import('/lua/game.lua').TTT_ModPath
local oldCreateUI = CreateUI 
function CreateUI(isReplay) 
    oldCreateUI(isReplay) 
    import(TTT_Path..'/TimeSelection.lua').InitTechOverTimeUI()
end

end