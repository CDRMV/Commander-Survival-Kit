local factions = import('/lua/factions.lua').Factions
local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Button = import('/lua/maui/button.lua').Button
local CreateText = import('/lua/maui/text.lua').Text
local StatusBar = import("/lua/maui/statusbar.lua").StatusBar
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local Tooltip = import("/lua/ui/game/tooltip.lua")
local Group = import("/lua/maui/group.lua").Group

local GetFBPOPath = function() for i, mod in __active_mods do if mod.name == "(F.B.P.) Future Battlefield Pack: Orbital" then return mod.location end end end
local FBPOPath = GetFBPOPath()


local factions = import('/lua/factions.lua').Factions
local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()

local HQComCentersIncluded = SessionGetScenarioInfo().Options.HQComCentersIncluded

HQComCenterDisabled = true	

local CollectedTacticalPoints = 0 + import('/mods/Commander Survival Kit/UI/Layout/Values.lua').CurrentTacticalPoints
local MaxTacticalPoints = 0
local TacticalPointsGenRate = 0
local TacticalCenterPoints = 0
local TacticalPointsInterval = 0
local CollectedRefPoints = 0 + import('/mods/Commander Survival Kit/UI/Layout/Values.lua').CurrentReinforcementPoints
local MaxRefPoints = 0
local RefPointsGenRate = 0
local CommandCenterPoints = 0
local RefPointsInterval = 0

local buttonpress = 0
local buttonlock = 0
local fsbuttonpress = 0

function GetFireSupportPointValues(Value1, Value2, Value3, Value4, Value5)
CollectedTacticalPoints = Value1
MaxTacticalPoints = Value2
TacticalCenterPoints = Value4
TacticalPointsGenRate = Value3 + TacticalCenterPoints
TacticalPointsInterval = Value5
end

function GetRefPointValues(Value1, Value2, Value3, Value4, Value5)
CollectedRefPoints = Value1
MaxRefPoints = Value2
CommandCenterPoints = Value4
RefPointsGenRate = Value3 + CommandCenterPoints
RefPointsInterval = Value5
end

function Getfsbuttonpress(Value)
fsbuttonpress = Value
end

function Getrefbuttonpress(Value)
buttonpress = Value
end


function SetLayout()
    local controls = import('/mods/Commander Survival Kit/UI/MainPanel.lua').controls
    local savedParent = import('/mods/Commander Survival Kit/UI/MainPanel.lua').savedParent
    local econControl = import('/lua/ui/game/economy.lua').GUI.bg
    
	
	if focusarmy >= 1 then
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
	controls.bg.panel:SetTexture('/textures/ui/aeon/game/resource-panel/resources_panel_bmp.dds')
    controls.bg.leftBrace:SetTexture('/textures/ui/aeon/game/filter-ping-panel/bracket-left_bmp.dds')
    controls.bg.leftGlow:SetTexture('/textures/ui/aeon/game/filter-ping-panel/bracket-energy-l_bmp.dds')
    controls.bg.rightGlowTop:SetTexture('/textures/ui/aeon/game/bracket-right-energy/bracket_bmp_t.dds')
    controls.bg.rightGlowMiddle:SetTexture('/textures/ui/aeon/game/bracket-right-energy/bracket_bmp_m.dds')
    controls.bg.rightGlowBottom:SetTexture('/textures/ui/aeon/game/bracket-right-energy/bracket_bmp_b.dds')
    
    controls.collapseArrow:SetTexture('/textures/ui/aeon/game/tab-l-btn/tab-close_btn_up.dds')
    controls.collapseArrow:SetNewTextures('/textures/ui/aeon/game/tab-l-btn/tab-close_btn_up.dds',
	    '/textures/ui/aeon/game/tab-l-btn/tab-open_btn_up.dds',
        '/textures/ui/aeon/game/tab-l-btn/tab-close_btn_over.dds',
        '/textures/ui/aeon/game/tab-l-btn/tab-open_btn_over.dds',
        '/textures/ui/aeon/game/tab-l-btn/tab-close_btn_dis.dds',
        '/textures/ui/aeon/game/tab-l-btn/tab-open_btn_dis.dds')
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
	controls.bg.panel:SetTexture('/textures/ui/cybran/game/resource-panel/resources_panel_bmp.dds')
    controls.bg.leftBrace:SetTexture('/textures/ui/cybran/game/filter-ping-panel/bracket-left_bmp.dds')
    controls.bg.leftGlow:SetTexture('/textures/ui/cybran/game/filter-ping-panel/bracket-energy-l_bmp.dds')
    controls.bg.rightGlowTop:SetTexture('/textures/ui/cybran/game/bracket-right-energy/bracket_bmp_t.dds')
    controls.bg.rightGlowMiddle:SetTexture('/textures/ui/cybran/game/bracket-right-energy/bracket_bmp_m.dds')
    controls.bg.rightGlowBottom:SetTexture('/textures/ui/cybran/game/bracket-right-energy/bracket_bmp_b.dds')
    
    controls.collapseArrow:SetTexture('/textures/ui/cybran/game/tab-l-btn/tab-close_btn_up.dds')
    controls.collapseArrow:SetNewTextures('/textures/ui/cybran/game/tab-l-btn/tab-close_btn_up.dds',
		'/textures/ui/cybran/game/tab-l-btn/tab-open_btn_up.dds',
        '/textures/ui/cybran/game/tab-l-btn/tab-close_btn_over.dds',
        '/textures/ui/cybran/game/tab-l-btn/tab-open_btn_over.dds',
        '/textures/ui/cybran/game/tab-l-btn/tab-close_btn_dis.dds',
        '/textures/ui/cybran/game/tab-l-btn/tab-open_btn_dis.dds')
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
	controls.bg.panel:SetTexture('/textures/ui/uef/game/resource-panel/resources_panel_bmp.dds')
    controls.bg.leftBrace:SetTexture('/textures/ui/uef/game/filter-ping-panel/bracket-left_bmp.dds')
    controls.bg.leftGlow:SetTexture('/textures/ui/uef/game/filter-ping-panel/bracket-energy-l_bmp.dds')
    controls.bg.rightGlowTop:SetTexture('/textures/ui/uef/game/bracket-right-energy/bracket_bmp_t.dds')
    controls.bg.rightGlowMiddle:SetTexture('/textures/ui/uef/game/bracket-right-energy/bracket_bmp_m.dds')
    controls.bg.rightGlowBottom:SetTexture('/textures/ui/uef/game/bracket-right-energy/bracket_bmp_b.dds')
    
    controls.collapseArrow:SetTexture('/textures/ui/uef/game/tab-l-btn/tab-close_btn_up.dds')
    controls.collapseArrow:SetNewTextures('/textures/ui/uef/game/tab-l-btn/tab-close_btn_up.dds',
	   '/textures/ui/uef/game/tab-l-btn/tab-open_btn_up.dds',
        '/textures/ui/uef/game/tab-l-btn/tab-close_btn_over.dds',
        '/textures/ui/uef/game/tab-l-btn/tab-open_btn_over.dds',
        '/textures/ui/uef/game/tab-l-btn/tab-close_btn_dis.dds',
        '/textures/ui/uef/game/tab-l-btn/tab-open_btn_dis.dds')
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
	controls.bg.panel:SetTexture('/textures/ui/seraphim/game/resource-panel/resources_panel_bmp.dds')
    controls.bg.leftBrace:SetTexture('/textures/ui/seraphim/game/filter-ping-panel/bracket-left_bmp.dds')
    controls.bg.leftGlow:SetTexture('/textures/ui/seraphim/game/filter-ping-panel/bracket-energy-l_bmp.dds')
    controls.bg.rightGlowTop:SetTexture('/textures/ui/seraphim/game/bracket-right-energy/bracket_bmp_t.dds')
    controls.bg.rightGlowMiddle:SetTexture('/textures/ui/seraphim/game/bracket-right-energy/bracket_bmp_m.dds')
    controls.bg.rightGlowBottom:SetTexture('/textures/ui/seraphim/game/bracket-right-energy/bracket_bmp_b.dds')
    
    controls.collapseArrow:SetTexture('/textures/ui/seraphim/game/tab-l-btn/tab-close_btn_up.dds')
    controls.collapseArrow:SetNewTextures('/textures/ui/seraphim/game/tab-l-btn/tab-close_btn_up.dds',
	    '/textures/ui/seraphim/game/tab-l-btn/tab-open_btn_up.dds',
        '/textures/ui/seraphim/game/tab-l-btn/tab-close_btn_over.dds',
        '/textures/ui/seraphim/game/tab-l-btn/tab-open_btn_over.dds',
        '/textures/ui/seraphim/game/tab-l-btn/tab-close_btn_dis.dds',
        '/textures/ui/seraphim/game/tab-l-btn/tab-open_btn_dis.dds')
		end
	end
	

    LayoutHelpers.AtLeftTopIn(controls.collapseArrow, GetFrame(0), -3, 170) -- 170
    controls.collapseArrow.Depth:Set(function() return controls.bg.Depth() + 10 end)
    
    LayoutHelpers.Below(controls.bg, econControl, 5) -- 5
    if controls.collapseArrow:IsChecked() then
        LayoutHelpers.AtLeftIn(controls.bg, savedParent, -200)
    else
        LayoutHelpers.AtLeftIn(controls.bg, savedParent, 15)
    end
	
	
    controls.bg.Height:Set(controls.bg.panel.Height)
    controls.bg.Width:Set(controls.bg.panel.Width)
    
    LayoutHelpers.AtLeftTopIn(controls.bg.panel, controls.bg, 2, 75) -- 75
    controls.bg.leftBrace.Right:Set(function() return controls.bg.Left() + 11 end)
    controls.bg.leftBrace.Top:Set(function() return controls.bg.Top() + 75 end)
    controls.bg.leftGlow.Left:Set(function() return controls.bg.leftBrace.Left() + 12 end)
    controls.bg.leftGlow.Top:Set(function() return controls.bg.Top() + 74 end)
    controls.bg.leftGlow.Depth:Set(function() return controls.bg.leftBrace.Depth() - 1 end)
    controls.bg.rightGlowTop.Top:Set(function() return controls.bg.Top() + 78 end)
    controls.bg.rightGlowTop.Left:Set(function() return controls.bg.Right() - 9 end)
    controls.bg.rightGlowBottom.Bottom:Set(function() return controls.bg.Bottom() + 72 end)
    controls.bg.rightGlowBottom.Left:Set(controls.bg.rightGlowTop.Left)
    controls.bg.rightGlowMiddle.Top:Set(controls.bg.rightGlowTop.Bottom)
    controls.bg.rightGlowMiddle.Bottom:Set(function() return math.max(controls.bg.rightGlowTop.Bottom(), controls.bg.rightGlowBottom.Top()) end)
    controls.bg.rightGlowMiddle.Right:Set(function() return controls.bg.rightGlowTop.Right() end)
	

	
	
	if focusarmy >= 1 then
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
	local RefIcon = Bitmap(controls.bg, '/mods/Commander Survival Kit/textures/AeonRefSymbol2.dds')
	RefIcon.Height:Set(24)
    RefIcon.Width:Set(24)
	LayoutHelpers.AtLeftTopIn(RefIcon, controls.bg, 120, 112)
	LayoutHelpers.DepthOverParent(RefIcon, controls.bg, 10)
FSButton = UIUtil.CreateButtonStd(controls.bg, '/mods/Commander Survival Kit/textures/aeon_fs_btn/aeon_fs', nil, 11)
RefButton = UIUtil.CreateButtonStd(controls.bg, '/mods/Commander Survival Kit/textures/aeon_ref_btn/aeon_ref', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
	local RefIcon = Bitmap(controls.bg, '/mods/Commander Survival Kit/textures/CybranRefSymbol2.dds')
	RefIcon.Height:Set(24)
    RefIcon.Width:Set(24)
	LayoutHelpers.AtLeftTopIn(RefIcon, controls.bg, 120, 112)
	LayoutHelpers.DepthOverParent(RefIcon, controls.bg, 10)
FSButton = UIUtil.CreateButtonStd(controls.bg, '/mods/Commander Survival Kit/textures/cybran_fs_btn/cybran_fs', nil, 11)
RefButton = UIUtil.CreateButtonStd(controls.bg, '/mods/Commander Survival Kit/textures/cybran_ref_btn/cybran_ref', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
	local RefIcon = Bitmap(controls.bg, '/mods/Commander Survival Kit/textures/UEFRefSymbol2.dds')
	RefIcon.Height:Set(24)
    RefIcon.Width:Set(24)
	LayoutHelpers.AtLeftTopIn(RefIcon, controls.bg, 120, 112)
	LayoutHelpers.DepthOverParent(RefIcon, controls.bg, 10)
FSButton = UIUtil.CreateButtonStd(controls.bg, '/mods/Commander Survival Kit/textures/uef_fs_btn/uef_fs', nil, 11)
RefButton = UIUtil.CreateButtonStd(controls.bg, '/mods/Commander Survival Kit/textures/uef_ref_btn/uef_ref', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
	local RefIcon = Bitmap(controls.bg, '/mods/Commander Survival Kit/textures/SeraphimRefSymbol2.dds')
	RefIcon.Height:Set(24)
    RefIcon.Width:Set(24)
	LayoutHelpers.AtLeftTopIn(RefIcon, controls.bg, 120, 112)
	LayoutHelpers.DepthOverParent(RefIcon, controls.bg, 10)
FSButton = UIUtil.CreateButtonStd(controls.bg, '/mods/Commander Survival Kit/textures/sera_fs_btn/sera_fs', nil, 11)
RefButton = UIUtil.CreateButtonStd(controls.bg, '/mods/Commander Survival Kit/textures/sera_ref_btn/sera_ref', nil, 11)
		end
	end
	

	
FSButton.OnClick = function(control)
		buttonpress = 0
		fsbuttonpress = fsbuttonpress + 1
		if fsbuttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/HelpCenter.lua').UI:Hide()
		import('/mods/Commander Survival Kit/UI/HelpCenterMovie.lua').UI:Hide()
		import('/mods/Commander Survival Kit/UI/HelpCenterMovie.lua').OUI:Hide()
		import('/mods/Commander Survival Kit/UI/info.lua').UI:Hide()
		if FBPOPath then
		import('/mods/Commander Survival Kit/UI/SpaceReinforcementManager.lua').FBPOUI:Hide()
		end
		import('/mods/Commander Survival Kit/UI/NavalReinforcementManager.lua').NavalUI:Hide()
		import('/mods/Commander Survival Kit/UI/AirReinforcementManager.lua').UI:Hide()
		import('/mods/Commander Survival Kit/UI/LandReinforcementManager.lua').LandUI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSUI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSMissileUI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSBUI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSSPUI:Hide()
		import('/mods/Commander Survival Kit/UI/refheader.lua').UI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSDUI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSDUI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/fsheader.lua').UI:Show()
		import('/mods/Commander Survival Kit/UI/fsheader.lua').UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/fsheader.lua').Getfwbuttonpress(0)
		import('/mods/Commander Survival Kit/UI/fsheader.lua').Getbbbuttonpress(0)
		import('/mods/Commander Survival Kit/UI/fsheader.lua').Gethelpbuttonpress(1)
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSASUI:Show()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSASUI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS1UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS2UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSAS3UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS4Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS5Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS6Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS7Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS8Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS9Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS10Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS11Slider:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').AS12Slider:Hide()
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
		if fsbuttonpress == 2 then
		import('/mods/Commander Survival Kit/UI/HelpCenter.lua').UI:Hide()
		import('/mods/Commander Survival Kit/UI/HelpCenterMovie.lua').UI:Hide()
		import('/mods/Commander Survival Kit/UI/HelpCenterMovie.lua').OUI:Hide()
		import('/mods/Commander Survival Kit/UI/info.lua').UI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSASUI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSUI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSMissileUI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSBUI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSSPUI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSDUI:Hide()
		import('/mods/Commander Survival Kit/UI/fsheader.lua').UI:Hide()
		fsbuttonpress = 0
		end
end


RefButton.OnClick = function(control)
		fsbuttonpress = 0
		buttonpress = buttonpress + 1
		if buttonpress == 1 then
		import('/mods/Commander Survival Kit/UI/refheader.lua').Getlandbuttonpress(0)
		import('/mods/Commander Survival Kit/UI/refheader.lua').Getairbuttonpress(0)
		import('/mods/Commander Survival Kit/UI/refheader.lua').Getnavalbuttonpress(0)
		import('/mods/Commander Survival Kit/UI/refheader.lua').Getspacebuttonpress(0)
		import('/mods/Commander Survival Kit/UI/refheader.lua').Gethelpbuttonpress(1)
		import('/mods/Commander Survival Kit/UI/HelpCenter.lua').UI:Hide()
		import('/mods/Commander Survival Kit/UI/HelpCenterMovie.lua').UI:Hide()
		import('/mods/Commander Survival Kit/UI/HelpCenterMovie.lua').OUI:Hide()
		import('/mods/Commander Survival Kit/UI/info.lua').UI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSASUI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSUI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSMissileUI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSBUI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSSPUI:Hide()
		import('/mods/Commander Survival Kit/UI/FireSupportManager.lua').FSDUI:Hide()
		import('/mods/Commander Survival Kit/UI/fsheader.lua').UI:Hide()
		import('/mods/Commander Survival Kit/UI/refheader.lua').UI:SetTitle('<LOC RefManager>Reinforcement Manager')
		import('/mods/Commander Survival Kit/UI/refheader.lua').UI:Show()
		import('/mods/Commander Survival Kit/UI/refheader.lua').Text:Show()
		import('/mods/Commander Survival Kit/UI/refheader.lua').Text2:Show()
		import('/mods/Commander Survival Kit/UI/refheader.lua').UI._closeBtn:Hide()
		import('/mods/Commander Survival Kit/UI/refheader.lua').LBTNUI._closeBtn:Hide()
		end
		if buttonpress == 2 then
		import('/mods/Commander Survival Kit/UI/HelpCenter.lua').UI:Hide()
		import('/mods/Commander Survival Kit/UI/HelpCenterMovie.lua').UI:Hide()
		import('/mods/Commander Survival Kit/UI/HelpCenterMovie.lua').OUI:Hide()
		import('/mods/Commander Survival Kit/UI/info.lua').UI:Hide()
		if FBPOPath then
		import('/mods/Commander Survival Kit/UI/SpaceReinforcementManager.lua').FBPOUI:Hide()
		end
		import('/mods/Commander Survival Kit/UI/NavalReinforcementManager.lua').NavalUI:Hide()
		import('/mods/Commander Survival Kit/UI/AirReinforcementManager.lua').UI:Hide()
		import('/mods/Commander Survival Kit/UI/LandReinforcementManager.lua').LandUI:Hide()
		import('/mods/Commander Survival Kit/UI/refheader.lua').UI:Hide()
		import('/mods/Commander Survival Kit/UI/refheader.lua').Text:Hide()
		import('/mods/Commander Survival Kit/UI/refheader.lua').Text2:Hide()
		buttonpress = 0
		end	
end
	
    TacticalPointStorage = Group(controls.bg)
    LayoutHelpers.AtCenterIn(TacticalPointStorage, controls.bg, 0, 0)
    TacticalPointStorage.Width:Set(100)
    LayoutHelpers.SetHeight(TacticalPointStorage, -100)
    TacticalPointStorage.top = 0	
	
	RefPointStorage = Group(controls.bg)
    LayoutHelpers.AtCenterIn(RefPointStorage, controls.bg, 0, 0)
    RefPointStorage.Width:Set(100)
    LayoutHelpers.SetHeight(RefPointStorage, -150)
    RefPointStorage.top = 0

	local FSIcon = Bitmap(controls.bg, '/mods/Commander Survival Kit/textures/FSSymbol2.dds')
	FSIcon.Height:Set(24)
    FSIcon.Width:Set(24)
	LayoutHelpers.AtLeftTopIn(FSIcon, controls.bg, 120, 82)
	LayoutHelpers.DepthOverParent(FSIcon, controls.bg, 10)
	
Text = CreateText(TacticalPointStorage)	
Text:SetFont('Arial',10) 
Text:SetColor('ffb76518')
Text2 = CreateText(TacticalPointStorage)	
Text2:SetFont('Arial',10) 
Text2:SetColor('ffb76518')
Text3 = CreateText(RefPointStorage)	
Text3:SetFont('Arial',10) 
Text3:SetColor('ff9161ff')
Text4 = CreateText(RefPointStorage)	
Text4:SetFont('Arial',10) 
Text4:SetColor('ff9161ff')	


Text5 = CreateText(controls.bg)	
Text5:SetFont('Arial',15) 
Text5:SetColor('ffb76518')	

Text6 = CreateText(controls.bg)	
Text6:SetFont('Arial',15) 
Text6:SetColor('ff9161ff')	

ForkThread(
	function()
	local number = 0
	local oldmax = 0
while true do
if CollectedTacticalPoints ~= nil and MaxTacticalPoints ~= nil and TacticalPointsGenRate ~= nil and TacticalCenterPoints ~= nil and TacticalPointsInterval ~= nil then
if number == 0 then
tacpointBar = StatusBar(TacticalPointStorage, 0, tonumber(MaxTacticalPoints), false, false,
UIUtil.UIFile('/game/resource-mini-bars/mini-energy-bar-back_bmp.dds'),
UIUtil.UIFile('/mods/Commander Survival Kit/textures/mini-fs-bar_bmp.dds'), false)
tacpointBar.Height:Set(8)
tacpointBar.Width:Set(110)	
LayoutHelpers.AtCenterIn(tacpointBar, TacticalPointStorage, 58, 50)
LayoutHelpers.DepthOverParent(tacpointBar, TacticalPointStorage, 10)
oldmax = MaxTacticalPoints
number = number + 1			
elseif number == 1 and oldmax ~= MaxTacticalPoints then
oldmax = MaxTacticalPoints
tacpointBar:SetRange(0, tonumber(MaxTacticalPoints))
tacpointBar:SetValue(tonumber(CollectedTacticalPoints))
end
if CollectedTacticalPoints <= MaxTacticalPoints then			
Text:SetText(CollectedTacticalPoints)
Text2:SetText(MaxTacticalPoints)
Text5:SetText('+' .. TacticalPointsGenRate .. '/' .. TacticalPointsInterval .. 's')
tacpointBar:SetValue(tonumber(CollectedTacticalPoints))
LayoutHelpers.AtLeftTopIn(tacpointBar._bar, tacpointBar, 5, 0)
LayoutHelpers.DepthOverParent(tacpointBar._bar, tacpointBar, 100)
end
else

end
WaitSeconds(0.1)
end
end
)


			
ForkThread(
	function()
	local number = 0
	local oldmax = 0
while true do
if CollectedRefPoints ~= nil and MaxRefPoints ~= nil and RefPointsGenRate ~= nil and CommandCenterPoints ~= nil and RefPointsInterval ~= nil then
if number == 0 then
refpointBar = StatusBar(RefPointStorage, 0, tonumber(MaxRefPoints), false, false,
UIUtil.UIFile('/game/resource-mini-bars/mini-energy-bar-back_bmp.dds'),
UIUtil.UIFile('/mods/Commander Survival Kit/textures/mini-ref-bar_bmp.dds'), false)
refpointBar.Height:Set(8)
refpointBar.Width:Set(110)	
LayoutHelpers.AtCenterIn(refpointBar, RefPointStorage, 86, 50)
LayoutHelpers.DepthOverParent(refpointBar, RefPointStorage, 10)
oldmax = MaxRefPoints
number = number + 1			
elseif number == 1 and oldmax ~= MaxRefPoints then
oldmax = MaxRefPoints
refpointBar:SetRange(0, tonumber(MaxRefPoints))
refpointBar:SetValue(tonumber(CollectedRefPoints))
end
if CollectedRefPoints <= MaxRefPoints then			
Text3:SetText(CollectedRefPoints)
Text4:SetText(MaxRefPoints)
Text6:SetText('+' .. RefPointsGenRate .. '/' .. RefPointsInterval .. 's')
refpointBar:SetValue(tonumber(CollectedRefPoints))
LayoutHelpers.AtLeftTopIn(refpointBar._bar, refpointBar, 5, 0)
LayoutHelpers.DepthOverParent(refpointBar._bar, refpointBar, 100)
end
else

end
WaitSeconds(0.1)
end
end
)



Text.Depth:Set(30)
Text2.Depth:Set(30)
Text3.Depth:Set(30)
Text4.Depth:Set(30)
Text5.Depth:Set(30)
Text6.Depth:Set(30)
RefButton.Height:Set(46)
RefButton.Width:Set(46)
LayoutHelpers.AtCenterIn(TacticalPointStorage, controls.bg, 0, 0)
LayoutHelpers.DepthOverParent(TacticalPointStorage, controls.bg, 10)
LayoutHelpers.AtLeftTopIn(RefButton, controls.bg, 60, 87)
LayoutHelpers.DepthOverParent(RefButton, controls.bg, 50)
FSButton.Height:Set(46)
FSButton.Width:Set(46)
LayoutHelpers.AtLeftTopIn(FSButton, controls.bg, 10, 87)
LayoutHelpers.DepthOverParent(FSButton, controls.bg, 50)
LayoutHelpers.AtCenterIn(Text, controls.bg, 68, 10)
LayoutHelpers.DepthOverParent(Text, controls.bg, 10)
LayoutHelpers.AtCenterIn(Text2, controls.bg, 68, 91)
LayoutHelpers.DepthOverParent(Text2, controls.bg, 10)
LayoutHelpers.AtCenterIn(Text3, controls.bg, 96, 10)
LayoutHelpers.DepthOverParent(Text3, controls.bg, 10)
LayoutHelpers.AtCenterIn(Text4, controls.bg, 96, 91)
LayoutHelpers.DepthOverParent(Text4, controls.bg, 10)

LayoutHelpers.AtCenterIn(Text5, controls.bg, 62, 130)
LayoutHelpers.DepthOverParent(Text5, controls.bg, 10)
LayoutHelpers.AtCenterIn(Text6, controls.bg, 90, 130)
LayoutHelpers.DepthOverParent(Text6, controls.bg, 10)

 
Tooltip.AddButtonTooltip(RefButton, "RefBtn", 1)
Tooltip.AddButtonTooltip(FSButton, "FSBtn", 1)

Tooltip.AddControlTooltip(Text5, 'TacPointIncome')
Tooltip.AddControlTooltip(Text6, 'RefPointIncome')

Tooltip.AddControlTooltip(TacticalPointStorage, 'TacPointStorage')
Tooltip.AddControlTooltip(RefPointStorage, 'RefPointStorage')


RefButton:Disable()
FSButton:Disable()
local Gametype = SessionGetScenarioInfo().type

CSKManagerNumber = import('/mods/Commander Survival Kit/UI/Layout/Values.lua').CSKManagerNumber
HQComCenterDetected = import('/mods/Commander Survival Kit/UI/Layout/Values.lua').HQComCenterDetected


ForkThread(
	function()
	while true do 
		if Gametype == 'skirmish' or Gametype == 'campaign_coop' then
		while true do 
		if HQComCenterDisabled == false or HQComCentersIncluded == 1 then
		if HQComCenterDetected == false then
		CSKManagerNumber = 0
		RefButton:Disable()
		FSButton:Disable()
		else
		if CSKManagerNumber == 0 then
		RefButton:Enable()
		FSButton:Enable()
		CSKManagerNumber = 1
		end
		end
		elseif HQComCenterDisabled == true or HQComCentersIncluded == 2 then
		if CSKManagerNumber == 0 then
		RefButton:Enable()
		FSButton:Enable()
		CSKManagerNumber = 1
		end
		end
		WaitSeconds(1)
		end
		elseif Gametype == 'campaign' then
		while true do 
		if HQComCenterDisabled == false and HQComCentersIncluded == nil then
		if HQComCenterDetected == false then
		CSKManagerNumber = 0
		RefButton:Disable()
		FSButton:Disable()
		else
		if CSKManagerNumber == 0 then
		RefButton:Enable()
		FSButton:Enable()
		CSKManagerNumber = 1
		end
		end
		elseif HQComCenterDisabled == true and HQComCentersIncluded == nil then
		if CSKManagerNumber == 0 then
		RefButton:Enable()
		FSButton:Enable()
		CSKManagerNumber = 1
		end
		end
		WaitSeconds(1)
		end
		end
		end
	end
)

 
end