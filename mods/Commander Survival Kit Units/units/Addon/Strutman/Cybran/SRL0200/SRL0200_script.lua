#****************************************************************************
#**
#**  File     :  /cdimage/units/DRL0204/DRL0204_script.lua
#**  Author(s):  Dru Staltman, Eric Williamson
#**
#**  Summary  :  Cybran Rocket Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CDFRocketIridiumWeapon = CybranWeaponsFile.CDFRocketIridiumWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')


SRL0200 = Class(CWalkingLandUnit) {
    Weapons = {
        MissileWeapon = Class(CDFRocketIridiumWeapon) {
		OnWeaponFired = function(self)
			ForkThread( function()	
			self.unit.Launch = true
			WaitSeconds(0.3)
			self.unit:HideBone('Scud', true)    
			self.unit.Launch = false			
			end)
		end,
		},
		MissileDirectWeapon = Class(CDFRocketIridiumWeapon) {
		OnWeaponFired = function(self)
			ForkThread( function()	
			self.unit.Launch = true
			WaitSeconds(0.3)
			self.unit:HideBone('Scud', true)    
			self.unit.Launch = false			
			end)
		end,
		},
    },
	
	OnCreate = function(self)
        CWalkingLandUnit.OnCreate(self)
		self.MissileWeapon = self:GetWeaponByLabel('MissileWeapon')
		self.MissileDirectWeapon = self:GetWeaponByLabel('MissileDirectWeapon')
		self.MissileWeapon:SetEnabled(true)
		self.MissileDirectWeapon:SetEnabled(false)
		ForkThread( function()	
		self.LaunchEffect = false
		while true do
		if self.Launch == false then
		WaitSeconds(45)
		if not self:IsDead() then 
		self:ShowBone('Scud', true)
		end
		end
		WaitSeconds(0.1)
		end
		end)
    end,
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self.MissileWeapon:SetEnabled(false)
		self.MissileDirectWeapon:SetEnabled(true)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self.MissileWeapon:SetEnabled(true)
		self.MissileDirectWeapon:SetEnabled(false)
        end
    end,
	
    
}

TypeClass = SRL0200
