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
local CDFParticleCannonWeapon = import('/lua/cybranweapons.lua').CDFParticleCannonWeapon

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
		
		
		PlayFxWeaponUnpackSequence = function(self)
			self.unit:RemoveCommandCap('RULEUCC_Stop')
			self.unit:SetSpeedMult(0)
			if self.unit.number == 0 then
            local unpackAnimator = CreateAnimator(self.unit)
            self.UnpackAnimator = unpackAnimator
			if self.unit:GetScriptBit('RULEUTC_WeaponToggle') == false then
			self.UnpackAnimator:PlayAnim('/mods/Commander Survival Kit Units/units/Addon/Strutman/Cybran/SRL0200/SRL0200_aunpack.sca'):SetRate(0.2)
			else
			self.UnpackAnimator:PlayAnim('/mods/Commander Survival Kit Units/units/Addon/Strutman/Cybran/SRL0200/SRL0200_adirectunpack.sca'):SetRate(0.2)
			end
			self.WeaponPackState = 'Unpacking'
            WaitFor(unpackAnimator)
			self.unit.number = 1
			end
		end,
		
		PlayFxWeaponPackSequence = function(self)
			self.unit:SetSpeedMult(1.0)
            self.UnpackAnimator:SetRate(-0.2)
            self.WeaponPackState = 'Packing'
            WaitFor(self.UnpackAnimator)
			self.unit.number = 0
        self.WeaponPackState = 'Packed'
		self.unit:AddCommandCap('RULEUCC_Stop')
    end,
		},
		MainGun = Class(CDFParticleCannonWeapon) {},
    },
	
	OnCreate = function(self)
        CWalkingLandUnit.OnCreate(self)
		self.number = 0
		self.MissileWeapon = self:GetWeaponByLabel('MissileWeapon')
		self.MainGun = self:GetWeaponByLabel('MainGun')
		self.MainGun:SetEnabled(true)
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
		IssueClearCommands({self})
		self.MainGun:SetEnabled(true)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		IssueClearCommands({self})
		self.MainGun:SetEnabled(true)
        end
    end,
    
}

TypeClass = SRL0200
