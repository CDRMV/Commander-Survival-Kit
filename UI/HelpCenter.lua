----directory----
local path = '/mods/Commander Survival Kit/UI/'

----significant operators imported from external sources----
local CreateText = import('/lua/maui/text.lua').Text 
local CreateWindow = import('/lua/maui/window.lua').Window
local UIUtil = import('/lua/ui/uiutil.lua')
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local Group = import("/lua/maui/group.lua").Group
local LayoutHelpers = import("/lua/maui/layouthelpers.lua")
local factions = import('/lua/factions.lua').Factions

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
	Right = 1200
}

local Position2 = {
	Left = 340, 
	Top = 350, 
	Bottom = 420,  
	Right = 660
}

local Position3 = {
	Left = 340, 
	Top = 430, 
	Bottom = 620,  
	Right = 660
}

local Position4 = {
	Left = 340, 
	Top = 630, 
	Bottom = 710,  
	Right = 660
}

local Position5 = {
	Left = 700, 
	Top = 350, 
	Bottom = 620,  
	Right = 1150
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
RefUI = CreateWindow(UI,'Reinforcements (Tutorials)',nil,false,false,true,true,'Reinforcements',Position2,Border) 
FSUI = CreateWindow(UI,'Weapon Barrages (Tutorials)',nil,false,false,true,true,'Reinforcements',Position3,Border) 
FSUI2 = CreateWindow(UI,'Turrets/Devices (Tutorials)',nil,false,false,true,true,'Reinforcements',Position4,Border) 
MovieUI = CreateWindow(UI,nil,nil,false,false,true,true,'Reinforcements',Position5,Border)
local button
if focusarmy >= 1 then
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
		button = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "Land", 11, -6, -50)
		button2 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "Air", 11, -6, -50)
		button3 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "Space", 11, -6, -50)
		button4 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "Artillery", 11, -6, -50)
		button5 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "Naval", 11, -6, -50)
		button6 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "Missile", 11, -6, -50)
		button7 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "Rapid Fire", 11, -6, -50)
		button8 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "Beam", 11, -6, -50)
		button9 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "Special", 11, -6, -50)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		button = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "Land", 11, -6, -50)
		button2 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "Air", 11, -6, -50)
		button3 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "Space", 11, -6, -50)
		button4 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "Artillery", 11, -6, -50)
		button5 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "Naval", 11, -6, -50)
		button6 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "Missile", 11, -6, -50)
		button7 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "Rapid Fire", 11, -6, -50)
		button8 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "Beam", 11, -6, -50)
		button9 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "Special", 11, -6, -50)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		button = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "Land", 11, -6, -50)
		button2 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "Air", 11, -6, -50)
		button3 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "Space", 11, -6, -50)
		button4 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "Artillery", 11, -6, -50)
		button5 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "Naval", 11, -6, -50)
		button6 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "Missile", 11, -6, -50)
		button7 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "Rapid Fire", 11, -6, -50)
		button8 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "Beam", 11, -6, -50)
		button9 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "Special", 11, -6, -50)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		button = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "Land", 11, -6, -50)
		button2 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "Air", 11, -6, -50)
		button3 = UIUtil.CreateButtonStd(RefUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "Space", 11, -6, -50)
		button4 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "Artillery", 11, -6, -50)
		button5 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "Naval", 11, -6, -50)
		button6 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "Missile", 11, -6, -50)
		button7 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "Rapid Fire", 11, -6, -60)
		button8 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "Beam", 11, -6, -50)
		button9 = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "Special", 11, -6, -50)
	end
end


button.OnClick = function(self)

end

button2.OnClick = function(self)

end

button3.OnClick = function(self)

end

button4.OnClick = function(self)

end

button5.OnClick = function(self)

end

button6.OnClick = function(self)

end

button7.OnClick = function(self)

end

button8.OnClick = function(self)

end

button9.OnClick = function(self)

end

for d,t in ButtonPosition9 do
	button9[d]:Set(t)
end

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

for d,t in ButtonPosition3 do
	button3[d]:Set(t)
end

for d,t in ButtonPosition2 do
	button2[d]:Set(t)
end

for d,t in ButtonPosition do
	button[d]:Set(t)
end

LayoutHelpers.DepthOverParent(button, UI, 10)
LayoutHelpers.DepthOverParent(button2, UI, 10)
LayoutHelpers.DepthOverParent(button3, UI, 10)
LayoutHelpers.DepthOverParent(button4, UI, 10)
LayoutHelpers.DepthOverParent(button5, UI, 10)
LayoutHelpers.DepthOverParent(button6, UI, 10)
LayoutHelpers.DepthOverParent(button7, UI, 10)
LayoutHelpers.DepthOverParent(button8, UI, 10)
LayoutHelpers.DepthOverParent(button9, UI, 10)


Text = CreateText(UI)
Text2 = CreateText(UI)

UI._closeBtn:Hide()

for k,v in TextPosition2 do
	Text2[k]:Set(v)
end
for k,v in TextPosition do
	Text[k]:Set(v)
end

for e,f in Position5 do
	MovieUI[e]:Set(f)
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


Text = CreateText(MovieUI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, MovieUI)

Text2 = CreateText(MovieUI)	
Text2:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text2:SetColor('FFbadbdb')
Text2:SetText('[...COMING SOON...]')
Text2.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text2, FSUI2)