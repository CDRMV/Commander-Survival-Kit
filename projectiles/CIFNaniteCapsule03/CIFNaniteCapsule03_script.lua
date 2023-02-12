#
# UEF Small Yield Nuclear Bomb
#
local NaniteCapsule3Projectile = import('/mods/Commander Survival Kit/lua/FireSupportProjectiles.lua').NaniteCapsule3Projectile
local ModEffectpath = '/mods/Commander Survival Kit/effects/emitters/'
CIFNaniteCapsule03 = Class(NaniteCapsule3Projectile) {

	OnImpact = function(self, TargetType, targetEntity)

		NaniteCapsule3Projectile.OnImpact( self, TargetType, targetEntity )
		local location = self:GetPosition()
		local ShieldUnit =CreateUnitHPR('URFSSP03XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
	end,

}

TypeClass = CIFNaniteCapsule03