#
# UEF Small Yield Nuclear Bomb
#
local NaniteCapsule4Projectile = import('/mods/Commander Survival Kit/lua/FireSupportProjectiles.lua').NaniteCapsule4Projectile
local ModEffectpath = '/mods/Commander Survival Kit/effects/emitters/'
CIFNaniteCapsule04 = Class(NaniteCapsule4Projectile) {

	OnImpact = function(self, TargetType, targetEntity)

		NaniteCapsule4Projectile.OnImpact( self, TargetType, targetEntity )
		local location = self:GetPosition()
		local ShieldUnit =CreateUnitHPR('URFSSP04XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
	end,

}

TypeClass = CIFNaniteCapsule04