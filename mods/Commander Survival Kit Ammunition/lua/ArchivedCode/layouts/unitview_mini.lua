--[[

Modified Unitview_mini.lua for Vanilla and FAF to Create the new Panel to display the current and maximum amount of Ammunition

]]--


local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 


local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')

function SetLayout()
    local controls = import('/lua/ui/game/unitview.lua').controls
    controls.bg:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/build-over-back_bmp.dds'))
    LayoutHelpers.AtLeftIn(controls.bg, controls.parent)
    LayoutHelpers.AtBottomIn(controls.bg, controls.parent)
    
    controls.bracket:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/bracket-unit_bmp.dds'))
    LayoutHelpers.AtLeftTopIn(controls.bracket, controls.bg, -18, -2)
    
    if controls.bracketMid then
        controls.bracketMid:Destroy()
        controls.bracketMid = false
    end
    if controls.bracketMax then
        controls.bracketMax:Destroy()
        controls.bracketMax = false
    end
    
    LayoutHelpers.AtLeftTopIn(controls.name, controls.bg, 16, 14)
    LayoutHelpers.AtRightIn(controls.name, controls.bg, 16)
    controls.name:SetClipToWidth(true)
    controls.name:SetDropShadow(true)
    
    LayoutHelpers.AtLeftTopIn(controls.icon, controls.bg, 12, 34)
    controls.icon.Height:Set(48)
    controls.icon.Width:Set(48)
    LayoutHelpers.AtLeftTopIn(controls.stratIcon, controls.icon)
    LayoutHelpers.Below(controls.vetIcons[1], controls.icon, 5)
    LayoutHelpers.AtLeftIn(controls.vetIcons[1], controls.icon, -5)
    for index = 2, 5 do
        local i = index
        LayoutHelpers.RightOf(controls.vetIcons[i], controls.vetIcons[i-1], -3)
    end
    LayoutHelpers.AtLeftTopIn(controls.healthBar, controls.bg, 66, 35)
    controls.healthBar.Width:Set(188)
    controls.healthBar.Height:Set(16)
    controls.healthBar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_bg.dds'))
    controls.healthBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_green.dds'))
    LayoutHelpers.AtBottomIn(controls.shieldBar, controls.healthBar)
    LayoutHelpers.AtLeftIn(controls.shieldBar, controls.healthBar)
    controls.shieldBar.Width:Set(188)
    controls.shieldBar.Height:Set(2)
    controls.shieldBar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_bg.dds'))
    controls.shieldBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/shieldbar.dds'))
    LayoutHelpers.Below(controls.fuelBar, controls.shieldBar)
    controls.fuelBar.Width:Set(188)
    controls.fuelBar.Height:Set(2)
    controls.fuelBar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_bg.dds'))
    controls.fuelBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/fuelbar.dds'))
    LayoutHelpers.AtCenterIn(controls.health, controls.healthBar)
    controls.health:SetDropShadow(true)
    
    local iconPositions = {
        [1] = {Left = 70, Top = 60},
        [3] = {Left = 140, Top = 60},
        [5] = {Left = 190, Top = 60},
    }
    local iconTextures = {
        UIUtil.UIFile('/game/unit_view_icons/mass.dds'),
        UIUtil.UIFile('/game/unit_view_icons/energy.dds'),
        UIUtil.UIFile('/game/unit_view_icons/kills.dds'),
        UIUtil.UIFile('/game/unit_view_icons/missiles.dds'),
        UIUtil.UIFile('/game/unit_view_icons/shield.dds'),
        UIUtil.UIFile('/game/unit_view_icons/fuel.dds'),
    }
    for index = 1, 6 do
        local i = index
        if iconPositions[i] then
            LayoutHelpers.AtLeftTopIn(controls.statGroups[i].icon, controls.bg, iconPositions[i].Left, iconPositions[i].Top)
        else
            LayoutHelpers.Below(controls.statGroups[i].icon, controls.statGroups[i-1].icon, 5)
        end
        controls.statGroups[i].icon:SetTexture(iconTextures[i])
        LayoutHelpers.RightOf(controls.statGroups[i].value, controls.statGroups[i].icon, 5)
        LayoutHelpers.AtVerticalCenterIn(controls.statGroups[i].value, controls.statGroups[i].icon)
        controls.statGroups[i].value:SetDropShadow(true)
    end
    LayoutHelpers.AtLeftTopIn(controls.actionIcon, controls.bg, 261, 34)
    controls.actionIcon.Height:Set(48)
    controls.actionIcon.Width:Set(48)
    LayoutHelpers.Below(controls.actionText, controls.actionIcon)
    LayoutHelpers.AtHorizontalCenterIn(controls.actionText, controls.actionIcon)
    
    controls.abilities.Left:Set(function() return controls.bg.Right() + 19 end)
    controls.abilities.Bottom:Set(function() return controls.bg.Bottom() - 50 end)
    controls.abilities.Height:Set(50)
    controls.abilities.Width:Set(200)
    
    controls.abilityBG.TL:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_ul.dds'))
    controls.abilityBG.TL.Right:Set(controls.abilities.Left)
    controls.abilityBG.TL.Bottom:Set(controls.abilities.Top)
    
    controls.abilityBG.TM:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_horz_um.dds'))
    controls.abilityBG.TM.Right:Set(controls.abilityBG.TL.Right)
    controls.abilityBG.TM.Bottom:Set(function() return controls.abilities.Top() end)
    controls.abilityBG.TM.Left:Set(controls.abilityBG.TR.Left)
    
    controls.abilityBG.TR:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_ur.dds'))
    controls.abilityBG.TR.Left:Set(controls.abilities.Right)
    controls.abilityBG.TR.Bottom:Set(controls.abilities.Top)
    
    controls.abilityBG.ML:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_vert_l.dds'))
    controls.abilityBG.ML.Right:Set(controls.abilities.Left)
    controls.abilityBG.ML.Top:Set(controls.abilityBG.TL.Bottom)
    controls.abilityBG.ML.Bottom:Set(controls.abilityBG.BL.Top)
    
    controls.abilityBG.M:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_m.dds'))
    controls.abilityBG.M.Top:Set(controls.abilityBG.TM.Bottom)
    controls.abilityBG.M.Left:Set(controls.abilityBG.ML.Right)
    controls.abilityBG.M.Right:Set(controls.abilityBG.MR.Left)
    controls.abilityBG.M.Bottom:Set(controls.abilityBG.BM.Top)
    
    controls.abilityBG.MR:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_vert_r.dds'))
    controls.abilityBG.MR.Left:Set(controls.abilities.Right)
    controls.abilityBG.MR.Top:Set(controls.abilityBG.TR.Bottom)
    controls.abilityBG.MR.Bottom:Set(controls.abilityBG.BR.Top)
    
    controls.abilityBG.BL:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_ll.dds'))
    controls.abilityBG.BL.Right:Set(controls.abilities.Left)
    controls.abilityBG.BL.Top:Set(controls.abilities.Bottom)
    
    controls.abilityBG.BM:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_lm.dds'))
    controls.abilityBG.BM.Right:Set(controls.abilityBG.BL.Right)
    controls.abilityBG.BM.Top:Set(function() return controls.abilities.Bottom() end)
    controls.abilityBG.BM.Left:Set(controls.abilityBG.BR.Left)
    
    controls.abilityBG.BR:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_lr.dds'))
    controls.abilityBG.BR.Left:Set(controls.abilities.Right)
    controls.abilityBG.BR.Top:Set(controls.abilities.Bottom)
	
	controls.ammunition.Left:Set(function() return controls.abilities.Right() + 30 end)
    controls.ammunition.Bottom:Set(function() return controls.bg.Bottom() - 50 end)
    controls.ammunition.Height:Set(50)
    controls.ammunition.Width:Set(200)
    
    controls.ammunitionBG.TL:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_ul.dds'))
    controls.ammunitionBG.TL.Right:Set(controls.ammunition.Left)
    controls.ammunitionBG.TL.Bottom:Set(controls.ammunition.Top)
    
    controls.ammunitionBG.TM:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_horz_um.dds'))
    controls.ammunitionBG.TM.Right:Set(controls.ammunitionBG.TL.Right)
    controls.ammunitionBG.TM.Bottom:Set(function() return controls.ammunition.Top() end)
    controls.ammunitionBG.TM.Left:Set(controls.ammunitionBG.TR.Left)
    
    controls.ammunitionBG.TR:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_ur.dds'))
    controls.ammunitionBG.TR.Left:Set(controls.ammunition.Right)
    controls.ammunitionBG.TR.Bottom:Set(controls.ammunition.Top)
    
    controls.ammunitionBG.ML:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_vert_l.dds'))
    controls.ammunitionBG.ML.Right:Set(controls.ammunition.Left)
    controls.ammunitionBG.ML.Top:Set(controls.ammunitionBG.TL.Bottom)
    controls.ammunitionBG.ML.Bottom:Set(controls.ammunitionBG.BL.Top)
    
    controls.ammunitionBG.M:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_m.dds'))
    controls.ammunitionBG.M.Top:Set(controls.ammunitionBG.TM.Bottom)
    controls.ammunitionBG.M.Left:Set(controls.ammunitionBG.ML.Right)
    controls.ammunitionBG.M.Right:Set(controls.ammunitionBG.MR.Left)
    controls.ammunitionBG.M.Bottom:Set(controls.ammunitionBG.BM.Top)
    
    controls.ammunitionBG.MR:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_vert_r.dds'))
    controls.ammunitionBG.MR.Left:Set(controls.ammunition.Right)
    controls.ammunitionBG.MR.Top:Set(controls.ammunitionBG.TR.Bottom)
    controls.ammunitionBG.MR.Bottom:Set(controls.ammunitionBG.BR.Top)
    
    controls.ammunitionBG.BL:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_ll.dds'))
    controls.ammunitionBG.BL.Right:Set(controls.ammunition.Left)
    controls.ammunitionBG.BL.Top:Set(controls.ammunition.Bottom)
    
    controls.ammunitionBG.BM:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_lm.dds'))
    controls.ammunitionBG.BM.Right:Set(controls.ammunitionBG.BL.Right)
    controls.ammunitionBG.BM.Top:Set(function() return controls.ammunition.Bottom() end)
    controls.ammunitionBG.BM.Left:Set(controls.ammunitionBG.BR.Left)
    
    controls.ammunitionBG.BR:SetTexture(UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_lr.dds'))
    controls.ammunitionBG.BR.Left:Set(controls.ammunition.Right)
    controls.ammunitionBG.BR.Top:Set(controls.ammunition.Bottom)
end

function PositionWindow()
    local controls = import('/lua/ui/game/unitview.lua').controls
    local consControl = import('/lua/ui/game/construction.lua').controls.constructionGroup
    if consControl:IsHidden() then
        LayoutHelpers.AtBottomIn(controls.bg, controls.parent)
        controls.abilities.Bottom:Set(function() return controls.bg.Bottom() - 24 end)
		controls.ammunition.Bottom:Set(function() return controls.bg.Bottom() - 24 end)
    else
        LayoutHelpers.AtBottomIn(controls.bg, controls.parent, 120)
        controls.abilities.Bottom:Set(function() return controls.bg.Bottom() - 42 end)
		controls.ammunition.Bottom:Set(function() return controls.bg.Bottom() - 42 end)
    end
    LayoutHelpers.AtLeftIn(controls.bg, controls.parent, 17)
end

else

local UIUtil = import("/lua/ui/uiutil.lua")
local LayoutHelpers = import("/lua/maui/layouthelpers.lua")
local Prefs = import("/lua/user/prefs.lua")
local options = Prefs.GetFromCurrentProfile('options')
local NinePatch = import("/lua/ui/controls/ninepatch.lua").NinePatch
local controls = import("/lua/ui/game/unitview.lua").controls
local consControl = import("/lua/ui/game/construction.lua").controls.constructionGroup
local ordersControls = import("/lua/ui/game/orders.lua").controls

local iconPositions = {
    [1] = {Left = 70, Top = 55},
    [2] = {Left = 70, Top = 70},
    [3] = {Left = 190, Top = 60},
    [4] = {Left = 130, Top = 55},
    [5] = {Left = 130, Top = 85},
    [6] = {Left = 130, Top = 70},
    [7] = {Left = 190, Top = 85},
    [8] = {Left = 70, Top = 85},
}
local iconTextures = {
    UIUtil.UIFile('/game/unit_view_icons/mass.dds'),
    UIUtil.UIFile('/game/unit_view_icons/energy.dds'),
    UIUtil.UIFile('/game/unit_view_icons/kills.dds'),
    UIUtil.UIFile('/game/unit_view_icons/kills.dds'),
    UIUtil.UIFile('/game/unit_view_icons/missiles.dds'),
    UIUtil.UIFile('/game/unit_view_icons/shield.dds'),
    UIUtil.UIFile('/game/unit_view_icons/fuel.dds'),
    UIUtil.UIFile('/game/unit_view_icons/build.dds'),
    UIUtil.UIFile('/game/unit_view_icons/reclaim_alt_mass.dds'),
    UIUtil.UIFile('/game/unit_view_icons/reclaim_alt_energy.dds'),
}

function SetLayout()
    controls.bg:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/build-over-back_bmp.dds'))
    LayoutHelpers.AtLeftIn(controls.bg, controls.parent)
    LayoutHelpers.AtBottomIn(controls.bg, controls.parent)
    
    LayoutHelpers.Above(controls.queue, controls.bg, 10)
    LayoutHelpers.AtLeftIn(controls.queue, controls.bg, 3)
    controls.queue:SetThemeTextures()

    controls.bracket:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/bracket-unit_bmp.dds'))
    LayoutHelpers.AtLeftTopIn(controls.bracket, controls.bg, -18, -2)

    if controls.bracketMid then
        controls.bracketMid:Destroy()
        controls.bracketMid = false
    end
    if controls.bracketMax then
        controls.bracketMax:Destroy()
        controls.bracketMax = false
    end

    LayoutHelpers.AtLeftTopIn(controls.name, controls.bg, 16, 14)
    LayoutHelpers.AtRightIn(controls.name, controls.bg, 16)
    controls.name:SetClipToWidth(true)
    controls.name:SetDropShadow(true)

    LayoutHelpers.AtLeftTopIn(controls.icon, controls.bg, 12, 34)
    LayoutHelpers.SetDimensions(controls.icon, 48, 48)
    LayoutHelpers.AtLeftTopIn(controls.stratIcon, controls.icon)
    LayoutHelpers.Below(controls.vetIcons[1], controls.icon, 5)
    LayoutHelpers.AtLeftIn(controls.vetIcons[1], controls.icon, -5)
    for index = 2, 5 do
        local i = index
        LayoutHelpers.RightOf(controls.vetIcons[i], controls.vetIcons[i-1], -3)
    end
    LayoutHelpers.AtLeftTopIn(controls.healthBar, controls.bg, 66, 35)
    LayoutHelpers.SetDimensions(controls.healthBar, 188, 16)
    controls.healthBar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_bg.dds'))
    controls.healthBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_green.dds'))
    LayoutHelpers.AtBottomIn(controls.shieldBar, controls.healthBar)
    LayoutHelpers.AtLeftIn(controls.shieldBar, controls.healthBar)
    LayoutHelpers.SetDimensions(controls.shieldBar, 188, 2)
    controls.shieldBar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_bg.dds'))
    controls.shieldBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/shieldbar.dds'))
    LayoutHelpers.Below(controls.fuelBar, controls.shieldBar)
    LayoutHelpers.SetDimensions(controls.fuelBar, 188, 2)
    controls.fuelBar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_bg.dds'))
    controls.fuelBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/fuelbar.dds'))

    LayoutHelpers.AtLeftTopIn(controls.vetBar, controls.bg, 192, 68)
    LayoutHelpers.SetDimensions(controls.vetBar, 56, 3)
    controls.vetBar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_bg.dds'))
    controls.vetBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/fuelbar.dds'))

    LayoutHelpers.AtLeftTopIn(controls.ReclaimGroup, controls.bg, 188, 58)
    LayoutHelpers.SetDimensions(controls.ReclaimGroup, 100, 48)
    -- LayoutHelpers.AtLeftTopIn(controls.ReclaimGroup.Title, controls.ReclaimGroup, -10, 0)
    controls.ReclaimGroup.MassIcon:SetTexture(iconTextures[9])
    controls.ReclaimGroup.EnergyIcon:SetTexture(iconTextures[10])
    LayoutHelpers.AtLeftTopIn(controls.ReclaimGroup.MassIcon, controls.ReclaimGroup, 1, 2)
    LayoutHelpers.RightOf(controls.ReclaimGroup.EnergyIcon, controls.ReclaimGroup.MassIcon, 5)

    LayoutHelpers.Below(controls.ReclaimGroup.MassText, controls.ReclaimGroup.MassIcon, 2)
    LayoutHelpers.AtHorizontalCenterIn(controls.ReclaimGroup.MassText, controls.ReclaimGroup.MassIcon, -2)


    LayoutHelpers.Below(controls.ReclaimGroup.EnergyText, controls.ReclaimGroup.EnergyIcon, 2)
    LayoutHelpers.AtHorizontalCenterIn(controls.ReclaimGroup.EnergyText, controls.ReclaimGroup.EnergyIcon, -2)

    LayoutHelpers.FillParent(controls.ReclaimGroup.Debug, controls.ReclaimGroup)

    controls.ReclaimGroup.Debug:SetSolidColor('00ffffff')
    controls.ReclaimGroup.Debug.Depth:Set(-1000000)

    LayoutHelpers.Below(controls.nextVet, controls.vetBar)
    controls.nextVet:SetDropShadow(true)
    LayoutHelpers.Above(controls.vetTitle, controls.vetBar)
    controls.vetTitle:SetDropShadow(true)

    LayoutHelpers.AtCenterIn(controls.health, controls.healthBar)
    controls.health:SetDropShadow(true)

    for index = 1, table.getn(iconPositions) do
        local i = index
        if iconPositions[i] then
            LayoutHelpers.AtLeftTopIn(controls.statGroups[i].icon, controls.bg, iconPositions[i].Left, iconPositions[i].Top)
        else
            LayoutHelpers.Below(controls.statGroups[i].icon, controls.statGroups[i-1].icon, 5)
        end
        controls.statGroups[i].icon:SetTexture(iconTextures[i])
        LayoutHelpers.RightOf(controls.statGroups[i].value, controls.statGroups[i].icon, 5)
        LayoutHelpers.AtVerticalCenterIn(controls.statGroups[i].value, controls.statGroups[i].icon)
        controls.statGroups[i].value:SetDropShadow(true)
    end
    LayoutHelpers.AtLeftTopIn(controls.actionIcon, controls.bg, 261, 34)
    LayoutHelpers.SetDimensions(controls.actionIcon, 48, 48)
    LayoutHelpers.Below(controls.actionText, controls.actionIcon)
    LayoutHelpers.AtHorizontalCenterIn(controls.actionText, controls.actionIcon)

    LayoutHelpers.AnchorToRight(controls.abilities, controls.bg, 19)
    LayoutHelpers.AtBottomIn(controls.abilities, controls.bg, 50)
    LayoutHelpers.SetDimensions(controls.abilities, 200, 50)
	
	LayoutHelpers.AnchorToRight(controls.ammunition, controls.abilities, 30)
    LayoutHelpers.AtBottomIn(controls.ammunition, controls.bg, 50)
    LayoutHelpers.SetDimensions(controls.ammunition, 200, 50)

    SetBG(controls)

    if options.gui_detailed_unitview ~= 0 then
        LayoutHelpers.AtLeftTopIn(controls.healthBar, controls.bg, 66, 25)
        LayoutHelpers.Below(controls.shieldBar, controls.healthBar)
        LayoutHelpers.SetHeight(controls.shieldBar, 14)
        LayoutHelpers.CenteredBelow(controls.shieldText, controls.shieldBar,0)
        LayoutHelpers.SetHeight(controls.shieldBar, 2)
    else
        LayoutHelpers.AtLeftTopIn(controls.statGroups[1].icon, controls.bg, 70, 60)
        LayoutHelpers.AtLeftTopIn(controls.statGroups[2].icon, controls.bg, 70, 80)
    end
end

function SetBG(controls)
    if controls.abilityBG then controls.abilityBG:Destroy() end
    controls.abilityBG = NinePatch(controls.abilities,
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_m.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_ul.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_ur.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_ll.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_lr.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_vert_l.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_vert_r.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_horz_um.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_lm.dds')
)

    if controls.ammunitionBG then controls.ammunitionBG:Destroy() end
    controls.ammunitionBG = NinePatch(controls.ammunition,
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_m.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_ul.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_ur.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_ll.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_lr.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_vert_l.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_vert_r.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_horz_um.dds'),
        UIUtil.UIFile('/game/filter-ping-list-panel/panel_brd_lm.dds')
)

    controls.abilityBG:Surround(controls.abilities, 3, 5)
    LayoutHelpers.DepthUnderParent(controls.abilityBG, controls.abilities)
	controls.ammunitionBG:Surround(controls.ammunition, 3, 5)
    LayoutHelpers.DepthUnderParent(controls.ammunitionBG, controls.ammunition)
end

function PositionWindow()
    if consControl:IsHidden() then
        LayoutHelpers.AtBottomIn(controls.bg, controls.parent)
        LayoutHelpers.AtBottomIn(controls.abilities, controls.bg, 24)
		 LayoutHelpers.AtBottomIn(controls.ammunition, controls.bg, 24)
    else
        if ordersControls.bg then
            LayoutHelpers.AtBottomIn(controls.bg, controls.parent, 120)
            LayoutHelpers.AtBottomIn(controls.abilities, controls.bg, 42)
			LayoutHelpers.AtBottomIn(controls.ammunition, controls.bg, 42)
        else
            -- Replay? Anyway, the orders control does not exist so the construction control is all the way to the left.
            -- The construction control is taller than the orders control, so we have to move unit view higher.
            LayoutHelpers.AtBottomIn(controls.bg, controls.parent, 140)
            LayoutHelpers.AtLeftIn(controls.bg, controls.parent, 18)
        end
    end
    LayoutHelpers.AtLeftIn(controls.bg, controls.parent, 17)
end

function UpdateStatusBars(controls)
    if options.gui_detailed_unitview ~= 0 and controls.store == 1 then
        LayoutHelpers.CenteredBelow(controls.fuelBar, controls.shieldBar,3)
        LayoutHelpers.CenteredBelow(controls.shieldText, controls.fuelBar,-2.5)
    elseif options.gui_detailed_unitview ~= 0 then
        LayoutHelpers.CenteredBelow(controls.fuelBar, controls.shieldBar,0)
        LayoutHelpers.CenteredBelow(controls.shieldText, controls.shieldBar,0)
    end
end

end 

