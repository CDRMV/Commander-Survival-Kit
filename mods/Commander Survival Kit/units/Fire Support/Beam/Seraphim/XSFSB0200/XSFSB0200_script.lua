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

local SAirUnit = import('/lua/defaultunits.lua').AirUnit
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SDFUltraChromaticBeamGenerator = SeraphimWeapons.SDFUltraChromaticBeamGenerator02
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

XSFSB0100 = Class(SAirUnit) {

    Weapons = {
        Beam = Class(SDFUltraChromaticBeamGenerator) {},
    },
    OnCreate = function(self)
        SAirUnit.OnCreate(self)
		self.Spinners = {
            Spinner1 = CreateRotator(self, 'UEA0203', 'y', nil, 0, 60, 360):SetTargetSpeed(180),
        }
        for k, v in self.Spinners do
            self.Trash:Add(v)
        end
		self:ForkThread(
            function()
                self.AimingNode = CreateRotator(self, 0, 'x', 0, 10000, 10000, 1000)
                WaitFor(self.AimingNode)
				local interval = 0
                while (interval < 11) do
				LOG(interval)
					if interval == 10 then 
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

TypeClass = XSFSB0100