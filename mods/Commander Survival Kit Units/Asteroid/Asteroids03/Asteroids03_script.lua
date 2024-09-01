local Projectile = import('/lua/sim/DefaultProjectiles.lua').EmitterProjectile
local Hit1 = import('/lua/EffectTemplates.lua').ExplosionEffectsLrg02

Asteroids02 = Class(Projectile) {

    FxTrails = {
	'/mods/Commander Survival Kit/effects/emitters/Asteroid_Trail01_emit.bp',
	'/mods/Commander Survival Kit/effects/emitters/Asteroid_Trail02_emit.bp',
	},
    FxImpactTrajectoryAligned = false,
    FxTrailScale = 70,
    FxTrailOffset = 0,
    FxImpactUnit = Hit1,
    FxImpactLand = Hit1,
    FxImpactWater = {
        '/effects/emitters/seraphim_rifter_artillery_hit_01w_emit.bp',
        '/effects/emitters/seraphim_rifter_artillery_hit_02w_emit.bp',
        '/effects/emitters/seraphim_rifter_artillery_hit_03w_emit.bp',
        '/effects/emitters/seraphim_rifter_artillery_hit_05w_emit.bp',
        '/effects/emitters/seraphim_rifter_artillery_hit_06w_emit.bp',
        '/effects/emitters/seraphim_rifter_artillery_hit_08w_emit.bp',
    },
    FxImpactNone = Hit1,
    FxImpactProp = Hit1,
    RandomPolyTrails = 2,

    OnCreate = function(self)
        Projectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2)
        self.MoveThread = self:ForkThread(self.MovementThread)
    end,

    MovementThread = function(self)        
        self.WaitTime = 0.1
        self.Distance = self:GetDistanceToTarget()
        self:SetTurnRate(8)
        WaitSeconds(0.3)        
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitSeconds(self.WaitTime)
        end
    end,

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        if dist > self.Distance then
        	self:SetTurnRate(75)
        	WaitSeconds(3)
        	self:SetTurnRate(8)
        	self.Distance = self:GetDistanceToTarget()
        end
        if dist > 50 then        
            #Freeze the turn rate as to prevent steep angles at long distance targets
            WaitSeconds(2)
            self:SetTurnRate(10)
        elseif dist > 30 and dist <= 50 then
						self:SetTurnRate(12)
						WaitSeconds(1.5)
            self:SetTurnRate(12)
        elseif dist > 10 and dist <= 25 then
            WaitSeconds(0.3)
            self:SetTurnRate(50)
				elseif dist > 0 and dist <= 10 then         
            self:SetTurnRate(100)   
            KillThread(self.MoveThread)         
        end
    end,        

    GetDistanceToTarget = function(self)
        local tpos = self:GetCurrentTargetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,
	

    OnImpact = function(self, impactType, targetEntity)
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Explosion then
                self:PlaySound(myBlueprint.Audio.Explosion)
            end
           
			nukeProjectile = self:CreateProjectile('/mods/Commander Survival Kit/effects/Entities/LargeAsteroid/TacNukeEffectController01/TacNukeEffectController01_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
            nukeProjectile:PassData(self.Data)
        local dam = self.DamageData.DamageAmount
        self.DamageData.DamageAmount = (dam*0.5)+(dam*0.5*Random())
        local pos = self:GetPosition()
        if impactType == 'Terrain' then
            CreateSplat(
                pos,
                Random()*2*math.pi,
                'czar_mark01_albedo',
                5, 5,
                500, 100,
                -1
            )
            local num = Random(1,7)
            if num <= 5 then
                CreatePropHPR(
                    '/env/Lava/Props/Rocks/Lav_Rock0'..num..'_prop.bp',
                    pos[1], pos[2], pos[3],
                    Random(0,360), Random(-20,20), Random(-20,20)
                )
            end
        end
        Projectile.OnImpact(self, impactType, targetEntity)
    end,
}

TypeClass = Asteroids02