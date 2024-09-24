#****************************************************************************
#** 
#**  File     :  /cdimage/units/XSC1301/XSC1301_script.lua 
#** 
#** 
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'

XSB8503 = Class(StructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
		
		self.Effect1 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModeffectPath .. 'sera_teleport_01_emit.bp'):ScaleEmitter(2.55)
		self.Trash:Add(self.Effect1)
		self.Effect2 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModeffectPath .. 'sera_teleport_02_emit.bp'):ScaleEmitter(2.55)
		self.Trash:Add(self.Effect2)
		self.Effect3 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModeffectPath .. 'sera_teleport_03_emit.bp'):ScaleEmitter(2.65)
		self.Trash:Add(self.Effect3)
		Sync.ReinforcementPointStorageCount = true
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
		self.Effect1:Destroy()
		self.Effect2:Destroy()
		self.Effect3:Destroy()
		self:ForkThread(self.DeathThread, overkillRatio , instigator)
		Sync.ReinforcementPointStorageCount = false
    end,
	
	OnReclaimed = function(self, reclaimer)
        self:DoUnitCallbacks('OnReclaimed', reclaimer)
		self.Effect1:Destroy()
		self.Effect2:Destroy()
		self.Effect3:Destroy()
		Sync.ReinforcementPointStorageCount = false
        self.CreateReclaimEndEffects(reclaimer, self)
        self:Destroy()
    end,

}


TypeClass = XSB8503

