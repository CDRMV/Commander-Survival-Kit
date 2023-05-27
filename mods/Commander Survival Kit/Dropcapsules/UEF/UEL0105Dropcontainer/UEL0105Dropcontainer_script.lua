local DefaultProjectileFile = import("/lua/sim/defaultprojectiles.lua")
local EffectTemplate = import('/lua/EffectTemplates.lua')
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile

UEL0105Dropcontainer = Class(SingleBeamProjectile) {

    DestroyOnImpact = false,
    FxTrails = nil,
    FxTrailOffset = 0,
    BeamName = nil,

    FxImpactUnit = EffectTemplate.TMissileHit01,
    FxImpactLand = EffectTemplate.TMissileHit01,
    FxImpactProp = EffectTemplate.TMissileHit01,
    FxImpactUnderWater = {},

    CreateImpactEffects = function( self, army, EffectTable, EffectScale )
        local emit = nil
        for k, v in EffectTable do
            emit = CreateEmitterAtEntity(self,army,v)
            if emit and EffectScale != 1 then
                emit:ScaleEmitter(EffectScale or 1)
            end
        end
    end,

    OnCreate = function(self)
        SingleBeamProjectile.OnCreate(self)
		self.Effect1 = CreateAttachedEmitter(self,'L_Engine1_Exhaust1',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
		self.Effect2 = CreateAttachedEmitter(self,'L_Engine1_Exhaust2',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
		self.Effect3 = CreateAttachedEmitter(self,'L_Engine2_Exhaust1',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
		self.Effect4 = CreateAttachedEmitter(self,'L_Engine2_Exhaust2',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
		self.Effect5 = CreateAttachedEmitter(self,'R_Engine1_Exhaust1',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
		self.Effect6 = CreateAttachedEmitter(self,'R_Engine1_Exhaust2',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
		self.Effect7 = CreateAttachedEmitter(self,'R_Engine2_Exhaust1',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
		self.Effect8 = CreateAttachedEmitter(self,'R_Engine2_Exhaust2',self:GetArmy(), '/effects/emitters/air_hover_exhaust_01_emit.bp'):ScaleEmitter(0.15)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2)
        self.MoveThread = self:ForkThread(self.MovementThread)
    end,

    MovementThread = function(self)        
        self.WaitTime = 0.1
        self.Distance = self:GetDistanceToTarget()
        self:SetTurnRate(8)
        WaitSeconds(0.3)        
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitSeconds(self.WaitTime)
        end
    end,

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        if dist > self.Distance then
        	self:SetTurnRate(75)
        	WaitSeconds(3)
        	self:SetTurnRate(8)
        	self.Distance = self:GetDistanceToTarget()
        end
        if dist > 50 then        
            #Freeze the turn rate as to prevent steep angles at long distance targets
            WaitSeconds(2)
            self:SetTurnRate(10)
        elseif dist > 30 and dist <= 50 then
						self:SetTurnRate(12)
						WaitSeconds(1.5)
            self:SetTurnRate(12)
        elseif dist > 10 and dist <= 25 then
            WaitSeconds(0.3)
            self:SetTurnRate(50)
				elseif dist > 0 and dist <= 10 then         
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
	
	OnImpact = function(self, TargetType, targetEntity)

		SingleBeamProjectile.OnImpact( self, TargetType, targetEntity )
		local location = self:GetPosition()
		local SurfaceHeight = GetSurfaceHeight(location[1], location[3]) -- Get Water layer
		local TerrainHeight = GetTerrainHeight(location[1], location[3]) -- Get Land Layer
		LOG("Water: ", SurfaceHeight)
		LOG("Land: ", TerrainHeight)
		
		-- Check for preventing Land Reinforcements to be spawned in the Water.
		if SurfaceHeight == TerrainHeight then 
		local ShieldUnit =CreateUnitHPR('DCEL0105', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
		
		else

		end
	end,
}


TypeClass = UEL0105Dropcontainer