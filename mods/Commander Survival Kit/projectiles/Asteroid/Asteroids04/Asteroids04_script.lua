local Projectile = import('/lua/terranprojectiles.lua').TIFMissileNuke
local Hit1 = import('/lua/EffectTemplates.lua').ExplosionEffectsLrg02
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 

Asteroids04 = Class(Projectile) {

    FxTrails = {
	'/effects/emitters/nuke_munition_launch_trail_04_emit.bp',
	'/effects/emitters/nuke_munition_launch_trail_06_emit.bp',
    '/mods/Commander Survival Kit/effects/emitters/fire_trail_08_emit.bp',
	},
	BeamName = '/mods/Commander Survival Kit/effects/emitters/empty_exhaust_beam_emit.bp',
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
	FxTrailScale = 12.0,

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
           
			nukeProjectile = self:CreateProjectile('/mods/Commander Survival Kit/effects/Entities/KillerAsteroidImpactEffectController01/KillerAsteroidImpactEffectController01_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
            nukeProjectile:PassDamageData(self.DamageData)
            nukeProjectile:PassData(self.Data)
        Projectile.OnImpact(self, impactType, targetEntity)
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
	   self:ForkThread(
        function()
		local fireballs = Random(15, 20)
		local fireballs2 = Random(6, 10)
        local projBp = '/mods/Commander Survival Kit/projectiles/Asteroid/Asteroids00/Asteroids00_proj.bp'
		local projBp2 = '/mods/Commander Survival Kit/projectiles/Asteroid/Asteroids01/Asteroids01_proj.bp'
        local angle = (2*math.pi) / fireballs
        local angle2 = (2*math.pi) / fireballs2
		local velocity2 = Random(0, -8)
        local DamageData = {
            Damage = self.NukeBlackHoleFireballDamage or 0,
            Radius = self.NukeBlackHoleFireballRadius or 0,
            DamageType = self.NukeBlackHoleFireballDamageType or 'Normal',
        }

        local initialAngle = RandomFloat( 0, angle )
		local initialAngle2 = RandomFloat( 0, angle2 )
		local initialAngle3 = RandomFloat( 0, angle )
		local initialAngle4 = RandomFloat( 0, angle2 )
        for i = 0, (fireballs-1) do
			local velocity = Random(-8, 8)
            local randomAngle = 1.2 * RandomFloat( -angle, angle )
            local X = math.sin( (i * angle) + initialAngle + randomAngle )
            local Z = math.cos( (i * angle) + initialAngle + randomAngle )
            local Y = RandomFloat( 1, 3)
            local proj =  self:CreateProjectile( projBp, 0, 0, 0, X, Y, Z)
            proj:SetVelocity( X * velocity, Y * velocity, Z * velocity )
            proj:SetVelocity( velocity * RandomFloat(0.75, 1.25) )
            proj:SetBallisticAcceleration( -2 )

            if DamageData.Damage > 0 then
                proj:PassDamageData( DamageData )
            end
        end
		for i = 0, (fireballs2-1) do
			local velocity = Random(-8, 8)
            local randomAngle2 = 1.2 * RandomFloat( -angle2, angle2 )
            local X2 = math.sin( (i * angle2) + initialAngle2 + randomAngle2 )
            local Z2 = math.cos( (i * angle2) + initialAngle2 + randomAngle2 )
            local Y2 = RandomFloat( 1, 3)
            local proj2 =  self:CreateProjectile( projBp2, 0, 0, 0, X2, Y2, Z2)
            proj2:SetVelocity( X2 * velocity, Y2 * velocity, Z2 * velocity )
            proj2:SetVelocity( velocity * RandomFloat(0.75, 1.25) )
            proj2:SetBallisticAcceleration( -2 )

            if DamageData.Damage > 0 then
                proj2:PassDamageData( DamageData )
            end
        end
		WaitSeconds(0.1)
		self:Destroy()
		end
        )
    end,
}

TypeClass = Asteroids04

else

Asteroids04 = Class(Projectile) {

    FxTrails = {
	'/effects/emitters/nuke_munition_launch_trail_04_emit.bp',
	'/effects/emitters/nuke_munition_launch_trail_06_emit.bp',
    '/mods/Commander Survival Kit/effects/emitters/fire_trail_08_emit.bp',
	},
	BeamName = '/mods/Commander Survival Kit/effects/emitters/empty_exhaust_beam_emit.bp',
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
	FxTrailScale = 12.0,

    OnCreate = function(self)
        Projectile.OnCreate(self)
        self.effectEntityPath = '/mods/Commander Survival Kit/effects/Entities/KillerAsteroidImpactEffectController01/KillerAsteroidImpactEffectController01_proj.bp'
        self:LauncherCallbacks()
    end,

    OnImpact = function(self, TargetType, TargetEntity)
        if EntityCategoryContains(categories.AEON * categories.PROJECTILE * categories.ANTIMISSILE * categories.TECH2, TargetEntity) then
            self:Destroy()
        else
            Projectile.OnImpact(self, TargetType, TargetEntity)
        end
    end,

    -- Tactical nuke has different flight path
    MovementThread = function(self)
        self:CreateEffects(self.InitialEffects, self.Army, 1)
        self:SetTurnRate(8)
        WaitTicks(4)
        self:CreateEffects(self.LaunchEffects, self.Army, 1)
        self:CreateEffects(self.ThrustEffects, self.Army, 1)
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitTicks(2)
        end
    end,

    DoDamage = function(self, instigator, DamageData, targetEntity)
        local nukeDamage = function(self, instigator, pos, brain, army, damageType)
            if self.TotalTime == 0 then
                DamageArea(instigator, pos, self.Radius, self.Damage, (damageType or 'Nuke'), true, true)
            end
        end
        self.InnerRing.DoNukeDamage = nukeDamage
        self.OuterRing.DoNukeDamage = nukeDamage
        Projectile.DoDamage(self, instigator, DamageData, targetEntity)
    end,

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        if dist > 50 then
            -- Freeze the turn rate as to prevent steep angles at long distance targets
            WaitTicks(21)
            self:SetTurnRate(20)
        elseif dist > 128 and dist <= 213 then
            -- Increase check intervals
            self:SetTurnRate(30)
            WaitTicks(16)
            self:SetTurnRate(30)
        elseif dist > 43 and dist <= 107 then
            -- Further increase check intervals
            WaitTicks(4)
            self:SetTurnRate(75)
        elseif dist > 0 and dist <= 43 then
            -- Further increase check intervals
            self:SetTurnRate(200)
            KillThread(self.MoveThread)
        end
    end,

    OnEnterWater = function(self)
        Projectile.OnEnterWater(self)
        self:SetDestroyOnWater(true)
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
	   self:ForkThread(
        function()
		local fireballs = Random(15, 20)
		local fireballs2 = Random(6, 10)
        local projBp = '/mods/Commander Survival Kit/projectiles/Asteroid/Asteroids00/Asteroids00_proj.bp'
		local projBp2 = '/mods/Commander Survival Kit/projectiles/Asteroid/Asteroids01/Asteroids01_proj.bp'
        local angle = (2*math.pi) / fireballs
        local angle2 = (2*math.pi) / fireballs2
		local velocity2 = Random(0, -8)
        local DamageData = {
            Damage = self.NukeBlackHoleFireballDamage or 0,
            Radius = self.NukeBlackHoleFireballRadius or 0,
            DamageType = self.NukeBlackHoleFireballDamageType or 'Normal',
        }

        local initialAngle = RandomFloat( 0, angle )
		local initialAngle2 = RandomFloat( 0, angle2 )
		local initialAngle3 = RandomFloat( 0, angle )
		local initialAngle4 = RandomFloat( 0, angle2 )
        for i = 0, (fireballs-1) do
			local velocity = Random(-8, 8)
            local randomAngle = 1.2 * RandomFloat( -angle, angle )
            local X = math.sin( (i * angle) + initialAngle + randomAngle )
            local Z = math.cos( (i * angle) + initialAngle + randomAngle )
            local Y = RandomFloat( 1, 3)
            local proj =  self:CreateProjectile( projBp, 0, 0, 0, X, Y, Z)
            proj:SetVelocity( X * velocity, Y * velocity, Z * velocity )
            proj:SetVelocity( velocity * RandomFloat(0.75, 1.25) )
            proj:SetBallisticAcceleration( -2 )

            if DamageData.Damage > 0 then
                proj:PassDamageData( DamageData )
            end
        end
		for i = 0, (fireballs2-1) do
			local velocity = Random(-8, 8)
            local randomAngle2 = 1.2 * RandomFloat( -angle2, angle2 )
            local X2 = math.sin( (i * angle2) + initialAngle2 + randomAngle2 )
            local Z2 = math.cos( (i * angle2) + initialAngle2 + randomAngle2 )
            local Y2 = RandomFloat( 1, 3)
            local proj2 =  self:CreateProjectile( projBp2, 0, 0, 0, X2, Y2, Z2)
            proj2:SetVelocity( X2 * velocity, Y2 * velocity, Z2 * velocity )
            proj2:SetVelocity( velocity * RandomFloat(0.75, 1.25) )
            proj2:SetBallisticAcceleration( -2 )

            if DamageData.Damage > 0 then
                proj2:PassDamageData( DamageData )
            end
        end
		WaitSeconds(0.1)
		self:Destroy()
		end
        )
    end,
	


}

TypeClass = Asteroids04

end