#
# Terran Gauss Cannon Projectile
#
local TDFGaussCannonProjectile = import('/lua/terranprojectiles.lua').TDFGaussCannonProjectile
local ModEffectTemplate = import('/mods/Commander Survival Kit Units/lua/CSKUnitsEffectTemplates.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')

CDFPhotonMissile01 = Class(TDFGaussCannonProjectile) {

    FxImpactUnit = EffectTemplate.TMissileHit01,
    FxImpactLand = EffectTemplate.TMissileHit01,
    FxImpactProp = EffectTemplate.TMissileHit01,
    FxImpactUnderWater = {},
    PolyTrails = nil,
    PolyTrailOffset = {0,0},
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
    FxTrails = ModEffectTemplate.CPhotonMissileFxtrails,
	FxTrailScale = 0.5,
    
    OnCreate = function(self, inWater)
        TDFGaussCannonProjectile.OnCreate(self, inWater)
        if not inWater then
            self:SetDestroyOnWater(true)
        else
            self:ForkThread(self.DestroyOnWaterThread)
        end
    end,
    
    DestroyOnWaterThread = function(self)
        WaitSeconds(0.2)
        self:SetDestroyOnWater(true)
    end,
}
TypeClass = CDFPhotonMissile01

