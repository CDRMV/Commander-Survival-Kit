local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile
local WeaponFile = import('/lua/sim/DefaultWeapons.lua')
local CollisionBeams = import('/lua/defaultcollisionbeams.lua')
local BareBonesWeapon = WeaponFile.BareBonesWeapon
local DefaultProjectileWeapon = WeaponFile.DefaultProjectileWeapon
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
local NullShell = DefaultProjectileFile.NullShell
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile
local GinsuCollisionBeam = CollisionBeams.GinsuCollisionBeam
local OrbitalDeathLaserCollisionBeam = CollisionBeams.OrbitalDeathLaserCollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Blackhole = '/mods/Commander Survival Kit/effects/Entities/Blackhole/Blackhole_proj.bp'
local SmallBlackhole = '/mods/Commander Survival Kit/effects/Entities/SmallBlackhole/SmallBlackhole_proj.bp'
local MediumBlackhole = '/mods/Commander Survival Kit/effects/Entities/MediumBlackhole/MediumBlackhole_proj.bp'
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile

ATeniumProjectile = Class(SinglePolyTrailProjectile) {

	PolyTrail = ModEffectTemplate.ATeniumPolytrail01,
    FxTrails = ModEffectTemplate.ATeniumMunition01,

	# Hit Effects
    FxImpactUnit = {},
    FxImpactProp = {},
    FxImpactLand = {},
    FxImpactShield = EffectTemplate.ADisruptorHitShield,
	
	FxLandHitScale = 5,
}

SBOAAntheProjectile = Class(EmitterProjectile) {
    FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.SZthuthaamArtilleryProjectileFXTrails,
	FxImpactUnit = EffectTemplate.SZhanaseeBombHit01,
    FxImpactProp = EffectTemplate.SZhanaseeBombHit01,
    FxImpactAirUnit = EffectTemplate.SZhanaseeBombHit01,
    FxImpactLand = EffectTemplate.SZhanaseeBombHit01,
    FxImpactUnderWater = {},
}


CNaniteProjectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites01,
    FxImpactProp = ModEffectTemplate.CNanites01,
    FxImpactLand = ModEffectTemplate.CNanites01,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 0.3,
	FxUnitScale = 0.3,
	FxPropHitScale = 0.3,
}

CNanite2Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites01,
    FxImpactProp = ModEffectTemplate.CNanites01,
    FxImpactLand = ModEffectTemplate.CNanites01,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 0.6,
	FxUnitScale = 0.6,
	FxPropHitScale = 0.6,
}

CNanite3Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites01,
    FxImpactProp = ModEffectTemplate.CNanites01,
    FxImpactLand = ModEffectTemplate.CNanites01,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 0.9,
	FxUnitScale = 0.9,
	FxPropHitScale = 0.9,
}

CNanite4Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites01,
    FxImpactProp = ModEffectTemplate.CNanites01,
    FxImpactLand = ModEffectTemplate.CNanites01,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 1.2,
	FxUnitScale = 1.2,
	FxPropHitScale = 1.2,
}

CNanite5Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites01,
    FxImpactProp = ModEffectTemplate.CNanites01,
    FxImpactLand = ModEffectTemplate.CNanites01,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 1.5,
	FxUnitScale = 1.5,
	FxPropHitScale = 1.5,
}

NaniteCapsuleProjectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites02,
    FxImpactProp = ModEffectTemplate.CNanites02,
    FxImpactLand = ModEffectTemplate.CNanites02,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 0.3,
	FxUnitScale = 0.3,
	FxPropHitScale = 0.3,
}

NaniteCapsule2Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites02,
    FxImpactProp = ModEffectTemplate.CNanites02,
    FxImpactLand = ModEffectTemplate.CNanites02,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 0.6,
	FxUnitScale = 0.6,
	FxPropHitScale = 0.6,
}

NaniteCapsule3Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites02,
    FxImpactProp = ModEffectTemplate.CNanites02,
    FxImpactLand = ModEffectTemplate.CNanites02,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 0.9,
	FxUnitScale = 0.9,
	FxPropHitScale = 0.9,
}

NaniteCapsule4Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites02,
    FxImpactProp = ModEffectTemplate.CNanites02,
    FxImpactLand = ModEffectTemplate.CNanites02,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 1.2,
	FxUnitScale = 1.2,
	FxPropHitScale = 1.2,
}

NaniteCapsule5Projectile = Class(SinglePolyTrailProjectile) {

    FxTrails = {'/effects/emitters/mortar_munition_03_emit.bp',},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.CNanites02,
    FxImpactProp = ModEffectTemplate.CNanites02,
    FxImpactLand = ModEffectTemplate.CNanites02,
    FxImpactUnderWater = {},
	
	FxLandHitScale = 1.5,
	FxUnitScale = 1.5,
	FxPropHitScale = 1.5,
}

ASingularityProjectile = Class(NullShell) {
    ProjBp = Blackhole,

    -- no impact Fx, the blackhole entity script does this
    FxImpactUnit = {},
    FxImpactLand = {},
    FxImpactUnderWater = {},
    
    
    OnCreate = function(self)
        NullShell.OnCreate(self)
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
            
            self:CreateProjectile( self.ProjBp, 0, 0, 0, nil, nil, nil):SetCollision(false)
        end
        self:ForkThread( self.ExplosionDelayThread, targetType, TargetEntity)
    end,
    
    ExplosionDelayThread = function(self, targetType, TargetEntity)
        WaitSeconds(0.1)
        NullShell.OnImpact(self, targetType, TargetEntity)
    end,
}

ASmallSingularityProjectile = Class(NullShell) {
    ProjBp = SmallBlackhole,

    -- no impact Fx, the blackhole entity script does this
    FxImpactUnit = {},
    FxImpactLand = {},
    FxImpactUnderWater = {},
    
    
    OnCreate = function(self)
        NullShell.OnCreate(self)
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
            
            self:CreateProjectile( self.ProjBp, 0, 0, 0, nil, nil, nil):SetCollision(false)
        end
        self:ForkThread( self.ExplosionDelayThread, targetType, TargetEntity)
    end,
    
    ExplosionDelayThread = function(self, targetType, TargetEntity)
        WaitSeconds(0.1)
        NullShell.OnImpact(self, targetType, TargetEntity)
    end,
}

AMediumSingularityProjectile = Class(NullShell) {
    ProjBp = MediumBlackhole,

    -- no impact Fx, the blackhole entity script does this
    FxImpactUnit = {},
    FxImpactLand = {},
    FxImpactUnderWater = {},
    
    
    OnCreate = function(self)
        NullShell.OnCreate(self)
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
            
            self:CreateProjectile( self.ProjBp, 0, 0, 0, nil, nil, nil):SetCollision(false)
        end
        self:ForkThread( self.ExplosionDelayThread, targetType, TargetEntity)
    end,
    
    ExplosionDelayThread = function(self, targetType, TargetEntity)
        WaitSeconds(0.1)
        NullShell.OnImpact(self, targetType, TargetEntity)
    end,
}


--a most unholy mergination of various classes but it all works! and has a linecount of approximately 0 as a result
ASingularyEnergyProjectile = Class(ASingularityProjectile, SingleBeamProjectile) {
	PolyTrail = ModEffectTemplate.ATeniumPolytrail01,
    FxTrails = ModEffectTemplate.ATeniumMunition01,
    
    OnCreate = function(self)
        SingleBeamProjectile.OnCreate(self)
    end,
    
    OnImpact = function(self, targetType, TargetEntity)
        ASingularityProjectile.OnImpact(self, targetType, TargetEntity)
    end,
}

ASmallSingularyEnergyProjectile = Class(ASmallSingularityProjectile, SingleBeamProjectile) {
	PolyTrail = ModEffectTemplate.ATeniumPolytrail01,
    FxTrails = ModEffectTemplate.ATeniumMunition01,
    
    OnCreate = function(self)
        SingleBeamProjectile.OnCreate(self)
    end,
    
    OnImpact = function(self, targetType, TargetEntity)
        ASmallSingularityProjectile.OnImpact(self, targetType, TargetEntity)
    end,
}

AMediumSingularyEnergyProjectile = Class(AMediumSingularityProjectile, SingleBeamProjectile) {
	PolyTrail = ModEffectTemplate.ATeniumPolytrail01,
    FxTrails = ModEffectTemplate.ATeniumMunition01,
    
    OnCreate = function(self)
        SingleBeamProjectile.OnCreate(self)
    end,
    
    OnImpact = function(self, targetType, TargetEntity)
        AMediumSingularityProjectile.OnImpact(self, targetType, TargetEntity)
    end,
}