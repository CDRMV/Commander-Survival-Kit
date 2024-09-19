local CallAirDropExperimentalReinforcementBeacon = import('/lua/defaultunits.lua').CallAirDropExperimentalReinforcementBeacon

UERL0401 = Class(CallAirDropExperimentalReinforcementBeacon) {
    FxTransportBeacon = {'/effects/emitters/red_beacon_light_01_emit.bp'},
    FxTransportBeaconScale = 1,

    OnCreate = function(self)
        CallAirDropExperimentalReinforcementBeacon.OnCreate(self)
        for k, v in self.FxTransportBeacon do
            self.Trash:Add(CreateAttachedEmitter(self, 0,self:GetArmy(), v):ScaleEmitter(self.FxTransportBeaconScale))
        end
    end,
}

TypeClass = UERL0401