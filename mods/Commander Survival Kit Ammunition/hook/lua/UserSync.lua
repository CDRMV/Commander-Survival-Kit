
local OldOnSync = OnSync
function OnSync()
	OldOnSync ()
	
	if Sync.CurrentAmmunition then
		--LOG(Sync.CurrentAmmunition)
		import('/lua/ui/game/unitview.lua')
	end
	
	if Sync.CurrentAmmunitionStorage then
		--LOG(Sync.CurrentAmmunitionStorage)
		import('/lua/ui/game/unitview.lua')
	end
	
	if Sync.CreateUnitDialogText then
	import('/mods/Commander Survival Kit Ammunition/UI/info.lua').UpdateUIText(Sync.CreateUnitDialogText)
	end
	
	if Sync.ManageUnitDialog == true then
	import('/mods/Commander Survival Kit Ammunition/UI/info.lua').ManageUI(true)
	elseif Sync.ManageUnitDialog == false then
	import('/mods/Commander Survival Kit Ammunition/UI/info.lua').ManageUI(false)
	end
	
	if Sync.EnableButton then
	import('/lua/ui/game/unittext.lua')
	end
	
	
	
end
