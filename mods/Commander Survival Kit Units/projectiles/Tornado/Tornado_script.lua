#
# Terran Nuke Missile
#
local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile
local Explosion = import('/lua/defaultexplosions.lua')
local ModEffectTemplate = import('/mods/Commander Survival Kit Units/lua/CSKUnitsEffects.lua')

Tornado = Class(SingleBeamProjectile) {
	
	FxImpactUnit = ModEffectTemplate.TornadoEffects,
    FxImpactLand = ModEffectTemplate.TornadoEffects,
	FxImpactNone = ModEffectTemplate.TornadoEffects,
    FxImpactProp = ModEffectTemplate.TornadoEffects,
	BeamName = '/mods/Commander Survival Kit Units/effects/emitters/empty_exhaust_beam_emit.bp',
    FxLandHitScale = 1.25,
    FxNoneHitScale = 1.25,
    FxPropHitScale = 1.25,

    FxTrails = {
	'/mods/Commander Survival Kit Units/effects/emitters/tornado01_emit.bp', 
    '/mods/Commander Survival Kit Units/effects/emitters/tornado02_emit.bp',
	},
	
    FxTrailScale = 0.5,
	
	OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()
        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_008_albedo', 6, 6, 250, 200, army )

            local blanketSides = 12
            local blanketAngle = (2*math.pi) / blanketSides
            local blanketStrength = 1
            local blanketVelocity = 2.25

            for i = 0, (blanketSides-1) do
                local blanketX = math.sin(i*blanketAngle)
                local blanketZ = math.cos(i*blanketAngle)
                local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
                    :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            end
        end
        SingleBeamProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
	
    OnCreate = function(self)
        SingleBeamProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2.0)
        self.MovementTurnLevel = 1
        self:ForkThread( self.MovementThread )
    end,
    
    MovementThread = function(self)        
        self.WaitTime = 0.1
        self:SetTurnRate(8)
        WaitSeconds(0.3)        
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitSeconds(self.WaitTime)
        end
    end,

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        #Get the nuke as close to 90 deg as possible
        if dist > 50 then        
            #Freeze the turn rate as to prevent steep angles at long distance targets
            WaitSeconds(2)
            self:SetTurnRate(20)
        elseif dist > 128 and dist <= 213 then
						# Increase check intervals
						self:SetTurnRate(30)
						WaitSeconds(1.5)
            self:SetTurnRate(30)
        elseif dist > 43 and dist <= 107 then
						# Further increase check intervals
            WaitSeconds(0.3)
            self:SetTurnRate(50)
				elseif dist > 0 and dist <= 43 then
						# Further increase check intervals            
            self:SetTurnRate(100)   
            KillThread(self.MoveThread)         
        end
    end,        

    GetDistanceToTarget = function(self)
        local tpos = self:GetCurrentTargetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,
}

TypeClass = Tornado
