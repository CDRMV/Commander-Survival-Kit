
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local CreateText = import('/lua/maui/text.lua').Text
local Button = import('/lua/maui/button.lua').Button
local MenuCommon = import('/lua/ui/menus/menucommon.lua')
local Slider = import('/lua/maui/slider.lua').Slider
local IntegerSlider = import('/lua/maui/slider.lua').IntegerSlider
local Checkbox = import('/lua/maui/checkbox.lua').Checkbox
local Tooltip = import('/lua/ui/game/tooltip.lua')
local CreateWindow = import('/lua/maui/window.lua').Window
local factions = import('/lua/factions.lua').Factions
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()			


local StatusBar = import("/lua/maui/statusbar.lua").StatusBar
	
finished = false
local i = 0
local width = 0
		




local Infos = {}
	
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

	local Position2 = {
		Left = 480, 
		Top = 8, 
		Bottom = 72, 
		Right = 550
	}

	
	UI = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Construction',Position2,Border) 
	UI._closeBtn:Hide()
	for i, v in Position2 do 
		UI[i]:Set(v)
	end

function ChangeWindowSize(Window, newright)
	local Position2 = {
		Left = 480, 
		Top = 8, 
		Bottom = 72, 
		Right = 550 + newright
	}
	
	for i, v in Position2 do 
		UI[i]:Set(v)
	end
end	

function AddResearchProgressBar(parent, start, researchtime)
        if start then
			ResearchProgressBar = StatusBar(parent, 0, 1, false, false, nil, nil, true)
			ResearchProgressBarBG = Bitmap(parent)
            ResearchProgressBarBG:SetSolidColor('FF000202')
			LayoutHelpers.SetDimensions(ResearchProgressBarBG, 50, 10)
			LayoutHelpers.SetDimensions(ResearchProgressBar, 50, 10)
			LayoutHelpers.AtCenterIn(ResearchProgressBarBG, parent, 22, 0)
			LayoutHelpers.DepthOverParent(ResearchProgressBarBG, parent, 10)
			LayoutHelpers.AtCenterIn(ResearchProgressBar, parent, 22, 0)
			LayoutHelpers.DepthOverParent(ResearchProgressBar, parent, 30)
			Progress = 0
			ResearchMax = 2
			ProgressInterval = .01
			ForkThread(
			function()
				while Progress  <= ResearchMax do
				ResearchProgressBar:SetValue(Progress)
				LOG('Research Progress: ', Progress)
            if Progress > 1.00 then
				ChangeWindowSize(UI, -65)
				parent:Destroy()
				ResearchProgressBar:Destroy()
				ResearchProgressBarBG:Destroy()
				finished = true
				parent = nil
				break
			elseif Progress > .75 then
                ResearchProgressBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_green.dds'))
				LayoutHelpers.AtCenterIn(ResearchProgressBar, parent, 22, 0)
				LayoutHelpers.DepthOverParent(ResearchProgressBar, parent, 30)
            elseif Progress > .25 then
                ResearchProgressBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_yellow.dds'))
				LayoutHelpers.AtCenterIn(ResearchProgressBar, parent, 22, 0)
				LayoutHelpers.DepthOverParent(ResearchProgressBar, parent, 30)
            else
                ResearchProgressBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_red.dds'))
				LayoutHelpers.AtCenterIn(ResearchProgressBar, parent, 22, 0)
				LayoutHelpers.DepthOverParent(ResearchProgressBar, parent, 30)
            end

			WaitSeconds(researchtime)
			Progress = Progress + ProgressInterval
				end
			end
			)
		elseif start == false then
			ResearchProgressBar:Destroy()
			ResearchProgressBarBG:Destroy()
			Progress = 0
			ResearchMax = 0
			ProgressInterval = 0
			parent = nil
		end
end
	
function CreateResearchProgressInfo(Picture, ResearchProgressStart, ResearchTime)
		local InfoPicture = nil
        Infos = {}

		InfoPicture = Bitmap(UI, Picture)
		InfoPicture.Width:Set(60)
		InfoPicture.Height:Set(60)

		AddResearchProgressBar(InfoPicture, ResearchProgressStart, ResearchTime)
		ForkThread(
			function()
				while true do
					if finished == true then
						i = i - 1
						width =  width - 55
						ChangeWindowSize(UI, width)
						finished = false
					end
				WaitSeconds(1)	
				end
			end
		)

		
        Infos[i] = InfoPicture
		LayoutHelpers.AtLeftTopIn(Infos[i], UI, width, 0)
		LayoutHelpers.DepthOverParent(Infos[i], UI, 10)
        i = i + 1
		width =  width + 55
		ChangeWindowSize(UI, width)

		InfoPicture = nil
end	

local step = 0
local step2 = 0
ForkThread(
	function()
		repeat	
			local MathFloor = math.floor
			local hours = MathFloor(GetGameTimeSeconds() / 3600)
			local Seconds = GetGameTimeSeconds() - hours * 3600
			WaitSeconds(1)
			if Seconds >= 10 and Seconds <= 500 then 
				step = step + 1
				if step == 1 then
				CreateResearchProgressInfo('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT2_btn_up.dds', true, 1)
				CreateResearchProgressInfo('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT3_btn_up.dds', true, 5)
				CreateResearchProgressInfo('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TEx_btn_up.dds', true, 10)
				CreateResearchProgressInfo('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TEx_btn_up.dds', true, 15)
				else
				end
			end
			
			if Seconds >= 310 then 
				step2 = step2 + 1
				if step2 == 1 then
				CreateResearchProgressInfo('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT2_btn_up.dds', true, 1)
				CreateResearchProgressInfo('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT3_btn_up.dds', true, 5)
				CreateResearchProgressInfo('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TEx_btn_up.dds', true, 10)
				CreateResearchProgressInfo('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TEx_btn_up.dds', true, 15)
				else
				end
			end
		until(GetGameTimeSeconds() < 0)
	end
)
