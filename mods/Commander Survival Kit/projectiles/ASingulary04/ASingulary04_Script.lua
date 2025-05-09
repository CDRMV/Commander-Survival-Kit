local DefaultProjectileFile = import("/lua/sim/defaultprojectiles.lua")
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')
local InstableTendium = '/mods/Commander Survival Kit/effects/Entities/InstableTendium/InstableTendium_proj.bp'
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
ASingulary04 = Class(SingleBeamProjectile) {

	PolyTrail = ModEffectTemplate.ATeniumPolytrail01,
    FxTrails = ModEffectTemplate.ATeniumMunition01,

    ProjBp = InstableTendium,

    -- no impact Fx, the blackhole entity script does this
    FxImpactUnit = {},
    FxImpactLand = {},
    FxImpactUnderWater = {},
    
    
    OnCreate = function(self)
        SingleBeamProjectile.OnCreate(self)
    end,
    
    OnImpact = function(self, targetType, TargetEntity)
        if self.AlreadyExploded then return end
        -- if we didn't impact with another projectile (that would be the anti nuke projectile) then create nuke effect
        if not TargetEntity or not EntityCategoryContains(categories.PROJECTILE, TargetEntity) then
            self.AlreadyExploded = true --incase we decide to hit something else instead.

            -- Play the explosion sound
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Explosion then
                self:PlaySound(myBlueprint.Audio.Explosion)
            end
                    local pos = self:GetPosition()
        local orientation = RandomFloat( 0, 2 * math.pi )
		        CreateDecal(pos, orientation, 'Crater01_albedo', '', 'Albedo', 30, 30, 1200, 0, self.Army)
        CreateDecal(pos, orientation, 'Crater01_normals', '', 'Normals', 30, 30, 1200, 0, self.Army)
        CreateDecal(pos, orientation, 'nuke_scorch_003_albedo', '', 'Albedo', 30, 30, 1200, 0, self.Army)
            self:CreateProjectile( self.ProjBp, 0, 0, 0, nil, nil, nil):SetCollision(false)
        end
        self:ForkThread( self.ExplosionDelayThread, targetType, TargetEntity)
    end,
    
    ExplosionDelayThread = function(self, targetType, TargetEntity)
        WaitSeconds(0.1)
        SingleBeamProjectile.OnImpact(self, targetType, TargetEntity)
    end,
}


    
TypeClass = ASingulary04

