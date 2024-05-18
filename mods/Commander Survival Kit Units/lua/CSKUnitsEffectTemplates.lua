ModBpPath = '/mods/Commander Survival Kit Units/effects/emitters/'
EmtBpPath = '/effects/emitters/'
EmitterTempEmtBpPath = '/effects/emitters/temp/'
TableCat = import('/lua/utilities.lua').TableCat

AeonLaserFenceBeam = {
    ModBpPath .. 'aeon_laserfence_beam_01_emit.bp',
}

CybranPenWeapon = {
    ModBpPath .. 'pengranade_emit.bp',
}

TPlasmaCannonGreenHeavyHit02 = {
    ModBpPath .. 'green_heavy_plasma_cannon_hit_01_emit.bp',
    ModBpPath .. 'green_heavy_plasma_cannon_hit_02_emit.bp',
    ModBpPath .. 'green_heavy_plasma_cannon_hit_03_emit.bp',
    ModBpPath .. 'green_heavy_plasma_cannon_hit_04_emit.bp',
    ModBpPath .. 'green_heavy_plasma_cannon_hit_05_emit.bp',
}
TPlasmaCannonGreenHeavyHit03 = {
    ModBpPath .. 'green_heavy_plasma_cannon_hit_05_emit.bp',
}
TPlasmaCannonGreenHeavyHit04 = {
    ModBpPath .. 'green_heavy_plasma_cannon_hitunit_05_emit.bp',
}

TGreenPlasmaCannonHeavyHit01 = TableCat( TPlasmaCannonGreenHeavyHit02, TPlasmaCannonGreenHeavyHit03 )
TGreenPlasmaCannonHeavyHitUnit01 = TableCat( TPlasmaCannonGreenHeavyHit02, TPlasmaCannonGreenHeavyHit04)

TPlasmaCannonGreenHeavyMunition = {
    ModBpPath .. 'green_plasma_cannon_trail_02_emit.bp',
}

TPlasmaCannonGreenHeavyMuzzleFlash = {
    ModBpPath .. 'green_plasma_cannon_muzzle_flash_01_emit.bp',
    ModBpPath .. 'green_plasma_cannon_muzzle_flash_02_emit.bp',
    ModBpPath .. 'green_cannon_muzzle_flash_01_emit.bp',
    ModBpPath .. 'green_heavy_plasma_cannon_hitunit_05_emit.bp',
}

CMicrowaveEffect02Fxtrails01= {
    ModBpPath .. 'Microwave_Pod_fxtrail_01_emit.bp',
}

CMicrowaveEffect02Fxtrails02= {
    ModBpPath .. 'Microwave_Pod_fxtrail_02_emit.bp',
}

CMicrowaveEffect02Fxtrails03= {
    ModBpPath .. 'Microwave_Pod_fxtrail_03_emit.bp',
}

CPhotonMissileFxtrails= {
	ModBpPath .. 'proton_missile_fxtrail_emit.bp',
    ModBpPath .. 'proton_missile_smoke_exhaust_emit.bp',
}

CMicrowaveEffect02FxtrailsAll=
{
    CMicrowaveEffect02Fxtrails01,
    CMicrowaveEffect02Fxtrails02,
    CMicrowaveEffect02Fxtrails03,
}

CNanites01 = {
    ModBpPath .. 'nanites_01_emit.bp',
	ModBpPath .. 'nanites_03_emit.bp',
}

CNanites02 = {
    ModBpPath .. 'nanites_02_emit.bp',
	ModBpPath .. 'nanites_03_emit.bp',
}



