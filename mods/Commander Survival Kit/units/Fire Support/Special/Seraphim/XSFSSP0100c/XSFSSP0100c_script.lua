#****************************************************************************
#**
#**  UEF Medium Artillery Strike
#**  Author(s):  CDRMV
#**
#**  Summary  :  A Dummy Unit which is designed for the Seraphim Dimensional Weapon 
#**				 It is Unselectable and Untargetable by enemy Units.				
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

XSFSSP0100c = Class(StructureUnit) {
    Weapons = {
        DimensionalShockwave = Class(DefaultProjectileWeapon) {},
    },
	
    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
		self:ForkThread(
            function()
			self:HideBone('XSFSSP0100c', true)
				local interval = 0
                while (interval < 13) do
				LOG(interval)
					if interval == 12 then 
						self:Destroy()
					end
					self:CreateProjectile( '/mods/Commander Survival Kit/projectiles/DimensionalInterference/DimensionalInterference_proj.bp', 0, 0, 0, 0, 0, 0)
					WaitSeconds(1)
					interval = interval + 1
                end
            end
        )
    end,

}

TypeClass = XSFSSP0100c