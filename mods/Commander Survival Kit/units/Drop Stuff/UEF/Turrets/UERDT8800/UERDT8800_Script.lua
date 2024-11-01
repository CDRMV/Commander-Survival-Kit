local CallAirDropT3LandReinforcementBeacon = import('/lua/defaultunits.lua').CallAirDropT3LandReinforcementBeacon

UERDR8800 = Class(CallAirDropT3LandReinforcementBeacon) {
    FxTransportBeacon = {'/effects/emitters/red_beacon_light_01_emit.bp'},
    FxTransportBeaconScale = 1,

    OnCreate = function(self)
        CallAirDropT3LandReinforcementBeacon.OnCreate(self)
        for k, v in self.FxTransportBeacon do
            self.Trash:Add(CreateAttachedEmitter(self, 0,self:GetArmy(), v):ScaleEmitter(self.FxTransportBeaconScale))
        end
    end,
}

TypeClass = UERDR8800
