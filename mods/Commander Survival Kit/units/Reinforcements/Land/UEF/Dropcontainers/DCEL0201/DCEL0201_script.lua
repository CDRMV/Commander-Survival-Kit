#****************************************************************************
#**
#**  File     :  units/XRL0002/XRL0002_script.lua
#**
#**  Summary  :  Crab egg
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TAirFactoryUnit = import('/lua/terranunits.lua').TAirFactoryUnit

DCEL0201 = Class(TAirFactoryUnit) {



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
		
						self.Drone = CreateSlider(self, 'Drone', 0, 800, 200, 25)
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
}
TypeClass = DCEL0201