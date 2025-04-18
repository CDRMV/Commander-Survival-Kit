local Projectile = import('/lua/sim/projectile.lua').Projectile
local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local MultiPolyTrailProjectile = DefaultProjectileFile.MultiPolyTrailProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/Commander Survival Kit Units/lua/CSKUnitsEffectTemplates.lua')
local NullShell = DefaultProjectileFile.NullShell


#------------------------------------------------------------------------
#  Cybran PROJECTILES
#------------------------------------------------------------------------

CNaniteCloud01 = Class(EmitterProjectile) {
    FxTrails = {
	'/mods/Commander Survival Kit Units/Effects/Emitters/NaniteTrailFX.bp',
	'/mods/Commander Survival Kit Units/Effects/Emitters/NaniteTrailFX2.bp',
	'/mods/Commander Survival Kit Units/Effects/Emitters/NaniteTrailFX3.bp',
	},
	
	FxTrailScale = 2,
    
    FxImpactTrajectoryAligned = false,

    FxImpactUnit = ModEffectTemplate.CNanites01,
    FxImpactProp = ModEffectTemplate.CNanites01,
    FxImpactLand = ModEffectTemplate.CNanites01,
    FxImpactWater = EffectTemplate.TNapalmCarpetBombHitWater01,
    FxImpactUnderWater = {},
}

CNaniteCloud02 = Class(EmitterProjectile) {
    FxTrails = {
	'/mods/Commander Survival Kit Units/Effects/Emitters/NaniteTrailFX.bp',
	'/mods/Commander Survival Kit Units/Effects/Emitters/NaniteTrailFX2.bp',
	'/mods/Commander Survival Kit Units/Effects/Emitters/NaniteTrailFX3.bp',
	},
	
	FxTrailScale = 0.5,
    
    FxImpactTrajectoryAligned = false,

    FxImpactUnit = ModEffectTemplate.CNanites01,
    FxImpactProp = ModEffectTemplate.CNanites01,
    FxImpactLand = ModEffectTemplate.CNanites01,
    FxImpactWater = EffectTemplate.TNapalmCarpetBombHitWater01,
    FxImpactUnderWater = {},
}

CPenProjectile = Class(EmitterProjectile) {
    FxTrails = ModEffectTemplate.CybranPenWeapon,

    # Hit Effects
    FxImpactUnit = EffectTemplate.CNanoDartUnitHit01,
    FxImpactProp = EffectTemplate.CArtilleryHit01,
    FxImpactLand = EffectTemplate.CArtilleryHit01,
    FxImpactUnderWater = {},
}

PhotonicProjectile = Class(MultiPolyTrailProjectile) {

    PolyTrails = {
    		'/mods/Commander Survival Kit Units/effects/Emitters/InstablePhotonic_emit.bp',
	},
	PolyTrailOffset = {0,0},

    # Hit Effects
    FxImpactUnit = EffectTemplate.CHvyProtonCannonHitUnit,
    FxImpactProp = EffectTemplate.CHvyProtonCannonHitUnit,
    FxImpactLand = EffectTemplate.CHvyProtonCannonHitLand,
    FxImpactUnderWater = EffectTemplate.CHvyProtonCannonHit01,
    FxImpactWater = EffectTemplate.CHvyProtonCannonHit01,
    FxImpactUnderWater = {},
}

CLaserIridiumProjectile = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        '/mods/Commander Survival Kit Units/effects/emitters/Iridium_Laser_emit.bp',
	},
	PolyTrailOffset = {0,0}, 
	
    # Hit Effects
    FxImpactUnit = EffectTemplate.TMissileHit01,
    FxImpactLand = EffectTemplate.TMissileHit01,
    FxImpactProp = EffectTemplate.TMissileHit01,
    FxImpactUnderWater = {},
}

#------------------------------------------------------------------------
#  UEF PROJECTILES
#------------------------------------------------------------------------

TDFCargoProjectile = Class(SinglePolyTrailProjectile) {
    DestroyOnImpact = false,
    FxTrails = EffectTemplate.TMissileExhaust02,
    FxTrailOffset = -1,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',

    FxImpactUnit = EffectTemplate.TMissileHit01,
    FxImpactLand = EffectTemplate.TMissileHit01,
    FxImpactProp = EffectTemplate.TMissileHit01,
    FxImpactUnderWater = {},

    OnImpact = function(self, targetType, targetEntity)
        if targetType == 'Terrain' then
			local location = self:GetPosition()
			local ShieldUnit =CreateUnitHPR('UEB5105', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
		else
		
		end
        SingleBeamProjectile.OnImpact(self, targetType, targetEntity)
    end,
}

THeavyGreenPlasmaCannonProjectile = Class(MultiPolyTrailProjectile) {
    FxTrails = ModEffectTemplate.TPlasmaCannonGreenHeavyMunition,
    RandomPolyTrails = 1,
    PolyTrailOffset = {0,0,0},
    PolyTrails = EffectTemplate.TPlasmaCannonHeavyPolyTrails,
    FxImpactUnit = ModEffectTemplate.TGreenPlasmaCannonHeavyHitUnit01,
    FxImpactProp = ModEffectTemplate.TGreenPlasmaCannonHeavyHitUnit01,
    FxImpactLand = ModEffectTemplate.TGreenPlasmaCannonHeavyHit01,
}

TSuperPlasmaCannonProjectile = Class(MultiPolyTrailProjectile) {
    FxTrails = EffectTemplate.TPlasmaCannonHeavyMunition,
    RandomPolyTrails = 1,
    PolyTrailOffset = {0,0,0},
	FxTrailScale = 3.5,
    PolyTrails = EffectTemplate.TPlasmaCannonHeavyPolyTrails,
    FxImpactUnit = EffectTemplate.TPlasmaCannonHeavyHitUnit01,
    FxImpactProp = EffectTemplate.TPlasmaCannonHeavyHitUnit01,
    FxImpactLand = EffectTemplate.TPlasmaCannonHeavyHit01,
	FxLandHitScale = 3.5,
    FxPropHitScale = 3.5,
    FxUnitHitScale = 3.5,
    FxNoneHitScale = 3.5,
}

TFreezerGrenade = Class(MultiPolyTrailProjectile) {
    FxTrails= EffectTemplate.THeavyFragmentationGrenadeFxTrails,
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = EffectTemplate.TGaussCannonHitUnit01,
    FxImpactProp = EffectTemplate.TGaussCannonHitUnit01,
	FxImpactWater = EffectTemplate.DefaultProjectileWaterImpact,
    FxImpactLand = EffectTemplate.CArtilleryHit01,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

Flamethrower01 = Class(EmitterProjectile) {
    FxTrails = {'/mods/Commander Survival Kit Units/Effects/Emitters/FlamerthrowerTrailFX.bp',},
    
    FxImpactTrajectoryAligned = false,

    FxImpactUnit = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactProp = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactLand = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactWater = EffectTemplate.TNapalmCarpetBombHitWater01,
    FxImpactUnderWater = {},
}

Flamethrower02 = Class(EmitterProjectile) {
    FxTrails = {'/mods/Commander Survival Kit Units/Effects/Emitters/FlamerthrowerTrailFX.bp',},
       FxTrailScale = 0.5,
    
    FxImpactTrajectoryAligned = false,

    FxImpactUnit = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactProp = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactLand = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactWater = EffectTemplate.TNapalmCarpetBombHitWater01,
    FxImpactUnderWater = {},
    FxLandHitScale = 0.5,
    FxPropHitScale = 0.5,
    FxUnitHitScale = 0.5,
    FxNoneHitScale = 0.5,
}

THeavyMaserCannonProjectile = Class(EmitterProjectile) {
    FxTrails = 
	{
		'/mods/Commander Survival Kit Units/Effects/Emitters/maser_heavy_cannon_fxtrail_01_emit.bp',
		'/mods/Commander Survival Kit Units/Effects/Emitters/maser_heavy_cannon_fxtrail_02_emit.bp',
		'/mods/Commander Survival Kit Units/Effects/Emitters/maser_heavy_cannon_fxtrail_03_emit.bp',
		'/mods/Commander Survival Kit Units/Effects/Emitters/maser_heavy_cannon_fxtrail_04_emit.bp',
		'/mods/Commander Survival Kit Units/Effects/Emitters/maser_heavy_cannon_fxtrails_01_emit.bp',
		'/mods/Commander Survival Kit Units/Effects/Emitters/maser_heavy_cannon_fxtrails_02_emit.bp',
	},
   	FxTrailScale = 0.5,
    FxImpactTrajectoryAligned = false,
    FxImpactUnit = EffectTemplate.TPlasmaCannonHeavyHitUnit01,
    FxImpactProp = EffectTemplate.TPlasmaCannonHeavyHitUnit01,
    FxImpactLand = EffectTemplate.TPlasmaCannonHeavyHit01,
    FxImpactUnderWater = {},
    FxLandHitScale = 0.7,
    FxPropHitScale = 0.7,
    FxUnitHitScale = 0.7,
    FxNoneHitScale = 0.7,
    FxTrailOffset = 0,
}

TExperimentalMaserCannonProjectile = Class(EmitterProjectile) {
    FxTrails = 
	{
		'/mods/Commander Survival Kit Units/Effects/Emitters/maser_heavy_cannon_fxtrail_01_emit.bp',
		'/mods/Commander Survival Kit Units/Effects/Emitters/maser_heavy_cannon_fxtrail_02_emit.bp',
		'/mods/Commander Survival Kit Units/Effects/Emitters/maser_heavy_cannon_fxtrail_03_emit.bp',
		'/mods/Commander Survival Kit Units/Effects/Emitters/maser_heavy_cannon_fxtrail_04_emit.bp',
		'/mods/Commander Survival Kit Units/Effects/Emitters/maser_heavy_cannon_fxtrails_01_emit.bp',
		'/mods/Commander Survival Kit Units/Effects/Emitters/maser_heavy_cannon_fxtrails_02_emit.bp',
	},
   	FxTrailScale = 0.5,
    FxImpactTrajectoryAligned = false,
    FxImpactUnit = EffectTemplate.TPlasmaCannonHeavyHitUnit01,
    FxImpactProp = EffectTemplate.TPlasmaCannonHeavyHitUnit01,
    FxImpactLand = EffectTemplate.TPlasmaCannonHeavyHit01,
    FxImpactUnderWater = {},
    FxLandHitScale = 0.7,
    FxPropHitScale = 0.7,
    FxUnitHitScale = 0.7,
    FxNoneHitScale = 0.7,
    FxTrailOffset = 0,
}

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



