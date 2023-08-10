
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
local ResearchTooltip = import('/mods/Commander Survival Kit Research/ui/Researchtooltip.lua')
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
local ResearchProgress = SessionGetScenarioInfo().Options.ResearchProgress

local StatusBar = import("/lua/maui/statusbar.lua").StatusBar
	
finished = false

function AddResearchProgressBar(parent, start, researchtime)
        if start then
			ResearchProgressBar = StatusBar(parent, 0, 1, false, false, nil, nil, true)
			ResearchProgressBarBG = Bitmap(parent)
            ResearchProgressBarBG:SetSolidColor('FF000202')
			LayoutHelpers.SetDimensions(ResearchProgressBarBG, 50, 10)
			LayoutHelpers.SetDimensions(ResearchProgressBar, 50, 10)
			LayoutHelpers.AtCenterIn(ResearchProgressBarBG, parent, 22, 0)
			LayoutHelpers.DepthOverParent(ResearchProgressBarBG, parent, 10)
			LayoutHelpers.AtCenterIn(ResearchProgressBar, ResearchProgressBarBG, 22, 0)
			LayoutHelpers.DepthOverParent(ResearchProgressBar, ResearchProgressBarBG, 10)
			Progress = 0
			ResearchMax = 2
			ProgressInterval = .01
			ForkThread(
			function()
				while Progress  <= ResearchMax do
				ResearchProgressBar:SetValue(Progress)
				LOG('Research Progress: ', Progress)
            if Progress > 1.00 then
				ResearchProgressBar:Destroy()
				ResearchProgressBarBG:Destroy()
				finished = true
				break
			elseif Progress > .75 then
                ResearchProgressBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_green.dds'))
				LayoutHelpers.AtCenterIn(ResearchProgressBar, parent, 22, 0)
				LayoutHelpers.DepthOverParent(ResearchProgressBar, parent, 10)
            elseif Progress > .25 then
                ResearchProgressBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_yellow.dds'))
				LayoutHelpers.AtCenterIn(ResearchProgressBar, parent, 22, 0)
				LayoutHelpers.DepthOverParent(ResearchProgressBar, parent, 10)
            else
                ResearchProgressBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_red.dds'))
				LayoutHelpers.AtCenterIn(ResearchProgressBar, parent, 22, 0)
				LayoutHelpers.DepthOverParent(ResearchProgressBar, parent, 10)
            end

			WaitSeconds(1)
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
		end
end


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
		Left = 0, 
		Top = 200, 
		Bottom = 1050, 
		Right = 1300
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
		LayoutHelpers.AtLeftIn(dialog2, GetFrame(0))		
		dialog2._closeBtn:Hide()
		
		local T2BTNpress = 0
		local T3BTNpress = 0
		local ExpBTNpress = 0
		local MassLVL1BTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/MassBoostLVL1', nil, 11)
		local EnergyLVL1BTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/EnergyBoostLVL1', nil, 11)
		local MassLVL2BTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/MassBoostLVL2', nil, 11)
		local EnergyLVL2BTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/EnergyBoostLVL2', nil, 11)
		local MassLVL3BTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/MassBoostLVL3', nil, 11)
		local EnergyLVL3BTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/EnergyBoostLVL3', nil, 11)
		
		local VertLVL1BTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/VeterancyLVL1', nil, 11)
		local VertLVL2BTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/VeterancyLVL2', nil, 11)
		local VertLVL3BTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/VeterancyLVL3', nil, 11)
		local VertLVL4BTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/VeterancyLVL4', nil, 11)
		local VertLVL5BTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/VeterancyLVL5', nil, 11)
		
		local T2BTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT2', nil, 11)
		local T3BTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT3', nil, 11)
		local ExpBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TEx', nil, 11)
		local T2EcoBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT2Eco', nil, 11)
		local T2PDBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT2PD', nil, 11)
		local T2NDBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT2ND', nil, 11)
		local T2AABTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT2AA', nil, 11)
		local T2ArtBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT2Art', nil, 11)
		local T2MBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT2M', nil, 11)
		local T2IntBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT2Int', nil, 11)
		local T2DefBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT2Def', nil, 11)
		local T3EcoBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT3Eco', nil, 11)
		local T3PDBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT3PD', nil, 11)
		local T3AABTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT3AA', nil, 11)
		local T3ArtBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT3Art', nil, 11)
		local T3SMBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT3SM', nil, 11)
		local T3IntBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT3Int', nil, 11)
		local T3DefBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT3Def', nil, 11)
		local TExpArtBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TExArt', nil, 11)
		local TExpSatCBTN = UIUtil.CreateButtonStd(dialog2, '/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TExSatC', nil, 11)
		
		T2BTN:Enable()
		T3BTN:Disable()
		ExpBTN:Disable()
		
			T2BTNdis = ('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT2_btn_dis.dds')
			T3BTNdis = ('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TT3_btn_dis.dds')
			ExBTNdis = ('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/TEx_btn_dis.dds')
			ResearchTooltip.AddResearchButtonTooltip(T2BTN, "Research Tech 2")
			ResearchTooltip.AddResearchButtonTooltip(T3BTN, "Research Tech 3")
			ResearchTooltip.AddResearchButtonTooltip(ExpBTN, "Research Experimental")
			Tooltip.AddButtonTooltip(MassLVL1BTN, "<LOC AB_Research>Research Mass Generation Boost 1")
			Tooltip.AddButtonTooltip(EnergyLVL1BTN, "<LOC AB_Research>Research Energy Generation Boost 1")
			Tooltip.AddButtonTooltip(MassLVL2BTN, "<LOC AB_Research>Research Mass Generation Boost 2")
			Tooltip.AddButtonTooltip(EnergyLVL2BTN, "<LOC AB_Research>Research Energy Generation Boost 2")
			Tooltip.AddButtonTooltip(VertLVL1BTN, "<LOC AB_Research>Research Veterancy Level 1")
			Tooltip.AddButtonTooltip(VertLVL2BTN, "<LOC AB_Research>Research Veterancy Level 2")
			Tooltip.AddButtonTooltip(VertLVL3BTN, "<LOC AB_Research>Research Veterancy Level 3")
			Tooltip.AddButtonTooltip(VertLVL4BTN, "<LOC AB_Research>Research Veterancy Level 4")
			Tooltip.AddButtonTooltip(VertLVL5BTN, "<LOC AB_Research>Research Veterancy Level 5")
			Tooltip.AddButtonTooltip(MassLVL3BTN, "<LOC AB_Research>Research Mass Generation Boost 3")
			Tooltip.AddButtonTooltip(EnergyLVL3BTN, "<LOC AB_Research>Research Energy Generation Boost 3")
			Tooltip.AddButtonTooltip(T2EcoBTN, "<LOC AB_Research>Research Tech 2 Economy Structures")
			Tooltip.AddButtonTooltip(T2PDBTN, "<LOC AB_Research>Research Tech 2 Point Defenses")
			Tooltip.AddButtonTooltip(T2NDBTN, "<LOC AB_Research>Research Tech 2 Naval Defenses")
			Tooltip.AddButtonTooltip(T2AABTN, "<LOC AB_Research>Research Tech 2 Anti Air Defenses")
			Tooltip.AddButtonTooltip(T2ArtBTN, "<LOC AB_Research>Research Tech 2 Artillery Structures")
			Tooltip.AddButtonTooltip(T2MBTN, "<LOC AB_Research>Research Tech 2 Missile Silos")
			Tooltip.AddButtonTooltip(T2IntBTN, "<LOC AB_Research>Research Tech 2 Intel Structures")
			Tooltip.AddButtonTooltip(T2DefBTN, "<LOC AB_Research>Research Tech 2 General Defense Structures")
			Tooltip.AddButtonTooltip(T3EcoBTN, "<LOC AB_Research>Research Tech 3 Economy Structures")
			Tooltip.AddButtonTooltip(T3PDBTN, "<LOC AB_Research>Research Tech 3 Point Defenses")
			Tooltip.AddButtonTooltip(T3AABTN, "<LOC AB_Research>Research Tech 3 Anti Air Defenses")
			Tooltip.AddButtonTooltip(T3ArtBTN, "<LOC AB_Research>Research Tech 3 Artillery Structures")
			Tooltip.AddButtonTooltip(T3SMBTN, "<LOC AB_Research>Research Tech 3 Missile Silos")
			Tooltip.AddButtonTooltip(T3IntBTN, "<LOC AB_Research>Research Tech 3 Intel Structures")
			Tooltip.AddButtonTooltip(T3DefBTN, "<LOC AB_Research>Research Tech 3 General Defense Structures")
			Tooltip.AddButtonTooltip(TExpArtBTN, "<LOC AB_Research>Research Experimental Artillery")
			Tooltip.AddButtonTooltip(TExpSatCBTN, "<LOC AB_Research>Research Experimental Satellite Center")
		mbgtxt = UIUtil.UIFile('/mods/Commander Survival Kit Research/textures/uef_background.dds')
		mbg = Bitmap(dialog2, mbgtxt)
		LayoutHelpers.FillParentFixedBorder(mbg, dialog2, 5)
		LayoutHelpers.DepthOverParent(mbg, dialog2, 0)
		
		
		if ResearchProgress == 1 then
		T2BTN.OnClick = function(self, modifiers)
		T2BTNpress = T2BTNpress + 1
		LOG('Buttonpress: ', T2BTNpress)
		if T2BTNpress == 1 then
			if ResearchPointsGenerated >= t2 then
				ResearchPointsGenerated = ResearchPointsGenerated - t2
				import('/Mods/Commander Survival Kit Research/UI/Main.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
				import('/Mods/Commander Survival Kit Research/UI/ResearchUI.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
				LOG('Invested Points:', t2)
				AddResearchProgressBar(T2BTN, true, 60)
				ForkThread(
					function()
						while true do
							LOG('Research Finished: ', finished)	
							if finished == true then
								T2BTN:Disable()
								T3BTN:Enable()
								--VersionCheckforButtons(T2BTN, T2BTNdis, T2BTNdis, T2BTNdis, T2BTNdis)
								SimCallback({Func = 'DoUnlockTech2'})
								AddResearchProgressBar(T2BTN, false, 0)
								finished = false
								break
							else
			
							end
						WaitSeconds(1)
						end
					end
				)
			else
				LOG('Not enough Points!')
				T2BTNpress = 0
			end
		elseif T2BTNpress == 2 then	
			ResearchPointsGenerated = ResearchPointsGenerated + t2
			import('/Mods/Commander Survival Kit Research/UI/Main.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
			import('/Mods/Commander Survival Kit Research/UI/ResearchUI.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
			T2BTNpress = 0
			AddResearchProgressBar(T2BTN, false, 0)
		end
		end
		
		T3BTN.OnClick = function(self, modifiers)
		T3BTNpress = T3BTNpress + 1
		LOG('Buttonpress: ', T3BTNpress)
		if T3BTNpress == 1 then
			if ResearchPointsGenerated >= t3 then
				ResearchPointsGenerated = ResearchPointsGenerated - t3
				import('/Mods/Commander Survival Kit Research/UI/Main.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
				import('/Mods/Commander Survival Kit Research/UI/ResearchUI.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
				LOG('Invested Points:', t3)
				AddResearchProgressBar(T3BTN, true, 60)
				ForkThread(
					function()
						while true do
							LOG('Research Finished: ', finished)	
							if finished == true then
								T3BTN:Disable()
								ExpBTN:Enable()
								--VersionCheckforButtons(T3BTN, T3BTNdis, T3BTNdis, T3BTNdis, T3BTNdis)
								SimCallback({Func = 'DoUnlockTech3'})
								AddResearchProgressBar(T3BTN, false, 0)
								finished = false
								break
							else
			
							end
						WaitSeconds(1)
						end
					end
				)
			else
				LOG('Not enough Points!')
				T3BTNpress = 0
			end
		elseif T3BTNpress == 2 then	
			ResearchPointsGenerated = ResearchPointsGenerated + t3
			import('/Mods/Commander Survival Kit Research/UI/Main.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
			import('/Mods/Commander Survival Kit Research/UI/ResearchUI.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
			T3BTNpress = 0
			AddResearchProgressBar(T3BTN, false, 0)
		end
		end
		
		ExpBTN.OnClick = function(self, modifiers)
		ExpBTNpress = ExpBTNpress + 1
		LOG('Buttonpress: ', ExpBTNpress)
		if ExpBTNpress == 1 then
			if ResearchPointsGenerated >= texp then
				ResearchPointsGenerated = ResearchPointsGenerated - texp
				import('/Mods/Commander Survival Kit Research/UI/Main.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
				import('/Mods/Commander Survival Kit Research/UI/ResearchUI.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
				LOG('Invested Points:', texp)
				AddResearchProgressBar(ExpBTN, true, 60)
				ForkThread(
					function()
						while true do
							LOG('Research Finished: ', finished)	
							if finished == true then
								ExpBTN:Disable()
								--VersionCheckforButtons(ExpBTN, ExpBTNdis, ExpBTNdis, ExpBTNdis, ExpBTNdis)
								SimCallback({Func = 'DoUnlockExperimental'})
								AddResearchProgressBar(ExpBTN, false, 0)
								finished = false
								break
							else
			
							end
						WaitSeconds(1)
						end
					end
				)
			else
				LOG('Not enough Points!')
				ExpBTNpress = 0
			end
		elseif ExpBTNpress == 2 then	
			ResearchPointsGenerated = ResearchPointsGenerated + t3
			import('/Mods/Commander Survival Kit Research/UI/Main.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
			import('/Mods/Commander Survival Kit Research/UI/ResearchUI.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
			ExpBTNpress = 0
			AddResearchProgressBar(ExpBTN, false, 0)
		end
		end
		
		elseif ResearchProgress == 2 then
			T2BTN.OnClick = function(self, modifiers)
				if ResearchPointsGenerated >= t2 then
					ResearchPointsGenerated = ResearchPointsGenerated - t2
					import('/Mods/Commander Survival Kit Research/UI/Main.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
					import('/Mods/Commander Survival Kit Research/UI/ResearchUI.lua').ResearchPointInvestmentHandle(ResearchPointsGenerated)
					LOG('Invested Points:', t2)
					T2BTN:Disable()
					VersionCheckforButtons(T2BTN, T2BTNdis, T2BTNdis, T2BTNdis, T2BTNdis)
					SimCallback({Func = 'DoUnlockTech2'})
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
					SimCallback({Func = 'DoUnlockTech3'})
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
					SimCallback({Func = 'DoUnlockExperimental'})
				else
					LOG('Not enough Points!')
				end
			end
		end
		


		
		tecline1tex = UIUtil.UIFile('/mods/Commander Survival Kit Research/textures/Research Buttons/UEF/Lines.dds')
		tecline1 = Bitmap(dialog2, tecline1tex)
		tecline1.Width:Set(124)
		tecline1.Height:Set(5)
		tecline2 = Bitmap(dialog2, tecline1tex)
		tecline2.Width:Set(124)
		tecline2.Height:Set(5)
		tecline3 = Bitmap(dialog2, tecline1tex)
		tecline3.Width:Set(5)
		tecline3.Height:Set(690)
		tecline4 = Bitmap(dialog2, tecline1tex)
		tecline4.Width:Set(35)
		tecline4.Height:Set(5)
		tecline5 = Bitmap(dialog2, tecline1tex)
		tecline5.Width:Set(35)
		tecline5.Height:Set(5)
		tecline6 = Bitmap(dialog2, tecline1tex)
		tecline6.Width:Set(35)
		tecline6.Height:Set(5)
		tecline7 = Bitmap(dialog2, tecline1tex)
		tecline7.Width:Set(35)
		tecline7.Height:Set(5)
		tecline8 = Bitmap(dialog2, tecline1tex)
		tecline8.Width:Set(35)
		tecline8.Height:Set(5)
		tecline9 = Bitmap(dialog2, tecline1tex)
		tecline9.Width:Set(35)
		tecline9.Height:Set(5)
		tecline10 = Bitmap(dialog2, tecline1tex)
		tecline10.Width:Set(35)
		tecline10.Height:Set(5)
		tecline11 = Bitmap(dialog2, tecline1tex)
		tecline11.Width:Set(5)
		tecline11.Height:Set(690)
		tecline12 = Bitmap(dialog2, tecline1tex)
		tecline12.Width:Set(35)
		tecline12.Height:Set(5)
		tecline13 = Bitmap(dialog2, tecline1tex)
		tecline13.Width:Set(35)
		tecline13.Height:Set(5)
		tecline14 = Bitmap(dialog2, tecline1tex)
		tecline14.Width:Set(35)
		tecline14.Height:Set(5)
		tecline15 = Bitmap(dialog2, tecline1tex)
		tecline15.Width:Set(35)
		tecline15.Height:Set(5)
		tecline16 = Bitmap(dialog2, tecline1tex)
		tecline16.Width:Set(35)
		tecline16.Height:Set(5)
		tecline17 = Bitmap(dialog2, tecline1tex)
		tecline17.Width:Set(35)
		tecline17.Height:Set(5)
		tecline18 = Bitmap(dialog2, tecline1tex)
		tecline18.Width:Set(35)
		tecline18.Height:Set(5)
		tecline19 = Bitmap(dialog2, tecline1tex)
		tecline19.Width:Set(5)
		tecline19.Height:Set(190)
		tecline20 = Bitmap(dialog2, tecline1tex)
		tecline20.Width:Set(35)
		tecline20.Height:Set(5)
		tecline21 = Bitmap(dialog2, tecline1tex)
		tecline21.Width:Set(35)
		tecline21.Height:Set(5)
		tecline22 = Bitmap(dialog2, tecline1tex)
		tecline22.Width:Set(37)
		tecline22.Height:Set(5)
		tecline23 = Bitmap(dialog2, tecline1tex)
		tecline23.Width:Set(37)
		tecline23.Height:Set(5)
		tecline24 = Bitmap(dialog2, tecline1tex)
		tecline24.Width:Set(37)
		tecline24.Height:Set(5)
		tecline25 = Bitmap(dialog2, tecline1tex)
		tecline25.Width:Set(37)
		tecline25.Height:Set(5)
		tecline27 = Bitmap(dialog2, tecline1tex)
		tecline27.Width:Set(37)
		tecline27.Height:Set(5)
		tecline28 = Bitmap(dialog2, tecline1tex)
		tecline28.Width:Set(37)
		tecline28.Height:Set(5)
		tecline29 = Bitmap(dialog2, tecline1tex)
		tecline29.Width:Set(37)
		tecline29.Height:Set(5)
		tecline30 = Bitmap(dialog2, tecline1tex)
		tecline30.Width:Set(37)
		tecline30.Height:Set(5)
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
		
		
		LayoutHelpers.AtLeftTopIn(tecline22, dialog2, 970, 65)
		LayoutHelpers.DepthOverParent(tecline22, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline23, dialog2, 1070, 65)
		LayoutHelpers.DepthOverParent(tecline23, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline24, dialog2, 970, 135)
		LayoutHelpers.DepthOverParent(tecline24, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline25, dialog2, 1070, 135)
		LayoutHelpers.DepthOverParent(tecline25, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(EnergyLVL1BTN, dialog2, 900, 30)
		LayoutHelpers.AtLeftTopIn(MassLVL1BTN, dialog2, 900, 100)
		LayoutHelpers.DepthOverParent(MassLVL1BTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(EnergyLVL1BTN, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(EnergyLVL2BTN, dialog2, 1000, 30)
		LayoutHelpers.AtLeftTopIn(MassLVL2BTN, dialog2, 1000, 100)
		LayoutHelpers.DepthOverParent(MassLVL2BTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(EnergyLVL2BTN, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(EnergyLVL3BTN, dialog2, 1100, 30)
		LayoutHelpers.AtLeftTopIn(MassLVL3BTN, dialog2, 1100, 100)
		LayoutHelpers.DepthOverParent(MassLVL3BTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(EnergyLVL3BTN, dialog2, 10)
		
		LayoutHelpers.AtLeftTopIn(tecline27, dialog2, 770, 785)
		LayoutHelpers.DepthOverParent(tecline27, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline28, dialog2, 870, 785)
		LayoutHelpers.DepthOverParent(tecline28, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline29, dialog2, 970, 785)
		LayoutHelpers.DepthOverParent(tecline29, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline30, dialog2, 1070, 785)
		LayoutHelpers.DepthOverParent(tecline30, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(VertLVL1BTN, dialog2, 700, 750)
		LayoutHelpers.AtLeftTopIn(VertLVL2BTN, dialog2, 800, 750)
		LayoutHelpers.AtLeftTopIn(VertLVL3BTN, dialog2, 900, 750)
		LayoutHelpers.AtLeftTopIn(VertLVL4BTN, dialog2, 1000, 750)
		LayoutHelpers.AtLeftTopIn(VertLVL5BTN, dialog2, 1100, 750)
		LayoutHelpers.DepthOverParent(VertLVL1BTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(VertLVL2BTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(VertLVL3BTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(VertLVL4BTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(VertLVL5BTN, dialog2, 10)
		
		LayoutHelpers.AtLeftTopIn(tecline3, dialog2, 56, 100)
		LayoutHelpers.DepthOverParent(tecline3, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline4, dialog2, 60, 175)
		LayoutHelpers.DepthOverParent(tecline4, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline5, dialog2, 60, 285)
		LayoutHelpers.DepthOverParent(tecline5, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline6, dialog2, 60, 385)
		LayoutHelpers.DepthOverParent(tecline6, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline7, dialog2, 60, 485)
		LayoutHelpers.DepthOverParent(tecline7, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline8, dialog2, 60, 585)
		LayoutHelpers.DepthOverParent(tecline8, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline9, dialog2, 60, 685)
		LayoutHelpers.DepthOverParent(tecline9, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline10, dialog2, 60, 785)
		LayoutHelpers.DepthOverParent(tecline10, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline11, dialog2, 246, 100)
		LayoutHelpers.DepthOverParent(tecline11, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline12, dialog2, 250, 175)
		LayoutHelpers.DepthOverParent(tecline12, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline13, dialog2, 250, 285)
		LayoutHelpers.DepthOverParent(tecline13, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline14, dialog2, 250, 385)
		LayoutHelpers.DepthOverParent(tecline14, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline15, dialog2, 250, 485)
		LayoutHelpers.DepthOverParent(tecline15, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline16, dialog2, 250, 585)
		LayoutHelpers.DepthOverParent(tecline16, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline17, dialog2, 250, 685)
		LayoutHelpers.DepthOverParent(tecline17, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline18, dialog2, 250, 785)
		LayoutHelpers.DepthOverParent(tecline18, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline19, dialog2, 436, 100)
		LayoutHelpers.DepthOverParent(tecline19, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline20, dialog2, 436, 175)
		LayoutHelpers.DepthOverParent(tecline20, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(tecline21, dialog2, 436, 285)
		LayoutHelpers.DepthOverParent(tecline21, dialog2, 10)
		LayoutHelpers.AtLeftTopIn(T2EcoBTN, dialog2, 90, 140)
		LayoutHelpers.AtLeftTopIn(T2PDBTN, dialog2, 90, 250)
		LayoutHelpers.AtLeftTopIn(T2NDBTN, dialog2, 150, 250)
		LayoutHelpers.AtLeftTopIn(T2AABTN, dialog2, 90, 350)
		LayoutHelpers.AtLeftTopIn(T2ArtBTN, dialog2, 90, 450)
		LayoutHelpers.AtLeftTopIn(T2MBTN, dialog2, 90, 550)
		LayoutHelpers.AtLeftTopIn(T2IntBTN, dialog2, 90, 650)
		LayoutHelpers.AtLeftTopIn(T2DefBTN, dialog2, 90, 750)
		LayoutHelpers.AtLeftTopIn(T3EcoBTN, dialog2, 280, 140)
		LayoutHelpers.AtLeftTopIn(T3PDBTN, dialog2, 280, 250)
		LayoutHelpers.AtLeftTopIn(T3AABTN, dialog2, 280, 350)
		LayoutHelpers.AtLeftTopIn(T3ArtBTN, dialog2, 280, 450)
		LayoutHelpers.AtLeftTopIn(T3SMBTN, dialog2, 280, 550)
		LayoutHelpers.AtLeftTopIn(T3IntBTN, dialog2, 280, 650)
		LayoutHelpers.AtLeftTopIn(T3DefBTN, dialog2, 280, 750)
		LayoutHelpers.AtLeftTopIn(TExpArtBTN, dialog2, 470, 140)
		LayoutHelpers.AtLeftTopIn(TExpSatCBTN, dialog2, 470, 250)
		LayoutHelpers.DepthOverParent(T2EcoBTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(T2PDBTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(T2NDBTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(T2AABTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(T2ArtBTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(T2MBTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(T2IntBTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(T2DefBTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(T3EcoBTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(T3PDBTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(T3AABTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(T3ArtBTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(T3SMBTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(T3IntBTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(T3DefBTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(TExpArtBTN, dialog2, 10)
		LayoutHelpers.DepthOverParent(TExpSatCBTN, dialog2, 10)
