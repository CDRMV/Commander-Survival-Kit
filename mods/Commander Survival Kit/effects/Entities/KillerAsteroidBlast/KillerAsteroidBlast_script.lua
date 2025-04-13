#****************************************************************************
#**
#**  File     :  /effects/Entities/SCUDeath01/SCUDeath01_script.lua
#**  Author(s):  Gordon Duclos
#**
#**  Summary  :  SCU Death Explosion
#**
#**  Copyright © 2005,2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local NullShell = import('/lua/sim/defaultprojectiles.lua').NullShell
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

KillerAsteroidBlast = Class(NullShell) {

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
        local position = self:GetPosition()

		# Knockdown force rings
        DamageRing(self, position, 0.1, 45, 1, 'Force', true)
        WaitSeconds(0.1)
        DamageRing(self, position, 0.1, 45, 1, 'Force', true)
    end,
       
}

TypeClass = KillerAsteroidBlast

