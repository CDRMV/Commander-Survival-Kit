#
# UEF Small Yield Nuclear Bomb
#
local NaniteCapsuleProjectile = import('/mods/Commander Survival Kit/lua/FireSupportProjectiles.lua').NaniteCapsuleProjectile
local ModEffectpath = '/mods/Commander Survival Kit/effects/emitters/'
CIFNaniteCapsule01 = Class(NaniteCapsuleProjectile) {

	OnImpact = function(self, TargetType, targetEntity)

		NaniteCapsuleProjectile.OnImpact( self, TargetType, targetEntity )
		local location = self:GetPosition()
		local ShieldUnit =CreateUnitHPR('URFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
	end,

}

TypeClass = CIFNaniteCapsule01