#
# Terran Artillery Projectile
#
local ModEffectTemplate = import('/mods/Commander Survival Kit Units/lua/CSKUnitsEffects.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TArtilleryProjectile = import('/lua/terranprojectiles.lua').TArtilleryProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

TIFNarpalmMotherShell01 = Class(TArtilleryProjectile) {
 OnImpact = function(self, TargetType, TargetEntity) 
        
        local FxFragEffect = EffectTemplate.TFragmentationSensorShellFrag 
        local ChildProjectileBP = '/Mods/Commander Survival Kit Units/projectiles/TIFNapalmShell01/TIFNapalmShell01_proj.bp'  
              
        
        # Split effects
        for k, v in FxFragEffect do
            CreateEmitterAtEntity( self, self:GetArmy(), v )
        end
        
        local vx, vy, vz = self:GetVelocity()
        local velocity = 20
    
		# One initial projectile following same directional path as the original
        self:CreateChildProjectile(ChildProjectileBP):SetVelocity(vx, vy, vz):SetVelocity(velocity):PassDamageData(self.DamageData)
   		
		# Create several other projectiles in a dispersal pattern
        local numProjectiles = 6
        local angle = (2*math.pi) / numProjectiles
        local angleInitial = RandomFloat( 0, angle )
        
        # Randomization of the spread
        local angleVariation = angle * 0.35 # Adjusts angle variance spread
        local spreadMul = 0.5 # Adjusts the width of the dispersal        
        
        local xVec = 0 
        local yVec = vy
        local zVec = 0

        # Launch projectiles at semi-random angles away from split location
        for i = 0, (numProjectiles -1) do
            xVec = vx + (math.sin(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul
            zVec = vz + (math.cos(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul 
            local proj = self:CreateChildProjectile(ChildProjectileBP)
            proj:SetVelocity(xVec,yVec,zVec)
            proj:SetVelocity(velocity)
            proj:PassDamageData(self.DamageData)                        
        end
        self:Destroy()
    end,
}

TypeClass = TIFNarpalmMotherShell01

