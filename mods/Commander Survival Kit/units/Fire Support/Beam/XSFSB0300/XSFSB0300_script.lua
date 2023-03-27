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
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SDFUltraChromaticBeamGenerator = SeraphimWeapons.SDFUltraChromaticBeamGenerator02
local SIFBombZhanaseeWeapon = SeraphimWeapons.SIFBombZhanaseeWeapon
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

XSFSB0300 = Class(SAirUnit) {

    Weapons = {
        Beam = Class(SDFUltraChromaticBeamGenerator) {},
		        Beam2 = Class(SDFUltraChromaticBeamGenerator) {},
		Bomb2 = Class(SIFBombZhanaseeWeapon) {},
    },
    OnCreate = function(self)
        SAirUnit.OnCreate(self)
		self.Spinners = {
            Spinner1 = CreateRotator(self, 'Spinner', 'y', nil, 0, 60, -360):SetTargetSpeed(20),
			Spinner2 = CreateRotator(self, 'Spinner2', 'y', nil, 0, 60, 360):SetTargetSpeed(60),
        }
        for k, v in self.Spinners do
            self.Trash:Add(v)
        end
		self:ForkThread(
            function()
                self.AimingNode = CreateRotator(self, 0, 'x', 0, 10000, 10000, 1000)
                WaitFor(self.AimingNode)
				local interval = 0
                while (interval < 10) do
				LOG(interval)
					if interval == 9 then 
						self:Destroy()
					end
                    local num = Ceil((R()+R()+R()+R()+R()+R()+R()+R()+R()+R()+R())*R(1,10))
                    coroutine.yield(num)
                    self:GetWeaponByLabel'Beam':FireWeapon()
					self:GetWeaponByLabel'Beam2':FireWeapon()
					self:GetWeaponByLabel'Bomb2':FireWeapon()
					WaitSeconds(3)
					interval = interval + 1
                end
            end
        )
    end,
}

TypeClass = XSFSB0300