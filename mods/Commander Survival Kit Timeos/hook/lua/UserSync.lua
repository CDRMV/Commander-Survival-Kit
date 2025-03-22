
local Prefs = import("/lua/user/prefs.lua")
local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.uid == "5t3edt-btz6-9437-h6ui-967gt56facsku120" then return mod.location end end end
local CSKUnitsPath = GetCSKUnitsPath()
local GetFBPOPath = function() for i, mod in __active_mods do if mod.uid == "5t3edt-btz6-9437-h6ui-967gt56fa5" then return mod.location end end end
local FBPOPath = GetFBPOPath()
local GetWaitTime=0	


local OldOnSync = OnSync
function OnSync()
	OldOnSync ()
	
	if Sync.Techlevel2 == true then
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').Techlevel:SetText('Tech 2')
		Prefs.SetToCurrentProfile('UnlockedTechlevel', 1)
	else
	
	end	
	
	if Sync.Techlevel3 == true then
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').Techlevel:SetText('Tech 3')
		Prefs.SetToCurrentProfile('UnlockedTechlevel', 2)
	else
	
	end	
	
	if Sync.Techlevel4 == true then
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').Techlevel:SetText('Elite')
		Prefs.SetToCurrentProfile('UnlockedTechlevel', 3)
		
	else
	
	end	
	
	if Sync.Techlevel5 == true then
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').Techlevel:SetText('Experimental')
		Prefs.SetToCurrentProfile('UnlockedTechlevel', 4)
	else
	
	end	
	
	if Sync.Techlevel6 == true then
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').Techlevel:SetText('Hero')
		Prefs.SetToCurrentProfile('UnlockedTechlevel', 5)
	else
	
	end	
	
	if Sync.Techlevel7 == true then
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').Techlevel:SetText('Titan')
		Prefs.SetToCurrentProfile('UnlockedTechlevel', 6)
	else
	
	end	
	
	if Sync.Techlevel8 == true then
		Prefs.SetToCurrentProfile('UnlockedTechlevel', 7)
	else
	
	end	
	
	if Sync.T2WaitTime then
	SetWaitTimeText(Sync.T2WaitTime)
	Prefs.SetToCurrentProfile('UnlockedWaitTime', Sync.T2WaitTime)
	end
	
	if Sync.T3WaitTime then
	SetWaitTimeText(Sync.T3WaitTime)
	Prefs.SetToCurrentProfile('UnlockedWaitTime', Sync.T3WaitTime)
	end
	
	if Sync.TEXPWaitTime then
	SetWaitTimeText(Sync.TEXPWaitTime)
	Prefs.SetToCurrentProfile('UnlockedWaitTime', Sync.TEXPWaitTime)
	end
	
	if Sync.TEliteWaitTime then
	SetWaitTimeText(Sync.TEliteWaitTime)
	Prefs.SetToCurrentProfile('UnlockedWaitTime', Sync.TEliteWaitTime)
	end
	
	if Sync.THeroWaitTime then
	SetWaitTimeText(Sync.THeroWaitTime)
	Prefs.SetToCurrentProfile('UnlockedWaitTime', Sync.THeroWaitTime)
	end
	
	if Sync.TTitanWaitTime then
	SetWaitTimeText(Sync.TTitanWaitTime)
	Prefs.SetToCurrentProfile('UnlockedWaitTime', Sync.TTitanWaitTime)
	end
	

	
	if Sync.LoadTechlevel == true then
	if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
	local UnlockedTechlevel = Prefs.GetFromCurrentProfile('UnlockedTechlevel')
	LOG('Sync.LoadTechlevel: ', Sync.LoadTechlevel)
	LOG('UnlockedTechlevel: ', UnlockedTechlevel)
	if UnlockedTechlevel == 1 then
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').SetTechlevel('Tech 2')
		SetWaitTimeText2(Prefs.GetFromCurrentProfile('UnlockedWaitTime'))
	elseif UnlockedTechlevel == 2 then	
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').SetTechlevel('Tech 3')
		SetWaitTimeText2(Prefs.GetFromCurrentProfile('UnlockedWaitTime'))
	elseif UnlockedTechlevel == 3 then	
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').SetTechlevel('Experimental')
		SetWaitTimeText2(Prefs.GetFromCurrentProfile('UnlockedWaitTime'))
	elseif UnlockedTechlevel == 4 then	
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').SetTechlevel('Elite')
		SetWaitTimeText2(Prefs.GetFromCurrentProfile('UnlockedWaitTime'))
	elseif UnlockedTechlevel == 5 then	
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').SetTechlevel('Hero')
		SetWaitTimeText2(Prefs.GetFromCurrentProfile('UnlockedWaitTime'))
	elseif UnlockedTechlevel == 6 then	
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').SetTechlevel('Titan')
		SetWaitTimeText2(Prefs.GetFromCurrentProfile('UnlockedWaitTime'))
	elseif UnlockedTechlevel == 7 then	
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').SetTechlevel('')
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').SetWaitTime('')
	end
	
	else
	local UnlockedTechlevel = Prefs.GetFromCurrentProfile('UnlockedTechlevel')
	LOG('Sync.LoadTechlevel: ', Sync.LoadTechlevel)
	LOG('UnlockedTechlevel: ', UnlockedTechlevel)
	if UnlockedTechlevel == 1 then
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').SetTechlevel('Tech 2')
		SetWaitTimeText2(Prefs.GetFromCurrentProfile('UnlockedWaitTime'))
	elseif UnlockedTechlevel == 2 then	
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').SetTechlevel('Tech 3')
		SetWaitTimeText2(Prefs.GetFromCurrentProfile('UnlockedWaitTime'))
	elseif UnlockedTechlevel == 3 then	
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').SetTechlevel('Experimental')
		SetWaitTimeText2(Prefs.GetFromCurrentProfile('UnlockedWaitTime'))
	elseif UnlockedTechlevel == 4 then	
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').SetTechlevel('')
		import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').SetWaitTime('')
	end
	end
	
	else
	
	end
	
	if Sync.ClosePanel == true then
	import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').Techlevel:SetText('')
	import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').WaitTime:SetText('')
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


