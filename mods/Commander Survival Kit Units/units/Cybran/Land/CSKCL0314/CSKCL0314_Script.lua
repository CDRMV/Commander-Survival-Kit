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
local ModWeaponsFile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua')
local CDFLaserIridiumWeapon = ModWeaponsFile.CDFLaserIridiumWeapon

CSKCL0314 = Class(CLandUnit) {
    Weapons = {
	  GroundGun = Class(CDFLaserIridiumWeapon) {},
	  AAGun = Class(CDFLaserIridiumWeapon) {},
	},
	
	OnCreate = function(self)
        CLandUnit.OnCreate(self)
        self:SetWeaponEnabledByLabel('AAGun', false)
    end,
    
    OnScriptBitSet = function(self, bit)
        CLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
            self:SetWeaponEnabledByLabel('AAGun', true)
            self:SetWeaponEnabledByLabel('GroundGun', false)
            self:GetWeaponManipulatorByLabel('AAGun'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('GroundGun'):GetHeadingPitch() )
        end
    end,

    OnScriptBitClear = function(self, bit)
        CLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
            self:SetWeaponEnabledByLabel('AAGun', false)
            self:SetWeaponEnabledByLabel('GroundGun', true)
            self:GetWeaponManipulatorByLabel('GroundGun'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('AAGun'):GetHeadingPitch() )
        end
    end,
	  
	
}

TypeClass = CSKCL0314