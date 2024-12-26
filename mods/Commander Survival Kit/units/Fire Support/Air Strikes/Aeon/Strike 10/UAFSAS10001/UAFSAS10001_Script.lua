local CallPatrolGunshipBeacon = import('/lua/defaultunits.lua').CallPatrolGunshipBeacon

UAFSAS10001 = Class(CallPatrolGunshipBeacon) {
    FxTransportBeacon = {'/effects/emitters/red_beacon_light_01_emit.bp'},
    FxTransportBeaconScale = 1,

    OnCreate = function(self)
        CallPatrolGunshipBeacon.OnCreate(self)
        for k, v in self.FxTransportBeacon do
            self.Trash:Add(CreateAttachedEmitter(self, 0,self:GetArmy(), v):ScaleEmitter(self.FxTransportBeaconScale))
        end
    end,
}

TypeClass = UAFSAS10001
