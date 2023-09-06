local DefaultProjectileFile = import("/lua/sim/defaultprojectiles.lua")
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local EffectTemplate = import('/lua/EffectTemplates.lua')

SBOAAnthe01 = Class(EmitterProjectile) {

    FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.SZthuthaamArtilleryProjectileFXTrails,
	FxImpactUnit = EffectTemplate.SZhanaseeBombHit01,
    FxImpactProp = EffectTemplate.SZhanaseeBombHit01,
    FxImpactAirUnit = EffectTemplate.SZhanaseeBombHit01,
    FxImpactLand = EffectTemplate.SZhanaseeBombHit01,
    FxImpactUnderWater = {},

    OnImpact = function(self, TargetType, TargetEntity)   
        CreateLightParticle(self, -1, self:GetArmy(), 26, 5, 'sparkle_white_add_08', 'ramp_white_24' )
        
        # One initial projectile following same directional path as the original
        self:CreateProjectile('/effects/entities/SBOZhanaseeBombEffect01/SBOZhanaseeBombEffect01_proj.bp', 0, 0, 0, 0, 10.0, 0):SetCollision(false):SetVelocity(0,10.0, 0)
        self:CreateProjectile('/effects/entities/SBOZhanaseeBombEffect02/SBOZhanaseeBombEffect02_proj.bp', 0, 0, 0, 0, 0.05, 0):SetCollision(false):SetVelocity(0,0.05, 0)
        
        if TargetType == 'Terrain' then
            ### WaitSeconds(5.0)
            ### Create our decals for like nine seconds that way there will be no problem when it comes to bombs dropping all the time.
            local pos = self:GetPosition()
            DamageArea( self, pos, self.DamageData.DamageRadius, 1, 'Force', true )
            DamageArea( self, pos, self.DamageData.DamageRadius, 1, 'Force', true )              
            CreateDecal( pos, RandomFloat(0.0,6.28), 'Scorch_012_albedo', '', 'Albedo', 40, 40, 300, 200, self:GetArmy())          
        end
        
		EmitterProjectile.OnImpact(self, TargetType, TargetEntity) 
        
    end,

}
TypeClass = SBOAAnthe01