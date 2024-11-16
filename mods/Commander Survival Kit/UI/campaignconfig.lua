----directory----
local path = '/mods/Commander Survival Kit/UI/'
local moviepath = '/mods/Commander Survival Kit/movies/'
local texpath = '/mods/Commander Survival Kit/textures/medium-uef_btn/'
----significant operators imported from external sources----
local CreateText = import('/lua/maui/text.lua').Text 
local CreateWindow = import('/lua/maui/window.lua').Window
local UIUtil = import('/lua/ui/uiutil.lua')
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local Group = import("/lua/maui/group.lua").Group
local LayoutHelpers = import("/lua/maui/layouthelpers.lua")
local factions = import('/lua/factions.lua').Factions
local helpcentermovie = import(path .. 'HelpcenterMovie.lua').UI
local helpcentermovieoptions = import(path .. 'HelpcenterMovie.lua').OUI
local movie = import(path .. 'HelpcenterMovie.lua').backMovie
local Movie = import('/lua/maui/movie.lua').Movie
local Tooltip = import("/lua/ui/game/tooltip.lua")
local Gametype = SessionGetScenarioInfo().type
local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	
local Bitmap = import("/lua/maui/bitmap.lua").Bitmap
local Combo = import("/lua/ui/controls/combo.lua").Combo
local Button = import("/lua/maui/button.lua").Button
local Scrollbar = import("/lua/maui/scrollbar.lua").Scrollbar
local Border = {
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


----parameters----
CampaignOptionWindow = CreateWindow(GetFrame(0),'Campaign Option Manager',nil,false,false,true,true,'Construction',nil,Border) 
local defPosition = {	
	Left = 350, 
	Top = 400, 
	Bottom = 900,  
	Right = 1450
}

local Background = Bitmap(CampaignOptionWindow, texpath .. 'small-uef_btn_dis.dds')
LayoutHelpers.FillParentFixedBorder(Background,CampaignOptionWindow, 5)

for i, v in defPosition do 
CampaignOptionWindow[i]:Set(v)
end

CampaignOptionWindow._closeBtn.OnClick = function(control)

GetCursor():Hide()
CampaignOptionWindow:Hide()
UIUtil.MakeInputModal(GetFrame(0))
SessionResume()

end


local ComboTitle1 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[1].label
local ComboTitle2 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[2].label
local ComboTitle3 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[3].label
local ComboTitle4 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[4].label
local ComboTitle5 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[5].label
local ComboTitle6 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[6].label
local ComboTitle7 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[7].label
local ComboTitle8 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[8].label
local ComboTitle9 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[9].label
local ComboTitle10 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[10].label
local ComboTitle11 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[11].label
local ComboTitle12 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[12].label
local ComboTitle13 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[13].label
local ComboTitle14 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[14].label
local ComboTitle15 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[15].label
local ComboTitle16 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[16].label
local ComboTitle17 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[17].label
local ComboTitle18 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[18].label
local ComboTitle19 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[19].label

local ComboValues1 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[1].values
local ComboValues2 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[2].values
local ComboValues3 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[3].values
local ComboValues4 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[4].values
local ComboValues5 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[5].values
local ComboValues6 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[6].values
local ComboValues7 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[7].values
local ComboValues8 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[8].values
local ComboValues9 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[9].values
local ComboValues10 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[10].values
local ComboValues11 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[11].values
local ComboValues12 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[12].values
local ComboValues13 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[13].values
local ComboValues14 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[14].values
local ComboValues15 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[15].values
local ComboValues16 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[16].values
local ComboValues17 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[17].values
local ComboValues18 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[18].values
local ComboValues19 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[19].values

-- General
    gameList = Group(CampaignOptionWindow)
    LayoutHelpers.AtCenterIn(gameList, CampaignOptionWindow, -160, -275)
    gameList.Width:Set(100)
    LayoutHelpers.SetHeight(gameList, 400)
    gameList.top = 0

-- Fire Support Manager
	
	gameList2 = Group(CampaignOptionWindow)
    LayoutHelpers.AtCenterIn(gameList2, CampaignOptionWindow, 50, 105)
    gameList2.Width:Set(100)
    LayoutHelpers.SetHeight(gameList2, 400)
    gameList2.top = 0

-- Reinforcements Manger

	gameList3 = Group(CampaignOptionWindow)
    LayoutHelpers.AtCenterIn(gameList3, CampaignOptionWindow, -10, 495)
    gameList3.Width:Set(100)
    LayoutHelpers.SetHeight(gameList3, 400)
    gameList3.top = 0
	
	
Title1 = CreateText(gameList)	
Title1:SetFont('Arial',14) 
Title1:SetColor('FFbadbdb')
Title1:SetText('GENERAL:')
Title1.Depth:Set(30)
LayoutHelpers.AtCenterIn(Title1, gameList, 20, -230)

Title2 = CreateText(gameList)	
Title2:SetFont('Arial',14) 
Title2:SetColor('FFbadbdb')
Title2:SetText('FIRE SUPPORT MANAGER:')
Title2.Depth:Set(30)
LayoutHelpers.AtCenterIn(Title2, gameList2, -180, -228)

Title3 = CreateText(gameList)	
Title3:SetFont('Arial',14) 
Title3:SetColor('FFbadbdb')
Title3:SetText('REINFORCEMENTS MANAGER:')
Title3.Depth:Set(30)
LayoutHelpers.AtCenterIn(Title3, gameList3, -120, -225)
	

TestCombo = Combo(gameList2, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo:AddItems({ComboValues1[1].text, ComboValues1[2].text})
LayoutHelpers.SetWidth(TestCombo, 160)
LayoutHelpers.SetHeight(TestCombo, 20)
LayoutHelpers.AtCenterIn(TestCombo, gameList2, -150, -40)
LayoutHelpers.DepthOverParent(TestCombo, gameList2, 10)

Text = CreateText(gameList2)	
Text:SetFont('Arial',11) 
Text:SetColor('FFbadbdb')
Text:SetText(ComboTitle1 .. ':')
Text.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text, gameList2, -150, -250)

TestCombo2 = Combo(gameList3, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo2:AddItems({ComboValues2[1].text, ComboValues2[2].text})
LayoutHelpers.SetWidth(TestCombo2, 160)
LayoutHelpers.SetHeight(TestCombo2, 20)
LayoutHelpers.AtCenterIn(TestCombo2, gameList3, -90, -40)
LayoutHelpers.DepthOverParent(TestCombo2, gameList3, 10)

Text2 = CreateText(gameList3)	
Text2:SetFont('Arial',11) 
Text2:SetColor('FFbadbdb')
Text2:SetText(ComboTitle2 .. ':')
Text2.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text2, gameList3, -90, -270)

TestCombo3 = Combo(gameList3, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo3:AddItems({ComboValues3[1].text, ComboValues3[2].text})
LayoutHelpers.SetWidth(TestCombo3, 160)
LayoutHelpers.SetHeight(TestCombo3, 20)
LayoutHelpers.AtCenterIn(TestCombo3, gameList3, -60, -40)
LayoutHelpers.DepthOverParent(TestCombo3, gameList3, 10)

Text3 = CreateText(gameList3)	
Text3:SetFont('Arial',11) 
Text3:SetColor('FFbadbdb')
Text3:SetText(ComboTitle3 .. ':')
Text3.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text3, gameList3, -60, -275)

TestCombo4 = Combo(gameList3, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo4:AddItems({ComboValues4[1].text, ComboValues4[2].text})
LayoutHelpers.SetWidth(TestCombo4, 160)
LayoutHelpers.SetHeight(TestCombo4, 20)
LayoutHelpers.AtCenterIn(TestCombo4, gameList3, -30, -40)
LayoutHelpers.DepthOverParent(TestCombo4, gameList3, 10)

Text4 = CreateText(gameList3)	
Text4:SetFont('Arial',11) 
Text4:SetColor('FFbadbdb')
Text4:SetText(ComboTitle4 .. ':')
Text4.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text4, gameList3, -30, -268)

TestCombo5 = Combo(gameList2, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo5:AddItems({ComboValues5[1].text, ComboValues5[2].text})
LayoutHelpers.SetWidth(TestCombo5, 160)
LayoutHelpers.SetHeight(TestCombo5, 20)
LayoutHelpers.AtCenterIn(TestCombo5, gameList2, -120, -40)
LayoutHelpers.DepthOverParent(TestCombo5, gameList2, 10)

Text5 = CreateText(gameList2)	
Text5:SetFont('Arial',11) 
Text5:SetColor('FFbadbdb')
Text5:SetText(ComboTitle5 .. ':')
Text5.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text5, gameList2, -120, -288)


TestCombo6 = Combo(gameList2, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo6:AddItems({ComboValues6[1].text, ComboValues6[2].text})
LayoutHelpers.SetWidth(TestCombo6, 160)
LayoutHelpers.SetHeight(TestCombo6, 20)
LayoutHelpers.AtCenterIn(TestCombo6, gameList2, -90, -40)
LayoutHelpers.DepthOverParent(TestCombo6, gameList2, 10)

Text6 = CreateText(gameList2)	
Text6:SetFont('Arial',11) 
Text6:SetColor('FFbadbdb')
Text6:SetText(ComboTitle6 .. ':')
Text6.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text6, gameList2, -90, -268)

TestCombo7 = Combo(gameList, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo7:AddItems({ComboValues7[2].text, ComboValues7[1].text})
LayoutHelpers.SetWidth(TestCombo7, 160)
LayoutHelpers.SetHeight(TestCombo7, 20)
LayoutHelpers.AtCenterIn(TestCombo7, gameList, 90, -40)
LayoutHelpers.DepthOverParent(TestCombo7, gameList, 10)

Text7 = CreateText(gameList)	
Text7:SetFont('Arial',11) 
Text7:SetColor('FFbadbdb')
Text7:SetText(ComboTitle7 .. ':')
Text7.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text7, gameList, 90, -225)

TestCombo8 = Combo(gameList3, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo8:AddItems({ComboValues8[2].text, ComboValues8[1].text})
LayoutHelpers.SetWidth(TestCombo8, 160)
LayoutHelpers.SetHeight(TestCombo8, 20)
LayoutHelpers.AtCenterIn(TestCombo8, gameList3, 0, -40)
LayoutHelpers.DepthOverParent(TestCombo8, gameList3, 10)

Text8 = CreateText(gameList3)	
Text8:SetFont('Arial',11) 
Text8:SetColor('FFbadbdb')
Text8:SetText(ComboTitle8 .. ':')
Text8.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text8, gameList3, 0, -250)

TestCombo9 = Combo(gameList, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo9:AddItems({ComboValues9[2].text, ComboValues9[1].text})
LayoutHelpers.SetWidth(TestCombo9, 160)
LayoutHelpers.SetHeight(TestCombo9, 20)
LayoutHelpers.AtCenterIn(TestCombo9, gameList, 60, -40)
LayoutHelpers.DepthOverParent(TestCombo9, gameList, 10)

Text9 = CreateText(gameList)	
Text9:SetFont('Arial',11) 
Text9:SetColor('FFbadbdb')
Text9:SetText(ComboTitle9 .. ':')
Text9.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text9, gameList, 60, -198)

TestCombo10 = Combo(gameList, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo10:AddItems({ComboValues10[1].text, ComboValues10[2].text})
LayoutHelpers.SetWidth(TestCombo10, 160)
LayoutHelpers.SetHeight(TestCombo10, 20)
LayoutHelpers.AtCenterIn(TestCombo10, gameList, 120, -40)
LayoutHelpers.DepthOverParent(TestCombo10, gameList, 10)

Text10 = CreateText(gameList)	
Text10:SetFont('Arial',11) 
Text10:SetColor('FFbadbdb')
Text10:SetText(ComboTitle10 .. ':')
Text10.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text10, gameList, 120, -200)

TestCombo11 = Combo(gameList, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo11:AddItems({ComboValues11[1].text, ComboValues11[2].text})
LayoutHelpers.SetWidth(TestCombo11, 160)
LayoutHelpers.SetHeight(TestCombo11, 20)
LayoutHelpers.AtCenterIn(TestCombo11, gameList, 150, -40)
LayoutHelpers.DepthOverParent(TestCombo11, gameList, 10)

Text11 = CreateText(gameList)	
Text11:SetFont('Arial',11) 
Text11:SetColor('FFbadbdb')
Text11:SetText(ComboTitle11 .. ':')
Text11.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text11, gameList, 150, -200)

TestCombo12 = Combo(gameList3, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo12:AddItems({ComboValues12[1].text, ComboValues12[2].text})
LayoutHelpers.SetWidth(TestCombo12, 160)
LayoutHelpers.SetHeight(TestCombo12, 20)
LayoutHelpers.AtCenterIn(TestCombo12, gameList3, 30, -40)
LayoutHelpers.DepthOverParent(TestCombo12, gameList3, 10)

Text12 = CreateText(gameList3)	
Text12:SetFont('Arial',11) 
Text12:SetColor('FFbadbdb')
Text12:SetText(ComboTitle12 .. ':')
Text12.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text12, gameList3, 30, -252)

TestCombo13 = Combo(gameList3, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo13:AddItems({ComboValues13[3].text, ComboValues13[2].text, ComboValues13[1].text})
LayoutHelpers.SetWidth(TestCombo13, 160)
LayoutHelpers.SetHeight(TestCombo13, 20)
LayoutHelpers.AtCenterIn(TestCombo13, gameList3, 60, -40)
LayoutHelpers.DepthOverParent(TestCombo13, gameList3, 10)

Text13 = CreateText(gameList3)	
Text13:SetFont('Arial',11) 
Text13:SetColor('FFbadbdb')
Text13:SetText(ComboTitle13 .. ':')
Text13.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text13, gameList3, 60, -225)

TestCombo14 = Combo(gameList3, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo14:AddItems({ComboValues14[1].text, ComboValues14[2].text})
LayoutHelpers.SetWidth(TestCombo14, 160)
LayoutHelpers.SetHeight(TestCombo14, 20)
LayoutHelpers.AtCenterIn(TestCombo14, gameList3, 90, -40)
LayoutHelpers.DepthOverParent(TestCombo14, gameList3, 10)

Text14 = CreateText(gameList3)	
Text14:SetFont('Arial',11) 
Text14:SetColor('FFbadbdb')
Text14:SetText(ComboTitle14 .. ':')
Text14.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text14, gameList3, 90, -230)


TestCombo15 = Combo(gameList3, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo15:AddItems({ComboValues15[1].text, ComboValues15[2].text})
LayoutHelpers.SetWidth(TestCombo15, 160)
LayoutHelpers.SetHeight(TestCombo15, 20)
LayoutHelpers.AtCenterIn(TestCombo15, gameList3, 120, -40)
LayoutHelpers.DepthOverParent(TestCombo15, gameList3, 10)

Text15 = CreateText(gameList3)	
Text15:SetFont('Arial',11) 
Text15:SetColor('FFbadbdb')
Text15:SetText(ComboTitle15 .. ':')
Text15.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text15, gameList3, 120, -247)


TestCombo16 = Combo(gameList2, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo16:AddItems({ComboValues16[1].text, ComboValues16[2].text})
LayoutHelpers.SetWidth(TestCombo16, 160)
LayoutHelpers.SetHeight(TestCombo16, 20)
LayoutHelpers.AtCenterIn(TestCombo16, gameList2, -60, -40)
LayoutHelpers.DepthOverParent(TestCombo16, gameList2, 10)

Text16 = CreateText(gameList2)	
Text16:SetFont('Arial',11) 
Text16:SetColor('FFbadbdb')
Text16:SetText(ComboTitle16 .. ':')
Text16.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text16, gameList2, -60, -255)

TestCombo17 = Combo(gameList2, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo17:AddItems({ComboValues17[1].text, ComboValues17[2].text})
LayoutHelpers.SetWidth(TestCombo17, 160)
LayoutHelpers.SetHeight(TestCombo17, 20)
LayoutHelpers.AtCenterIn(TestCombo17, gameList2, -30, -40)
LayoutHelpers.DepthOverParent(TestCombo17, gameList2, 10)

Text17 = CreateText(gameList2)	
Text17:SetFont('Arial',11) 
Text17:SetColor('FFbadbdb')
Text17:SetText(ComboTitle17 .. ':')
Text17.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text17, gameList2, -30, -223)


TestCombo18 = Combo(gameList2, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo18:AddItems({ComboValues18[1].text, ComboValues18[2].text})
LayoutHelpers.SetWidth(TestCombo18, 160)
LayoutHelpers.SetHeight(TestCombo18, 20)
LayoutHelpers.AtCenterIn(TestCombo18, gameList2, 0, -40)
LayoutHelpers.DepthOverParent(TestCombo18, gameList2, 10)

Text18 = CreateText(gameList2)	
Text18:SetFont('Arial',11) 
Text18:SetColor('FFbadbdb')
Text18:SetText(ComboTitle18 .. ':')
Text18.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text18, gameList2, 0, -230)

TestCombo19 = Combo(gameList2, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo19:AddItems({ComboValues19[1].text, ComboValues19[2].text})
LayoutHelpers.SetWidth(TestCombo19, 160)
LayoutHelpers.SetHeight(TestCombo19, 20)
LayoutHelpers.AtCenterIn(TestCombo19, gameList2, 30, -40)
LayoutHelpers.DepthOverParent(TestCombo19, gameList2, 10)

Text19 = CreateText(gameList2)	
Text19:SetFont('Arial',11) 
Text19:SetColor('FFbadbdb')
Text19:SetText(ComboTitle19 .. ':')
Text19.Depth:Set(30)
LayoutHelpers.AtCenterIn(Text19, gameList2, 30, -258)



ForkThread(
	function()
		if Gametype == 'campaign' then
		local focusarmy = GetFocusArmy()
		if focusarmy >= 1 then
		WaitSeconds(1)
		CampaignOptionWindow:Show()
		SessionRequestPause()
		GetCursor():Show()
		UIUtil.MakeInputModal(CampaignOptionWindow)
		end
		end
	end
)		
