#
# UEF Small Yield Nuclear Bomb
#
local NaniteCapsule2Projectile = import('/mods/Commander Survival Kit/lua/FireSupportProjectiles.lua').NaniteCapsule2Projectile
local ModEffectpath = '/mods/Commander Survival Kit/effects/emitters/'
CIFNaniteCapsule02 = Class(NaniteCapsule2Projectile) {

	OnImpact = function(self, TargetType, targetEntity)

		NaniteCapsule2Projectile.OnImpact( self, TargetType, targetEntity )
		local location = self:GetPosition()
		local ShieldUnit =CreateUnitHPR('URFSSP02XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
	end,

}

TypeClass = CIFNaniteCapsule02