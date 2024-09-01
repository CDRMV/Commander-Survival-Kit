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

local ADFPhasonLaser = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').ADFMiniPhasonLaser

CSKAA0300 = Class(AAirUnit) {
    Weapons = {
        EyeWeapon = Class(ADFPhasonLaser) {
		
		        PlayFxWeaponUnpackSequence = function(self)
                    if self.unit.Spinner3 then 
					self.unit.Spinner3:Destroy()
                    end
					if self.unit.Spinner4 then 
					self.unit.Spinner4:Destroy()
                    end
					if self.unit.Spinner5 then 
					self.unit.Spinner5:Destroy()
                    end
					if self.unit.Spinner6 then 
					self.unit.Spinner6:Destroy()
                    end
                    ADFPhasonLaser.PlayFxWeaponUnpackSequence(self)
                end,

                PlayFxWeaponPackSequence = function(self)
					self.unit.Spinner3 = CreateRotator(self.unit, 'Spinner01', 'y', nil, 0, 60, 360):SetTargetSpeed(90)
					self.unit.Spinner4 = CreateRotator(self.unit, 'Spinner02', 'y', nil, 0, 60, -360):SetTargetSpeed(-90)
					self.unit.Spinner5 = CreateRotator(self.unit, 'Spinner03', 'x', nil, 0, 60, 360):SetTargetSpeed(90)
					self.unit.Spinner6 = CreateRotator(self.unit, 'Spinner04', 'x', nil, 0, 60, -360):SetTargetSpeed(-90)
                    ADFPhasonLaser.PlayFxWeaponPackSequence(self)
                end,
		
		},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
        self.Spinner1 = CreateRotator(self, 'CSKAA0300', 'y', nil, 0, 60, 360):SetTargetSpeed(0)
		self.Spinner2 = CreateRotator(self, 'Spinner', 'y', nil, 0, 60, 360):SetTargetSpeed(0)
		self.Spinner3 = CreateRotator(self, 'Spinner01', 'y', nil, 0, 60, 360):SetTargetSpeed(90)
		self.Spinner4 = CreateRotator(self, 'Spinner02', 'y', nil, 0, 60, -360):SetTargetSpeed(-90)
		self.Spinner5 = CreateRotator(self, 'Spinner03', 'x', nil, 0, 60, 360):SetTargetSpeed(90)
		self.Spinner6 = CreateRotator(self, 'Spinner04', 'x', nil, 0, 60, -360):SetTargetSpeed(-90)
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

TypeClass = CSKAA0300