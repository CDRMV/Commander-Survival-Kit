#
# Terran Artillery Projectile
#
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TArtilleryProjectilePolytrail = import('/lua/terranprojectiles.lua').TArtilleryProjectilePolytrail
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

TIFSmokeScreenShell01 = Class(TArtilleryProjectilePolytrail) {
	FxImpactTrajectoryAligned = false,
    PolyTrail = '/effects/emitters/default_polytrail_04_emit.bp',
    FxImpactUnit = ModEffectTemplate.TNapalmHvyCarpetBombHitLand01,
    FxImpactProp = EffectTemplate.TNapalmHvyCarpetBombHitLand01,
    FxImpactLand = ModEffectTemplate.TNapalmHvyCarpetBombHitLand01,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
    FxImpactUnderWater = {},
	
	OnImpact = function(self, TargetType, targetEntity)
		local location = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local ShieldUnit =CreateUnitHPR('UEFSSP02XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		TArtilleryProjectilePolytrail.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = TIFSmokeScreenShell01

