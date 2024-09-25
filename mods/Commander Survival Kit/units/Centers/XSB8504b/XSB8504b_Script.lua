#****************************************************************************
#** 
#**  File     :  /cdimage/units/XSC1301/XSC1301_script.lua 
#** 
#** 
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'

XSB8504b = Class(StructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
		
		self.Entity = import('/lua/sim/Entity.lua').Entity({Owner = self,})
        self.Entity:AttachBoneTo( -1, self, 'Mesh' )
        self.Entity:SetMesh('/mods/Commander Survival Kit/meshes/Seraphim/Missile_mesh')
        self.Entity:SetDrawScale(0.015)
        self.Entity:SetVizToAllies('Intel')
        self.Entity:SetVizToNeutrals('Intel')
        self.Entity:SetVizToEnemies('Intel')        
        self.Trash:Add(self.Entity)
		
        self.Spinners = {
            Spinner1 = CreateRotator(self, 'Spinner', 'y', nil, 0, 60, 360):SetTargetSpeed(90),
        }
        for k, v in self.Spinners do
            self.Trash:Add(v)
        end
		
		
		self.Effect1 = CreateAttachedEmitter(self,'Effect2',self:GetArmy(), ModeffectPath .. 'sera_teleport_01_emit.bp'):ScaleEmitter(3.55)
		self.Trash:Add(self.Effect1)
		Sync.TacticalPointStorageCountLVL2 = true
    end,
	
	OnDestroy = function(self)
		if self.Entity == nil then
		else
		self.Entity:Destroy()
		end
		if self.Effect1 == nil then
		else
		self.Effect1:Destroy()
		end
        self.Dead = true

        if self:GetFractionComplete() < 1 then
            self:SendNotifyMessage('cancelled')
        end


        -- Destroy everything added to the trash
        self.Trash:Destroy()
        

        ChangeState(self, self.DeadState)
    end, 
	
	OnKilled = function(self, instigator, type, overkillRatio)
		self.Entity:Destroy()
		self.Effect1:Destroy()
		Sync.TacticalPointStorageCountLVL2 = false
		self:ForkThread(self.DeathThread, overkillRatio , instigator)
    end,
	
	OnReclaimed = function(self, reclaimer)
        self:DoUnitCallbacks('OnReclaimed', reclaimer)
		self.Entity:Destroy()
		self.Effect1:Destroy()
		Sync.TacticalPointStorageCountLVL2 = false
        self.CreateReclaimEndEffects(reclaimer, self)
        self:Destroy()
    end,

}


TypeClass = XSB8504b

