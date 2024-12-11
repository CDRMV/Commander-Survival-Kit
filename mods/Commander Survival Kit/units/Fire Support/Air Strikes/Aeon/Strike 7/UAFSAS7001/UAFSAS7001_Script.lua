local CallTorpedoAirStrikeBeacon = import('/lua/defaultunits.lua').CallTorpedoAirStrikeBeacon

UAFSAS7001 = Class(CallTorpedoAirStrikeBeacon) {
    FxTransportBeacon = {'/effects/emitters/red_beacon_light_01_emit.bp'},
    FxTransportBeaconScale = 1,

    OnCreate = function(self)
        CallTorpedoAirStrikeBeacon.OnCreate(self)
        for k, v in self.FxTransportBeacon do
            self.Trash:Add(CreateAttachedEmitter(self, 0,self:GetArmy(), v):ScaleEmitter(self.FxTransportBeaconScale))
        end
    end,
}

TypeClass = UAFSAS7001
