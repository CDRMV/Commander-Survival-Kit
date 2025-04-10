#****************************************************************************
#**
#**  UEF Medium Artillery Strike
#**  Author(s):  CDRMV
#**
#**  Summary  :  A Dummy Unit which fires Artillery Strikes below it. 
#**				 It is Selectable and Untargetable by enemy Units.				
#**				 It attacks enemy Units automatically in Range and will be destroyed after 10 Seconds.
#**              
#**  Copyright © 2022 Fire Support Manager by CDRMV
#****************************************************************************

local SAirUnit = import('/lua/defaultunits.lua').AirUnit
local AIFMediumArtilleryStrike = import('/mods/Commander Survival Kit/lua/FireSupportBarrages.lua').AIFMediumArtilleryStrike

XSFSSP0100 = Class(SAirUnit) {

	
    OnCreate = function(self)
        SAirUnit.OnCreate(self)
        self:ForkThread(function()
		WaitSeconds(1)	
		local location = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local ShieldUnit =CreateUnitHPR('XSFSSP0100b', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:Destroy()	
        end)
    end,
}

TypeClass = XSFSSP0100