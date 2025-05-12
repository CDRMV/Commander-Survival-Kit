

local NullShell = import("/lua/sim/defaultprojectiles.lua").NullShell
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

BlastEffect01 = Class(NullShell) {

	OnCreate = function(self)
		NullShell.OnCreate(self)
		
		self:ForkThread(self.EffectThread)
	end,

	
	EffectThread = function(self)
        local army = self:GetArmy()
        local position = self:GetPosition()

        # Create full-screen glow flash

        
		
        # Create projectile that controls plume effects
        local PlumeEffectYOffset = -0.02
        self:CreateProjectile('/mods/Commander Survival Kit Units/effects/entities/BlastEffect01/Blu3000Effect02/Blu3000Effect02_proj.bp',0,PlumeEffectYOffset,0,0,0,1)        
        
        self:ForkThread(self.CreateHeadConvectionSpinners)
        --self:ForkThread(self.CreateFlavorPlumes) 
       
      
        local scale = 1
		local shockwavescale = 0
		local number = 0
		while true do
		if number == 10 then
		self:Destroy()
		else
		local scaleChange = 20 * scale
		shockwavescale = shockwavescale + 1
		DamageRing(self, position, 0.01, shockwavescale, 10, 'Nuke', true, true)
		DamageRing(self, position, 0.01, shockwavescale, 1, 'Force', true, true)
		self:SetScaleVelocity(scaleChange, scaleChange, scaleChange)
		number = number +1
		end
		WaitSeconds(0.1)
		end


        WaitSeconds(8.9)
        self:CreateGroundPlumeConvectionEffects(army)
        
    end,
        
    CreateInitialFireballSmokeRing = function(self)
        local sides = 12
        local angle = (2*math.pi) / sides
        local velocity = 1
        local OffsetMod = 4       

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            self:CreateProjectile('/mods/Commander Survival Kit Units/effects/entities/Blu3000/Blu3000EffectShockwave01/Blu3000EffectShockwave01_proj.bp', X * OffsetMod , 0.1, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity):SetAcceleration(-0.1)
        end   
    end,  
    
    CreateOuterRingWaveSmokeRing = function(self)
        local sides = 32
        local angle = (2*math.pi) / sides
        local velocity = 0.3
        local OffsetMod = 4
        local projectiles = {}

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            local proj =  self:CreateProjectile('/mods/Commander Survival Kit Units/effects/entities/Blu3000/Blu3000EffectShockwave02/Blu3000EffectShockwave02_proj.bp', X * OffsetMod , 0.1, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity)
            table.insert( projectiles, proj )
        end  
        
        WaitSeconds( 3 )

        # Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetAcceleration(-0.05)
        end         
    end,      
    
    CreateFlavorPlumes = function(self)
        local numProjectiles = 8
        local angle = (2*math.pi) / numProjectiles
        local angleInitial = RandomFloat( 0, angle )
        local angleVariation = angle * 0.35
        local projectiles = {}

        local xVec = 0 
        local yVec = 0
        local zVec = 0
        local velocity = 0

        # yVec -0.1, requires 2 initial velocity to start
        # yVec 0.1, requires 3 initial velocity to start
        # yVec 1.0, requires 8.5 initial velocity to start

        # Launch projectiles at semi-random angles away from the sphere, with enough
        # initial velocity to escape sphere core
        for i = 0, (numProjectiles -1) do
            xVec = math.sin(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))
            yVec = RandomFloat(0.2, 1)
            zVec = math.cos(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation)) 
            velocity = 0.1 + (yVec * RandomFloat(2,5))
            table.insert(projectiles, self:CreateProjectile('/mods/Commander Survival Kit Units/effects/entities/BlastEffect01/Blu3000EffectFlavorPlume01/Blu3000EffectFlavorPlume01_proj.bp', 0, 0, 0, xVec, yVec, zVec):SetVelocity(velocity) )
        end

        WaitSeconds( 3 )

        # Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetVelocity(0.015):SetBallisticAcceleration(-0.05):ScaleEmitter(0.1) 
        end
    end,
    
    CreateHeadConvectionSpinners = function(self)
        local sides = 10
        local angle = (2*math.pi) / sides
        local HeightOffset = -0.05
        local velocity = 0.05
        local OffsetMod = 0.5
        local projectiles = {}        

        for i = 0, (sides-1) do
            local x = math.sin(i*angle) * OffsetMod
            local z = math.cos(i*angle) * OffsetMod
            local proj = self:CreateProjectile('/mods/Commander Survival Kit Units/effects/entities/BlastEffect01/Blu3000Effect03/Blu3000Effect03_proj.bp', x, HeightOffset, z, x, 0, z)
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
      proj:SetVelocity(0,0.5,0) 
          proj:SetBallisticAcceleration(-0.05)            
        end   
    end,
    
    CreateGroundPlumeConvectionEffects = function(self,army)
    for k, v in EffectTemplate.TNukeGroundConvectionEffects01 do
          CreateEmitterAtEntity(self, army, v ):ScaleEmitter(0.1)  
    end
    
    local sides = 10
    local angle = (2*math.pi) / sides
    local inner_lower_limit = 1
        local outer_lower_limit = 1
        local outer_upper_limit = 1
    
    local inner_lower_height = 1
    local inner_upper_height = 2
    local outer_lower_height = 1
    local outer_upper_height = 1
      
    sides = 8
    angle = (2*math.pi) / sides
    for i = 0, (sides-1)
    do
        local magnitude = RandomFloat(outer_lower_limit, outer_upper_limit)
        local x = math.sin(i*angle+RandomFloat(-angle/1, angle/2)) * magnitude
        local z = math.cos(i*angle+RandomFloat(-angle/1, angle/2)) * magnitude
        local velocity = RandomFloat( 1, 0.1 ) * 0.1
        self:CreateProjectile('/mods/Commander Survival Kit Units/effects/entities/BlastEffect01/Blu3000Effect05/Blu3000Effect05_proj.bp', x, RandomFloat(outer_lower_height, outer_upper_height), z, x, 0, z)
            :SetVelocity(x * velocity, 0, z * velocity)
    end 
    end,
}
TypeClass = BlastEffect01