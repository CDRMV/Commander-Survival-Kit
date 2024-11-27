--*****************************************************************************
--* File: lua/modules/ui/game/multifunction.lua
--* Author: Chris Blackwell
--* Summary: UI for the multifunction display
--*
--* Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--*****************************************************************************

local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Group = import('/lua/maui/group.lua').Group
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local Checkbox = import('/lua/maui/checkbox.lua').Checkbox
local Button = import('/lua/maui/button.lua').Button
local Grid = import('/lua/maui/grid.lua').Grid
local Text = import('/lua/maui/text.lua').Text
local GameCommon = import('/lua/ui/game/gamecommon.lua')
local Tooltip = import('/lua/ui/game/tooltip.lua')
local econ = import("/lua/ui/game/economy.lua")
local cmdMode = import('/lua/ui/game/commandmode.lua')
local UIPing = import('/lua/ui/game/ping.lua')
local Prefs = import('/lua/user/prefs.lua')
local miniMap = import('/lua/ui/game/minimap.lua')
local UIMain = import('/lua/ui/uimain.lua')
local Borders = import('/lua/ui/game/borders.lua')
local modtexpath = '/mods/Commander Survival Kit/textures/'
local filters = import('/lua/ui/game/rangeoverlayparams.lua').RangeOverlayParams
local worldView = import('/lua/ui/game/borders.lua').GetMapGroup()
local factions = import('/lua/factions.lua').Factions
local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	

factionname = nil
savedParent = false
layerpanel = false

controls = {
    bg = false,
}


function SetLayout(layout)
    import('/mods/Commander Survival Kit/UI/Layout/MainPanel_Layout.lua').SetLayout()
    CommonLogic()
end

function CreatePanel(parent)
    savedParent = parent
    Create()
    return SetLayout()
end			
			
    
function Create()


    controls.bg = Group(savedParent)
    
    controls.bg.panel = Bitmap(savedParent)
    controls.bg.leftBrace = Bitmap(savedParent)
    controls.bg.leftGlow = Bitmap(savedParent)
    controls.bg.rightGlowTop = Bitmap(savedParent)
    controls.bg.rightGlowMiddle = Bitmap(savedParent)
    controls.bg.rightGlowBottom = Bitmap(savedParent)
    
    controls.collapseArrow = Checkbox(savedParent)
    Tooltip.AddCheckboxTooltip(controls.collapseArrow, 'mfd_collapse')
	
   
    
    SetLayout()
  

end



function CommonLogic()
    controls.collapseArrow.OnCheck = function(self, checked)
        ToggleMFDPanel()
    end
end


--[[
function ToggleMilitary()
    GetButton('military'):ToggleCheck()
end

function ToggleDefense()
    GetButton('teamcolor'):ToggleCheck()
end

function ToggleEconomy()
    GetButton('economy'):ToggleCheck()
end

function ToggleIntel()
end
]]--





function ToggleMFDPanel(state)
    if import('/lua/ui/game/gamemain.lua').gameUIHidden then
        return
    end
    if UIUtil.GetAnimationPrefs() then
        if state or controls.bg:IsHidden() then
            PlaySound(Sound({Cue = "UI_Score_Window_Open", Bank = "Interface"}))
            controls.bg:Show()
            controls.bg:SetNeedsFrameUpdate(true)
            controls.bg.OnFrame = function(self, delta)
                local newLeft = self.Left() + (1000*delta)
                if newLeft > savedParent.Left()+15 then
                    newLeft = savedParent.Left()+15
                    self:SetNeedsFrameUpdate(false)
                end
                self.Left:Set(newLeft)
            end
            controls.collapseArrow:SetCheck(false, true)
        else
            PlaySound(Sound({Cue = "UI_Score_Window_Close", Bank = "Interface"}))
            controls.bg:SetNeedsFrameUpdate(true)
            controls.bg.OnFrame = function(self, delta)
                local newLeft = self.Left() - (1000*delta)
                if newLeft < savedParent.Left()-self.Width() - 10 then
                    newLeft = savedParent.Left()-self.Width() - 10
                    self:SetNeedsFrameUpdate(false)
                    self:Hide()
                end
                self.Left:Set(newLeft)
            end
            controls.collapseArrow:SetCheck(true, true)
        end
    else
        if state or GUI.bg:IsHidden() then
            controls.bg:Show()
            controls.collapseArrow:SetCheck(false, true)
        else
            controls.bg:Hide()
            controls.collapseArrow:SetCheck(true, true)
        end
    end
end

function Contract()
end

function Expand()
end

function InitialAnimation()
    controls.bg:Show()
    controls.bg.Left:Set(savedParent.Left()-controls.bg.Width())
    controls.bg:SetNeedsFrameUpdate(true)
    controls.bg.OnFrame = function(self, delta)
        local newLeft = self.Left() + (1000*delta)
        if newLeft > savedParent.Left()+15 then
            newLeft = savedParent.Left()+15
            self:SetNeedsFrameUpdate(false)
        end
        self.Left:Set(newLeft)
    end
    controls.collapseArrow:Show()
    controls.collapseArrow:SetCheck(false, true)
end

