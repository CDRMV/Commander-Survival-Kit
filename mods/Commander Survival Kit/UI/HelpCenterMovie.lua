----directory----
local path = '/mods/Commander Survival Kit/UI/'

----significant operators imported from external sources----
local CreateText = import('/lua/maui/text.lua').Text 
local CreateWindow = import('/lua/maui/window.lua').Window
local UIUtil = import('/lua/ui/uiutil.lua')
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local Group = import("/lua/maui/group.lua").Group
local LayoutHelpers = import("/lua/maui/layouthelpers.lua")
local Movie = import('/lua/maui/movie.lua').Movie
local factions = import('/lua/factions.lua').Factions
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
	Left = 660, 
	Top = 320, 
	Bottom = 720,  
	Right = 1200
}
local Position2 = {
	Left = 800, 
	Top = 720, 
	Bottom = 800,  
	Right = 1100
}




   
----actions----
UI = CreateWindow(GetFrame(0),nil,nil,false,false,false,false,'Reinforcements',Position,Border) 
OUI = CreateWindow(GetFrame(0),nil,nil,false,false,true,false,'Reinforcements',Position2,Border) 
backMovie = Movie(UI)
local playbutton
local stopbutton

if focusarmy >= 1 then
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
		playbutton = UIUtil.CreateButtonStd(OUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "Play", 11, 0, 0)
		stopbutton = UIUtil.CreateButtonStd(OUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "Stop", 11, 0, 0)
			
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		playbutton = UIUtil.CreateButtonStd(OUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "Play", 11, 0, 0)
		stopbutton = UIUtil.CreateButtonStd(OUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "Stop", 11, 0, 0)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		playbutton = UIUtil.CreateButtonStd(OUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "Play", 11, 0, 0)
		stopbutton = UIUtil.CreateButtonStd(OUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "Stop", 11, 0, 0)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		playbutton = UIUtil.CreateButtonStd(OUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "Play", 11, 0, 0)
		stopbutton = UIUtil.CreateButtonStd(OUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "Stop", 11, 0, 0)
	end
end


playbutton.OnClick = function(self)
	backMovie:Play()
	backMovie:Loop(true)
end

stopbutton.OnClick = function(self)
	backMovie:Stop()
end

Tooltip.AddButtonTooltip(playbutton, "MPBtn", 1)
Tooltip.AddButtonTooltip(stopbutton, "MSBtn", 1)


Text = CreateText(UI)	
Text:SetFont('Arial',16) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.CenteredBelow(Text, UI, -45)



UI._closeBtn:Hide()

for i,j in Position do
	UI[i]:Set(j)
end

for a,b in Position2 do
	OUI[a]:Set(b)
end

LayoutHelpers.SetWidth(playbutton, 80)
LayoutHelpers.SetHeight(playbutton, 70)
LayoutHelpers.AtCenterIn(playbutton, OUI, 6, -40)
LayoutHelpers.DepthOverParent(playbutton, OUI, 10)
LayoutHelpers.SetWidth(stopbutton, 80)
LayoutHelpers.SetHeight(stopbutton, 70)
LayoutHelpers.AtCenterIn(stopbutton, OUI, 6, 40)
LayoutHelpers.DepthOverParent(stopbutton, OUI, 10)










