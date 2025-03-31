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

local StructureUnit = import('/lua/defaultunits.lua').StructureUnit
local DefaultProjectileWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon
local ModEffectpath = '/mods/Commander Survival Kit/effects/emitters/'
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

UTX0100 = Class(StructureUnit) {
    Weapons = {
        Earthquake = Class(DefaultProjectileWeapon) {},
    },
	
    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
		self:ForkThread(
            function()
			self:HideBone('UTX0100', true)
				local interval = 0
                while (interval < 21) do
				LOG(interval)
					if interval == 20 then 
						self:Destroy()
					end
					DamageArea(self, self:GetPosition(), 20, 5, 'Normal', false, false)
					local rotation = RandomFloat(0,2*math.pi)
					local size = RandomFloat(40.75,50.0)
					CreateDecal(self:GetPosition(), rotation, 'River002_normals', '', 'Normals', size, size, 150, 15, self:GetArmy())
					self:ShakeCamera(100, 10, 0, 10)
					interval = interval + 1
					WaitSeconds(1)
                end
            end
        )
    end,

}

TypeClass = UTX0100