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

local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local AIFMediumArtilleryStrike = import('/mods/Reinforcement Manager/lua/FireSupportStrikes.lua').AIFMediumArtilleryStrike

UAFS0400 = Class(AAirUnit) {

    Weapons = {
        Turret01 = Class(AIFMediumArtilleryStrike) {},
    },
    OnCreate = function(self)
        AAirUnit.OnCreate(self)
		
        self:ForkThread(function()
            WaitSeconds(10) 		-- Time Windwo to select the Unit and order it to fire on the Ground
			self:Destroy()			-- Unit will be destroyed 
        end)
    end,
}

TypeClass = UAFS0400