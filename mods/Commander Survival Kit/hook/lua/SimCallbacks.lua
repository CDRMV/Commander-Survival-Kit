----
----
----
----
----
----
----
----
----
----
--[[
Callbacks.SpawnReinforcements = function(data, units)
	local id = data.id
	
	if id == nil then 

	else
	local randomnumberx = math.random(1,10)
	local randomnumberz = math.random(1,10)
	local quantity = data.Quantity
	local x = data.X
	local z = data.Z
	local BorderPos = data.pos 
	local aiBrain = ArmyBrains[data.ArmyIndex] 
		LOG('X: ', BorderPos[1])
	LOG('Y: ', BorderPos[3])
	LOG('Unit ID: ', id)
	LOG('X: ', BorderPos[1])
	LOG('Y: ', BorderPos[3])
	LOG('GetFocusArmy: ', ArmyBrains[data.ArmyIndex])
	
	local spawnedUnit = aiBrain:CreateUnitNearSpot(id, BorderPos[1] + (randomnumberx * x), BorderPos[3] + (randomnumberz * z)) 
	end
	
end	
]]--


Callbacks.SpawnFireSupportBeam = function(data, units)
	local id = data.id
	
	if id == nil then 

	else
	local clicklocationtemp = data.pos 
	local ArmyIndex = ArmyBrains[data.ArmyIndex] 
	local Immobile = data.Immobile
	local price = data.price 
	LOG('Unit ID: ', id)
	LOG('Price: ', price)
	LOG('Klick Position: ', clicklocationtemp)
	LOG('GetFocusArmy: ', ArmyIndex)
	LOG('Immobile: ', Immobile)
	
	if GetArmyUnitCostTotal(data.ArmyIndex) == GetArmyUnitCap(data.ArmyIndex) then
	LOG('Unit Cap Reached')
	Sync.FSUnitCapReached = price
	else
	local Beam = nil
	Beam = ArmyIndex:CreateUnitNearSpot(id, clicklocationtemp[1], clicklocationtemp[3]) 
	Beam:SetImmobile(Immobile)
	end
	end
end

Callbacks.SpawnFireSupport = function(data, units)
	local id = data.id
	
	if id == nil then 

	else
	local clicklocationtemp = data.pos 
	local ArmyIndex = ArmyBrains[data.ArmyIndex] 
	local price = data.price 
	LOG('Unit ID: ', id)
	LOG('Price: ', price)
	LOG('Klick Position: ', clicklocationtemp)
	LOG('GetFocusArmy: ', ArmyIndex)
	
	if GetArmyUnitCostTotal(data.ArmyIndex) == GetArmyUnitCap(data.ArmyIndex) then
	LOG('Unit Cap Reached')
	Sync.FSUnitCapReached = price
	else
	local Barrage = nil
	Barrage = ArmyIndex:CreateUnitNearSpot(id, clicklocationtemp[1], clicklocationtemp[3]) 
	Barrage:SetImmobile(true)
	end
	end
end	

Callbacks.SpawnReinforcements = function(data, units)
	local id = data.id
	
	if id == nil then 

	else
	local clicklocationtemp = data.pos 
	local ArmyIndex = ArmyBrains[data.ArmyIndex] 
	local price = data.price 
	LOG('Unit ID: ', id)
	LOG('Price: ', price)
	LOG('Klick Position: ', clicklocationtemp)
	LOG('GetFocusArmy: ', ArmyIndex)    
	if GetArmyUnitCostTotal(data.ArmyIndex) == GetArmyUnitCap(data.ArmyIndex) then
	LOG('Unit Cap Reached')
	Sync.RefUnitCapReached = price
	else
	local RefUnit = nil
	RefUnit = ArmyIndex:CreateUnitNearSpot(id, clicklocationtemp[1], clicklocationtemp[3]) 
	end
	end
end	

Callbacks.SpawnUEFReinforcements = function(data, units)
	local id = data.id
	 local Rotation = nil 
	if id == nil then 

	else
	local clicklocationtemp = data.pos 
	local ArmyIndex = ArmyBrains[data.ArmyIndex] 
	local price = data.price 
	local AirRefOrigin = data.origin
	LOG('Unit ID: ', id)
	LOG('Price: ', price)
	LOG('Klick Position: ', clicklocationtemp)
	LOG('GetFocusArmy: ', ArmyIndex)    
	
	LOG('AirRefOrigin: ', AirRefOrigin)

	if AirRefOrigin == 'North' then
	Rotation = 0
	end
	
	
	if AirRefOrigin == 'East' then
	Rotation = -90
	end
	
	
	if AirRefOrigin == 'South' then
	Rotation = -180
	end
	
	
	if AirRefOrigin == 'West' then
	Rotation = -270
	end
	
	if AirRefOrigin == 'Random' then
	Rotation = 0
	end
	
	if GetArmyUnitCostTotal(data.ArmyIndex) == GetArmyUnitCap(data.ArmyIndex) then
	LOG('Unit Cap Reached')
	Sync.RefUnitCapReached = price
	else
	local UEFRefUnit = nil
	UEFRefUnit = CreateUnit2(id, data.ArmyIndex, 'Land', clicklocationtemp[1], clicklocationtemp[3], Rotation)
	end
	end
end	


Callbacks.SpawnAirReinforcements = function(data, units)
	local id = data.id
	 local Rotation = nil 
	if id == nil then 

	else
	local clicklocationtemp = data.pos 
	local ArmyIndex = ArmyBrains[data.ArmyIndex] 
	local price = data.price 
	local AirRefOrigin = data.origin
	LOG('Unit ID: ', id)
	LOG('Price: ', price)
	LOG('Klick Position: ', clicklocationtemp)
	LOG('GetFocusArmy: ', ArmyIndex)    
	
	LOG('AirRefOrigin: ', AirRefOrigin)

	if AirRefOrigin == 'North' then
	Rotation = 0
	end
	
	
	if AirRefOrigin == 'East' then
	Rotation = -90
	end
	
	
	if AirRefOrigin == 'South' then
	Rotation = -180
	end
	
	
	if AirRefOrigin == 'West' then
	Rotation = -270
	end
	
	if AirRefOrigin == 'Random' then
	Rotation = 0
	end
	
	if GetArmyUnitCostTotal(data.ArmyIndex) == GetArmyUnitCap(data.ArmyIndex) then
	LOG('Unit Cap Reached')
	Sync.RefUnitCapReached = price
	else
	local AirRefUnit = nil
	AirRefUnit = CreateUnit2(id, data.ArmyIndex, 'Land', clicklocationtemp[1], clicklocationtemp[3], Rotation)
	end
	end
end	

Callbacks.SpawnDropTurretorDevice = function(data, units)
	local id = data.id
	
	if id == nil then 

	else
	local clicklocationtemp = data.pos 
	local ArmyIndex = ArmyBrains[data.ArmyIndex] 
	local price = data.price 
	LOG('Unit ID: ', id)
	LOG('Price: ', price)
	LOG('Klick Position: ', clicklocationtemp)
	LOG('GetFocusArmy: ', ArmyIndex)
	if GetArmyUnitCostTotal(data.ArmyIndex) == GetArmyUnitCap(data.ArmyIndex) then
	LOG('Unit Cap Reached')
	Sync.DropUnitCapReached = price
	else
	local DropDefenseUnit = nil
	DropDefenseUnit = ArmyIndex:CreateUnitNearSpot(id, clicklocationtemp[1], clicklocationtemp[3]) 
	end
	end
end	

Callbacks.SpawnAirDropTurretorDevice = function(data, units)
	local id = data.id
	 local Rotation = nil 
	if id == nil then 

	else
	local clicklocationtemp = data.pos 
	local ArmyIndex = ArmyBrains[data.ArmyIndex] 
	local price = data.price 
	local DropOrigin = data.origin
	LOG('Unit ID: ', id)
	LOG('Price: ', price)
	LOG('Klick Position: ', clicklocationtemp)
	LOG('GetFocusArmy: ', ArmyIndex)
	LOG('DropOrigin: ', DropOrigin)

	if DropOrigin == 'North' then
	Rotation = 0
	end
	
	
	if DropOrigin == 'East' then
	Rotation = -90
	end
	
	
	if DropOrigin == 'South' then
	Rotation = -180
	end
	
	
	if DropOrigin == 'West' then
	Rotation = -270
	end
	
	if DropOrigin == 'Random' then
	Rotation = 0
	end
	
	if GetArmyUnitCostTotal(data.ArmyIndex) == GetArmyUnitCap(data.ArmyIndex) then
	LOG('Unit Cap Reached')
	Sync.DropUnitCapReached = price
	else
	local AirDropDefenseUnit = nil
	AirDropDefenseUnit = CreateUnit2(id, data.ArmyIndex, 'Land', clicklocationtemp[1], clicklocationtemp[3], Rotation)
	end
	end
end	

Callbacks.SpawnAirStrike = function(data, units)
	
    local Rotation = nil 
	local id = data.id
	
	if id == nil then 

	else
	local clicklocationtemp = data.pos 
	local ArmyIndex = ArmyBrains[data.ArmyIndex] 
	local Amount = data.amount
	local price = data.price 
	local AirStrikeOrigin = data.origin
	import("/lua/defaultunits.lua").SetAirStrikeAmount(Amount)
	LOG('Unit ID: ', id)
	LOG('Price: ', price)
	LOG('Klick Position: ', clicklocationtemp)
	LOG('GetFocusArmy: ', ArmyIndex)
	LOG('AirStrikeOrigin: ', AirStrikeOrigin)

	if AirStrikeOrigin == 'North' then
	Rotation = 0
	end
	
	
	if AirStrikeOrigin == 'East' then
	Rotation = -90
	end
	
	
	if AirStrikeOrigin == 'South' then
	Rotation = -180
	end
	
	
	if AirStrikeOrigin == 'West' then
	Rotation = -270
	end
	
	if AirStrikeOrigin == 'Random' then
	Rotation = 0
	end
	
	if GetArmyUnitCostTotal(data.ArmyIndex) == GetArmyUnitCap(data.ArmyIndex) then
	LOG('Unit Cap Reached')
	Sync.FSUnitCapReached = price
	else
	local AirStrikeUnit = nil
	AirStrikeUnit = CreateUnit2(id, data.ArmyIndex, 'Land', clicklocationtemp[1], clicklocationtemp[3], Rotation)
	end
	end
end	








