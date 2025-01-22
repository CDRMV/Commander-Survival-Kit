#
# Terran Gauss Cannon Projectile
#
local TDFGaussCannonProjectile = import('/lua/terranprojectiles.lua').TDFGaussCannonProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
TDFHellfireMissile02 = Class(TDFGaussCannonProjectile) {

    FxImpactUnit = EffectTemplate.TMissileHit01,
    FxImpactLand = EffectTemplate.TMissileHit01,
    FxImpactProp = EffectTemplate.TMissileHit01,
    FxImpactUnderWater = {},
    PolyTrails = nil,
    PolyTrailOffset = {0,0},
	FxAirUnitHitScale = 1,
    FxLandHitScale = 1,
    FxNoneHitScale = 1,
    FxPropHitScale = 1,
    FxProjectileHitScale = 1,
    FxProjectileUnderWaterHitScale = 1,
    FxShieldHitScale = 1,
    FxUnderWaterHitScale = 1,
    FxUnitHitScale = 1,
    FxWaterHitScale = 1,
    FxOnKilledScale = 1,
    BeamName = '/mods/Commander Survival Kit Units/effects/emitters/aeromissile_exhaust_fire_beam_01_emit.bp',
    FxTrails = EffectTemplate.TMissileExhaust03,
	FxTrailScale = 0.5,
    
	
	OnCreate = function(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 5)
        TDFGaussCannonProjectile.OnCreate(self)

        -- Delay the range calculation by 1 tick
        self:ForkThread(function()
            -- Retrieve the current target position
            while true do
            local targetPos = self:GetCurrentTargetPosition()
            if not targetPos then
                return
            end

            -- Get initial position of the projectile
            local projPos = self:GetPosition()

            -- Calculate distance to target position

        local distance = VDist2(projPos[1], projPos[3], targetPos[1], targetPos[3])

            
        if distance < 5 then
		local FxFragEffect = EffectTemplate.TFragmentationSensorShellFrag 
        local ChildProjectileBP = '/projectiles/TIFArtillery01/TIFArtillery01_proj.bp'  
              
        
        # Split effects
        for k, v in FxFragEffect do
            CreateEmitterAtEntity( self, self:GetArmy(), v )
        end
        
        local vx, vy, vz = 0 , 0, 0
        local velocity = 2
    
		# One initial projectile following same directional path as the original
        self:CreateChildProjectile(ChildProjectileBP):SetVelocity(0, 0, 0):SetVelocity(velocity):PassDamageData(self.DamageData)
   		
		# Create several other projectiles in a dispersal pattern
        local numProjectiles = 4
        local angle = (2*math.pi) / numProjectiles
        local angleInitial = RandomFloat( 0, angle )
        
        # Randomization of the spread
        local angleVariation = angle * 0.35 # Adjusts angle variance spread
        local spreadMul = 0.5 # Adjusts the width of the dispersal        
        
        local xVec = 0 
        local yVec = 0
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
        end

         WaitSeconds(0.1)
         end
        end)
    end,
    
}
TypeClass = TDFHellfireMissile02

