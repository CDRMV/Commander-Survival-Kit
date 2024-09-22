#****************************************************************************
#** 
#**  File     :  /cdimage/units/UAC1501/UAC1501_script.lua 
#**  Author(s):  John Comes, David Tomandl 
#** 
#**  Summary  :  Aeon Manufacturing Center, Ver1
#** 
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'

XSB8502 = Class(StructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
		
		self.Entity = import('/lua/sim/Entity.lua').Entity({Owner = self,})
        self.Entity:AttachBoneTo( -1, self, 'Mesh' )
        self.Entity:SetMesh('/mods/Commander Survival Kit/meshes/Seraphim/Missile_mesh')
        self.Entity:SetDrawScale(0.010)
        self.Entity:SetVizToAllies('Intel')
        self.Entity:SetVizToNeutrals('Intel')
        self.Entity:SetVizToEnemies('Intel')        
        self.Trash:Add(self.Entity)
		
		self.Entity2 = import('/lua/sim/Entity.lua').Entity({Owner = self,})
        self.Entity2:AttachBoneTo( -1, self, 'Mesh2' )
        self.Entity2:SetMesh('/mods/Commander Survival Kit/meshes/Seraphim/Missile_mesh')
        self.Entity2:SetDrawScale(0.010)
        self.Entity2:SetVizToAllies('Intel')
        self.Entity2:SetVizToNeutrals('Intel')
        self.Entity2:SetVizToEnemies('Intel')        
        self.Trash:Add(self.Entity2)
		
        self.Spinners = {
            Spinner1 = CreateRotator(self, 'Spinner', 'y', nil, 0, 60, 360):SetTargetSpeed(90),
			Spinner2 = CreateRotator(self, 'Spinner2', 'y', nil, 0, 60, 360):SetTargetSpeed(-90),
        }
        for k, v in self.Spinners do
            self.Trash:Add(v)
        end
		
		
		self.Effect1 = CreateAttachedEmitter(self,'Effect2',self:GetArmy(), ModeffectPath .. 'sera_teleport_01_emit.bp'):ScaleEmitter(3.05)
		self.Trash:Add(self.Effect1)
		self.Effect2 = CreateAttachedEmitter(self,'Effect4',self:GetArmy(), ModeffectPath .. 'sera_teleport_01_emit.bp'):ScaleEmitter(3.05)
		self.Trash:Add(self.Effect2)
		
		self.Effect3 = CreateAttachedEmitter(self,'Effect5',self:GetArmy(), ModeffectPath .. 'sera_teleport_01_emit.bp'):ScaleEmitter(2.05)
		self.Trash:Add(self.Effect3)
		self.Effect4 = CreateAttachedEmitter(self,'Effect5',self:GetArmy(), ModeffectPath .. 'sera_teleport_02_emit.bp'):ScaleEmitter(2.05)
		self.Trash:Add(self.Effect4)
		self.Effect5 = CreateAttachedEmitter(self,'Effect5',self:GetArmy(), ModeffectPath .. 'sera_teleport_03_emit.bp'):ScaleEmitter(2.15)
		self.Trash:Add(self.Effect5)
		
		self.Effect6 = CreateAttachedEmitter(self,'Effect6',self:GetArmy(), ModeffectPath .. 'sera_teleport_01_emit.bp'):ScaleEmitter(2.05)
		self.Trash:Add(self.Effect6)
		self.Effect7 = CreateAttachedEmitter(self,'Effect6',self:GetArmy(), ModeffectPath .. 'sera_teleport_02_emit.bp'):ScaleEmitter(2.05)
		self.Trash:Add(self.Effect7)
		self.Effect8 = CreateAttachedEmitter(self,'Effect6',self:GetArmy(), ModeffectPath .. 'sera_teleport_03_emit.bp'):ScaleEmitter(2.15)
		self.Trash:Add(self.Effect8)
		
		
		Sync.HQComCenterDetected = true

    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
		self.Entity:Destroy()
		self.Entity2:Destroy()
		self.Effect1:Destroy()
		self.Effect2:Destroy()
		self.Effect3:Destroy()
		self.Effect4:Destroy()
		self.Effect5:Destroy()
		self.Effect6:Destroy()
		self.Effect7:Destroy()
		self.Effect8:Destroy()
		Sync.HQComCenterDetected = false
		self:ForkThread(self.DeathThread, overkillRatio , instigator)
    end,

}


TypeClass = XSB8502

