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

local AAirUnit = import('/lua/defaultunits.lua').AirUnit
local AIFMediumArtilleryStrike = import('/mods/Commander Survival Kit/lua/FireSupportBarrages.lua').AIFMediumArtilleryStrike
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

UAFSSP0300 = Class(AAirUnit) {

    Weapons = {
        Turret01 = Class(AIFMediumArtilleryStrike) {},
    },
    OnCreate = function(self)
        AAirUnit.OnCreate(self)
		
		self:ForkThread(
            function()
					local num = Ceil((R()+R()+R()+R()+R()+R()+R()+R()+R()+R()+R())*R(1,10))
                    coroutine.yield(num)
                    self:GetWeaponByLabel'Turret01':FireWeapon()
					WaitSeconds(5)
					self:Destroy()
            end
        )
    end,
}

TypeClass = UAFSSP0300