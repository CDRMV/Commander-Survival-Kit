local WeaponFile = import('/lua/sim/DefaultWeapons.lua')
local KamikazeWeapon = WeaponFile.KamikazeWeapon
local CollisionBeams = import('/lua/defaultcollisionbeams.lua')
local ModCollisionBeams = import('/mods/Commander Survival Kit Units/lua/CSKUnitsBeams.lua')
local BareBonesWeapon = WeaponFile.BareBonesWeapon
local DefaultProjectileWeapon = WeaponFile.DefaultProjectileWeapon
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
local GinsuCollisionBeam = CollisionBeams.GinsuCollisionBeam
local Tornado = ModCollisionBeams.Tornado
local LightningBeam = ModCollisionBeams.LightningBeam
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
local GreenCollisionBeam = ModCollisionBeams.GreenCollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffects = '/mods/Commander Survival Kit Units/effects/emitters/'
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat


AIFMediumArtilleryStrike = Class(DefaultProjectileWeapon) {
    
}

TDFLightningBeam = Class(DefaultBeamWeapon) {
    BeamType = LightningBeam,
    FxMuzzleFlash = {},
	FxScale = 0.5,
    FxChargeMuzzleFlash = {}, ####EffectTemplate.SExperimentalUnstablePhasonLaserMuzzle01,
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 1,
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

CMobileAdvancedKamikazeBombWeapon = Class(KamikazeWeapon){
	FxDeath = EffectTemplate.CMobileKamikazeBombExplosion,

    OnFire = function(self)
		local army = self.unit:GetArmy()
        for k, v in self.FxDeath do
            CreateEmitterAtBone(self.unit,-2,army,v)
        end   
        CreateLightParticle( self.unit, -1, -1, 15, 10, 'flare_lens_add_02', 'ramp_red_10' ) 
		KamikazeWeapon.OnFire(self)
    end,
}

CDFPhotonicWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
	SphereEffectActiveMesh = '/effects/entities/cybranphalanxsphere01/cybranphalanxsphere02_mesh',
    FxUpackingChargeEffectScale = 1,
}

CDFHeavyPhotonicLaserGenerator = Class(DefaultBeamWeapon) {
    BeamType = ModCollisionBeams.PhotonicLaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
	SphereEffectActiveMesh = '/effects/entities/cybranphalanxsphere01/cybranphalanxsphere02_mesh',
    FxUpackingChargeEffectScale = 1,
	
    PlayFxWeaponUnpackSequence = function( self )
        local army = self.unit:GetArmy()
        local bp = self:GetBlueprint()
		self.SphereEffectEntity1 = import('/lua/sim/Entity.lua').Entity()
		self.SphereEffectEntity2 = import('/lua/sim/Entity.lua').Entity()
		self.SphereEffectEntity3 = import('/lua/sim/Entity.lua').Entity()
		self.SphereEffectEntity4 = import('/lua/sim/Entity.lua').Entity()
		self.SphereEffectEntity5 = import('/lua/sim/Entity.lua').Entity()
		self.SphereEffectEntity6 = import('/lua/sim/Entity.lua').Entity()
		self.SphereEffectEntity7 = import('/lua/sim/Entity.lua').Entity()
		self.SphereEffectEntity8 = import('/lua/sim/Entity.lua').Entity()
        self.SphereEffectEntity1:AttachBoneTo( -1, self.unit, 'TailEffect1' )
		self.SphereEffectEntity2:AttachBoneTo( -1, self.unit, 'TailEffect2' )
		self.SphereEffectEntity3:AttachBoneTo( -1, self.unit, 'TailEffect3' )
		self.SphereEffectEntity4:AttachBoneTo( -1, self.unit, 'TailEffect4' )
		self.SphereEffectEntity5:AttachBoneTo( -1, self.unit, 'TailEffect5' )
		self.SphereEffectEntity6:AttachBoneTo( -1, self.unit, 'TailEffect6' )
		self.SphereEffectEntity7:AttachBoneTo( -1, self.unit, 'TailEffect7' )
		self.SphereEffectEntity8:AttachBoneTo( -1, self.unit, 'TailEffect8' )
        self.SphereEffectEntity1:SetMesh(self.SphereEffectActiveMesh)
		self.SphereEffectEntity2:SetMesh(self.SphereEffectActiveMesh)
		self.SphereEffectEntity3:SetMesh(self.SphereEffectActiveMesh)
		self.SphereEffectEntity4:SetMesh(self.SphereEffectActiveMesh)
		self.SphereEffectEntity5:SetMesh(self.SphereEffectActiveMesh)
		self.SphereEffectEntity6:SetMesh(self.SphereEffectActiveMesh)
		self.SphereEffectEntity7:SetMesh(self.SphereEffectActiveMesh)
		self.SphereEffectEntity8:SetMesh(self.SphereEffectActiveMesh)
        self.SphereEffectEntity1:SetDrawScale(0.3)
        self.SphereEffectEntity1:SetVizToAllies('Intel')
        self.SphereEffectEntity1:SetVizToNeutrals('Intel')
        self.SphereEffectEntity1:SetVizToEnemies('Intel')
		self.SphereEffectEntity2:SetDrawScale(0.3)
        self.SphereEffectEntity2:SetVizToAllies('Intel')
        self.SphereEffectEntity2:SetVizToNeutrals('Intel')
        self.SphereEffectEntity2:SetVizToEnemies('Intel')
		self.SphereEffectEntity3:SetDrawScale(0.3)
        self.SphereEffectEntity3:SetVizToAllies('Intel')
        self.SphereEffectEntity3:SetVizToNeutrals('Intel')
        self.SphereEffectEntity3:SetVizToEnemies('Intel')
		self.SphereEffectEntity4:SetDrawScale(0.3)
        self.SphereEffectEntity4:SetVizToAllies('Intel')
        self.SphereEffectEntity4:SetVizToNeutrals('Intel')
        self.SphereEffectEntity4:SetVizToEnemies('Intel')
		self.SphereEffectEntity5:SetDrawScale(0.3)
        self.SphereEffectEntity5:SetVizToAllies('Intel')
        self.SphereEffectEntity5:SetVizToNeutrals('Intel')
        self.SphereEffectEntity5:SetVizToEnemies('Intel')
		self.SphereEffectEntity6:SetDrawScale(0.3)
        self.SphereEffectEntity6:SetVizToAllies('Intel')
        self.SphereEffectEntity6:SetVizToNeutrals('Intel')
        self.SphereEffectEntity6:SetVizToEnemies('Intel')
		self.SphereEffectEntity7:SetDrawScale(0.3)
        self.SphereEffectEntity7:SetVizToAllies('Intel')
        self.SphereEffectEntity7:SetVizToNeutrals('Intel')
        self.SphereEffectEntity7:SetVizToEnemies('Intel')
		self.SphereEffectEntity8:SetDrawScale(0.3)
        self.SphereEffectEntity8:SetVizToAllies('Intel')
        self.SphereEffectEntity8:SetVizToNeutrals('Intel')
        self.SphereEffectEntity8:SetVizToEnemies('Intel')
		self.unit.Trash:Add(self.SphereEffectEntity1)
		self.Effect1 = CreateAttachedEmitter(self.unit, 'Effect6', army, ModEffects .. 'photonic_ambient_01_emit.bp'):ScaleEmitter(1.0):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1)
		self.Effect2 = CreateAttachedEmitter(self.unit, 'Effect5', army, ModEffects .. 'photonic_ambient_01_emit.bp'):ScaleEmitter(2.0):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1)
		self.Effect3 = CreateAttachedEmitter(self.unit, 'Effect4', army, ModEffects .. 'photonic_ambient_01_emit.bp'):ScaleEmitter(2.0):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1)
		self.Effect4 = CreateAttachedEmitter(self.unit, 'Effect3', army, ModEffects .. 'photonic_ambient_01_emit.bp'):ScaleEmitter(2.0):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1)
        self.Effect5 = CreateAttachedEmitter(self.unit, 'Effect2', army, ModEffects .. 'photonic_ambient_01_emit.bp'):ScaleEmitter(2.0):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1)
		self.Effect6 = CreateAttachedEmitter(self.unit, 'Effect1', army, ModEffects .. 'photonic_ambient_01_emit.bp'):ScaleEmitter(1.0):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1)
		self.Effect7 = CreateAttachedEmitter(self.unit, 'Effect6', army, ModEffects .. 'photonic_ambient_02_emit.bp'):ScaleEmitter(0.5):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1)
		self.Effect8 = CreateAttachedEmitter(self.unit, 'Effect5', army, ModEffects .. 'photonic_ambient_02_emit.bp'):ScaleEmitter(1.0):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1)
		self.Effect9 = CreateAttachedEmitter(self.unit, 'Effect4', army, ModEffects .. 'photonic_ambient_02_emit.bp'):ScaleEmitter(1.0):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1)
		self.Effect10 = CreateAttachedEmitter(self.unit, 'Effect3', army, ModEffects .. 'photonic_ambient_02_emit.bp'):ScaleEmitter(1.0):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1)
        self.Effect11 = CreateAttachedEmitter(self.unit, 'Effect2', army, ModEffects .. 'photonic_ambient_02_emit.bp'):ScaleEmitter(1.0):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1)
		self.Effect12 = CreateAttachedEmitter(self.unit, 'Effect1', army, ModEffects .. 'photonic_ambient_02_emit.bp'):ScaleEmitter(1.0):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1)
		self.MuzzleEffect1 = CreateAttachedEmitter(self.unit, 'Center_Turret_Muzzle', army, ModEffects .. 'photonic_ambient_01_emit.bp'):ScaleEmitter(1.0):OffsetEmitter(0,0,0):SetEmitterParam('LIFETIME', -1)		
        DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
    end,
	
	PlayFxWeaponPackSequence = function( self )
		local army = self.unit:GetArmy()
		if self.SphereEffectEntity1 == nil then
		
		else
		self.SphereEffectEntity1:Destroy()
		end
		if self.SphereEffectEntity2 == nil then
		
		else
		self.SphereEffectEntity2:Destroy()
		end
		if self.SphereEffectEntity3 == nil then
		
		else
		self.SphereEffectEntity3:Destroy()
		end
		if self.SphereEffectEntity4 == nil then
		
		else
		self.SphereEffectEntity4:Destroy()
		end
		if self.SphereEffectEntity5 == nil then
		
		else
		self.SphereEffectEntity5:Destroy()
		end
		if self.SphereEffectEntity6 == nil then
		
		else
		self.SphereEffectEntity6:Destroy()
		end
		if self.SphereEffectEntity6 == nil then
		
		else
		self.SphereEffectEntity6:Destroy()
		end
		if self.SphereEffectEntity7 == nil then
		
		else
		self.SphereEffectEntity7:Destroy()
		end
		if self.SphereEffectEntity8 == nil then
		
		else
		self.SphereEffectEntity8:Destroy()
		end
		if self.MuzzleEffect1 == nil then
		
		else
		self.MuzzleEffect1:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect1 == nil then
		
		else
		self.Effect1:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect2 == nil then
		
		else
		self.Effect2:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect3 == nil then
		
		else
		self.Effect3:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect4 == nil then
		
		else
		self.Effect4:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect5 == nil then
		
		else
		self.Effect5:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect6 == nil then
		
		else
		self.Effect6:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect7 == nil then
		
		else
		self.Effect7:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect8 == nil then
		
		else
		self.Effect8:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect9 == nil then
		
		else
		self.Effect9:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect10 == nil then
		
		else
		self.Effect10:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect11 == nil then
		
		else
		self.Effect11:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect12 == nil then
		
		else
		self.Effect12:SetEmitterParam('LIFETIME', 0)
		end	
        DefaultBeamWeapon.PlayFxWeaponPackSequence(self)
    end,
	
	OnLostTarget = function(self)
		local army = self.unit:GetArmy()
		if self.SphereEffectEntity1 == nil then
		
		else
		self.SphereEffectEntity1:Destroy()
		end
		if self.SphereEffectEntity2 == nil then
		
		else
		self.SphereEffectEntity2:Destroy()
		end
		if self.SphereEffectEntity3 == nil then
		
		else
		self.SphereEffectEntity3:Destroy()
		end
		if self.SphereEffectEntity4 == nil then
		
		else
		self.SphereEffectEntity4:Destroy()
		end
		if self.SphereEffectEntity5 == nil then
		
		else
		self.SphereEffectEntity5:Destroy()
		end
		if self.SphereEffectEntity6 == nil then
		
		else
		self.SphereEffectEntity6:Destroy()
		end
		if self.SphereEffectEntity6 == nil then
		
		else
		self.SphereEffectEntity6:Destroy()
		end
		if self.SphereEffectEntity7 == nil then
		
		else
		self.SphereEffectEntity7:Destroy()
		end
		if self.SphereEffectEntity8 == nil then
		
		else
		self.SphereEffectEntity8:Destroy()
		end
		if self.MuzzleEffect1 == nil then
		
		else
		self.MuzzleEffect1:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect1 == nil then
		
		else
		self.Effect1:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect2 == nil then
		
		else
		self.Effect2:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect3 == nil then
		
		else
		self.Effect3:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect4 == nil then
		
		else
		self.Effect4:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect5 == nil then
		
		else
		self.Effect5:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect6 == nil then
		
		else
		self.Effect6:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect7 == nil then
		
		else
		self.Effect7:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect8 == nil then
		
		else
		self.Effect8:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect9 == nil then
		
		else
		self.Effect9:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect10 == nil then
		
		else
		self.Effect10:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect11 == nil then
		
		else
		self.Effect11:SetEmitterParam('LIFETIME', 0)
		end
		if self.Effect12 == nil then
		
		else
		self.Effect12:SetEmitterParam('LIFETIME', 0)
		end
		DefaultBeamWeapon.OnLostTarget(self)
    end, 
	
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

ADFHeavyGreenLaserBeamWeapon = Class(DefaultBeamWeapon) {
	BeamType = GreenCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function( self )
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

CAMZapperWeapon5 = Class(DefaultBeamWeapon) {

    BeamType = CollisionBeams.ZapperCollisionBeam,
    FxMuzzleFlash = { '/effects/emitters/cannon_muzzle_flash_01_emit.bp', },

    SphereEffectIdleMesh = '/effects/entities/cybranphalanxsphere01/cybranphalanxsphere01_mesh',
    SphereEffectActiveMesh = '/effects/entities/cybranphalanxsphere01/cybranphalanxsphere02_mesh',
    SphereEffectBp = '/effects/emitters/zapper_electricity_01_emit.bp',
    SphereEffectBone = 'Zapper_Muzzle',

    ---@param self CAMZapperWeapon
    OnCreate = function(self)
        DefaultBeamWeapon.OnCreate(self)
        local bp = self.Blueprint
        self.SphereEffectEntity = import("/lua/sim/entity.lua").Entity()
        self.SphereEffectEntity:AttachBoneTo(-1, self.unit, self.SphereEffectBone)
        self.SphereEffectEntity:SetMesh(self.SphereEffectIdleMesh)
        self.SphereEffectEntity:SetDrawScale(0.2)
        self.SphereEffectEntity:SetVizToAllies('Intel')
        self.SphereEffectEntity:SetVizToNeutrals('Intel')
        self.SphereEffectEntity:SetVizToEnemies('Intel')

        local emit = CreateAttachedEmitter(self.unit, self.SphereEffectBone, self.unit.Army, self.SphereEffectBp):ScaleEmitter(0.3)

        self.unit.Trash:Add(self.SphereEffectEntity)
        self.unit.Trash:Add(emit)
    end,

    IdleState = State(DefaultBeamWeapon.IdleState) {
        Main = function(self)
            DefaultBeamWeapon.IdleState.Main(self)
        end,

        OnGotTarget = function(self)
            DefaultBeamWeapon.IdleState.OnGotTarget(self)
            self.SphereEffectEntity:SetMesh(self.SphereEffectActiveMesh)
        end,
    },

    ---@param self CAMZapperWeapon
    OnLostTarget = function(self)
        DefaultBeamWeapon.OnLostTarget(self)
        self.SphereEffectEntity:SetMesh(self.SphereEffectIdleMesh)
    end,
}

TMobileAdvancedKamikazeBombWeapon = Class(KamikazeWeapon){
	FxDeath = EffectTemplate.TAPDSHit01,
	FxDeath2 = EffectTemplate.CMobileKamikazeBombExplosion,
    OnFire = function(self)
		local army = self.unit:GetArmy()
        for k, v in self.FxDeath do
            CreateEmitterAtBone(self.unit,-2,army,v):ScaleEmitter(1)
        end 
		for k, v in self.FxDeath2 do
            CreateEmitterAtBone(self.unit,-2,army,v):ScaleEmitter(1.5)
        end 
        CreateLightParticle( self.unit, -1, -1, 15, 10, 'flare_lens_add_02', 'ramp_red_10' ) 
		KamikazeWeapon.OnFire(self)
    end,
}



TElectricMaserBeamWeapon = Class(DefaultBeamWeapon) {
    BeamType = ElectricMaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,
	
	PlayFxWeaponUnpackSequence = function( self )
		self.unit:SetImmobile(true)
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
	
	PlayFxWeaponPackSequence = function( self )
		self:ForkThread(
            function()
			local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

			if version < 3652 then 
	            WaitSeconds(10)
				self.unit:SetImmobile(false)
			else 	
                WaitSeconds(3)
				self.unit:SetImmobile(false)
			end
            end
        )
		DefaultBeamWeapon.PlayFxWeaponPackSequence(self)
    end,
	
	OnLostTarget = function(self)
		self:ForkThread(
            function()
			local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

			if version < 3652 then 
	            WaitSeconds(10)
				self.unit:SetImmobile(false)
			else 	
                WaitSeconds(3)
				self.unit:SetImmobile(false)
			end
            end
        )
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

