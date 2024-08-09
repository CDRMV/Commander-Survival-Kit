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


Callbacks.SpawnFireSupport = function(data, units)
	local id = data.id
	
	if id == nil then 

	else
	local clicklocationtemp = data.pos 
	local ArmyIndex = ArmyBrains[data.ArmyIndex] 
	
	LOG('Unit ID: ', id)
	LOG('Klick Position: ', clicklocationtemp)
	LOG('GetFocusArmy: ', ArmyIndex)
	local spawnedUnit = nil
	spawnedUnit = ArmyIndex:CreateUnitNearSpot(id, clicklocationtemp[1], clicklocationtemp[3]) 

	end
end	



