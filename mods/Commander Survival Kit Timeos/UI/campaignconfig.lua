----directory----
local path = '/mods/Commander Survival Kit Timeos/UI/'
local texpath = '/mods/Commander Survival Kit Timeos/textures/medium-uef_btn/'
----significant operators imported from external sources----
local CreateText = import('/lua/maui/text.lua').Text 
local CreateWindow = import('/lua/maui/window.lua').Window
local UIUtil = import('/lua/ui/uiutil.lua')
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local Group = import("/lua/maui/group.lua").Group
local LayoutHelpers = import("/lua/maui/layouthelpers.lua")
local factions = import('/lua/factions.lua').Factions
local Movie = import('/lua/maui/movie.lua').Movie
local Tooltip = import("/lua/ui/game/tooltip.lua")
local Gametype = SessionGetScenarioInfo().type
local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	
local Bitmap = import("/lua/maui/bitmap.lua").Bitmap
local Combo = import("/lua/ui/controls/combo.lua").Combo
local Button = import("/lua/maui/button.lua").Button
local Scrollbar = import("/lua/maui/scrollbar.lua").Scrollbar

local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	

local GetCSKPath = function() for i, mod in __active_mods do if mod.CSKProjectModName == "CSK" then return mod.location end end end
local CSKPath = GetCSKPath()
local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.CSKProjectModName == "CSK-Units" then return mod.location end end end
local CSKUnitsPath = GetCSKUnitsPath()
local GetFBPOrbitalPath = function() for i, mod in __active_mods do if mod.FBPProjectModName == "FBP-Orbital" then return mod.location end end end
local FBPOrbitalPath = GetFBPOrbitalPath()

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
    Main = Group(GetFrame(0))
    LayoutHelpers.AtCenterIn(Main, GetFrame(0), 0, 0)
	if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
    LayoutHelpers.SetHeight(Main, 250)
    LayoutHelpers.SetWidth(Main, 600)
	else
    LayoutHelpers.SetHeight(Main, 220)
    LayoutHelpers.SetWidth(Main, 600)
	end
	

----parameters----
CampaignOptionWindow = CreateWindow(Main,'<LOC CampaignOptionsManager>Campaign Options Manager',nil,false,false,true,false,'Construction',nil,Border) 
LayoutHelpers.DepthOverParent(CampaignOptionWindow._closeBtn, CampaignOptionWindow, 0)
LayoutHelpers.FillParentFixedBorder(CampaignOptionWindow,Main, 5)


local Background = Bitmap(CampaignOptionWindow, texpath .. 'small-uef_btn_dis.dds')
LayoutHelpers.FillParentFixedBorder(Background,CampaignOptionWindow, 5)

LayoutHelpers.DepthOverParent(CampaignOptionWindow, Main, 30)

local ComboTitle1 = import("/mods/Commander Survival Kit Timeos/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[1].label
local ComboTitle2 = import("/mods/Commander Survival Kit Timeos/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[2].label
local ComboTitle3 = import("/mods/Commander Survival Kit Timeos/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[3].label
local ComboTitle4 = import("/mods/Commander Survival Kit Timeos/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[4].label
local ComboTitle5 = import("/mods/Commander Survival Kit Timeos/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[5].label
local ComboTitle6 = import("/mods/Commander Survival Kit Timeos/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[6].label


local ComboValues1 = import("/mods/Commander Survival Kit Timeos/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[1].values
local ComboValues2 = import("/mods/Commander Survival Kit Timeos/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[2].values
local ComboValues3 = import("/mods/Commander Survival Kit Timeos/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[3].values
local ComboValues4 = import("/mods/Commander Survival Kit Timeos/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[4].values
local ComboValues5 = import("/mods/Commander Survival Kit Timeos/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[5].values
local ComboValues6 = import("/mods/Commander Survival Kit Timeos/lua/AI/LobbyOptions/lobbyoptions.lua").AIOpts[6].values

    gameList = Group(CampaignOptionWindow)
    LayoutHelpers.AtCenterIn(gameList, CampaignOptionWindow, -60, 110)
    gameList.Width:Set(100)
    LayoutHelpers.SetHeight(gameList, 400)
    gameList.top = 0

	
	
	

TestCombo = Combo(gameList, 12, 24, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo:AddItems({
ComboValues1[1].text, 
ComboValues1[2].text,
ComboValues1[3].text, 
ComboValues1[4].text,
ComboValues1[5].text, 
ComboValues1[6].text,
ComboValues1[7].text, 
ComboValues1[8].text,
ComboValues1[9].text, 
ComboValues1[10].text,
ComboValues1[11].text, 
ComboValues1[12].text,
ComboValues1[13].text, 
ComboValues1[14].text,
ComboValues1[15].text, 
ComboValues1[16].text,
ComboValues1[17].text, 
ComboValues1[18].text,
ComboValues1[19].text, 
ComboValues1[20].text,
ComboValues1[21].text, 
ComboValues1[22].text,
ComboValues1[23].text, 
ComboValues1[24].text,
})
TestCombo:SetItem(1)
LayoutHelpers.SetWidth(TestCombo, 160)
LayoutHelpers.SetHeight(TestCombo, 20)
if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
LayoutHelpers.AtCenterIn(TestCombo, gameList, -6, -140)
else
LayoutHelpers.AtCenterIn(TestCombo, gameList, 32, -140)
end
LayoutHelpers.DepthOverParent(TestCombo, gameList, 10)

Tooltip.AddControlTooltip(TestCombo, import('/mods/Commander Survival Kit Timeos/lua/AI/CustomAITooltips/CSKTTooltips.lua').TestCombo)

TestCombo1ComboTooltips = import('/mods/Commander Survival Kit Timeos/lua/AI/CustomAITooltips/CSKTTooltips.lua').TestCombo1ComboTooltips
Tooltip.AddComboTooltip(TestCombo, TestCombo1ComboTooltips)

Text = CreateText(gameList)	
Text:SetFont('Arial',11) 
Text:SetColor(factions[armyInfo.armiesTable[focusarmy].faction+1].loadingColor)
Text:SetText(LOC(ComboTitle1 .. ':'))
Text.Depth:Set(30)

LayoutHelpers.DepthOverParent(Text, gameList, 10)

TestCombo2 = Combo(gameList, 12, 24, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo2:AddItems({
ComboValues2[1].text, 
ComboValues2[2].text,
ComboValues2[3].text, 
ComboValues2[4].text,
ComboValues2[5].text, 
ComboValues2[6].text,
ComboValues2[7].text, 
ComboValues2[8].text,
ComboValues2[9].text, 
ComboValues2[10].text,
ComboValues2[11].text, 
ComboValues2[12].text,
ComboValues2[13].text, 
ComboValues2[14].text,
ComboValues2[15].text, 
ComboValues2[16].text,
ComboValues2[17].text, 
ComboValues2[18].text,
ComboValues2[19].text, 
ComboValues2[20].text,
ComboValues2[21].text, 
ComboValues2[22].text,
ComboValues2[23].text, 
ComboValues2[24].text,
})
TestCombo2:SetItem(1)
LayoutHelpers.SetWidth(TestCombo2, 160)
LayoutHelpers.SetHeight(TestCombo2, 20)
if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
LayoutHelpers.AtCenterIn(TestCombo2, gameList, 22, -140)
else
LayoutHelpers.AtCenterIn(TestCombo2, gameList, 62, -140)
end
LayoutHelpers.DepthOverParent(TestCombo2, gameList, 10)

Tooltip.AddControlTooltip(TestCombo2, import('/mods/Commander Survival Kit Timeos/lua/AI/CustomAITooltips/CSKTTooltips.lua').TestCombo2)

TestCombo1ComboTooltips = import('/mods/Commander Survival Kit Timeos/lua/AI/CustomAITooltips/CSKTTooltips.lua').TestCombo1ComboTooltips
Tooltip.AddComboTooltip(TestCombo2, TestCombo1ComboTooltips)

Text2 = CreateText(gameList)	
Text2:SetFont('Arial',11) 
Text2:SetColor(factions[armyInfo.armiesTable[focusarmy].faction+1].loadingColor)
Text2:SetText(LOC(ComboTitle2 .. ':'))
Text2.Depth:Set(30)

LayoutHelpers.DepthOverParent(Text2, gameList, 10)

TestCombo3 = Combo(gameList, 12, 24, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo3:AddItems({
ComboValues3[1].text, 
ComboValues3[2].text,
ComboValues3[3].text, 
ComboValues3[4].text,
ComboValues3[5].text, 
ComboValues3[6].text,
ComboValues3[7].text, 
ComboValues3[8].text,
ComboValues3[9].text, 
ComboValues3[10].text,
ComboValues3[11].text, 
ComboValues3[12].text,
ComboValues3[13].text, 
ComboValues3[14].text,
ComboValues3[15].text, 
ComboValues3[16].text,
ComboValues3[17].text, 
ComboValues3[18].text,
ComboValues3[19].text, 
ComboValues3[20].text,
ComboValues3[21].text, 
ComboValues3[22].text,
ComboValues3[23].text, 
ComboValues3[24].text,
})
TestCombo3:SetItem(1)
LayoutHelpers.SetWidth(TestCombo3, 160)
LayoutHelpers.SetHeight(TestCombo3, 20)
if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
LayoutHelpers.AtCenterIn(TestCombo3, gameList, 52, -140)
else
LayoutHelpers.AtCenterIn(TestCombo3, gameList, 92, -140)
end
LayoutHelpers.DepthOverParent(TestCombo3, gameList, 10)

Tooltip.AddControlTooltip(TestCombo3, import('/mods/Commander Survival Kit Timeos/lua/AI/CustomAITooltips/CSKTTooltips.lua').TestCombo3)

TestCombo1ComboTooltips = import('/mods/Commander Survival Kit Timeos/lua/AI/CustomAITooltips/CSKTTooltips.lua').TestCombo1ComboTooltips
Tooltip.AddComboTooltip(TestCombo3, TestCombo1ComboTooltips)

Text3 = CreateText(gameList)	
Text3:SetFont('Arial',11) 
Text3:SetColor(factions[armyInfo.armiesTable[focusarmy].faction+1].loadingColor)
Text3:SetText(LOC(ComboTitle3 .. ':'))
Text3.Depth:Set(30)

LayoutHelpers.DepthOverParent(Text3, gameList, 10)

if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
TestCombo4 = Combo(gameList, 12, 24, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo4:AddItems({
ComboValues4[1].text, 
ComboValues4[2].text,
ComboValues4[3].text, 
ComboValues4[4].text,
ComboValues4[5].text, 
ComboValues4[6].text,
ComboValues4[7].text, 
ComboValues4[8].text,
ComboValues4[9].text, 
ComboValues4[10].text,
ComboValues4[11].text, 
ComboValues4[12].text,
ComboValues4[13].text, 
ComboValues4[14].text,
ComboValues4[15].text, 
ComboValues4[16].text,
ComboValues4[17].text, 
ComboValues4[18].text,
ComboValues4[19].text, 
ComboValues4[20].text,
ComboValues4[21].text, 
ComboValues4[22].text,
ComboValues4[23].text, 
ComboValues4[24].text,
})
TestCombo4:SetItem(1)
LayoutHelpers.SetWidth(TestCombo4, 160)
LayoutHelpers.SetHeight(TestCombo4, 20)
LayoutHelpers.AtCenterIn(TestCombo4, gameList, 82, -140)
LayoutHelpers.DepthOverParent(TestCombo4, gameList, 10)

Tooltip.AddControlTooltip(TestCombo4, import('/mods/Commander Survival Kit Timeos/lua/AI/CustomAITooltips/CSKTTooltips.lua').TestCombo4)

TestCombo1ComboTooltips = import('/mods/Commander Survival Kit Timeos/lua/AI/CustomAITooltips/CSKTTooltips.lua').TestCombo1ComboTooltips
Tooltip.AddComboTooltip(TestCombo4, TestCombo1ComboTooltips)

Text4 = CreateText(gameList)	
Text4:SetFont('Arial',11) 
Text4:SetColor(factions[armyInfo.armiesTable[focusarmy].faction+1].loadingColor)
Text4:SetText(LOC(ComboTitle4 .. ':'))
Text4.Depth:Set(30)

LayoutHelpers.DepthOverParent(Text4, gameList, 10)

TestCombo5 = Combo(gameList, 12, 24, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo5:AddItems({
ComboValues5[1].text, 
ComboValues5[2].text,
ComboValues5[3].text, 
ComboValues5[4].text,
ComboValues5[5].text, 
ComboValues5[6].text,
ComboValues5[7].text, 
ComboValues5[8].text,
ComboValues5[9].text, 
ComboValues5[10].text,
ComboValues5[11].text, 
ComboValues5[12].text,
ComboValues5[13].text, 
ComboValues5[14].text,
ComboValues5[15].text, 
ComboValues5[16].text,
ComboValues5[17].text, 
ComboValues5[18].text,
ComboValues5[19].text, 
ComboValues5[20].text,
ComboValues5[21].text, 
ComboValues5[22].text,
ComboValues5[23].text, 
ComboValues5[24].text,
})
TestCombo5:SetItem(1)
LayoutHelpers.SetWidth(TestCombo5, 160)
LayoutHelpers.SetHeight(TestCombo5, 20)
LayoutHelpers.AtCenterIn(TestCombo5, gameList, 112, -140)
LayoutHelpers.DepthOverParent(TestCombo5, gameList, 10)

Tooltip.AddControlTooltip(TestCombo5, import('/mods/Commander Survival Kit Timeos/lua/AI/CustomAITooltips/CSKTTooltips.lua').TestCombo5)

TestCombo1ComboTooltips = import('/mods/Commander Survival Kit Timeos/lua/AI/CustomAITooltips/CSKTTooltips.lua').TestCombo1ComboTooltips
Tooltip.AddComboTooltip(TestCombo5, TestCombo1ComboTooltips)

Text5 = CreateText(gameList)	
Text5:SetFont('Arial',11) 
Text5:SetColor(factions[armyInfo.armiesTable[focusarmy].faction+1].loadingColor)
Text5:SetText(LOC(ComboTitle5 .. ':'))
Text5.Depth:Set(30)

LayoutHelpers.DepthOverParent(Text5, gameList, 10)

TestCombo6 = Combo(gameList, 12, 24, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
TestCombo6:AddItems({
ComboValues6[1].text, 
ComboValues6[2].text,
ComboValues6[3].text, 
ComboValues6[4].text,
ComboValues6[5].text, 
ComboValues6[6].text,
ComboValues6[7].text, 
ComboValues6[8].text,
ComboValues6[9].text, 
ComboValues6[10].text,
ComboValues6[11].text, 
ComboValues6[12].text,
ComboValues6[13].text, 
ComboValues6[14].text,
ComboValues6[15].text, 
ComboValues6[16].text,
ComboValues6[17].text, 
ComboValues6[18].text,
ComboValues6[19].text, 
ComboValues6[20].text,
ComboValues6[21].text, 
ComboValues6[22].text,
ComboValues6[23].text, 
ComboValues6[24].text,
})
TestCombo6:SetItem(1)
LayoutHelpers.SetWidth(TestCombo6, 160)
LayoutHelpers.SetHeight(TestCombo6, 20)
LayoutHelpers.AtCenterIn(TestCombo6, gameList, 142, -140)
LayoutHelpers.DepthOverParent(TestCombo6, gameList, 10)

Tooltip.AddControlTooltip(TestCombo6, import('/mods/Commander Survival Kit Timeos/lua/AI/CustomAITooltips/CSKTTooltips.lua').TestCombo6)

TestCombo1ComboTooltips = import('/mods/Commander Survival Kit Timeos/lua/AI/CustomAITooltips/CSKTTooltips.lua').TestCombo1ComboTooltips
Tooltip.AddComboTooltip(TestCombo6, TestCombo1ComboTooltips)

Text6 = CreateText(gameList)	
Text6:SetFont('Arial',11) 
Text6:SetColor(factions[armyInfo.armiesTable[focusarmy].faction+1].loadingColor)
Text6:SetText(LOC(ComboTitle6 .. ':'))
Text6.Depth:Set(30)

LayoutHelpers.DepthOverParent(Text6, gameList, 10)

else

end


--[[
-----------
Legend:
-----------

Supported Languages:

US: English
DE: German


Text:  	Drop Turrets
Text2: 	Land Reinforcements
Text3: 	Air Reinforcements
Text4:  Naval Reinforcements
Text5: 	Air Strikes
Text6: 	Air Strike Mechanic


]]--


if __language == 'DE' then

if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
LayoutHelpers.AtCenterIn(Text, gameList, -8, -329) 
LayoutHelpers.AtCenterIn(Text2, gameList, 20, -329) 
LayoutHelpers.AtCenterIn(Text3, gameList, 50, -310) 
LayoutHelpers.AtCenterIn(Text4, gameList, 80, -335) 
LayoutHelpers.AtCenterIn(Text5, gameList, 110, -328) 
LayoutHelpers.AtCenterIn(Text6, gameList, 140, -328) 
else
LayoutHelpers.AtCenterIn(Text, gameList, 30, -329) 
LayoutHelpers.AtCenterIn(Text2, gameList, 60, -329) 
LayoutHelpers.AtCenterIn(Text3, gameList, 90, -310) 
end

else

if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
LayoutHelpers.AtCenterIn(Text, gameList, -8, -329) 
LayoutHelpers.AtCenterIn(Text2, gameList, 20, -329) 
LayoutHelpers.AtCenterIn(Text3, gameList, 50, -310) 
LayoutHelpers.AtCenterIn(Text4, gameList, 80, -335) 
LayoutHelpers.AtCenterIn(Text5, gameList, 110, -328) 
LayoutHelpers.AtCenterIn(Text6, gameList, 140, -328) 
else
LayoutHelpers.AtCenterIn(Text, gameList, 30, -329) 
LayoutHelpers.AtCenterIn(Text2, gameList, 60, -329) 
LayoutHelpers.AtCenterIn(Text3, gameList, 90, -310) 
end

end


local savebutton
local loadbutton
local donebutton

if focusarmy >= 1 then
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
		savebutton = UIUtil.CreateButtonStd(gameList, '/mods/Commander Survival Kit Timeos/textures/medium-aeon_btn/medium-aeon', "<LOC Save>Save", 11, 0, 0)
		loadbutton = UIUtil.CreateButtonStd(gameList, '/mods/Commander Survival Kit Timeos/textures/medium-aeon_btn/medium-aeon', "<LOC Load>Load", 11, 0, 0)
		donebutton = UIUtil.CreateButtonStd(gameList, '/mods/Commander Survival Kit Timeos/textures/medium-aeon_btn/medium-aeon', "<LOC Done>Done", 11, 0, 0)	
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		savebutton = UIUtil.CreateButtonStd(gameList, '/mods/Commander Survival Kit Timeos/textures/medium-cybran_btn/medium-cybran', "<LOC Save>Save", 11, 0, 0)
		loadbutton = UIUtil.CreateButtonStd(gameList, '/mods/Commander Survival Kit Timeos/textures/medium-cybran_btn/medium-cybran', "<LOC Load>Load", 11, 0, 0)
		donebutton = UIUtil.CreateButtonStd(gameList, '/mods/Commander Survival Kit Timeos/textures/medium-cybran_btn/medium-cybran', "<LOC Done>Done", 11, 0, 0)	
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		savebutton = UIUtil.CreateButtonStd(gameList, '/mods/Commander Survival Kit Timeos/textures/medium-uef_btn/medium-uef', "<LOC Save>Save", 11, 0, 0)
		loadbutton = UIUtil.CreateButtonStd(gameList, '/mods/Commander Survival Kit Timeos/textures/medium-uef_btn/medium-uef', "<LOC Load>Load", 11, 0, 0)
		donebutton = UIUtil.CreateButtonStd(gameList, '/mods/Commander Survival Kit Timeos/textures/medium-uef_btn/medium-uef', "<LOC Done>Done", 11, 0, 0)	
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		savebutton = UIUtil.CreateButtonStd(gameList, '/mods/Commander Survival Kit Timeos/textures/medium-seraphim_btn/medium-seraphim', "<LOC Save>Save", 11, 0, 0)
		loadbutton = UIUtil.CreateButtonStd(gameList, '/mods/Commander Survival Kit Timeos/textures/medium-seraphim_btn/medium-seraphim', "<LOC Load>Load", 11, 0, 0)
		donebutton = UIUtil.CreateButtonStd(gameList, '/mods/Commander Survival Kit Timeos/textures/medium-seraphim_btn/medium-seraphim', "<LOC Done>Done", 11, 0, 0)
	end
end

Tooltip.AddButtonTooltip(savebutton, "SaveBtn", 1)
Tooltip.AddButtonTooltip(loadbutton, "LoadBtn", 1)
Tooltip.AddButtonTooltip(donebutton, "DoneBtn", 1)




savebutton.OnClick = function(self)
if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
SaveArray[1] = TestCombo:GetItem()
SaveArray[2] = TestCombo2:GetItem()
SaveArray[3] = TestCombo3:GetItem()
SaveArray[4] = TestCombo4:GetItem()
SaveArray[5] = TestCombo5:GetItem()
SaveArray[6] = TestCombo6:GetItem()
else
SaveArray[1] = TestCombo:GetItem()
SaveArray[2] = TestCombo2:GetItem()
SaveArray[3] = TestCombo3:GetItem()
end
LoadPreviousSavedOptions(false, nil)
Sync.TransferSaveArray = SaveArray
end

loadbutton.OnClick = function(self)
if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
TestCombo:SetItem(LoadArray[1])
TestCombo2:SetItem(LoadArray[2])
TestCombo3:SetItem(LoadArray[3])
TestCombo4:SetItem(LoadArray[4])
TestCombo5:SetItem(LoadArray[5])
TestCombo6:SetItem(LoadArray[6])
else
TestCombo:SetItem(LoadArray[1])
TestCombo2:SetItem(LoadArray[2])
TestCombo3:SetItem(LoadArray[3])
end
end

donebutton.OnClick = function(self)

if CSKPath then

GetCursor():Show()
CampaignOptionWindow:Hide()
UIUtil.MakeInputModal(GetFrame(0))

else

if import('/lua/ui/game/gamemain.lua').IsNISMode() == true then
if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
CheckT2WaitTime(TestCombo:GetItem())
CheckT3WaitTime(TestCombo2:GetItem())
CheckEXPWaitTime(TestCombo3:GetItem())
CheckEliteWaitTime(TestCombo4:GetItem())
CheckHeroWaitTime(TestCombo5:GetItem())
CheckTitanWaitTime(TestCombo6:GetItem())
else
CheckT2WaitTime(TestCombo:GetItem())
CheckT3WaitTime(TestCombo2:GetItem())
CheckEXPWaitTime(TestCombo3:GetItem())
end
GetCursor():Show()
CampaignOptionWindow:Hide()
UIUtil.MakeInputModal(GetFrame(0))
ForkThread(function()
SessionResume()
WaitSeconds(0.5)
SessionRequestPause()
end)
else
if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
CheckT2WaitTime(TestCombo:GetItem())
CheckT3WaitTime(TestCombo2:GetItem())
CheckEXPWaitTime(TestCombo3:GetItem())
CheckEliteWaitTime(TestCombo4:GetItem())
CheckHeroWaitTime(TestCombo5:GetItem())
CheckTitanWaitTime(TestCombo6:GetItem())
else
CheckT2WaitTime(TestCombo:GetItem())
CheckT3WaitTime(TestCombo2:GetItem())
CheckEXPWaitTime(TestCombo3:GetItem())
end
CampaignOptionWindow:Hide()
UIUtil.MakeInputModal(GetFrame(0))
SessionResume()
end

end

--import('/mods/Commander Survival Kit Timeos/UI/MainPanel.lua').GetRefCampaignOptions(SaveArray)
--CheckforPointStoragesIncluded(TestCombo7:GetItem())

end


LayoutHelpers.SetWidth(savebutton, 200)
LayoutHelpers.SetHeight(savebutton, 80)
LayoutHelpers.AtCenterIn(savebutton, gameList, 10, 70)
LayoutHelpers.DepthOverParent(savebutton, gameList, 10)
LayoutHelpers.SetWidth(loadbutton, 200)
LayoutHelpers.SetHeight(loadbutton, 80)
LayoutHelpers.AtCenterIn(loadbutton, gameList, 60, 70)
LayoutHelpers.DepthOverParent(loadbutton, gameList, 10)
LayoutHelpers.SetWidth(donebutton, 200)
LayoutHelpers.SetHeight(donebutton, 80)
LayoutHelpers.AtCenterIn(donebutton, gameList, 110, 70)
LayoutHelpers.DepthOverParent(donebutton, gameList, 10)

ForkThread(
	function()
		if Gametype == 'campaign' then
		if CSKPath then
		
		else
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
	end
)	


TransferData = function()
LOG('Transfer')
if CSKUnitsPath or FBPOrbitalPath or CSKUnitsPath and FBPOrbitalPath then
ForkThread(function()
WaitSeconds(1)
CheckT2WaitTime(TestCombo:GetItem())
CheckT3WaitTime(TestCombo2:GetItem())
CheckEXPWaitTime(TestCombo3:GetItem())
CheckEliteWaitTime(TestCombo4:GetItem())
CheckHeroWaitTime(TestCombo5:GetItem())
CheckTitanWaitTime(TestCombo6:GetItem())
end)
else
ForkThread(function()
WaitSeconds(1)
CheckT2WaitTime(TestCombo:GetItem())
CheckT3WaitTime(TestCombo2:GetItem())
CheckEXPWaitTime(TestCombo3:GetItem())
end)
end
end

ShowManager = function()
CampaignOptionWindow:Show()
CampaignOptionWindow._closeBtn:Hide()
CampaignOptionWindow:SetTitle('<LOC CSKTimeosOptions>CSK: Timeos - Options')
UIUtil.MakeInputModal(CampaignOptionWindow)
LayoutHelpers.AtCenterIn(Main, GetFrame(0), 280, 0)
end

HideButtons = function()
savebutton:Hide()
loadbutton:Hide()
LayoutHelpers.AtCenterIn(donebutton, gameList, 60, 70)
end


CheckT2WaitTime = function(value)	
local SendValue = 0

-- 5 Minutes
if value == 1 then
SendValue = 300
end

-- 10 Minutes
if value == 2 then
SendValue = 600
end

-- 15 Minutes
if value == 3 then
SendValue = 900
end

-- 20 Minutes
if value == 4 then
SendValue = 1200
end

-- 25 Minutes
if value == 5 then
SendValue = 1500
end

-- 30 Minutes
if value == 6 then
SendValue = 1800
end

-- 35 Minutes
if value == 7 then
SendValue = 2100
end

-- 40 Minutes
if value == 8 then
SendValue = 2400
end

-- 45 Minutes
if value == 9 then
SendValue = 2700
end

-- 50 Minutes
if value == 10 then
SendValue = 3000
end

-- 55 Minutes
if value == 11 then
SendValue = 3300
end

-- 1 Hour
if value == 12 then
SendValue = 3600
end

-- 1 Hour 5 Minutes
if value == 13 then
SendValue = 3900
end

-- 1 Hour 10 Minutes
if value == 13 then
SendValue = 4200
end

-- 1 Hour 15 Minutes
if value == 14 then
SendValue = 4500
end

-- 1 Hour 20 Minutes
if value == 15 then
SendValue = 4800
end

-- 1 Hour 25 Minutes
if value == 16 then
SendValue = 5100
end

-- 1 Hour 30 Minutes
if value == 17 then
SendValue = 5400
end

-- 1 Hour 35 Minutes
if value == 18 then
SendValue = 5700
end

-- 1 Hour 40 Minutes
if value == 19 then
SendValue = 6000
end

-- 1 Hour 45 Minutes
if value == 20 then
SendValue = 6300
end

-- 1 Hour 50 Minutes
if value == 21 then
SendValue = 6600
end

-- 1 Hour 55 Minutes
if value == 22 then
SendValue = 6900
end

-- 2 Hours
if value == 23 then
SendValue = 7200
end


    data = {
        From = GetFocusArmy(),
        To = -1,
        Name = "CheckforT2WaitTime",
        Args = {selection = SendValue }
    }
    local QueryCb = function() end
    import('/lua/UserPlayerQuery.lua').Query( data, QueryCb) 

end

CheckT3WaitTime = function(value)	

local SendValue = 0

-- 5 Minutes
if value == 1 then
SendValue = 300
end

-- 10 Minutes
if value == 2 then
SendValue = 600
end

-- 15 Minutes
if value == 3 then
SendValue = 900
end

-- 20 Minutes
if value == 4 then
SendValue = 1200
end

-- 25 Minutes
if value == 5 then
SendValue = 1500
end

-- 30 Minutes
if value == 6 then
SendValue = 1800
end

-- 35 Minutes
if value == 7 then
SendValue = 2100
end

-- 40 Minutes
if value == 8 then
SendValue = 2400
end

-- 45 Minutes
if value == 9 then
SendValue = 2700
end

-- 50 Minutes
if value == 10 then
SendValue = 3000
end

-- 55 Minutes
if value == 11 then
SendValue = 3300
end

-- 1 Hour
if value == 12 then
SendValue = 3600
end

-- 1 Hour 5 Minutes
if value == 13 then
SendValue = 3900
end

-- 1 Hour 10 Minutes
if value == 13 then
SendValue = 4200
end

-- 1 Hour 15 Minutes
if value == 14 then
SendValue = 4500
end

-- 1 Hour 20 Minutes
if value == 15 then
SendValue = 4800
end

-- 1 Hour 25 Minutes
if value == 16 then
SendValue = 5100
end

-- 1 Hour 30 Minutes
if value == 17 then
SendValue = 5400
end

-- 1 Hour 35 Minutes
if value == 18 then
SendValue = 5700
end

-- 1 Hour 40 Minutes
if value == 19 then
SendValue = 6000
end

-- 1 Hour 45 Minutes
if value == 20 then
SendValue = 6300
end

-- 1 Hour 50 Minutes
if value == 21 then
SendValue = 6600
end

-- 1 Hour 55 Minutes
if value == 22 then
SendValue = 6900
end

-- 2 Hours
if value == 23 then
SendValue = 7200
end

    data = {
        From = GetFocusArmy(),
        To = -1,
        Name = "CheckforT3WaitTime",
        Args = {selection = SendValue }
    }
    local QueryCb = function() end
    import('/lua/UserPlayerQuery.lua').Query( data, QueryCb) 

end

CheckEXPWaitTime = function(value)	

local SendValue = 0

-- 5 Minutes
if value == 1 then
SendValue = 300
end

-- 10 Minutes
if value == 2 then
SendValue = 600
end

-- 15 Minutes
if value == 3 then
SendValue = 900
end

-- 20 Minutes
if value == 4 then
SendValue = 1200
end

-- 25 Minutes
if value == 5 then
SendValue = 1500
end

-- 30 Minutes
if value == 6 then
SendValue = 1800
end

-- 35 Minutes
if value == 7 then
SendValue = 2100
end

-- 40 Minutes
if value == 8 then
SendValue = 2400
end

-- 45 Minutes
if value == 9 then
SendValue = 2700
end

-- 50 Minutes
if value == 10 then
SendValue = 3000
end

-- 55 Minutes
if value == 11 then
SendValue = 3300
end

-- 1 Hour
if value == 12 then
SendValue = 3600
end

-- 1 Hour 5 Minutes
if value == 13 then
SendValue = 3900
end

-- 1 Hour 10 Minutes
if value == 13 then
SendValue = 4200
end

-- 1 Hour 15 Minutes
if value == 14 then
SendValue = 4500
end

-- 1 Hour 20 Minutes
if value == 15 then
SendValue = 4800
end

-- 1 Hour 25 Minutes
if value == 16 then
SendValue = 5100
end

-- 1 Hour 30 Minutes
if value == 17 then
SendValue = 5400
end

-- 1 Hour 35 Minutes
if value == 18 then
SendValue = 5700
end

-- 1 Hour 40 Minutes
if value == 19 then
SendValue = 6000
end

-- 1 Hour 45 Minutes
if value == 20 then
SendValue = 6300
end

-- 1 Hour 50 Minutes
if value == 21 then
SendValue = 6600
end

-- 1 Hour 55 Minutes
if value == 22 then
SendValue = 6900
end

-- 2 Hours
if value == 23 then
SendValue = 7200
end

    data = {
        From = GetFocusArmy(),
        To = -1,
        Name = "CheckforEXPWaitTime",
        Args = {selection = SendValue }
    }
    local QueryCb = function() end
    import('/lua/UserPlayerQuery.lua').Query( data, QueryCb) 

end

CheckEliteWaitTime = function(value)	

local SendValue = 0

-- 5 Minutes
if value == 1 then
SendValue = 300
end

-- 10 Minutes
if value == 2 then
SendValue = 600
end

-- 15 Minutes
if value == 3 then
SendValue = 900
end

-- 20 Minutes
if value == 4 then
SendValue = 1200
end

-- 25 Minutes
if value == 5 then
SendValue = 1500
end

-- 30 Minutes
if value == 6 then
SendValue = 1800
end

-- 35 Minutes
if value == 7 then
SendValue = 2100
end

-- 40 Minutes
if value == 8 then
SendValue = 2400
end

-- 45 Minutes
if value == 9 then
SendValue = 2700
end

-- 50 Minutes
if value == 10 then
SendValue = 3000
end

-- 55 Minutes
if value == 11 then
SendValue = 3300
end

-- 1 Hour
if value == 12 then
SendValue = 3600
end

-- 1 Hour 5 Minutes
if value == 13 then
SendValue = 3900
end

-- 1 Hour 10 Minutes
if value == 13 then
SendValue = 4200
end

-- 1 Hour 15 Minutes
if value == 14 then
SendValue = 4500
end

-- 1 Hour 20 Minutes
if value == 15 then
SendValue = 4800
end

-- 1 Hour 25 Minutes
if value == 16 then
SendValue = 5100
end

-- 1 Hour 30 Minutes
if value == 17 then
SendValue = 5400
end

-- 1 Hour 35 Minutes
if value == 18 then
SendValue = 5700
end

-- 1 Hour 40 Minutes
if value == 19 then
SendValue = 6000
end

-- 1 Hour 45 Minutes
if value == 20 then
SendValue = 6300
end

-- 1 Hour 50 Minutes
if value == 21 then
SendValue = 6600
end

-- 1 Hour 55 Minutes
if value == 22 then
SendValue = 6900
end

-- 2 Hours
if value == 23 then
SendValue = 7200
end

    data = {
        From = GetFocusArmy(),
        To = -1,
        Name = "CheckforEliteWaitTime",
        Args = {selection = SendValue }
    }
    local QueryCb = function() end
    import('/lua/UserPlayerQuery.lua').Query( data, QueryCb) 

end

CheckHeroWaitTime = function(value)	

local SendValue = 0

-- 5 Minutes
if value == 1 then
SendValue = 300
end

-- 10 Minutes
if value == 2 then
SendValue = 600
end

-- 15 Minutes
if value == 3 then
SendValue = 900
end

-- 20 Minutes
if value == 4 then
SendValue = 1200
end

-- 25 Minutes
if value == 5 then
SendValue = 1500
end

-- 30 Minutes
if value == 6 then
SendValue = 1800
end

-- 35 Minutes
if value == 7 then
SendValue = 2100
end

-- 40 Minutes
if value == 8 then
SendValue = 2400
end

-- 45 Minutes
if value == 9 then
SendValue = 2700
end

-- 50 Minutes
if value == 10 then
SendValue = 3000
end

-- 55 Minutes
if value == 11 then
SendValue = 3300
end

-- 1 Hour
if value == 12 then
SendValue = 3600
end

-- 1 Hour 5 Minutes
if value == 13 then
SendValue = 3900
end

-- 1 Hour 10 Minutes
if value == 13 then
SendValue = 4200
end

-- 1 Hour 15 Minutes
if value == 14 then
SendValue = 4500
end

-- 1 Hour 20 Minutes
if value == 15 then
SendValue = 4800
end

-- 1 Hour 25 Minutes
if value == 16 then
SendValue = 5100
end

-- 1 Hour 30 Minutes
if value == 17 then
SendValue = 5400
end

-- 1 Hour 35 Minutes
if value == 18 then
SendValue = 5700
end

-- 1 Hour 40 Minutes
if value == 19 then
SendValue = 6000
end

-- 1 Hour 45 Minutes
if value == 20 then
SendValue = 6300
end

-- 1 Hour 50 Minutes
if value == 21 then
SendValue = 6600
end

-- 1 Hour 55 Minutes
if value == 22 then
SendValue = 6900
end

-- 2 Hours
if value == 23 then
SendValue = 7200
end

    data = {
        From = GetFocusArmy(),
        To = -1,
        Name = "CheckforHeroWaitTime",
        Args = {selection = SendValue }
    }
    local QueryCb = function() end
    import('/lua/UserPlayerQuery.lua').Query( data, QueryCb) 

end

CheckTitanWaitTime = function(value)	

local SendValue = 0

-- 5 Minutes
if value == 1 then
SendValue = 300
end

-- 10 Minutes
if value == 2 then
SendValue = 600
end

-- 15 Minutes
if value == 3 then
SendValue = 900
end

-- 20 Minutes
if value == 4 then
SendValue = 1200
end

-- 25 Minutes
if value == 5 then
SendValue = 1500
end

-- 30 Minutes
if value == 6 then
SendValue = 1800
end

-- 35 Minutes
if value == 7 then
SendValue = 2100
end

-- 40 Minutes
if value == 8 then
SendValue = 2400
end

-- 45 Minutes
if value == 9 then
SendValue = 2700
end

-- 50 Minutes
if value == 10 then
SendValue = 3000
end

-- 55 Minutes
if value == 11 then
SendValue = 3300
end

-- 1 Hour
if value == 12 then
SendValue = 3600
end

-- 1 Hour 5 Minutes
if value == 13 then
SendValue = 3900
end

-- 1 Hour 10 Minutes
if value == 13 then
SendValue = 4200
end

-- 1 Hour 15 Minutes
if value == 14 then
SendValue = 4500
end

-- 1 Hour 20 Minutes
if value == 15 then
SendValue = 4800
end

-- 1 Hour 25 Minutes
if value == 16 then
SendValue = 5100
end

-- 1 Hour 30 Minutes
if value == 17 then
SendValue = 5400
end

-- 1 Hour 35 Minutes
if value == 18 then
SendValue = 5700
end

-- 1 Hour 40 Minutes
if value == 19 then
SendValue = 6000
end

-- 1 Hour 45 Minutes
if value == 20 then
SendValue = 6300
end

-- 1 Hour 50 Minutes
if value == 21 then
SendValue = 6600
end

-- 1 Hour 55 Minutes
if value == 22 then
SendValue = 6900
end

-- 2 Hours
if value == 23 then
SendValue = 7200
end

    data = {
        From = GetFocusArmy(),
        To = -1,
        Name = "CheckforTitanWaitTime",
        Args = {selection = SendValue }
    }
    local QueryCb = function() end
    import('/lua/UserPlayerQuery.lua').Query( data, QueryCb) 

end




