#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0111/UEL0111_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Missile Launcher Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local AIUtils = import('/lua/ai/aiutilities.lua')
CSKATL0200 = Class(TLandUnit) {

	OnStopBeingBuilt = function(self,builder,layer)
		TLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.AmmunitionStorage = self:GetBlueprint().Economy.Ammunition.AmmunitionStorage
		self.MaxAmmunitionStorage = self:GetBlueprint().Economy.Ammunition.MaxAmmunitionStorage
		self:SetScriptBit('RULEUTC_WeaponToggle', true)
    end,
	
	OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self.AmmoRefuelThread = self:ForkThread(self.UnitsNeedsAmmoThread)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		KillThread(self.AmmoRefuelThread)
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
			FloatingEntityText(self:GetEntityId(), tostring(self.AmmunitionStorage) ..'/' .. tostring(self.MaxAmmunitionStorage))
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

TypeClass = CSKATL0200