local CallAirDropDefenseBeacon = import('/lua/defaultunits.lua').CallAirDropDefenseBeacon

UERDR8800 = Class(CallAirDropDefenseBeacon) {
    FxTransportBeacon = {'/effects/emitters/red_beacon_light_01_emit.bp'},
    FxTransportBeaconScale = 1,

    OnCreate = function(self)
        CallAirDropDefenseBeacon.OnCreate(self)
        for k, v in self.FxTransportBeacon do
            self.Trash:Add(CreateAttachedEmitter(self, 0,self:GetArmy(), v):ScaleEmitter(self.FxTransportBeaconScale))
        end
    end,
}

TypeClass = UERDR8800
