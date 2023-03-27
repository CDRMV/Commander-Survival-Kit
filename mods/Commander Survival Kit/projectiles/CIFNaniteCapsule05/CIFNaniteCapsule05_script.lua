#
# UEF Small Yield Nuclear Bomb
#
local NaniteCapsule5Projectile = import('/mods/Commander Survival Kit/lua/FireSupportProjectiles.lua').NaniteCapsule5Projectile
local ModEffectpath = '/mods/Commander Survival Kit/effects/emitters/'
CIFNaniteCapsule05 = Class(NaniteCapsule5Projectile) {

	OnImpact = function(self, TargetType, targetEntity)

		NaniteCapsule5Projectile.OnImpact( self, TargetType, targetEntity )
		local location = self:GetPosition()
		local ShieldUnit =CreateUnitHPR('URFSSP05XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
	end,

}

TypeClass = CIFNaniteCapsule05