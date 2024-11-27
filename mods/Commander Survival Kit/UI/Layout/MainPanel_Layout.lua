local factions = import('/lua/factions.lua').Factions
local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Button = import('/lua/maui/button.lua').Button
local CreateText = import('/lua/maui/text.lua').Text
local StatusBar = import("/lua/maui/statusbar.lua").StatusBar
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap

local factions = import('/lua/factions.lua').Factions
local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	

local CollectedTacticalPoints = nil
local MaxTacticalPoints = nil
local TacticalPointsGenRate = nil
local CollectedRefPoints = nil
local MaxRefPoints = nil
local RefPointsGenRate = nil

function GetFireSupportPointValues(Value1, Value2, Value3)
CollectedTacticalPoints = Value1
MaxTacticalPoints = Value2
TacticalPointsGenRate = Value3
end

function GetRefPointValues(Value1, Value2, Value3)
CollectedRefPoints = Value1
MaxRefPoints = Value2
RefPointsGenRate = Value3
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
	

    LayoutHelpers.AtLeftTopIn(controls.collapseArrow, GetFrame(0), -3, 240) -- 170
    controls.collapseArrow.Depth:Set(function() return controls.bg.Depth() + 10 end)
    
    LayoutHelpers.Below(controls.bg, econControl, 75) -- 5
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
	
	local FSIcon = Bitmap(controls.bg, '/mods/Commander Survival Kit/textures/FSSymbol2.dds')
	local RefIcon = Bitmap(controls.bg, '/mods/Commander Survival Kit/textures/UEFRefSymbol2.dds')
	FSIcon.Height:Set(24)
    FSIcon.Width:Set(24)
	RefIcon.Height:Set(24)
    RefIcon.Width:Set(24)
	LayoutHelpers.AtLeftTopIn(FSIcon, controls.bg, 120, 82)
	LayoutHelpers.DepthOverParent(FSIcon, controls.bg, 10)
	LayoutHelpers.AtLeftTopIn(RefIcon, controls.bg, 120, 112)
	LayoutHelpers.DepthOverParent(RefIcon, controls.bg, 10)
    
    local FSButton
	if focusarmy >= 1 then
FSButton = UIUtil.CreateButtonStd(controls.bg, '/mods/Commander Survival Kit/textures/uef_fs_btn/uef_fs', nil, 11)
    FSButton.Height:Set(46)
    FSButton.Width:Set(46)
	LayoutHelpers.AtLeftTopIn(FSButton, controls.bg, 10, 87)
	LayoutHelpers.DepthOverParent(FSButton, controls.bg, 10)
    end
	
	    local RefButton
	if focusarmy >= 1 then
RefButton = UIUtil.CreateButtonStd(controls.bg, '/mods/Commander Survival Kit/textures/uef_ref_btn/uef_ref', nil, 11)
    RefButton.Height:Set(46)
    RefButton.Width:Set(46)
	LayoutHelpers.AtLeftTopIn(RefButton, controls.bg, 55, 87)
	LayoutHelpers.DepthOverParent(RefButton, controls.bg, 10)
    end
	
Text = CreateText(controls.bg)	
Text:SetFont('Arial',10) 
Text:SetColor('ffb76518')
Text2 = CreateText(controls.bg)	
Text2:SetFont('Arial',10) 
Text2:SetColor('ffb76518')
Text3 = CreateText(controls.bg)	
Text3:SetFont('Arial',10) 
Text3:SetColor('ff9161ff')
Text4 = CreateText(controls.bg)	
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
if CollectedTacticalPoints ~= nil and MaxTacticalPoints ~= nil and TacticalPointsGenRate ~= nil then
if number == 0 then
tacpointBar = StatusBar(controls.bg, 0, tonumber(MaxTacticalPoints), false, false,
UIUtil.UIFile('/game/resource-mini-bars/mini-energy-bar-back_bmp.dds'),
UIUtil.UIFile('/mods/Commander Survival Kit/textures/mini-fs-bar_bmp.dds'), false)
tacpointBar.Height:Set(8)
tacpointBar.Width:Set(110)	
LayoutHelpers.AtCenterIn(tacpointBar, controls.bg, 58, 50)
LayoutHelpers.DepthOverParent(tacpointBar, controls.bg, 10)
oldmax = MaxTacticalPoints
number = number + 1			
elseif number == 1 and oldmax ~= MaxTacticalPoints then
oldmax = MaxTacticalPoints
tacpointBar:SetRange(CollectedTacticalPoints, tonumber(MaxTacticalPoints))
tacpointBar:SetValue(tonumber(CollectedTacticalPoints))
end
if CollectedTacticalPoints <= MaxTacticalPoints then			
Text:SetText(CollectedTacticalPoints)
Text2:SetText(MaxTacticalPoints)
Text5:SetText('+' .. TacticalPointsGenRate .. '/s')
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
if CollectedRefPoints ~= nil and MaxRefPoints ~= nil and RefPointsGenRate ~= nil then
if number == 0 then
refpointBar = StatusBar(controls.bg, 0, tonumber(MaxRefPoints), false, false,
UIUtil.UIFile('/game/resource-mini-bars/mini-energy-bar-back_bmp.dds'),
UIUtil.UIFile('/mods/Commander Survival Kit/textures/mini-ref-bar_bmp.dds'), false)
refpointBar.Height:Set(8)
refpointBar.Width:Set(110)	
LayoutHelpers.AtCenterIn(refpointBar, controls.bg, 88, 50)
LayoutHelpers.DepthOverParent(refpointBar, controls.bg, 10)
oldmax = MaxRefPoints
number = number + 1			
elseif number == 1 and oldmax ~= MaxRefPoints then
oldmax = MaxRefPoints
refpointBar:SetRange(0, tonumber(MaxRefPoints))
tacpointBar:SetValue(tonumber(CollectedRefPoints))
end
if CollectedRefPoints <= MaxRefPoints then			
Text3:SetText(CollectedRefPoints)
Text4:SetText(MaxRefPoints)
Text6:SetText('+' .. RefPointsGenRate .. '/s')
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
LayoutHelpers.AtCenterIn(Text, controls.bg, 68, 10)
LayoutHelpers.DepthOverParent(Text, controls.bg, 10)
LayoutHelpers.AtCenterIn(Text2, controls.bg, 68, 91)
LayoutHelpers.DepthOverParent(Text2, controls.bg, 10)
LayoutHelpers.AtCenterIn(Text3, controls.bg, 98, 10)
LayoutHelpers.DepthOverParent(Text3, controls.bg, 10)
LayoutHelpers.AtCenterIn(Text4, controls.bg, 98, 91)
LayoutHelpers.DepthOverParent(Text4, controls.bg, 10)

LayoutHelpers.AtCenterIn(Text5, controls.bg, 62, 130)
LayoutHelpers.DepthOverParent(Text5, controls.bg, 10)
LayoutHelpers.AtCenterIn(Text6, controls.bg, 90, 130)
LayoutHelpers.DepthOverParent(Text6, controls.bg, 10)

    
end