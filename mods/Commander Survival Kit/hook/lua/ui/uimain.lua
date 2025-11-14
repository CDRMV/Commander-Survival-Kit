--[[
This hook is needed to Setup the correct Window Border Colors for the two Managers. 
Without that the Game will always use the default UEF Border Color on the Windows. 
A Restart of the Match was required to let the Game load the correct Border Colors for the Windows
The SetupUI Function has been modified to check, which Faction has been selected by the Player in the Game.prefs.lua
So the correct Skin will now be loaded correctly for the specif Faction, which fixes the Issue on my Windows.
The Version Check below is a just in Case Configuration to keep it compatible with all Game Versions if needed.
Changes on this Function in FAF and Loud can happen for whatever reason in the Future so make sense to Setup an Preparation
Currently all Game Versions are using the same SetupUI Function it seems. 
]]--

local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 
if DiskGetFileInfo('/lua/AI/CustomAIs_v2/ExtrasAI.lua') then
if import('/lua/AI/CustomAIs_v2/ExtrasAI.lua').AI.Name == 'AI Patch LOUD' not import('/lua/AI/CustomAIs_v2/ExtrasAI.lua').AI.Name == 'AI Patch (Duncane)' then

do	

-- Initialize the UI states on startup
function SetupUI()

    -- SetCursor needs to happen anytime this function is called because we
    -- could be switching lua states.
    local c = UIUtil.CreateCursor()
    SetCursor( c )

    -- the rest of this function only needs to run once to set up the globals, so
    -- don't do it again if not needed
    if alreadySetup then return end
    alreadySetup = true

    UIUtil.currentLayout = Prefs.GetFromCurrentProfile('layout') or 'bottom'
    local skin = Prefs.GetFromCurrentProfile('skin')
	local Gametype = SessionGetScenarioInfo().type
	if Gametype == 'campaign' then
	SelectedFaction = Prefs.GetFromCurrentProfile('last_faction')
	elseif Gametype == 'campaign_coop' or Gametype == 'skirmish' then
	SelectedFaction = Prefs.GetFromCurrentProfile('LastFaction')
	end
	if SelectedFaction == 1 then
	UIUtil.SetCurrentSkin('uef')
	elseif SelectedFaction == 2 then 
	UIUtil.SetCurrentSkin('aeon')
	elseif SelectedFaction == 3 then
	UIUtil.SetCurrentSkin('cybran')
	elseif SelectedFaction == 4 then
	UIUtil.SetCurrentSkin('seraphim')
	elseif SelectedFaction == 5 then
	UIUtil.SetCurrentSkin('nomads')
	else
	UIUtil.SetCurrentSkin(skin or 'uef')    -- default skin to start
	end

    UIUtil.consoleDepth = 5000000 -- no UI element should depth higher than this!
end
end

else
do
	

--* Initialize the UI states, this is always called on startup
function SetupUI()
    
    -- SetCursor needs to happen anytime this function is called because we
    -- could be switching lua states.
    local c = UIUtil.CreateCursor()
    SetCursor( c )

    -- the rest of this function only needs to run once to set up the globals, so 
    -- don't do it again if not needed
    if alreadySetup then return end
    alreadySetup = true

    UIUtil.currentLayout = Prefs.GetFromCurrentProfile('layout') or 'bottom'
    local skin = Prefs.GetFromCurrentProfile('skin')
	local Gametype = SessionGetScenarioInfo().type
	if Gametype == 'campaign' then
	SelectedFaction = Prefs.GetFromCurrentProfile('last_faction')
	elseif Gametype == 'campaign_coop' or Gametype == 'skirmish' then
	SelectedFaction = Prefs.GetFromCurrentProfile('LastFaction')
	end
	if SelectedFaction == 1 then
	UIUtil.SetCurrentSkin('uef')
	elseif SelectedFaction == 2 then 
	UIUtil.SetCurrentSkin('aeon')
	elseif SelectedFaction == 3 then
	UIUtil.SetCurrentSkin('cybran')
	elseif SelectedFaction == 4 then
	UIUtil.SetCurrentSkin('seraphim')
	elseif SelectedFaction == 5 then
	UIUtil.SetCurrentSkin('nomads')
	else
	UIUtil.SetCurrentSkin(skin or 'uef')    -- default skin to start
	end

    UIUtil.consoleDepth = 5000000 -- no UI element should depth higher than this!
end

end
end

else

do
	

--* Initialize the UI states, this is always called on startup
function SetupUI()
    
    -- SetCursor needs to happen anytime this function is called because we
    -- could be switching lua states.
    local c = UIUtil.CreateCursor()
    SetCursor( c )

    -- the rest of this function only needs to run once to set up the globals, so 
    -- don't do it again if not needed
    if alreadySetup then return end
    alreadySetup = true

    UIUtil.currentLayout = Prefs.GetFromCurrentProfile('layout') or 'bottom'
    local skin = Prefs.GetFromCurrentProfile('skin')
	local Gametype = SessionGetScenarioInfo().type
	if Gametype == 'campaign' then
	SelectedFaction = Prefs.GetFromCurrentProfile('last_faction')
	elseif Gametype == 'campaign_coop' or Gametype == 'skirmish' then
	SelectedFaction = Prefs.GetFromCurrentProfile('LastFaction')
	end
	if SelectedFaction == 1 then
	UIUtil.SetCurrentSkin('uef')
	elseif SelectedFaction == 2 then 
	UIUtil.SetCurrentSkin('aeon')
	elseif SelectedFaction == 3 then
	UIUtil.SetCurrentSkin('cybran')
	elseif SelectedFaction == 4 then
	UIUtil.SetCurrentSkin('seraphim')
	elseif SelectedFaction == 5 then
	UIUtil.SetCurrentSkin('nomads')
	else
	UIUtil.SetCurrentSkin(skin or 'uef')    -- default skin to start
	end

    UIUtil.consoleDepth = 5000000 -- no UI element should depth higher than this!
end

end

end

else

do	

--* Initialize the UI states, this is always called on startup
function SetupUI()

    -- SetCursor needs to happen anytime this function is called because we
    -- could be switching lua states.
    local c = UIUtil.CreateCursor()
    SetCursor( c )

    -- the rest of this function only needs to run once to set up the globals, so 
    -- don't do it again if not needed
    if alreadySetup then return end
    alreadySetup = true

    UIUtil.currentLayout = Prefs.GetFromCurrentProfile('layout') or 'bottom'
    local skin = Prefs.GetFromCurrentProfile('skin')
	local Gametype = SessionGetScenarioInfo().type
	if Gametype == 'campaign' then
	SelectedFaction = Prefs.GetFromCurrentProfile('last_faction')
	elseif Gametype == 'campaign_coop' or Gametype == 'skirmish' then
	SelectedFaction = Prefs.GetFromCurrentProfile('LastFaction')
	end
	if SelectedFaction == 1 then
	UIUtil.SetCurrentSkin('uef')
	elseif SelectedFaction == 2 then 
	UIUtil.SetCurrentSkin('aeon')
	elseif SelectedFaction == 3 then
	UIUtil.SetCurrentSkin('cybran')
	elseif SelectedFaction == 4 then
	UIUtil.SetCurrentSkin('seraphim')
	elseif SelectedFaction == 5 then
	UIUtil.SetCurrentSkin('nomads')
	else
	UIUtil.SetCurrentSkin(skin or 'uef')    -- default skin to start
	end

    UIUtil.consoleDepth = 5000000 -- no UI element should depth higher than this!

end

end

end
