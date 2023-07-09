#****************************************************************************
#**
#**  File     :  /cdimage/units/UES0201/UES0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Terran Destroyer Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TSeaUnit = import('/lua/terranunits.lua').TSeaUnit
local WeaponFile = import('/lua/terranweapons.lua')
local TAAFlakArtilleryCannon = import('/lua/terranweapons.lua').TAAFlakArtilleryCannon
local TDFShipGaussCannonWeapon = WeaponFile.TDFShipGaussCannonWeapon

CSKTS0201 = Class(TSeaUnit) {
    DestructionTicks = 200,

    Weapons = {
        MainGun = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.40,
		},
		SecGun = Class(TDFShipGaussCannonWeapon) {
		    FxMuzzleFlashScale = 0.15,
		},
		AAGun = Class(TAAFlakArtilleryCannon) {
            PlayOnlyOneSoundCue = true,
        },
    },
	
	OnCreate = function(self)
        TSeaUnit.OnCreate(self)
        self.Effect1 = CreateAttachedEmitter(self,'Funnel_Smoke',self:GetArmy(), '/effects/emitters/hydrocarbon_smoke_01_emit.bp'):ScaleEmitter(0.5)
        self.Trash:Add(self.Effect1)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        TSeaUnit.OnStopBeingBuilt(self,builder,layer)
        self.Effect1 = CreateAttachedEmitter(self,'Funnel_Smoke',self:GetArmy(), '/effects/emitters/hydrocarbon_smoke_01_emit.bp'):ScaleEmitter(0.5)
        self.Trash:Add(self.Effect1)
    end,
	
	OnDestroy = function(self)
        TSeaUnit.OnDestroy(self)
        if self.Effect1 then
           self.Effect1:Destroy()
        end
    end,
}

TypeClass = CSKTS0201