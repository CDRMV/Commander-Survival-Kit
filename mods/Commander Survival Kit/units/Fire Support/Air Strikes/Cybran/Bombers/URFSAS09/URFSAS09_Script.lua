#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0304/UEA0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Strategic Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CAirUnit = import('/lua/defaultunits.lua').AirUnit
local TIFSmallYieldNuclearBombWeapon = import('/lua/terranweapons.lua').TIFSmallYieldNuclearBombWeapon
local CWeapons = import('/lua/cybranweapons.lua')
local CDFHeavyDisintegratorWeapon = CWeapons.CDFLaserDisintegratorWeapon02
local AirStrikeMechanic = ScenarioInfo.Options.AirStrikeMechanic

URFSAS09 = Class(CAirUnit) {
    Weapons = {
        Bomb = Class(TIFSmallYieldNuclearBombWeapon) {
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
		
		local AirStrikeOrigin = import('/lua/defaultunits.lua').AirStrikeOrigin
		local PlayableArea = ScenarioInfo.MapData.PlayableRect
		
		if AirStrikeOrigin == 'North'  then
		
		position[3] = PlayableArea[2]


		elseif AirStrikeOrigin == 'East' then
		
		position[1] = PlayableArea[3]

		
		elseif AirStrikeOrigin == 'South' then
		
		position[3] = PlayableArea[4]

		
		elseif AirStrikeOrigin == 'West' then
		
		position[1] = PlayableArea[1]
		
		elseif AirStrikeOrigin == 'Random' then
		
		local Random = math.random(4)
		
		if Random == 1 then 
		position[3] = PlayableArea[2]
		elseif Random == 2 then
		position[1] = PlayableArea[3]
		elseif Random == 3 then
		position[3] = PlayableArea[4]
		elseif Random == 4 then
		position[1] = PlayableArea[1]
		end
		
		end
		
		
		self.unit.SpawnPosition = position
		IssueMove({self.unit}, self.unit.SpawnPosition)
        while not self.unit.Dead do
		self:SetEnabled(false)
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
        AARailGun1 = Class(CDFHeavyDisintegratorWeapon) {},
        AARailGun1 = Class(CDFHeavyDisintegratorWeapon) {},
    },
	
	OnCreate = function(self)
        CAirUnit.OnCreate(self)
		if AirStrikeMechanic == 1 or Sync.AirStrikeMechanic == true  then
		local wep = self:GetWeaponByLabel('Bomb')
        wep:SetTargetingPriorities({
                'SPECIALHIGHPRI',
                'SPECIALLOWPRI',
                'ALLUNITS',
            })
		else

		end
    end,
	
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

TypeClass = URFSAS09
