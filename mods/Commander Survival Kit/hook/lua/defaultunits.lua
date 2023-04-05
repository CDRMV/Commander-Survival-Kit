--------------------------------------------------------------------------------
-- Summary: Air Strike beacon unit script
--  Note: This code is an modified Version of Balthazar BrewReinforce Becon Script.
--  Author: CDRMV, Sean "Balthazar" Wheeldon (Originally)
--------------------------------------------------------------------------------
AirStrikeBeacon = Class(StructureUnit) {
    ----------------------------------------------------------------------------
    -- NOTE: Call this function to start call the reinforcements
    -- Inputs: self, the unit type requested
    ----------------------------------------------------------------------------
    CallAirStrike = function(self, unitID, quantity, exitOpposite)
        --Sanitise inputs
        unitID = unitID 
        quantity = math.max(quantity or 1, 1)

        --Get positions
        local pos = self.CachePosition or self:GetPosition()
        local BorderPos, OppBorPos

        local x, z = pos[1] / ScenarioInfo.size[1] - 0.5, pos[3] / ScenarioInfo.size[2] - 0.6

        if math.abs(x) <= math.abs(z) then
            BorderPos = {pos[1], nil, math.ceil(z) * ScenarioInfo.size[2]}
            OppBorPos = {pos[1], nil, BorderPos[3]==0 and ScenarioInfo.size[2] or 0}
            x, z = 1, 0
        else
            BorderPos = {math.ceil(x) * ScenarioInfo.size[1], nil, pos[3]}
            OppBorPos = {BorderPos[1]==0 and ScenarioInfo.size[1] or 0, nil, pos[3]}
            x, z = 0, 1
        end

        BorderPos[2] = GetTerrainHeight(BorderPos[1], BorderPos[3])
        OppBorPos[2] = GetTerrainHeight(OppBorPos[1], OppBorPos[3])

        --Get blueprints
        local unitBP = __blueprints[unitID]


        --Entity data
        local Bombers = {} -- Temporary, for this cycle
        if self.SingleUse then
            self.Bombers = {} -- so a single use beacon can call multiple types of unit
        end
        local created = 0
        local tpn = 0
        local army = self:GetArmy()

        while created < quantity do
            tpn = tpn + 1
            Bombers[tpn] = CreateUnitHPR(
                unitID,
                army,
                BorderPos[1] + (math.random(-quantity,quantity) * x), BorderPos[2], BorderPos[3] + (math.random(-quantity,quantity) * z),
                0, 0, 0
            )
            table.insert(self.Bombers, Bombers[tpn])
			created = created + 1
            if created >= quantity then
                break
            end
        end

        for i, trans in Bombers do
            if exitOpposite then
                IssueMove({trans}, {OppBorPos[1] + (math.random(-quantity,quantity) * x), OppBorPos[2], OppBorPos[3] + (math.random(-quantity,quantity) * z)})
            else
                IssueMove({trans}, {BorderPos[1] + (math.random(-quantity,quantity) * x), BorderPos[2], BorderPos[3] + (math.random(-quantity,quantity) * z)})
            end
            trans.DeliveryThread = self.DeliveryThread
            trans:ForkThread(trans.DeliveryThread, self)
        end
        if self.SingleUse then
            self:ForkThread(self.TransportSurvivalCheckThread)
        end
    end,

    DeliveryThread = function(self, beacon)
        self:SetUnSelectable(true)
        while not self.Dead do
            local orders = table.getn(self:GetCommandQueue())
            if orders > 1 then
                --Transport on the way
                coroutine.yield(50)
            elseif orders == 1 then
                coroutine.yield(100) 
            elseif orders == 0 then
                -- Transport has arrived back at the edge of the map
                if beacon and beacon.SingleUse and not beacon.Dead then
                    beacon:Destroy()
                end
                self:Destroy()
                coroutine.yield(100) --shouldn't matter, but just in case
            end
        end
    end,

    TransportSurvivalCheckThread = function(self)
        if self.SingleUse then --  double check just in case something called this and shouldn't have
            while not self.Dead do
                local KYS = true
                for i, tran in self.Bombers do
                    if tran and not tran.Dead then
                        KYS = false
                        break
                    end
                end
                if KYS then
                    self:Destroy()
                end
                coroutine.yield(100)
            end
        end
    end,

}

--------------------------------------------------------------------------------
-- Summary: Single use reinforcement beacon unit script
--          Calls reinforcements on stop being built. Destroys resolved.
--  Author: CDRMV, Sean "Balthazar" Wheeldon (Originally)
--  Inputs: Expects blueprint table bp.Economy.Reinforcements with values for the
--          keys: [Unit = id string], [Transport = id string], [Quantity = intager]
--          for example:
--[[
    Economy = {
        Reinforcements = {
            Unit = 'ual0106',
            Quantity = 30,
            ExitOpposite = true,
        }
    },
]]
--------------------------------------------------------------------------------
CallAirStrikeBeacon = Class(AirStrikeBeacon) {

    SingleUse = true,

    OnStopBeingBuilt = function(self, builder, layer)
        AirStrikeBeacon.OnStopBeingBuilt(self, builder, layer)

        local bpR = (__blueprints[self.BpId] or self:GetBlueprint() ).Economy.Reinforcements
        self:CallAirStrike(bpR.Unit, bpR.Quantity, bpR.ExitOpposite)
    end,
}
