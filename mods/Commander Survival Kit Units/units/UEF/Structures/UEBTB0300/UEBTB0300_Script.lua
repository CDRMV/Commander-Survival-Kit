#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2301/UEB2301_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local TDFLightningBeam = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').TDFLightningBeam

UEBTB0300 = Class(TStructureUnit) {
    Weapons = {
        PhasonBeam = Class(TDFLightningBeam) {}, 
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self.Effect1 = CreateAttachedEmitter(self,'Effect1',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(2.0)
        self.Trash:Add(self.Effecct1)
		self.Effect2 = CreateAttachedEmitter(self,'Effect2',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(2.0)
        self.Trash:Add(self.Effecct2)
		AttachBeamEntityToEntity(self, 'Effect_B02_2', self, 'Effect05', self:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.Effect3 = CreateAttachedEmitter(self,'Effect_B02_1',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct3)
		AttachBeamEntityToEntity(self, 'Effect_B02_4', self, 'Effect08', self:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.Effect4 = CreateAttachedEmitter(self,'Effect_B02_3',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct4)
		AttachBeamEntityToEntity(self, 'Effect_B02_6', self, 'Effect05.002', self:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.Effect4 = CreateAttachedEmitter(self,'Effect_B02_5',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct4)
		AttachBeamEntityToEntity(self, 'Effect_B02_8', self, 'Effect07', self:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		self.Effect4 = CreateAttachedEmitter(self,'Effect_B02_7',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(1.0)
        self.Trash:Add(self.Effecct4)
		AttachBeamEntityToEntity(self, 'Effect07', self, 'Muzzle7', self:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		AttachBeamEntityToEntity(self, 'Effect08', self, 'Muzzle8', self:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		AttachBeamEntityToEntity(self, 'Effect05.002', self, 'Muzzle6', self:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
		AttachBeamEntityToEntity(self, 'Effect05', self, 'Muzzle5', self:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_02_emit.bp')
    end,
}

TypeClass = UEBTB0300