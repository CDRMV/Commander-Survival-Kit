
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local Text = import('/lua/maui/text.lua').Text
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
	local ResearchPointsGenerated = 0		
---------
--Prices
---------

local t2 = 10
local t3 = 20
local texp = 30


---------







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
		Left = 630, 
		Top = 200, 
		Bottom = 1050, 
		Right = 1970
	}
	
	

function ResearchLabHandle(generated)
	ForkThread(function()
		ResearchPointsGenerated = generated + ResearchPointsGenerated
		LOG('ResearchPoints:', ResearchPointsGenerated)
	end)
end 


function VersionCheckforButtons(button, up, over, down, dis)
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 
	UIUtil.SetNewButtonTextures(button, up, over, down, dis)
else 	

end

end

		dialog2 = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Construction',Position2,Border) 																	
    	for i, v in Position2 do 
		dialog2[i]:Set(v)
		end
		dialog2._closeBtn:Hide()
		
	
		local T2BTN, T3BTN, ExpBTN
			T2BTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT2', nil, 11)
			T3BTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT3', nil, 11)
			ExpBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TEx', nil, 11)
			T2BTNdis = ('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT2_btn_dis.dds')
			T3BTNdis = ('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT3_btn_dis.dds')
			ExBTNdis = ('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TEx_btn_dis.dds')
			Tooltip.AddButtonTooltip(T2BTN, "<LOC AB_Research>Research Tech 2")
			Tooltip.AddButtonTooltip(T3BTN, "<LOC AB_Research>Research Tech 3")
			Tooltip.AddButtonTooltip(ExpBTN, "<LOC AB_Research>Research Experimental")
		mbgtxt = UIUtil.UIFile('/mods/Commander Survival Kit Research/textures/uef_background.dds')
		mbg = Bitmap(dialog2, mbgtxt)
		LayoutHelpers.FillParentFixedBorder(mbg, dialog2, 5)
		LayoutHelpers.DepthOverParent(mbg, dialog2, 0)
		T2BTN.OnClick = function(self, modifiers)
		if ResearchPointsGenerated >= t2 then
		ResearchPointsGenerated = ResearchPointsGenerated - t2
			import('/Mods/Commander Survival Kit Research/UI/Main.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
			import('/Mods/Commander Survival Kit Research/UI/ResearchUI.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
			LOG('Invested Points:', t2)
			T2BTN:Disable()
			VersionCheckforButtons(T2BTN, T2BTNdis, T2BTNdis, T2BTNdis, T2BTNdis)
		else
			LOG('Not enough Points!')
		end
		end
		T3BTN.OnClick = function(self, modifiers)
		if ResearchPointsGenerated >= t3 then
		ResearchPointsGenerated = ResearchPointsGenerated - t3
			import('/Mods/Commander Survival Kit Research/UI/Main.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
			import('/Mods/Commander Survival Kit Research/UI/ResearchUI.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
			LOG('Invested Points:', t3)
			T3BTN:Disable()
			VersionCheckforButtons(T3BTN, T3BTNdis, T3BTNdis, T3BTNdis, T3BTNdis)
		else
			LOG('Not enough Points!')
		end
		end
		ExpBTN.OnClick = function(self, modifiers)
		if ResearchPointsGenerated >= texp then
		ResearchPointsGenerated = ResearchPointsGenerated - texp
			import('/Mods/Commander Survival Kit Research/UI/Main.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
			import('/Mods/Commander Survival Kit Research/UI/ResearchUI.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
			LOG('Invested Points:', texp)
			ExpBTN:Disable()
			VersionCheckforButtons(ExpBTN, ExBTNdis, ExBTNdis, ExBTNdis, ExBTNdis)
		else
			LOG('Not enough Points!')
		end
		end
		
		tecline1tex = UIUtil.UIFile('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/Lines.dds')
		tecline1 = Bitmap(dialog2, tecline1tex)
		tecline1.Width:Set(124)
		tecline1.Height:Set(5)
		tecline2tex = UIUtil.UIFile('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/Lines.dds')
		tecline2 = Bitmap(dialog2, tecline2tex)
		tecline2.Width:Set(124)
		tecline2.Height:Set(5)
		LayoutHelpers.AtLeftTopIn(tecline1, dialog2, 93, 65)
		LayoutHelpers.DepthOverParent(tecline1, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline2, dialog2, 280, 65)
		LayoutHelpers.DepthOverParent(tecline2, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(T2BTN, dialog2, 20, 30)
		LayoutHelpers.AtLeftTopIn(T3BTN, dialog2, 210, 30)
		LayoutHelpers.AtLeftTopIn(ExpBTN, dialog2, 400, 30)
		LayoutHelpers.DepthOverParent(T2BTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(T3BTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(ExpBTN, dialog2, 10)
