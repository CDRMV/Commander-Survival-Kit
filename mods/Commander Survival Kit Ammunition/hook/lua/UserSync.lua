
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
	
end
