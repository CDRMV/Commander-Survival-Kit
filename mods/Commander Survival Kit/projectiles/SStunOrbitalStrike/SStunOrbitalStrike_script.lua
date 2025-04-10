local Projectile = import('/lua/terranprojectiles.lua').TArtilleryProjectilePolytrail
local Hit1 = import('/lua/EffectTemplates.lua').ExplosionEffectsLrg02
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')
local Modpath = '/mods/Commander Survival Kit/effects/emitters/'
SOrbitalStrike = Class(Projectile) {

    FxTrails = {
    '/effects/emitters/seraphim_khu_anti_nuke_fxtrail_01_emit.bp',
   '/effects/emitters/seraphim_khu_anti_nuke_fxtrail_02_emit.bp',
   '/effects/emitters/seraphim_khu_anti_nuke_fxtrail_03_emit.bp',
    '/effects/emitters/seraphim_rifter_mobileartillery_projectile_fxtrails_01_emit.bp',
   '/effects/emitters/seraphim_rifter_mobileartillery_projectile_fxtrails_02_emit.bp',
    '/effects/emitters/seraphim_rifter_mobileartillery_projectile_fxtrails_03_emit.bp',
    '/effects/emitters/seraphim_rifter_mobileartillery_projectile_fxtrails_04_emit.bp',
    '/effects/emitters/seraphim_rifter_mobileartillery_projectile_fxtrails_05_emit.bp',
    '/effects/emitters/seraphim_rifter_mobileartillery_projectile_fxtrails_06_emit.bp',
	},
	BeamName = '/mods/Commander Survival Kit/effects/emitters/empty_exhaust_beam_emit.bp',
    FxImpactTrajectoryAligned = false,
    PolyTrail = '/mods/Commander Survival Kit/effects/emitters/empty_trail_emit.bp',
	FxTrailScale = 10,
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
	FxTrailScale = 2.0,

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
	    Projectile.OnImpact(self, impactType, targetEntity)
        local pos = self:GetPosition()
        if impactType == 'Terrain' then
		self:CreateProjectile('/mods/Commander Survival Kit/effects/entities/SeraStunBlastEffect01/SeraStunBlastEffect01_proj.bp', 0, 0, 0, 0, 0, 1)
            CreateSplat(
                pos,
                Random()*2*math.pi,
                'czar_mark01_albedo',
                15, 15,
                500, 100,
                -1
            )
            DamageArea(self, pos, 5, 1, 'Force', true)
			self:CreateImpactEffects(self.Army, self.FxImpactUnit, 2)
        end
    end,
	
}

TypeClass = SOrbitalStrike