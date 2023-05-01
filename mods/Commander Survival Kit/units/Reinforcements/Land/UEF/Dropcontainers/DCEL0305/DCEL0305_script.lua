#****************************************************************************
#**
#**  File     :  units/XRL0002/XRL0002_script.lua
#**
#**  Summary  :  Crab egg
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TAirFactoryUnit = import('/lua/defaultunits.lua').FactoryUnit

DCEL0305 = Class(TAirFactoryUnit) {

    ContrailEffects = {'/effects/emitters/contrail_polytrail_01_emit.bp',},
    BeamExhaustCruise = '/effects/emitters/air_move_trail_beam_03_emit.bp',
    BeamExhaustIdle = '/effects/emitters/air_idle_trail_beam_01_emit.bp',

    OnStopBeingBuilt = function(self, builder, layer)
        TAirFactoryUnit.OnStopBeingBuilt(self,builder,layer)
        local bp = self:GetBlueprint()
        local buildUnit = bp.Economy.BuildUnit
        
        local pos = self:GetPosition()
        
        local aiBrain = self:GetAIBrain()
        CreateUnitHPR(
            buildUnit,
            aiBrain.Name,
            pos[1], pos[2], pos[3],
            0, 0, 0
        )
        ForkThread( function()
		
						self.Effect1 = CreateAttachedEmitter(self,'L_Engine1_Exhaust1',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
						self.Trash:Add(self.Effect1)
						self.Effect2 = CreateAttachedEmitter(self,'L_Engine1_Exhaust2',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
						self.Trash:Add(self.Effect2)
						self.Effect3 = CreateAttachedEmitter(self,'L_Engine2_Exhaust1',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
						self.Trash:Add(self.Effect3)
						self.Effect4 = CreateAttachedEmitter(self,'L_Engine2_Exhaust2',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
						self.Trash:Add(self.Effect4)
						self.Effect5 = CreateAttachedEmitter(self,'R_Engine1_Exhaust1',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
						self.Trash:Add(self.Effect5)
						self.Effect6 = CreateAttachedEmitter(self,'R_Engine1_Exhaust2',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
						self.Trash:Add(self.Effect6)
						self.Effect7 = CreateAttachedEmitter(self,'R_Engine2_Exhaust1',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
						self.Trash:Add(self.Effect7)
						self.Effect8 = CreateAttachedEmitter(self,'R_Engine2_Exhaust2',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
						self.Trash:Add(self.Effect8)
						self.Drone = CreateSlider(self, 'Drone', 0, 800, 250, 25)
                        self.Trash:Add(self.Drone)
                        self.OpenAnimManip = CreateAnimator(self)
                        self.Trash:Add(self.OpenAnimManip)
                        self.OpenAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen, false):SetRate(0.1)
                        
                        
                        self:PlaySound(bp.Audio['EggOpen'])
                        WaitFor(self.OpenAnimManip)
                        
                        #CreateSlider(unit, bone, [goal_x, goal_y, goal_z, [speed,
                        self.EggSlider = CreateSlider(self, 0, 0, -20, 0, 5)
                        self.Trash:Add(self.EggSlider)
                        
                        self:PlaySound(bp.Audio['EggSink'])
                        WaitFor(self.EggSlider)
                        
                        self:Destroy()
                    end
                  )
        
        #ChangeState( self, self.EggConstruction )
    end,
    
    EggConstruction = State {
        Main = function(self)
            local bp = self:GetBlueprint()
            local buildUnit = bp.Economy.BuildUnit
            self:GetAIBrain():BuildUnit( self, buildUnit, 1 )
        end,
    },
    
    OnStopBuild = function(self, unitBeingBuilt, order)
        if unitBeingBuilt:GetFractionComplete() == 1 then
            ForkThread(function()
                WaitSeconds(0.1)
                self:Destroy()
            end)
        end
    end,
	
	OnDestroy = function(self)
        TAirFactoryUnit.OnDestroy(self)
		self:HideBone( 'Drone', true )
    end,
	
	OnKilled = function(self)
        TAirFactoryUnit.OnKilled(self)
		self:HideBone( 'Drone', true )
    end,
}
TypeClass = DCEL0305