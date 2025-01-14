local CallAirDropLandExperimentalReinforcementBeacon = import('/lua/defaultunits.lua').CallAirDropLandExperimentalReinforcementBeacon

UERL0401 = Class(CallAirDropLandExperimentalReinforcementBeacon) {
    FxTransportBeacon = {'/effects/emitters/red_beacon_light_01_emit.bp'},
    FxTransportBeaconScale = 1,

    OnCreate = function(self)
        CallAirDropLandExperimentalReinforcementBeacon.OnCreate(self)
        for k, v in self.FxTransportBeacon do
            self.Trash:Add(CreateAttachedEmitter(self, 0,self:GetArmy(), v):ScaleEmitter(self.FxTransportBeaconScale))
        end
    end,
}

TypeClass = UERL0401