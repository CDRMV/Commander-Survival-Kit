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

local CAirUnit = import('/lua/defaultunits.lua').AirUnit
local CIFMediumArtilleryStrike = import('/mods/Commander Survival Kit/lua/FireSupportBarrages.lua').CIFMediumArtilleryStrike
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
URFSSP0400 = Class(CAirUnit) {

    Weapons = {
        Turret01 = Class(CIFMediumArtilleryStrike) {},
    },
    OnCreate = function(self)
        CAirUnit.OnCreate(self)
		
		self:ForkThread(
            function()
					local num = Ceil((R()+R()+R()+R()+R()+R()+R()+R()+R()+R()+R())*R(1,10))
                    coroutine.yield(num)
                    self:GetWeaponByLabel'Turret01':FireWeapon()
					WaitSeconds(0.1)
					self:Destroy()
            end
        )
    end,
}

TypeClass = URFSSP0400