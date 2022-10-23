----directory----
local path = '/mods/Reinforcement Manager/UI/Reinforcements/'

----significant operators imported from external sources----
local CreateText = import('/lua/maui/text.lua').Text 
local CreateWindow = import('/lua/maui/window.lua').Window
local UIUtil = import('/lua/ui/uiutil.lua')
local UIFile = import('/lua/ui/uiutil.lua').UIFile

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
	Left = 1664, 
	Top = 450, 
	Bottom = 570, 
	Right = 1950
}

local TextPosition = {
	Left = 1680, 
	Top = 475, 
	Bottom = 575, 
	Right = 1950
}

local TextPosition2 = {
	Left = 1680, 
	Top = 505, 
	Bottom = 605, 
	Right = 1920
}

local TextPosition3 = {
	Left = 1680, 
	Top = 535, 
	Bottom = 635, 
	Right = 1920
}
   
----actions----
UI = CreateWindow(GetFrame(0),'Status',nil,false,false,true,true,'Reinforcements',Position,Border) 
Text = CreateText(GetFrame(0))
Text2 = CreateText(GetFrame(0))
Text3 = CreateText(GetFrame(0))
UI._closeBtn:Hide()
for k,v in TextPosition3 do
	Text3[k]:Set(v)
end
for k,v in TextPosition2 do
	Text2[k]:Set(v)
end
for k,v in TextPosition do
	Text[k]:Set(v)
end
for i,j in Position do
	UI[i]:Set(j)
end
Text:SetFont('Arial',20) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('ffFFFFFF')
--('To play with this mod , you should keep in mind the followings : \n 1. Click the close button to get the unit list . \n 2.Select a number of engineers/ACU/SACUs to get the access to the construction queue . \n 3.Press Shift and then click an icon to add a building-command to the current queue . \n 4.Simply clicking the icon will stop the engineers from any current activities and force them to execute the building-command \n 5.Eventually , you should choose and right click a spare place')
Text.Depth:Set(30)
Text2:SetFont('Arial',20) --Oh well . You must have font and larger depth otherwise text would not come out
Text2:SetColor('ffFFFFFF')
--('To play with this mod , you should keep in mind the followings : \n 1. Click the close button to get the unit list . \n 2.Select a number of engineers/ACU/SACUs to get the access to the construction queue . \n 3.Press Shift and then click an icon to add a building-command to the current queue . \n 4.Simply clicking the icon will stop the engineers from any current activities and force them to execute the building-command \n 5.Eventually , you should choose and right click a spare place')
Text2.Depth:Set(30)
Text3:SetFont('Arial',20) --Oh well . You must have font and larger depth otherwise text would not come out
Text3:SetColor('ffFFFFFF')
--('To play with this mod , you should keep in mind the followings : \n 1. Click the close button to get the unit list . \n 2.Select a number of engineers/ACU/SACUs to get the access to the construction queue . \n 3.Press Shift and then click an icon to add a building-command to the current queue . \n 4.Simply clicking the icon will stop the engineers from any current activities and force them to execute the building-command \n 5.Eventually , you should choose and right click a spare place')
Text3.Depth:Set(30)