#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0202/UAL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Aeon Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local ALandUnit = import('/lua/defaultunits.lua').MobileUnit
local ADFCannonQuantumWeapon = import('/lua/aeonweapons.lua').ADFCannonQuantumWeapon
local AIUtils = import('/lua/ai/aiutilities.lua')
local Utils = import('/lua/utilities.lua')

CSKAALTest01 = Class(ALandUnit) {

    Weapons = {
        MainGun = Class(ADFCannonQuantumWeapon) {
		OnWeaponFired = function(self)
			if self.unit.CurrentAmmunition == 0 then
			FloatingEntityText(self.unit:GetEntityId(), 'Runs out of Ammunition')
			self:SetEnabled(false)
			IssueClearCommands({self.unit})
			self.unit:SearchforAmmoRefuelUnitThread(self.unit)
			else
			self.unit.CurrentAmmunition = self.unit.CurrentAmmunition - 1	
			Sync.CurrentAmmunition = self.unit.CurrentAmmunition
			end
		end,
		}
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
		ALandUnit.OnStopBeingBuilt(self,builder,layer)
		self.MaxAmmunition = self:GetBlueprint().Economy.Ammunition.MaxAmmunition
		self.CurrentAmmunition = self:GetBlueprint().Economy.Ammunition.CurrentAmmunition
		Sync.CurrentAmmunition = self.CurrentAmmunition
		self:ForkThread(self.UpdateAmmoValueThread)
		self:ForkThread(self.DisplayAmmoValueThread)
    end,
	
	UpdateAmmoValueThread = function(self)
	while true do
		if self.CurrentAmmunition > 0 then
		self:SetWeaponEnabledByLabel('MainGun', true)
		end
	WaitSeconds(0.1)	
	end	
    end,
	
	SearchforAmmoRefuelUnitThread = function(self)
            local units = nil
			units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.AMMUNITIONREFUELUNIT,
			self:GetPosition(), 
			99999
			
			)
			
			for _,unit in units do

			if Utils.GetDistanceBetweenTwoEntities(unit, self) < 50 then
			if unit.AmmunitionStorage > 0 then
			unit:GetPosition()
			IssueMove({self}, unit)
			units = nil
			end
			end
			end
    end,  
	
	DisplayAmmoValueThread = function(self)
	while not self:IsDead() do
            local units = nil
			local number = 0
			units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.AMMUNITIONREFUELUNIT,
			self:GetPosition(), 
			15
			
			)
			
			for _,unit in units do
			if self.CurrentAmmunition < self.MaxAmmunition then
			if unit:GetScriptBit(2) == true then
			if number == 0 then
			FloatingEntityText(self:GetEntityId(), tostring(self.CurrentAmmunition) ..'/' .. tostring(self.MaxAmmunition))
			number = 1
			end
			else
			
			end
			end
			end
			WaitSeconds(1)	
			end
    end,
}
TypeClass = CSKAALTest01