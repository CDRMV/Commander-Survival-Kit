#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0303/URL0303_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local CSKUWeaponFile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua')
local Weapon = import('/lua/sim/Weapon.lua').Weapon
local cWeapons = import('/lua/cybranweapons.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local Buff = import('/lua/sim/Buff.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Entity = import('/lua/sim/Entity.lua').Entity
local CDFHeavyMicrowaveLaserGeneratorCom = cWeapons.CDFHeavyMicrowaveLaserGeneratorCom
local CDFProtonCannonWeapon = cWeapons.CDFProtonCannonWeapon
local CIFArtilleryWeapon = cWeapons.CIFArtilleryWeapon
local CDFRocketIridiumWeapon = cWeapons.CDFRocketIridiumWeapon
local CAANanoDartWeapon = cWeapons.CAANanoDartWeapon
local CAMZapperWeapon = CSKUWeaponFile.CAMZapperWeapon5
local CAAMissileNaniteWeapon = cWeapons.CAAMissileNaniteWeapon


CSKCL0400 = Class(CWalkingLandUnit) 
{
    PlayEndAnimDestructionEffects = false,
	SphereEffectBp = '/effects/emitters/zapper_electricity_01_emit.bp',
    Weapons = {
        AAGun = Class(CAANanoDartWeapon) {},
		RocketTurret = Class(CDFRocketIridiumWeapon) {},
        BackArtTurret = Class(CIFArtilleryWeapon) {
		    FxMuzzleFlash = {
                '/effects/emitters/cybran_artillery_muzzle_flash_01_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_flash_02_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_smoke_01_emit.bp',
            },
		},
		ChestTurret = Class(CAAMissileNaniteWeapon) {},
        BackTurret = Class(CDFProtonCannonWeapon) {},
		HeadTurret = Class(CDFProtonCannonWeapon) {},
		MainGun = Class(CDFHeavyMicrowaveLaserGeneratorCom) {},
    },
	
	OnCreate = function(self)
        CWalkingLandUnit.OnCreate(self)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		--self:HideBone( 'F_AATurret01', true )
		--self:HideBone( 'F_MTurret01', true )
		--self:HideBone( 'Back_Turret', true )
		--self:HideBone( 'Art_Turret', true )
		--self:HideBone( 'Zapper_Muzzle', true )
		--self:HideBone( 'Zapper_Turret', true )
		self:SetWeaponEnabledByLabel('AAGun', false)
		self:SetWeaponEnabledByLabel('RocketTurret', false)
		self:SetWeaponEnabledByLabel('BackArtTurret', false)
		self:SetWeaponEnabledByLabel('BackTurret', false)
		self:SetWeaponEnabledByLabel('MainGun', true)
		self:SetWeaponEnabledByLabel('ChestTurret', true)
		self:SetWeaponEnabledByLabel('HeadTurret', true)
    end,
	
	
    
}

TypeClass = CSKCL0400