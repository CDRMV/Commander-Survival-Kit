local DefaultProjectileFile = import("/lua/sim/defaultprojectiles.lua")
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')

Nanites5 = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites01,
    FxImpactProp = ModEffectTemplate.CNanites01,
    FxImpactLand = ModEffectTemplate.CNanites01,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 3.0,
	FxUnitScale = 3.0,
	FxPropHitScale = 3.0,

}

TypeClass = Nanites5
