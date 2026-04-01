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
local DummyTurretWeapon = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').DummyTurretWeapon

SRL0200 = Class(CWalkingLandUnit) {
    Weapons = {
		Dummy = Class(DummyTurretWeapon) {},
        MissileWeapon = Class(CDFRocketIridiumWeapon) {
		OnWeaponFired = function(self)
			ForkThread( function()	
			self.unit.Launch = true
			WaitSeconds(0.3)
			self.unit:HideBone('Scud', true)    
			self.unit.Launch = false
			IssueStop({self.unit})	
			self:SetEnabled(false)		
			end)
		end,
		},
		MissileWeapon2 = Class(CDFRocketIridiumWeapon) {
		OnWeaponFired = function(self)
			ForkThread( function()	
			self.unit.Launch = true
			WaitSeconds(0.3)
			self.unit:HideBone('Scud', true)    
			self.unit.Launch = false	
			IssueStop({self.unit})
			self:SetEnabled(false)		
			end)
		end,
		},
    },
	
	OnCreate = function(self)
        CWalkingLandUnit.OnCreate(self)
		self.Dummy = self:GetWeaponByLabel('Dummy')
		self:CreateEnhancement('InDirectFireMode')
		self:SetScriptBit('RULEUTC_WeaponToggle', false)
		self.DirectFireMode = false
		self.InDirectFireMode = true
		ForkThread( function()	
		self.LaunchEffect = false
		while true do
		if  self:IsUnitState('Enhancing') then
		IssueStop({self})
		self.MissileWeapon2:SetEnabled(false)
		self.MissileWeapon:SetEnabled(false)
		else
		end
		if self.Launch == false then
		WaitSeconds(45)
		if not self:IsDead() then 
		self:ShowBone('Scud', true)
		if self.InDirectFireMode == true and self.DirectFireMode == false then
		self.MissileWeapon = self:GetWeaponByLabel('MissileWeapon')
		self.MissileWeapon2 = self:GetWeaponByLabel('MissileWeapon2')
		self.MissileWeapon:SetEnabled(true)
		self.MissileWeapon2:SetEnabled(false)
		end
		if self.DirectFireMode == true and self.InDirectFireMode == false then
		self.MissileWeapon = self:GetWeaponByLabel('MissileWeapon')
		self.MissileWeapon2 = self:GetWeaponByLabel('MissileWeapon2')
		self.MissileWeapon:SetEnabled(false)
		self.MissileWeapon2:SetEnabled(true)
		end
		end
		end
		WaitSeconds(0.1)
		end
		end)
    end,
	
	
	CreateEnhancement = function(self, enh)
        CWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh == 'DirectFireMode' then
		self:ShowBone('Scud', true)
		self.Dummy:ChangeMaxRadius(100)
		self.Dummy:ChangeMinRadius(10)
		self.MissileWeapon = self:GetWeaponByLabel('MissileWeapon')
		self.MissileWeapon2 = self:GetWeaponByLabel('MissileWeapon2')
		self.MissileWeapon:SetEnabled(false)
		self.MissileWeapon2:SetEnabled(true)
		self.DirectFireMode = true
		self.InDirectFireMode = false
        elseif enh == 'InDirectFireMode' then
		self:ShowBone('Scud', true)
		self.Dummy:ChangeMaxRadius(150)
		self.Dummy:ChangeMinRadius(20)
		self.MissileWeapon = self:GetWeaponByLabel('MissileWeapon')
		self.MissileWeapon2 = self:GetWeaponByLabel('MissileWeapon2')
		self.MissileWeapon:SetEnabled(true)
		self.MissileWeapon2:SetEnabled(false)
		self.DirectFireMode = false
		self.InDirectFireMode = true
        end
    end,
	
    
}

TypeClass = SRL0200
