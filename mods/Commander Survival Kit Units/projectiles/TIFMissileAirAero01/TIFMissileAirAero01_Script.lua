#
# Terran Land-Based Cruise Missile
#
local TMissileCruiseProjectile = import('/lua/terranprojectiles.lua').TMissileCruiseProjectile02
local Explosion = import('/lua/defaultexplosions.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')

TIFMissileAirAero01 = Class(TMissileCruiseProjectile) {
    
	FxImpactUnit = EffectTemplate.TMissileHit02,
    FxImpactAirUnit = EffectTemplate.TMissileHit02,
    FxImpactProp = EffectTemplate.TMissileHit02,    
    FxImpactLand = EffectTemplate.TMissileHit02,
	FxAirUnitHitScale = 1,
    FxLandHitScale = 1,
    FxNoneHitScale = 1,
    FxPropHitScale = 1,
    FxProjectileHitScale = 1,
    FxProjectileUnderWaterHitScale = 1,
    FxShieldHitScale = 1,
    FxUnderWaterHitScale = 1,
    FxUnitHitScale = 1,
    FxWaterHitScale = 1,
    FxOnKilledScale = 1,
    BeamName = '/mods/Commander Survival Kit Units/effects/emitters/aeromissile_exhaust_fire_beam_01_emit.bp',
    FxTrails = EffectTemplate.TMissileExhaust03,
	FxTrailScale = 0.5,
}
TypeClass = TIFMissileAirAero01

