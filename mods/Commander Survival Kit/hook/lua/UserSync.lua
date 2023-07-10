#****************************************************************************
#**
#**  File     :  /hook/lua/UserSync.lua
#**  Author(s):  novaprim3
#**
#**  Summary  :  Multi-Phantom Mod for Forged Alliance
#**
#****************************************************************************

local ResearchOnSync = OnSync
function OnSync()
	ResearchOnSync ()
	
	# research abilities from kill counts
	if Sync.ResearchUpdatedAbilityCount then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').CollectedAbility(Sync.ResearchUpdatedAbilityCount)
	end
	
	# abilities from research labs
	if Sync.ResearchLabsCount then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').ResearchLabHandle(Sync.ResearchLabsCount)
	end
end
