#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0303/UEL0303_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TerranWeaponFile = import('/lua/terranweapons.lua')
local TWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local TDFHeavyPlasmaCannonWeapon = TerranWeaponFile.TDFHeavyPlasmaCannonWeapon
local TIFArtilleryWeapon = TerranWeaponFile.TIFArtilleryWeapon
local TDFGaussCannonWeapon = TerranWeaponFile.TDFGaussCannonWeapon

CSKTL0400 = Class(TWalkingLandUnit) {

    Weapons = {
        HeavyPlasma01 = Class(TDFHeavyPlasmaCannonWeapon) {
            DisabledFiringBones = {
                'Torso', 'ArmR_B02', 'Barrel_R', 'ArmR_B03', 'ArmR_B04',
                'ArmL_B02', 'Barrel_L', 'ArmL_B03', 'ArmL_B04',
            },
        },
		ChestArt = Class(TIFArtilleryWeapon) {
        },
		SecTurret = Class(TDFGaussCannonWeapon) {
        }
    },
	
	OnStopBeingBuilt = function(self, builder, layer)
        TWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:HideBone( 'R_Art_Barrel', true )
		self:HideBone( 'L_Art_Barrel', true )
		self:HideBone( 'R_ML', true )
		self:HideBone( 'L_ML', true )
		self.Trash:Add(CreateRotator(self, 'Spinner1', 'z', nil, 180, 0, 180))
		self.Trash:Add(CreateRotator(self, 'Spinner2', 'z', nil, -180, 0, 180))
		ForkThread( function()

		end
		)
    end,
    
}

TypeClass = CSKTL0400