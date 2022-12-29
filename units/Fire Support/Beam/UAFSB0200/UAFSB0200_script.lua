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
local ModWeaponsFile = import("/mods/Commander Survival Kit/lua/FireSupportBarrages.lua")
local ADFTeniumLaser = ModWeaponsFile.ADFTeniumLaser
local ADFTeniumCannonWeapon = ModWeaponsFile.ADFTeniumCannonWeapon
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

UAFSB0200 = Class(AAirUnit) {

    Weapons = {
        Beam = Class(ADFTeniumLaser) {},
		MainGun = Class(ADFTeniumCannonWeapon) {}
    },
    OnCreate = function(self)
        AAirUnit.OnCreate(self)
		
		self:ForkThread(
            function()
                self.AimingNode = CreateRotator(self, 0, 'x', 0, 10000, 10000, 1000)
                WaitFor(self.AimingNode)
				local interval = 0
                while (interval < 5) do
				LOG(interval)
					if interval == 4 then 
						self:Destroy()
					end
                    local num = Ceil((R()+R()+R()+R()+R()+R()+R()+R()+R()+R()+R())*R(1,10))
                    coroutine.yield(num)
                    self:GetWeaponByLabel'Beam':FireWeapon()
					self:GetWeaponByLabel'MainGun':FireWeapon()
					WaitSeconds(3)
					interval = interval + 1
                end
            end
        )
    end,
}

TypeClass = UAFSB0200