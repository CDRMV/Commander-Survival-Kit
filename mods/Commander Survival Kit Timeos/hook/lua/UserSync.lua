
local GetCSKPath = function() for i, mod in __active_mods do if mod.CSKProjectModName == "CSK" then return mod.location end end end
local CSKPath = GetCSKPath()
local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.CSKProjectModName == "CSK-Units" then return mod.location end end end
local CSKUnitsPath = GetCSKUnitsPath()
local GetFBPOrbitalPath = function() for i, mod in __active_mods do if mod.FBPProjectModName == "FBP-Orbital" then return mod.location end end end
local FBPOrbitalPath = GetFBPOrbitalPath()
local GetWaitTime=0	


local OldOnSync = OnSync
function OnSync()
	OldOnSync ()
	
	if Sync.Techlevel2 == true then
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').Techlevel:SetText('Tech 2')
	else
	
	end	
	
	if Sync.Techlevel3 == true then
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').Techlevel:SetText('Tech 3')
	else
	
	end	
	
	if Sync.Techlevel4 == true then
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').Techlevel:SetText('Elite')	
	else
	
	end	
	
	if Sync.Techlevel5 == true then
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').Techlevel:SetText('Experimental')
	else
	
	end	
	
	if Sync.Techlevel6 == true then
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').Techlevel:SetText('Hero')
	else
	
	end	
	
	if Sync.Techlevel7 == true then
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').Techlevel:SetText('Titan')
	else
	
	end		
	
	if Sync.T2WaitTime then
	SetWaitTimeText(Sync.T2WaitTime)
	end
	
	if Sync.T3WaitTime then
	SetWaitTimeText(Sync.T3WaitTime)
	end
	
	if Sync.TEXPWaitTime then
	SetWaitTimeText(Sync.TEXPWaitTime)
	end
	
	if Sync.TEliteWaitTime then
	SetWaitTimeText(Sync.TEliteWaitTime)
	end
	
	if Sync.THeroWaitTime then
	SetWaitTimeText(Sync.THeroWaitTime)
	end
	
	if Sync.TTitanWaitTime then
	SetWaitTimeText(Sync.TTitanWaitTime)
	end
	
	if Sync.ClosePanel == true then
	import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').Techlevel:SetText('')
	import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').WaitTime:SetText('')
	import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').HidePanel()
	end
	
end



function SetWaitTimeText(seconds)
    local MathFloor = math.floor
    local hours = MathFloor(seconds / 3600)
    seconds = seconds - hours * 3600
    local minutes = MathFloor(seconds / 60)
    seconds = MathFloor(seconds - minutes * 60)
    SetTime = ("%02d:%02d:%02d"):format(hours, minutes, seconds)
	import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').WaitTime:SetText(SetTime)
end

function SetWaitTimeText2(seconds)
	local MathFloor = math.floor
    local hours = MathFloor(seconds / 3600)
    seconds = seconds - hours * 3600
    local minutes = MathFloor(seconds / 60)
    seconds = MathFloor(seconds - minutes * 60)
    SetTime = ("%02d:%02d:%02d"):format(hours, minutes, seconds)
	import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').SetWaitTime(SetTime)
end


