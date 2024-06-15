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

local SIFZthuthaamArtilleryCannon = import('/lua/seraphimweapons.lua').SIFZthuthaamArtilleryCannon

CSKSA0200 = Class(SAirUnit) {
    Weapons = {
        MainGun = Class(SIFZthuthaamArtilleryCannon) {},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        SAirUnit.OnStopBeingBuilt(self,builder,layer)
        self.Spinner1 = CreateRotator(self, 'CSKSA0200', 'y', nil, 0, 60, 360):SetTargetSpeed(0)
		self.Effect1 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), '/effects/emitters/seraphim_airmoveexhaust_01_emit.bp'):ScaleEmitter(2)
        self.Trash:Add(self.Effect1)
		
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

TypeClass = CSKSA0200