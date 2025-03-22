----directory----

local GetCSKTutorialsPath = function() for i, mod in __active_mods do if mod.uid == "5t3edt-btz6-9437-h6ui-967gt56fa8118TUT" then return mod.location end end end
local CSKTutorialsPath = GetCSKTutorialsPath()

local path = '/mods/Commander Survival Kit/UI/'
local helpcenter = import(path .. 'Helpcenter.lua').UI
----significant operators imported from external sources----
local CreateText = import('/lua/maui/text.lua').Text 
local CreateWindow = import('/lua/maui/window.lua').Window
local UIUtil = import('/lua/ui/uiutil.lua')
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local LayoutHelpers = import("/lua/maui/layouthelpers.lua")
local factions = import('/lua/factions.lua').Factions
local RefUI = import(path .. 'Helpcenter.lua').RefUI
local FSUI = import(path .. 'Helpcenter.lua').FSUI
local FSUI2 = import(path .. 'Helpcenter.lua').FSUI2
local MovieUI = import(path .. 'HelpcenterMovie.lua').UI

local Tooltip = import("/lua/ui/game/tooltip.lua")

local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	
local Gametype = SessionGetScenarioInfo().type
local LandRefInclude = SessionGetScenarioInfo().Options.LandRefInclude
local AirRefInclude = SessionGetScenarioInfo().Options.AirRefInclude
local NavalRefInclude = SessionGetScenarioInfo().Options.NavalRefInclude
local SpaceRefInclude = SessionGetScenarioInfo().Options.SpaceRefInclude

local RefCampaignOptions = {}

function GetRefCampaignOptions(Array)
RefCampaignOptions = Array
end


local landbuttonpress = 0
local airbuttonpress = 0
local navalbuttonpress = 0
local spacebuttonpress = 0
 
local buttonpress = 1
 
function Gethelpbuttonpress(Value)
buttonpress = Value
end

function Getlandbuttonpress(Value)
landbuttonpress = Value
end

function Getairbuttonpress(Value)
airbuttonpress = Value
end

function Getnavalbuttonpress(Value)
navalbuttonpress = Value
end

function Getspacebuttonpress(Value)
spacebuttonpress = Value
end

local GetFBPOPath = function() for i, mod in __active_mods do if mod.uid == "5t3edt-btz6-9437-h6ui-967gt56fa5" then return mod.location end end end
local FBPOPath = GetFBPOPath()
----parameters----
local Border = {
        tl = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_ul.dds'),
        tr = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_ur.dds'),
        tm = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_horz_um.dds'),
        ml = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_vert_l.dds'),
        m = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_m.dds'),
        mr = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_vert_r.dds'),
        bl = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_ll.dds'),
        bm = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_lm.dds'),
        br = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_lr.dds'),
        borderColor = 'ff415055',
}
	
local Position = {
	Left = 20, 
	Top = 220, 
	Bottom = 320, 
	Right = 335
}

local TextPosition = {
	Left = 40, 
	Top = 245, 
	Bottom = 265, 
	Right = 240
}

local TextPosition2 = {
	Left = 40, 
	Top = 261, 
	Bottom = 381, 
	Right = 240
}

local ButtonPosition = {
	Left = 255, 
	Top = 235, 
	Bottom = 285, 
	Right = 325
}



   
----actions----
UI = CreateWindow(GetFrame(0),'<LOC RefManager>Reinforcement Manager',nil,false,false,true,true,'Reinforcements',Position,Border) 
local button
if focusarmy >= 1 then
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
		button = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "<LOC Help>Help", 11, -8, -64)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		button = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "<LOC Help>Help", 11, -8, -64)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		button = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "<LOC Help>Help", 11, -8, -64)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		button = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "<LOC Help>Help", 11, -8, -64)
	end
end



--#################################################################### 

-- Reinforcement Layer Button Definitions

--#################################################################### 



LBTNUI = CreateWindow(UI,nil,nil,false,false,true,true,'Construction',Position,Border) 

local LayerUIPosition = {
	Left = 40, 
	Top = 280, 
	Bottom = 320, 
	Right = 315
}  

local LandBTNPosition = {
	Left = 45, 
	Top = 282, 
	Bottom = 315, 
	Right = 110
}  


local AirBTNPosition = {
	Left = 110, 
	Top = 282, 
	Bottom = 315, 
	Right = 175
}  

local NavalBTNPosition = {
	Left = 175, 
	Top = 282, 
	Bottom = 315, 
	Right = 240
}  

local SpaceBTNPosition = {
	Left = 240, 
	Top = 282, 
	Bottom = 315, 
	Right = 310
}  

for i, v in LayerUIPosition do 
	LBTNUI[i]:Set(v)
end

LBTNUI:Hide() 
LBTNUI._closeBtn:Hide()

local LandButton
local AirButton
local NavalButton
local SpaceButton

if focusarmy >= 1 then
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
		LandButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "<LOC Land>Land", 11, -20, -67)
		AirButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "<LOC Air>Air", 11, -20, -67)
		NavalButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "<LOC Naval>Naval", 11, -20, -67)
		SpaceButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "<LOC Space>Space", 11, -20, -67)
			
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LandButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "<LOC Land>Land", 11, -20, -67)
		AirButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "<LOC Air>Air", 11, -20, -67)
		NavalButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "<LOC Naval>Naval", 11, -20, -67)
		SpaceButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "<LOC Space>Space", 11, -20, -67)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LandButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "<LOC Land>Land", 11, -20, -67)
		AirButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "<LOC Air>Air", 11, -20, -67)
		NavalButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "<LOC Naval>Naval", 11, -20, -67)
		SpaceButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "<LOC Space>Space", 11, -20, -67)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LandButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "<LOC Land>Land", 11, -20, -67)
		AirButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "<LOC Air>Air", 11, -20, -67)
		NavalButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "<LOC Naval>Naval", 11, -20, -67)
		SpaceButton = UIUtil.CreateButtonStd(LBTNUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "<LOC Space>Space", 11, -20, -67)
	end
end

LayoutHelpers.DepthOverParent(LandButton, LBTNUI, 30)
LayoutHelpers.DepthOverParent(AirButton, LBTNUI, 30)
LayoutHelpers.DepthOverParent(NavalButton, LBTNUI, 30)
LayoutHelpers.DepthOverParent(SpaceButton, LBTNUI, 30)

for i, v in LandBTNPosition do 
	LandButton[i]:Set(v)
end

for i, v in AirBTNPosition do 
	AirButton[i]:Set(v)
end

for i, v in NavalBTNPosition do 
	NavalButton[i]:Set(v)
end

for i, v in SpaceBTNPosition do 
	SpaceButton[i]:Set(v)
end

ForkThread(
	function()
if Gametype == 'skirmish' then
if LandRefInclude == 1 then

else
HideLandRefButton()
end
elseif Gametype == 'campaign_coop' then
if LandRefInclude == 1 then

else
HideLandRefButton()
end
else 
while true do
if RefCampaignOptions == nil then

else

if RefCampaignOptions[2] == 1 then

break
elseif RefCampaignOptions[2] == 2 then
HideLandRefButton()

break
else

end
end
WaitSeconds(0.1)
end
end
end
)

ForkThread(
	function()
if Gametype == 'skirmish' then
if AirRefInclude == 1 then

else
HideAirRefButton()
end
elseif Gametype == 'campaign_coop' then
if AirRefInclude == 1 then

else
HideAirRefButton()
end
else
while true do
if RefCampaignOptions == nil then

else

if RefCampaignOptions[3] == 1 then

break
elseif RefCampaignOptions[3] == 2 then
HideAirRefButton()

break
else

end
end
WaitSeconds(0.1)
end
end
end
)

ForkThread(
	function()
if Gametype == 'skirmish' then
if NavalRefInclude == 1 then

else
HideNavalRefButton()
end
elseif Gametype == 'campaign_coop' then
if NavalRefInclude == 1 then

else
HideNavalRefButton()
end
else
while true do
if RefCampaignOptions == nil then

else

if RefCampaignOptions[4] == 1 then

break
elseif RefCampaignOptions[4] == 2 then
HideNavalRefButton()

break
else

end
end
WaitSeconds(0.1)
end
end
end
)

ForkThread(
	function()
if Gametype == 'skirmish' then
if SpaceRefInclude == 1 then

else
HideSpaceRefButton()
end
else
HideSpaceRefButton()
end
end
)

HideLandRefButton = function()
ForkThread(
	function()
	while true do
LayoutHelpers.DepthOverParent(LandButton, LBTNUI, 0)
WaitSeconds(0.01)
end
end
)
end

HideAirRefButton = function()
ForkThread(
	function()
	while true do
LayoutHelpers.DepthOverParent(AirButton, LBTNUI, 0)
WaitSeconds(0.01)
end
end
)
end

HideNavalRefButton = function()
ForkThread(
	function()
	while true do
LayoutHelpers.DepthOverParent(NavalButton, LBTNUI, 0)
WaitSeconds(0.01)
end
end
)
end

HideSpaceRefButton = function()
ForkThread(
	function()
	while true do
LayoutHelpers.DepthOverParent(SpaceButton, LBTNUI, 0)
WaitSeconds(0.01)
end
end
)
end


LandButton.OnClick = function(self)
		landbuttonpress = landbuttonpress + 1
		if landbuttonpress == 1 then
		UI:SetTitle('<LOC LandRefManager>Land Reinforcement Manager')
		airbuttonpress = 0
		navalbuttonpress = 0
		spacebuttonpress = 0
		if FBPOPath then
		import(path .. 'SpaceReinforcementManager.lua').FBPOUI:Hide()
		end
		import(path .. 'AirReinforcementManager.lua').UI:Hide()
		import(path .. 'NavalReinforcementManager.lua').NavalUI:Hide()
		import(path .. 'LandReinforcementManager.lua').LandUI:Show()
		import(path .. 'LandReinforcementManager.lua').LandUI._closeBtn:Hide()
		import(path .. 'LandReinforcementManager.lua').LandUI2._closeBtn:Hide()
		import(path .. 'info.lua').UI:Hide()
		import(path .. 'info.lua').UI._closeBtn:Hide()
		end
		if landbuttonpress == 2 then
		UI:SetTitle('<LOC RefManager>Reinforcement Manager')
		if FBPOPath then
		import(path .. 'SpaceReinforcementManager.lua').FBPOUI:Hide()
		end
		import(path .. 'LandReinforcementManager.lua').LandUI:Hide()
		import(path .. 'NavalReinforcementManager.lua').NavalUI:Hide()
		import(path .. 'AirReinforcementManager.lua').UI:Hide()
		import(path .. 'info.lua').UI:Hide()
		import(path .. 'info.lua').Text:Hide()
		import(path .. 'info.lua').Text2:Hide()
		import(path .. 'info.lua').Text3:Hide()
		import(path .. 'info.lua').UI._closeBtn:Hide()
		landbuttonpress = 0
		end	
end

AirButton.OnClick = function(self)
		airbuttonpress = airbuttonpress + 1
		if airbuttonpress == 1 then
		UI:SetTitle('<LOC AirRefManager>Air Reinforcement Manager')
		landbuttonpress = 0
		navalbuttonpress = 0
		spacebuttonpress = 0
		import(path .. 'LandReinforcementManager.lua').LandUI:Hide()
		import(path .. 'NavalReinforcementManager.lua').NavalUI:Hide()
		if FBPOPath then
		import(path .. 'SpaceReinforcementManager.lua').FBPOUI:Hide()
		end
		import(path .. 'AirReinforcementManager.lua').UI:Show()
		import(path .. 'AirReinforcementManager.lua').UI._closeBtn:Hide()
		import(path .. 'AirReinforcementManager.lua').UI2._closeBtn:Hide()
		import(path .. 'info.lua').UI:Hide()
		import(path .. 'info.lua').UI._closeBtn:Hide()
		end
		if airbuttonpress == 2 then
		UI:SetTitle('<LOC RefManager>Reinforcement Manager')
				if FBPOPath then
		import(path .. 'SpaceReinforcementManager.lua').FBPOUI:Hide()
		end
		import(path .. 'LandReinforcementManager.lua').LandUI:Hide()
		import(path .. 'NavalReinforcementManager.lua').NavalUI:Hide()
		import(path .. 'AirReinforcementManager.lua').UI:Hide()
		import(path .. 'info.lua').UI:Hide()
		import(path .. 'info.lua').Text:Hide()
		import(path .. 'info.lua').Text2:Hide()
		import(path .. 'info.lua').Text3:Hide()
		import(path .. 'info.lua').UI._closeBtn:Hide()
		airbuttonpress = 0
		end	
end

NavalButton.OnClick = function(self)
		navalbuttonpress = navalbuttonpress + 1
		if navalbuttonpress == 1 then
		UI:SetTitle('<LOC NavalRefManager>Naval Reinforcement Manager')
		landbuttonpress = 0
		airbuttonpress = 0
		spacebuttonpress = 0
		import(path .. 'LandReinforcementManager.lua').LandUI:Hide()
		import(path .. 'AirReinforcementManager.lua').UI:Hide()
		if FBPOPath then
		import(path .. 'SpaceReinforcementManager.lua').FBPOUI:Hide()
		end
		import(path .. 'NavalReinforcementManager.lua').NavalUI:Show()
		import(path .. 'NavalReinforcementManager.lua').NavalUI._closeBtn:Hide()
		import(path .. 'NavalReinforcementManager.lua').NavalUI2._closeBtn:Hide()
		import(path .. 'info.lua').UI:Hide()
		import(path .. 'info.lua').UI._closeBtn:Hide()
		end
		if navalbuttonpress == 2 then
		UI:SetTitle('<LOC RefManager>Reinforcement Manager')
				if FBPOPath then
		import(path .. 'SpaceReinforcementManager.lua').FBPOUI:Hide()
		end
		import(path .. 'LandReinforcementManager.lua').LandUI:Hide()
		import(path .. 'NavalReinforcementManager.lua').NavalUI:Hide()
		import(path .. 'AirReinforcementManager.lua').UI:Hide()
		import(path .. 'info.lua').UI:Hide()
		import(path .. 'info.lua').Text:Hide()
		import(path .. 'info.lua').Text2:Hide()
		import(path .. 'info.lua').Text3:Hide()
		import(path .. 'info.lua').UI._closeBtn:Hide()
		navalbuttonpress = 0
		end	
end

if FBPOPath then
SpaceButton.OnClick = function(self)
		spacebuttonpress = spacebuttonpress + 1
		if spacebuttonpress == 1 then
		UI:SetTitle('<LOC SpaceRefManager>Space Reinforcement Manager')
		landbuttonpress = 0
		navalbuttonpress = 0
		airbuttonpress = 0
		import(path .. 'LandReinforcementManager.lua').LandUI:Hide()
		import(path .. 'AirReinforcementManager.lua').UI:Hide()
		import(path .. 'NavalReinforcementManager.lua').NavalUI:Hide()
		import(path .. 'SpaceReinforcementManager.lua').FBPOUI:Show()
		import(path .. 'SpaceReinforcementManager.lua').FBPOUI._closeBtn:Hide()
		import(path .. 'info.lua').UI:Hide()
		import(path .. 'info.lua').UI._closeBtn:Hide()
		end
		if spacebuttonpress == 2 then
		UI:SetTitle('<LOC RefManager>Reinforcement Manager')
		import(path .. 'SpaceReinforcementManager.lua').FBPOUI:Hide()
		import(path .. 'LandReinforcementManager.lua'):Hide()
		import(path .. 'AirReinforcementManager.lua').UI:Hide()
		import(path .. 'info.lua').UI:Hide()
		import(path .. 'info.lua').Text:Hide()
		import(path .. 'info.lua').Text2:Hide()
		import(path .. 'info.lua').Text3:Hide()
		import(path .. 'info.lua').UI._closeBtn:Hide()
		spacebuttonpress = 0
		end
end

Tooltip.AddButtonTooltip(SpaceButton, "SBtn", 1)

else

Tooltip.AddButtonTooltip(SpaceButton, "DesSBtn", 1)

end

Tooltip.AddButtonTooltip(LandButton, "LBtn", 1)
Tooltip.AddButtonTooltip(AirButton, "ABtn", 1)
Tooltip.AddButtonTooltip(NavalButton, "NBtn", 1) -- DesNBtn 




button.OnClick = function(self)
	if buttonpress == 1 then
		helpcenter:Show()
		RefUI._closeBtn:Hide()
		FSUI._closeBtn:Hide()
		FSUI2._closeBtn:Hide()
		MovieUI._closeBtn:Hide()	
	end
	if buttonpress == 2 then 
		helpcenter:Hide()
		buttonpress = 0	
	end
	
	buttonpress = buttonpress + 1
end

for d,t in ButtonPosition do
	button[d]:Set(t)
end

Tooltip.AddButtonTooltip(button, "HCBtn", 1)
LayoutHelpers.DepthOverParent(LBTNUI, UI, 10)
LayoutHelpers.DepthOverParent(button, UI, 10)

if CSKTutorialsPath then
button:Enable()
else
button:Disable()
end

Text = CreateText(UI)
Text2 = CreateText(UI)

UI._closeBtn:Hide()

for k,v in TextPosition2 do
	Text2[k]:Set(v)
end
for k,v in TextPosition do
	Text[k]:Set(v)
end
for i,j in Position do
	UI[i]:Set(j)
end
Text:SetFont('Arial',13) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('ffFFFFFF')
--('To play with this mod , you should keep in mind the followings : \n 1. Click the close button to get the unit list . \n 2.Select a number of engineers/ACU/SACUs to get the access to the construction queue . \n 3.Press Shift and then click an icon to add a building-command to the current queue . \n 4.Simply clicking the icon will stop the engineers from any current activities and force them to execute the building-command \n 5.Eventually , you should choose and right click a spare place')
Text.Depth:Set(30)
Text2:SetFont('Arial',13) --Oh well . You must have font and larger depth otherwise text would not come out
Text2:SetColor('ffFFFFFF')
--('To play with this mod , you should keep in mind the followings : \n 1. Click the close button to get the unit list . \n 2.Select a number of engineers/ACU/SACUs to get the access to the construction queue . \n 3.Press Shift and then click an icon to add a building-command to the current queue . \n 4.Simply clicking the icon will stop the engineers from any current activities and force them to execute the building-command \n 5.Eventually , you should choose and right click a spare place')
Text2.Depth:Set(30)
