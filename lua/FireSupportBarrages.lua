local WeaponFile = import('/lua/sim/DefaultWeapons.lua')
local CollisionBeams = import('/lua/defaultcollisionbeams.lua')
local ModCollisionBeams = import('/mods/Commander Survival Kit/lua/FireSupportBeams.lua')
local BareBonesWeapon = WeaponFile.BareBonesWeapon
local DefaultProjectileWeapon = WeaponFile.DefaultProjectileWeapon
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
local GinsuCollisionBeam = CollisionBeams.GinsuCollisionBeam
local Tornado = ModCollisionBeams.Tornado
local LargeTornado = ModCollisionBeams.LargeTornado
local TDFHiroCollisionBeam2 = ModCollisionBeams.TDFHiroCollisionBeam2
local OrbitalDeathLaserCollisionBeam2 = ModCollisionBeams.OrbitalDeathLaserCollisionBeam2
local MicrowaveLaserCollisionBeam03 = ModCollisionBeams.MicrowaveLaserCollisionBeam03
local MicrowaveLaserCollisionBeam04 = ModCollisionBeams.MicrowaveLaserCollisionBeam04
local EffectTemplate = import('/lua/EffectTemplates.lua')

AIFMediumArtilleryStrike = Class(DefaultProjectileWeapon) {
    
}


TIFMediumArtilleryStrike = Class(DefaultProjectileWeapon) {
    
}

CIFMediumArtilleryStrike = Class(DefaultProjectileWeapon) {
    
}

SIFMediumArtilleryStrike = Class(DefaultProjectileWeapon) {
    
}

TornadoBeam = Class(DefaultBeamWeapon) {
BeamType = LargeTornado,
}

TornadoBeam2 = Class(DefaultBeamWeapon) {
BeamType = Tornado,
}

Acidrain = Class(DefaultProjectileWeapon) {

}

TDFHiroPlasmaCannon2 = Class(DefaultBeamWeapon) {
    BeamType = TDFHiroCollisionBeam2,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 0,
}

TOrbitalDeathLaserBeamWeapon2 = Class(DefaultBeamWeapon) {
    BeamType = OrbitalDeathLaserCollisionBeam2,
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 0,
}

CDFHeavyMicrowaveLaserGeneratorCom2 = Class(DefaultBeamWeapon) {
    BeamType = MicrowaveLaserCollisionBeam03,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 0,
}

CDFHeavyMicrowaveLaserGeneratorCom3 = Class(DefaultBeamWeapon) {
    BeamType = MicrowaveLaserCollisionBeam04,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 0,
}
