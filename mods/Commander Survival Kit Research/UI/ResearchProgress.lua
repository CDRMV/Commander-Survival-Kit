

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

local StatusBar = import("/lua/maui/statusbar.lua").StatusBar
	
finished = false

function AddResearchProgressBar(parent, start, researchtime)
        if start then
		ResearchProgressBar = StatusBar(parent, 0, 1, false, false, nil, nil, true)
		    LayoutHelpers.AtCenterIn(ResearchProgressBar, parent, 0, 0)
            ResearchProgressBar:Show()
			Progress = 0
			ResearchMax = 1
			ProgressInterval = .01
			ForkThread(
			function()
				while Progress  <= ResearchMax do
				ResearchProgressBar:SetValue(Progress)
				LOG('Research Progress: ', Progress)
            if Progress > 1 then
				ResearchProgressBar:Hide()
				finished = true
				return finished
			elseif Progress > .75 then
                ResearchProgressBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_green.dds'))
				LayoutHelpers.AtCenterIn(ResearchProgressBar, parent, 0, 0)
            elseif Progress > .25 then
                ResearchProgressBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_yellow.dds'))
				LayoutHelpers.AtCenterIn(ResearchProgressBar, parent, 0, 0)
            else
                ResearchProgressBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_red.dds'))
				LayoutHelpers.AtCenterIn(ResearchProgressBar, parent, 0, 0)
            end

			WaitSeconds(1)
			Progress = Progress + ProgressInterval
				end
			end
			)
		end
end
