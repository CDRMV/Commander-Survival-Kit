----directory----
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
	Top = 250, 
	Bottom = 270, 
	Right = 240
}

local TextPosition2 = {
	Left = 40, 
	Top = 271, 
	Bottom = 291, 
	Right = 240
}

local ButtonPosition = {
	Left = 255, 
	Top = 260, 
	Bottom = 320, 
	Right = 325
}
   
----actions----
UI = CreateWindow(GetFrame(0),'Air/Space Reinforcement Manager',nil,false,false,true,true,'Reinforcements',Position,Border) 
local button
if focusarmy >= 1 then
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
		button = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "Help", 11, -4, -64)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		button = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "Help", 11, -4, -64)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		button = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "Help", 11, -4, -64)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		button = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "Help", 11, -4, -64)
	end
end

local buttonpress = 1
button.OnClick = function(self)
	if buttonpress == 1 then
		helpcenter:Show()
		RefUI._closeBtn:Hide()
		FSUI._closeBtn:Hide()
		FSUI2._closeBtn:Hide()
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

LayoutHelpers.DepthOverParent(button, UI, 10)

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
Text:SetFont('Arial',15) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('ffFFFFFF')
--('To play with this mod , you should keep in mind the followings : \n 1. Click the close button to get the unit list . \n 2.Select a number of engineers/ACU/SACUs to get the access to the construction queue . \n 3.Press Shift and then click an icon to add a building-command to the current queue . \n 4.Simply clicking the icon will stop the engineers from any current activities and force them to execute the building-command \n 5.Eventually , you should choose and right click a spare place')
Text.Depth:Set(30)
Text2:SetFont('Arial',15) --Oh well . You must have font and larger depth otherwise text would not come out
Text2:SetColor('ffFFFFFF')
--('To play with this mod , you should keep in mind the followings : \n 1. Click the close button to get the unit list . \n 2.Select a number of engineers/ACU/SACUs to get the access to the construction queue . \n 3.Press Shift and then click an icon to add a building-command to the current queue . \n 4.Simply clicking the icon will stop the engineers from any current activities and force them to execute the building-command \n 5.Eventually , you should choose and right click a spare place')
Text2.Depth:Set(30)