

local UIUtil = import("/lua/ui/uiutil.lua")
local Group = import("/lua/maui/group.lua").Group
local Bitmap = import("/lua/maui/bitmap.lua").Bitmap
local LayoutHelpers = import("/lua/maui/layouthelpers.lua")
local TooltipInfo = import("/lua/ui/help/tooltips.lua")
local Prefs = import("/lua/user/prefs.lua")
local Button = import("/lua/maui/button.lua").Button
local Edit = import("/lua/maui/edit.lua").Edit
local Checkbox = import("/lua/maui/checkbox.lua").Checkbox
local Keymapping = import("/lua/keymap/defaultkeymap.lua").defaultKeyMap
local mouseoverDisplay = false
local createThread = false
local MathFloor = math.floor
local MathCeil = math.ceil
local pixelScaleFactor = import("/lua/user/prefs.lua").GetFromCurrentProfile("options").ui_scale or 1


	

function ScaleNumber(number)
    return MathFloor(number * pixelScaleFactor)
end

function DestroyMouseoverDisplay()
    if createThread then
        KillThread(createThread)
    end
    if mouseoverDisplay then
        mouseoverDisplay:Destroy()
        mouseoverDisplay = false
    end
end

function CreateToolTip(parent, text)
    local tooltip = UIUtil.CreateText(parent, LOC(text), 12, UIUtil.bodyFont)
    tooltip.Depth:Set(function() return parent.Depth() + 10000 end)

    tooltip.bg = Bitmap(tooltip)
    tooltip.bg:SetSolidColor(UIUtil.tooltipTitleColor)
    tooltip.bg.Depth:Set(function() return tooltip.Depth() - 1 end)
    tooltip.bg.Top:Set(tooltip.Top)
    tooltip.bg.Bottom:Set(tooltip.Bottom)
    LayoutHelpers.AtLeftIn(tooltip.bg, tooltip, -2)
    LayoutHelpers.AtRightIn(tooltip.bg, tooltip, -2)

    tooltip.border = Bitmap(tooltip)
    tooltip.border:SetSolidColor(UIUtil.tooltipBorderColor)
    tooltip.border.Depth:Set(function() return tooltip.bg.Depth() - 1 end)
    LayoutHelpers.AtLeftTopIn(tooltip.border, tooltip, -1, -1)
    LayoutHelpers.AtRightBottomIn(tooltip.border, tooltip, -1, -1)

    tooltip:DisableHitTest(true)

    return tooltip
end



function CreateResearchToolTip(parent, cost, text, desc, prerequisite, width, padding, descFontSize, textFontSize)
    text = LOC(text)
    desc = LOC(desc)
    -- scale padding by UI scaling factor so we do not need to do this later in code
    -- when adjusting position of tooltip elements
    -- default padding should be 2-4 to text is not to close to tooltip border but kept original value
    padding = ScaleNumber(padding or 0)
    -- using passed font size or falling back to default values which should be the same but kept original values
    descFontSize = descFontSize or 12
    textFontSize = textFontSize or 14
    -- calculating an offset for lower letters: p, j so they are not clipped by header background
    local textFillOffset = ScaleNumber(textFontSize / 4)
     
    if width then -- adjusting width by optional padding
       width = width + (padding + padding)
    end

    if text == '' then
         text = nil
    end
    if desc == '' then
         desc = nil
    end

    if text or desc then
        -- using Bitmap instead of Group so we do not need to create tooltip.extbg = Bitmap(tooltip)
        local tooltip = Bitmap(parent)
            tooltip:SetSolidColor('FF000202')
        tooltip.Depth:Set(function() return parent.Depth() + 10000 end)
		
		        if text then
            -- creating tooltip title
            tooltip.title = UIUtil.CreateText(tooltip, text, textFontSize, UIUtil.bodyFont)
            tooltip.title.Top:Set(tooltip.Top)
            tooltip.title.Top:Set(function() return tooltip.Top() + 13 end)
            tooltip.title.Left:Set(function() return tooltip.Left() + padding + 80 end)
            -- creating background fill for tooltip title
            tooltip.bg = Bitmap(tooltip)
            
            tooltip.bg:SetSolidColor(UIUtil.tooltipTitleColor)
            tooltip.bg.Depth:Set(function() return tooltip.title.Depth() - 1 end)
            tooltip.bg.Top:Set(function() return tooltip.Top() end)
            tooltip.bg.Left:Set(function() return tooltip.Left() end)
            tooltip.bg.Right:Set(function() return tooltip.title.Right() + 10 end)
            tooltip.bg.Bottom:Set(function() return tooltip.title.Bottom() + 10 end)
			
			        tooltip.extborder = Bitmap(tooltip.bg)
        tooltip.extborder:SetSolidColor(UIUtil.tooltipBorderColor)
        tooltip.extborder.Depth:Set(function() return tooltip.bg.Depth() - 1 end)
        tooltip:DisableHitTest(true)
        LayoutHelpers.FillParentFixedBorder(tooltip.extborder, tooltip.bg, -1)
        end
		
			logotxt = UIUtil.UIFile('/mods/Commander Survival Kit Research/textures/icon.dds')
            tooltip.logo = Bitmap(tooltip, logotxt)
			tooltip.logo.Width:Set(35)
			tooltip.logo.Height:Set(35)
			tooltip.logo.Top:Set(tooltip.Top)
            tooltip.logo.Top:Set(function() return tooltip.Top() + textFillOffset end)
            tooltip.logo.Left:Set(function() return tooltip.Left() + padding end)
			tooltip.logobg = Bitmap(tooltip)
            tooltip.logobg:SetSolidColor('FF000202')
            tooltip.logobg.Depth:Set(function() return tooltip.Depth() end)
            tooltip.logobg.Top:Set(function() return tooltip.logo.Top() end)
            tooltip.logobg.Left:Set(function() return tooltip.logo.Left()end)
            tooltip.logobg.Right:Set(function() return tooltip.logo.Right() end)
            tooltip.logobg.Bottom:Set(function() return tooltip.logo.Bottom() end)
			
						        tooltip.extborder2 = Bitmap(tooltip.logobg)
        tooltip.extborder2:SetSolidColor(UIUtil.tooltipBorderColor)
        tooltip.extborder2.Depth:Set(function() return tooltip.logobg.Depth() - 1 end)
        tooltip:DisableHitTest(true)
        LayoutHelpers.FillParentFixedBorder(tooltip.extborder2, tooltip.logobg, -1)
			
            tooltip.cost = UIUtil.CreateText(tooltip, cost, textFontSize, UIUtil.bodyFont)
            tooltip.cost.Top:Set(tooltip.Top)
            tooltip.cost.Top:Set(function() return tooltip.Top() + 13 end)
            tooltip.cost.Left:Set(function() return tooltip.Left() + padding + 50 end)
            -- creating background fill for tooltip title
            tooltip.cbg = Bitmap(tooltip)
            
            tooltip.cbg:SetSolidColor('FF000202')
            tooltip.cbg.Depth:Set(function() return tooltip.cost.Depth() - 1 end)
            tooltip.cbg.Top:Set(function() return tooltip.cost.Top() end)
            tooltip.cbg.Left:Set(function() return tooltip.cost.Left() end)
            tooltip.cbg.Right:Set(function() return tooltip.cost.Right() end)
            tooltip.cbg.Bottom:Set(function() return tooltip.cost.Bottom() end)
			
		tooltip.extborder3 = Bitmap(tooltip.cbg)
        tooltip.extborder3:SetSolidColor(UIUtil.tooltipBorderColor)
        tooltip.extborder3.Depth:Set(function() return tooltip.cbg.Depth() - 1 end)
        tooltip:DisableHitTest(true)
        LayoutHelpers.FillParentFixedBorder(tooltip.extborder3, tooltip.cbg, -1)



        tooltip.desc = {}
        local tempTable = false

        if desc then
            tooltip.desc[1] = UIUtil.CreateText(tooltip, "", descFontSize, UIUtil.bodyFont)
            tooltip.desc[1].Width:Set(tooltip.Width)
            if text == nil then
                tooltip.desc[1].Top:Set(function() return tooltip.Top() + padding end)
                tooltip.desc[1].Left:Set(function() return tooltip.Left() + padding end)

            else
				tooltip.desc[1].Top:Set(function() return tooltip.title.Bottom() + padding end)
			    tooltip.desc[1].Left:Set(function() return tooltip.Left() + padding end)
                tooltip.desc[1].Top:Set(function() return tooltip.bg.Bottom() + padding + 10 end)
                tooltip.desc[1].Right:Set(function() return tooltip.bg.Right() + padding end)
				            tooltip.dbg = Bitmap(tooltip)
            
            tooltip.dbg:SetSolidColor('FF000202')
            tooltip.dbg.Depth:Set(function() return tooltip.desc[1].Depth() - 1 end)
            tooltip.dbg.Top:Set(function() return tooltip.bg.Bottom() end)
            tooltip.dbg.Left:Set(function() return tooltip.desc[1].Left() end)
            tooltip.dbg.Right:Set(function() return tooltip.desc[1].Right() end)
            tooltip.dbg.Bottom:Set(function() return tooltip.desc[1].Bottom() + 10 end)
			
					tooltip.extborder4 = Bitmap(tooltip.dbg)
        tooltip.extborder4:SetSolidColor(UIUtil.tooltipBorderColor)
        tooltip.extborder4.Depth:Set(function() return tooltip.dbg.Depth() - 1 end)
        tooltip:DisableHitTest(true)
        LayoutHelpers.FillParentFixedBorder(tooltip.extborder4, tooltip.dbg, -1)
		
			tooltip.preq = UIUtil.CreateText(tooltip, 'Prerequisite: ' .. prerequisite, textFontSize, UIUtil.bodyFont)
            tooltip.preq.Bottom:Set(tooltip.Bottom)
            tooltip.preq.Bottom:Set(function() return tooltip.dbg.Bottom() + 15 end)
            tooltip.preq.Left:Set(function() return tooltip.Left() + padding end)
            -- creating background fill for tooltip title
            tooltip.pbg = Bitmap(tooltip)
            
            tooltip.pbg:SetSolidColor(UIUtil.tooltipTitleColor)
            tooltip.pbg.Depth:Set(function() return tooltip.preq.Depth() - 1 end)
            tooltip.pbg.Top:Set(function() return tooltip.preq.Top() - 1 end)
            tooltip.pbg.Left:Set(function() return tooltip.preq.Left() end)
            tooltip.pbg.Right:Set(function() return tooltip.title.Right() + 10 end)
            tooltip.pbg.Bottom:Set(function() return tooltip.preq.Bottom() + 1 end)
			
			        tooltip.extborder5 = Bitmap(tooltip.pbg)
        tooltip.extborder5:SetSolidColor(UIUtil.tooltipBorderColor)
        tooltip.extborder5.Depth:Set(function() return tooltip.pbg.Depth() - 1 end)
        tooltip:DisableHitTest(true)
        LayoutHelpers.FillParentFixedBorder(tooltip.extborder5, tooltip.pbg, -1)
			
            end

            local textBoxWidth
            if not width then
                textBoxWidth = tooltip.desc[1]:GetStringAdvance(desc) + 1
                textBoxWidth = math.min(textBoxWidth, ScaleNumber(250))
                if tooltip.title then
                    textBoxWidth = math.max(textBoxWidth, tooltip.title.TextAdvance())
                end
            else
                textBoxWidth = ScaleNumber(width - padding - padding)
            end
            tempTable = import("/lua/maui/text.lua").WrapText(desc, textBoxWidth,
            function(text)
                return tooltip.desc[1]:GetStringAdvance(text)
            end)

            for i=1, table.getn(tempTable) do
                if i == 1 then
                    tooltip.desc[i]:SetText(tempTable[i])
                else
                    local index = i
                    tooltip.desc[i] = UIUtil.CreateText(tooltip, tempTable[i], descFontSize, UIUtil.bodyFont)
                    tooltip.desc[i].Width:Set(tooltip.desc[1].Width)
                    LayoutHelpers.Below(tooltip.desc[index], tooltip.desc[index-1])
                end
                tooltip.desc[i]:SetColor('FFCCCCCC') -- #FFCCCCCC
            end
            -- removed tooltip.extbg Bitmap because it is redundant by tooltip Bitmap
        end
		
		

        if not width then
            if tooltip.title then
                width = tooltip.title.TextAdvance()
            else
                width = 0
            end
            for _, v in tooltip.desc do
                local w = v.TextAdvance()
                if w > width then width = w end
            end
            width = width + padding + padding -- adding left padding and right padding
        end

        if text then
            local titleWidth = tooltip.title.Width() + padding + padding
            tooltip.Width:Set(function() return math.max(titleWidth, width) end)
        else
            tooltip.Width:Set(function() return width end)
        end
        
        
        local descHeight = 0
        if tooltip.desc and tooltip.desc[1] then
           tooltip.descTotalHeight = (tooltip.desc[1].Height() * table.getn(tempTable))
           tooltip.descTotalHeight = tooltip.descTotalHeight + padding + padding
        end

        local textHeight = 0
        if text then
           textHeight = tooltip.title.Height() + textFillOffset + textFillOffset
        end

        if text == nil then
            tooltip.Height:Set(function() return tooltip.descTotalHeight end)
        elseif desc == nil then
            tooltip.Height:Set(function() return textHeight end)
        else
            tooltip.Height:Set(function() return textHeight + tooltip.descTotalHeight end)
        end


        return tooltip
    else
        WARN("Tooltip error! Text and description are both empty!  This should not happen.")
    end
end

function CreateMouseoverResearchDisplay(parent, ID, delay, extended, width, forced, padding, descFontSize, textFontSize, position)

    -- values used throughout the function
    local totalTime = 0
    local alpha = 0.0
    local text = ""
    local body = ""
    if not position then position = 'center' end
    
    -- remove previous instance
    if mouseoverDisplay then
        mouseoverDisplay:Destroy()
        mouseoverDisplay = false
    end

    -- determine if we want to show this tooltip (game options can prevent that)
    if not forced and not Prefs.GetOption('tooltips') then return end

    -- determine delay
    local createDelay = 0
    if delay and Prefs.GetOption('tooltip_delay') then
        createDelay = math.max(delay, Prefs.GetOption('tooltip_delay'))
    else
        createDelay = Prefs.GetOption('tooltip_delay') or 0
    end

    -- retrieve tooltip title / description
    if type(ID) == 'string' then
        if TooltipInfo['Tooltips'][ID] then
			cost = 0
            text = TooltipInfo['Tooltips'][ID]['title']
            body = TooltipInfo['Tooltips'][ID]['description']
            if TooltipInfo['Tooltips'][ID]['keyID'] and TooltipInfo['Tooltips'][ID]['keyID'] ~= "" then
                for i, v in Keymapping do
                    if v == TooltipInfo['Tooltips'][ID]['keyID'] then
                        local properkeyname = import("/lua/ui/dialogs/keybindings.lua").FormatKeyName(i)
                        text = LOCF("%s (%s)", text, properkeyname)
                        break
                    end
                end
            end
        else
            if extended then
                WARN("No tooltip in table for key: "..ID)
            end
            text = ID
            body = "No Description"
        end
    elseif type(ID) == 'table' then
        text = ID.text
        body = ID.body
    else
        WARN('UNRECOGNIZED TOOLTIP ENTRY - Not a string or table! ', repr(ID))
    end


	cost = 0
	prerequisite = 'None'
    if extended then 
        -- creating a tooltip with header text and body description
        mouseoverDisplay = CreateResearchToolTip(parent, cost, text, body, prerequisite, width, padding, descFontSize, textFontSize)
    else 
        -- creating a tooltip with just header text
        mouseoverDisplay = CreateToolTip(parent, text)
    end

    -- adjust position to show tooltip on left/right side of its parent and within main window
    if extended then
        local Frame = GetFrame(0)
        if parent.Top() - mouseoverDisplay.Height() < 0 then
            mouseoverDisplay.Top:Set(function() return parent.Bottom() + 10 end)
        else
            mouseoverDisplay.Bottom:Set(parent.Top)
        end
        if (parent.Left() + (parent.Width() / 2)) - (mouseoverDisplay.Width() / 2) < 0 then
            mouseoverDisplay.Left:Set(parent.Right)
        elseif (parent.Right() - (parent.Width() / 2)) + (mouseoverDisplay.Width() / 2) > Frame.Right() then
            mouseoverDisplay.Right:Set(parent.Left)
        elseif position == 'left' then
            mouseoverDisplay.Left:Set(function() return parent.Left() + 80 end)
        elseif position == 'right' then
            mouseoverDisplay.Left:Set(function() return parent.Right() - mouseoverDisplay.Width() - 10 end)
        else -- position == 'center'
            LayoutHelpers.AtHorizontalCenterIn(mouseoverDisplay, parent)
        end
    else
        local Frame = GetFrame(0)
        mouseoverDisplay.Bottom:Set(parent.Top)
        if (parent.Left() + (parent.Width() / 2)) - (mouseoverDisplay.Width() / 2) < 0 then
            mouseoverDisplay.Left:Set(4)
        elseif (parent.Right() - (parent.Width() / 2)) + (mouseoverDisplay.Width() / 2) > Frame.Right() then
            mouseoverDisplay.Right:Set(function() return Frame.Right() - 4 end)
        else
            LayoutHelpers.AtHorizontalCenterIn(mouseoverDisplay, parent)
        end
    end


    -- adding smooth popup animation to the tooltip 
    mouseoverDisplay:SetAlpha(alpha, true)
    mouseoverDisplay:SetNeedsFrameUpdate(true)
    mouseoverDisplay.OnFrame = function(self, deltaTime)
        if totalTime > createDelay then
            if parent then
                if alpha < 1 then
                    mouseoverDisplay:SetAlpha(alpha, true)
                    alpha = alpha + (deltaTime * 4)
                else
                    mouseoverDisplay:SetAlpha(1, true)
                    mouseoverDisplay:SetNeedsFrameUpdate(false)
                end
            else
                WARN("NO PARENT SPECIFIED FOR TOOLTIP")
            end
        end
        totalTime = totalTime + deltaTime
    end
end

function AddResearchButtonTooltip(control, tooltipID, delay, width)
    control.HandleEvent = function(self, event)
        if event.Type == 'MouseEnter' then
		position = 'left'
            CreateMouseoverResearchDisplay(self, tooltipID, delay, true, width, false, 0, 12, 14, position)
        elseif event.Type == 'MouseExit' then
            DestroyMouseoverDisplay()
        end
        return Button.HandleEvent(self, event)
    end
end

function AddResearchPictureTooltip(control, tooltipID, delay, width)
    control.HandleEvent = function(self, event)
        if event.Type == 'MouseEnter' then
		position = 'left'
            CreateMouseoverResearchDisplay(self, tooltipID, delay, true, width, false, 0, 12, 14, position)
        elseif event.Type == 'MouseExit' then
            DestroyMouseoverDisplay()
        end
    end
end
