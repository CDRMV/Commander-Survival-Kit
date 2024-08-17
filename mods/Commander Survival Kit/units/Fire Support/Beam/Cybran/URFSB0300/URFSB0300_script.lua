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
local ModWeaponsFile = import("/mods/Commander Survival Kit/lua/FireSupportBarrages.lua")
local CDFHeavyMicrowaveLaserGeneratorCom3 = ModWeaponsFile.CDFHeavyMicrowaveLaserGeneratorCom3
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

URFSB0300 = Class(CAirUnit) {

    Weapons = {
        Beam = Class(CDFHeavyMicrowaveLaserGeneratorCom3) {},
    },
    OnCreate = function(self)
        CAirUnit.OnCreate(self)
		self.Spinners = {
            Spinner1 = CreateRotator(self, 'UEA0203', 'y', nil, 0, 60, 360):SetTargetSpeed(180),
        }
        for k, v in self.Spinners do
            self.Trash:Add(v)
        end
		self:ForkThread(
            function()
				local interval = 0
                while (interval < 6) do
				LOG(interval)
					if interval == 5 then 
						self:Destroy()
					end
                    local num = Ceil((R()+R()+R()+R()+R()+R()+R()+R()+R()+R()+R())*R(1,10))
                    coroutine.yield(num)
                    self:GetWeaponByLabel'Beam':FireWeapon()
					WaitSeconds(3)
					interval = interval + 1
                end
            end
        )
    end,
}

TypeClass = URFSB0300