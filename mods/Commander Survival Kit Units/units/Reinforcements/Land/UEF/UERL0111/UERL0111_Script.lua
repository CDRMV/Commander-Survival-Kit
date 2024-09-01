local CallAirDropLandReinforcementBeacon = import('/lua/defaultunits.lua').CallAirDropLandReinforcementBeacon

UERL0111 = Class(CallAirDropLandReinforcementBeacon) {
    FxTransportBeacon = {'/effects/emitters/red_beacon_light_01_emit.bp'},
    FxTransportBeaconScale = 1,

    OnCreate = function(self)
        CallAirDropLandReinforcementBeacon.OnCreate(self)
        for k, v in self.FxTransportBeacon do
            self.Trash:Add(CreateAttachedEmitter(self, 0,self:GetArmy(), v):ScaleEmitter(self.FxTransportBeaconScale))
        end
    end,
}

TypeClass = UERL0111
