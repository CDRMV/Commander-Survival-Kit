local Projectile = import('/lua/terranprojectiles.lua').TIFMissileNuke
local Hit1 = import('/lua/EffectTemplates.lua').ExplosionEffectsLrg02
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 

Asteroids05 = Class(Projectile) {

    FxTrails = {
	'/effects/emitters/nuke_munition_launch_trail_04_emit.bp',
	'/effects/emitters/nuke_munition_launch_trail_06_emit.bp',
    '/mods/Commander Survival Kit/effects/emitters/fire_trail_08_emit.bp',
	},
	BeamName = '/mods/Commander Survival Kit/effects/emitters/empty_exhaust_beam_emit.bp',
    FxImpactTrajectoryAligned = false,
    FxTrailOffset = 1,
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
	FxTrailScale = 25.0,

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
		local army = self:GetArmy()
        local position = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local Dummy =CreateUnitHPR('USX0400b', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		 CreateLightParticle(self, -1, army, 80, 20, 'glow_03', 'ramp_fire_06')
		local fireballs = Random(15, 20)
		local fireballs2 = Random(6, 10)
        local projBp = '/mods/Commander Survival Kit/projectiles/Asteroid/Asteroids00/Asteroids00_proj.bp'
		local projBp2 = '/mods/Commander Survival Kit/projectiles/Asteroid/Asteroids01/Asteroids01_proj.bp'
        local angle = (2*math.pi) / fireballs
        local angle2 = (2*math.pi) / fireballs2
		local velocity2 = Random(0, -8)
        local DamageData = {
            DamageAmount = 500,
            DamageRadius = 5,
            DamageType = 'Normal',
        }
		local DamageData2 = {
            DamageAmount = 1000,
            DamageRadius = 10,
            DamageType = 'Normal',
        }

        local initialAngle = RandomFloat( 0, angle )
		local initialAngle2 = RandomFloat( 0, angle2 )
		local initialAngle3 = RandomFloat( 0, angle )
		local initialAngle4 = RandomFloat( 0, angle2 )
		for k, v in EffectTemplate.TNukeRings01 do
		CreateEmitterAtEntity(self, army, v )
        end
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

            if DamageData.DamageAmount > 0 then
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

            if DamageData2.DamageAmount > 0 then
                proj2:PassDamageData( DamageData2 )
            end
        end
		self:ForkThread(self.CreateHeadConvectionSpinners)
        self:ForkThread(self.CreateFlavorPlumes)
		self:CreateGroundPlumeConvectionEffects(army)
		WaitSeconds(0.1)
		self:Destroy()
		end
        )
    end,
	
	CreateGroundPlumeConvectionEffects = function(self,army)
    for k, v in EffectTemplate.TNukeGroundConvectionEffects01 do
          CreateEmitterAtEntity(self, army, v ) 
    end
    
    local sides = 10
    local angle = (2*math.pi) / sides
    local inner_lower_limit = 2
        local outer_lower_limit = 2
        local outer_upper_limit = 2
    
    local inner_lower_height = 1
    local inner_upper_height = 3
    local outer_lower_height = 2
    local outer_upper_height = 3
      
    sides = 8
    angle = (2*math.pi) / sides
    for i = 0, (sides-1)
    do
        local magnitude = RandomFloat(outer_lower_limit, outer_upper_limit)
        local x = math.sin(i*angle+RandomFloat(-angle/2, angle/4)) * magnitude
        local z = math.cos(i*angle+RandomFloat(-angle/2, angle/4)) * magnitude
        local velocity = RandomFloat( 1, 3 ) * 3
        self:CreateProjectile('/effects/entities/UEFNukeEffect05/UEFNukeEffect05_proj.bp', x, RandomFloat(outer_lower_height, outer_upper_height), z, x, 0, z)
            :SetVelocity(x * velocity, 0, z * velocity)
    end 
    end,
	
	CreateFlavorPlumes = function(self)
        local numProjectiles = 8
        local angle = (2*math.pi) / numProjectiles
        local angleInitial = RandomFloat( 0, angle )
        local angleVariation = angle * 0.75
        local projectiles = {}

        local xVec = 0 
        local yVec = 0
        local zVec = 0
        local velocity = 0

        # yVec -0.2, requires 2 initial velocity to start
        # yVec 0.3, requires 3 initial velocity to start
        # yVec 1.8, requires 8.5 initial velocity to start

        # Launch projectiles at semi-random angles away from the sphere, with enough
        # initial velocity to escape sphere core
        for i = 0, (numProjectiles -1) do
            xVec = math.sin(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))
            yVec = RandomFloat(0.2, 0.1)
            zVec = math.cos(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation)) 
            velocity = 1.4 + (yVec * RandomFloat(1,2))
            table.insert(projectiles, self:CreateProjectile('/effects/entities/UEFNukeFlavorPlume01/UEFNukeFlavorPlume01_proj.bp', 0, 0, 0, xVec, yVec, zVec):SetVelocity(velocity) )
        end

        WaitSeconds( 3 )

        # Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetVelocity(2):SetBallisticAcceleration(-0.15)
        end
    end,
    
    CreateHeadConvectionSpinners = function(self)
        local sides = 10
        local angle = (2*math.pi) / sides
        local HeightOffset = -1
        local velocity = 1
        local OffsetMod = 10
        local projectiles = {}        

        for i = 0, (sides-1) do
            local x = math.sin(i*angle) * OffsetMod
            local z = math.cos(i*angle) * OffsetMod
            local proj = self:CreateProjectile('/effects/entities/UEFNukeEffect03/UEFNukeEffect03_proj.bp', x, HeightOffset, z, x, 0, z)
                :SetVelocity(velocity)
            table.insert(projectiles, proj)
        end   
    
    WaitSeconds(1)
        for i = 0, (sides-1) do
            local x = math.sin(i*angle)
            local z = math.cos(i*angle)
            local proj = projectiles[i+1]
      proj:SetVelocityAlign(false)
      proj:SetOrientation(OrientFromDir(Util.Cross( Vector(x,0,z), Vector(0,1,0))),true)
      proj:SetVelocity(0,1,0) 
          proj:SetBallisticAcceleration(-0.05)            
        end   
    end,
}

TypeClass = Asteroids05

else

Asteroids05 = Class(Projectile) {

    FxTrails = {
	'/effects/emitters/nuke_munition_launch_trail_04_emit.bp',
	'/effects/emitters/nuke_munition_launch_trail_06_emit.bp',
    '/mods/Commander Survival Kit/effects/emitters/fire_trail_08_emit.bp',
	},
	BeamName = '/mods/Commander Survival Kit/effects/emitters/empty_exhaust_beam_emit.bp',
    FxImpactTrajectoryAligned = false,
    FxTrailOffset = 1,
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
	FxTrailScale = 25.0,

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
		local army = self:GetArmy()
        local position = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local Dummy =CreateUnitHPR('USX0400b', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		 CreateLightParticle(self, -1, army, 80, 20, 'glow_03', 'ramp_fire_06')
		local fireballs = Random(15, 20)
		local fireballs2 = Random(6, 10)
        local projBp = '/mods/Commander Survival Kit/projectiles/Asteroid/Asteroids00/Asteroids00_proj.bp'
		local projBp2 = '/mods/Commander Survival Kit/projectiles/Asteroid/Asteroids01/Asteroids01_proj.bp'
        local angle = (2*math.pi) / fireballs
        local angle2 = (2*math.pi) / fireballs2
		local velocity2 = Random(0, -8)
        local DamageData = {
            DamageAmount = 500,
            DamageRadius = 5,
            DamageType = 'Normal',
        }
		local DamageData2 = {
            DamageAmount = 1000,
            DamageRadius = 10,
            DamageType = 'Normal',
        }

        local initialAngle = RandomFloat( 0, angle )
		local initialAngle2 = RandomFloat( 0, angle2 )
		local initialAngle3 = RandomFloat( 0, angle )
		local initialAngle4 = RandomFloat( 0, angle2 )
		for k, v in EffectTemplate.TNukeRings01 do
		CreateEmitterAtEntity(self, army, v )
        end
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

            if DamageData.DamageAmount > 0 then
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

            if DamageData2.DamageAmount > 0 then
                proj2:PassDamageData( DamageData2 )
            end
        end
		self:ForkThread(self.CreateHeadConvectionSpinners)
        self:ForkThread(self.CreateFlavorPlumes)
		self:CreateGroundPlumeConvectionEffects(army)
		WaitSeconds(0.1)
		self:Destroy()
		end
        )
    end,
	
	CreateGroundPlumeConvectionEffects = function(self,army)
    for k, v in EffectTemplate.TNukeGroundConvectionEffects01 do
          CreateEmitterAtEntity(self, army, v ) 
    end
    
    local sides = 10
    local angle = (2*math.pi) / sides
    local inner_lower_limit = 2
        local outer_lower_limit = 2
        local outer_upper_limit = 2
    
    local inner_lower_height = 1
    local inner_upper_height = 3
    local outer_lower_height = 2
    local outer_upper_height = 3
      
    sides = 8
    angle = (2*math.pi) / sides
    for i = 0, (sides-1)
    do
        local magnitude = RandomFloat(outer_lower_limit, outer_upper_limit)
        local x = math.sin(i*angle+RandomFloat(-angle/2, angle/4)) * magnitude
        local z = math.cos(i*angle+RandomFloat(-angle/2, angle/4)) * magnitude
        local velocity = RandomFloat( 1, 3 ) * 3
        self:CreateProjectile('/effects/entities/UEFNukeEffect05/UEFNukeEffect05_proj.bp', x, RandomFloat(outer_lower_height, outer_upper_height), z, x, 0, z)
            :SetVelocity(x * velocity, 0, z * velocity)
    end 
    end,
	
	CreateFlavorPlumes = function(self)
        local numProjectiles = 8
        local angle = (2*math.pi) / numProjectiles
        local angleInitial = RandomFloat( 0, angle )
        local angleVariation = angle * 0.75
        local projectiles = {}

        local xVec = 0 
        local yVec = 0
        local zVec = 0
        local velocity = 0

        # yVec -0.2, requires 2 initial velocity to start
        # yVec 0.3, requires 3 initial velocity to start
        # yVec 1.8, requires 8.5 initial velocity to start

        # Launch projectiles at semi-random angles away from the sphere, with enough
        # initial velocity to escape sphere core
        for i = 0, (numProjectiles -1) do
            xVec = math.sin(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))
            yVec = RandomFloat(0.2, 0.1)
            zVec = math.cos(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation)) 
            velocity = 1.4 + (yVec * RandomFloat(1,2))
            table.insert(projectiles, self:CreateProjectile('/effects/entities/UEFNukeFlavorPlume01/UEFNukeFlavorPlume01_proj.bp', 0, 0, 0, xVec, yVec, zVec):SetVelocity(velocity) )
        end

        WaitSeconds( 3 )

        # Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetVelocity(2):SetBallisticAcceleration(-0.15)
        end
    end,
    
    CreateHeadConvectionSpinners = function(self)
        local sides = 10
        local angle = (2*math.pi) / sides
        local HeightOffset = -1
        local velocity = 1
        local OffsetMod = 10
        local projectiles = {}        

        for i = 0, (sides-1) do
            local x = math.sin(i*angle) * OffsetMod
            local z = math.cos(i*angle) * OffsetMod
            local proj = self:CreateProjectile('/effects/entities/UEFNukeEffect03/UEFNukeEffect03_proj.bp', x, HeightOffset, z, x, 0, z)
                :SetVelocity(velocity)
            table.insert(projectiles, proj)
        end   
    
    WaitSeconds(1)
        for i = 0, (sides-1) do
            local x = math.sin(i*angle)
            local z = math.cos(i*angle)
            local proj = projectiles[i+1]
      proj:SetVelocityAlign(false)
      proj:SetOrientation(OrientFromDir(Util.Cross( Vector(x,0,z), Vector(0,1,0))),true)
      proj:SetVelocity(0,1,0) 
          proj:SetBallisticAcceleration(-0.05)            
        end   
    end,
	


}

TypeClass = Asteroids05

end