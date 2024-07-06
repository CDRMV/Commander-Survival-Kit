#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0304/UEA0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Strategic Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TIFSmallYieldNuclearBombWeapon = import('/lua/terranweapons.lua').TIFSmallYieldNuclearBombWeapon
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon

CSKTA0315 = Class(TAirUnit) {
    Weapons = {
		AntiAirMissileFlare = Class(TDFGaussCannonWeapon) {
		FxMuzzleFlashScale = 0.25,
		},
		DropFlare = Class(TDFGaussCannonWeapon) {
		FxMuzzleFlashScale = 0.25,
		},
        Bomb = Class(TIFSmallYieldNuclearBombWeapon) {
		OnWeaponFired = function(self)
		self.unit:SetWeaponEnabledByLabel('DropFlare', true)
		self.unit:SetWeaponEnabledByLabel('AntiAirMissileFlare', false)
		self.unit:GetWeaponByLabel'DropFlare':FireWeapon()
		self.unit:SetWeaponEnabledByLabel('DropFlare', false)
		self.unit:SetWeaponEnabledByLabel('AntiAirMissileFlare', true)
		end,
		},
    },
	
	CheckAntiAirUnitsThread = function(self)
		while true do
		local Pos = self:GetPosition()
        while not self:IsDead() do
            local units = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.ANTIAIR,
			self:GetPosition(), 
			50,
			'Enemy'
			
			)
            for _,unit in units do
				self:GetWeaponByLabel'AntiAirMissileFlare':FireWeapon()
            end
            
            WaitSeconds(7)
        end
		WaitSeconds(1)
		end
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
		self:SetWeaponEnabledByLabel('DropFlare', false)
		self.CheckAntiAirUnitsThreadHandle = self:ForkThread(self.CheckAntiAirUnitsThread)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
    end,
}

TypeClass = CSKTA0315
