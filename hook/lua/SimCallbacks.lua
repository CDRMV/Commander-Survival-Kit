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
	local clicklocationtemp = data.pos 
	local aiBrain = ArmyBrains[data.ArmyIndex] 
		LOG('X: ', clicklocationtemp[1])
	LOG('Y: ', clicklocationtemp[3])
	clicklocationtemp[1] = math.random(1, 10)
	clicklocationtemp[3] = math.random(1, 10)
	LOG('Unit ID: ', id)
	LOG('X: ', clicklocationtemp[1])
	LOG('Y: ', clicklocationtemp[3])
	LOG('GetFocusArmy: ', ArmyBrains[data.ArmyIndex])
	
	local spawnedUnit = aiBrain:CreateUnitNearSpot(id, clicklocationtemp[1], clicklocationtemp[3]) 
	
	end
	
	
end	


