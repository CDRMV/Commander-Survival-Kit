

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



function CreateResearchToolTip(parent, text, desc, width, padding, descFontSize, textFontSize)
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
        tooltip:SetSolidColor('FF000202') -- #FF000202 -- #E5B06AFF
        tooltip.Depth:Set(function() return parent.Depth() + 10000 end)

        if text then
            -- creating tooltip title
            tooltip.title = UIUtil.CreateText(tooltip, text, textFontSize, UIUtil.bodyFont)
            tooltip.title.Top:Set(tooltip.Top)
            tooltip.title.Top:Set(function() return tooltip.Top() + textFillOffset end)
            tooltip.title.Left:Set(function() return tooltip.Left() + padding end)
            -- creating background fill for tooltip title
            tooltip.bg = Bitmap(tooltip)
            
            tooltip.bg:SetSolidColor(UIUtil.tooltipTitleColor)
            tooltip.bg.Depth:Set(function() return tooltip.title.Depth() - 1 end)
            tooltip.bg.Top:Set(function() return tooltip.Top() end)
            tooltip.bg.Left:Set(function() return tooltip.Left() end)
            tooltip.bg.Right:Set(function() return tooltip.Right() end)
            tooltip.bg.Bottom:Set(function() return tooltip.title.Bottom() + textFillOffset end)
        end

        tooltip.desc = {}
        local tempTable = false

        if desc then
            tooltip.desc[1] = UIUtil.CreateText(tooltip, "", descFontSize, UIUtil.bodyFont)
            tooltip.desc[1].Width:Set(tooltip.Width)
            if text == nil then
                tooltip.desc[1].Top:Set(function() return tooltip.Top() + padding end)
                tooltip.desc[1].Left:Set(function() return tooltip.Left() + padding end)
            else
                tooltip.desc[1].Top:Set(function() return tooltip.bg.Bottom() + padding end)
                tooltip.desc[1].Left:Set(function() return tooltip.Left() + padding end)
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
        
        tooltip.extborder = Bitmap(tooltip)
        tooltip.extborder:SetSolidColor(UIUtil.tooltipBorderColor)
        tooltip.extborder.Depth:Set(function() return tooltip.Depth() - 1 end)
        tooltip:DisableHitTest(true)
        LayoutHelpers.FillParentFixedBorder(tooltip.extborder, tooltip, -1)
        
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

    if extended then 
        -- creating a tooltip with header text and body description
        mouseoverDisplay = CreateResearchToolTip(parent, text, body, width, padding, descFontSize, textFontSize)
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
            mouseoverDisplay.Left:Set(function() return parent.Left() + 10 end)
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
            CreateMouseoverResearchDisplay(self, tooltipID, delay, true, width)
        elseif event.Type == 'MouseExit' then
            DestroyMouseoverDisplay()
        end
        return Button.HandleEvent(self, event)
    end
end
