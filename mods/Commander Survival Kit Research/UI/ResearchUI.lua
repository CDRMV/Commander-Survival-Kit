
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
local ResearchPointsGenerated = 0		

	
ttectree = import('/mods/Commander Survival Kit Research/ui/TTechnologyResearchTree.lua').dialog2	
ctectree = import('/mods/Commander Survival Kit Research/ui/CTechnologyResearchTree.lua').dialog2

ctectree:Hide()		
ttectree:Hide()


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
		Left = 600, 
		Top = 100, 
		Bottom = 1100, 
		Right = 2000
	}
	
	local Position2 = {
		Left = 630, 
		Top = 200, 
		Bottom = 1050, 
		Right = 1970
	}
	
	local Position3 = {
		Left = 600, 
		Top = 30, 
		Bottom = 100, 
		Right = 1000
	}


    
	dialog = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Construction',Position,Border) 
    LayoutHelpers.AtTopIn(dialog, GetFrame(0), 50)
    LayoutHelpers.AtHorizontalCenterIn(dialog, GetFrame(0))
    	for i, v in Position do 
		dialog[i]:Set(v)
	end
    
dialog._closeBtn.OnClick = function(control)
		dialog:Hide()
		ctectree:Hide()
end

		dialog2 = CreateWindow(dialog,nil,nil,false,false,true,true,'Construction',Position2,Border) 																	
    	for i, v in Position2 do 
		dialog2[i]:Set(v)
		end
		dialog2._closeBtn:Hide()
		
		
		dialog3 = CreateWindow(dialog,nil,nil,false,false,true,true,'Construction',Position2,Border) 																	
    	for i, v in Position3 do 
		dialog3[i]:Set(v)
		end
		dialog3._closeBtn:Hide()
		bgtxt = UIUtil.UIFile('/mods/Commander Survival Kit Research/textures/medium-cybran_btn/small-cybran_btn_up.dds')
		bg = Bitmap(dialog3, bgtxt)
		bg.Width:Set(120)
		bg.Height:Set(60)
		LayoutHelpers.FillParentFixedBorder(bg, dialog3, 5)
		LayoutHelpers.DepthOverParent(bg, dialog3, 10)
		
		label = UIUtil.CreateText(dialog3, 'Research', 22)
		label:SetColor('ffFFFFFF')
		LayoutHelpers.AtCenterIn(label, dialog3)
		LayoutHelpers.DepthOverParent(label, dialog3, 10)

	
		local LandBTN, AirBTN, NavalBTN, StrucBTN, TecBTN
		local buttonpress = 0
				if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LandBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-aeon_btn/medium-aeon', 'Land', 11)
			AirBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-aeon_btn/medium-aeon', 'Air', 11)
			NavalBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-aeon_btn/medium-aeon', 'Naval', 11)
			StrucBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-aeon_btn/medium-aeon', 'Structure', 11)
			TecBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-aeon_btn/medium-aeon', 'Technology', 11)
		mbgtxt = UIUtil.UIFile('/mods/Commander Survival Kit Research/textures/aeon_background.dds')
		mbg = Bitmap(dialog2, mbgtxt)
		LayoutHelpers.FillParentFixedBorder(mbg, dialog2, 5)
		LayoutHelpers.DepthOverParent(mbg, dialog2, 0)
        LandBTN.OnClick = function(self, modifiers)

		end
		AirBTN.OnClick = function(self, modifiers)

		end
		NavalBTN.OnClick = function(self, modifiers)

		end
		StrucBTN.OnClick = function(self, modifiers)

		end
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			LandBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-cybran_btn/medium-cybran', 'Land', 11)
			AirBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-cybran_btn/medium-cybran', 'Air', 11)
			NavalBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-cybran_btn/medium-cybran', 'Naval', 11)
			StrucBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-cybran_btn/medium-cybran', 'Structure', 11)
			TecBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-cybran_btn/medium-cybran', 'Technology', 11)
		LandBTN.OnClick = function(self, modifiers)

		end
		AirBTN.OnClick = function(self, modifiers)

		end
		NavalBTN.OnClick = function(self, modifiers)

		end
		StrucBTN.OnClick = function(self, modifiers)
		end
		TecBTN.OnClick = function(self, modifiers)
		LOG('buttonpress: ', buttonpress)
		buttonpress = buttonpress + 1
		if buttonpress == 1 then
		LayoutHelpers.DepthOverParent(ctectree, dialog2, 10)
	    ctectree:Show()
		ctectree._closeBtn:Hide()
		end 
		
		if buttonpress == 2 then
		ctectree:Hide()
		buttonpress = 0
		end 
		end
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			LandBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-uef_btn/medium-uef', 'Land', 11)
			AirBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-uef_btn/medium-uef', 'Air', 11)
			NavalBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-uef_btn/medium-uef', 'Naval', 11)
			StrucBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-uef_btn/medium-uef', 'Structure', 11)
			TecBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-uef_btn/medium-uef', 'Technology', 11)
		mbgtxt = UIUtil.UIFile('/mods/Commander Survival Kit Research/textures/uef_background.dds')
		mbg = Bitmap(dialog2, mbgtxt)
		LayoutHelpers.FillParentFixedBorder(mbg, dialog2, 5)
		LayoutHelpers.DepthOverParent(mbg, dialog2, 0)
		LandBTN.OnClick = function(self, modifiers)

		end
		AirBTN.OnClick = function(self, modifiers)

		end
		NavalBTN.OnClick = function(self, modifiers)

		end
		StrucBTN.OnClick = function(self, modifiers)

		end
		TecBTN.OnClick = function(self, modifiers)
		LOG('buttonpress: ', buttonpress)
		buttonpress = buttonpress + 1
		if buttonpress == 1 then
		LayoutHelpers.DepthOverParent(ttectree, dialog2, 10)
	    ttectree:Show()
		ttectree._closeBtn:Hide()
		end 
		
		if buttonpress == 2 then
		ttectree:Hide()
		buttonpress = 0
		end 
		end
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			LandBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-seraphim_btn/medium-seraphim', 'Land', 11)
			AirBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-seraphim_btn/medium-seraphim', 'Air', 11)
			NavalBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-seraphim_btn/medium-seraphim', 'Naval', 11)
			StrucBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-seraphim_btn/medium-seraphim', 'Structure', 11)
			TecBTN = UIUtil.CreateButtonStd(dialog, '/mods/Commander Survival Kit Research/textures/medium-seraphim_btn/medium-seraphim', 'Technology', 11)
					mbgtxt = UIUtil.UIFile('/mods/Commander Survival Kit Research/textures/sera_background.dds')
		mbg = Bitmap(dialog2, mbgtxt)
		LayoutHelpers.FillParentFixedBorder(mbg, dialog2, 5)
		LayoutHelpers.DepthOverParent(mbg, dialog2, 0)
		LandBTN.OnClick = function(self, modifiers)

		end
		AirBTN.OnClick = function(self, modifiers)

		end
		NavalBTN.OnClick = function(self, modifiers)

		end
		StrucBTN.OnClick = function(self, modifiers)

		end
		end
		LayoutHelpers.AtLeftTopIn(LandBTN, dialog, 20, 30)
		LayoutHelpers.AtLeftTopIn(AirBTN, dialog, 210, 30)
		LayoutHelpers.AtLeftTopIn(NavalBTN, dialog, 400, 30)
		LayoutHelpers.AtLeftTopIn(StrucBTN, dialog, 590, 30)
		LayoutHelpers.AtLeftTopIn(TecBTN, dialog, 780, 30)
		LayoutHelpers.DepthOverParent(LandBTN, dialog, 10)
		LayoutHelpers.DepthOverParent(AirBTN, dialog, 10)
		LayoutHelpers.DepthOverParent(NavalBTN, dialog, 10)
		LayoutHelpers.DepthOverParent(StrucBTN, dialog, 10)
		LayoutHelpers.DepthOverParent(TecBTN, dialog, 10)
		abilityText = UIUtil.CreateText(dialog, 'Collected Points: ', 22)
		LayoutHelpers.AtLeftTopIn(abilityText, dialog, 1100, 55)
		LayoutHelpers.DepthOverParent(abilityText, dialog, 10)
		abilityText:SetColor('ffFFFFFF')
		
		function ResearchPointInvestmentHandle(generated)
			ForkThread(function()
				ResearchPointsGenerated = generated
				LOG('NewPoints:', ResearchPointsGenerated)
				abilityText:SetText('Collected Points: ' .. LOC(ResearchPointsGenerated))
			end)
		end 
		
		function ResearchLabHandle(generated)
			ForkThread(function()
				ResearchPointsGenerated = generated + ResearchPointsGenerated
				LOG('ResearchPoints:', ResearchPointsGenerated)
				abilityText:SetText('Collected Points: ' .. LOC(ResearchPointsGenerated))
			end)
		end 
		
    end