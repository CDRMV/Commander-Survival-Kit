#
# Terran CDR Nuke
#
local CLOATacticalMissileProjectile = import('/lua/sim/defaultprojectiles.lua').SingleBeamProjectile

CybranTacBalisticMissile = Class(CLOATacticalMissileProjectile) {
    BeamName = '/mods/Commander Survival Kit Units/effects/emitters/empty_exhaust_beam_emit.bp',
	LaunchEffects = {
'/mods/Commander Survival Kit Units/effects/emitters/ctbm_trail_04_emit.bp',
                     '/mods/Commander Survival Kit Units/effects/emitters/ctbm_trail_06_emit.bp',
    },
    ThrustEffects = {'/mods/Commander Survival Kit Units/effects/emitters/ctbm_trail_04_emit.bp',
                     '/mods/Commander Survival Kit Units/effects/emitters/ctbm_trail_06_emit.bp',
    },

    ThrustFireEffect = {
					 '/mods/Commander Survival Kit Units/effects/emitters/ctbm_trail_01_emit.bp',
					 '/mods/Commander Survival Kit Units/effects/emitters/ctbm_trail_01_emit.bp',
    },
	
    OnCreate = function(self)
        CLOATacticalMissileProjectile.OnCreate(self)
		if self and not self.Dead then
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
	local position = self:GetPosition()
	self.unit = CreateUnitHPR('SRL0200Missile', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
	self.unit:AttachBoneTo('Missile', self, 'Missile')
	SetIgnoreArmyUnitCap(self:GetArmy(), false)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2.0)
        self.MovementTurnLevel = 1
        self:ForkThread( self.MovementThread )
		end
    end,
    
    OnImpact = function(self, TargetType, TargetEntity)
        if not TargetEntity or not EntityCategoryContains(categories.PROJECTILE, TargetEntity) then
            # Play the explosion sound
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Explosion then
                self:PlaySound(myBlueprint.Audio.Explosion)
            end
			nukeProjectile = self:CreateProjectile('/mods/Commander Survival Kit Units/effects/Entities/Cybran/TacNukeEffectController01/TacNukeEffectController01_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
            nukeProjectile:PassData(self.Data)
			if self.unit then
			self.unit:Destroy()
			end
        end
        CLOATacticalMissileProjectile.OnImpact(self, TargetType, TargetEntity)
    end,    

    MovementThread = function(self)
		WaitSeconds(0.3)
		self.unit:ShowBone(0,true)
        local army = self:GetArmy()
        local launcher = self:GetLauncher()
		self:TrackTarget(false)
		self.CreateEffects( self, self.LaunchEffects, army, 0.5 )
		self.CreateEffects( self, self.ThrustEffects, army, 2 )
		self.CreateFireEffects( self, self.ThrustFireEffect, army, 1.0, 3 )
        WaitSeconds(0.5)		# Height
        self:SetCollision(true)
        WaitSeconds(0.6)
        self:TrackTarget(true) # Turn ~90 degrees towards target
        self:SetDestroyOnWater(true)
        self:SetTurnRate(47.36)
        WaitSeconds(2) 					# Now set turn rate to zero so nuke flies straight
        self:SetTurnRate(0)
        self:SetAcceleration(0.001)
        self.WaitTime = 0.5
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitSeconds(self.WaitTime)
        end
    end,
	
	CreateEffects = function( self, EffectTable, army, scale)
        for k, v in EffectTable do
            self.Trash:Add(CreateAttachedEmitter(self, -1, army, v):ScaleEmitter(scale):OffsetEmitter(0, 0, -2))
        end
    end,
	
	CreateFireEffects = function( self, EffectTable, army, scale, Length)
        for k, v in EffectTable do
            self.Trash:Add(CreateAttachedEmitter(self, -1, army, v):ScaleEmitter(scale):OffsetEmitter(0, 0, -2):SetEmitterCurveParam('LIFETIME_CURVE', 10, 1))
        end
    end,

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        #Get the nuke as close to 90 deg as possible
        if dist > 100 then        
            #Freeze the turn rate as to prevent steep angles at long distance targets
            self:SetTurnRate(0)
        elseif dist > 55 and dist <= 150 then
						# Increase check intervals
            self.WaitTime = 0.3
        elseif dist > 22 and dist <= 75 then
						# Further increase check intervals
            self.WaitTime = 0.1
        elseif dist < 22 then
						# Turn the missile down
            self:SetTurnRate(50)
        end
    end,       

    GetDistanceToTarget = function(self)
        local tpos = self:GetCurrentTargetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,
    
    OnEnterWater = function(self)
        CLOATacticalMissileProjectile.OnEnterWater(self)
        self:SetDestroyOnWater(true)
    end,    
}
TypeClass = CybranTacBalisticMissile

