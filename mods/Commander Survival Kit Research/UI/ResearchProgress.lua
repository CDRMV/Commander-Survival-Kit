

local UIUtil = import("/lua/ui/uiutil.lua")
local Group = import("/lua/maui/group.lua").Group
local Bitmap = import("/lua/maui/bitmap.lua").Bitmap
local LayoutHelpers = import("/lua/maui/layouthelpers.lua")
local TooltipInfo = import("/lua/ui/help/tooltips.lua")
local Prefs = import("/lua/user/prefs.lua")
local Button = import("/lua/maui/button.lua").Button
local Edit = import("/lua/maui/edit.lua").Edit
local CreateWindow = import('/lua/maui/window.lua').Window
local Checkbox = import("/lua/maui/checkbox.lua").Checkbox
local Keymapping = import("/lua/keymap/defaultkeymap.lua").defaultKeyMap
local mouseoverDisplay = false
local createThread = false
local MathFloor = math.floor
local MathCeil = math.ceil
local pixelScaleFactor = import("/lua/user/prefs.lua").GetFromCurrentProfile("options").ui_scale or 1

local ResearchProgress = SessionGetScenarioInfo().Options.ResearchProgress

local StatusBar = import("/lua/maui/statusbar.lua").StatusBar
	
finished = false




	Border = {
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
		Left = 480, 
		Top = 8, 
		Bottom = 72, 
		Right = 615
	}

	
	dialog = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Construction',Position,Border) 

	dialog._closeBtn:Hide()

	for i, v in Position do 
		dialog[i]:Set(v)
	end
	
function AddResearchProgressInfoBar(parent, start, researchtime)
        if start then
			ResearchProgressBar = StatusBar(parent, 0, 1, false, false, nil, nil, true)
			ResearchProgressBarBG = Bitmap(parent)
            ResearchProgressBarBG:SetSolidColor('FF000202')
			LayoutHelpers.SetDimensions(ResearchProgressBarBG, 40, 6)
			LayoutHelpers.SetDimensions(ResearchProgressBar, 40, 6)
			LayoutHelpers.AtCenterIn(ResearchProgressBarBG, parent, 18, 0)
			LayoutHelpers.DepthOverParent(ResearchProgressBarBG, parent, 10)
			LayoutHelpers.AtCenterIn(ResearchProgressBar, ResearchProgressBarBG, 18, 0)
			LayoutHelpers.DepthOverParent(ResearchProgressBar, ResearchProgressBarBG, 10)
            ResearchProgressBar:Show()
			Progress = 0
			ResearchMax = 2
			ProgressInterval = .01
			ForkThread(
			function()
				while Progress  <= ResearchMax do
				ResearchProgressBar:SetValue(Progress)
				LOG('Research Progress: ', Progress)
            if Progress > 1.00 then
				ResearchProgressBar:Hide()
				finished = true
				break
			elseif Progress > .75 then
                ResearchProgressBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_green.dds'))
				LayoutHelpers.AtCenterIn(ResearchProgressBar, parent, 18, 0)
				LayoutHelpers.DepthOverParent(ResearchProgressBar, parent, 10)
            elseif Progress > .25 then
                ResearchProgressBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_yellow.dds'))
				LayoutHelpers.AtCenterIn(ResearchProgressBar, parent, 18, 0)
				LayoutHelpers.DepthOverParent(ResearchProgressBar, parent, 10)
            else
                ResearchProgressBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_red.dds'))
				LayoutHelpers.AtCenterIn(ResearchProgressBar, parent, 18, 0)
				LayoutHelpers.DepthOverParent(ResearchProgressBar, parent, 10)
            end

			WaitSeconds(1)
			Progress = Progress + ProgressInterval
				end
			end
			)
		elseif start == false then
			ResearchProgressBar:Hide()
			ResearchProgressBarBG:Hide()
			Progress = 0
			ResearchMax = 0
			ProgressInterval = 0
		end
end	
	
	
function AddResearchProgressInfo(pic, research)	
	ResearchProjects = {}
	
	Picture = Bitmap(dialog, pic)
	Picture.Width:Set(55)
	Picture.Height:Set(55)
	
	AddResearchProgressInfoBar(Picture, research, 0)
	LayoutHelpers.AtLeftTopIn(Picture, dialog, 0, -5)
	LayoutHelpers.DepthOverParent(Picture, dialog, 10)
end