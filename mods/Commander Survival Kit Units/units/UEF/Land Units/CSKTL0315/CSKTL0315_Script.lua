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
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local TDFIonizedPlasmaCannon = import('/lua/terranweapons.lua').TDFIonizedPlasmaCannon

CSKTL0315 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {},
		Riotgun01 = Class(TDFMachineGunWeapon) {},
		PlasmaCannon01 = Class(TDFIonizedPlasmaCannon) {},
    },
	
	OnStopBeingBuilt = function(self, builder, layer)
        TLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetWeaponEnabledByLabel('PlasmaCannon01', false)
	end,	
	
	OnCreate = function(self)
        TLandUnit.OnCreate(self)
		self:SetWeaponEnabledByLabel('PlasmaCannon01', false)
    end,
    
    OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
            self:SetWeaponEnabledByLabel('PlasmaCannon01', true)
            self:SetWeaponEnabledByLabel('MainGun', false)
			self:GetWeaponManipulatorByLabel('PlasmaCannon01'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('MainGun'):GetHeadingPitch() )
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
            self:SetWeaponEnabledByLabel('PlasmaCannon01', false)
            self:SetWeaponEnabledByLabel('MainGun', true)
			self:GetWeaponManipulatorByLabel('MainGun'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('PlasmaCannon01'):GetHeadingPitch() )
        end
    end,
}

TypeClass = CSKTL0315