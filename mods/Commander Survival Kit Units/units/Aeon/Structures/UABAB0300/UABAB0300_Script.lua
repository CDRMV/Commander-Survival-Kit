#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB2301/UAB2301_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Heavy Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit
local ADFPhasonLaser = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').ADFMiniPhasonLaser

UABAB0300 = Class(AStructureUnit) {
    Weapons = {
        EyeWeapon = Class(ADFPhasonLaser) {
		
		        PlayFxWeaponUnpackSequence = function(self)
                    if self.unit.Spinner1 then 
					self.unit.Spinner1:Destroy()
                    end
					if self.unit.Spinner2 then 
					self.unit.Spinner2:Destroy()
                    end
					if self.unit.Spinner3 then 
					self.unit.Spinner3:Destroy()
                    end
					if self.unit.Spinner4 then 
					self.unit.Spinner4:Destroy()
                    end
					if self.unit.Spinner5 then 
					self.unit.Spinner5:Destroy()
                    end
                    ADFPhasonLaser.PlayFxWeaponUnpackSequence(self)
                end,

                PlayFxWeaponPackSequence = function(self)
					self.unit.Spinner1 = CreateRotator(self.unit, 'Spinner01', 'y', nil, 0, 60, 360):SetTargetSpeed(90)
					self.unit.Spinner2 = CreateRotator(self.unit, 'Spinner02', 'y', nil, 0, 60, -360):SetTargetSpeed(-90)
					self.unit.Spinner3 = CreateRotator(self.unit, 'Spinner03', 'x', nil, 0, 60, 360):SetTargetSpeed(90)
					self.unit.Spinner4 = CreateRotator(self.unit, 'Spinner04', 'x', nil, 0, 60, -360):SetTargetSpeed(-90)
					self.unit.Spinner5 = CreateRotator(self.unit, 'Spinner05', 'y', nil, 0, 60, -360):SetTargetSpeed(-90)
                    ADFPhasonLaser.PlayFxWeaponPackSequence(self)
                end,
		
		},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        AStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self.Spinner1 = CreateRotator(self, 'Spinner01', 'y', nil, 0, 60, 360):SetTargetSpeed(90)
		self.Spinner2 = CreateRotator(self, 'Spinner02', 'y', nil, 0, 60, -360):SetTargetSpeed(-90)
		self.Spinner3 = CreateRotator(self, 'Spinner03', 'x', nil, 0, 60, 360):SetTargetSpeed(90)
		self.Spinner4 = CreateRotator(self, 'Spinner04', 'x', nil, 0, 60, -360):SetTargetSpeed(-90)
		self.Spinner5 = CreateRotator(self, 'Spinner05', 'y', nil, 0, 60, -360):SetTargetSpeed(-90)
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
        AStructureUnit.OnKilled(self, instigator, type, overkillRatio)
        local wep = self:GetWeaponByLabel('EyeWeapon')
        local bp = wep:GetBlueprint()
        if bp.Audio.BeamStop then
            wep:PlaySound(bp.Audio.BeamStop)
        end
        if bp.Audio.BeamLoop and wep.Beams[1].Beam then
            wep.Beams[1].Beam:SetAmbientSound(nil, nil)
        end
        for k, v in wep.Beams do
            v.Beam:Disable()
        end     
    end,
}

TypeClass = UABAB0300