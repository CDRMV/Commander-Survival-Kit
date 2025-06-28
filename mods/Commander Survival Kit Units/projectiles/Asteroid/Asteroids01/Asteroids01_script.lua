local Projectile = import('/lua/terranprojectiles.lua').TArtilleryProjectilePolytrail
local Hit1 = import('/lua/EffectTemplates.lua').ExplosionEffectsLrg02

Asteroids01 = Class(Projectile) {

    FxTrails = {
	'/effects/emitters/nuke_munition_launch_trail_04_emit.bp',
	'/effects/emitters/nuke_munition_launch_trail_06_emit.bp',
    '/mods/Commander Survival Kit/effects/emitters/fire_trail_08_emit.bp',
	},
	BeamName = '/mods/Commander Survival Kit/effects/emitters/empty_exhaust_beam_emit.bp',
    FxImpactTrajectoryAligned = false,
    PolyTrail = '/mods/Commander Survival Kit/effects/emitters/empty_trail_emit.bp',
    FxTrailOffset = 0.5,
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
	FxTrailScale = 4.0,

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
            DamageArea(self, pos, 5, 1, 'Force', true)
        end
        Projectile.OnImpact(self, impactType, targetEntity)
    end,
}

TypeClass = Asteroids01