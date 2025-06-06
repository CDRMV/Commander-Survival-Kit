local CallGroundAttackAirStrikeBeacon = import('/lua/defaultunits.lua').CallGroundAttackAirStrikeBeacon

UAFSAS9001 = Class(CallGroundAttackAirStrikeBeacon) {
    FxTransportBeacon = {'/effects/emitters/red_beacon_light_01_emit.bp'},
    FxTransportBeaconScale = 1,

    OnCreate = function(self)
        CallGroundAttackAirStrikeBeacon.OnCreate(self)
        for k, v in self.FxTransportBeacon do
            self.Trash:Add(CreateAttachedEmitter(self, 0,self:GetArmy(), v):ScaleEmitter(self.FxTransportBeaconScale))
        end
    end,
}

TypeClass = UAFSAS9001
