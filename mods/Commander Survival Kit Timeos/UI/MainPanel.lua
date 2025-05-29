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
local miniMap = import('/lua/ui/game/minimap.lua')
local UIMain = import('/lua/ui/uimain.lua')
local Borders = import('/lua/ui/game/borders.lua')
local filters = import('/lua/ui/game/rangeoverlayparams.lua').RangeOverlayParams
local worldView = import('/lua/ui/game/borders.lua').GetMapGroup()
local CampaignConfigUI = import('/mods/Commander Survival Kit Timeos/UI/campaignconfig.lua').CampaignOptionWindow
local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.CSKProjectModName == "CSK-Units" then return mod.location end end end
local CSKUnitsPath = GetCSKUnitsPath()
local GetFBPOrbitalPath = function() for i, mod in __active_mods do if mod.FBPProjectModName == "FBP-Orbital" then return mod.location end end end
local FBPOrbitalPath = GetFBPOrbitalPath()

CampaignConfigUI:Hide()

factionname = nil
savedParent = false
layerpanel = false

controls = {
    bg = false,
}


function SetLayout(layout)
    import('/mods/Commander Survival Kit Timeos/UI/Layout/MainPanel_Layout.lua').SetLayout()
    CommonLogic()
end

function CreatePanel(parent)
    savedParent = parent
    Create()
    return SetLayout()
end			
	
TechLevel=''
function SetTechlevel(value)
TechLevel = value
end

waitTime=''
function SetWaitTime(value)
waitTime = value
end
    
function Create()


    controls.bg = Group(savedParent)
    
    controls.bg.panel = Bitmap(controls.bg)
    controls.bg.LBracket = Bitmap(controls.bg)
    controls.bg.RBracket = Bitmap(controls.bg)
	
	Techlevel = Text(controls.bg)
	Techlevel:SetText(TechLevel)
	Techlevel:SetFont('Arial',18) 
	Techlevel:SetColor('ffFFFFFF')
	WaitTime = Text(controls.bg)
	WaitTime:SetText(waitTime)	
	WaitTime:SetFont('Arial',18) 
	WaitTime:SetColor('ffFFFFFF')
	
	
		    	LayoutHelpers.AtCenterIn(Techlevel, controls.bg.panel, -15, 0)
	LayoutHelpers.DepthOverParent(Techlevel, controls.bg, 10)
	LayoutHelpers.AtCenterIn(WaitTime, controls.bg.panel, 15, 0)
	LayoutHelpers.DepthOverParent(WaitTime, controls.bg, 10)
				Tooltip.AddControlTooltip(Techlevel, import('/mods/Commander Survival Kit Timeos/lua/AI/CustomAITooltips/CSKTTooltips.lua').UnlockTechlevel)
	Tooltip.AddControlTooltip(WaitTime, import('/mods/Commander Survival Kit Timeos/lua/AI/CustomAITooltips/CSKTTooltips.lua').UnlockWaitTime)
	
    controls.collapseArrow = Checkbox(savedParent)
    Tooltip.AddCheckboxTooltip(controls.collapseArrow, import('/mods/Commander Survival Kit Timeos/lua/AI/CustomAITooltips/CSKTTooltips.lua').CSKTimeosPanel)
    SetLayout()

  
end

function UnlocktheTechlevel(Techlevel)

	RemoveBuildRestriction(self:GetArmyIndex(), categories.TECH2 + categories.ALLUNITS - categories.EXPERIMENTAL)
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

	local ScenarioInfo = SessionGetScenarioInfo()
	local Tech2 = ScenarioInfo.Options.WaitTimeTech2
	local Tech3 = ScenarioInfo.Options.WaitTimeTech3
	local Experimental = ScenarioInfo.Options.WaitTimeEXP
	local Elite = ScenarioInfo.Options.WaitTimeElite
	local Hero = ScenarioInfo.Options.WaitTimeHero
	local Titan = ScenarioInfo.Options.WaitTimeTitan
		
	if Tech2 == nil and Tech3 == nil and Experimental == nil and Elite == nil and Hero == nil and Titan == nil then
		Tech2 = 300
		Tech3 = 300
		Experimental = 300
		Elite = 300
		Hero = 300
		Titan = 300
	end
		
	local MathFloor = math.floor
	local hours = MathFloor(GetGameTimeSeconds() / 3600)
	local Seconds = GetGameTimeSeconds() - hours * 3600


    if import('/lua/ui/game/gamemain.lua').gameUIHidden then
        return
    end
    if UIUtil.GetAnimationPrefs() then
        if state or controls.bg:IsHidden() then
            PlaySound(Sound({Cue = "UI_Score_Window_Open", Bank = "Interface"}))
	
		if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
			if Seconds < Tech2 then
				ShowPanel()
			end
			if Seconds > Tech2 and Seconds < (Tech2 + Tech3) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3) and Seconds < (Tech2 + Tech3 + Elite) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite) and Seconds < (Tech2 + Tech3 + Elite + Experimental) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite + Experimental) and Seconds < (Tech2 + Tech3 + Elite + Experimental + Hero) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite + Experimental + Hero) and Seconds < (Tech2 + Tech3 + Elite + Experimental + Hero + Titan) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite + Experimental + Hero + Titan) then
				HidePanel()	
			end
		else
			if Seconds < Tech2 then
				ShowPanel()
			end
			if Seconds > Tech2 and Seconds < (Tech2 + Tech3) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3) and Seconds < (Tech2 + Tech3 + Experimental) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Experimental) then
				HidePanel()		
			end
		end
            controls.bg:SetNeedsFrameUpdate(true)
            controls.bg.OnFrame = function(self, delta)
                local newLeft = self.Top() + (1000*delta)
                if newLeft > savedParent.Top()+78 then
                    newLeft = savedParent.Top()+78
                    self:SetNeedsFrameUpdate(false)
                end
                self.Top:Set(newLeft)
            end
        else
            PlaySound(Sound({Cue = "UI_Score_Window_Close", Bank = "Interface"}))
            controls.bg:SetNeedsFrameUpdate(true)
            controls.bg.OnFrame = function(self, delta)
                local newLeft = self.Top() - (1000*delta)
                if newLeft < savedParent.Top()-self.Height() - 10 then
                    newLeft = savedParent.Top()-self.Height() - 10
                    self:SetNeedsFrameUpdate(false)
                    self:Hide()
                end
                self.Top:Set(newLeft)
            end
        end
    else
	
        if state or GUI.bg:IsHidden() then
		if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
			if Seconds < Tech2 then
				ShowPanel()
			end
			if Seconds > Tech2 and Seconds < (Tech2 + Tech3) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3) and Seconds < (Tech2 + Tech3 + Elite) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite) and Seconds < (Tech2 + Tech3 + Elite + Experimental) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite + Experimental) and Seconds < (Tech2 + Tech3 + Elite + Experimental + Hero) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite + Experimental + Hero) and Seconds < (Tech2 + Tech3 + Elite + Experimental + Hero + Titan) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite + Experimental + Hero + Titan) then
				HidePanel()	
			end
		else
			if Seconds < Tech2 then
				ShowPanel()
			end
			if Seconds > Tech2 and Seconds < (Tech2 + Tech3) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3) and Seconds < (Tech2 + Tech3 + Experimental) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Experimental) then
				HidePanel()		
			end
		end
        else
            controls.bg:Hide()

        end
    end
end

function Contract()
        ToggleMFDPanel()
end


function Expand()
controls.collapseArrow:Hide()
	local ScenarioInfo = SessionGetScenarioInfo()
	local Tech2 = ScenarioInfo.Options.WaitTimeTech2
	local Tech3 = ScenarioInfo.Options.WaitTimeTech3
	local Experimental = ScenarioInfo.Options.WaitTimeEXP
	local Elite = ScenarioInfo.Options.WaitTimeElite
	local Hero = ScenarioInfo.Options.WaitTimeHero
	local Titan = ScenarioInfo.Options.WaitTimeTitan
		
	if Tech2 == nil and Tech3 == nil and Experimental == nil and Elite == nil and Hero == nil and Titan == nil then
		Tech2 = 300
		Tech3 = 300
		Experimental = 300
		Elite = 300
		Hero = 300
		Titan = 300
	end
		
	local MathFloor = math.floor
	local hours = MathFloor(GetGameTimeSeconds() / 3600)
	local Seconds = GetGameTimeSeconds() - hours * 3600
	
		if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
			if Seconds < Tech2 then
				ShowPanel()
			end
			if Seconds > Tech2 and Seconds < (Tech2 + Tech3) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3) and Seconds < (Tech2 + Tech3 + Elite) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite) and Seconds < (Tech2 + Tech3 + Elite + Experimental) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite + Experimental) and Seconds < (Tech2 + Tech3 + Elite + Experimental + Hero) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite + Experimental + Hero) and Seconds < (Tech2 + Tech3 + Elite + Experimental + Hero + Titan) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite + Experimental + Hero + Titan) then
				HidePanel()	
			end
		else
			if Seconds < Tech2 then
				ShowPanel()
			end
			if Seconds > Tech2 and Seconds < (Tech2 + Tech3) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3) and Seconds < (Tech2 + Tech3 + Experimental) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Experimental) then
				HidePanel()		
			end
		end
end

function HidePanel()
controls.bg:Hide()
end


function ShowPanel()
controls.bg:Show()
end

function InitialAnimation()
	controls.collapseArrow:Hide()
	local ScenarioInfo = SessionGetScenarioInfo()
	local Tech2 = ScenarioInfo.Options.WaitTimeTech2
	local Tech3 = ScenarioInfo.Options.WaitTimeTech3
	local Experimental = ScenarioInfo.Options.WaitTimeEXP
	local Elite = ScenarioInfo.Options.WaitTimeElite
	local Hero = ScenarioInfo.Options.WaitTimeHero
	local Titan = ScenarioInfo.Options.WaitTimeTitan
		
	if Tech2 == nil and Tech3 == nil and Experimental == nil and Elite == nil and Hero == nil and Titan == nil then
		Tech2 = 300
		Tech3 = 300
		Experimental = 300
		Elite = 300
		Hero = 300
		Titan = 300
	end
		
	local MathFloor = math.floor
	local hours = MathFloor(GetGameTimeSeconds() / 3600)
	local Seconds = GetGameTimeSeconds() - hours * 3600
	
		if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
			if Seconds < Tech2 then
				ShowPanel()
			end
			if Seconds > Tech2 and Seconds < (Tech2 + Tech3) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3) and Seconds < (Tech2 + Tech3 + Elite) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite) and Seconds < (Tech2 + Tech3 + Elite + Experimental) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite + Experimental) and Seconds < (Tech2 + Tech3 + Elite + Experimental + Hero) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite + Experimental + Hero) and Seconds < (Tech2 + Tech3 + Elite + Experimental + Hero + Titan) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Elite + Experimental + Hero + Titan) then
				HidePanel()	
			end
		else
			if Seconds < Tech2 then
				ShowPanel()
			end
			if Seconds > Tech2 and Seconds < (Tech2 + Tech3) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3) and Seconds < (Tech2 + Tech3 + Experimental) then
				ShowPanel()
			end
			if Seconds > (Tech2 + Tech3 + Experimental) then
				HidePanel()		
			end
		end
    controls.bg.Top:Set(savedParent.Top()-controls.bg.Height())
    controls.bg:SetNeedsFrameUpdate(true)
    controls.bg.OnFrame = function(self, delta)
        local newLeft = self.Top() + (1000*delta)
        if newLeft > savedParent.Top()+78 then
            newLeft = savedParent.Top()+78
            self:SetNeedsFrameUpdate(false)
        end
        self.Top:Set(newLeft)
    end
end


