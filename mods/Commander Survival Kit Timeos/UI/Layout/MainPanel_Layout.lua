


local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Button = import('/lua/maui/button.lua').Button
local CreateText = import('/lua/maui/text.lua').Text
local StatusBar = import("/lua/maui/statusbar.lua").StatusBar
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local Tooltip = import("/lua/ui/game/tooltip.lua")
local Group = import("/lua/maui/group.lua").Group

	local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )
local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.uid == "5t3edt-btz6-9437-h6ui-967gt56facsku120" then return mod.location end end end
local CSKUnitsPath = GetCSKUnitsPath()
local GetFBPOPath = function() for i, mod in __active_mods do if mod.uid == "5t3edt-btz6-9437-h6ui-967gt56fa5" then return mod.location end end end
local FBPOPath = GetFBPOPath()
   
   local controls = import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').controls
    local savedParent = import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').savedParent
    local econControl = import('/lua/ui/game/economy.lua').GUI.bg
	
	-----------------------------------------------------------------------------------------------------------------------
   
	

local number = 0

function SetLayout()

	
	-----------------------------------------------------------------------------------------------------------------------
	-- This If Statement is temporary to make the mod functional in Steam, DVD and Loud.
	-- It will be removed if the Lobby Options are added to support them
	-----------------------------------------------------------------------------------------------------------------------
	

	controls.bg.panel:SetTexture(UIUtil.SkinnableFile('/game/resource-panel/resources_panel_bmp.dds'))
    controls.bg.LBracket:SetTexture(UIUtil.SkinnableFile('/game/bracket-left-energy/bracket_bmp.dds'))
    controls.bg.RBracket:SetTexture(UIUtil.SkinnableFile('/game/bracket-right-energy/bracket_bmp.dds'))
	
    controls.collapseArrow:SetTexture(UIUtil.SkinnableFile('/game/tab-t-btn/tab-close_btn_up.dds'))
    controls.collapseArrow:SetNewTextures(UIUtil.SkinnableFile('/game/tab-t-btn/tab-close_btn_up.dds'),
	    UIUtil.SkinnableFile('/game/tab-t-btn/tab-open_btn_up.dds'),
        UIUtil.SkinnableFile('/game/tab-t-btn/tab-close_btn_over.dds'),
        UIUtil.SkinnableFile('/game/tab-t-btn/tab-open_btn_over.dds'),
        UIUtil.SkinnableFile('/game/tab-t-btn/tab-close_btn_dis.dds'),
        UIUtil.SkinnableFile('/game/tab-t-btn/tab-open_btn_dis.dds'))

	

    LayoutHelpers.AtLeftTopIn(controls.collapseArrow, econControl, 385, -5) -- 170
    controls.collapseArrow.Depth:Set(function() return controls.bg.Depth() + 10 end)
	
    
    LayoutHelpers.LeftOf(controls.bg, econControl, 5) -- 5

	controls.collapseArrow:Hide()
	
    controls.bg.Height:Set(controls.bg.panel.Height)
    controls.bg.Width:Set(controls.bg.panel.Width)
	
	controls.bg.panel.Height:Set(70)
    controls.bg.panel.Width:Set(130)
    

	LayoutHelpers.AtLeftTopIn(controls.bg.panel, econControl, 323, 0) 
	LayoutHelpers.AtLeftTopIn(controls.bg.LBracket, econControl, 320, 2)
	LayoutHelpers.AtLeftTopIn(controls.bg.RBracket, econControl, 440, 2)
	
	--SetWaitTimeText()
	
end

