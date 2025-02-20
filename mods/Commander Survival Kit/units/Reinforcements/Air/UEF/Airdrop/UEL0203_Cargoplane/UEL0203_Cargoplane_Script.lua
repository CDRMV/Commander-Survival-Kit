#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0304/UEA0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Strategic Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TIFSmallYieldNuclearBombWeapon = import('/lua/terranweapons.lua').TIFSmallYieldNuclearBombWeapon
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon

UEL0203_Cargoplane = Class(TAirUnit) {
    Weapons = {
		AntiAirMissileFlare = Class(TDFGaussCannonWeapon) {
		FxMuzzleFlashScale = 0.05,
		},
		DropFlare = Class(TDFGaussCannonWeapon) {
		FxMuzzleFlashScale = 0.05,
		},
        Bomb = Class(TIFSmallYieldNuclearBombWeapon) {
		
		OnWeaponFired = function(self)
		ForkThread( function()
		WaitSeconds(1)
		self.unit:GetWeaponByLabel'DropFlare':FireWeapon()
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
		
		local LandRefOrigin = import('/lua/defaultunits.lua').LandRefOrigin
		local PlayableArea = ScenarioInfo.MapData.PlayableRect
		
		if LandRefOrigin == 'North'  then
		
		position[3] = PlayableArea[2]


		elseif LandRefOrigin == 'East' then
		
		position[1] = PlayableArea[3]

		
		elseif LandRefOrigin == 'South' then
		
		position[3] = PlayableArea[4]

		
		elseif LandRefOrigin == 'West' then
		
		position[1] = PlayableArea[1]
		
		elseif LandRefOrigin == 'Random' then
		
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
		self.unit:GetWeaponByLabel'DropFlare':FireWeapon()
		IssueMove({self.unit}, self.unit.SpawnPosition)
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
		end,
		},
    },
	
	CheckAntiAirUnitsThread = function(self)
		while true do
		local Pos = self:GetPosition()
        while not self:IsDead() do
            local units = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.ANTIAIR,
			self:GetPosition(), 
			50,
			'Enemy'
			
			)
            for _,unit in units do
				self:GetWeaponByLabel'AntiAirMissileFlare':FireWeapon()
            end
            
            WaitSeconds(7)
        end
		WaitSeconds(1)
		end
    end,
	
	
	OnStopBeingBuilt = function(self,builder,layer)
	    TAirUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetWeaponEnabledByLabel('DropFlare', false)
		self.CheckAntiAirUnitsThreadHandle = self:ForkThread(self.CheckAntiAirUnitsThread)
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

TypeClass = UEL0203_Cargoplane
