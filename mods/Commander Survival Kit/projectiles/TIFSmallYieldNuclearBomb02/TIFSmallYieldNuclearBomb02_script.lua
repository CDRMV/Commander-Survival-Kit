#
# UEF Small Yield Nuclear Bomb
#

local EffectTemplate = import('/lua/EffectTemplates.lua')
local TIFSmallYieldNuclearBombProjectile = import('/lua/terranprojectiles.lua').TArtilleryAntiMatterProjectile
TIFSmallYieldNuclearBomb02 = Class(TIFSmallYieldNuclearBombProjectile) {
	PolyTrail = '/effects/emitters/default_polytrail_04_emit.bp',
	FxLandHitScale = 0.5,
    FxUnitHitScale = 0.5,
	FxImpactWater = EffectTemplate.DefaultProjectileWaterImpact,
	FxImpactWaterScale = 1.5,
}

TypeClass = TIFSmallYieldNuclearBomb02