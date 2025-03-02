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

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local WeaponsFile = import("/lua/terranweapons.lua")
local ModWeaponsFile = import("/mods/Commander Survival Kit/lua/FireSupportBarrages.lua")
local TDFHiroPlasmaCannon2 = ModWeaponsFile.TDFHiroPlasmaCannon2
local TOrbitalDeathLaserBeamWeapon2 = ModWeaponsFile.TOrbitalDeathLaserBeamWeapon2
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

UEFSB0301 = Class(TAirUnit) {

    Weapons = {
        Beam = Class(TOrbitalDeathLaserBeamWeapon2) {},
		HiroBeam = Class(TDFHiroPlasmaCannon2) {},
    },
    OnCreate = function(self)
        TAirUnit.OnCreate(self)
		self.Spinners = {
            Spinner1 = CreateRotator(self, 'UEA0203', 'y', nil, 0, 60, 360):SetTargetSpeed(80),
        }
        for k, v in self.Spinners do
            self.Trash:Add(v)
        end
		self:ForkThread(
            function()
                self.AimingNode = CreateRotator(self, 0, 'x', 0, 10000, 10000, 1000)
                WaitFor(self.AimingNode)
				local interval = 0
                while (interval < 6) do
				LOG(interval)
					if interval == 5 then 
						self:Destroy()
					end
                    local num = Ceil((R()+R()+R()+R()+R()+R()+R()+R()+R()+R()+R())*R(1,10))
                    coroutine.yield(num)
					WaitSeconds(10)
                    self:GetWeaponByLabel'Beam':FireWeapon()
					self:GetWeaponByLabel'HiroBeam':FireWeapon()
					WaitSeconds(3)
					interval = interval + 1
                end
            end
        )
    end,
}

TypeClass = UEFSB0301