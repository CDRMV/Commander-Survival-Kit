#****************************************************************************
#**
#**  File     :  units/XRL0002/XRL0002_script.lua
#**
#**  Summary  :  Crab egg
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'
local AAirFactoryUnit = import('/lua/aeonunits.lua').AAirFactoryUnit
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

UARL0303 = Class(AAirFactoryUnit) {

    OnStopBeingBuilt = function(self, builder, layer)
        AAirFactoryUnit.OnStopBeingBuilt(self,builder,layer)
		self:HideBone( 'Ring', true )
        local bp = self:GetBlueprint()
        local buildUnit = bp.Economy.BuildUnit
        local Spinner1 = CreateRotator(self, 'Ring', 'y', nil, 0, 60, 360)
		self.Trash:Add(Spinner1)
        local pos = self:GetPosition()
        
        local aiBrain = self:GetAIBrain()

        ForkThread( function()
						WaitSeconds(1)
						CreateLightParticle( self, 'Effect', self:GetArmy(), 3, 7, 'glow_03', 'ramp_white_01' ) 
						self:ShowBone( 'Ring', true )
						local Spinner1 = CreateRotator(self, 'Ring', 'y', nil, 0, 60, 360):SetTargetSpeed(0),
						WaitSeconds(3)
						CreateLightParticle( self, 'Effect', self:GetArmy(), 3, 7, 'glow_03', 'ramp_white_01' ) 
						self.Effect1 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModeffectPath .. 'aeon_teleport_01_emit.bp'):ScaleEmitter(1.95)
						self.Trash:Add(self.Effect1)
						self.Effect2 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModeffectPath .. 'aeon_teleport_02_emit.bp'):ScaleEmitter(1.85)
						self.Trash:Add(self.Effect2)
						self.Effect3 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModeffectPath .. 'aeon_teleport_03_emit.bp'):ScaleEmitter(1.95)
						self.Trash:Add(self.Effect3)

						WaitSeconds(10)
                        CreateLightParticle( self, 'Effect', self:GetArmy(), 3, 7, 'glow_03', 'ramp_white_01' ) 
						self:HideBone( 'Ring', true )
						CreateLightParticle( self, 'Effect', self:GetArmy(), 3, 7, 'glow_03', 'ramp_white_01' ) 
						self.Effect4 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModeffectPath .. 'aeon_TeleportRing_01_emit.bp'):ScaleEmitter(1.75)
						self.Trash:Add(self.Effect4)
						self.Effect6 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModeffectPath .. 'aeon_teleport_03_emit.bp'):ScaleEmitter(1.85)
						self.Trash:Add(self.Effect6)
						self.Effect7 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModeffectPath .. 'aeon_teleport_04_emit.bp'):ScaleEmitter(1.95)
						self.Trash:Add(self.Effect7)
                        #CreateSlider(unit, bone, [goal_x, goal_y, goal_z, [speed,
                        self.EggSlider = CreateSlider(self, 'Effect', 0, -10, 0, 10)
                        self.Trash:Add(self.EggSlider)
						WaitSeconds(5)
                        WaitFor(self.EggSlider)
                        
                        self:Destroy()
						CreateLightParticle( self, 'Effect', self:GetArmy(), 3, 7, 'glow_03', 'ramp_white_01' ) 
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
        AAirFactoryUnit.OnDestroy(self)
		self:HideBone( 'Ring', true )
    end,
	
	OnKilled = function(self)
        AAirFactoryUnit.OnKilled(self)
		self:HideBone( 'Ring', true )
    end,

}

TypeClass = UARL0303