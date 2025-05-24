local CreateText = import('/lua/maui/text.lua').Text 
local CreateWindow = import('/lua/maui/window.lua').Window
local UIUtil = import('/lua/ui/uiutil.lua')
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local factions = import('/lua/factions.lua').Factions
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Group = import('/lua/maui/group.lua').Group
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local parent = import('/lua/ui/game/unitview.lua').controls.bg

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
	


   
----actions----
ui = Group(GetFrame(0))
ui.BG = {}
ui.BG.TL = Bitmap(ui)
ui.BG.TR = Bitmap(ui)
ui.BG.TM = Bitmap(ui)
ui.BG.ML = Bitmap(ui)
ui.BG.MR = Bitmap(ui)
ui.BG.M = Bitmap(ui)
ui.BG.BL = Bitmap(ui)
ui.BG.BR = Bitmap(ui)
ui.BG.BM = Bitmap(ui)
Text = CreateText(ui)
Title = CreateText(ui)

	ui.Left:Set(function() return parent.Left() + 14 end)
    ui.Bottom:Set(function() return parent.Top() - 25 end)
    ui.Height:Set(50)
    ui.Width:Set(200)
    
    ui.BG.TL:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_ul.dds'))
    ui.BG.TL.Right:Set(ui.Left)
    ui.BG.TL.Bottom:Set(ui.Top)
    
    ui.BG.TM:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_horz_um.dds'))
    ui.BG.TM.Right:Set(ui.BG.TL.Right)
    ui.BG.TM.Bottom:Set(function() return ui.Top() end)
    ui.BG.TM.Left:Set(ui.BG.TR.Left)
    
    ui.BG.TR:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_ur.dds'))
    ui.BG.TR.Left:Set(ui.Right)
    ui.BG.TR.Bottom:Set(ui.Top)
    
    ui.BG.ML:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_vert_l.dds'))
    ui.BG.ML.Right:Set(ui.Left)
    ui.BG.ML.Top:Set(ui.BG.TL.Bottom)
    ui.BG.ML.Bottom:Set(ui.BG.BL.Top)
    
    ui.BG.M:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_m.dds'))
    ui.BG.M.Top:Set(ui.BG.TM.Bottom)
    ui.BG.M.Left:Set(ui.BG.ML.Right)
    ui.BG.M.Right:Set(ui.BG.MR.Left)
    ui.BG.M.Bottom:Set(ui.BG.BM.Top)
    
    ui.BG.MR:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_vert_r.dds'))
    ui.BG.MR.Left:Set(ui.Right)
    ui.BG.MR.Top:Set(ui.BG.TR.Bottom)
    ui.BG.MR.Bottom:Set(ui.BG.BR.Top)
    
    ui.BG.BL:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_ll.dds'))
    ui.BG.BL.Right:Set(ui.Left)
    ui.BG.BL.Top:Set(ui.Bottom)
    
    ui.BG.BM:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_lm.dds'))
    ui.BG.BM.Right:Set(ui.BG.BL.Right)
    ui.BG.BM.Top:Set(function() return ui.Bottom() end)
    ui.BG.BM.Left:Set(ui.BG.BR.Left)
    
    ui.BG.BR:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_lr.dds'))
    ui.BG.BR.Left:Set(ui.Right)
    ui.BG.BR.Top:Set(ui.Bottom)


Title:SetFont('Arial',15)
Title.Depth:Set(30)
Title:SetText('Ammunition Storage')
Text:SetFont('Arial',15)
Text.Depth:Set(30)
ui.Width:Set(Title.Width())
ui.Height:Set(25)


local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	


Text:SetColor(factions[armyInfo.armiesTable[focusarmy].faction+1].loadingColor)
Title:SetColor(factions[armyInfo.armiesTable[focusarmy].faction+1].loadingColor)

LayoutHelpers.AtCenterIn(Title, ui)
LayoutHelpers.AtTopIn(Title, ui, -10)
LayoutHelpers.AtCenterIn(Text, ui)
LayoutHelpers.AtTopIn(Text, ui, 10)
	

function UpdateUIText(Value)

Text:SetText(Value)

end


function ManageUI(Value)
if Value == true then
ui:Show()
elseif Value == false then
ui:Hide()
end
end
