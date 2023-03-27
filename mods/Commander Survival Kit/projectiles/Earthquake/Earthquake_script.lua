#
# Terran Napalm Carpet Bomb
#
local TNapalmCarpetBombProjectile = import('/lua/terranprojectiles.lua').TNapalmCarpetBombProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local EffectTemplate = import('/lua/EffectTemplates.lua')

Earthquake = Class(TNapalmCarpetBombProjectile) {
    FxImpactUnit = EffectTemplate.GenericDebrisLandImpact01,
    FxImpactProp = EffectTemplate.GenericDebrisLandImpact01,
    FxImpactLand = EffectTemplate.GenericDebrisLandImpact01,
    OnImpact = function(self, TargetType, targetEntity)
		if TargetType != 'Water' then 
			local rotation = RandomFloat(0,2*math.pi)
			local size = RandomFloat(40.75,50.0)
	        
			CreateDecal(self:GetPosition(), rotation, 'River002_normals', '', 'Normals', size, size, 150, 15, self:GetArmy())
		end	 
		TNapalmCarpetBombProjectile.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = Earthquake
