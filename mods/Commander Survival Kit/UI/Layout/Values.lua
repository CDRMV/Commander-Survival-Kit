CurrentReinforcementPoints = 0
CurrentTacticalPoints = 0
ReinforcementPointStorage = 0
TacticalPointStorage = 0
CSKManagerNumber = 0

function GetCSKManagerNumberValue(Value)
CSKManagerNumber = Value
end

HQComCenterDetected = false
RefCenterDetected = false
TACCenterDetected = false
RefPointStorageDetected = false
TACPointStorageDetected = false

function TacticalPointStorageHandle(Value)
TacticalPointStorage = Value
end

function ReinforcementPointStorageHandle(Value)
ReinforcementPointStorage = Value
end

function CurrentReinforcementPointsHandle(Value)
CurrentReinforcementPoints = Value
LOG('CurrentReinforcementPoints: ', CurrentReinforcementPoints)
end

function CurrentTacticalPointsHandle(Value)
CurrentTacticalPoints = Value
CheckforCurrentTacticalPointsHandle(CurrentTacticalPoints)
LOG('CurrentTacticalPoints: ', CurrentTacticalPoints)
end

function GetCurrentTacticalPointsHandle(Value)
CurrentTacticalPoints2 = Value
LOG('CurrentTacticalPoints: ', CurrentTacticalPoints2)
end

