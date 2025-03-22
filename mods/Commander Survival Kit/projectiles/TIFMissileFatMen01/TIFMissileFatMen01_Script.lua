#
# Terran Land-Based Cruise Missile
#
local TIFMissileNuke = import('/lua/terranprojectiles.lua').TIFMissileNuke
local Explosion = import('/lua/defaultexplosions.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')


local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 
TIFMissileFatMen01 = Class(TIFMissileNuke) {

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
           
			nukeProjectile = self:CreateProjectile('/effects/Entities/UEFNukeEffectController01/UEFNukeEffectController01_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
            nukeProjectile:PassDamageData(self.DamageData)
            nukeProjectile:PassData(self.Data)
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
        self:CreateEffects(self.InitialEffects, self.Army, 1)
        self:SetTurnRate(8)
        WaitTicks(4)
        self:CreateEffects(self.LaunchEffects, self.Army, 1)
        self:CreateEffects(self.ThrustEffects, self.Army, 1)
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitTicks(2)
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
TypeClass = TIFMissileFatMen01
	
else 	

TIFMissileFatMen01 = Class(TIFMissileNuke) {

BeamName = '/effects/emitters/missile_exhaust_fire_beam_06_emit.bp',
    InitialEffects = {'/effects/emitters/nuke_munition_launch_trail_02_emit.bp',},
    LaunchEffects = {
        '/effects/emitters/nuke_munition_launch_trail_03_emit.bp',
        '/effects/emitters/nuke_munition_launch_trail_05_emit.bp',
    },
    ThrustEffects = {'/effects/emitters/nuke_munition_launch_trail_04_emit.bp',},
    OnCreate = function(self)
        TIFMissileNuke.OnCreate(self)
        self.effectEntityPath = '/effects/Entities/UEFNukeEffectController02/UEFNukeEffectController02_proj.bp'
        self:LauncherCallbacks()
    end,

    OnImpact = function(self, TargetType, TargetEntity)
        if EntityCategoryContains(categories.AEON * categories.PROJECTILE * categories.ANTIMISSILE * categories.TECH2, TargetEntity) then
            self:Destroy()
        else
            TIFMissileNuke.OnImpact(self, TargetType, TargetEntity)
        end
    end,

    -- Tactical nuke has different flight path
    MovementThread = function(self)
        self:CreateEffects(self.InitialEffects, self.Army, 1)
        self:SetTurnRate(8)
        WaitTicks(4)
        self:CreateEffects(self.LaunchEffects, self.Army, 1)
        self:CreateEffects(self.ThrustEffects, self.Army, 1)
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitTicks(2)
        end
    end,

    DoDamage = function(self, instigator, DamageData, targetEntity)
        local nukeDamage = function(self, instigator, pos, brain, army, damageType)
            if self.TotalTime == 0 then
                DamageArea(instigator, pos, self.Radius, self.Damage, (damageType or 'Nuke'), true, true)
            end
        end
        self.InnerRing.DoNukeDamage = nukeDamage
        self.OuterRing.DoNukeDamage = nukeDamage
        TIFMissileNuke.DoDamage(self, instigator, DamageData, targetEntity)
    end,

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        if dist > 50 then
            -- Freeze the turn rate as to prevent steep angles at long distance targets
            WaitTicks(21)
            self:SetTurnRate(20)
        elseif dist > 128 and dist <= 213 then
            -- Increase check intervals
            self:SetTurnRate(30)
            WaitTicks(16)
            self:SetTurnRate(30)
        elseif dist > 43 and dist <= 107 then
            -- Further increase check intervals
            WaitTicks(4)
            self:SetTurnRate(75)
        elseif dist > 0 and dist <= 43 then
            -- Further increase check intervals
            self:SetTurnRate(200)
            KillThread(self.MoveThread)
        end
    end,

    OnEnterWater = function(self)
        TIFMissileNuke.OnEnterWater(self)
        self:SetDestroyOnWater(true)
    end,

   
}
TypeClass = TIFMissileFatMen01
end



