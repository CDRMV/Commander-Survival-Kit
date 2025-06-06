#****************************************************************************
#**
#**  File     :  /effects/Entities/UEFNukeEffectController01/UEFNukeEffectController01_script.lua
#**  Author(s):  Gordon Duclos
#**
#**  Summary  :  Nuclear explosion script
#**
#**  Copyright � 2005,2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local NullShell = import('/lua/sim/defaultprojectiles.lua').NullShell
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local ModPath = '/mods/Commander Survival Kit/effects/Entities/KillerAsteroidImpactEffectController01/'
local SIFExperimentalStrategicMissileEffect02 = '/effects/Entities/SIFExperimentalStrategicMissileEffect02/SIFExperimentalStrategicMissileEffect02_proj.bp' 
local SIFExperimentalStrategicMissileEffect04 = '/effects/Entities/SIFExperimentalStrategicMissileEffect04/SIFExperimentalStrategicMissileEffect04_proj.bp' 
local SIFExperimentalStrategicMissileEffect05 = '/effects/Entities/SIFExperimentalStrategicMissileEffect05/SIFExperimentalStrategicMissileEffect05_proj.bp'
local SIFExperimentalStrategicMissileEffect06 = '/effects/Entities/SIFExperimentalStrategicMissileEffect06/SIFExperimentalStrategicMissileEffect06_proj.bp'


KillerAsteroidImpactEffectController01 = Class(NullShell) {
    NukeOuterRingDamage = 0,
    NukeOuterRingRadius = 0,
    NukeOuterRingTicks = 0,
    NukeOuterRingTotalTime = 0,

    NukeInnerRingDamage = 0,
    NukeInnerRingRadius = 0,
    NukeInnerRingTicks = 0,
    NukeInnerRingTotalTime = 0,
   
    
    # NOTE: This script has been modified to REQUIRE that data is passed in!  The nuke won't explode until this happens!
    #OnCreate = function(self)

    PassData = function(self, Data)
        if Data.NukeOuterRingDamage then self.NukeOuterRingDamage = Data.NukeOuterRingDamage end
        if Data.NukeOuterRingRadius then self.NukeOuterRingRadius = Data.NukeOuterRingRadius end
        if Data.NukeOuterRingTicks then self.NukeOuterRingTicks = Data.NukeOuterRingTicks end
        if Data.NukeOuterRingTotalTime then self.NukeOuterRingTotalTime = Data.NukeOuterRingTotalTime end
        if Data.NukeInnerRingDamage then self.NukeInnerRingDamage = Data.NukeInnerRingDamage end
        if Data.NukeInnerRingRadius then self.NukeInnerRingRadius = Data.NukeInnerRingRadius end
        if Data.NukeInnerRingTicks then self.NukeInnerRingTicks = Data.NukeInnerRingTicks end
        if Data.NukeInnerRingTotalTime then self.NukeInnerRingTotalTime = Data.NukeInnerRingTotalTime end
  
        self:CreateNuclearExplosion()
    end,

    CreateNuclearExplosion = function(self)
        local myBlueprint = self:GetBlueprint()
            
        # Play the "NukeExplosion" sound
        if myBlueprint.Audio.NukeExplosion then
            self:PlaySound(myBlueprint.Audio.NukeExplosion)
        end
    
    # Create Damage Threads
        self:ForkThread(self.InnerRingDamage)
        self:ForkThread(self.OuterRingDamage)

    # Create thread that spawns and controls effects
        self:ForkThread(self.EffectThread)
    end,    

    OuterRingDamage = function(self)
        local myPos = self:GetPosition()
        if self.NukeOuterRingTotalTime == 0 then
            DamageArea(self:GetLauncher(), myPos, self.NukeOuterRingRadius, self.NukeOuterRingDamage, self.DamageData.DamageType, true, true)
        else
            local ringWidth = ( self.NukeOuterRingRadius / self.NukeOuterRingTicks )
            local tickLength = ( self.NukeOuterRingTotalTime / self.NukeOuterRingTicks )
            # Since we're not allowed to have an inner radius of 0 in the DamageRing function,
            # I'm manually executing the first tick of damage with a DamageArea function.
            DamageArea(self:GetLauncher(), myPos, ringWidth, self.NukeOuterRingDamage, 'Normal', true, true)
            WaitSeconds(tickLength)
            for i = 2, self.NukeOuterRingTicks do
                #print('Damage Ring: MaxRadius:' .. 2*i)
                DamageRing(self:GetLauncher(), myPos, ringWidth * (i - 1), ringWidth * i, self.NukeOuterRingDamage, self.DamageData.DamageType, true, true)
                WaitSeconds(tickLength)
            end
        end
    end,

    InnerRingDamage = function(self)
        local myPos = self:GetPosition()
        if self.NukeInnerRingTotalTime == 0 then
            DamageArea(self:GetLauncher(), myPos, self.NukeInnerRingRadius, self.NukeInnerRingDamage, self.DamageData.DamageType, true, true)
        else
            local ringWidth = ( self.NukeInnerRingRadius / self.NukeInnerRingTicks )
            local tickLength = ( self.NukeInnerRingTotalTime / self.NukeInnerRingTicks )
            # Since we're not allowed to have an inner radius of 0 in the DamageRing function,
            # I'm manually executing the first tick of damage with a DamageArea function.
            DamageArea(self:GetLauncher(), myPos, ringWidth, self.NukeInnerRingDamage, 'Normal', true, true)
            WaitSeconds(tickLength)
            for i = 2, self.NukeInnerRingTicks do
                #LOG('Damage Ring: MaxRadius:' .. ringWidth * i)
                DamageRing(self:GetLauncher(), myPos, ringWidth * (i - 1), ringWidth * i, self.NukeInnerRingDamage, self.DamageData.DamageType, true, true)
                WaitSeconds(tickLength)
            end
        end
    end,

    EffectThread = function(self)
        local army = self:GetArmy()
        local position = self:GetPosition()

        # Create full-screen glow flash
        CreateLightParticle(self, -1, army, 35, 4, 'glow_02', 'ramp_red_02')
        WaitSeconds(0.25)
        CreateLightParticle(self, -1, army, 80, 20, 'glow_03', 'ramp_fire_06')

        # Create initial fireball dome effect
        local FireballDomeYOffset = -0.1
        --self:CreateProjectile('/effects/entities/UEFNukeEffect01/UEFNukeEffect01_proj.bp',0,FireballDomeYOffset,0,0,0,1)
        
        # Create projectile that controls plume effects
        local PlumeEffectYOffset = 0.1
        --self:CreateProjectile('/effects/entities/UEFNukeEffect02/UEFNukeEffect02_proj.bp',0,PlumeEffectYOffset,0,0,0,1)        
        
        
        for k, v in EffectTemplate.TNukeRings01 do
      CreateEmitterAtEntity(self, army, v ):OffsetEmitter(0,5,0)
        end
		
        for k, v in EffectTemplate.TNukeRings01 do
      CreateEmitterAtEntity(self, army, v ):OffsetEmitter(0,-1,0):ScaleEmitter(2)
        end
		
		
		for k, v in EffectTemplate.SIFExperimentalStrategicMissileDetonate01 do
            emit = CreateEmitterAtEntity(self,army,v)
        end
		
		local plume = self:CreateProjectile(ModPath ..'KillerAsteroidImpactEffect03/KillerAsteroidImpactEffect03_proj.bp', 0, 3, 0, 0, 1, 0)
        plume:SetLifetime(6.0)
        plume:SetVelocity(10.0)
        plume:SetAcceleration(-0.35)  
        plume:SetCollision(false)
        plume:SetVelocityAlign(true)
        
        WaitSeconds( 1.0 )
		
		# Create fireball plumes to accentuate the explosive detonation
        local num_projectiles = 30        
        local horizontal_angle = (2*math.pi) / num_projectiles
        local angleInitial = RandomFloat( 0, horizontal_angle )  
        local xVec, yVec, zVec
        local angleVariation = 0.5        
        local px, py, pz  

		local DamageData = {
            DamageAmount = 500,
            DamageRadius = 5,
            DamageType = 'Normal',
        }

     
        for i = 0, (num_projectiles -1) do            
            xVec = math.sin(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation) ) 
            yVec = RandomFloat( 0.3, 1.5 ) + 1.2
            zVec = math.cos(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation) ) 
            px = RandomFloat( 7.5, 14.0 ) * xVec
            py = RandomFloat( 7.5, 14.0 ) * yVec
            pz = RandomFloat( 7.5, 14.0 ) * zVec
            
            local proj = self:CreateProjectile( '/mods/Commander Survival Kit/projectiles/Asteroid/Asteroids00/Asteroids00_proj.bp', px, py, pz, xVec, yVec, zVec )
            proj:SetVelocity(RandomFloat( 40, 100  ))
            proj:SetBallisticAcceleration(RandomFloat(-0.4, -1.8 ))    
			if DamageData.DamageAmount > 0 then
                proj:PassDamageData( DamageData )
            end
        end  

        local num_projectiles2 = 25        
        local horizontal_angle2 = (2*math.pi) / num_projectiles2
        local angleInitial2 = RandomFloat( 0, horizontal_angle2 )  
        local xVec2, yVec2, zVec2
        local angleVariation2 = 0.5        
        local px2, py2, pz2

		local DamageData2 = {
            DamageAmount = 1000,
            DamageRadius = 10,
            DamageType = 'Normal',
        }
     
        for i = 0, (num_projectiles2 -1) do            
            xVec2 = math.sin(angleInitial2 + (i*horizontal_angle2) + RandomFloat(-angleVariation2, angleVariation2) ) 
            yVec2 = RandomFloat( 0.3, 1.5 ) + 1.2
            zVec2 = math.cos(angleInitial2 + (i*horizontal_angle2) + RandomFloat(-angleVariation2, angleVariation2) ) 
            px2 = RandomFloat( 7.5, 14.0 ) * xVec2
            py2 = RandomFloat( 7.5, 14.0 ) * yVec2
            pz2 = RandomFloat( 7.5, 14.0 ) * zVec2
            
            local proj = self:CreateProjectile( '/mods/Commander Survival Kit/projectiles/Asteroid/Asteroids01/Asteroids01_proj.bp', px2, py2, pz2, xVec2, yVec2, zVec2 )
            proj:SetVelocity(RandomFloat( 40, 100  ))
            proj:SetBallisticAcceleration(RandomFloat(-0.4, -1.8 ))  
			if DamageData2.DamageAmount > 0 then
                proj:PassDamageData( DamageData2 )
            end
        end  		
        
        self:CreateInitialFireballSmokeRing()
        self:ForkThread(self.CreateOuterRingWaveSmokeRing)
		self:CreateInitialFireballSmokeRing2()
        self:ForkThread(self.CreateOuterRingWaveSmokeRing2)
        self:ForkThread(self.CreateHeadConvectionSpinners)
        self:ForkThread(self.CreateFlavorPlumes)
		self:ForkThread(self.CreateHeadConvectionSpinners2)
        self:ForkThread(self.CreateFlavorPlumes2)
		--self:ForkThread(self.CreateEffectInnerPlasma)
        --self:ForkThread(self.CreateEffectElectricity)
		--self:ForkThread(self.AftermathFireBalls)
        --self:ForkThread(self.AftermathFireBalls2)
        WaitSeconds( 0.55 )

        
        CreateLightParticle(self, -1, army, 300, 250, 'glow_03', 'ramp_nuke_04')
        
        # Create ground decals
        local orientation = RandomFloat(0,2*math.pi)
        CreateDecal(position, orientation, 'Crater01_albedo', '', 'Albedo', 50, 50, 1200, 0, army)
        CreateDecal(position, orientation, 'Crater01_normals', '', 'Normals', 50, 50, 1200, 0, army)       
        CreateDecal(position, orientation, 'nuke_scorch_003_albedo', '', 'Albedo', 60, 60, 1200, 0, army)    

    # Knockdown force rings
        DamageRing(self, position, 0.1, 85, 1, 'Force', true)
        WaitSeconds(0.1)
        DamageRing(self, position, 0.1, 85, 1, 'Force', true)

        WaitSeconds(8.9)
        self:CreateGroundPlumeConvectionEffects(army)
        
    end,
	
	CreateEffectInnerPlasma = function(self)
        local vx, vy, vz = self:GetVelocity()
        local num_projectiles = 12        
        local horizontal_angle = (2*math.pi) / num_projectiles
        local angleInitial = RandomFloat( 0, horizontal_angle )  
        local xVec, zVec
        local offsetMultiple = 10.0
        local px, pz

		WaitSeconds( 3.5 )
        for i = 0, (num_projectiles -1) do            
            xVec = (math.sin(angleInitial + (i*horizontal_angle)))
            zVec = (math.cos(angleInitial + (i*horizontal_angle)))
            px = (offsetMultiple*xVec)
            pz = (offsetMultiple*zVec)
            
            local proj = self:CreateProjectile( '/effects/entities/UEFNukeEffect03/UEFNukeEffect03_proj.bp', px, -10, pz, xVec, 0, zVec )
            proj:SetLifetime(5.0)
            proj:SetVelocity(7.0)
            proj:SetAcceleration(-0.35)            
        end
	end,
	
	# Create random wavy electricity lines
    CreateEffectElectricity = function(self)
        local vx, vy, vz = self:GetVelocity()
        local num_projectiles = 7        
        local horizontal_angle = (2*math.pi) / num_projectiles
        local angleInitial = RandomFloat( 0, horizontal_angle )  
        local xVec, zVec
        local offsetMultiple = 0.0
        local px, pz

		WaitSeconds( 3.5 )
        for i = 0, (num_projectiles -1) do            
            xVec = (math.sin(angleInitial + (i*horizontal_angle)))
            zVec = (math.cos(angleInitial + (i*horizontal_angle)))
            px = (offsetMultiple*xVec)
            pz = (offsetMultiple*zVec)
            
            local proj = self:CreateProjectile( '/effects/entities/UEFNukeEffect03/UEFNukeEffect03_proj.bp', px, -8, pz, xVec, 0, zVec )
            proj:SetLifetime(3.0)
            proj:SetVelocity(RandomFloat( 11, 20 ))
            proj:SetAcceleration(-0.35)            
        end
	end, 
	
	CreateInitialFireballSmokeRing = function(self)
        local sides = 12
        local angle = (2*math.pi) / sides
        local velocity = 5
        local OffsetMod = 15       

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            self:CreateProjectile('/effects/entities/UEFNukeShockwave01/UEFNukeShockwave01_proj.bp', X * OffsetMod , 10.5, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity):SetAcceleration(-0.5)
        end   
    end,  
    
    CreateOuterRingWaveSmokeRing = function(self)
        local sides = 32
        local angle = (2*math.pi) / sides
        local velocity = 7
        local OffsetMod = 10
        local projectiles = {}

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            local proj =  self:CreateProjectile('/effects/entities/UEFNukeShockwave02/UEFNukeShockwave02_proj.bp', X * OffsetMod , 10.5, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity)
            table.insert( projectiles, proj )
        end  
        
        WaitSeconds( 3 )

        # Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetAcceleration(-0.45)
        end         
    end, 
        
    CreateInitialFireballSmokeRing2 = function(self)
        local sides = 15
        local angle = (1*math.pi) / sides
        local velocity = 10
        local OffsetMod = 8       

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            self:CreateProjectile('/effects/entities/UEFNukeShockwave01/UEFNukeShockwave01_proj.bp', X * OffsetMod , 1.5, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity):SetAcceleration(-1)
        end   
    end,  
    
    CreateOuterRingWaveSmokeRing2 = function(self)
        local sides = 32
        local angle = (1*math.pi) / sides
        local velocity = 15
        local OffsetMod = 8
        local projectiles = {}

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            local proj =  self:CreateProjectile('/effects/entities/UEFNukeShockwave02/UEFNukeShockwave02_proj.bp', X * OffsetMod , 2.5, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity)
            table.insert( projectiles, proj )
        end  
        
        WaitSeconds( 3 )

        # Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetAcceleration(-0.85)
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
        local HeightOffset = 1
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
    
    CreateFlavorPlumes2 = function(self)
        local numProjectiles = 8
        local angle = (1*math.pi) / numProjectiles
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
            velocity = 20.4 + (yVec * RandomFloat(1,2))
            table.insert(projectiles, self:CreateProjectile('/effects/entities/UEFNukeFlavorPlume01/UEFNukeFlavorPlume01_proj.bp', 0, 0, 0, xVec, yVec, zVec):SetVelocity(velocity) )
        end

        WaitSeconds( 3 )

        # Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetVelocity(2):SetBallisticAcceleration(-0.15)
        end
    end,
    
    CreateHeadConvectionSpinners2 = function(self)
        local sides = 10
        local angle = (1*math.pi) / sides
        local HeightOffset = -1
        local velocity = 3
        local OffsetMod = 35
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
    
    CreateGroundPlumeConvectionEffects = function(self,army)
    for k, v in EffectTemplate.TNukeGroundConvectionEffects01 do
          CreateEmitterAtEntity(self, army, v ) 
    end
    
    local sides = 20
    local angle = (2*math.pi) / sides
    local inner_lower_limit = 4
        local outer_lower_limit = 4
        local outer_upper_limit = 4
    
    local inner_lower_height = 4
    local inner_upper_height = 8
    local outer_lower_height = 4
    local outer_upper_height = 7
      
    sides = 8
    angle = (2*math.pi) / sides
    for i = 0, (sides-1)
    do
        local magnitude = RandomFloat(outer_lower_limit, outer_upper_limit)
        local x = math.sin(i*angle+RandomFloat(-angle/2, angle/4)) * magnitude
        local z = math.cos(i*angle+RandomFloat(-angle/2, angle/4)) * magnitude
        local velocity = RandomFloat( 1, 5 ) * 3
        self:CreateProjectile('/effects/entities/UEFNukeEffect05/UEFNukeEffect05_proj.bp', x, RandomFloat(outer_lower_height, outer_upper_height), z, x, 0, z)
            :SetVelocity(x * velocity, 0, z * velocity)
    end 
    end,
	
	AftermathFireBalls = function(self, bag, lifetime, wreck)
        -- TODO: add more particles, this can be much more dramatic
        -- creates fireballs in the air flying outwards in a nice arc
        local fireballs = Random(15, 30)
        if fireballs < 1 then
            return
        end

        local projBp = '/mods/Commander Survival Kit/projectiles/Asteroid/Asteroids00/Asteroids00_proj.bp'

        local angle = (2*math.pi) / fireballs
        local velocity = 8

		local DamageData = {
            DamageAmount = 500,
            DamageRadius = 5,
            DamageType = 'Normal',
        }

        local initialAngle = RandomFloat( 0, angle )
        for i = 0, (fireballs-1) do
            local randomAngle = 1.2 * RandomFloat( -angle, angle )
            local X = math.sin( (i * angle) + initialAngle + randomAngle )
            local Z = math.cos( (i * angle) + initialAngle + randomAngle )
            local Y = RandomFloat( 1, 3)
            local proj =  self:CreateProjectile( projBp, 0, 0, 0, X, Y, Z)
            proj:SetVelocity( X * velocity, Y * velocity, Z * velocity )
            proj:SetVelocity( velocity * RandomFloat(0.75, 1.25) )
            proj:SetBallisticAcceleration( -2 )
            self.Trash:Add( proj )
            --bag:Add( proj )

            if DamageData.DamageAmount > 0 then
                proj:PassDamageData( DamageData )
            end
        end
    end,
	AftermathFireBalls2 = function(self, bag, lifetime, wreck)
        -- TODO: add more particles, this can be much more dramatic
        -- creates fireballs in the air flying outwards in a nice arc
        local fireballs = Random(10, 20)
        if fireballs < 1 then
            return
        end

        local projBp = '/mods/Commander Survival Kit/projectiles/Asteroid/Asteroids01/Asteroids01_proj.bp'

        local angle = (2*math.pi) / fireballs
        local velocity = 8

		local DamageData = {
            DamageAmount = 1000,
            DamageRadius = 10,
            DamageType = 'Normal',
        }

        local initialAngle = RandomFloat( 0, angle )
        for i = 0, (fireballs-1) do
            local randomAngle = 1.2 * RandomFloat( -angle, angle )
            local X = math.sin( (i * angle) + initialAngle + randomAngle )
            local Z = math.cos( (i * angle) + initialAngle + randomAngle )
            local Y = RandomFloat( 1, 3)
            local proj =  self:CreateProjectile( projBp, 0, 0, 0, X, Y, Z)
            proj:SetVelocity( X * velocity, Y * velocity, Z * velocity )
            proj:SetVelocity( velocity * RandomFloat(0.75, 1.25) )
            proj:SetBallisticAcceleration( -2 )
            self.Trash:Add( proj )
            --bag:Add( proj )

            if DamageData.DamageAmount > 0 then
                proj:PassDamageData( DamageData )
            end
        end
    end,
}

TypeClass = KillerAsteroidImpactEffectController01

