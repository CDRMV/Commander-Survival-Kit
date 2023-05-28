local DefaultProjectileFile = import("/lua/sim/defaultprojectiles.lua")
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')

URS0201NaniteCapsule = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites01,
    FxImpactProp = ModEffectTemplate.CNanites01,
    FxImpactLand = ModEffectTemplate.CNanites01,
    FxImpactUnderWater = {},
	FxImpactWater = ModEffectTemplate.CNanites01,
	
	FxLandHitScale = 1.3,
	FxUnitScale = 1.3,
	FxPropHitScale = 1.3,
	FxWaterHitScale = 1.3,


	OnImpact = function(self, TargetType, targetEntity)

		SinglePolyTrailProjectile.OnImpact( self, TargetType, targetEntity )
		local location = self:GetPosition()
		local ShieldUnit =CreateUnitHPR('URS0201', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
	end,

}

TypeClass = URS0201NaniteCapsule