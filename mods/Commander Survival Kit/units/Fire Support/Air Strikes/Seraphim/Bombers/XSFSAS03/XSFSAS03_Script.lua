#****************************************************************************
#**
#**  File     :  /units/XSA0304/XSA0304_script.lua
#**  Author(s):  Drew Staltman, Greg Kohne, Gordon Duclos
#**
#**  Summary  :  Seraphim Strategic Bomber Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SAirUnit = import('/lua/defaultunits.lua').AirUnit
local SIFBombZhanaseeWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon
local AirStrikeMechanic = ScenarioInfo.Options.AirStrikeMechanic

XSFSAS03 = Class(SAirUnit) {
    Weapons = {
        Bomb = Class(SIFBombZhanaseeWeapon) {
		OnWeaponFired = function(self)
		if AirStrikeMechanic == 1 or Sync.AirStrikeMechanic == true  then
		
		else
		ForkThread( function()
		WaitSeconds(1)
		IssueClearCommands({self.unit})
		self.unit:RemoveCommandCap('RULEUCC_Attack')
		self.unit:RemoveCommandCap('RULEUCC_RetaliateToggle')
		local pos = self.unit.CachePosition or self.unit:GetPosition()
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

		local position = self.unit.GetNearestPlayablePoint(self.unit,BorderPos)
		local oppoposition = self.unit.GetNearestPlayablePoint(self.unit,OppBorPos)
		self.unit.SpawnPosition = position
		IssueMove({self.unit}, self.unit.SpawnPosition)
		self:SetEnabled(false)
        while not self.unit.Dead do
            local orders = table.getn(self.unit:GetCommandQueue())
            if orders > 1 then

            elseif orders == 1 then
            elseif orders == 0 then
				self.unit:Destroy()
            end
		WaitSeconds(1)	
        end
		end
        )
		end
		end,
		},
    },
	
	GetPlayableArea = function()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
	end,

	GetNearestPlayablePoint = function(self,position)

    local px, _, pz = unpack(position)
	
	if ScenarioInfo.type == 'campaign' then
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
local playableArea = self.GetPlayableArea()
if playableArea[1] == 0 and playableArea[2] == 0 then
return position
else

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
end	
	else
	return position
	end
end,
}
TypeClass = XSFSAS03