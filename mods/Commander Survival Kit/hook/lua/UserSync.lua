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
	if Sync.ReinforcementPointsCount then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').CommandCenterPointsHandle(Sync.ReinforcementPointsCount)
	end
	
	if Sync.TacticalPointsCount then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').TacticalCenterPointsHandle(Sync.TacticalPointsCount)
	end
end
