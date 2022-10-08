#****************************************************************************
#**
#**  File     :  /mods/Blackopsexunits/effects/Entities/EXBillyEffectController01/EXBillyEffectController01_script.lua
#**  Author(s):  Gordon Duclos
#**
#**  Summary  :  Nuclear explosion script
#**
#**  Copyright © 2005,2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local NullShell = import('/lua/sim/defaultprojectiles.lua').NullShell
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/Reinforcement Manager/lua/FireSupporteffects.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

TacNukeEffectController01 = Class(NullShell) {
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
            DamageArea(self:GetLauncher(), myPos, self.NukeOuterRingRadius, self.NukeOuterRingDamage, 'Normal', true, true)
        else
            local ringWidth = ( self.NukeOuterRingRadius / self.NukeOuterRingTicks )
            local tickLength = ( self.NukeOuterRingTotalTime / self.NukeOuterRingTicks )
            # Since we're not allowed to have an inner radius of 0 in the DamageRing function,
            # I'm manually executing the first tick of damage with a DamageArea function.
            DamageArea(self:GetLauncher(), myPos, ringWidth, self.NukeOuterRingDamage, 'Normal', true, true)
            WaitSeconds(tickLength)
            for i = 2, self.NukeOuterRingTicks do
                #print('Damage Ring: MaxRadius:' .. 2*i)
                DamageRing(self:GetLauncher(), myPos, ringWidth * (i - 1), ringWidth * i, self.NukeOuterRingDamage, 'Normal', true, true)
                WaitSeconds(tickLength)
            end
        end
    end,

    InnerRingDamage = function(self)
        local myPos = self:GetPosition()
        if self.NukeInnerRingTotalTime == 0 then
            DamageArea(self:GetLauncher(), myPos, self.NukeInnerRingRadius, self.NukeInnerRingDamage, 'Normal', true, true)
        else
            local ringWidth = ( self.NukeInnerRingRadius / self.NukeInnerRingTicks )
            local tickLength = ( self.NukeInnerRingTotalTime / self.NukeInnerRingTicks )
            # Since we're not allowed to have an inner radius of 0 in the DamageRing function,
            # I'm manually executing the first tick of damage with a DamageArea function.
            DamageArea(self:GetLauncher(), myPos, ringWidth, self.NukeInnerRingDamage, 'Normal', true, true)
            WaitSeconds(tickLength)
            for i = 2, self.NukeInnerRingTicks do
                #LOG('Damage Ring: MaxRadius:' .. ringWidth * i)
                DamageRing(self:GetLauncher(), myPos, ringWidth * (i - 1), ringWidth * i, self.NukeInnerRingDamage, 'Normal', true, true)
                WaitSeconds(tickLength)
            end
        end
    end,

    EffectThread = function(self)
        local army = self:GetArmy()
        local position = self:GetPosition()

        # Create full-screen glow flash
        CreateLightParticle(self, -1, army, 10, 4, 'glow_02', 'ramp_red_02')
        CreateLightParticle(self, -1, army, 10, 15, 'glow_03', 'ramp_fire_06')

        # Create initial fireball dome effect
        local FireballDomeYOffset = -0.5
        self:CreateProjectile('/mods/Reinforcement Manager/effects/Entities/Cybran/TacNukeEffect01/TacNukeEffect01_proj.bp',0,FireballDomeYOffset,0,0,0,1)
        
        # Create projectile that controls plume effects
        local PlumeEffectYOffset = -0.25
        self:CreateProjectile('/mods/Reinforcement Manager/effects/Entities/Cybran/TacNukeEffect02/TacNukeEffect02_proj.bp',0,PlumeEffectYOffset,0,0,0,1)        
        
        
        for k, v in ModEffectTemplate.TCNukeRings01 do
			CreateEmitterAtEntity(self, army, v ):ScaleEmitter(0.125)
        end
        
        self:ForkThread(self.CreateHeadConvectionSpinners)
        
        WaitSeconds( 0.2 )
        
        # Create ground decals
        local orientation = RandomFloat(0,2*math.pi)
        CreateDecal(position, orientation, 'nuke_scorch_001_albedo', '', 'Albedo', 12, 12, 1200, 0, army)  
		for k, v in ModEffectTemplate.TCNukeRings01 do
			CreateEmitterAtEntity(self, army, v ):ScaleEmitter(0.125)
        end
        self:CreateGroundPlumeConvectionEffects(army)
        
    end,
        
    CreateInitialFireballSmokeRing = function(self)
        local sides = 12
        local angle = (2*math.pi) / sides
        local velocity = 1
        local OffsetMod = 0.25      

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            self:CreateProjectile('/mods/Reinforcement Manager/effects/Entities/Cybran/TacNukeShockwave01/TacNukeShockwave01_proj.bp', X * OffsetMod , 0.25, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity):SetAcceleration(-0.25)-- Exavier Modified Acceleration
        end   
    end,  
    
    CreateOuterRingWaveSmokeRing = function(self)
        local sides = 32
        local angle = (2*math.pi) / sides
        local velocity = 1.25
        local OffsetMod = 0.25
        local projectiles = {}

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            local proj =  self:CreateProjectile('/mods/Reinforcement Manager/effects/Entities/Cybran/TacNukeShockwave02/TacNukeShockwave02_proj.bp', X * OffsetMod , 0.5, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity)
            table.insert( projectiles, proj )
        end  
        
        WaitSeconds( 1 )

        # Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetAcceleration(-0.1)
        end         
    end,      
    
    CreateHeadConvectionSpinners = function(self)
        local sides = 10
        local angle = (2*math.pi) / sides
        local HeightOffset = -0.5
        local velocity = 8.75
        local OffsetMod = 0.5
        local projectiles = {}        

        for i = 0, (sides-1) do
            local x = math.sin(i*angle) * OffsetMod
            local z = math.cos(i*angle) * OffsetMod
            local proj = self:CreateProjectile('/mods/Reinforcement Manager/effects/Entities/Cybran/TacNukeEffect03/TacNukeEffect03_proj.bp', x, HeightOffset, z, x, 0, z)
                :SetVelocity(velocity)
            table.insert(projectiles, proj)
        end   
    
		WaitSeconds(0.2)
        for i = 0, (sides-1) do
            local x = math.sin(i*angle)
            local z = math.cos(i*angle)
            local proj = projectiles[i+1]
			proj:SetVelocityAlign(false)
			proj:SetOrientation(OrientFromDir(Util.Cross( Vector(x,0,z), Vector(0,1,0))),true)
			proj:SetVelocity(0,0.75,0)
			proj:SetBallisticAcceleration(-0.04)           
        end   
    end,
    
    CreateGroundPlumeConvectionEffects = function(self,army)
		for k, v in ModEffectTemplate.TCNukeGroundConvectionEffects01 do
			CreateEmitterAtEntity(self, army, v ):ScaleEmitter(0.25)
		end
		
		for k, v in ModEffectTemplate.TCNukeRings01 do
			CreateEmitterAtEntity(self, army, v ):ScaleEmitter(0.125)
        end
    
		local sides = 10
		local angle = (2*math.pi) / sides
		local inner_lower_limit = 0.5
        local outer_lower_limit = 0.5
        local outer_upper_limit = 0.75
    
		local inner_lower_height = 0
		local inner_upper_height = 1
		local outer_lower_height = 0
		local outer_upper_height = 1
      
		sides = 8
		angle = (2*math.pi) / sides
		for i = 0, (sides-1)
			do
			local magnitude = RandomFloat(outer_lower_limit, outer_upper_limit)
			local x = math.sin(i*angle+RandomFloat(-angle/2, angle/4)) * magnitude
			local z = math.cos(i*angle+RandomFloat(-angle/2, angle/4)) * magnitude
			local velocity = RandomFloat( 1, 3 ) * 0.5
			self:CreateProjectile('/mods/Reinforcement Manager/effects/Entities/Cybran/TacNukeEffect05/TacNukeEffect05_proj.bp', x, RandomFloat(outer_lower_height, outer_upper_height), z, x, 0, z)
				:SetVelocity(x * velocity, 0, z * velocity)
		end 
		for k, v in ModEffectTemplate.TCNukeRings01 do
			CreateEmitterAtEntity(self, army, v ):ScaleEmitter(0.125)
        end
    end,
}

TypeClass = TacNukeEffectController01

