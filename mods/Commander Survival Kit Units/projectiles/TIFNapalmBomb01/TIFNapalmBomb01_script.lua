#
# Terran Artillery Projectile
#
local ModEffectTemplate = import('/mods/Commander Survival Kit Units/lua/CSKUnitsEffects.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TArtilleryProjectilePolytrail = import('/lua/terranprojectiles.lua').TArtilleryProjectilePolytrail
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

TIFNapalmBomb01 = Class(TArtilleryProjectilePolytrail) {
	FxImpactTrajectoryAligned = false,
    PolyTrail = '/effects/emitters/default_polytrail_04_emit.bp',
    FxImpactUnit = EffectTemplate.TMissileHit01 ,
    FxImpactProp = EffectTemplate.TMissileHit01 ,
    FxImpactLand = EffectTemplate.TMissileHit01 ,
    FxImpactWater = EffectTemplate.WaterSplash01,
	FxLandHitScale = 2.5,
	FxUnitHitScale = 2.5,
	FxPropHitScale = 2.5,
    FxImpactUnderWater = {},
	
	OnImpact = function(self, TargetType, targetEntity)
		if TargetType != 'Water' then 
			local rotation = RandomFloat(0,2*math.pi)
			local size = RandomFloat(3.75,5.0)
	        
			CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 15, self:GetArmy())
		end	 
		TArtilleryProjectilePolytrail.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = TIFNapalmBomb01

