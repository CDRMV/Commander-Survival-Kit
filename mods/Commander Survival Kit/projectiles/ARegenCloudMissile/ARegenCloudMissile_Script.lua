local DefaultProjectileFile = import("/lua/sim/defaultprojectiles.lua")
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
ARegenCloudMissile = Class(SingleBeamProjectile) {

    FxTrails = ModEffectTemplate.ABuildProjectile,
	FxImpactTrajectoryAligned = false,
	PolyTrail = ModEffectTemplate.ATeniumPolytrail01,
    FxTrails = ModEffectTemplate.ABuildProjectile,
    FxImpactUnit = ModEffectTemplate.TNapalmHvyCarpetBombHitLand01,
    FxImpactProp = EffectTemplate.TNapalmHvyCarpetBombHitLand01,
    FxImpactLand = ModEffectTemplate.TNapalmHvyCarpetBombHitLand01,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
    FxImpactUnderWater = {},
	
	OnImpact = function(self, TargetType, targetEntity)
	
		local FxFragEffect = EffectTemplate.TFragmentationSensorShellFrag 
              
        
        # Split effects
        for k, v in FxFragEffect do
            CreateEmitterAtEntity( self, self:GetArmy(), v )
        end
	
		local location = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local ShieldUnit =CreateUnitHPR('UAFSSP0100b', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		SingleBeamProjectile.OnImpact( self, TargetType, targetEntity )
    end,
    

}

    
TypeClass = ARegenCloudMissile

