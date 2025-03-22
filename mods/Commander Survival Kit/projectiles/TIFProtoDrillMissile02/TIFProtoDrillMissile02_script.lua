#
# Terran Nuke Missile
#
local TIFMissileNuke = import('/lua/terranprojectiles.lua').TMissileCruiseProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local ModEffectTemplate = '/mods/Commander Survival Kit/lua/FireSupportEffects.lua'

TIFProtoDrillMissile02 = Class(TIFMissileNuke) {

	FxImpactLand = ModEffectTemplate.TDrillMissileImpact01,
	FxLandHitScale = 1.65,

    InitialEffects = {'/effects/emitters/nuke_munition_launch_trail_02_emit.bp',},
    LaunchEffects = {
        '/effects/emitters/nuke_munition_launch_trail_03_emit.bp',
        '/effects/emitters/nuke_munition_launch_trail_05_emit.bp',
        '/effects/emitters/nuke_munition_launch_trail_07_emit.bp',
    },
    ThrustEffects = {'/effects/emitters/nuke_munition_launch_trail_04_emit.bp',
                     '/effects/emitters/nuke_munition_launch_trail_06_emit.bp',
    },
    
    OnImpact = function(self, TargetType, TargetEntity)
        if not TargetEntity or not EntityCategoryContains(categories.PROJECTILE, TargetEntity) then
            # Play the explosion sound
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Explosion then
                self:PlaySound(myBlueprint.Audio.Explosion)
            end
		local rotation = RandomFloat(0,2*math.pi)
		local size = RandomFloat(5.75,5.0)
		CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())   	
		local location = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local ShieldUnit =CreateUnitHPR('UTX0401', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
        end
        TIFMissileNuke.OnImpact(self, TargetType, TargetEntity)
    end,

    DoTakeDamage = function(self, instigator, amount, vector, damageType)
        if self.ProjectileDamaged then
            for k,v in self.ProjectileDamaged do
                v(self)
            end
        end
        TIFMissileNuke.DoTakeDamage(self, instigator, amount, vector, damageType)
    end,

    OnCreate = function(self)
        TIFMissileNuke.OnCreate(self)
        local launcher = self:GetLauncher()
        if launcher and not launcher:IsDead() and launcher.EventCallbacks.ProjectileDamaged then
            self.ProjectileDamaged = {}
            for k,v in launcher.EventCallbacks.ProjectileDamaged do
                table.insert( self.ProjectileDamaged, v )
            end
        end
        self:SetCollisionShape('Sphere', 0, 0, 0, 2.0)
        self:ForkThread( self.MovementThread )
    end,

    CreateEffects = function( self, EffectTable, army, scale)
        for k, v in EffectTable do
            self.Trash:Add(CreateAttachedEmitter(self, -1, army, v):ScaleEmitter(scale))
        end
    end,

    MovementThread = function(self)
        local army = self:GetArmy()
        local launcher = self:GetLauncher()
        self.CreateEffects( self, self.InitialEffects, army, 1 )
        self:TrackTarget(false)
        WaitSeconds(2.5)		# Height
        self:SetCollision(true)
        self.CreateEffects( self, self.LaunchEffects, army, 1 )
        WaitSeconds(2.5)
        self.CreateEffects( self, self.ThrustEffects, army, 3 )
        WaitSeconds(2.5)
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

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        #Get the nuke as close to 90 deg as possible
        if dist > 150 then        
            #Freeze the turn rate as to prevent steep angles at long distance targets
            self:SetTurnRate(0)
        elseif dist > 75 and dist <= 150 then
						# Increase check intervals
            self.WaitTime = 0.3
        elseif dist > 32 and dist <= 75 then
						# Further increase check intervals
            self.WaitTime = 0.1
        elseif dist < 32 then
						# Turn the missile down
            self:SetTurnRate(50)
        end
    end,
    
    CheckMinimumSpeed = function(self, minSpeed)
        if self:GetCurrentSpeed() < minSpeed then
            return false
        end
        return true
    end,
    
    SetMinimumSpeed = function(self, minSpeed, resetAcceleration)
        if self:GetCurrentSpeed() < minSpeed then
            self:SetVelocity(minSpeed)
            if resetAcceleration then
                self:SetAcceleration(0)
            end
        end
    end,

    GetDistanceToTarget = function(self)
        local tpos = self:GetCurrentTargetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,
}

TypeClass = TIFProtoDrillMissile02
