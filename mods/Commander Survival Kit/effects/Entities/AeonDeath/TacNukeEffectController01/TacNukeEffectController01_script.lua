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
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

TacNukeEffectController01 = Class(NullShell) {
    

    OnCreate = function(self)
	    NullShell.OnCreate(self)
        local myBlueprint = self:GetBlueprint()
            
        # Play the "NukeExplosion" sound
        if myBlueprint.Audio.NukeExplosion then
            self:PlaySound(myBlueprint.Audio.NukeExplosion)
        end
    

    # Create thread that spawns and controls effects
        self:ForkThread(self.EffectThread)
    end, 

	PassDamageData = function(self, damageData)
        NullShell.PassDamageData(self, damageData)
        local instigator = self:GetLauncher()
        if instigator == nil then
            instigator = self
        end

        # Do Damage
        self:DoDamage( instigator, self.DamageData, nil )  
    end,
    
    OnImpact = function(self, targetType, targetEntity)
        self:Destroy()
    end,


    EffectThread = function(self)
        local army = self:GetArmy()
        local position = self:GetPosition()

        # Create full-screen glow flash
        CreateLightParticle(self, -1, army, 10, 4, 'glow_02', 'ramp_blue_02')
        CreateLightParticle(self, -1, army, 10, 15, 'glow_03', 'ramp_white_01')

        # Create initial fireball dome effect
        
        # Create projectile that controls plume effects
        local PlumeEffectYOffset = -0.25
        self:CreateProjectile('/mods/Commander Survival Kit/effects/Entities/AeonDeath/TacNukeEffect02/TacNukeEffect02_proj.bp',0,PlumeEffectYOffset,0,0,0,0)        
        
        
        for k, v in ModEffectTemplate.ANukeRings02 do
			CreateEmitterAtEntity(self, army, v ):ScaleEmitter(0.065)
        end
        
        self:CreateInitialFireballSmokeRing()
        self:ForkThread(self.CreateHeadConvectionSpinners)
        
        WaitSeconds( 0.2 )
        
        # Create ground decals
        local orientation = RandomFloat(0,2*math.pi)
        CreateDecal(self:GetPosition(), orientation, 'Crater01_albedo', '', 'Albedo', 8, 8, 1200, 0, army)
        CreateDecal(self:GetPosition(), orientation, 'Crater01_normals', '', 'Normals', 8, 8, 1200, 0, army)
        
    end,
        
    CreateInitialFireballSmokeRing = function(self)
	        local army = self:GetArmy()
        for k, v in ModEffectTemplate.ANukeRings01 do
			CreateEmitterAtEntity(self, army, v ):ScaleEmitter(0.125)
        end
    end,  
              
    
    CreateHeadConvectionSpinners = function(self)
        local sides = 10
        local angle = (2*math.pi) / sides
        local HeightOffset = 0
        local velocity = 8.75
        local OffsetMod = 0.5
        local projectiles = {}        

        for i = 0, (sides-1) do
            local x = math.sin(i*angle) * OffsetMod
            local z = math.cos(i*angle) * OffsetMod
            local proj = self:CreateProjectile('/mods/Commander Survival Kit/effects/Entities/AeonDeath/TacNukeEffect03/TacNukeEffect03_proj.bp', x, HeightOffset, z, x, 0, z)
                :SetVelocity(velocity)
            table.insert(projectiles, proj)
        end   
    
		WaitSeconds(0.2)
        for i = 0, (sides-1) do
            local x = math.sin(i*angle)
            local z = math.cos(i*angle)
            local proj = projectiles[i+1]
			proj:SetVelocityAlign(false)
			proj:SetOrientation(OrientFromDir(Util.Cross( Vector(x,0,z), Vector(0,0,0))),true)
			proj:SetVelocity(0,0.75,0)
			proj:SetBallisticAcceleration(-0.04)           
        end   
    end,
    
}

TypeClass = TacNukeEffectController01

