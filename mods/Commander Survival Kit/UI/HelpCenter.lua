----directory----
local path = '/mods/Commander Survival Kit/UI/'
local moviepath = '/mods/Commander Survival Kit Tutorials/movies/'

----significant operators imported from external sources----
local CreateText = import('/lua/maui/text.lua').Text 
local CreateWindow = import('/lua/maui/window.lua').Window
local UIUtil = import('/lua/ui/uiutil.lua')
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local Group = import("/lua/maui/group.lua").Group
local LayoutHelpers = import("/lua/maui/layouthelpers.lua")
local factions = import('/lua/factions.lua').Factions
local helpcentermovie = import(path .. 'HelpcenterMovie.lua').UI
local helpcentermovieoptions = import(path .. 'HelpcenterMovie.lua').OUI
local movie = import(path .. 'HelpcenterMovie.lua').backMovie
local Movie = import('/lua/maui/movie.lua').Movie
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
	Left = 330, 
	Top = 320, 
	Bottom = 720,  
	Right = 660
}

local Position2 = {
	Left = 340, 
	Top = 350, 
	Bottom = 420,  
	Right = 650
}

local Position3 = {
	Left = 340, 
	Top = 430, 
	Bottom = 620,  
	Right = 650
}

local Position4 = {
	Left = 340, 
	Top = 630, 
	Bottom = 710,  
	Right = 650
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
	Bottom = 391, 
	Right = 240
}

local ButtonPosition = {
	Left = 345, 
	Top = 365, 
	Bottom = 420,  
	Right = 445
}
local ButtonPosition2 = {
	Left = 445, 
	Top = 365, 
	Bottom = 420,  
	Right = 545
}
local ButtonPosition3 = {
	Left = 545, 
	Top = 365, 
	Bottom = 420,  
	Right = 645
}

local ButtonPosition4 = {
	Left = 345, 
	Top = 445, 
	Bottom = 500,  
	Right = 445
}
local ButtonPosition5 = {
	Left = 445, 
	Top = 445, 
	Bottom = 500, 
	Right = 545
}
local ButtonPosition6 = {
	Left = 545, 
	Top = 445, 
	Bottom = 500, 
	Right = 645
}

local ButtonPosition7 = {
	Left = 345, 
	Top = 485, 
	Bottom = 540,  
	Right = 445
}
local ButtonPosition8 = {
	Left = 445, 
	Top = 485, 
	Bottom = 540, 
	Right = 545
}
local ButtonPosition9 = {
	Left = 545, 
	Top = 485, 
	Bottom = 540,  
	Right = 645
}
   
----actions----
UI = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
RefUI = CreateWindow(UI,'<LOC Reinforcements>Reinforcements (Tutorials)',nil,false,false,true,true,'Reinforcements',Position2,Border) 
FSUI = CreateWindow(UI,'<LOC FireSupport>Fire Support (Tutorials)',nil,false,false,true,true,'Reinforcements',Position3,Border) 
FSUI2 = CreateWindow(UI,'<LOC DropDefenses>Drop Defenses (Tutorials)',nil,false,false,true,true,'Reinforcements',Position4,Border) 

local button

if focusarmy >= 1 then
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
		button = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "<LOC Land>Land", 11, -6, -50)
		button2 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "<LOC Air>Air", 11, -6, -50)
		--button3 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "<LOC Space>Space", 11, -6, -50)
		button4 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "<LOC AirStrikes>Air Strikes", 11, -6, -50)
		button5 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "<LOC Artillery>Artillery", 11, -6, -50)
		button6 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "<LOC Missile>Missile", 11, -6, -50)
		button7 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "<LOC Beam>Beam", 11, -6, -50)
		button8 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "<LOC Special>Special", 11, -6, -50)
		--button9 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "<LOC Special>Special", 11, -6, -50)
			
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		button = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "<LOC Land>Land", 11, -6, -50)
		button2 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "<LOC Air>Air", 11, -6, -50)
		--button3 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "<LOC Space>Space", 11, -6, -50)
		button4 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "<LOC AirStrikes>Air Strikes", 11, -6, -50)
		button5 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "<LOC Artillery>Artillery", 11, -6, -50)
		button6 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "<LOC Missile>Missile", 11, -6, -50)
		button7 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "<LOC Beam>Beam", 11, -6, -50)
		button8 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "<LOC Special>Special", 11, -6, -50)
		--button9 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "<LOC Special>Special", 11, -6, -50)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		button = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "<LOC Land>Land", 11, -6, -50)
		button2 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "<LOC Air>Air", 11, -6, -50)
		--button3 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "<LOC Space>Space", 11, -6, -50)
		button4 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "<LOC AirStrikes>Air Strikes", 11, -6, -50)
		button5 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "<LOC Artillery>Artillery", 11, -6, -50)
		button6 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "<LOC Missile>Missile", 11, -6, -50)
		button7 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "<LOC Beam>Beam", 11, -6, -50)
		button8 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "<LOC Special>Special", 11, -6, -50)
		--button9 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "<LOC Special>Special", 11, -6, -50)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		button = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "<LOC Land>Land", 11, -6, -50)
		button2 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "<LOC Air>Air", 11, -6, -50)
		--button3 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "<LOC Space>Space", 11, -6, -50)
		button4 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "<LOC AirStrikes>Air Strikes", 11, -6, -50)
		button5 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "<LOC Artillery>Artillery", 11, -6, -50)
		button6 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "<LOC Missile>Missile", 11, -6, -50)
		button7 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "<LOC Beam>Beam", 11, -6, -50)
		button8 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "<LOC Special>Special", 11, -6, -50)
		--button9 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "<LOC Special>Special", 11, -6, -50)
	end
end


local buttonpress = 1



button.OnClick = function(self)
	if buttonpress == 1 then
		movie:Set(moviepath .. 'Land.sfd')
		LayoutHelpers.FillParentFixedBorder(movie, helpcentermovie, 25)
		LayoutHelpers.DepthOverParent(movie, helpcentermovie, 10)
		helpcentermovie:Show()
		helpcentermovieoptions:Show()
	end
	if buttonpress == 2 then 
		helpcentermovie:Hide()
		helpcentermovieoptions:Hide()
		buttonpress = 0
	end
	
	buttonpress = buttonpress + 1
end

button2.OnClick = function(self)
	if buttonpress == 1 then
		movie:Set(moviepath .. 'Air.sfd')
		LayoutHelpers.FillParentFixedBorder(movie, helpcentermovie, 25)
		LayoutHelpers.DepthOverParent(movie, helpcentermovie, 10)
		helpcentermovie:Show()
		helpcentermovieoptions:Show()
	end
	if buttonpress == 2 then 
		helpcentermovie:Hide()
		helpcentermovieoptions:Hide()
		buttonpress = 0
	end
	
	buttonpress = buttonpress + 1
end

--[[
button3.OnClick = function(self)
	if buttonpress == 1 then
		movie:Set(moviepath .. 'Preview.sfd')
		LayoutHelpers.FillParentFixedBorder(movie, helpcentermovie, 25)
		LayoutHelpers.DepthOverParent(movie, helpcentermovie, 10)
		helpcentermovie:Show()
		helpcentermovieoptions:Show()
	end
	if buttonpress == 2 then 
		helpcentermovie:Hide()
		helpcentermovieoptions:Hide()
		buttonpress = 0
	end
	
	buttonpress = buttonpress + 1
end
]]--
button4.OnClick = function(self)
	if buttonpress == 1 then
		movie:Set(moviepath .. 'AirStrikes.sfd')
		LayoutHelpers.FillParentFixedBorder(movie, helpcentermovie, 25)
		LayoutHelpers.DepthOverParent(movie, helpcentermovie, 10)
		helpcentermovie:Show()
		helpcentermovieoptions:Show()
	end
	if buttonpress == 2 then 
		helpcentermovie:Hide()
		helpcentermovieoptions:Hide()
		buttonpress = 0
	end
	
	buttonpress = buttonpress + 1
end

button5.OnClick = function(self)
	if buttonpress == 1 then
		movie:Set(moviepath .. 'Artillery.sfd')
		LayoutHelpers.FillParentFixedBorder(movie, helpcentermovie, 25)
		LayoutHelpers.DepthOverParent(movie, helpcentermovie, 10)
		helpcentermovie:Show()
		helpcentermovieoptions:Show()
	end
	if buttonpress == 2 then 
		helpcentermovie:Hide()
		helpcentermovieoptions:Hide()
		buttonpress = 0
	end
	
	buttonpress = buttonpress + 1
end

button6.OnClick = function(self)
	if buttonpress == 1 then
		movie:Set(moviepath .. 'Missile.sfd')
		LayoutHelpers.FillParentFixedBorder(movie, helpcentermovie, 25)
		LayoutHelpers.DepthOverParent(movie, helpcentermovie, 10)
		helpcentermovie:Show()
		helpcentermovieoptions:Show()
	end
	if buttonpress == 2 then 
		helpcentermovie:Hide()
		helpcentermovieoptions:Hide()
		buttonpress = 0
	end
	
	buttonpress = buttonpress + 1
end

button7.OnClick = function(self)
	if buttonpress == 1 then
		movie:Set(moviepath .. 'Beam.sfd')
		LayoutHelpers.FillParentFixedBorder(movie, helpcentermovie, 25)
		LayoutHelpers.DepthOverParent(movie, helpcentermovie, 10)
		helpcentermovie:Show()
		helpcentermovieoptions:Show()
	end
	if buttonpress == 2 then 
		helpcentermovie:Hide()
		helpcentermovieoptions:Hide()
		buttonpress = 0
	end
	
	buttonpress = buttonpress + 1
end

button8.OnClick = function(self)
	if buttonpress == 1 then
		movie:Set(moviepath .. 'Special.sfd')
		LayoutHelpers.FillParentFixedBorder(movie, helpcentermovie, 25)
		LayoutHelpers.DepthOverParent(movie, helpcentermovie, 10)
		helpcentermovie:Show()
		helpcentermovieoptions:Show()
	end
	if buttonpress == 2 then 
		helpcentermovie:Hide()
		helpcentermovieoptions:Hide()
		buttonpress = 0
	end
	
	buttonpress = buttonpress + 1
end

--[[
button9.OnClick = function(self)
	if buttonpress == 1 then
		movie:Set(moviepath .. 'Preview.sfd')
		LayoutHelpers.FillParentFixedBorder(movie, helpcentermovie, 25)
		LayoutHelpers.DepthOverParent(movie, helpcentermovie, 10)
		helpcentermovie:Show()
		helpcentermovieoptions:Show()
	end
	if buttonpress == 2 then 
		helpcentermovie:Hide()
		helpcentermovieoptions:Hide()
		buttonpress = 0
	end
	
	buttonpress = buttonpress + 1
end
]]--

Tooltip.AddButtonTooltip(button, "LTBtn", 1)
Tooltip.AddButtonTooltip(button2, "ATBtn", 1)
--Tooltip.AddButtonTooltip(button3, "STBtn", 1)
Tooltip.AddButtonTooltip(button4, "ASTBtn", 1)
Tooltip.AddButtonTooltip(button5, "ARTTBtn", 1)
Tooltip.AddButtonTooltip(button6, "MTBtn", 1)
Tooltip.AddButtonTooltip(button7, "BTBtn", 1)
Tooltip.AddButtonTooltip(button8, "SPTBtn", 1)
--Tooltip.AddButtonTooltip(button9, "SPTBtn", 1)

--[[
for d,t in ButtonPosition9 do
	button9[d]:Set(t)
end
]]--
for d,t in ButtonPosition8 do
	button8[d]:Set(t)
end

for d,t in ButtonPosition7 do
	button7[d]:Set(t)
end

for d,t in ButtonPosition6 do
	button6[d]:Set(t)
end

for d,t in ButtonPosition5 do
	button5[d]:Set(t)
end

for d,t in ButtonPosition4 do
	button4[d]:Set(t)
end

--[[
for d,t in ButtonPosition3 do
	button3[d]:Set(t)
end
]]--
for d,t in ButtonPosition2 do
	button2[d]:Set(t)
end

for d,t in ButtonPosition do
	button[d]:Set(t)
end

LayoutHelpers.DepthOverParent(button, UI, 10)
LayoutHelpers.DepthOverParent(button2, UI, 10)
--LayoutHelpers.DepthOverParent(button3, UI, 10)
LayoutHelpers.DepthOverParent(button4, UI, 10)
LayoutHelpers.DepthOverParent(button5, UI, 10)
LayoutHelpers.DepthOverParent(button6, UI, 10)
LayoutHelpers.DepthOverParent(button7, UI, 10)
LayoutHelpers.DepthOverParent(button8, UI, 10)
--LayoutHelpers.DepthOverParent(button9, UI, 10)



Text2 = CreateText(FSUI2)

UI._closeBtn:Hide()

for k,v in TextPosition2 do
	Text2[k]:Set(v)
end



for c,d in Position4 do
	FSUI2[c]:Set(d)
end
for a,b in Position3 do
	FSUI[a]:Set(b)
end
for r,c in Position2 do
	RefUI[r]:Set(c)
end
for i,j in Position do
	UI[i]:Set(j)
end


Text2:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text2:SetColor('FFbadbdb')
Text2:SetText('[...COMING SOON...]')
Text2.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text2, FSUI2)