#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0203/UAA0203_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Gunship Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').AirUnit

local ADFCannonOblivionWeapon = import('/lua/aeonweapons.lua').ADFCannonOblivionWeapon

CSKAA0201 = Class(AAirUnit) {
    Weapons = {
        FrontTurret = Class(ADFCannonOblivionWeapon) {
			
			PlayFxWeaponUnpackSequence = function(self)
					self.unit:ShowBone('Muzzle', true)
                    ADFCannonOblivionWeapon.PlayFxWeaponUnpackSequence(self)
                end,

                PlayFxWeaponPackSequence = function(self)
					self.unit:HideBone('Muzzle', true)
                    ADFCannonOblivionWeapon.PlayFxWeaponPackSequence(self)
                end,
		
		},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
		self:HideBone('Muzzle', true)
        self.Spinner1 = CreateRotator(self, 'CSKAA0201', 'y', nil, 0, 60, 360):SetTargetSpeed(0)
		self.Spinner2 = CreateRotator(self, 'Spinner', 'y', nil, 0, 60, 360):SetTargetSpeed(0)
    end,
	
	OnMotionHorzEventChange = function(self, new, old)

        if old == 'Stopped' then
			self.Spinner1:SetTargetSpeed(0)
			self.Spinner2:SetTargetSpeed(0)
        end

        if new == 'Stopping' then
			self.Spinner1:SetTargetSpeed(20)
			self.Spinner2:SetTargetSpeed(20)
        end

    end,
	
}

TypeClass = CSKAA0201