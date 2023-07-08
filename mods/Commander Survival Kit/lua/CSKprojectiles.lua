local Projectile = import('/lua/sim/projectile.lua').Projectile
local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local MultiPolyTrailProjectile = DefaultProjectileFile.MultiPolyTrailProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/CSKEffectTemplates.lua')



#------------------------------------------------------------------------
#  Cybran PROJECTILES
#------------------------------------------------------------------------

CPenProjectile = Class(EmitterProjectile) {
    FxTrails = ModEffectTemplate.CybranPenWeapon,

    # Hit Effects
    FxImpactUnit = EffectTemplate.CNanoDartUnitHit01,
    FxImpactProp = EffectTemplate.CArtilleryHit01,
    FxImpactLand = EffectTemplate.CArtilleryHit01,
    FxImpactUnderWater = {},
}



