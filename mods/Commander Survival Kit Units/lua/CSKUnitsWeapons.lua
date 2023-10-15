local WeaponFile = import('/lua/sim/DefaultWeapons.lua')
local CollisionBeams = import('/lua/defaultcollisionbeams.lua')
local ModCollisionBeams = import('/mods/Commander Survival Kit Units/lua/CSKUnitsBeams.lua')
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
local ADFTeniumLaserBeam = ModCollisionBeams.ADFTeniumLaserBeam
local ADFTeniumLaserBeam2 = ModCollisionBeams.ADFTeniumLaserBeam2
local ADFTeniumLaserBeam3 = ModCollisionBeams.ADFTeniumLaserBeam3
local ElectricMaserCollisionBeam = ModCollisionBeams.ElectricMaserCollisionBeam
local HeavyMaserCollisionBeam = ModCollisionBeams.HeavyMaserCollisionBeam
local ExperimentalMaserCollisionBeam = ModCollisionBeams.ExperimentalMaserCollisionBeam
local LightMaserCollisionBeam = ModCollisionBeams.LightMaserCollisionBeam
local MaserCollisionBeam = ModCollisionBeams.MaserCollisionBeam
local HyperMaserCollisionBeam = ModCollisionBeams.HyperMaserCollisionBeam
local DualMaserCollisionBeam = ModCollisionBeams.DualMaserCollisionBeam
local LightHyperMaserCollisionBeam = ModCollisionBeams.LightHyperMaserCollisionBeam
local LightGreenCollisionBeam = ModCollisionBeams.LightGreenCollisionBeam
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

ADFTeniumLaser = Class(DefaultBeamWeapon) {
    BeamType = ADFTeniumLaserBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 0,
}

ADFTeniumLaser2 = Class(DefaultBeamWeapon) {
    BeamType = ADFTeniumLaserBeam2,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 0,
}

ADFTeniumLaser3 = Class(DefaultBeamWeapon) {
    BeamType = ADFTeniumLaserBeam3,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 0,
}

ADFTeniumCannonWeapon = Class(DefaultProjectileWeapon) {

}

ADFGreenLaserBeamWeapon = Class(DefaultBeamWeapon) {
	BeamType = LightGreenCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function( self )
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}


TElectricMaserBeamWeapon = Class(DefaultBeamWeapon) {
    BeamType = ElectricMaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function( self )
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

THyperMaserBeamWeapon = Class(DefaultBeamWeapon) {
    BeamType = HyperMaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function( self )
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

TLightHyperMaserBeamWeapon = Class(DefaultBeamWeapon) {
    BeamType = LightHyperMaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function( self )
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

TLightMaserBeamWeapon = Class(DefaultBeamWeapon) {
    BeamType = LightMaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function( self )
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

TMaserBeamWeapon = Class(DefaultBeamWeapon) {
    BeamType = MaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function( self )
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

TDualMaserBeamWeapon = Class(DefaultBeamWeapon) {
    BeamType = DualMaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function( self )
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

THeavyMaserBeamWeapon = Class(DefaultBeamWeapon) {
    BeamType = HeavyMaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function( self )
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

TDFHeavyMaserCannonWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = {'/mods/Commander Survival Kit Units/effects/emitters/mini_blue_beam_muzzle_01_emit.bp'},
}

TExperimentalMaserCannonWeapon = Class(DefaultBeamWeapon) {
    BeamType = ExperimentalMaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function( self )
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}