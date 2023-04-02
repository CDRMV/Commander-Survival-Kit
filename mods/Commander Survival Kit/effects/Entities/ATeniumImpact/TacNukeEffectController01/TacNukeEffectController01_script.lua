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
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupporteffects.lua')
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
	# This Version Check needs to be added to make it FAF compatible
	local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

    # Create thread that spawns and controls effects
        self:ForkThread(self.EffectThread)
    end,    

    EffectThread = function(self)
        local army = self:GetArmy()
        local position = self:GetPosition()

        # Create full-screen glow flash
        CreateLightParticle(self, -1, army, 10, 4, 'glow_02', 'ramp_green_02')
        CreateLightParticle(self, -1, army, 10, 15, 'glow_03', 'ramp_green_01')

        # Create initial fireball dome effect
        --self:CreateInitialFireballSmokeRing()
        self:ForkThread(self.CreateOuterRingWaveSmokeRing)
		self:ForkThread(self.CreateOuterRingWaveSmokeRing2)
				self:ForkThread(self.CreateOuterRingWaveSmokeRing3)
        # Create projectile that controls plume effects
       
        
        WaitSeconds( 0.2 )
        
        # Create ground decals
        local orientation = RandomFloat(0,2*math.pi)
        CreateDecal(position, orientation, 'crater01_albedo', '', 'Albedo', 70, 70, 1200, 0, army)  
        self:CreateGroundPlumeConvectionEffects(army)
        
    end,
        
    CreateInitialFireballSmokeRing = function(self)
        local sides = 12
        local angle = (2*math.pi) / sides
        local velocity = 5
        local OffsetMod = 0.5   

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            self:CreateProjectile('/mods/Commander Survival Kit/effects/Entities/ATeniumImpact/TacNukeShockwave01/TacNukeShockwave01_proj.bp', X * OffsetMod , 1.5, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity):SetAcceleration(-0.5)
        end   
    end,  
    
    CreateOuterRingWaveSmokeRing = function(self)
        local sides = 32
        local angle = (2*math.pi) / sides
        local velocity = 7
        local OffsetMod = 0.5
        local projectiles = {}

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            local proj =  self:CreateProjectile('/mods/Commander Survival Kit/effects/Entities/ATeniumImpact/TacNukeShockwave02/TacNukeShockwave02_proj.bp', X * OffsetMod , 2.5, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity)
            table.insert( projectiles, proj )
        end  
        
        WaitSeconds( 3 )

        # Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetAcceleration(-1.5)
        end         
    end,    
    
	CreateOuterRingWaveSmokeRing2 = function(self)
        local sides = 32
        local angle = (2*math.pi) / sides
        local velocity = 7
        local OffsetMod = 0.5
        local projectiles = {}

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            local proj =  self:CreateProjectile('/mods/Commander Survival Kit/effects/Entities/ATeniumImpact/TacNukeShockwave03/TacNukeShockwave03_proj.bp', X * OffsetMod , 2.5, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity)
            table.insert( projectiles, proj )
        end  
        
        WaitSeconds( 3 )

        # Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetAcceleration(-2.5)
        end         
    end, 

	CreateOuterRingWaveSmokeRing3 = function(self)
        local sides = 32
        local angle = (2*math.pi) / sides
        local velocity = 7
        local OffsetMod = 0.5
        local projectiles = {}

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            local proj =  self:CreateProjectile('/mods/Commander Survival Kit/effects/Entities/ATeniumImpact/TacNukeShockwave03/TacNukeShockwave03_proj.bp', X * OffsetMod , 1.5, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity)
            table.insert( projectiles, proj )
        end  
        
        WaitSeconds( 3 )

        # Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetAcceleration(-0.5)
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
            local proj = self:CreateProjectile('/mods/Commander Survival Kit/effects/Entities/ATeniumImpact/TacNukeEffect03/TacNukeEffect03_proj.bp', x, HeightOffset, z, x, 0, z)
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
		for k, v in ModEffectTemplate.ATeniumImpact01 do
			CreateEmitterAtEntity(self, army, v ):ScaleEmitter(0.8)
		end
    end,
}

TypeClass = TacNukeEffectController01

