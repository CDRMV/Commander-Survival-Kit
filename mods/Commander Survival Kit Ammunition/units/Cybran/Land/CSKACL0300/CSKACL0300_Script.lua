#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0202/URL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/defaultunits.lua').MobileUnit
local AIUtils = import('/lua/ai/aiutilities.lua')

CSKACL0300 = Class(CLandUnit) {
OnStopBeingBuilt = function(self,builder,layer)
		CLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.AmmunitionStorage = self:GetBlueprint().Economy.Ammunition.AmmunitionStorage
		self.MaxAmmunitionStorage = self:GetBlueprint().Economy.Ammunition.MaxAmmunitionStorage
		self:ForkThread(self.UnitsNeedsAmmoThread)
    end,

	UnitsNeedsAmmoThread = function(self)
		while not self:IsDead() do
            local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.LAND + categories.MOBILE - categories.AMMUNITIONREFUELUNIT,
			self:GetPosition(), 
			15
			
			)
            for _,unit in units do
			if unit.CurrentAmmunition == nil and unit.MaxAmmunition == nil then
			
			else
			
			if unit.CurrentAmmunition < unit.MaxAmmunition then
			unit.CurrentAmmunition = unit.CurrentAmmunition + 1
			self.AmmunitionStorage = self.AmmunitionStorage - 1
			FloatingEntityText(unit:GetEntityId(), tostring(unit.CurrentAmmunition) ..'/' .. tostring(unit.MaxAmmunition))
			FloatingEntityText(self:GetEntityId(), tostring(self.AmmunitionStorage) ..'/' .. tostring(self.MaxAmmunitionStorage))
			end
			end
			end
		WaitSeconds(1)	
		end	
    end,
	
}

TypeClass = CSKACL0300