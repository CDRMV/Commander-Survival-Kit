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
local TIFCruiseMissileLauncher = import('/lua/terranweapons.lua').TIFCruiseMissileLauncher

CSKTL0312 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TIFCruiseMissileLauncher) {
        },
		CruiseMissile = Class(TIFCruiseMissileLauncher) {

        },
    },
	
	OnCreate = function(self)
        TLandUnit.OnCreate(self)
        self:SetWeaponEnabledByLabel('CruiseMissile', false)
    end,
    
    OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
            self:SetWeaponEnabledByLabel('CruiseMissile', true)
            self:SetWeaponEnabledByLabel('MainGun', false)
            self:GetWeaponManipulatorByLabel('CruiseMissile'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('MainGun'):GetHeadingPitch() )
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
            self:SetWeaponEnabledByLabel('CruiseMissile', false)
            self:SetWeaponEnabledByLabel('MainGun', true)
            self:GetWeaponManipulatorByLabel('MainGun'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('CruiseMissile'):GetHeadingPitch() )
        end
    end,
}

TypeClass = CSKTL0312