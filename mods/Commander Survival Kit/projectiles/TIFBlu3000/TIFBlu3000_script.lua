#
# Terran Artillery Projectile
#
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TArtilleryProjectilePolytrail = import('/lua/terranprojectiles.lua').TArtilleryProjectilePolytrail
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

TIFBlu3000 = Class(TArtilleryProjectilePolytrail) {
    PolyTrail = '/effects/emitters/default_polytrail_04_emit.bp',
	
    OnImpact = function(self, TargetType, TargetEntity)
        if not TargetEntity or not EntityCategoryContains(categories.PROJECTILE, TargetEntity) then
            # Play the explosion sound
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Explosion then
                self:PlaySound(myBlueprint.Audio.Explosion)
            end
			CreateLightParticle(self, -1, self:GetArmy(), 35, 10, 'glow_02', 'ramp_red_02')
           	local rotation = RandomFloat(0,2*math.pi)
			local size = RandomFloat(42.75,42.0)
			CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
			nukeProjectile = self:CreateProjectile('/mods/Commander Survival Kit/effects/Entities/Blu3000/Blu3000EffectController01/Blu3000EffectController01_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
            nukeProjectile:PassData(self.Data)
        end
        TArtilleryProjectilePolytrail.OnImpact(self, TargetType, TargetEntity)
    end,  
}

TypeClass = TIFBlu3000

