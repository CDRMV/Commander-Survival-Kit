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

SaveArray = {}
local LoadArray = nil

function LoadPreviousSavedOptions(boolean, array)
if boolean == true then
LoadArray =	array
else
LoadArray = SaveArray
end
LOG(LoadArray[1])
end

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
CampaignOptionWindow = CreateWindow(GetFrame(0),'<LOC CampaignOptionsManager>Campaign Options Manager',nil,false,false,true,true,'Construction',nil,Border) 
LayoutHelpers.DepthOverParent(CampaignOptionWindow._closeBtn, CampaignOptionWindow, 0)
local defPosition = {	
	Left = 300, 
	Top = 400, 
	Bottom = 900,  
	Right = 1500
}

local Background = Bitmap(CampaignOptionWindow, texpath .. 'small-uef_btn_dis.dds')
LayoutHelpers.FillParentFixedBorder(Background,CampaignOptionWindow, 5)

for i, v in defPosition do 
CampaignOptionWindow[i]:Set(v)
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
local ComboTitle20 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[20].label

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
local ComboValues20 = import("/mods/Commander Survival Kit/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[20].values


local GenPosition = {	
	Left = 310, 
	Top = 480, 
	Bottom = 890,  
	Right = 660
}

local FSMPosition = {	
	Left = 670, 
	Top = 480, 
	Bottom = 890,  
	Right = 1070
}

local RefMPosition = {	
	Left = 1080, 
	Top = 480, 
	Bottom = 890,  
	Right = 1490
}

-- General
General= CreateWindow(CampaignOptionWindow,'<LOC General>General',nil,false,false,true,true,'Construction',nil,Border) 
General._closeBtn:Hide()
LayoutHelpers.DepthOverParent(General._closeBtn, General, 0)
for i, v in GenPosition do 
General[i]:Set(v)
end


    gameList = Group(General)
    LayoutHelpers.AtCenterIn(gameList, General, -220, 110)
    gameList.Width:Set(100)
    LayoutHelpers.SetHeight(gameList, 400)
    gameList.top = 0

-- Fire Support Manager

FireSupportManager= CreateWindow(CampaignOptionWindow,'<LOC FSManager>Fire Support Manager',nil,false,false,true,true,'Construction',nil,Border) 
FireSupportManager._closeBtn:Hide()
LayoutHelpers.DepthOverParent(FireSupportManager._closeBtn, FireSupportManager, 0)
for i, v in FSMPosition do 
FireSupportManager[i]:Set(v)
end

local FSBackground = Bitmap(FireSupportManager, '/mods/Commander Survival Kit/textures/FSSymbol.dds')
LayoutHelpers.FillParentFixedBorder(FSBackground,FireSupportManager, 0)
	
	gameList2 = Group(FireSupportManager)
    LayoutHelpers.AtCenterIn(gameList2, FireSupportManager, -10, 135)
    gameList2.Width:Set(100)
    LayoutHelpers.SetHeight(gameList2, 400)
    gameList2.top = 0

-- Reinforcements Manger

ReinforcementsManager= CreateWindow(CampaignOptionWindow,'<LOC RefManager>Reinforcements Manager',nil,false,false,true,true,'Construction',nil,Border) 
ReinforcementsManager._closeBtn:Hide()
LayoutHelpers.DepthOverParent(ReinforcementsManager._closeBtn, ReinforcementsManager, 0)
for i, v in RefMPosition do 
ReinforcementsManager[i]:Set(v)
end

local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	

if focusarmy >= 1 then
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
	local RefBackground = Bitmap(ReinforcementsManager, '/mods/Commander Survival Kit/textures/AeonRefSymbol.dds')
	LayoutHelpers.FillParentFixedBorder(RefBackground,ReinforcementsManager, 0)		
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
	local RefBackground = Bitmap(ReinforcementsManager, '/mods/Commander Survival Kit/textures/CybranRefSymbol.dds')
	LayoutHelpers.FillParentFixedBorder(RefBackground,ReinforcementsManager, 0)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
	local RefBackground = Bitmap(ReinforcementsManager, '/mods/Commander Survival Kit/textures/UEFRefSymbol.dds')
	LayoutHelpers.FillParentFixedBorder(RefBackground,ReinforcementsManager, 0)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
	local RefBackground = Bitmap(ReinforcementsManager, '/mods/Commander Survival Kit/textures/SeraphimRefSymbol.dds')
	LayoutHelpers.FillParentFixedBorder(RefBackground,ReinforcementsManager, 0)
	end
end



	gameList3 = Group(ReinforcementsManager)
    LayoutHelpers.AtCenterIn(gameList3, ReinforcementsManager, -70, 140)
    gameList3.Width:Set(100)
    LayoutHelpers.SetHeight(gameList3, 400)
    gameList3.top = 0
	

TestCombo = Combo(gameList2, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo:AddItems({ComboValues1[1].text, ComboValues1[2].text})
TestCombo:SetItem(1)
LayoutHelpers.SetWidth(TestCombo, 160)
LayoutHelpers.SetHeight(TestCombo, 20)
LayoutHelpers.AtCenterIn(TestCombo, gameList2, -150, -40)
LayoutHelpers.DepthOverParent(TestCombo, gameList2, 10)

Tooltip.AddControlTooltip(TestCombo, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo)

TestCombo1ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo1ComboTooltips
Tooltip.AddComboTooltip(TestCombo, TestCombo1ComboTooltips)

Text = CreateText(gameList2)	
Text:SetFont('Arial',11) 
Text:SetColor('FFbadbdb')
Text:SetText(LOC(ComboTitle1 .. ':'))
Text.Depth:Set(30)


TestCombo2 = Combo(gameList3, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo2:AddItems({ComboValues2[1].text, ComboValues2[2].text})
TestCombo2:SetItem(1)
LayoutHelpers.SetWidth(TestCombo2, 160)
LayoutHelpers.SetHeight(TestCombo2, 20)
LayoutHelpers.AtCenterIn(TestCombo2, gameList3, -90, -40)
LayoutHelpers.DepthOverParent(TestCombo2, gameList3, 10)

Tooltip.AddControlTooltip(TestCombo2, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo2)

TestCombo2ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo2ComboTooltips
Tooltip.AddComboTooltip(TestCombo2, TestCombo2ComboTooltips)

Text2 = CreateText(gameList3)	
Text2:SetFont('Arial',11) 
Text2:SetColor('FFbadbdb')
Text2:SetText(LOC(ComboTitle2 .. ':'))
Text2.Depth:Set(30)


TestCombo3 = Combo(gameList3, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo3:AddItems({ComboValues3[1].text, ComboValues3[2].text})
TestCombo3:SetItem(1)
LayoutHelpers.SetWidth(TestCombo3, 160)
LayoutHelpers.SetHeight(TestCombo3, 20)
LayoutHelpers.AtCenterIn(TestCombo3, gameList3, -60, -40)
LayoutHelpers.DepthOverParent(TestCombo3, gameList3, 10)

Tooltip.AddControlTooltip(TestCombo3, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo3)

TestCombo3ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo3ComboTooltips
Tooltip.AddComboTooltip(TestCombo3, TestCombo3ComboTooltips)

Text3 = CreateText(gameList3)	
Text3:SetFont('Arial',11) 
Text3:SetColor('FFbadbdb')
Text3:SetText(LOC(ComboTitle3 .. ':'))
Text3.Depth:Set(30)


TestCombo4 = Combo(gameList3, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo4:AddItems({ComboValues4[1].text, ComboValues4[2].text})
TestCombo4:SetItem(1)
LayoutHelpers.SetWidth(TestCombo4, 160)
LayoutHelpers.SetHeight(TestCombo4, 20)
LayoutHelpers.AtCenterIn(TestCombo4, gameList3, -30, -40)
LayoutHelpers.DepthOverParent(TestCombo4, gameList3, 10)

Tooltip.AddControlTooltip(TestCombo4, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo4)

TestCombo4ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo4ComboTooltips
Tooltip.AddComboTooltip(TestCombo4, TestCombo4ComboTooltips)

Text4 = CreateText(gameList3)	
Text4:SetFont('Arial',11) 
Text4:SetColor('FFbadbdb')
Text4:SetText(LOC(ComboTitle4 .. ':'))
Text4.Depth:Set(30)


TestCombo5 = Combo(gameList2, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo5:AddItems({ComboValues5[1].text, ComboValues5[2].text})
TestCombo5:SetItem(1)
LayoutHelpers.SetWidth(TestCombo5, 160)
LayoutHelpers.SetHeight(TestCombo5, 20)
LayoutHelpers.AtCenterIn(TestCombo5, gameList2, -120, -40)
LayoutHelpers.DepthOverParent(TestCombo5, gameList2, 10)

Tooltip.AddControlTooltip(TestCombo5, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo5)

TestCombo5ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo5ComboTooltips
Tooltip.AddComboTooltip(TestCombo5, TestCombo5ComboTooltips)

Text5 = CreateText(gameList2)	
Text5:SetFont('Arial',11) 
Text5:SetColor('FFbadbdb')
Text5:SetText(LOC(ComboTitle5 .. ':'))
Text5.Depth:Set(30)



TestCombo6 = Combo(gameList2, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo6:AddItems({ComboValues6[1].text, ComboValues6[2].text})
TestCombo6:SetItem(2)
LayoutHelpers.SetWidth(TestCombo6, 160)
LayoutHelpers.SetHeight(TestCombo6, 20)
LayoutHelpers.AtCenterIn(TestCombo6, gameList2, -90, -40)
LayoutHelpers.DepthOverParent(TestCombo6, gameList2, 10)

Tooltip.AddControlTooltip(TestCombo6, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo6)

TestCombo6ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo6ComboTooltips
Tooltip.AddComboTooltip(TestCombo6, TestCombo6ComboTooltips)

Text6 = CreateText(gameList2)	
Text6:SetFont('Arial',11) 
Text6:SetColor('FFbadbdb')
Text6:SetText(LOC(ComboTitle6 .. ':'))
Text6.Depth:Set(30)


TestCombo7 = Combo(gameList, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo7:AddItems({ComboValues7[1].text, ComboValues7[2].text})
TestCombo7:SetItem(2)


ForkThread(
	function()
	while true do
RefPointStorageDetected = import('/mods/Commander Survival Kit/UI/Layout/Values.lua').RefPointStorageDetected
TACPointStorageDetected = import('/mods/Commander Survival Kit/UI/Layout/Values.lua').TACPointStorageDetected
if RefPointStorageDetected == true or TACPointStorageDetected == true or RefPointStorageDetected == true and TACPointStorageDetected == true then
TestCombo7:SetItem(1)
TestCombo7:Disable()
end
WaitSeconds(0.1)
end
end)


LayoutHelpers.SetWidth(TestCombo7, 160)
LayoutHelpers.SetHeight(TestCombo7, 20)
LayoutHelpers.AtCenterIn(TestCombo7, gameList, 90, -40)
LayoutHelpers.DepthOverParent(TestCombo7, gameList, 10)

Tooltip.AddControlTooltip(TestCombo7, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo7)

TestCombo7ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo7ComboTooltips
Tooltip.AddComboTooltip(TestCombo7, TestCombo7ComboTooltips)

Text7 = CreateText(gameList)	
Text7:SetFont('Arial',11) 
Text7:SetColor('FFbadbdb')
Text7:SetText(LOC(ComboTitle7 .. ':'))
Text7.Depth:Set(30)


TestCombo8 = Combo(gameList3, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo8:AddItems({ComboValues8[1].text, ComboValues8[2].text})
TestCombo8:SetItem(2)
LayoutHelpers.SetWidth(TestCombo8, 160)
LayoutHelpers.SetHeight(TestCombo8, 20)
LayoutHelpers.AtCenterIn(TestCombo8, gameList3, 0, -40)
LayoutHelpers.DepthOverParent(TestCombo8, gameList3, 10)

Tooltip.AddControlTooltip(TestCombo8, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo8)

TestCombo8ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo8ComboTooltips
Tooltip.AddComboTooltip(TestCombo8, TestCombo8ComboTooltips)

Text8 = CreateText(gameList3)	
Text8:SetFont('Arial',11) 
Text8:SetColor('FFbadbdb')
Text8:SetText(LOC(ComboTitle8 .. ':'))
Text8.Depth:Set(30)


TestCombo9 = Combo(gameList, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo9:AddItems({ComboValues9[1].text, ComboValues9[2].text})
TestCombo9:SetItem(2)
ForkThread(
	function()
	while true do
HQComCenterDetected = import('/mods/Commander Survival Kit/UI/Layout/Values.lua').HQComCenterDetected
if HQComCenterDetected == true then
TestCombo9:SetItem(1)
TestCombo9:Disable()
end
WaitSeconds(0.1)
end
end)

LayoutHelpers.SetWidth(TestCombo9, 160)
LayoutHelpers.SetHeight(TestCombo9, 20)
LayoutHelpers.AtCenterIn(TestCombo9, gameList, 60, -40)
LayoutHelpers.DepthOverParent(TestCombo9, gameList, 10)

Tooltip.AddControlTooltip(TestCombo9, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo9)

TestCombo9ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo9ComboTooltips
Tooltip.AddComboTooltip(TestCombo9, TestCombo9ComboTooltips)

Text9 = CreateText(gameList)	
Text9:SetFont('Arial',11) 
Text9:SetColor('FFbadbdb')
Text9:SetText(LOC(ComboTitle9 .. ':'))
Text9.Depth:Set(30)


TestCombo10 = Combo(gameList, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo10:AddItems({ComboValues10[1].text, ComboValues10[2].text})
TestCombo10:SetItem(1)

ForkThread(
	function()
	while true do
RefCenterDetected = import('/mods/Commander Survival Kit/UI/Layout/Values.lua').RefCenterDetected
TACCenterDetected = import('/mods/Commander Survival Kit/UI/Layout/Values.lua').TACCenterDetected
if RefCenterDetected == true or TACCenterDetected == true or RefCenterDetected == true and TACCenterDetected == true then
TestCombo10:SetItem(1)
TestCombo10:Disable()
end
WaitSeconds(0.1)
end
end)

TestCombo10:SetItem(1)
LayoutHelpers.SetWidth(TestCombo10, 160)
LayoutHelpers.SetHeight(TestCombo10, 20)
LayoutHelpers.AtCenterIn(TestCombo10, gameList, 120, -40)
LayoutHelpers.DepthOverParent(TestCombo10, gameList, 10)

Tooltip.AddControlTooltip(TestCombo10, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo10)

TestCombo10ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo10ComboTooltips
Tooltip.AddComboTooltip(TestCombo10, TestCombo10ComboTooltips)

Text10 = CreateText(gameList)	
Text10:SetFont('Arial',11) 
Text10:SetColor('FFbadbdb')
Text10:SetText(LOC(ComboTitle10 .. ':'))
Text10.Depth:Set(30)


TestCombo11 = Combo(gameList, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo11:AddItems({ComboValues11[1].text, ComboValues11[2].text})
TestCombo11:SetItem(1)
LayoutHelpers.SetWidth(TestCombo11, 160)
LayoutHelpers.SetHeight(TestCombo11, 20)
LayoutHelpers.AtCenterIn(TestCombo11, gameList, 150, -40)
LayoutHelpers.DepthOverParent(TestCombo11, gameList, 10)

Tooltip.AddControlTooltip(TestCombo11, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo11)

TestCombo11ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo11ComboTooltips
Tooltip.AddComboTooltip(TestCombo11, TestCombo11ComboTooltips)

Text11 = CreateText(gameList)	
Text11:SetFont('Arial',11) 
Text11:SetColor('FFbadbdb')
Text11:SetText(LOC(ComboTitle11 .. ':'))
Text11.Depth:Set(30)


TestCombo12 = Combo(gameList3, 12, 12, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo12:AddItems({
ComboValues12[1].text, 
ComboValues12[2].text, 
ComboValues12[3].text, 
ComboValues12[4].text, 
ComboValues12[5].text, 
ComboValues12[6].text, 
ComboValues12[7].text,
ComboValues12[8].text, 
ComboValues12[9].text, 
ComboValues12[10].text, 
ComboValues12[11].text, 
ComboValues12[12].text
})
TestCombo12:SetItem(1)
LayoutHelpers.SetWidth(TestCombo12, 160)
LayoutHelpers.SetHeight(TestCombo12, 20)
LayoutHelpers.AtCenterIn(TestCombo12, gameList3, 30, -40)
LayoutHelpers.DepthOverParent(TestCombo12, gameList3, 10)

Tooltip.AddControlTooltip(TestCombo12, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo12)

TestCombo12ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo12ComboTooltips
Tooltip.AddComboTooltip(TestCombo12, TestCombo12ComboTooltips)

Text12 = CreateText(gameList3)	
Text12:SetFont('Arial',11) 
Text12:SetColor('FFbadbdb')
Text12:SetText(LOC(ComboTitle12 .. ':'))
Text12.Depth:Set(30)


TestCombo13 = Combo(gameList3, 12, 3, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo13:AddItems({ComboValues13[1].text, ComboValues13[2].text, ComboValues13[3].text})
TestCombo13:SetItem(3)
LayoutHelpers.SetWidth(TestCombo13, 160)
LayoutHelpers.SetHeight(TestCombo13, 20)
LayoutHelpers.AtCenterIn(TestCombo13, gameList3, 60, -40)
LayoutHelpers.DepthOverParent(TestCombo13, gameList3, 10)

Tooltip.AddControlTooltip(TestCombo13, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo13)

TestCombo13ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo13ComboTooltips
Tooltip.AddComboTooltip(TestCombo13, TestCombo13ComboTooltips)

Text13 = CreateText(gameList3)	
Text13:SetFont('Arial',11) 
Text13:SetColor('FFbadbdb')
Text13:SetText(LOC(ComboTitle13 .. ':'))
Text13.Depth:Set(30)


TestCombo14 = Combo(gameList3, 12, 4, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo14:AddItems({ComboValues14[1].text, ComboValues14[2].text, ComboValues14[3].text, ComboValues14[4].text})
TestCombo14:SetItem(2)
LayoutHelpers.SetWidth(TestCombo14, 160)
LayoutHelpers.SetHeight(TestCombo14, 20)
LayoutHelpers.AtCenterIn(TestCombo14, gameList3, 90, -40)
LayoutHelpers.DepthOverParent(TestCombo14, gameList3, 10)

Tooltip.AddControlTooltip(TestCombo14, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo14)

TestCombo14ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo14ComboTooltips
Tooltip.AddComboTooltip(TestCombo14, TestCombo14ComboTooltips)

Text14 = CreateText(gameList3)	
Text14:SetFont('Arial',11) 
Text14:SetColor('FFbadbdb')
Text14:SetText(LOC(ComboTitle14 .. ':'))
Text14.Depth:Set(30)



TestCombo15 = Combo(gameList3, 12, 6, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo15:AddItems({
ComboValues15[1].text, 
ComboValues15[2].text, 
ComboValues15[3].text, 
ComboValues15[4].text, 
ComboValues15[5].text,
ComboValues15[6].text
})
TestCombo15:SetItem(4)
LayoutHelpers.SetWidth(TestCombo15, 160)
LayoutHelpers.SetHeight(TestCombo15, 20)
LayoutHelpers.AtCenterIn(TestCombo15, gameList3, 120, -40)
LayoutHelpers.DepthOverParent(TestCombo15, gameList3, 10)

Tooltip.AddControlTooltip(TestCombo15, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo15)

TestCombo15ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo15ComboTooltips
Tooltip.AddComboTooltip(TestCombo15, TestCombo15ComboTooltips)

Text15 = CreateText(gameList3)	
Text15:SetFont('Arial',11) 
Text15:SetColor('FFbadbdb')
Text15:SetText(LOC(ComboTitle15 .. ':'))
Text15.Depth:Set(30)



TestCombo16 = Combo(gameList2, 12, 12, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo16:AddItems({
ComboValues16[1].text, 
ComboValues16[2].text, 
ComboValues16[3].text, 
ComboValues16[4].text, 
ComboValues16[5].text, 
ComboValues16[6].text, 
ComboValues16[7].text,
ComboValues16[8].text, 
ComboValues16[9].text, 
ComboValues16[10].text, 
ComboValues16[11].text, 
ComboValues16[12].text
})
TestCombo16:SetItem(1)
LayoutHelpers.SetWidth(TestCombo16, 160)
LayoutHelpers.SetHeight(TestCombo16, 20)
LayoutHelpers.AtCenterIn(TestCombo16, gameList2, -60, -40)
LayoutHelpers.DepthOverParent(TestCombo16, gameList2, 10)

Tooltip.AddControlTooltip(TestCombo16, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo16)

TestCombo16ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo16ComboTooltips
Tooltip.AddComboTooltip(TestCombo16, TestCombo16ComboTooltips)

Text16 = CreateText(gameList2)	
Text16:SetFont('Arial',11) 
Text16:SetColor('FFbadbdb')
Text16:SetText(LOC(ComboTitle16 .. ':'))
Text16.Depth:Set(30)


TestCombo17 = Combo(gameList2, 12, 3, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo17:AddItems({ComboValues17[1].text, ComboValues17[2].text, ComboValues17[3].text})
TestCombo17:SetItem(3)
LayoutHelpers.SetWidth(TestCombo17, 160)
LayoutHelpers.SetHeight(TestCombo17, 20)
LayoutHelpers.AtCenterIn(TestCombo17, gameList2, -30, -40)
LayoutHelpers.DepthOverParent(TestCombo17, gameList2, 10)

Tooltip.AddControlTooltip(TestCombo17, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo17)

TestCombo17ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo17ComboTooltips
Tooltip.AddComboTooltip(TestCombo17, TestCombo17ComboTooltips)


Text17 = CreateText(gameList2)	
Text17:SetFont('Arial',11) 
Text17:SetColor('FFbadbdb')
Text17:SetText(LOC(ComboTitle17 .. ':'))
Text17.Depth:Set(30)



TestCombo18 = Combo(gameList2, 12, 4, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo18:AddItems({ComboValues18[1].text, ComboValues18[2].text, ComboValues18[3].text, ComboValues18[4].text})
TestCombo18:SetItem(2)
LayoutHelpers.SetWidth(TestCombo18, 160)
LayoutHelpers.SetHeight(TestCombo18, 20)
LayoutHelpers.AtCenterIn(TestCombo18, gameList2, 0, -40)
LayoutHelpers.DepthOverParent(TestCombo18, gameList2, 10)

Tooltip.AddControlTooltip(TestCombo18, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo18)

TestCombo18ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo18ComboTooltips
Tooltip.AddComboTooltip(TestCombo18, TestCombo18ComboTooltips)

Text18 = CreateText(gameList2)	
Text18:SetFont('Arial',11) 
Text18:SetColor('FFbadbdb')
Text18:SetText(LOC(ComboTitle18 .. ':'))
Text18.Depth:Set(30)


TestCombo19 = Combo(gameList2, 12, 6, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo19:AddItems({
ComboValues19[1].text, 
ComboValues19[2].text,
ComboValues19[3].text, 
ComboValues19[4].text,
ComboValues19[5].text, 
ComboValues19[6].text
})
TestCombo19:SetItem(4)
LayoutHelpers.SetWidth(TestCombo19, 160)
LayoutHelpers.SetHeight(TestCombo19, 20)
LayoutHelpers.AtCenterIn(TestCombo19, gameList2, 30, -40)
LayoutHelpers.DepthOverParent(TestCombo19, gameList2, 10)

Tooltip.AddControlTooltip(TestCombo19, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo19)

TestCombo19ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo19ComboTooltips
Tooltip.AddComboTooltip(TestCombo19, TestCombo19ComboTooltips)

Text19 = CreateText(gameList2)	
Text19:SetFont('Arial',11) 
Text19:SetColor('FFbadbdb')
Text19:SetText(LOC(ComboTitle19 .. ':'))
Text19.Depth:Set(30)


TestCombo20 = Combo(gameList2, 12, 2, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo20:AddItems({ComboValues20[1].text, ComboValues20[2].text})
TestCombo20:SetItem(2)
LayoutHelpers.SetWidth(TestCombo20, 160)
LayoutHelpers.SetHeight(TestCombo20, 20)
LayoutHelpers.AtCenterIn(TestCombo20, gameList2, 60, -40)
LayoutHelpers.DepthOverParent(TestCombo20, gameList2, 10)

Tooltip.AddControlTooltip(TestCombo20, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo20)

TestCombo20ComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').TestCombo20ComboTooltips
Tooltip.AddComboTooltip(TestCombo20, TestCombo20ComboTooltips)

Text20 = CreateText(gameList2)	
Text20:SetFont('Arial',11) 
Text20:SetColor('FFbadbdb')
Text20:SetText(LOC(ComboTitle20 .. ':'))
Text20.Depth:Set(30)



if __language == 'de' then
LayoutHelpers.AtCenterIn(Text, gameList2, -150, -240)
LayoutHelpers.AtCenterIn(Text2, gameList3, -90, -270)
LayoutHelpers.AtCenterIn(Text3, gameList3, -60, -275)
LayoutHelpers.AtCenterIn(Text4, gameList3, -30, -268)
LayoutHelpers.AtCenterIn(Text5, gameList2, -120, -288)
LayoutHelpers.AtCenterIn(Text6, gameList2, -90, -268)
LayoutHelpers.AtCenterIn(Text7, gameList, 90, -225)
LayoutHelpers.AtCenterIn(Text8, gameList3, 0, -250)
LayoutHelpers.AtCenterIn(Text9, gameList, 60, -198)
LayoutHelpers.AtCenterIn(Text10, gameList, 120, -200)
LayoutHelpers.AtCenterIn(Text11, gameList, 150, -200)
LayoutHelpers.AtCenterIn(Text12, gameList3, 30, -252)
LayoutHelpers.AtCenterIn(Text13, gameList3, 60, -225)
LayoutHelpers.AtCenterIn(Text14, gameList3, 90, -230)
LayoutHelpers.AtCenterIn(Text15, gameList3, 120, -247)
LayoutHelpers.AtCenterIn(Text16, gameList2, -60, -255)
LayoutHelpers.AtCenterIn(Text17, gameList2, -30, -223)
LayoutHelpers.AtCenterIn(Text18, gameList2, 0, -230)
LayoutHelpers.AtCenterIn(Text19, gameList2, 30, -258)
LayoutHelpers.AtCenterIn(Text20, gameList2, 60, -258)
else
LayoutHelpers.AtCenterIn(Text, gameList2, -150, -250)
LayoutHelpers.AtCenterIn(Text2, gameList3, -90, -270)
LayoutHelpers.AtCenterIn(Text3, gameList3, -60, -275)
LayoutHelpers.AtCenterIn(Text4, gameList3, -30, -268)
LayoutHelpers.AtCenterIn(Text5, gameList2, -120, -288)
LayoutHelpers.AtCenterIn(Text6, gameList2, -90, -268)
LayoutHelpers.AtCenterIn(Text7, gameList, 90, -225)
LayoutHelpers.AtCenterIn(Text8, gameList3, 0, -250)
LayoutHelpers.AtCenterIn(Text9, gameList, 60, -198)
LayoutHelpers.AtCenterIn(Text10, gameList, 120, -200)
LayoutHelpers.AtCenterIn(Text11, gameList, 150, -200)
LayoutHelpers.AtCenterIn(Text12, gameList3, 30, -252)
LayoutHelpers.AtCenterIn(Text13, gameList3, 60, -225)
LayoutHelpers.AtCenterIn(Text14, gameList3, 90, -230)
LayoutHelpers.AtCenterIn(Text15, gameList3, 120, -247)
LayoutHelpers.AtCenterIn(Text16, gameList2, -60, -255)
LayoutHelpers.AtCenterIn(Text17, gameList2, -30, -223)
LayoutHelpers.AtCenterIn(Text18, gameList2, 0, -230)
LayoutHelpers.AtCenterIn(Text19, gameList2, 30, -258)
LayoutHelpers.AtCenterIn(Text20, gameList2, 60, -258)
end


local savebutton
local loadbutton
local donebutton

if focusarmy >= 1 then
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
		savebutton = UIUtil.CreateButtonStd(CampaignOptionWindow, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "<LOC Save>Save", 11, 0, 0)
		loadbutton = UIUtil.CreateButtonStd(CampaignOptionWindow, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "<LOC Load>Load", 11, 0, 0)
		donebutton = UIUtil.CreateButtonStd(CampaignOptionWindow, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "<LOC Done>Done", 11, 0, 0)	
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		savebutton = UIUtil.CreateButtonStd(CampaignOptionWindow, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "<LOC Save>Save", 11, 0, 0)
		loadbutton = UIUtil.CreateButtonStd(CampaignOptionWindow, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "<LOC Load>Load", 11, 0, 0)
		donebutton = UIUtil.CreateButtonStd(CampaignOptionWindow, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "<LOC Done>Done", 11, 0, 0)	
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		savebutton = UIUtil.CreateButtonStd(CampaignOptionWindow, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "<LOC Save>Save", 11, 0, 0)
		loadbutton = UIUtil.CreateButtonStd(CampaignOptionWindow, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "<LOC Load>Load", 11, 0, 0)
		donebutton = UIUtil.CreateButtonStd(CampaignOptionWindow, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "<LOC Done>Done", 11, 0, 0)	
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		savebutton = UIUtil.CreateButtonStd(CampaignOptionWindow, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "<LOC Save>Save", 11, 0, 0)
		loadbutton = UIUtil.CreateButtonStd(CampaignOptionWindow, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "<LOC Load>Load", 11, 0, 0)
		donebutton = UIUtil.CreateButtonStd(CampaignOptionWindow, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "<LOC Done>Done", 11, 0, 0)
	end
end

Tooltip.AddButtonTooltip(savebutton, "SaveBtn", 1)
Tooltip.AddButtonTooltip(loadbutton, "LoadBtn", 1)
Tooltip.AddButtonTooltip(donebutton, "DoneBtn", 1)

SaveArray[1] = TestCombo:GetItem()
SaveArray[2] = TestCombo2:GetItem()
SaveArray[3] = TestCombo3:GetItem()
SaveArray[4] = TestCombo4:GetItem()
SaveArray[5] = TestCombo5:GetItem()
SaveArray[6] = TestCombo6:GetItem()
SaveArray[7] = TestCombo7:GetItem()
SaveArray[8] = TestCombo8:GetItem()
SaveArray[9] = TestCombo9:GetItem()
SaveArray[10] = TestCombo10:GetItem()
SaveArray[11] = TestCombo11:GetItem()
SaveArray[12] = TestCombo12:GetItem()
SaveArray[13] = TestCombo13:GetItem()
SaveArray[14] = TestCombo14:GetItem()
SaveArray[15] = TestCombo15:GetItem()
SaveArray[16] = TestCombo16:GetItem()
SaveArray[17] = TestCombo17:GetItem()
SaveArray[18] = TestCombo18:GetItem()
SaveArray[19] = TestCombo19:GetItem()
SaveArray[20] = TestCombo20:GetItem()


savebutton.OnClick = function(self)
SaveArray[1] = TestCombo:GetItem()
SaveArray[2] = TestCombo2:GetItem()
SaveArray[3] = TestCombo3:GetItem()
SaveArray[4] = TestCombo4:GetItem()
SaveArray[5] = TestCombo5:GetItem()
SaveArray[6] = TestCombo6:GetItem()
SaveArray[7] = TestCombo7:GetItem()
SaveArray[8] = TestCombo8:GetItem()
SaveArray[9] = TestCombo9:GetItem()
SaveArray[10] = TestCombo10:GetItem()
SaveArray[11] = TestCombo11:GetItem()
SaveArray[12] = TestCombo12:GetItem()
SaveArray[13] = TestCombo13:GetItem()
SaveArray[14] = TestCombo14:GetItem()
SaveArray[15] = TestCombo15:GetItem()
SaveArray[16] = TestCombo16:GetItem()
SaveArray[17] = TestCombo17:GetItem()
SaveArray[18] = TestCombo18:GetItem()
SaveArray[19] = TestCombo19:GetItem()
SaveArray[20] = TestCombo20:GetItem()

LoadPreviousSavedOptions(false, nil)
Sync.TransferSaveArray = SaveArray
end

loadbutton.OnClick = function(self)
TestCombo:SetItem(LoadArray[1])
TestCombo2:SetItem(LoadArray[2])
TestCombo3:SetItem(LoadArray[3])
TestCombo4:SetItem(LoadArray[4])
TestCombo5:SetItem(LoadArray[5])
TestCombo6:SetItem(LoadArray[6])
TestCombo7:SetItem(LoadArray[7])
TestCombo8:SetItem(LoadArray[8])
TestCombo9:SetItem(LoadArray[9])
TestCombo10:SetItem(LoadArray[10])
TestCombo11:SetItem(LoadArray[11])
TestCombo12:SetItem(LoadArray[12])
TestCombo13:SetItem(LoadArray[13])
TestCombo14:SetItem(LoadArray[14])
TestCombo15:SetItem(LoadArray[15])
TestCombo16:SetItem(LoadArray[16])
TestCombo17:SetItem(LoadArray[17])
TestCombo18:SetItem(LoadArray[18])
TestCombo19:SetItem(LoadArray[19])	
TestCombo20:SetItem(LoadArray[20])	
end

donebutton.OnClick = function(self)
SaveArray[1] = TestCombo:GetItem()
SaveArray[2] = TestCombo2:GetItem()
SaveArray[3] = TestCombo3:GetItem()
SaveArray[4] = TestCombo4:GetItem()
SaveArray[5] = TestCombo5:GetItem()
SaveArray[6] = TestCombo6:GetItem()
SaveArray[7] = TestCombo7:GetItem()
SaveArray[8] = TestCombo8:GetItem()
SaveArray[9] = TestCombo9:GetItem()
SaveArray[10] = TestCombo10:GetItem()
SaveArray[11] = TestCombo11:GetItem()
SaveArray[12] = TestCombo12:GetItem()
SaveArray[13] = TestCombo13:GetItem()
SaveArray[14] = TestCombo14:GetItem()
SaveArray[15] = TestCombo15:GetItem()
SaveArray[16] = TestCombo16:GetItem()
SaveArray[17] = TestCombo17:GetItem()
SaveArray[18] = TestCombo18:GetItem()
SaveArray[19] = TestCombo19:GetItem()
SaveArray[20] = TestCombo20:GetItem()
if import('/lua/ui/game/gamemain.lua').IsNISMode() == true then
GetCursor():Hide()
else
GetCursor():Show()
end
CampaignOptionWindow:Hide()
UIUtil.MakeInputModal(GetFrame(0))
SessionResume()
import('/mods/Commander Survival Kit/UI/Main.lua').GetRefCampaignOptions(SaveArray)
import('/mods/Commander Survival Kit/UI/refheader.lua').GetRefCampaignOptions(SaveArray)
import('/mods/Commander Survival Kit/UI/fsheader.lua').GetFireSupportCampaignOptions(SaveArray)
import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').GetFireSupportCampaignOptions(SaveArray)
import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').GetRefCampaignOptions(SaveArray)
import('/mods/Commander Survival Kit/UI/LandReinforcementManager.lua').GetLandRefCampaignOptions(SaveArray)
import('/mods/Commander Survival Kit/UI/AirReinforcementManager.lua').GetAirRefCampaignOptions(SaveArray)
import('/mods/Commander Survival Kit/UI/NavalReinforcementManager.lua').GetNavalRefCampaignOptions(SaveArray)
CheckforPointStoragesIncluded(TestCombo7:GetItem())
CheckforPointGenerationCentersIncluded(TestCombo10:GetItem())
CheckforHQCommunicationCenterIncluded(TestCombo9:GetItem())
CheckforFireSupportWaitTime(TestCombo16:GetItem())
CheckforFireSupportGenInterval(TestCombo17:GetItem())
CheckforFireSupportGenRate(TestCombo18:GetItem())
CheckforFireSupportMaximalPoints(TestCombo19:GetItem())
CheckforRefWaitTime(TestCombo12:GetItem())
CheckforRefGenInterval(TestCombo13:GetItem())
CheckforRefGenRate(TestCombo14:GetItem())
CheckforRefMaximalPoints(TestCombo15:GetItem())
CheckforKillReward(TestCombo11:GetItem())
CheckforAirStrikeMechanic(TestCombo6:GetItem())

end

--[[

CampaignOptionWindow._closeBtn.OnClick = function(control)

SaveArray[1] = TestCombo:GetItem()
SaveArray[2] = TestCombo2:GetItem()
SaveArray[3] = TestCombo3:GetItem()
SaveArray[4] = TestCombo4:GetItem()
SaveArray[5] = TestCombo5:GetItem()
SaveArray[6] = TestCombo6:GetItem()
SaveArray[7] = TestCombo7:GetItem()
SaveArray[8] = TestCombo8:GetItem()
SaveArray[9] = TestCombo9:GetItem()
SaveArray[10] = TestCombo10:GetItem()
SaveArray[11] = TestCombo11:GetItem()
SaveArray[12] = TestCombo12:GetItem()
SaveArray[13] = TestCombo13:GetItem()
SaveArray[14] = TestCombo14:GetItem()
SaveArray[15] = TestCombo15:GetItem()
SaveArray[16] = TestCombo16:GetItem()
SaveArray[17] = TestCombo17:GetItem()
SaveArray[18] = TestCombo18:GetItem()
SaveArray[19] = TestCombo19:GetItem()
GetCursor():Hide()
CampaignOptionWindow:Hide()
UIUtil.MakeInputModal(GetFrame(0))
SessionResume()
import('/mods/Commander Survival Kit/UI/Main.lua').GetRefCampaignOptions(SaveArray)
import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').GetFireSupportCampaignOptions(SaveArray)
import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').GetRefCampaignOptions(SaveArray)
import('/mods/Commander Survival Kit/UI/LandReinforcementManager.lua').GetLandRefCampaignOptions(SaveArray)
import('/mods/Commander Survival Kit/UI/AirReinforcementManager.lua').GetAirRefCampaignOptions(SaveArray)
import('/mods/Commander Survival Kit/UI/NavalReinforcementManager.lua').GetNavalRefCampaignOptions(SaveArray)
CheckforPointStoragesIncluded(TestCombo7:GetItem())
CheckforPointGenerationCentersIncluded(TestCombo10:GetItem())
CheckforHQCommunicationCenterIncluded(TestCombo9:GetItem())
CheckforFireSupportWaitTime(TestCombo16:GetItem())
CheckforFireSupportGenInterval(TestCombo17:GetItem())
CheckforFireSupportGenRate(TestCombo18:GetItem())
CheckforFireSupportMaximalPoints(TestCombo19:GetItem())
CheckforRefWaitTime(TestCombo12:GetItem())
CheckforRefGenInterval(TestCombo13:GetItem())
CheckforRefGenRate(TestCombo14:GetItem())
CheckforRefMaximalPoints(TestCombo15:GetItem())
CheckforKillReward(TestCombo11:GetItem())
CheckforAirStrikeMechanic(TestCombo6:GetItem())

end

]]--

--Tooltip.AddButtonTooltip(savebutton, "MPBtn", 1)
--Tooltip.AddButtonTooltip(loadbutton, "MSBtn", 1)
--Tooltip.AddButtonTooltip(donebutton, "MSBtn", 1)


LayoutHelpers.SetWidth(savebutton, 200)
LayoutHelpers.SetHeight(savebutton, 80)
LayoutHelpers.AtCenterIn(savebutton, CampaignOptionWindow, -200, -200)
LayoutHelpers.DepthOverParent(savebutton, CampaignOptionWindow, 10)
LayoutHelpers.SetWidth(loadbutton, 200)
LayoutHelpers.SetHeight(loadbutton, 80)
LayoutHelpers.AtCenterIn(loadbutton, CampaignOptionWindow, -200, 0)
LayoutHelpers.DepthOverParent(loadbutton, CampaignOptionWindow, 10)
LayoutHelpers.SetWidth(donebutton, 200)
LayoutHelpers.SetHeight(donebutton, 80)
LayoutHelpers.AtCenterIn(donebutton, CampaignOptionWindow, -200, 200)
LayoutHelpers.DepthOverParent(donebutton, CampaignOptionWindow, 10)

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
		LOG(__language)
		end
		end
	end
)	


CheckforPointStoragesIncluded = function(value)	

    data = {
        From = GetFocusArmy(),
        To = -1,
        Name = "CheckforPointStoragesIncluded",
        Args = {selection = value }
    }
    local QueryCb = function() end
    import('/lua/UserPlayerQuery.lua').Query( data, QueryCb) 


end

CheckforPointGenerationCentersIncluded = function(value)	

    data = {
        From = GetFocusArmy(),
        To = -1,
        Name = "CheckforPointGenerationCentersIncluded",
        Args = {selection = value }
    }
    local QueryCb = function() end
    import('/lua/UserPlayerQuery.lua').Query( data, QueryCb) 


end

CheckforHQCommunicationCenterIncluded = function(value)	

    data = {
        From = GetFocusArmy(),
        To = -1,
        Name = "CheckforHQCommunicationCenterIncluded",
        Args = {selection = value }
    }
    local QueryCb = function() end
    import('/lua/UserPlayerQuery.lua').Query( data, QueryCb) 


end

CheckforKillReward = function(value)	

    data = {
        From = GetFocusArmy(),
        To = -1,
        Name = "CheckforKillRewardIncluded",
        Args = {selection = value }
    }
    local QueryCb = function() end
    import('/lua/UserPlayerQuery.lua').Query( data, QueryCb) 


end

CheckforAirStrikeMechanic = function(value)	

    data = {
        From = GetFocusArmy(),
        To = -1,
        Name = "CheckforAirStrikeMechanic",
        Args = {selection = value }
    }
    local QueryCb = function() end
    import('/lua/UserPlayerQuery.lua').Query( data, QueryCb) 


end



CheckforFireSupportWaitTime = function(value)	

local SendValue = 0

-- 5 Minutes
if value == 1 then
SendValue = ComboValues12[1].key
end

-- 10 Minutes
if value == 2 then
SendValue = ComboValues12[2].key
end

-- 15 Minutes
if value == 3 then
SendValue = ComboValues12[3].key
end

-- 20 Minutes
if value == 4 then
SendValue = ComboValues12[4].key
end

-- 25 Minutes
if value == 5 then
SendValue = ComboValues12[5].key
end

-- 30 Minutes
if value == 6 then
SendValue = ComboValues12[6].key
end

-- 35 Minutes
if value == 7 then
SendValue = ComboValues12[7].key
end

-- 40 Minutes
if value == 8 then
SendValue = ComboValues12[8].key
end

-- 45 Minutes
if value == 9 then
SendValue = ComboValues12[9].key
end

-- 50 Minutes
if value == 10 then
SendValue = ComboValues12[10].key
end

-- 55 Minutes
if value == 11 then
SendValue = ComboValues12[11].key
end

-- 60 Minutes
if value == 12 then
SendValue = ComboValues12[12].key
end

import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').GetFireSupportWaitTimeCampaignOptionValue(SendValue)

end

CheckforFireSupportMaximalPoints = function(value)	

local SendValue = 0

-- 0 Points
if value == 1 then
SendValue = ComboValues19[1].key
end

-- 1000 Points
if value == 2 then
SendValue = ComboValues19[2].key
end

-- 2000 Points
if value == 3 then
SendValue = ComboValues19[3].key
end

-- 3000 Points
if value == 4 then
SendValue = ComboValues19[4].key
end

-- 4000 Points
if value == 5 then
SendValue = ComboValues19[5].key
end

-- 5000 Points
if value == 6 then
SendValue = ComboValues19[6].key
end

import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').GetFireSupportMaxPointCampaignOptionValue(SendValue)

end

CheckforFireSupportGenInterval = function(value)	

local SendValue = 0

-- 1 Seconds
if value == 1 then
SendValue = ComboValues17[1].key
end

-- 2 Seconds
if value == 2 then
SendValue = ComboValues17[2].key
end

-- 3 Seconds
if value == 3 then
SendValue = ComboValues17[3].key
end


import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').GetFireSupportGenIntervalCampaignOptionValue(SendValue)




end

CheckforFireSupportGenRate = function(value)	

local SendValue = 0

-- Deactivated/0 Point
if value == 1 then
SendValue = ComboValues18[1].key
end

-- 1 Point
if value == 2 then
SendValue = ComboValues18[2].key
end

-- 2 Points
if value == 3 then
SendValue = ComboValues18[3].key
end

-- 3 Points
if value == 4 then
SendValue = ComboValues18[3].key
end



import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').GetFireSupportGenRateCampaignOptionValue(SendValue)


end

CheckforRefWaitTime = function(value)	

local SendValue = 0

-- 5 Minutes
if value == 1 then
SendValue = ComboValues12[1].key
end

-- 10 Minutes
if value == 2 then
SendValue = ComboValues12[2].key
end

-- 15 Minutes
if value == 3 then
SendValue = ComboValues12[3].key
end

-- 20 Minutes
if value == 4 then
SendValue = ComboValues12[4].key
end

-- 25 Minutes
if value == 5 then
SendValue = ComboValues12[5].key
end

-- 30 Minutes
if value == 6 then
SendValue = ComboValues12[6].key
end

-- 35 Minutes
if value == 7 then
SendValue = ComboValues12[7].key
end

-- 40 Minutes
if value == 8 then
SendValue = ComboValues12[8].key
end

-- 45 Minutes
if value == 9 then
SendValue = ComboValues12[9].key
end

-- 50 Minutes
if value == 10 then
SendValue = ComboValues12[10].key
end

-- 55 Minutes
if value == 11 then
SendValue = ComboValues12[11].key
end

-- 60 Minutes
if value == 12 then
SendValue = ComboValues12[12].key
end

import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').GetRefWaitTimeCampaignOptionValue(SendValue)

end


CheckforRefMaximalPoints = function(value)	

local SendValue = 0

-- 0 Points
if value == 1 then
SendValue = ComboValues15[1].key
end

-- 1000 Points
if value == 2 then
SendValue = ComboValues15[2].key
end

-- 2000 Points
if value == 3 then
SendValue = ComboValues15[3].key
end

-- 3000 Points
if value == 4 then
SendValue = ComboValues15[4].key
end

-- 4000 Points
if value == 5 then
SendValue = ComboValues15[5].key
end

-- 5000 Points
if value == 6 then
SendValue = ComboValues15[6].key
end

LOG('SendValue: ', SendValue)
import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').GetRefMaxPointCampaignOptionValue(SendValue)


end

CheckforRefGenInterval = function(value)	

local SendValue = 0

-- 1 Seconds
if value == 1 then
SendValue = ComboValues13[1].key
end

-- 2 Seconds
if value == 2 then
SendValue = ComboValues13[2].key
end

-- 3 Seconds
if value == 3 then
SendValue = ComboValues13[3].key
end


import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').GetRefGenIntervalCampaignOptionValue(SendValue)



end

CheckforRefGenRate = function(value)	

local SendValue = 0

-- Deactivated/0 Point
if value == 1 then
SendValue = ComboValues14[1].key
end

-- 1 Point
if value == 2 then
SendValue = ComboValues14[2].key
end

-- 2 Points
if value == 3 then
SendValue = ComboValues14[3].key
end

-- 3 Points
if value == 4 then
SendValue = ComboValues14[3].key
end



import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').GetRefGenRateCampaignOptionValue(SendValue)


end


