local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local MultiPolyTrailProjectile = DefaultProjectileFile.MultiPolyTrailProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')


CExperimentalDisintegratorPulseLaser = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
		'/effects/emitters/disintegrator_polytrail_02_emit.bp',
		'/effects/emitters/disintegrator_polytrail_03_emit.bp',
		'/effects/emitters/default_polytrail_03_emit.bp',
	},
	PolyTrailOffset = {0,0,0},    

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CExDisintegratorHitLand01,
    FxImpactProp = ModEffectTemplate.CExDisintegratorHitLand01,
    FxImpactLand = ModEffectTemplate.CExDisintegratorHitLand01,
    FxImpactUnderWater = {},
    FxTrails = EffectTemplate.CHvyProtonCannonFXTrail01,
	FxTrailScale = 1.5,
    FxTrailOffset = 0,
	FxLandHitScale = 1.7,
    FxPropHitScale = 1.7,
    FxUnitHitScale = 1.7,
    FxNoneHitScale = 1.7,
}


