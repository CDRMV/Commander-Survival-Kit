----directory----
local path = '/mods/Commander Survival Kit/UI/'

----significant operators imported from external sources----
local CreateText = import('/lua/maui/text.lua').Text 
local CreateWindow = import('/lua/maui/window.lua').Window
local UIUtil = import('/lua/ui/uiutil.lua')
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local Bitmap = import("/lua/maui/bitmap.lua").Bitmap
local Movie = import('/lua/maui/movie.lua').Movie
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local CreateMultiLineText = import('/lua/maui/MultiLineText.lua').MultiLineText
local factions = import('/lua/factions.lua').Factions

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
	Left = 300, 
	Top = 80, 
	Bottom = 220, 
	Right = 660
}

local MovieUIPosition = {
	Left = 305, 
	Top = 105, 
	Bottom = 215, 
	Right = 420
}

local TextUIPosition = {
	Left = 420, 
	Top = 105, 
	Bottom = 215, 
	Right = 660
}


local TextPosition = {
	Left = 430, 
	Top = 135, 
	Bottom = 140, 
	Right = 655
}

local Text2Position = {
	Left = 430, 
	Top = 150, 
	Bottom = 155, 
	Right = 655
}

local Text3Position = {
	Left = 430, 
	Top = 160, 
	Bottom = 165, 
	Right = 655
}

local Text4Position = {
	Left = 430, 
	Top = 170, 
	Bottom = 175, 
	Right = 655
}

local Text5Position = {
	Left = 430, 
	Top = 180, 
	Bottom = 185, 
	Right = 655
}



----actions----
UI = CreateWindow(GetFrame(0),'Transmission',nil,false,false,true,true,'Reinforcements',Position,Border) 
MovieUI = CreateWindow(UI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
MovieUI._closeBtn:Hide()
TextUI = CreateWindow(UI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
TextUI._closeBtn:Hide()
local Picture 
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()	
	if focusarmy >= 1 then
			if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			Picture = Bitmap(MovieUI, '/mods/Commander Survival Kit/movies/Aeon.dds')
			LayoutHelpers.FillParentFixedBorder(Picture, MovieUI, 5)
			end
			if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			Picture = Bitmap(MovieUI, '/mods/Commander Survival Kit/movies/Cybran.dds')
			LayoutHelpers.FillParentFixedBorder(Picture, MovieUI, 5)
			end
			if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			Picture = Bitmap(MovieUI, '/mods/Commander Survival Kit/movies/UEF.dds')
			LayoutHelpers.FillParentFixedBorder(Picture, MovieUI, 5)
			end
			if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			Picture = Bitmap(MovieUI, '/mods/Commander Survival Kit/movies/Sera.dds')
			LayoutHelpers.FillParentFixedBorder(Picture, MovieUI, 5)
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



LayoutHelpers.DepthOverParent(Picture, UI, 10)


for i,j in Position do
	UI[i]:Set(j)
end

