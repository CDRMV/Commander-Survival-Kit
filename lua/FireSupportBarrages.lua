local WeaponFile = import('/lua/sim/DefaultWeapons.lua')
local CollisionBeams = import('/lua/defaultcollisionbeams.lua')
local ModCollisionBeams = import('/mods/Commander Survival Kit/lua/FireSupportBeams.lua')
local BareBonesWeapon = WeaponFile.BareBonesWeapon
local DefaultProjectileWeapon = WeaponFile.DefaultProjectileWeapon
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
local GinsuCollisionBeam = CollisionBeams.GinsuCollisionBeam
local Tornado = ModCollisionBeams.Tornado
local OrbitalDeathLaserCollisionBeam = CollisionBeams.OrbitalDeathLaserCollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')

AIFMediumArtilleryStrike = Class(DefaultProjectileWeapon) {
    
}


TIFMediumArtilleryStrike = Class(DefaultProjectileWeapon) {
    
}

CIFMediumArtilleryStrike = Class(DefaultProjectileWeapon) {
    
}

SIFMediumArtilleryStrike = Class(DefaultProjectileWeapon) {
    
}

TornadoBeam = Class(DefaultProjectileWeapon) {

}

Acidrain = Class(DefaultProjectileWeapon) {

}
