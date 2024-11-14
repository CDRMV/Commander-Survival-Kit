#
# Terran Torpedo Bomb
#
local TTorpedoShipProjectile = import('/lua/terranprojectiles.lua').TTorpedoShipProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')

TANAnglerTorpedo04 = Class(TTorpedoShipProjectile) {
    FxInitial = {},
    FxTrails = {'/effects/emitters/torpedo_underwater_wake_01_emit.bp',},
    TrailDelay = 0,

    # Hit Effects
    FxImpactLand = {},
    FxUnitHitScale = 2.00,
    FxImpactUnit = EffectTemplate.CTorpedoUnitHit01,
    FxImpactProp = EffectTemplate.CTorpedoUnitHit01,
    FxImpactUnderWater = EffectTemplate.CTorpedoUnitHit01,
    FxImpactNone = {},
    FxEnterWater= EffectTemplate.WaterSplash01,

    OnCreate = function(self, inWater)
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.0)
        TTorpedoShipProjectile.OnCreate(self)
        # if we are starting in the water then immediately switch to tracking in water and
        # create underwater trail effects
        if inWater == true then
            self:TrackTarget(true):StayUnderwater(true)
            TTorpedoShipProjectile.OnEnterWater(self)
        end
    end,

    OnEnterWater = function(self)
        TTorpedoShipProjectile.OnEnterWater(self)
        local army = self:GetArmy()

        for k, v in self.FxEnterWater do #splash
            CreateEmitterAtEntity(self,army,v)
        end
        self:TrackTarget(true)
        self:StayUnderwater(true)
        self:SetTurnRate(720)
        self:SetMaxSpeed(18)
        self:SetVelocity(0)
        self:ForkThread(self.MovementThread)
    end,
    
    MovementThread = function(self)
        WaitTicks(1)
        self:SetVelocity(3)
    end,


}
TypeClass = TANAnglerTorpedo04
