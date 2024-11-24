local factions = import('/lua/factions.lua').Factions
local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Button = import('/lua/maui/button.lua').Button

function SetLayout()
    local controls = import('/mods/Commander Survival Kit/UI/MainPanel.lua').controls
    local savedParent = import('/mods/Commander Survival Kit/UI/MainPanel.lua').savedParent
    local econControl = import('/lua/ui/game/economy.lua').GUI.bg
    
    controls.bg.panel:SetTexture('/textures/ui/uef/game/filter-ping-panel/filter-ping-panel02_bmp.dds')
    controls.bg.leftBrace:SetTexture('/textures/ui/uef/game/filter-ping-panel/bracket-left_bmp.dds')
    controls.bg.leftGlow:SetTexture('/textures/ui/uef/game/filter-ping-panel/bracket-energy-l_bmp.dds')
    controls.bg.rightGlowTop:SetTexture('/textures/ui/uef/game/bracket-right-energy/bracket_bmp_t.dds')
    controls.bg.rightGlowMiddle:SetTexture('/textures/ui/uef/game/bracket-right-energy/bracket_bmp_m.dds')
    controls.bg.rightGlowBottom:SetTexture('/textures/ui/uef/game/bracket-right-energy/bracket_bmp_b.dds')
    
    controls.collapseArrow:SetTexture('/textures/ui/uef/game/tab-l-btn/tab-close_btn_up.dds')
    controls.collapseArrow:SetNewTextures('/textures/ui/uef/game/tab-l-btn/tab-close_btn_up.dds',
        '/textures/ui/uef/game/tab-l-btn/tab-open_btn_up.dds',
        '/textures/ui/uef/game/tab-l-btn/tab-close_btn_over.dds',
        '/textures/ui/uef/game/tab-l-btn/tab-open_btn_over.dds',
        '/textures/ui/uef/game/tab-l-btn/tab-close_btn_dis.dds',
        '/textures/ui/uef/game/tab-l-btn/tab-open_btn_dis.dds')
    LayoutHelpers.AtLeftTopIn(controls.collapseArrow, GetFrame(0), -3, 240) -- 170
    controls.collapseArrow.Depth:Set(function() return controls.bg.Depth() + 10 end)
    
    LayoutHelpers.Below(controls.bg, econControl, 75) -- 5
    if controls.collapseArrow:IsChecked() then
        LayoutHelpers.AtLeftIn(controls.bg, savedParent, -200)
    else
        LayoutHelpers.AtLeftIn(controls.bg, savedParent, 15)
    end
    controls.bg.Height:Set(controls.bg.panel.Height)
    controls.bg.Width:Set(controls.bg.panel.Width)
    
    LayoutHelpers.AtLeftTopIn(controls.bg.panel, controls.bg, 2, 75) -- 75
    controls.bg.leftBrace.Right:Set(function() return controls.bg.Left() + 11 end)
    controls.bg.leftBrace.Top:Set(function() return controls.bg.Top() + 75 end)
    controls.bg.leftGlow.Left:Set(function() return controls.bg.leftBrace.Left() + 12 end)
    controls.bg.leftGlow.Top:Set(function() return controls.bg.Top() + 74 end)
    controls.bg.leftGlow.Depth:Set(function() return controls.bg.leftBrace.Depth() - 1 end)
    controls.bg.rightGlowTop.Top:Set(function() return controls.bg.Top() + 78 end)
    controls.bg.rightGlowTop.Left:Set(function() return controls.bg.Right() - 9 end)
    controls.bg.rightGlowBottom.Bottom:Set(function() return controls.bg.Bottom() + 72 end)
    controls.bg.rightGlowBottom.Left:Set(controls.bg.rightGlowTop.Left)
    controls.bg.rightGlowMiddle.Top:Set(controls.bg.rightGlowTop.Bottom)
    controls.bg.rightGlowMiddle.Bottom:Set(function() return math.max(controls.bg.rightGlowTop.Bottom(), controls.bg.rightGlowBottom.Top()) end)
    controls.bg.rightGlowMiddle.Right:Set(function() return controls.bg.rightGlowTop.Right() end)
    
    local MainButton
	if focusarmy >= 1 then
MainButton = UIUtil.CreateButtonStd(controls.bg, '/mods/Commander Survival Kit/textures/icon', nil, 11)
    MainButton.Height:Set(55)
    MainButton.Width:Set(80)
	LayoutHelpers.AtLeftTopIn(MainButton, controls.bg, 12, 81)
	LayoutHelpers.DepthOverParent(MainButton, controls.bg, 10)
    end

    
end