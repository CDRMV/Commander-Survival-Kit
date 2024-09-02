local CallAirDropT1andT2LandReinforcementBeacon = import('/lua/defaultunits.lua').CallAirDropT1andT2LandReinforcementBeacon

UERL0105 = Class(CallAirDropT1andT2LandReinforcementBeacon) {
    FxTransportBeacon = {'/effects/emitters/red_beacon_light_01_emit.bp'},
    FxTransportBeaconScale = 1,

    OnCreate = function(self)
        CallAirDropT1andT2LandReinforcementBeacon.OnCreate(self)
        for k, v in self.FxTransportBeacon do
            self.Trash:Add(CreateAttachedEmitter(self, 0,self:GetArmy(), v):ScaleEmitter(self.FxTransportBeaconScale))
        end
    end,
}

TypeClass = UERL0105
