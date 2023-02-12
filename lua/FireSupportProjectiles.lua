local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile
local WeaponFile = import('/lua/sim/DefaultWeapons.lua')
local CollisionBeams = import('/lua/defaultcollisionbeams.lua')
local BareBonesWeapon = WeaponFile.BareBonesWeapon
local DefaultProjectileWeapon = WeaponFile.DefaultProjectileWeapon
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile
local GinsuCollisionBeam = CollisionBeams.GinsuCollisionBeam
local OrbitalDeathLaserCollisionBeam = CollisionBeams.OrbitalDeathLaserCollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile

ATeniumProjectile = Class(SinglePolyTrailProjectile) {

	PolyTrail = ModEffectTemplate.ATeniumPolytrail01,
    FxTrails = ModEffectTemplate.ATeniumMunition01,

	# Hit Effects
    FxImpactUnit = {},
    FxImpactProp = {},
    FxImpactLand = {},
    FxImpactShield = EffectTemplate.ADisruptorHitShield,
	
	FxLandHitScale = 5,
}

SBOAAntheProjectile = Class(EmitterProjectile) {
    FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.SZthuthaamArtilleryProjectileFXTrails,
	FxImpactUnit = EffectTemplate.SZhanaseeBombHit01,
    FxImpactProp = EffectTemplate.SZhanaseeBombHit01,
    FxImpactAirUnit = EffectTemplate.SZhanaseeBombHit01,
    FxImpactLand = EffectTemplate.SZhanaseeBombHit01,
    FxImpactUnderWater = {},
}


CNaniteProjectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites01,
    FxImpactProp = ModEffectTemplate.CNanites01,
    FxImpactLand = ModEffectTemplate.CNanites01,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 0.3,
	FxUnitScale = 0.3,
	FxPropHitScale = 0.3,
}

CNanite2Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites01,
    FxImpactProp = ModEffectTemplate.CNanites01,
    FxImpactLand = ModEffectTemplate.CNanites01,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 0.6,
	FxUnitScale = 0.6,
	FxPropHitScale = 0.6,
}

CNanite3Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites01,
    FxImpactProp = ModEffectTemplate.CNanites01,
    FxImpactLand = ModEffectTemplate.CNanites01,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 0.9,
	FxUnitScale = 0.9,
	FxPropHitScale = 0.9,
}

CNanite4Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites01,
    FxImpactProp = ModEffectTemplate.CNanites01,
    FxImpactLand = ModEffectTemplate.CNanites01,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 1.2,
	FxUnitScale = 1.2,
	FxPropHitScale = 1.2,
}

CNanite5Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites01,
    FxImpactProp = ModEffectTemplate.CNanites01,
    FxImpactLand = ModEffectTemplate.CNanites01,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 1.5,
	FxUnitScale = 1.5,
	FxPropHitScale = 1.5,
}

NaniteCapsuleProjectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites02,
    FxImpactProp = ModEffectTemplate.CNanites02,
    FxImpactLand = ModEffectTemplate.CNanites02,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 0.3,
	FxUnitScale = 0.3,
	FxPropHitScale = 0.3,
}

NaniteCapsule2Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites02,
    FxImpactProp = ModEffectTemplate.CNanites02,
    FxImpactLand = ModEffectTemplate.CNanites02,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 0.6,
	FxUnitScale = 0.6,
	FxPropHitScale = 0.6,
}

NaniteCapsule3Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites02,
    FxImpactProp = ModEffectTemplate.CNanites02,
    FxImpactLand = ModEffectTemplate.CNanites02,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 0.9,
	FxUnitScale = 0.9,
	FxPropHitScale = 0.9,
}

NaniteCapsule4Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites02,
    FxImpactProp = ModEffectTemplate.CNanites02,
    FxImpactLand = ModEffectTemplate.CNanites02,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 1.2,
	FxUnitScale = 1.2,
	FxPropHitScale = 1.2,
}

NaniteCapsule5Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites02,
    FxImpactProp = ModEffectTemplate.CNanites02,
    FxImpactLand = ModEffectTemplate.CNanites02,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 1.5,
	FxUnitScale = 1.5,
	FxPropHitScale = 1.5,
}