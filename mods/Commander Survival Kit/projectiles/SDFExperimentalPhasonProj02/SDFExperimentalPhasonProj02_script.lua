#****************************************************************************
#**
#**  File     :  /data/projectiles/SDFExperimentalPhasonProj01/SDFExperimentalPhasonProj01_script.lua
#**  Author(s):  Matt Vainio
#**
#**  Summary  :  Experimental Phason Projectile script, XSL0401
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
local SDFExperimentalPhasonProjectile = import('/lua/seraphimprojectiles.lua').SDFExperimentalPhasonProjectile
SDFExperimentalPhasonProj02 = Class(SDFExperimentalPhasonProjectile) {

	OnImpact = function(self, TargetType, targetEntity)

		SDFExperimentalPhasonProjectile.OnImpact( self, TargetType, targetEntity )
		local location = self:GetPosition()
		local ShieldUnit =CreateUnitHPR('XSL0402b', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
	end,

}

TypeClass = SDFExperimentalPhasonProj02

