----directory----
local path = '/mods/Commander Survival Kit/UI/'


local helpcenter = import(path .. 'Helpcenter.lua').UI
local RefUI = import(path .. 'Helpcenter.lua').RefUI
local FSUI = import(path .. 'Helpcenter.lua').FSUI
local FSUI2 = import(path .. 'Helpcenter.lua').FSUI2
local MovieUI = import(path .. 'HelpcenterMovie.lua').UI


local Tooltip = import("/lua/ui/game/tooltip.lua")

----significant operators imported from external sources----
local CreateText = import('/lua/maui/text.lua').Text 
local CreateWindow = import('/lua/maui/window.lua').Window
local UIUtil = import('/lua/ui/uiutil.lua')
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local LayoutHelpers = import("/lua/maui/layouthelpers.lua")
local factions = import('/lua/factions.lua').Factions
local Combo = import("/lua/ui/controls/combo.lua").Combo
local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	
local ExAirStrikesInclude = SessionGetScenarioInfo().Options.EXAirStrikesInclude
local Gametype = SessionGetScenarioInfo().type
local FireSupportCampaignOptions = {}

function GetFireSupportCampaignOptions(Array)
FireSupportCampaignOptions = Array
end


ForkThread(
	function()
if Gametype == 'campaign' then
while true do
if FireSupportCampaignOptions == nil then

else

if FireSupportCampaignOptions[20] == 1 then
ExAirStrikesInclude = 1
break
elseif FireSupportCampaignOptions[20] == 2 then
ExAirStrikesInclude = 2
break
else

end
end
WaitSeconds(0.1)
end
end
end
)


----parameters----
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
	
local Position = {
	Left = 20, 
	Top = 220, 
	Bottom = 320, 
	Right = 335
}

local TextPosition = {
	Left = 40, 
	Top = 250, 
	Bottom = 270, 
	Right = 240
}

local TextPosition2 = {
	Left = 40, 
	Top = 271, 
	Bottom = 291, 
	Right = 240
}


local ButtonPosition = {
	Left = 255, 
	Top = 245, 
	Bottom = 295, 
	Right = 325
}

local FWBTNPosition = {
	Left = 290, 
	Top = 223, 
	Bottom = 243, 
	Right = 310
} 


local BBTNPosition = {
	Left = 270, 
	Top = 223, 
	Bottom = 243, 
	Right = 290
} 

   
----actions----
UI = CreateWindow(GetFrame(0),'Fire Support Manager',nil,false,false,true,true,'Reinforcements',Position,Border) 

Text = CreateText(UI)
Text2 = CreateText(UI)
UI._closeBtn:Hide()


for k,v in TextPosition2 do
	Text2[k]:Set(v)
end
for k,v in TextPosition do
	Text[k]:Set(v)
end
Text:SetFont('Arial',13) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('ffFFFFFF')
--('To play with this mod , you should keep in mind the followings : \n 1. Click the close button to get the unit list . \n 2.Select a number of engineers/ACU/SACUs to get the access to the construction queue . \n 3.Press Shift and then click an icon to add a building-command to the current queue . \n 4.Simply clicking the icon will stop the engineers from any current activities and force them to execute the building-command \n 5.Eventually , you should choose and right click a spare place')
Text.Depth:Set(30)
Text2:SetFont('Arial',13) --Oh well . You must have font and larger depth otherwise text would not come out
Text2:SetColor('ffFFFFFF')
--('To play with this mod , you should keep in mind the followings : \n 1. Click the close button to get the unit list . \n 2.Select a number of engineers/ACU/SACUs to get the access to the construction queue . \n 3.Press Shift and then click an icon to add a building-command to the current queue . \n 4.Simply clicking the icon will stop the engineers from any current activities and force them to execute the building-command \n 5.Eventually , you should choose and right click a spare place')
Text2.Depth:Set(30)



local button
local ForwardButton
local BackButton

if focusarmy >= 1 then
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
		button = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/medium-aeon', "Help", 11, -8, -64)
		ForwardButton = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/aeon_fw_btn/aeon_fw', nil, 11)
		BackButton = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/aeon_bb_btn/aeon_bb', nil, 11)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		button = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/medium-cybran', "Help", 11, -8, -64)
		ForwardButton = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/cybran_fw_btn/cybran_fw', nil, 11)
		BackButton = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/cybran_bb_btn/cybran_bb', nil, 11)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		button = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/medium-uef_btn/medium-uef', "Help", 11, -8, -64)
		ForwardButton = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/uef_fw_btn/uef_fw', nil, 11)
		BackButton = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/uef_bb_btn/uef_bb', nil, 11)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		button = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/medium-seraphim', "Help", 11, -8, -64)
		ForwardButton = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/sera_fw_btn/sera_fw', nil, 11)
		BackButton = UIUtil.CreateButtonStd(UI, '/mods/Commander Survival Kit/textures/sera_bb_btn/sera_bb', nil, 11)
	end
end

local fsforwardbuttonpress = 0
local fsbackbuttonpress = 0
local buttonpress = 1
 
function Gethelpbuttonpress(Value)
buttonpress = Value
end
 
function Getfwbuttonpress(Value)
fsforwardbuttonpress = Value
LOG('fsforwardbuttonpress: ', fsforwardbuttonpress)
end

function Getbbbuttonpress(Value)
fsbackbuttonpress = Value
LOG('fsbackbuttonpress: ', fsbackbuttonpress)
end

LayoutHelpers.SetDimensions(ForwardButton, 10, 10)
LayoutHelpers.SetDimensions(BackButton, 10, 10)


local asfwbuttonpress = 0
local asbbbuttonpress = 0
local artfwbuttonpress = 0
local artbbbuttonpress = 0
local mfwbuttonpress = 0
local mbbuttonpress = 0
local bfwbuttonpress = 0
local bbbbuttonpress = 0
local spfwbuttonpress = 0
local spbbbuttonpress = 0
	
function Getasbuttonpress(Value1, Value2)
asfwbuttonpress = Value1
asbbbuttonpress = Value2
LOG('asfwbuttonpress: ', asfwbuttonpress)
LOG('asbbbuttonpress: ', asbbbuttonpress)
end	

function Getartbuttonpress(Value1, Value2)
artfwbuttonpress = Value1
artbbbuttonpress = Value2
LOG('artfwbuttonpress: ', artfwbuttonpress)
LOG('artbbbuttonpress: ', artbbbuttonpress)
end	

function Getmbuttonpress(Value1, Value2)
mfwbuttonpress = Value1
mbbuttonpress = Value2
LOG('mfwbuttonpress: ', mfwbuttonpress)
LOG('mbbuttonpress: ', mbbuttonpress)
end	

function Getbbuttonpress(Value1, Value2)
bfwbuttonpress = Value1
bbbbuttonpress = Value2
LOG('bfwbuttonpress: ', bfwbuttonpress)
LOG('bbbbuttonpress: ', bbbbuttonpress)
end	


function Getspbuttonpress(Value1, Value2)
spfwbuttonpress = Value1
spbbbuttonpress = Value2
LOG('spfwbuttonpress: ', spfwbuttonpress)
LOG('spbbbuttonpress: ', spbbbuttonpress)
end	


ForwardButton.OnClick = function(self)
		fsforwardbuttonpress = fsforwardbuttonpress + 1
		if fsforwardbuttonpress == 1 then
		import(path .. 'FireSupportManager.lua').FSASUI:Hide()
		import(path .. 'FireSupportManager.lua').FSUI:Show()
		import(path .. 'FireSupportManager.lua').FSUI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FS1UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FS2UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FS3UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSUI._closeBtn:Hide()
		if artfwbuttonpress == 4 and artbbbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS2UI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS3UI:Hide()
		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS2UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS2UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS3UI._closeBtn:Hide()
		end
		fsbackbuttonpress = 4
		end
		if fsforwardbuttonpress == 2 then
		import(path .. 'FireSupportManager.lua').FSUI:Hide()
		import(path .. 'FireSupportManager.lua').FSMissileUI:Show()
		import(path .. 'FireSupportManager.lua').FSMissileUI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FS1MissileUI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FS2MissileUI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FS3MissileUI._closeBtn:Hide()
		if mfwbuttonpress == 1 and mbbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS3MissileUI:Hide()
		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS3MissileUI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS3MissileUI._closeBtn:Hide()
		end
		fsbackbuttonpress = 3
		end
		if fsforwardbuttonpress == 3 then
		import(path .. 'FireSupportManager.lua').FSMissileUI:Hide()
		import(path .. 'FireSupportManager.lua').FSBUI:Show()
		import(path .. 'FireSupportManager.lua').FSBUI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSB1UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSB2UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSB3UI._closeBtn:Hide()
		if focusarmy >= 1 then
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		if bfwbuttonpress == 1 and bbbbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB2UI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB3UI:Hide()
		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB2UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB2UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB3UI._closeBtn:Hide()
		end
		else
		if bfwbuttonpress == 1 and bbbbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB3UI:Hide()
		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB3UI._closeBtn:Hide()
		end
		end
		end
		fsbackbuttonpress = 2
		end
		if fsforwardbuttonpress == 4 then
		import(path .. 'FireSupportManager.lua').FSBUI:Hide()
		import(path .. 'FireSupportManager.lua').FSSPUI:Show()
		import(path .. 'FireSupportManager.lua').FSSPUI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSSP1UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSSP2UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSSP3UI._closeBtn:Hide()
		if focusarmy >= 1 then
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').spfwbutton:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').spbbbutton:Hide()
		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').spfwbutton:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').spbbbutton:Show()
		end
		end
		if spfwbuttonpress == 1 and spbbbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSSP3UI:Hide()
		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSSP3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSSP3UI._closeBtn:Hide()
		end
		fsbackbuttonpress = 1
		end
		if fsforwardbuttonpress == 5 then
		import(path .. 'FireSupportManager.lua').FSSPUI:Hide()
		import(path .. 'FireSupportManager.lua').FSASUI:Show()
		import(path .. 'FireSupportManager.lua').FSASUI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSAS1UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSAS2UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSAS3UI._closeBtn:Hide()
		if focusarmy >= 1 then
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
		if asfwbuttonpress == 1 and asbbbuttonpress == 2 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		elseif asfwbuttonpress == 2 and asbbbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		if ExAirStrikesInclude == 1 then

		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Hide()
		end
		elseif asfwbuttonpress == 0 and asbbbuttonpress == 0 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		end
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		if asfwbuttonpress == 1 and asbbbuttonpress == 2 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		elseif asfwbuttonpress == 2 and asbbbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		if ExAirStrikesInclude == 1 then

		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Hide()
		end
		elseif asfwbuttonpress == 0 and asbbbuttonpress == 0 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		end
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		if asfwbuttonpress == 1 and asbbbuttonpress == 3 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		elseif asfwbuttonpress == 2 and asbbbuttonpress == 2 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		elseif asfwbuttonpress == 3 and asbbbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		if ExAirStrikesInclude == 1 then

		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS2UI:Hide()
		end
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Hide()
		elseif asfwbuttonpress == 0 and asbbbuttonpress == 0 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS2UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS2UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		end
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		if asfwbuttonpress == 1 and asbbbuttonpress == 2 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		elseif asfwbuttonpress == 2 and asbbbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		if ExAirStrikesInclude == 1 then

		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Hide()
		end
		elseif asfwbuttonpress == 0 and asbbbuttonpress == 0 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		end
		end
		end
		fsforwardbuttonpress = 0
		fsbackbuttonpress = 0
		end
end



BackButton.OnClick = function(self)
		fsbackbuttonpress = fsbackbuttonpress + 1
		if fsbackbuttonpress == 1 then
		import(path .. 'FireSupportManager.lua').FSASUI:Hide()
		import(path .. 'FireSupportManager.lua').FSSPUI:Show()
		import(path .. 'FireSupportManager.lua').FSSPUI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSSP1UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSSP2UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSSP3UI._closeBtn:Hide()
		if focusarmy >= 1 then
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').spfwbutton:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').spbbbutton:Hide()
		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').spfwbutton:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').spbbbutton:Show()
		end
		end
		if spfwbuttonpress == 1 and spbbbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSSP3UI:Hide()
		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSSP3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSSP3UI._closeBtn:Hide()
		end
		fsforwardbuttonpress = 4
		end
		if fsbackbuttonpress == 2 then
		import(path .. 'FireSupportManager.lua').FSSPUI:Hide()
		import(path .. 'FireSupportManager.lua').FSBUI:Show()
		import(path .. 'FireSupportManager.lua').FSBUI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSB1UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSB2UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSB3UI._closeBtn:Hide()
		if focusarmy >= 1 then
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		if bfwbuttonpress == 1 and bbbbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB2UI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB3UI:Hide()
		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB2UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB2UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB3UI._closeBtn:Hide()
		end
		else
		if bfwbuttonpress == 1 and bbbbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB3UI:Hide()
		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSB3UI._closeBtn:Hide()
		end
		end
		end
		fsforwardbuttonpress = 3
		end
		if fsbackbuttonpress == 3 then
		import(path .. 'FireSupportManager.lua').FSBUI:Hide()
		import(path .. 'FireSupportManager.lua').FSMissileUI:Show()
		import(path .. 'FireSupportManager.lua').FSMissileUI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FS1MissileUI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FS2MissileUI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FS3MissileUI._closeBtn:Hide()
		if mfwbuttonpress == 1 and mbbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS3MissileUI:Hide()
		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS3MissileUI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS3MissileUI._closeBtn:Hide()
		end
		fsforwardbuttonpress = 2
		end
		if fsbackbuttonpress == 4 then
		import(path .. 'FireSupportManager.lua').FSMissileUI:Hide()
		import(path .. 'FireSupportManager.lua').FSUI:Show()
		import(path .. 'FireSupportManager.lua').FSUI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FS1UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FS2UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FS3UI._closeBtn:Hide()
		if artfwbuttonpress == 4 and artbbbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS2UI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS3UI:Hide()
		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS2UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS2UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FS3UI._closeBtn:Hide()
		end
		fsforwardbuttonpress = 1
		end
		if fsbackbuttonpress == 5 then
		import(path .. 'FireSupportManager.lua').FSUI:Hide()
		import(path .. 'FireSupportManager.lua').FSASUI:Show()
		import(path .. 'FireSupportManager.lua').FSAS1UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSAS2UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSAS3UI._closeBtn:Hide()
		import(path .. 'FireSupportManager.lua').FSASUI._closeBtn:Hide()
		if focusarmy >= 1 then
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
		if asbbbuttonpress == 1 and asfwbuttonpress == 2 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		if ExAirStrikesInclude == 1 then

		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Hide()
		end
		elseif asbbbuttonpress == 2 and asfwbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		elseif asbbbuttonpress == 0 and asfwbuttonpress == 0 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		end
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		if asbbbuttonpress == 1 and asfwbuttonpress == 2  then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		if ExAirStrikesInclude == 1 then

		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Hide()
		end
		elseif asbbbuttonpress == 2 and asfwbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		elseif asbbbuttonpress == 0 and asfwbuttonpress == 0 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		end
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		if asbbbuttonpress == 1 and asfwbuttonpress == 3 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		if ExAirStrikesInclude == 1 then

		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS2UI:Hide()
		end
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Hide()
		elseif asbbbuttonpress == 2 and asfwbuttonpress == 2 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS2UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS2UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		elseif asbbbuttonpress == 3 and asfwbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		elseif asbbbuttonpress == 0 and asfwbuttonpress == 0 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		end
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		if asbbbuttonpress == 1 and asfwbuttonpress == 2 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		if ExAirStrikesInclude == 1 then

		else
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Hide()
		end
		elseif asbbbuttonpress == 2 and asfwbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		elseif asbbbuttonpress == 0 and asfwbuttonpress == 0 then
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3Slider:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS1SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS2SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS3SliderText:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11SliderText:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12SliderText:Hide()
		end
		end
		end
		fsforwardbuttonpress = 0
		fsbackbuttonpress = 0
		end
end

Tooltip.AddButtonTooltip(ForwardButton, "FWBtn", 1)
Tooltip.AddButtonTooltip(BackButton, "BBtn", 1)


for i,j in FWBTNPosition do
	ForwardButton[i]:Set(j)
end


for i,j in BBTNPosition do
	BackButton[i]:Set(j)
end



button.OnClick = function(self)
	if buttonpress == 1 then
		helpcenter:Show()
		RefUI._closeBtn:Hide()
		FSUI._closeBtn:Hide()
		FSUI2._closeBtn:Hide()
	end
	if buttonpress == 2 then 
		helpcenter:Hide()
		buttonpress = 0
	end
	
	buttonpress = buttonpress + 1
end

Tooltip.AddButtonTooltip(button, "HCBtn", 1)

for d,t in ButtonPosition do
	button[d]:Set(t)
end

LayoutHelpers.DepthOverParent(button, UI, 10)
LayoutHelpers.DepthOverParent(ForwardButton, UI, 10)
LayoutHelpers.DepthOverParent(BackButton, UI, 10)


for i,j in Position do
	UI[i]:Set(j)
end



