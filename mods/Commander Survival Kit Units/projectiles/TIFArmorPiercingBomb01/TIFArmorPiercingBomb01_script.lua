local EffectTemplate = import('/lua/EffectTemplates.lua')
local TArtilleryProjectilePolytrail = import('/lua/terranprojectiles.lua').TArtilleryProjectilePolytrail
TIFArmorPiercingBomb01 = Class(TArtilleryProjectilePolytrail) {
	FxImpactTrajectoryAligned = false,
	PolyTrail = '/effects/emitters/default_polytrail_04_emit.bp',
	FxLandHitScale = 1.5,
    FxUnitHitScale = 1.5,
	FxImpactUnit = EffectTemplate.TAPDSHitUnit01,
    FxImpactLand = EffectTemplate.TAPDSHit01,
}

TypeClass = TIFArmorPiercingBomb01