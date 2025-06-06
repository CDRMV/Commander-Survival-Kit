#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0202/UEL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Tank Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local AIUtils = import('/lua/ai/aiutilities.lua')
local Utils = import('/lua/utilities.lua')

CSKATLTest01 = Class(TLandUnit) {
    Weapons = {
        FrontTurret01 = Class(TDFGaussCannonWeapon) {
		OnWeaponFired = function(self)
			if self.unit.CurrentAmmunition == 0 then
			FloatingEntityText(self.unit:GetEntityId(), 'Runs out of Ammunition')
			self:SetEnabled(false)
			IssueClearCommands({self.unit})
			self.unit:SearchforAmmoRefuelUnitThread(self.unit)
			else
			self.unit.CurrentAmmunition = self.unit.CurrentAmmunition - 1
			if self.unit:GetScriptBit('RULEUTC_SpecialToggle') == false then
			
			elseif self.unit:GetScriptBit('RULEUTC_SpecialToggle') == true then
			import("/mods/Commander Survival Kit Ammunition/UI/Main.lua").UnitDialog(self.unit, tostring(self.unit.CurrentAmmunition) ..'/' .. tostring(self.unit.MaxAmmunition), true)
			end
			Sync.CurrentAmmunition = self.unit.CurrentAmmunition
			end
		end,
		
        }
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
		TLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.MaxAmmunition = self:GetBlueprint().Economy.Ammunition.MaxAmmunition
		self.CurrentAmmunition = self:GetBlueprint().Economy.Ammunition.CurrentAmmunition
		--self.Sync.CurrentAmmunition = self.CurrentAmmunition
		--Sync.UnitData[self:GetEntityId()].CurrentAmmunition = self.CurrentAmmunition
		self:ForkThread(self.UpdateAmmoValueThread)
		self:ForkThread(self.DisplayAmmoValueThread)
		self:ForkThread(self.UpdateButtonThread)
    end,
	
	UpdateAmmoValueThread = function(self)
	while true do
		if self.CurrentAmmunition > 0 then
		self:SetWeaponEnabledByLabel('FrontTurret01', true)
		end
	WaitSeconds(0.1)	
	end	
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
        TLandUnit.OnScriptBitSet(self, bit)
        if bit == 7 then
		local ammo = self.UpdateAmmoDialogValueThread(self.CurrentAmmunition)
		import("/mods/Commander Survival Kit Ammunition/UI/Main.lua").UnitDialog(self, tostring(ammo) ..'/' .. tostring(self.MaxAmmunition), true)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
        if bit == 7 then
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
			if self.CurrentAmmunition <= self.MaxAmmunition then
			if unit:GetScriptBit('RULEUTC_WeaponToggle') == true then
			if number == 0 then
			if self:GetScriptBit('RULEUTC_SpecialToggle') == true then
			Sync.CreateUnitDialogText = tostring(self.CurrentAmmunition) ..'/' .. tostring(self.MaxAmmunition)
			end
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

TypeClass = CSKATLTest01