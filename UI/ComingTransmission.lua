----directory----
local path = '/mods/Reinforcement Manager/UI/Reinforcements/'

----significant operators imported from external sources----
local CreateText = import('/lua/maui/text.lua').Text 
local CreateWindow = import('/lua/maui/window.lua').Window
local UIUtil = import('/lua/ui/uiutil.lua')
local UIFile = import('/lua/ui/uiutil.lua').UIFile
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
	Left = 330, 
	Top = 320, 
	Bottom = 720,  
	Right = 660
}

local MovieUIPosition = {
	Left = 370, 
	Top = 345, 
	Bottom = 560,  
	Right = 620
}

local TextUIPosition = {
	Left = 340, 
	Top = 565, 
	Bottom = 710,  
	Right = 650
}

local MoviePosition = {
	Left = 380, 
	Top = 375, 
	Bottom = 550,  
	Right = 610
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
			backMovie:Set('/movies/Aeon_load.sfd')
			LayoutHelpers.AtCenterIn(backMovie, MovieUI)
			backMovie:Loop(true)
			backMovie:Play()

			end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			backMovie = Movie(MovieUI)
			backMovie:Set('/movies/Cybran_load.sfd')
			LayoutHelpers.AtCenterIn(backMovie, MovieUI)
			backMovie:Loop(true)
			backMovie:Play()
			end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			backMovie = Movie(MovieUI)
			backMovie:Set('/movies/UEF_load.sfd')
			LayoutHelpers.AtCenterIn(backMovie, MovieUI)
			backMovie:Loop(true)
			backMovie:Play()
			end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			backMovie = Movie(MovieUI)
			backMovie:Set('/movies/Seraphim_load.sfd')
			LayoutHelpers.AtCenterIn(backMovie, MovieUI)
			backMovie:Loop(true)
			backMovie:Play()
			end
	end
	
	
Text = CreateText(UI)	
Text:SetFont('Arial',20) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...INCOMING...]')
Text.Depth:Set(30)


LayoutHelpers.AtCenterIn(Text, TextUI)


for i,j in TextUIPosition do
	TextUI[i]:Set(j)
end
	
for i,j in MovieUIPosition do
	MovieUI[i]:Set(j)
end

for i,j in MoviePosition do
	backMovie[i]:Set(j)
end


for i,j in Position do
	UI[i]:Set(j)
end