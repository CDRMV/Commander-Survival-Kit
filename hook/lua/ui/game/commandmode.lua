----
local legacy = OnCommandIssued --hook to the og codes 
local currentClickLocation = {} 

---- 
---- 

OnCommandIssued = function(command) --the og codes
	legacy(command)
	currentClickLocation[1] = command.Target.Position 
end
 
ClickListener = function()
	return currentClickLocation
end

doscript('/mods/Reinforcement Manager/UI/Reinforcements/ReinforcementManager.lua')