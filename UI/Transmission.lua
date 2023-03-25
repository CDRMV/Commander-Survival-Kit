----directory----
local path = '/mods/Commander Survival Kit/UI/'

----significant operators imported from external sources----
local CreateText = import('/lua/maui/text.lua').Text 
local CreateWindow = import('/lua/maui/window.lua').Window
local UIUtil = import('/lua/ui/uiutil.lua')
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local Movie = import('/lua/maui/movie.lua').Movie
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local CreateMultiLineText = import('/lua/maui/MultiLineText.lua').MultiLineText
local factions = import('/lua/factions.lua').Factions
local helpcenter = import(path .. 'Helpcenter.lua').UI
helpcenter:Hide()

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
	Top = 720, 
	Bottom = 860, 
	Right = 385
}

local MovieUIPosition = {
	Left = 25, 
	Top = 745, 
	Bottom = 855, 
	Right = 130
}

local TextUIPosition = {
	Left = 130, 
	Top = 745, 
	Bottom = 855, 
	Right = 380
}

local MoviePosition = {
	Left = 30, 
	Top = 750, 
	Bottom = 850, 
	Right = 122
}

local TextPosition = {
	Left = 140, 
	Top = 770, 
	Bottom = 780, 
	Right = 330
}

local Text2Position = {
	Left = 140, 
	Top = 785, 
	Bottom = 790, 
	Right = 330
}

local Text3Position = {
	Left = 140, 
	Top = 795, 
	Bottom = 800, 
	Right = 330
}

local Text4Position = {
	Left = 140, 
	Top = 805, 
	Bottom = 810, 
	Right = 330
}

local Text5Position = {
	Left = 140, 
	Top = 815, 
	Bottom = 820, 
	Right = 330
}



----actions----
UI = CreateWindow(GetFrame(0),'Transmission',nil,false,false,true,true,'Reinforcements',Position,Border) 

MovieUI = CreateWindow(UI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
MovieUI._closeBtn:Hide()

TextUI = CreateWindow(UI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
TextUI._closeBtn:Hide()

local backMovie 
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()	
	if focusarmy >= 1 then
			if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			backMovie = Movie(MovieUI)
			backMovie:Set('/movies/X06_Rhiza_M02_04487.sfd')
			LayoutHelpers.AtCenterIn(backMovie, MovieUI)
			backMovie:Loop(true)
			backMovie:Play()

			end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			backMovie = Movie(MovieUI)
			backMovie:Set('/movies/X02_Brackman_M02_03549.sfd')
			LayoutHelpers.AtCenterIn(backMovie, MovieUI)
			backMovie:Loop(true)
			backMovie:Play()
			end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			backMovie = Movie(MovieUI)
			backMovie:Set('/movies/X01_Graham_M02_03637.sfd')
			LayoutHelpers.AtCenterIn(backMovie, MovieUI)
			backMovie:Loop(true)
			backMovie:Play()
			end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			backMovie = Movie(MovieUI)
			backMovie:Set('/movies/X04_Oum-Eoshi_M03_03758.sfd')
			LayoutHelpers.AtCenterIn(backMovie, MovieUI)
			backMovie:Loop(true)
			backMovie:Play()
			end
	end

	
	
Text = CreateText(UI)	
Text:SetFont('Arial',10) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text.Depth:Set(30)

Text2 = CreateText(UI)	
Text2:SetFont('Arial',9) --Oh well . You must have font and larger depth otherwise text would not come out
Text2:SetColor('ffFFFFFF')
Text2.Depth:Set(30)

Text3 = CreateText(UI)	
Text3:SetFont('Arial',9) --Oh well . You must have font and larger depth otherwise text would not come out
Text3:SetColor('ffFFFFFF')
Text3.Depth:Set(30)

Text4 = CreateText(UI)	
Text4:SetFont('Arial',9) --Oh well . You must have font and larger depth otherwise text would not come out
Text4:SetColor('ffFFFFFF')
Text4.Depth:Set(30)

Text5 = CreateText(UI)	
Text5:SetFont('Arial',9) --Oh well . You must have font and larger depth otherwise text would not come out
Text5:SetColor('ffFFFFFF')
Text5.Depth:Set(30)

for k,v in TextPosition do
	Text[k]:Set(v)
end

for k,v in Text2Position do
	Text2[k]:Set(v)
end

for k,v in Text3Position do
	Text3[k]:Set(v)
end

for k,v in Text4Position do
	Text4[k]:Set(v)
end

for k,v in Text5Position do
	Text5[k]:Set(v)
end

for i,j in TextUIPosition do
	TextUI[i]:Set(j)
end
	
for i,j in MovieUIPosition do
	MovieUI[i]:Set(j)
end

for i,j in MoviePosition do
	backMovie[i]:Set(j)
end

LayoutHelpers.DepthOverParent(backMovie, UI, 10)


for i,j in Position do
	UI[i]:Set(j)
end