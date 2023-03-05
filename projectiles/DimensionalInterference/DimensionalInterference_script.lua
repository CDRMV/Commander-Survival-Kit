#
# Terran Napalm Carpet Bomb
#
local TNapalmCarpetBombProjectile = import('/lua/terranprojectiles.lua').TNapalmCarpetBombProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local EffectTemplate = import('/lua/EffectTemplates.lua')
local CSKEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')
local EffectUtilities = import('/lua/EffectUtilities.lua')

DimensionalInterference = Class(TNapalmCarpetBombProjectile) {
	SecondaryFx = CSKEffectTemplate.DimensionalSecondary,
	DimensionalFxScale = 0.1,
    FxImpactUnit = EffectTemplate.GenericDebrisLandImpact01,
    FxImpactProp = EffectTemplate.GenericDebrisLandImpact01,
    FxImpactLand = EffectTemplate.GenericDebrisLandImpact01,
    OnImpact = function(self, TargetType, targetEntity)
		if TargetType != 'Water' then 
			local rotation = RandomFloat(0,2*math.pi)
			        local pos = self:GetPosition()
        self.surfaceY = GetTerrainHeight(pos[1], pos[3]) + GetTerrainTypeOffset(pos[1], pos[3])
        if pos[2] < (self.surfaceY + 4) then
            pos[2] = self.surfaceY + 4
            Warp( self, pos )
        end



        local emitters = EffectUtilities.CreateEffects( self, self.Army, self.SecondaryFx )
        for k, emit in emitters do
            emit:ScaleEmitter(5 * self.DimensionalFxScale or 1 )
            self.Trash:Add( emit )
        end
			
			
			local size = 30
	        self:ShakeCamera( 55, 10, 0, 3 )
			CreateLightParticleIntel (self, -1, self.Army, (10 * self.DimensionalFxScale), 10, 'glow_03', 'ramp_ser_03')
			CreateDecal(self:GetPosition(), rotation, 'crater_radial01_normals', '', 'Normals', size, size, 1200, 0, self:GetArmy())
		end	 
		TNapalmCarpetBombProjectile.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = DimensionalInterference
