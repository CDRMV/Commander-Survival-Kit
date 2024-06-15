#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0203/UAA0203_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Gunship Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SAirUnit = import('/lua/defaultunits.lua').AirUnit

local SDFUltraChromaticBeamGenerator = import('/lua/seraphimweapons.lua').SDFUltraChromaticBeamGenerator

CSKSA0300 = Class(SAirUnit) {
    Weapons = {
        MainGun = Class(SDFUltraChromaticBeamGenerator) {},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        SAirUnit.OnStopBeingBuilt(self,builder,layer)
        self.Spinner1 = CreateRotator(self, 'CSKSA0300', 'y', nil, 0, 60, 360):SetTargetSpeed(0)
		self.Effect1 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), '/effects/emitters/seraphim_airmoveexhaust_01_emit.bp'):ScaleEmitter(3)
        self.Trash:Add(self.Effect1)
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
        local wep1 = self:GetWeaponByLabel('MainGun')
        local bp1 = wep1:GetBlueprint()
        if bp1.Audio.BeamStop then
            wep1:PlaySound(bp1.Audio.BeamStop)
        end
        if bp1.Audio.BeamLoop and wep1.Beams[1].Beam then
            wep1.Beams[1].Beam:SetAmbientSound(nil, nil)
        end
        for k, v in wep1.Beams do
            v.Beam:Disable()
        end     
        
        
        SAirUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
	
	OnMotionHorzEventChange = function(self, new, old)

        if old == 'Stopped' then
			self.Spinner1:SetTargetSpeed(0)
        end

        if new == 'Stopping' then
			self.Spinner1:SetTargetSpeed(20)
        end

    end,
	
}

TypeClass = CSKSA0300