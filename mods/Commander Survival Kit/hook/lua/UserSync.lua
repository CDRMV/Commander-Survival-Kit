#****************************************************************************
#**
#**  File     :  /hook/lua/UserSync.lua
#**  Author(s):  novaprim3
#**
#**  Summary  :  Multi-Phantom Mod for Forged Alliance
#**
#****************************************************************************

local AirStrikeAmount = nil
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
	
	if Sync.ReinforcementPointStorageCountLVL1 == true then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').ReinforcementPointStorageHandle(1000)
	elseif Sync.ReinforcementPointStorageCountLVL1 == false then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').ReinforcementPointStorageHandle(-1000)
	else
	
	end
	
	if Sync.ReinforcementPointStorageCountLVL2 == true then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').ReinforcementPointStorageHandle(1000)
	elseif Sync.ReinforcementPointStorageCountLVL2 == false then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').ReinforcementPointStorageHandle(-2000)
	else
	
	end
	
	if Sync.ReinforcementPointStorageCountLVL3 == true then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').ReinforcementPointStorageHandle(1000)
	elseif Sync.ReinforcementPointStorageCountLVL3 == false then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').ReinforcementPointStorageHandle(-3000)
	else
	
	end
	
	if Sync.ReinforcementPointStorageCountLVL4 == true then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').ReinforcementPointStorageHandle(1000)
	elseif Sync.ReinforcementPointStorageCountLVL4 == false then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').ReinforcementPointStorageHandle(-4000)
	else
	
	end
	
	if Sync.ReinforcementPointStorageCountLVL5 == true then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').ReinforcementPointStorageHandle(1000)
	elseif Sync.ReinforcementPointStorageCountLVL5 == false then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').ReinforcementPointStorageHandle(-5000)
	else
	
	end
	
	if Sync.TacticalPointStorageCountLVL1 == true then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').TacticalPointStorageHandle(1000)
	elseif Sync.TacticalPointStorageCountLVL1 == false then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').TacticalPointStorageHandle(-1000)
	else
	
	end
	
	if Sync.TacticalPointStorageCountLVL2 == true then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').TacticalPointStorageHandle(1000)
	elseif Sync.TacticalPointStorageCountLVL2 == false then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').TacticalPointStorageHandle(-2000)
	else
	
	end
	
	if Sync.TacticalPointStorageCountLVL3 == true then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').TacticalPointStorageHandle(1000)
	elseif Sync.TacticalPointStorageCountLVL3 == false then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').TacticalPointStorageHandle(-3000)
	else
	
	end
	
	if Sync.TacticalPointStorageCountLVL4 == true then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').TacticalPointStorageHandle(1000)
	elseif Sync.TacticalPointStorageCountLVL4 == false then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').TacticalPointStorageHandle(-4000)
	else
	
	end
	
	if Sync.TacticalPointStorageCountLVL5 == true then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').TacticalPointStorageHandle(1000)
	elseif Sync.TacticalPointStorageCountLVL5 == false then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').TacticalPointStorageHandle(-5000)
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
	
	if Sync.RefUnitCapReached then
		import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').CheckUnitCapReached(Sync.RefUnitCapReached)
	else
	
	end
	
	if Sync.DropUnitCapReached then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').CheckUnitCapReached(Sync.DropUnitCapReached)
	else
	
	end
	
	if Sync.TransferSaveArray then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').GetCampaignOptions(Sync.TransferSaveArray)
		import('/mods/Commander Survival Kit/UI/campaignconfig.lua').LoadPreviousSavedOptions(true, Sync.TransferSaveArray)
	else
	
	end
	
	
end
