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

local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local SIFMediumArtilleryStrike = import('/mods/Reinforcement Manager/lua/FireSupportStrikes.lua').SIFMediumArtilleryStrike

XSFSM0100 = Class(SAirUnit) {

    Weapons = {
        Turret01 = Class(SIFMediumArtilleryStrike) {},
    },
    OnCreate = function(self)
        SAirUnit.OnCreate(self)
		
        self:ForkThread(function()
            WaitSeconds(10) 		-- Time Windwo to select the Unit and order it to fire on the Ground
			self:Destroy()			-- Unit will be destroyed 
        end)
    end,
}

TypeClass = XSFSM0100