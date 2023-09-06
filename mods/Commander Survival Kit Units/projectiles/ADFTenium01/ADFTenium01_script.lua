
local DefaultProjectileFile = import("/lua/sim/defaultprojectiles.lua")
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local ModEffectTemplate = import('/mods/Commander Survival Kit Units/lua/CSKUnitsEffects.lua')
local EffectTemplate = import("/lua/effecttemplates.lua")

ADFTenium01 = Class(SinglePolyTrailProjectile) {

	PolyTrail = ModEffectTemplate.ATeniumPolytrail01,
    FxTrails = ModEffectTemplate.ATeniumMunition01,

	# Hit Effects
    FxImpactUnit = {},
    FxImpactProp = {},
    FxImpactLand = {},
    FxImpactShield = EffectTemplate.ADisruptorHitShield,
	
	FxLandHitScale = 5,


  OnImpact = function(self, TargetType, TargetEntity)
        if not TargetEntity or not EntityCategoryContains(categories.PROJECTILE, TargetEntity) then
            # Play the explosion sound
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Explosion then
                self:PlaySound(myBlueprint.Audio.Explosion)
            end
           
			nukeProjectile = self:CreateProjectile('/mods/Commander Survival Kit Units/effects/Entities/ATeniumImpact/TacNukeEffectController01/TacNukeEffectController01_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
            nukeProjectile:PassData(self.Data)
        end
        SinglePolyTrailProjectile.OnImpact(self, TargetType, TargetEntity)
    end,    
	}

TypeClass = ADFTenium01

