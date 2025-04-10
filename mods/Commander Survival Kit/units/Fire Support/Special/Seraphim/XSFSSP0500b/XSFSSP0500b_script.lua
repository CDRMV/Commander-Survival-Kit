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

XSFSSP0500b = Class(StructureUnit) {

	
    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
		self:CreateProjectile('/mods/Commander Survival Kit/effects/Entities/SmallDimensional/SmallDimensional_proj.bp',0,0,0,0,0,1) 
    end,

}

TypeClass = XSFSSP0500b