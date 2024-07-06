#****************************************************************************
#**
#**  File     :  units/XRL0002/XRL0002_script.lua
#**
#**  Summary  :  Crab egg
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TMobileFactoryUnit = import('/lua/defaultunits.lua').MobileUnit

UEB5105 = Class(TMobileFactoryUnit) {

	OnStopBeingBuilt = function(self,builder,layer)
        TMobileFactoryUnit.OnStopBeingBuilt(self,builder,layer)
        ChangeState(self, self.EggConstruction)
    end,

	EggConstruction = State {
        Main = function(self)
            local bp = self:GetBlueprint()
            local buildUnit = bp.Economy.BuildableCategory
        end,
    },
    
    OnStopBuild = function(self, unitBeingBuilt, order)
        if unitBeingBuilt:GetFractionComplete() == 1 then
		        ForkThread( function()
                        self.OpenAnimManip = CreateAnimator(self)
                        self.Trash:Add(self.OpenAnimManip)
                        self.OpenAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen, false):SetRate(1.5)
						WaitFor(self.OpenAnimManip)
						
						self.EggSlider = CreateSlider(self, 0, 0, -5, 0, 5)
                        self.Trash:Add(self.EggSlider)
                        WaitFor(self.EggSlider)
						self:Destroy()
                end
            )
        end
    end,
}

TypeClass = UEB5105