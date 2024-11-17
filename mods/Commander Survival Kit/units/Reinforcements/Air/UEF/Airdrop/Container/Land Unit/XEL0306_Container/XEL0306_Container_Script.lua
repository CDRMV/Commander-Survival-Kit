#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0202/UEL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TLandUnit = import('/lua/defaultunits.lua').MobileUnit

XEL0306_Container = Class(TLandUnit) {

TransportAnimation  = function(self, rate)
		ForkThread( function()
		WaitSeconds(5)
        local bp = self:GetBlueprint()
        local buildUnit = bp.Economy.BuildUnit
        
        local pos = self:GetPosition()

        local aiBrain = self:GetAIBrain()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
        self.Unit = CreateUnitHPR(
            'XEL0306',
            aiBrain.Name,
            pos[1], pos[2], pos[3],
            0, 0, 0
        )
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self.Unit:AttachBoneTo(0, self, 'Build')
                        self.OpenAnimManip = CreateAnimator(self)
                        self.Trash:Add(self.OpenAnimManip)
                        self.OpenAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen, false):SetRate(0.1)
                   
                        WaitFor(self.OpenAnimManip)
                        self.Unit:DetachFrom()
                        
                        self:Destroy()
                    end
        )
		TLandUnit.TransportAnimation(self, rate)
    end,

}

TypeClass = XEL0306_Container