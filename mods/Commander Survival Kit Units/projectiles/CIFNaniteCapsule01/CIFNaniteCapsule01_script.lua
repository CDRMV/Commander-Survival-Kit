local DefaultProjectileFile = import("/lua/sim/defaultprojectiles.lua")
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')

CIFNaniteCapsule01 = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites02,
    FxImpactProp = ModEffectTemplate.CNanites02,
    FxImpactLand = ModEffectTemplate.CNanites02,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 0.3,
	FxUnitScale = 0.3,
	FxPropHitScale = 0.3,


	OnImpact = function(self, TargetType, targetEntity)

		SinglePolyTrailProjectile.OnImpact( self, TargetType, targetEntity )
		local location = self:GetPosition()
		local ShieldUnit =CreateUnitHPR('URFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
	end,

}

TypeClass = CIFNaniteCapsule01