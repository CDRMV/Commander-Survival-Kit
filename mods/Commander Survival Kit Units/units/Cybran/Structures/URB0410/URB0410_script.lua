#****************************************************************************
#**
#**  File     :  /cdimage/units/URB1201/URB1201_script.lua
#**  Author(s):  John Comes, Dave Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Tier 2 Power Generator Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CMagnetStructureUnit = import('/lua/defaultunits.lua').StructureUnit

URB1201 = Class(CMagnetStructureUnit) {
    AmbientEffects = 'CT2PowerAmbient',
    CircleMesh = '/mods/Commander Survival Kit Units/effects/Entities/CybranRayShield/CybranRayShield_mesh',
	MagnetThread = function(self)
		local Pos = self:GetPosition()
        while not self:IsDead() do
            #Get friendly units in the area (including self)
            local units = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			self:GetBlueprint().Intel.VisionRadius,
			'Enemy'
			
			)
            #Give them a 5 second regen buff
            for _,unit in units do
				IssueMove({unit}, Pos)
            end
            
            #Wait 5 seconds
            WaitSeconds(1)
        end
    end,
	
	DestructionThread = function(self)
		local Pos = self:GetPosition()
        while not self:IsDead() do
            #Get friendly units in the area (including self)
            local units = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			6,
			'Enemy'
			
			)
            #Give them a 5 second regen buff
            for _,unit in units do
				unit:Kill()
            end
            
            #Wait 5 seconds
            WaitSeconds(1)
        end
    end,
	
    OnStopBeingBuilt = function(self,builder,layer)
		self:SetMaintenanceConsumptionInactive()
		self:ShowBone('Fundament', true)
		self:HideBone('BlackFundament', true)
        CMagnetStructureUnit.OnStopBeingBuilt(self,builder,layer)
    end,
	

	OnScriptBitSet = function(self, bit)
        CMagnetStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		ForkThread( function()
			self.RayShieldEntity = import('/lua/sim/Entity.lua').Entity()
			self.RayShieldEntity:AttachBoneTo( -1, self, 'Shield' )
			self.RayShieldEntity:SetMesh(self.CircleMesh)
			self.RayShieldEntity:SetDrawScale(0.35)
			self.RayShieldEntity:SetVizToAllies('Intel')
			self.RayShieldEntity:SetVizToNeutrals('Intel')
			self.RayShieldEntity:SetVizToEnemies('Intel')
			self.RayShieldEntity2 = import('/lua/sim/Entity.lua').Entity()
			self.RayShieldEntity2:AttachBoneTo( -1, self, 'Shield' )
			self.RayShieldEntity2:SetMesh(self.CircleMesh)
			self.RayShieldEntity2:SetDrawScale(0.35)
			self.RayShieldEntity2:SetVizToAllies('Intel')
			self.RayShieldEntity2:SetVizToNeutrals('Intel')
			self.RayShieldEntity2:SetVizToEnemies('Intel')
			self.RayShieldEntity3 = import('/lua/sim/Entity.lua').Entity()
			self.RayShieldEntity3:AttachBoneTo( -1, self, 'Shield' )
			self.RayShieldEntity3:SetMesh(self.CircleMesh)
			self.RayShieldEntity3:SetDrawScale(0.35)
			self.RayShieldEntity3:SetVizToAllies('Intel')
			self.RayShieldEntity3:SetVizToNeutrals('Intel')
			self.RayShieldEntity3:SetVizToEnemies('Intel')
		    self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/magnet_01_emit.bp'):ScaleEmitter(3)
            self.Trash:Add(self.Effect1)
			self.Effect2 = CreateAttachedEmitter(self,'Electro_Effect01',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(2)
            self.Trash:Add(self.Effect2)
			self.Effect3 = CreateAttachedEmitter(self,'Electro_Effect02',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(2)
            self.Trash:Add(self.Effect3)
			self.Effect4 = CreateAttachedEmitter(self,'Electro_Effect03',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(2)
            self.Trash:Add(self.Effect4)
			self:SetMaintenanceConsumptionActive()
			self.MagnetThreadHandle = self:ForkThread(self.MagnetThread)
			self.DestructionThreadHandle = self:ForkThread(self.DestructionThread)
        end)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CMagnetStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		ForkThread( function()
			self.RayShieldEntity:Destroy()
			self.RayShieldEntity2:Destroy()
			self.RayShieldEntity3:Destroy()
			self:SetMaintenanceConsumptionInactive()
			KillThread(self.MagnetThreadHandle)
			KillThread(self.DestructionThreadHandle)
			self.Effect1:Destroy()
			self.Effect2:Destroy()
			self.Effect3:Destroy()
			self.Effect4:Destroy()
        end)
        end
    end,
}

TypeClass = URB1201