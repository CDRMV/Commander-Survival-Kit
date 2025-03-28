#****************************************************************************
#**
#**  File     :  /data/projectiles/CIFBrackmanHackPegs01/CIFBrackmanHackPegs01_script.lua
#**  Author(s):  Greg Kohne
#**
#**  Summary  :  Brackman Hack Peg-Pod
#**
#**  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local EffectTemplate = import('/lua/EffectTemplates.lua')
local CDFProtonCannonProjectile = import('/lua/cybranprojectiles.lua').CDFProtonCannonProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
local TrackingTarget

CIFHackPegs01 = Class(CDFProtonCannonProjectile) {
    
    OnImpact = function(self, TargetType, TargetEntity) 
        local FxFragEffect = EffectTemplate.CBrackmanCrabPegPodSplit01 
        local ChildProjectileBP = '/projectiles/CIFBrackmanHackPegs02/CIFBrackmanHackPegs02_proj.bp'  
              
        ### Play split effects
        for k, v in FxFragEffect do
            CreateEmitterAtEntity( self, self:GetArmy(), v )
        end
        
        local vx, vy, vz = self:GetVelocity()
        local velocity = 18
		# Create several other projectiles in a dispersal pattern
        local numProjectiles = 9
        local angle = (2*math.pi) / numProjectiles
        local angleInitial = RandomFloat( 0, angle )
        # Randomization of the spread
        local angleVariation = 0.0 # Adjusts angle variance spread
        local spreadMul = 0.753 # Adjusts the width of the dispersal        
        
        #vy= -0.3
        
        local xVec = 0
        local zVec = 0
        
                  
               
        # Launch projectiles at semi-random angles away from split location
		for i = 0, (numProjectiles -1) do
            xVec = vx + (math.sin(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul
            zVec = vz + (math.cos(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul 
            local proj = self:CreateProjectile(ChildProjectileBP, 0, 0.0, 0, xVec, -1.0, zVec):SetCollision(true):SetVelocity(velocity)
            proj:SetTargetPosition(self:GetCurrentTargetPosition()) 
        end
		local location = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local ShieldUnit =CreateUnitHPR('URFSSP0400b', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:Destroy()
    end,
	
    

}



TypeClass = CIFHackPegs01
