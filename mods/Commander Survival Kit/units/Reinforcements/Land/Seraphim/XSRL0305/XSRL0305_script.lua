#****************************************************************************
#**
#**  File     :  units/XRL0002/XRL0002_script.lua
#**
#**  Summary  :  Crab egg
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'
local SAirFactoryUnit = import('/lua/defaultunits.lua').FactoryUnit
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

XSRL0305 = Class(SAirFactoryUnit) {

    OnStopBeingBuilt = function(self, builder, layer)
        SAirFactoryUnit.OnStopBeingBuilt(self,builder,layer)
		self:HideBone( 'Ring', true )
        local bp = self:GetBlueprint()
        local buildUnit = bp.Economy.BuildUnit
        local Spinner1 = CreateRotator(self, 'Ring', 'y', nil, 0, 60, 360)
		self.Trash:Add(Spinner1)
        local pos = self:GetPosition()
        
        local aiBrain = self:GetAIBrain()

        ForkThread( function()
						WaitSeconds(1)
						CreateLightParticle( self, 'Effect', self:GetArmy(), 3, 7, 'glow_03', 'ramp_ser_01.dds' ) 
						self.Effect1 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModeffectPath .. 'sera_teleport_01_emit.bp'):ScaleEmitter(0.95)
						self.Trash:Add(self.Effect1)
						self.Effect2 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModeffectPath .. 'sera_teleport_02_emit.bp'):ScaleEmitter(1.05)
						self.Trash:Add(self.Effect2)
						self.Effect3 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModeffectPath .. 'sera_teleport_03_emit.bp'):ScaleEmitter(1.15)
						self.Trash:Add(self.Effect3)

						WaitSeconds(13)
                        CreateLightParticle( self, 'Effect', self:GetArmy(), 3, 7, 'glow_03', 'ramp_ser_01.dds' ) 
						--self:HideBone( 'Ring', true )
						CreateLightParticle( self, 'Effect', self:GetArmy(), 3, 7, 'glow_03', 'ramp_ser_01.dds' ) 
						self.Effect4 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModeffectPath .. 'sera_TeleportRing_01_emit.bp'):ScaleEmitter(1.15)
						self.Trash:Add(self.Effect4)
						self.Effect6 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModeffectPath .. 'sera_teleport_03_emit.bp'):ScaleEmitter(1.05)
						self.Trash:Add(self.Effect6)
						self.Effect7 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModeffectPath .. 'sera_teleport_04_emit.bp'):ScaleEmitter(1.15)
						self.Trash:Add(self.Effect7)
                        #CreateSlider(unit, bone, [goal_x, goal_y, goal_z, [speed,
                        self.EggSlider = CreateSlider(self, 'Effect', 0, 0, 0, 10)
                        self.Trash:Add(self.EggSlider)
						WaitSeconds(5)
                        WaitFor(self.EggSlider)
                        
                        self:Destroy()
						CreateLightParticle( self, 'Effect', self:GetArmy(), 3, 7, 'glow_03', 'ramp_ser_01.dds' ) 
						local orientation = RandomFloat(0,2*math.pi)
						CreateDecal(pos, orientation, 'Crater01_albedo', '', 'Albedo', 4, 4, 200, 0, self:GetArmy())
						CreateDecal(pos, orientation, 'Crater01_normals', '', 'Normals', 4, 4, 200, 0, self:GetArmy())       
						CreateUnitHPR(
						buildUnit,
						aiBrain.Name,
						pos[1], pos[2], pos[3],
						0, 0, 0
						)
                    end
                  )
       
    end,
    
    
    OnStopBuild = function(self, unitBeingBuilt, order)
        if unitBeingBuilt:GetFractionComplete() == 1 then
            ForkThread(function()
                WaitSeconds(0.1)
                self:Destroy()
            end)
        end
    end,
	
	OnDestroy = function(self)
        SAirFactoryUnit.OnDestroy(self)
		self:HideBone( 'Ring', true )
    end,
	
	OnKilled = function(self)
        SAirFactoryUnit.OnKilled(self)
		self:HideBone( 'Ring', true )
    end,

}

TypeClass = XSRL0305