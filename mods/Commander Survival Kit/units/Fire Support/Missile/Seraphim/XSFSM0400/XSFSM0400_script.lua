#****************************************************************************
#**
#**  UEF Medium Artillery Strike
#**  Author(s):  CDRMV
#**
#**  Summary  :  A Dummy Unit which fires Artillery Strikes below it. 
#**				 It is Selectable and Untargetable by enemy Units.				
#**				 It attacks enemy Units automatically in Range and will be destroyed after 5 Seconds.
#**              
#**  Copyright © 2022 Fire Support Manager by CDRMV
#****************************************************************************

local SAirUnit = import('/lua/defaultunits.lua').AirUnit
local TIFMediumArtilleryStrike = import('/mods/Commander Survival Kit/lua/FireSupportBarrages.lua').TIFMediumArtilleryStrike

XSFSM0400 = Class(SAirUnit) {

    Weapons = {
        Turret01 = Class(TIFMediumArtilleryStrike) {},
    },
    OnCreate = function(self)
        SAirUnit.OnCreate(self)
		
        self:ForkThread(function()
            WaitSeconds(5) 		-- Time Windwo to select the Unit and order it to fire on the Ground
			self:Destroy()			-- Unit will be destroyed 
        end)
    end,
}

TypeClass = XSFSM0400