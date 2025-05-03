#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0304/UEL0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Heavy Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local AIUtils = import('/lua/ai/aiutilities.lua')

CSKATL0300 = Class(TLandUnit) {
	
	OnStopBeingBuilt = function(self,builder,layer)
		TLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.AmmunitionStorage = 500
		self.MaxAmmunitionStorage = 500
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
			if unit.Ammunition == nil and unit.MaxAmmunition == nil then
			
			else
			
			if unit.Ammunition < unit.MaxAmmunition then
			unit.Ammunition = unit.Ammunition + 1
			self.AmmunitionStorage = self.AmmunitionStorage - 1
			FloatingEntityText(unit:GetEntityId(), tostring(unit.Ammunition) ..'/' .. tostring(unit.MaxAmmunition))
			FloatingEntityText(self:GetEntityId(), tostring(self.AmmunitionStorage) ..'/' .. tostring(self.MaxAmmunitionStorage))
			end
			end
			end
		WaitSeconds(1)	
		end	
    end,
	

}

TypeClass = CSKATL0300