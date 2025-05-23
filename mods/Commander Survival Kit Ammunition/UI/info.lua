local CreateText = import('/lua/maui/text.lua').Text 
local CreateWindow = import('/lua/maui/window.lua').Window
local UIUtil = import('/lua/ui/uiutil.lua')
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local factions = import('/lua/factions.lua').Factions
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')

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
	Top = 220, 
	Bottom = 320, 
	Right = 660
}


   
----actions----
UI = CreateWindow(GetFrame(0),'<LOC Info>Info',nil,false,false,true,false,'Reinforcements',Position,Border) 
Text = CreateText(UI)


for i,j in Position do
	UI[i]:Set(j)
end


Text:SetFont('Arial',20)
Text.Depth:Set(30)


local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	


Text:SetColor(factions[armyInfo.armiesTable[focusarmy].faction+1].loadingColor)

LayoutHelpers.AtCenterIn(Text, UI)
LayoutHelpers.AtTopIn(Text, UI, 30)
	


function UpdateUIText(Value)

Text:SetText(Value)

end


function ManageUI(Value)
if Value == true then
UI:Show()
UI._closeBtn:Hide()
elseif Value == false then
UI:Hide()
end
end
