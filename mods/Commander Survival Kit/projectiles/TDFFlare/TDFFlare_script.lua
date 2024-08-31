-- Ship-based Anti-Torpedo Script

local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local Flare = import('/mods/Commander Survival Kit Units/lua/CSKUnitsAntiProjectiles.lua').Flare
local EffectTemplate = import('/lua/effecttemplates.lua')

local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile
local EmitterProjectileOnCreate = EmitterProjectile.OnCreate

-- upvalue scope for performance
local IsEnemy = IsEnemy
local EntityCategoryContains = EntityCategoryContains

-- pre-computed for performance
local FlareCategories = categories.MISSILE


flare = Class(EmitterProjectile) {

    OnCreate = function(self)
        EmitterProjectileOnCreate(self)
        self.RedirectedMissiles = 0

        -- missiles that hit the flare are immediately neutralized
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.0)

        -- Create several flares of different sizes. A collision check is done when an entity enters the
        -- collision box of another entity. As long as the entity remains inside no additional checks
        -- are done. Therefore we create several flares of different sizes to catch missiles that are
        -- far out and close by.

        local flareSpecs = {
            Radius = 5,
            Owner = self,
            Category = 'MISSILE',
        }

        local trash = self.Trash
        for k = 1, 3 do
            flareSpecs.Radius = 5 + k * 5
        end
    end,
	
	    OnCollisionCheck = function(self, other)
        -- flat out destroy the tactical missile when we get in contact with it
        if EntityCategoryContains(FlareCategories, other) and self:GetArmy() != other:GetArmy()
        then
            -- destroy the other projectile
            Damage(self.Launcher, other:GetPosition(), other, 200, 'Normal')
        end

        return true
    end,

    FxAirUnitHitScale = 1,
    FxLandHitScale = 1,
    FxNoneHitScale = 3,
    FxPropHitScale = 1,
    FxProjectileHitScale = 3,
    FxProjectileUnderWaterHitScale = 0.1,
    FxShieldHitScale = 1,
    FxUnderWaterHitScale = 0.1,
    FxUnitHitScale = 1,
    FxWaterHitScale = 0.1,
    FxOnKilledScale = 3,
    FxTrails = {
	'/mods/Commander Survival Kit Units/effects/emitters/mgpF1_flaresmoke_emit.bp', --SMOKE
	'/mods/Commander Survival Kit Units/effects/emitters/mgpF1_flare01_emit.bp', --FIRE
	'/mods/Commander Survival Kit Units/effects/emitters/mgpF1_flare02_emit.bp', --GLOW
	'/mods/Commander Survival Kit Units/effects/emitters/mgpF1_flare03_emit.bp', --SPARKS
	},
	
	OnKilled = function(self, instigator, type, overkillRatio)
        EmitterProjectile.OnKilled(self, instigator, type, overkillRatio)
        CreateLightParticle(self, -1, self.Army, 3, 6, 'flare_lens_add_02', 'ramp_fire_13')
    end,

}

TypeClass = flare
