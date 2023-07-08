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
local TDFGaussCannonWeapon = WeaponFile.TDFGaussCannonWeapon

CSKTS0202 = Class(TSeaUnit) {
    DestructionTicks = 200,

    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {},
    },
	
	OnCreate = function(self)
        TSeaUnit.OnCreate(self)
        self.Effect1 = CreateAttachedEmitter(self,'Funnel_Smoke',self:GetArmy(), '/effects/emitters/hydrocarbon_smoke_01_emit.bp'):ScaleEmitter(0.5)
        self.Trash:Add(self.Effect1)
		self.Effect2 = CreateAttachedEmitter(self,'Funnel_Smoke2',self:GetArmy(), '/effects/emitters/hydrocarbon_smoke_01_emit.bp'):ScaleEmitter(0.5)
        self.Trash:Add(self.Effect2)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        TSeaUnit.OnStopBeingBuilt(self,builder,layer)
        self.Effect1 = CreateAttachedEmitter(self,'Funnel_Smoke',self:GetArmy(), '/effects/emitters/hydrocarbon_smoke_01_emit.bp'):ScaleEmitter(0.5)
        self.Trash:Add(self.Effect1)
		self.Effect2 = CreateAttachedEmitter(self,'Funnel_Smoke2',self:GetArmy(), '/effects/emitters/hydrocarbon_smoke_01_emit.bp'):ScaleEmitter(0.5)
        self.Trash:Add(self.Effect2)
    end,
}

TypeClass = CSKTS0202