#****************************************************************************
#**
#**  File     :  /cdimage/units/URB2301/URB2301_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local cWeapons = import('/lua/cybranweapons.lua')
local CDFHeavyMicrowaveLaserGeneratorCom = cWeapons.CDFHeavyMicrowaveLaserGeneratorCom

URBCB0300 = Class(CStructureUnit) {
    Weapons = {
	    AAMainGun = Class(CDFHeavyMicrowaveLaserGeneratorCom) {},
        MainGun = Class(CDFHeavyMicrowaveLaserGeneratorCom) {},
    },
	
	OnCreate = function(self)
        CStructureUnit.OnCreate(self)
        self:SetWeaponEnabledByLabel('AAMainGun', false)
    end,
    
    OnScriptBitSet = function(self, bit)
        CStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
            self:SetWeaponEnabledByLabel('AAMainGun', true)
            self:SetWeaponEnabledByLabel('MainGun', false)
            self:GetWeaponManipulatorByLabel('AAMainGun'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('MainGun'):GetHeadingPitch() )
        end
    end,

    OnScriptBitClear = function(self, bit)
        CStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
            self:SetWeaponEnabledByLabel('AAMainGun', false)
            self:SetWeaponEnabledByLabel('MainGun', true)
            self:GetWeaponManipulatorByLabel('MainGun'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('AAMainGun'):GetHeadingPitch() )
        end
    end,
}

TypeClass = URBCB0300