--------------------------------------------------------------------------------
-- Summary: Air Strike beacon unit script
--  Note: This code is an modified Version of Balthazar BrewReinforce Becon Script.
--  Author: CDRMV, Sean "Balthazar" Wheeldon (Originally)
--------------------------------------------------------------------------------

AirStrikeBeacon = Class(StructureUnit) {

GetPlayableArea = function()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
end,

GetNearestPlayablePoint = function(self,position)

    local px, _, pz = unpack(position)
	
	if ScenarioInfo.type == 'campaign' or ScenarioInfo.type == 'campaign_coop' then
	local playableArea = self.GetPlayableArea()

    -- keep track whether the point is actually outside the map
    local isOutside = false

    if px < playableArea[1] then
        isOutside = true
        px = playableArea[1] + 1
    elseif px > playableArea[3] then
        isOutside = true
        px = playableArea[3] - 1
    end

    if pz < playableArea[2] then
        isOutside = true
        pz = playableArea[2] + 1
    elseif pz > playableArea[4] then
        isOutside = true
        pz = playableArea[4] - 1
    end

    -- if it really is outside the map then we allocate a new vector
    if isOutside then
        return {
            px, 
            GetTerrainHeight(px, pz),
            pz
        }

    end

	elseif ScenarioInfo.type == 'skirmish' then
	return position
	else
	return position
	end
end,

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

		local AirStrikeMechanic = ScenarioInfo.Options.AirStrikeMechanic

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

		local position = self.GetNearestPlayablePoint(self,BorderPos)
		local oppoposition = self.GetNearestPlayablePoint(self,OppBorPos)


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
                position[1] + (math.random(-quantity,quantity) * x), position[2], position[3] + (math.random(-quantity,quantity) * z),
                0, 0, 0
            )
            table.insert(self.Bombers, Bombers[tpn])
			created = created + 1
            if created >= quantity then
                break
            end
        end

        for i, Bomber in Bombers do
			if AirStrikeMechanic == 1 or Sync.AirStrikeMechanic == true then
            if exitOpposite then
                IssueMove({Bomber}, {oppoposition[1] + (math.random(-quantity,quantity) * x), oppoposition[2], oppoposition[3] + (math.random(-quantity,quantity) * z)})
				Bomber:RotateTowards(oppoposition)
            else
               IssueMove({Bomber}, {pos[1] + (math.random(-quantity,quantity) * x), pos[2], pos[3] + (math.random(-quantity,quantity) * z)})
			   IssueAttack({Bomber}, {pos[1] + (math.random(-quantity,quantity) * x), pos[2], pos[3] + (math.random(-quantity,quantity) * z)})
			   Bomber:RotateTowards(pos)
            end
            Bomber.DeliveryThread = self.DeliveryThread
            Bomber:ForkThread(Bomber.DeliveryThread, self)
			else
			if exitOpposite then
			   IssueMove({Bomber}, {pos[1] + (math.random(-quantity,quantity) * x), pos[2], pos[3] + (math.random(-quantity,quantity) * z)})
			   IssueAttack({Bomber}, {pos[1] + (math.random(-quantity,quantity) * x), pos[2], pos[3] + (math.random(-quantity,quantity) * z)})
			   Bomber:RotateTowards(pos)
            else
                IssueMove({Bomber}, {oppoposition[1] + (math.random(-quantity,quantity) * x), oppoposition[2], oppoposition[3] + (math.random(-quantity,quantity) * z)})
				Bomber:RotateTowards(oppoposition)
            end
            Bomber.DeliveryThread = self.DeliveryThread
            Bomber:ForkThread(Bomber.DeliveryThread, self)
			end
        end
        if self.SingleUse then
            self:ForkThread(self.AirStrikeSurvivalCheckThread)
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
				IssueClearCommands(self)
				self:SetImmobile(true)
				self:RemoveCommandCap('RULEUCC_Attack')
				self:RemoveCommandCap('RULEUCC_RetaliateToggle')
				self:SetWeaponEnabledByLabel('Bomb', false)
				self:Destroy()
                -- Transport has arrived back at the edge of the map
                if beacon and beacon.SingleUse and not beacon.Dead then
                    beacon:Destroy()
                end
                coroutine.yield(100) --shouldn't matter, but just in case
            end
        end
    end,

    AirStrikeSurvivalCheckThread = function(self)
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

TorpedoAirStrikeBeacon = Class(StructureUnit) {

GetPlayableArea = function()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
end,

GetNearestPlayablePoint = function(self,position)

    local px, _, pz = unpack(position)
	
	if ScenarioInfo.type == 'campaign' or ScenarioInfo.type == 'campaign_coop'  then
	local playableArea = self.GetPlayableArea()

    -- keep track whether the point is actually outside the map
    local isOutside = false

    if px < playableArea[1] then
        isOutside = true
        px = playableArea[1] + 1
    elseif px > playableArea[3] then
        isOutside = true
        px = playableArea[3] - 1
    end

    if pz < playableArea[2] then
        isOutside = true
        pz = playableArea[2] + 1
    elseif pz > playableArea[4] then
        isOutside = true
        pz = playableArea[4] - 1
    end

    -- if it really is outside the map then we allocate a new vector
    if isOutside then
        return {
            px, 
            GetSurfaceHeight(px, pz),
            pz
        }

    end

	elseif ScenarioInfo.type == 'skirmish' then
	return position
	else
	return position
	end
end,

    ----------------------------------------------------------------------------
    -- NOTE: Call this function to start call the reinforcements
    -- Inputs: self, the unit type requested
    ----------------------------------------------------------------------------
	
	CallTorpedoAirStrike = function(self, unitID, quantity, exitOpposite)
		local Unitcat = ParseEntityCategory('NAVAL')
		local Navalunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			Unitcat, 
			self:GetPosition(), 
			25,
			'Enemy'
			
		)
		
		
	
        --Sanitise inputs
        unitID = unitID 
        quantity = math.max(quantity or 1, 1)

        --Get positions
        local pos = self.CachePosition or self:GetPosition()
        local BorderPos, OppBorPos

		local AirStrikeMechanic = ScenarioInfo.Options.AirStrikeMechanic

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

		local position = self.GetNearestPlayablePoint(self,BorderPos)
		local oppoposition = self.GetNearestPlayablePoint(self,OppBorPos)


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
                position[1] + (math.random(-quantity,quantity) * x), position[2], position[3] + (math.random(-quantity,quantity) * z),
                0, 0, 0
            )
            table.insert(self.Bombers, Bombers[tpn])
			created = created + 1
            if created >= quantity then
                break
            end
        end

        for i, Bomber in Bombers do
			if AirStrikeMechanic == 1 or Sync.AirStrikeMechanic == true then
            if exitOpposite then
                IssueMove({Bomber}, {oppoposition[1] + (math.random(-quantity,quantity) * x), oppoposition[2], oppoposition[3] + (math.random(-quantity,quantity) * z)})
				Bomber:RotateTowards(oppoposition)
            else
                IssueMove({Bomber}, {position[1] + (math.random(-quantity,quantity) * x), position[2], position[3] + (math.random(-quantity,quantity) * z)})
            end
            Bomber.DeliveryThread = self.DeliveryThread
            Bomber:ForkThread(Bomber.DeliveryThread, self)
			else
			if exitOpposite then
			   if Navalunits[1] == nil then
			   IssueMove({Bomber}, {pos[1] + (math.random(-quantity,quantity) * x), pos[2], pos[3] + (math.random(-quantity,quantity) * z)})
			   IssueAttack({Bomber}, {pos[1] + (math.random(-quantity,quantity) * x), pos[2], pos[3] + (math.random(-quantity,quantity) * z)})
			   Bomber:RotateTowards(pos)
			   else
			   IssueMove({Bomber}, {pos[1] + (math.random(-quantity,quantity) * x), pos[2], pos[3] + (math.random(-quantity,quantity) * z)})
			   IssueAttack({Bomber}, Navalunits[1])
			   Bomber:RotateTowards(pos)
			   end
            else
                IssueMove({Bomber}, {position[1] + (math.random(-quantity,quantity) * x), position[2], position[3] + (math.random(-quantity,quantity) * z)})
            end
            Bomber.DeliveryThread = self.DeliveryThread
            Bomber:ForkThread(Bomber.DeliveryThread, self, position)
			end
        end
        if self.SingleUse then
            self:ForkThread(self.TorpedoAirStrikeSurvivalCheckThread)
        end
    end,

    DeliveryThread = function(self, beacon, spawnposition)
	local number = 0 
        self:SetUnSelectable(true)
        while not self.Dead do
            local orders = table.getn(self:GetCommandQueue())
            if orders > 1 then
                --Transport on the way
                coroutine.yield(50)
            elseif orders == 1 then
                coroutine.yield(100) 
            elseif orders == 0 then
				if number == 0 then
				--IssueClearCommands(self)
				IssueMove({self}, spawnposition)
				self:RemoveCommandCap('RULEUCC_Attack')
				self:RemoveCommandCap('RULEUCC_RetaliateToggle')
				self:SetWeaponEnabledByLabel('Bomb', false)
				number = number + 1
				else
				IssueClearCommands(self)
				self:SetImmobile(true)
				self:Destroy()
				
				end
	
                -- Transport has arrived back at the edge of the map#
                if beacon and beacon.SingleUse and not beacon.Dead then
                    beacon:Destroy()
                end	
                coroutine.yield(100) --shouldn't matter, but just in case
            end
        end
    end,

    TorpedoAirStrikeSurvivalCheckThread = function(self)
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

GroundAttackAirStrikeBeacon = Class(StructureUnit) {

GetPlayableArea = function()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
end,

GetNearestPlayablePoint = function(self,position)

    local px, _, pz = unpack(position)
	
	if ScenarioInfo.type == 'campaign' or ScenarioInfo.type == 'campaign_coop' then
	local playableArea = self.GetPlayableArea()

    -- keep track whether the point is actually outside the map
    local isOutside = false

    if px < playableArea[1] then
        isOutside = true
        px = playableArea[1] + 1
    elseif px > playableArea[3] then
        isOutside = true
        px = playableArea[3] - 1
    end

    if pz < playableArea[2] then
        isOutside = true
        pz = playableArea[2] + 1
    elseif pz > playableArea[4] then
        isOutside = true
        pz = playableArea[4] - 1
    end

    -- if it really is outside the map then we allocate a new vector
    if isOutside then
        return {
            px, 
            GetTerrainHeight(px, pz),
            pz
        }

    end

	elseif ScenarioInfo.type == 'skirmish' then
	return position
	else
	return position
	end
end,

    ----------------------------------------------------------------------------
    -- NOTE: Call this function to start call the reinforcements
    -- Inputs: self, the unit type requested
    ----------------------------------------------------------------------------
    CallGroundAttackAirStrike = function(self, unitID, quantity, exitOpposite)
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

		local position = self.GetNearestPlayablePoint(self,BorderPos)
		local oppoposition = self.GetNearestPlayablePoint(self,OppBorPos)

        --Get blueprints
        local unitBP = __blueprints[unitID]


        --Entity data
        local AirUnits = {} -- Temporary, for this cycle
        if self.SingleUse then
            self.AirUnits = {} -- so a single use beacon can call multiple types of unit
        end
        local created = 0
        local tpn = 0
        local army = self:GetArmy()
		

        while created < quantity do
            tpn = tpn + 1
			AirUnits[tpn] = CreateUnitHPR(
                unitID,
                army,
                position[1] + (math.random(-quantity,quantity) * x), position[2], position[3] + (math.random(-quantity,quantity) * z),
                0, 0, 0
            )
            table.insert(self.AirUnits, AirUnits[tpn])
			created = created + 1
            if created >= quantity then
                break
            end
        end

        for i, unit in AirUnits do
            if exitOpposite then
                IssueAttack({unit}, {pos[1] + (math.random(-quantity,quantity) * x), pos[2], pos[3] + (math.random(-quantity,quantity) * z)})
				unit:RotateTowards(pos)
            else
                IssueMove({unit}, {oppoposition[1] + (math.random(-quantity,quantity) * x), oppoposition[2], oppoposition[3] + (math.random(-quantity,quantity) * z)})
            end
            unit.DeliveryThread = self.DeliveryThread
            unit:ForkThread(unit.DeliveryThread, self)
        end
        if self.SingleUse then
            self:ForkThread(self.AirUnitSurvivalCheckThread)
        end
    end,

    DeliveryThread = function(self, beacon)
	local number = 0
	local pos = beacon:GetPosition()
        while not self.Dead do
            local orders = table.getn(self:GetCommandQueue())
            if orders > 1 then
                --Air Unit on the way
                coroutine.yield(50)
            elseif orders == 1 then
                coroutine.yield(100) 
				if beacon and beacon.SingleUse and not beacon.Dead then
                    beacon:Destroy()
                end
            elseif orders == 0 then
				if number == 0 then
				self:RotateTowardsMid()
				IssueAttack({self}, pos)
				end
                coroutine.yield(100) --shouldn't matter, but just in case
            end
        end
    end,

    AirUnitSurvivalCheckThread = function(self)
        if self.SingleUse then --  double check just in case something called this and shouldn't have
            while not self.Dead do
                local KYS = true
                for i, tran in self.AirUnits do
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

AirReinforcementBeacon = Class(StructureUnit) {

GetPlayableArea = function()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
end,

GetNearestPlayablePoint = function(self,position)

    local px, _, pz = unpack(position)
	
	if ScenarioInfo.type == 'campaign'  or ScenarioInfo.type == 'campaign_coop' then
	local playableArea = self.GetPlayableArea()

    -- keep track whether the point is actually outside the map
    local isOutside = false

    if px < playableArea[1] then
        isOutside = true
        px = playableArea[1] + 1
    elseif px > playableArea[3] then
        isOutside = true
        px = playableArea[3] - 1
    end

    if pz < playableArea[2] then
        isOutside = true
        pz = playableArea[2] + 1
    elseif pz > playableArea[4] then
        isOutside = true
        pz = playableArea[4] - 1
    end

    -- if it really is outside the map then we allocate a new vector
    if isOutside then
        return {
            px, 
            GetTerrainHeight(px, pz),
            pz
        }

    end

	elseif ScenarioInfo.type == 'skirmish' then
	return position
	else
	return position
	end
end,

    ----------------------------------------------------------------------------
    -- NOTE: Call this function to start call the reinforcements
    -- Inputs: self, the unit type requested
    ----------------------------------------------------------------------------
    CallAirReinforcement = function(self, unitID, quantity, ArrivalatLocation)
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

		local position = self.GetNearestPlayablePoint(self,BorderPos)
		local oppoposition = self.GetNearestPlayablePoint(self,OppBorPos)

        --Get blueprints
        local unitBP = __blueprints[unitID]


        --Entity data
        local AirUnits = {} -- Temporary, for this cycle
        if self.SingleUse then
            self.AirUnits = {} -- so a single use beacon can call multiple types of unit
        end
        local created = 0
        local tpn = 0
        local army = self:GetArmy()
		

        while created < quantity do
            tpn = tpn + 1
			AirUnits[tpn] = CreateUnitHPR(
                unitID,
                army,
                position[1] + (math.random(-quantity,quantity) * x), position[2], position[3] + (math.random(-quantity,quantity) * z),
                0, 0, 0
            )
            table.insert(self.AirUnits, AirUnits[tpn])
			created = created + 1
            if created >= quantity then
                break
            end
        end

        for i, unit in AirUnits do
            if ArrivalatLocation then
                IssueMove({unit}, {pos[1] + (math.random(-quantity,quantity) * x), pos[2], pos[3] + (math.random(-quantity,quantity) * z)})
				unit:RotateTowards(pos)
            else
                IssueMove({unit}, {oppoposition[1] + (math.random(-quantity,quantity) * x), oppoposition[2], oppoposition[3] + (math.random(-quantity,quantity) * z)})
            end
            unit.DeliveryThread = self.DeliveryThread
            unit:ForkThread(unit.DeliveryThread, self)
        end
        if self.SingleUse then
            self:ForkThread(self.AirUnitSurvivalCheckThread)
        end
    end,

    DeliveryThread = function(self, beacon)
        while not self.Dead do
            local orders = table.getn(self:GetCommandQueue())
            if orders > 1 then
                --Air Unit on the way
                coroutine.yield(50)
            elseif orders == 1 then
                coroutine.yield(100) 
				if beacon and beacon.SingleUse and not beacon.Dead then
                    beacon:Destroy()
                end
            elseif orders == 0 then
                -- Air Unit has arrived back at the edge of the map
                if beacon and beacon.SingleUse and not beacon.Dead then
                    beacon:Destroy()
                end
                coroutine.yield(100) --shouldn't matter, but just in case
            end
        end
    end,

    AirUnitSurvivalCheckThread = function(self)
        if self.SingleUse then --  double check just in case something called this and shouldn't have
            while not self.Dead do
                local KYS = true
                for i, tran in self.AirUnits do
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



AirDropT1andT2LandReinforcementBeacon = Class(StructureUnit) {

GetPlayableArea = function()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
end,

GetNearestPlayablePoint = function(self,position)

    local px, _, pz = unpack(position)
	
	if ScenarioInfo.type == 'campaign' or ScenarioInfo.type == 'campaign_coop' then
	local playableArea = self.GetPlayableArea()

    -- keep track whether the point is actually outside the map
    local isOutside = false

    if px < playableArea[1] then
        isOutside = true
        px = playableArea[1] + 1
    elseif px > playableArea[3] then
        isOutside = true
        px = playableArea[3] - 1
    end

    if pz < playableArea[2] then
        isOutside = true
        pz = playableArea[2] + 1
    elseif pz > playableArea[4] then
        isOutside = true
        pz = playableArea[4] - 1
    end

    -- if it really is outside the map then we allocate a new vector
    if isOutside then
        return {
            px, 
            GetTerrainHeight(px, pz),
            pz
        }

    end

	elseif ScenarioInfo.type == 'skirmish' then
	return position
	else
	return position
	end
end,

    ----------------------------------------------------------------------------
    -- NOTE: Call this function to start call the reinforcements
    -- Inputs: self, the unit type requested
    ----------------------------------------------------------------------------
    CallAirDropT1andT2LandReinforcement = function(self, unitID, quantity, ArrivalatLocation)
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

		local position = self.GetNearestPlayablePoint(self,BorderPos)
		local oppoposition = self.GetNearestPlayablePoint(self,OppBorPos)

        --Get blueprints
        local unitBP = __blueprints[unitID]


        --Entity data
        local AirUnits = {} -- Temporary, for this cycle
        if self.SingleUse then
            self.AirUnits = {} -- so a single use beacon can call multiple types of unit
        end
        local created = 0
        local tpn = 0
        local army = self:GetArmy()
		

        while created < quantity do
            tpn = tpn + 1
			AirUnits[tpn] = CreateUnitHPR(
                unitID,
                army,
                position[1] + (math.random(-quantity,quantity) * x), position[2], position[3] + (math.random(-quantity,quantity) * z),
                0, 0, 0
            )
            table.insert(self.AirUnits, AirUnits[tpn])
			created = created + 1
            if created >= quantity then
                break
            end
        end

        for i, unit in AirUnits do
            if ArrivalatLocation then
                IssueAttack({unit}, {pos[1] + (math.random(-quantity,quantity) * x), pos[2], pos[3] + (math.random(-quantity,quantity) * z)})
				unit:RotateTowards(pos)
            else
                IssueMove({unit}, {oppoposition[1] + (math.random(-quantity,quantity) * x), oppoposition[2], oppoposition[3] + (math.random(-quantity,quantity) * z)})
            end
            unit.DeliveryThread = self.DeliveryThread
            unit:ForkThread(unit.DeliveryThread, self)
        end
        if self.SingleUse then
            self:ForkThread(self.AirUnitSurvivalCheckThread)
        end
    end,

    DeliveryThread = function(self, beacon)
	local number = 0
	local pos = beacon:GetPosition()
        while not self.Dead do
            local orders = table.getn(self:GetCommandQueue())
            if orders > 1 then
                --Air Unit on the way
                coroutine.yield(50)
            elseif orders == 1 then
                coroutine.yield(100) 
				if beacon and beacon.SingleUse and not beacon.Dead then
                    beacon:Destroy()
                end
            elseif orders == 0 then
				if number == 0 then
				self:RotateTowardsMid()
				IssueAttack({self}, pos)
				end
                coroutine.yield(100) --shouldn't matter, but just in case
            end
        end
    end,

    AirUnitSurvivalCheckThread = function(self)
        if self.SingleUse then --  double check just in case something called this and shouldn't have
            while not self.Dead do
                local KYS = true
                for i, tran in self.AirUnits do
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

AirDropT3LandReinforcementBeacon = Class(StructureUnit) {

GetPlayableArea = function()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
end,

GetNearestPlayablePoint = function(self,position)

    local px, _, pz = unpack(position)
	
	if ScenarioInfo.type == 'campaign' or ScenarioInfo.type == 'campaign_coop' then
	local playableArea = self.GetPlayableArea()

    -- keep track whether the point is actually outside the map
    local isOutside = false

    if px < playableArea[1] then
        isOutside = true
        px = playableArea[1] + 1
    elseif px > playableArea[3] then
        isOutside = true
        px = playableArea[3] - 1
    end

    if pz < playableArea[2] then
        isOutside = true
        pz = playableArea[2] + 1
    elseif pz > playableArea[4] then
        isOutside = true
        pz = playableArea[4] - 1
    end

    -- if it really is outside the map then we allocate a new vector
    if isOutside then
        return {
            px, 
            GetTerrainHeight(px, pz),
            pz
        }

    end

	elseif ScenarioInfo.type == 'skirmish' then
	return position
	else
	return position
	end
end,

    ----------------------------------------------------------------------------
    -- NOTE: Call this function to start call the reinforcements
    -- Inputs: self, the unit type requested
    ----------------------------------------------------------------------------
    CallAirDropT3LandReinforcement = function(self, unitID, quantity, ArrivalatLocation)
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

		local position = self.GetNearestPlayablePoint(self,BorderPos)
		local oppoposition = self.GetNearestPlayablePoint(self,OppBorPos)

        --Get blueprints
        local unitBP = __blueprints[unitID]


        --Entity data
        local AirUnits = {} -- Temporary, for this cycle
        if self.SingleUse then
            self.AirUnits = {} -- so a single use beacon can call multiple types of unit
        end
        local created = 0
        local tpn = 0
        local army = self:GetArmy()
		

        while created < quantity do
            tpn = tpn + 1
			AirUnits[tpn] = CreateUnitHPR(
                unitID,
                army,
                position[1] + (math.random(-quantity,quantity) * x), position[2], position[3] + (math.random(-quantity,quantity) * z),
                0, 0, 0
            )
            table.insert(self.AirUnits, AirUnits[tpn])
			created = created + 1
            if created >= quantity then
                break
            end
        end

        for i, unit in AirUnits do
            if ArrivalatLocation then
                IssueTransportUnload({unit}, {pos[1] + (math.random(-quantity,quantity) * x), pos[2], pos[3] + (math.random(-quantity,quantity) * z)})
				unit:RotateTowards(pos)
            else
                IssueMove({unit}, {oppoposition[1] + (math.random(-quantity,quantity) * x), oppoposition[2], oppoposition[3] + (math.random(-quantity,quantity) * z)})
            end
            unit.DeliveryThread = self.DeliveryThread
            unit:ForkThread(unit.DeliveryThread, self)
        end
        if self.SingleUse then
            self:ForkThread(self.AirUnitSurvivalCheckThread)
        end
    end,

    DeliveryThread = function(self, beacon)
	local number = 0
	local pos = beacon:GetPosition()
        while not self.Dead do
            local orders = table.getn(self:GetCommandQueue())
            if orders > 1 then
                --Air Unit on the way
                coroutine.yield(50)
            elseif orders == 1 then
                coroutine.yield(100) 
				if beacon and beacon.SingleUse and not beacon.Dead then
                    beacon:Destroy()
                end
            elseif orders == 0 then
				if number == 0 then
				self:RotateTowardsMid()
				IssueTransportUnload({self}, pos)
				end
                coroutine.yield(100) --shouldn't matter, but just in case
            end
        end
    end,

    AirUnitSurvivalCheckThread = function(self)
        if self.SingleUse then --  double check just in case something called this and shouldn't have
            while not self.Dead do
                local KYS = true
                for i, tran in self.AirUnits do
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


AirDropNavalReinforcementBeacon = Class(StructureUnit) {

GetPlayableArea = function()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
end,

GetNearestPlayablePoint = function(self,position)

    local px, _, pz = unpack(position)
	
	if ScenarioInfo.type == 'campaign' or ScenarioInfo.type == 'campaign_coop' then
	local playableArea = self.GetPlayableArea()

    -- keep track whether the point is actually outside the map
    local isOutside = false

    if px < playableArea[1] then
        isOutside = true
        px = playableArea[1] + 1
    elseif px > playableArea[3] then
        isOutside = true
        px = playableArea[3] - 1
    end

    if pz < playableArea[2] then
        isOutside = true
        pz = playableArea[2] + 1
    elseif pz > playableArea[4] then
        isOutside = true
        pz = playableArea[4] - 1
    end

    -- if it really is outside the map then we allocate a new vector
    if isOutside then
        return {
            px, 
            GetTerrainHeight(px, pz),
            pz
        }

    end

	elseif ScenarioInfo.type == 'skirmish' then
	return position
	else
	return position
	end
end,

    ----------------------------------------------------------------------------
    -- NOTE: Call this function to start call the reinforcements
    -- Inputs: self, the unit type requested
    ----------------------------------------------------------------------------
CallAirDropNavalReinforcement = function(self, unitID, quantity, ArrivalatLocation)
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

		local position = self.GetNearestPlayablePoint(self,BorderPos)
		local oppoposition = self.GetNearestPlayablePoint(self,OppBorPos)

        --Get blueprints
        local unitBP = __blueprints[unitID]


        --Entity data
        local AirUnits = {} -- Temporary, for this cycle
        if self.SingleUse then
            self.AirUnits = {} -- so a single use beacon can call multiple types of unit
        end
        local created = 0
        local tpn = 0
        local army = self:GetArmy()
		

        while created < quantity do
            tpn = tpn + 1
			AirUnits[tpn] = CreateUnitHPR(
                unitID,
                army,
                position[1] + (math.random(-quantity,quantity) * x), position[2], position[3] + (math.random(-quantity,quantity) * z),
                0, 0, 0
            )
            table.insert(self.AirUnits, AirUnits[tpn])
			created = created + 1
            if created >= quantity then
                break
            end
        end
	
        for i, unit in AirUnits do
            if ArrivalatLocation then
                IssueTransportUnload({unit}, {pos[1] + (math.random(-quantity,quantity) * x), pos[2], pos[3] + (math.random(-quantity,quantity) * z)})
				unit:RotateTowards(pos)
            else
                IssueMove({unit}, {oppoposition[1] + (math.random(-quantity,quantity) * x), oppoposition[2], oppoposition[3] + (math.random(-quantity,quantity) * z)})
            end
            unit.DeliveryThread = self.DeliveryThread
            unit:ForkThread(unit.DeliveryThread, self)
        end
        if self.SingleUse then
            self:ForkThread(self.AirUnitSurvivalCheckThread)
        end
    end,

    DeliveryThread = function(self, beacon)
	local number = 0
	local pos = beacon:GetPosition()
        while not self.Dead do
            local orders = table.getn(self:GetCommandQueue())
            if orders > 1 then
                --Air Unit on the way
                coroutine.yield(50)
            elseif orders == 1 then
			    coroutine.yield(10) 
				if beacon and beacon.SingleUse and not beacon.Dead then
                    beacon:Destroy()
                end
                coroutine.yield(90) 
            elseif orders == 0 then
				if number == 0 then
				self:RotateTowardsMid()
				IssueTransportUnload({self}, pos)
				end
                coroutine.yield(100) --shouldn't matter, but just in case
            end
        end
    end,

    AirUnitSurvivalCheckThread = function(self)
        if self.SingleUse then --  double check just in case something called this and shouldn't have
            while not self.Dead do
                local KYS = true
                for i, tran in self.AirUnits do
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


AirDropExperimentalReinforcementBeacon = Class(StructureUnit) {

GetPlayableArea = function()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
end,

GetNearestPlayablePoint = function(self,position)

    local px, _, pz = unpack(position)
	
	if ScenarioInfo.type == 'campaign' or ScenarioInfo.type == 'campaign_coop' then
	local playableArea = self.GetPlayableArea()

    -- keep track whether the point is actually outside the map
    local isOutside = false

    if px < playableArea[1] then
        isOutside = true
        px = playableArea[1] + 1
    elseif px > playableArea[3] then
        isOutside = true
        px = playableArea[3] - 1
    end

    if pz < playableArea[2] then
        isOutside = true
        pz = playableArea[2] + 1
    elseif pz > playableArea[4] then
        isOutside = true
        pz = playableArea[4] - 1
    end

    -- if it really is outside the map then we allocate a new vector
    if isOutside then
        return {
            px, 
            GetTerrainHeight(px, pz),
            pz
        }

    end

	elseif ScenarioInfo.type == 'skirmish' then
	return position
	else
	return position
	end
end,

    ----------------------------------------------------------------------------
    -- NOTE: Call this function to start call the reinforcements
    -- Inputs: self, the unit type requested
    ----------------------------------------------------------------------------
CallAirDropExperimentalReinforcement = function(self, unitID, quantity, ArrivalatLocation)
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

		local position = self.GetNearestPlayablePoint(self,BorderPos)
		local oppoposition = self.GetNearestPlayablePoint(self,OppBorPos)

        --Get blueprints
        local unitBP = __blueprints[unitID]


        --Entity data
        local AirUnits = {} -- Temporary, for this cycle
        if self.SingleUse then
            self.AirUnits = {} -- so a single use beacon can call multiple types of unit
        end
        local created = 0
        local tpn = 0
        local army = self:GetArmy()
		

        while created < quantity do
            tpn = tpn + 1
			AirUnits[tpn] = CreateUnitHPR(
                unitID,
                army,
                position[1] + (math.random(-quantity,quantity) * x), position[2], position[3] + (math.random(-quantity,quantity) * z),
                0, 0, 0
            )
            table.insert(self.AirUnits, AirUnits[tpn])
			created = created + 1
            if created >= quantity then
                break
            end
        end

        for i, unit in AirUnits do
            if ArrivalatLocation then
                IssueTransportUnload({unit}, {pos[1] + (math.random(-quantity,quantity) * x), pos[2], pos[3] + (math.random(-quantity,quantity) * z)})
				unit:RotateTowards(pos)
            else
                IssueMove({unit}, {oppoposition[1] + (math.random(-quantity,quantity) * x), oppoposition[2], oppoposition[3] + (math.random(-quantity,quantity) * z)})
            end
            unit.DeliveryThread = self.DeliveryThread
            unit:ForkThread(unit.DeliveryThread, self)
        end
        if self.SingleUse then
            self:ForkThread(self.AirUnitSurvivalCheckThread)
        end
    end,

    DeliveryThread = function(self, beacon)
	local number = 0
	local pos = beacon:GetPosition()
        while not self.Dead do
            local orders = table.getn(self:GetCommandQueue())
            if orders > 1 then
                --Air Unit on the way
                coroutine.yield(50)
            elseif orders == 1 then
                coroutine.yield(100) 
				if beacon and beacon.SingleUse and not beacon.Dead then
                    beacon:Destroy()
                end
            elseif orders == 0 then
				if number == 0 then
				self:RotateTowardsMid()
				IssueTransportUnload({self}, pos)
				end
                coroutine.yield(100) --shouldn't matter, but just in case
            end
        end
    end,

    AirUnitSurvivalCheckThread = function(self)
        if self.SingleUse then --  double check just in case something called this and shouldn't have
            while not self.Dead do
                local KYS = true
                for i, tran in self.AirUnits do
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

PatrolGunshipAirStrikeBeacon = Class(StructureUnit) {

GetPlayableArea = function()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
end,

GetNearestPlayablePoint = function(self,position)

    local px, _, pz = unpack(position)
	
	if ScenarioInfo.type == 'campaign'  or ScenarioInfo.type == 'campaign_coop' then
	local playableArea = self.GetPlayableArea()

    -- keep track whether the point is actually outside the map
    local isOutside = false

    if px < playableArea[1] then
        isOutside = true
        px = playableArea[1] + 1
    elseif px > playableArea[3] then
        isOutside = true
        px = playableArea[3] - 1
    end

    if pz < playableArea[2] then
        isOutside = true
        pz = playableArea[2] + 1
    elseif pz > playableArea[4] then
        isOutside = true
        pz = playableArea[4] - 1
    end

    -- if it really is outside the map then we allocate a new vector
    if isOutside then
        return {
            px, 
            GetTerrainHeight(px, pz),
            pz
        }

    end

	elseif ScenarioInfo.type == 'skirmish' then
	return position
	else
	return position
	end
end,

    ----------------------------------------------------------------------------
    -- NOTE: Call this function to start call the reinforcements
    -- Inputs: self, the unit type requested
    ----------------------------------------------------------------------------
    CallPatrolGunship = function(self, unitID, quantity, ArrivalatLocation)
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

		local position = self.GetNearestPlayablePoint(self,BorderPos)
		local oppoposition = self.GetNearestPlayablePoint(self,OppBorPos)

        --Get blueprints
        local unitBP = __blueprints[unitID]


        --Entity data
        local AirUnits = {} -- Temporary, for this cycle
        if self.SingleUse then
            self.AirUnits = {} -- so a single use beacon can call multiple types of unit
        end
        local created = 0
        local tpn = 0
        local army = self:GetArmy()
		

        while created < quantity do
            tpn = tpn + 1
			AirUnits[tpn] = CreateUnitHPR(
                unitID,
                army,
                position[1] + (math.random(-quantity,quantity) * x), position[2], position[3] + (math.random(-quantity,quantity) * z),
                0, 0, 0
            )
            table.insert(self.AirUnits, AirUnits[tpn])
			created = created + 1
            if created >= quantity then
                break
            end
        end

        for i, unit in AirUnits do
            if ArrivalatLocation then
                IssueMove({unit}, {pos[1] + (math.random(-quantity,quantity) * x), pos[2], pos[3] + (math.random(-quantity,quantity) * z)})
				unit:RotateTowards(pos)
            else
                IssueMove({unit}, {oppoposition[1] + (math.random(-quantity,quantity) * x), oppoposition[2], oppoposition[3] + (math.random(-quantity,quantity) * z)})
            end
            unit.DeliveryThread = self.DeliveryThread
            unit:ForkThread(unit.DeliveryThread, self)
        end
        if self.SingleUse then
            self:ForkThread(self.AirUnitSurvivalCheckThread)
        end
    end,

    DeliveryThread = function(self, beacon)
        while not self.Dead do
            local orders = table.getn(self:GetCommandQueue())
            if orders > 1 then
                --Air Unit on the way
                coroutine.yield(50)
            elseif orders == 1 then
                coroutine.yield(100) 
				if beacon and beacon.SingleUse and not beacon.Dead then
                    beacon:Destroy()
                end
            elseif orders == 0 then
                -- Air Unit has arrived back at the edge of the map
                if beacon and beacon.SingleUse and not beacon.Dead then
                    beacon:Destroy()
                end
                coroutine.yield(100) --shouldn't matter, but just in case
            end
        end
    end,

    AirUnitSurvivalCheckThread = function(self)
        if self.SingleUse then --  double check just in case something called this and shouldn't have
            while not self.Dead do
                local KYS = true
                for i, tran in self.AirUnits do
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
            ArrivalatLocation = true,
        }
    },
]]
--------------------------------------------------------------------------------

local Quantity = nil

SetAirStrikeAmount = function(value)
	LOG(value)
	Quantity = value
end

CallAirStrikeBeacon = Class(AirStrikeBeacon) {


	--Quantity = GetAirStrikeAmount,

    SingleUse = true,

    ---@param self Unit

    OnStopBeingBuilt = function(self, builder, layer)
        AirStrikeBeacon.OnStopBeingBuilt(self, builder, layer)
			LOG('Quantity: ', Quantity)
        local bpR = (__blueprints[self.BpId] or self:GetBlueprint() ).Economy.Reinforcements
        self:CallAirStrike(bpR.Unit, Quantity, bpR.ExitOpposite)
		Quantity = 0
    end,
}

CallGroundAttackAirStrikeBeacon = Class(GroundAttackAirStrikeBeacon) {


	--Quantity = GetAirStrikeAmount,

    SingleUse = true,

    ---@param self Unit

    OnStopBeingBuilt = function(self, builder, layer)
        GroundAttackAirStrikeBeacon.OnStopBeingBuilt(self, builder, layer)
			LOG('Quantity: ', Quantity)
        local bpR = (__blueprints[self.BpId] or self:GetBlueprint() ).Economy.Reinforcements
        self:CallGroundAttackAirStrike(bpR.Unit, Quantity, bpR.ExitOpposite)
		Quantity = 0
    end,
}

CallTorpedoAirStrikeBeacon = Class(TorpedoAirStrikeBeacon) {


	--Quantity = GetAirStrikeAmount,

    SingleUse = true,

    ---@param self Unit

    OnStopBeingBuilt = function(self, builder, layer)
        TorpedoAirStrikeBeacon.OnStopBeingBuilt(self, builder, layer)
			LOG('Quantity: ', Quantity)
        local bpR = (__blueprints[self.BpId] or self:GetBlueprint() ).Economy.Reinforcements
        self:CallTorpedoAirStrike(bpR.Unit, Quantity, bpR.ExitOpposite)
		Quantity = 0
    end,
}

CallAirReinforcementBeacon = Class(AirReinforcementBeacon) {

    SingleUse = true,

    OnStopBeingBuilt = function(self, builder, layer)
        AirReinforcementBeacon.OnStopBeingBuilt(self, builder, layer)
        local bpR = (__blueprints[self.BpId] or self:GetBlueprint() ).Economy.Reinforcements
        self:CallAirReinforcement(bpR.Unit, bpR.Quantity, bpR.ArrivalatLocation)
    end,
}

CallAirDropT1andT2LandReinforcementBeacon = Class(AirDropT1andT2LandReinforcementBeacon) {

    SingleUse = true,

    OnStopBeingBuilt = function(self, builder, layer)
        AirDropT1andT2LandReinforcementBeacon.OnStopBeingBuilt(self, builder, layer)
        local bpR = (__blueprints[self.BpId] or self:GetBlueprint() ).Economy.Reinforcements
        self:CallAirDropT1andT2LandReinforcement(bpR.Unit, bpR.Quantity, bpR.ArrivalatLocation)
    end,
}

CallAirDropT3LandReinforcementBeacon = Class(AirDropT3LandReinforcementBeacon) {

    SingleUse = true,

    OnStopBeingBuilt = function(self, builder, layer)
        AirDropT3LandReinforcementBeacon.OnStopBeingBuilt(self, builder, layer)
        local bpR = (__blueprints[self.BpId] or self:GetBlueprint() ).Economy.Reinforcements
        self:CallAirDropT3LandReinforcement(bpR.Unit, bpR.Quantity, bpR.ArrivalatLocation)
    end,
}

CallAirDropNavalReinforcementBeacon = Class(AirDropNavalReinforcementBeacon) {

    SingleUse = true,

    OnStopBeingBuilt = function(self, builder, layer)
        AirDropNavalReinforcementBeacon.OnStopBeingBuilt(self, builder, layer)
        local bpR = (__blueprints[self.BpId] or self:GetBlueprint() ).Economy.Reinforcements
        self:CallAirDropNavalReinforcement(bpR.Unit, bpR.Quantity, bpR.ArrivalatLocation)
    end,
}

CallAirDropExperimentalReinforcementBeacon = Class(AirDropExperimentalReinforcementBeacon) {

    SingleUse = true,

    OnStopBeingBuilt = function(self, builder, layer)
        AirDropExperimentalReinforcementBeacon.OnStopBeingBuilt(self, builder, layer)
        local bpR = (__blueprints[self.BpId] or self:GetBlueprint() ).Economy.Reinforcements
        self:CallAirDropExperimentalReinforcement(bpR.Unit, bpR.Quantity, bpR.ArrivalatLocation)
    end,
}

CallPatrolGunshipBeacon = Class(PatrolGunshipAirStrikeBeacon) {

	--Quantity = GetAirStrikeAmount,

    SingleUse = true,
	

    OnStopBeingBuilt = function(self, builder, layer)
        PatrolGunshipAirStrikeBeacon.OnStopBeingBuilt(self, builder, layer)
		LOG('Quantity: ', Quantity)
        local bpR = (__blueprints[self.BpId] or self:GetBlueprint() ).Economy.Reinforcements
        self:CallPatrolGunship(bpR.Unit, Quantity, bpR.ArrivalatLocation)
		Quantity = 0
    end,
}