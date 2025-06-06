local DefaultProjectileFile = import("/lua/sim/defaultprojectiles.lua")
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')

URS0302NaniteCapsule = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites01,
    FxImpactProp = ModEffectTemplate.CNanites01,
    FxImpactLand = ModEffectTemplate.CNanites01,
    FxImpactUnderWater = {},
	FxImpactWater = ModEffectTemplate.CNanites01,
	
	FxLandHitScale = 0.8,
	FxUnitScale = 0.8,
	FxPropHitScale = 0.8,
	FxWaterHitScale = 0.8,


	OnImpact = function(self, TargetType, targetEntity)

		SinglePolyTrailProjectile.OnImpact( self, TargetType, targetEntity )
		local location = self:GetPosition()
		local SurfaceHeight = GetSurfaceHeight(location[1], location[3]) -- Get Water layer
		local TerrainHeight = GetTerrainHeight(location[1], location[3]) -- Get Land Layer
		LOG("Water: ", SurfaceHeight)
		LOG("Land: ", TerrainHeight)
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		-- Check for preventing Land Reinforcements to be spawned in the Water.
		if SurfaceHeight == TerrainHeight then 
		
		else
		local ShieldUnit =CreateUnitHPR('UCRSN0302', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
		end
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
	end,

}

TypeClass = URS0302NaniteCapsule