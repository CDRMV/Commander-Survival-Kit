#****************************************************************************
#**
#**  File     :  /data/projectiles/SBOOtheTacticalBomb01/SBOOtheTacticalBomb01_script.lua
#**  Author(s):  Gordon Duclos, Aaron Lundquist
#**
#**  Summary  :  Othe Tactical Bomb script, XSA0103
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local DefaultExplosion = import('/lua/defaultexplosions.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local SBOAAntheProjectile = import('/mods/Commander Survival Kit/lua/FireSupportProjectiles.lua').SBOAAntheProjectile
SBOAAnthe01 = Class(SBOAAntheProjectile) {

    OnImpact = function(self, TargetType, TargetEntity)   
        CreateLightParticle(self, -1, self:GetArmy(), 26, 5, 'sparkle_white_add_08', 'ramp_white_24' )
        
        # One initial projectile following same directional path as the original
        self:CreateProjectile('/effects/entities/SBOZhanaseeBombEffect01/SBOZhanaseeBombEffect01_proj.bp', 0, 0, 0, 0, 10.0, 0):SetCollision(false):SetVelocity(0,10.0, 0)
        self:CreateProjectile('/effects/entities/SBOZhanaseeBombEffect02/SBOZhanaseeBombEffect02_proj.bp', 0, 0, 0, 0, 0.05, 0):SetCollision(false):SetVelocity(0,0.05, 0)
        
        if TargetType == 'Terrain' then
            ### WaitSeconds(5.0)
            ### Create our decals for like nine seconds that way there will be no problem when it comes to bombs dropping all the time.
            local pos = self:GetPosition()
            DamageArea( self, pos, self.DamageData.DamageRadius, 1, 'Force', true )
            DamageArea( self, pos, self.DamageData.DamageRadius, 1, 'Force', true )              
            CreateDecal( pos, RandomFloat(0.0,6.28), 'Scorch_012_albedo', '', 'Albedo', 40, 40, 300, 200, self:GetArmy())          
        end
        
		SBOAAntheProjectile.OnImpact(self, TargetType, TargetEntity) 
        
    end,

}
TypeClass = SBOAAnthe01