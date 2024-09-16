--****************************************************************************
--**
--**  File     :  /lua/defaultantimissile.lua
--**  Author(s):  Gordon Duclos
--**
--**  Summary  :  Default definitions collision beams
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local Entity = import("/lua/sim/entity.lua").Entity
local GetRandomFloat = import("/lua/utilities.lua").GetRandomFloat

-- upvalue scope for performance
local IsEnemy = IsEnemy
local KillThread = KillThread
local EntityCategoryContains = EntityCategoryContains

-- pre-computed for performance
local FlareCategories = categories.ANTIAIRMISSILE
---@class FlareSpec
---@field Army Army
---@field Owner Unit | Projectile
---@field Radius number defaults to `5`
---@field OffsetMult number defaults to `0`
---@field RedirectCat UnparsedCategory defaults to `"MISSILE"`

---@class DepthChargeSpec
---@field Army Army
---@field Owner Projectile
---@field Radius number
---@field ProjectilesToDeflect number

---@class MissileRedirectSpec
---@field Army Army
---@field Owner string
---@field Radius number
---@field RedirectRateOfFire number
---@field AttachBone Bone

---@class Flare : Entity
---@field Army Army
---@field Owner Unit | Projectile
---@field Radius number
---@field OffsetMult number

Flare = Class(Entity) {

    ---@param self Flare
    ---@param spec FlareSpec
    OnCreate = function(self, spec)
        self.Army = self:GetArmy()
        self.Owner = spec.Owner
        self.Radius = spec.Radius or 5
        self.OffsetMult = spec.OffsetMult or 0
        self:SetCollisionShape('Sphere', 0, 0, self.Radius * self.OffsetMult, self.Radius)
        self:SetDrawScale(self.Radius)
        self:AttachTo(spec.Owner, -1)
    end,

    --- We only divert projectiles. The flare-projectile itself will be responsible for
    --- accepting the collision and causing the hostile projectile to impact.
    ---@param self Flare
    ---@param other Projectile
    ---@return boolean
    OnCollisionCheck = function(self, other)
        local army = self.Army
        if not IsDestroyed(self.Owner) and
            EntityCategoryContains(FlareCategories, other) and self:GetArmy() != other:GetArmy()
        then
            -- take out scripted movement
            local otherMoveThread = other.MoveThread
            if otherMoveThread then
                KillThread(otherMoveThread)
                other.MoveThread = nil
            end

            -- determine whether we redirect
            local owner = self.Owner
            local ownerRedirectedMissiles = owner.RedirectedMissiles
            if not (ownerRedirectedMissiles >= 3 or other.IsRedirected) then
                -- keep track of how many missiles we redirected
                owner.RedirectedMissiles = owner.RedirectedMissiles + 1

                other.IsRedirected = true
                other:SetNewTarget(self.Owner)
                other:SetTurnRate(120)

                -- projectiles that end due to lifetime still explode and deal damage,
                -- therefore we straigth out kill the projectile after a short duration
                other:SetLifetime(3)
                other.Trash:Add(
                    ForkThread(
                        self.KillThread,
                        self, other, 10 + 5 * Random()
                    )
                )

                local trash = owner.Trash

            end
        end

        return false
    end,

    --- Kills the projectile after waiting for a short duration
    ---@param self Flare
    ---@param projectile Projectile
    KillThread = function(self, projectile, ticksToWait)
        WaitTicks(ticksToWait)
        if not IsDestroyed(projectile) then
            Damage(self.Owner.Launcher, projectile:GetPosition(), projectile, 200, "Normal")
        end
    end,
}

---@class MissileRedirect : Entity
MissileRedirect = Class(Entity) {
    RedirectBeams = {},
    EndPointEffects = {},

    ---@param self MissileRedirect
    ---@param spec MissileRedirectSpec
    OnCreate = function(self, spec)
        self.Army = self:GetArmy()
        self.Owner = spec.Owner
        self.Radius = spec.Radius
        self.RedirectRateOfFire = spec.RedirectRateOfFire or 1
        self:SetCollisionShape('Sphere', 0, 0, 0, self.Radius)
        self:SetDrawScale(self.Radius)
        self.AttachBone = spec.AttachBone
        self:AttachTo(spec.Owner, spec.AttachBone)
        ChangeState(self, self.WaitingState)
    end,

    ---@param self MissileRedirect
    OnDestroy = function(self)
        ChangeState(self, self.DeadState)
    end,

    DeadState = State {
        Main = function(self)
        end,
    },

    -- Return true to process this collision, false to ignore it.
    WaitingState = State {
        OnCollisionCheck = function(self, other)
            if IsEnemy(self.Army, other:GetArmy()) and
                other ~= self.EnemyProj and
                EntityCategoryContains(categories.ANTIAIRMISSILE, other)
            then
                self.Enemy = other:GetLauncher()
                self.EnemyProj = other

                ChangeState(self, self.RedirectingState)
            end
            return false
        end,
    },

    RedirectingState = State {
        Main = function(self)
            if not self or self:BeenDestroyed() or
                not self.EnemyProj or self.EnemyProj:BeenDestroyed() or
                not self.Owner or self.Owner.Dead then
                if self then
                    ChangeState(self, self.WaitingState)
                end

                return
            end

            if self.Enemy then
                -- Set collision to friends active so that when the missile reaches its source it can deal damage.
                self.EnemyProj.CollideFriendly = true
                self.EnemyProj.DamageData.DamageFriendly = true
                self.EnemyProj.DamageData.DamageSelf = true
            end

            if not self.EnemyProj:BeenDestroyed() then
                local proj = self.EnemyProj
                local enemy = self.Enemy
                local enemyPos = enemy and enemy:GetPosition()

                if proj.MoveThread then
                    KillThread(proj.MoveThread)
                    proj.MoveThread = nil
                end

                proj:ForkThread(function()
                    local projPos = proj:GetPosition()
                    local above = { projPos[1] + GetRandomFloat(-2, 2), projPos[2] + GetRandomFloat(4, 6),
                        projPos[3] + GetRandomFloat(-2, 2) }

                    proj:SetLifetime(30)
                    proj:SetCollideSurface(true)
                    proj:SetTurnRate(160)
                    proj:SetNewTargetGround(above)
                    proj:TrackTarget(true)
                    WaitSeconds(1)

                    if proj:BeenDestroyed() then return end
                    if not enemy then
                        proj:DoTakeDamage(self.Owner, 30, Vector(0, 1, 0), 'Fire')
                    elseif not enemy:BeenDestroyed() then
                        proj:SetNewTarget(enemy)
                        WaitSeconds(2)
                        enemyPos = enemy:GetPosition()
                    end

                    -- aim at right below surface if unit is submerged
                    enemyPos = enemyPos or projPos
                    local surfaceHeight = GetSurfaceHeight(enemyPos[1], enemyPos[3]) - 0.02
                    enemyPos[2] = math.max(surfaceHeight, enemyPos[2])

                    proj:SetNewTargetGround(enemyPos)
                end)
            end

            ChangeState(self, self.WaitingState)
        end,

        OnCollisionCheck = function(self, other)
            return false
        end,
    },
}