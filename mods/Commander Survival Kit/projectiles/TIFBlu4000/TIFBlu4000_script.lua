#
# Terran Artillery Projectile
#
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TArtilleryProjectilePolytrail = import('/lua/terranprojectiles.lua').TArtilleryProjectilePolytrail
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

TIFBlu4000 = Class(TArtilleryProjectilePolytrail) {
	FxImpactTrajectoryAligned = false,
    PolyTrail = '/effects/emitters/default_polytrail_04_emit.bp',
    FxImpactUnit = ModEffectTemplate.TBluBombHitLand01,
    FxImpactProp = ModEffectTemplate.TBluBombHitLand01,
    FxImpactLand = ModEffectTemplate.TBluBombHitLand01,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
	FxUnitHitScale = 1.5,
	FxLandHitScale = 1.5,
    FxImpactUnderWater = {},
	
	OnImpact = function(self, TargetType, targetEntity)
		if TargetType != 'Water' then 
			local rotation = RandomFloat(0,2*math.pi)
			local size = RandomFloat(42.75,42.0)
	        DamageArea(self, self:GetPosition(), 10, 6000, 'Normal', false)
			DamageArea(self, self:GetPosition(), 10, 15, 'Force', false)
			CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
		end	 
		TArtilleryProjectilePolytrail.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = TIFBlu4000

