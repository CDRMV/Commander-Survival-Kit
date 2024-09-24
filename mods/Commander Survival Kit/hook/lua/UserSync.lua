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
	
	if Sync.ReinforcementPointStorageCount == true then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').ReinforcementPointStorageHandle(1000)
	elseif Sync.ReinforcementPointStorageCount == false then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').ReinforcementPointStorageHandle(-1000)
	else
	
	end
	
	if Sync.TacticalPointStorageCount == true then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').TacticalPointStorageHandle(1000)
	elseif Sync.TacticalPointStorageCount == false then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').TacticalPointStorageHandle(-1000)
	else
	
	end
	
	if Sync.CheckNoReinforcementPointStorageCount == true then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').ReinforcementPointStorageHandle(0)
	else
	
	end
	
	if Sync.CheckNoTacticalPointStorageCount == true then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').TacticalPointStorageHandle(0)
	else
	
	end
	
	if Sync.HQComCenterDetected == true then
		import('/mods/Commander Survival Kit/UI/Main.lua').HQComCenterDetected = true
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').HQComCenterDetected = true
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').HQComCenterDetected = true
	end
	
	if Sync.HQComCenterDetected == false then
		import('/mods/Commander Survival Kit/UI/Main.lua').HQComCenterDetected = false
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').HQComCenterDetected = false
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').HQComCenterDetected = false
	end
	
	if Sync.HQComCenterDisabled == true then
		import('/mods/Commander Survival Kit/UI/Main.lua').HQComCenterDisabled = true
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').HQComCenterDisabled = true
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').HQComCenterDisabled = true
	end
	
	if Sync.HQComCenterDisabled == false then
		import('/mods/Commander Survival Kit/UI/Main.lua').HQComCenterDisabled = false
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').HQComCenterDisabled = false
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').HQComCenterDisabled = false
	end
end
