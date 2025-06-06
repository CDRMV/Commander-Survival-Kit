#****************************************************************************
#**
#**  UEF Medium Artillery Strike
#**  Author(s):  CDRMV
#**
#**  Summary  :  A Dummy Unit which fires Artillery Strikes below it. 
#**				 It is Selectable and Untargetable by enemy Units.				
#**				 It attacks enemy Units automatically in Range and will be destroyed after 10 Seconds.
#**              
#**  Copyright � 2022 Fire Support Manager by CDRMV
#****************************************************************************

local AirUnit = import('/lua/defaultunits.lua').AirUnit
local DefaultProjectileWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon2
local R, Ceil = Random, math.ceil
UCRL0305 = Class(AirUnit) {

    Weapons = {
        Turret01 = Class(DefaultProjectileWeapon) {},
    },
	
	
    OnStopBeingBuilt = function(self, builder, layer)
        AirUnit.OnStopBeingBuilt(self, builder, layer)
        self:ForkThread(
            function()
                self.AimingNode = CreateRotator(self, 0, 'x', 90, 10000, 10000, 1000)
                WaitFor(self.AimingNode)
				local interval = 0
                while (interval < 3) do
				LOG(interval)
					if interval == 2 then 
						self:Destroy()	
					end
                    local num = Ceil((R()+R()+R()+R()+R()+R()+R()+R()+R()+R()+R())*R(1,10))
                    coroutine.yield(num)
                    self:GetWeaponByLabel'Turret01':FireWeapon()
					interval = interval + 1
                end
            end
        )
    end,
}

TypeClass = UCRL0305