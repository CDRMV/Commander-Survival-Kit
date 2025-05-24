#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0201/UAL0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Light Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AHoverLandUnit = import('/lua/defaultunits.lua').MobileUnit
local AIUtils = import('/lua/ai/aiutilities.lua')

CSKAAL0100 = Class(AHoverLandUnit) {

	OnStopBeingBuilt = function(self,builder,layer)
		AHoverLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.AmmunitionStorage = self:GetBlueprint().Economy.Ammunition.AmmunitionStorage
		self.MaxAmmunitionStorage = self:GetBlueprint().Economy.Ammunition.MaxAmmunitionStorage
		self:SetScriptBit('RULEUTC_WeaponToggle', true)
		self:ForkThread(self.UpdateButtonThread)
    end,
	
	UpdateButtonThread = function(self)
	while true do
	import("/mods/Commander Survival Kit Ammunition/UI/Main.lua").ManageButton(self)
	WaitSeconds(0.1)	
	end	
    end,
	
	
	
	
	UpdateAmmoDialogValueThread = function(value)
		LOG(value)
		return value	
    end,
	
	
	OnScriptBitSet = function(self, bit)
        AHoverLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self.AmmoRefuelThread = self:ForkThread(self.UnitsNeedsAmmoThread)
        end
		if bit == 7 then
		local ammo = self.UpdateAmmoDialogValueThread(self.AmmunitionStorage)
		import("/mods/Commander Survival Kit Ammunition/UI/Main.lua").UnitDialog(self, tostring(ammo) ..'/' .. tostring(self.MaxAmmunitionStorage), true)
        end
    end,

    OnScriptBitClear = function(self, bit)
        AHoverLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		KillThread(self.AmmoRefuelThread)
        end
		if bit == 7 then
        end
    end,

	UnitsNeedsAmmoThread = function(self)
		while not self:IsDead() do
			local number = 0
            local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.LAND + categories.MOBILE - categories.AMMUNITIONREFUELUNIT,
			self:GetPosition(), 
			15
			
			)
            for _,unit in units do
			if unit.CurrentAmmunition == nil and unit.MaxAmmunition == nil then
			
			else
			if self.AmmunitionStorage == 0 then 
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			else
			if unit.CurrentAmmunition < unit.MaxAmmunition then

			unit.CurrentAmmunition = unit.CurrentAmmunition + 1
			Sync.CurrentAmmunition = unit.CurrentAmmunition
			self.AmmunitionStorage = self.AmmunitionStorage - 1
			Sync.CurrentAmmunitionStorage = self.AmmunitionStorage
			if number == 0 then
			if self:GetScriptBit('RULEUTC_SpecialToggle') == true then
			Sync.CreateUnitDialogText = tostring(self.AmmunitionStorage) ..'/' .. tostring(self.MaxAmmunitionStorage)
			end
			number = 1
			end
			end
			end
			end
			end
		WaitSeconds(1)	
		end	
    end,

}
TypeClass = CSKAAL0100

