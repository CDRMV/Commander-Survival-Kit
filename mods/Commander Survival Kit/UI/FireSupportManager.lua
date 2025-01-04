#****************************************************************************
#**	 Feature: Reinforcements Manager 
#** 	
#**	 Mod: FBP Orbital
#**  
#**	 Original Author: Illumination
#**	 Author: CDRMV 

#**	 Description:
#**  This Feature is based on the Code of The Second Construction Panel from Illumination
#**  I have change & modified from an alternative Construction panel to an Reinforcement Manager
#**  The manager is able to spawn three Units as Reinforcements on the Map 

#**  How to use:
#**  Single Reinforcement Calls
#**  Click on the Unit Icon/Button & set a Target location on the Map with right click
#**  The unit will appear after ten Seconds

#**  Multi Reinforcement calls 
#**  Keep Shift pressed, Click on the Unit Icon/Button & set a Target location on the Map with right click
#**  The unit will appear after ten Seconds

#**  Copyright © 2022 FBP Orbital & SupremeWarfare4k (as original Code)
#****************************************************************************


--#################################################################### 

-- General Stuff and Imports

--#################################################################### 
local GetTextureDimensions = import('/lua/maui/layouthelpers.lua').GetTextureDimensions
local path = '/mods/Commander Survival Kit/UI/'
local UIUtil = import('/lua/ui/uiutil.lua')
local Tooltip = import("/lua/ui/game/tooltip.lua")
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local CreateWindow = import('/lua/maui/window.lua').Window
local CreateText = import('/lua/maui/text.lua').Text 
local Button = import('/lua/maui/button.lua').Button
local Slider = import('/lua/maui/slider.lua').Slider
local Bitmap = import("/lua/maui/bitmap.lua").Bitmap
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local GetClickPosition = import('/lua/ui/game/commandmode.lua').ClickListener
local GetPause = import ('/lua/ui/game/tabs.lua').OnPause
local arrivalbox = import(path .. 'Arrives.lua').UI
local arrivalboxtext = import(path .. 'Arrives.lua').Text
local availablebox = import(path .. 'Availability.lua').UI
local availableboxtext = import(path .. 'Availability.lua').Text
local headerbox = import(path .. 'header.lua').UI
local headerboxtext = import(path .. 'header.lua').Text
local headerboxtext2 = import(path .. 'header.lua').Text2
local info = import(path .. 'info.lua').UI
local infoboxtext = import(path .. 'info.lua').Text
local infoboxtext2 = import(path .. 'info.lua').Text2
local infoboxtext3 = import(path .. 'info.lua').Text3
local fsheaderbox = import(path .. 'fsheader.lua').UI
local fsheaderboxtext = import(path .. 'fsheader.lua').Text
local fsheaderboxtext2 = import(path .. 'fsheader.lua').Text2
local fstextboxUI = import(path .. 'fsreminder.lua').UI
--local FSPUI = import(path .. 'tacui.lua').UI
local FSPUItext = import(path .. 'tacui.lua').Text
local fstextbox = import(path .. 'fsreminder.lua').Text
local fstextbox2 = import(path .. 'fsreminder.lua').Text2
local fstextbox3 = import(path .. 'fsreminder.lua').Text3
local textboxUI = import(path .. 'reminder.lua').UI
local textbox = import(path .. 'reminder.lua').Text
local textbox2 = import(path .. 'reminder.lua').Text2
local UIPing = import('/lua/ui/game/ping.lua')
local cmdMode = import('/lua/ui/game/commandmode.lua')
local factions = import('/lua/factions.lua').Factions
local Tooltip = import("/lua/ui/game/tooltip.lua")
linkup2 = import(path .. 'ReinforcementButtons.lua').linkup
SetBtnTextures2 = import(path .. 'ReinforcementButtons.lua').SetBtnTextures
increasedBorder2 = import(path .. 'ReinforcementButtons.lua').increasedBorder

local CreateTransmission = import(path .. 'CreateTransmission.lua')
local CreateTransmission = import(path .. 'CreateTransmission.lua').CreateTransmission

HQComCenterDetected = false
HQComCenterDisabled = false


--local posx = import('/lua/aibrain.lua').OnSpawnPreBuiltUnits.posX
--local posy = import('/lua/aibrain.lua').OnSpawnPreBuiltUnits.posY

--#################################################################### 

-- Check for FBP Orbital activation

--#################################################################### 


local GetFBPOPath = function() for i, mod in __active_mods do if mod.name == "(F.B.P.) Future Battlefield Pack: Orbital" then return mod.location end end end
local FBPOPath = GetFBPOPath()


--#################################################################### 

-- Variable Definitions

--#################################################################### 
local FireSupportCampaignOptions = {}
local FireSupportCampaignOptionsMaxPointValue = nil
local FireSupportCampaignOptionsWaitTimeValue = nil
local FireSupportCampaignOptionsGenIntervalValue = nil
local FireSupportCampaignOptionsGenRateValue = nil

function GetFireSupportCampaignOptions(Array)
FireSupportCampaignOptions = Array
end

function GetFireSupportMaxPointCampaignOptionValue(Value)
FireSupportCampaignOptionsMaxPointValue = Value
end

function GetFireSupportWaitTimeCampaignOptionValue(Value)
FireSupportCampaignOptionsWaitTimeValue = Value
end

function GetFireSupportGenIntervalCampaignOptionValue(Value)
FireSupportCampaignOptionsGenIntervalValue = Value
end

function GetFireSupportGenRateCampaignOptionValue(Value)
FireSupportCampaignOptionsGenRateValue = Value
end


local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	
local quantity = math.max(1, 1)
local mapsize = SessionGetScenarioInfo().size
local Gametype = SessionGetScenarioInfo().type
local mapWidth = mapsize[1]
local mapHeight = mapsize[2]
LOG('MapWidth: ', mapWidth)
LOG('MapHeigth: ', mapHeight)

local selectedtime = SessionGetScenarioInfo().Options.TacPoints
local TacWaitInterval = selectedtime

local AddTacticalPointStorage = 0

local DropIncluded = SessionGetScenarioInfo().Options.DropInclude
local AirStrikesInclude = SessionGetScenarioInfo().Options.AirStrikesInclude
local ExAirStrikesInclude = SessionGetScenarioInfo().Options.EXAirStrikesInclude
local ChoosedInterval = SessionGetScenarioInfo().Options.TacPointsGenInt
local ChoosedRate = SessionGetScenarioInfo().Options.TacPointsGenRate
local StartTACPoints = 50 
local MaxTACPoints = SessionGetScenarioInfo().Options.TacPointsMax	-- Maximum collectable Tactical Points
local MaxTACPointsText = tostring(MaxTACPoints)
local MaxTactpoints = '/' .. MaxTACPointsText

function TacticalPointStorageHandle(Value)
	ForkThread(function()
	AddTacticalPointStorage = Value
		if AddTacticalPointStorage == 0 and MaxTACPoints < 10000 then
		if SessionGetScenarioInfo().Options.TacPointsMax > 0 then
		MaxTACPoints = SessionGetScenarioInfo().Options.TacPointsMax
		MaxTACPointsText = tostring(MaxTACPoints)
		MaxTactpoints = '/' .. MaxTACPointsText
		else
		MaxTACPoints = 0
		MaxTACPointsText = tostring(MaxTACPoints)
		MaxTactpoints = '/' .. MaxTACPointsText
		end
		else
		if AddTacticalPointStorage > 0 and MaxTACPoints < 10000 then
		MaxTACPoints = MaxTACPoints + AddTacticalPointStorage
		MaxTACPointsText = tostring(MaxTACPoints)
		MaxTactpoints = '/' .. MaxTACPointsText
		AddTacticalPointStorage = 0
		elseif MaxTACPoints < 10000 then
		MaxTACPoints = MaxTACPoints + AddTacticalPointStorage
		MaxTACPointsText = tostring(MaxTACPoints)
		MaxTactpoints = '/' .. MaxTACPointsText
		AddTacticalPointStorage = 0
		end
		end
	end)
end 


ForkThread(
	function()
if Gametype == 'campaign' then
while true do
if TacWaitInterval == nil then
if FireSupportCampaignOptionsWaitTimeValue == nil then

else
TacWaitInterval = FireSupportCampaignOptionsWaitTimeValue
break
end
end
WaitSeconds(0.1)
end
end
end
)


ForkThread(
	function()
if Gametype == 'campaign' then
while true do
if MaxTACPoints == nil then
if FireSupportCampaignOptionsMaxPointValue == nil then

else
MaxTACPoints = FireSupportCampaignOptionsMaxPointValue + AddTacticalPointStorage
MaxTACPointsText = tostring(MaxTACPoints)
MaxTactpoints = '/' .. MaxTACPointsText
break
end
end
WaitSeconds(0.1)
end
end
end
)


ForkThread(
	function()
if Gametype == 'campaign' then
while true do
if ChoosedInterval == nil then
if FireSupportCampaignOptionsGenIntervalValue == nil then

else
ChoosedInterval = FireSupportCampaignOptionsGenIntervalValue
break
end
end
WaitSeconds(0.1)
end
end
end
)



ForkThread(
	function()
if Gametype == 'campaign' then
while true do
if ChoosedRate == nil then
if FireSupportCampaignOptionsGenRateValue == nil then

else
ChoosedRate = FireSupportCampaignOptionsGenRateValue
break
end
end
WaitSeconds(0.1)
end
end
end
)

--[[

if TacWaitInterval == nil and ChoosedInterval == nil and ChoosedRate == nil and MaxTACPoints == nil then
TacWaitInterval = 300 
ChoosedInterval = 3
ChoosedRate = 1
MaxTACPoints = 3000 + AddTacticalPointStorage
MaxTACPointsText = tostring(MaxTACPoints)
MaxTactpoints = '/' .. MaxTACPointsText
else

end

]]--

local TacticalCenterpoints = 0


local Text1
local Text2
local Text3
local Text4
local Text5


local fstext = '0/' .. MaxTACPointsText
local fstext2 = 'Collected Points: 0/' .. MaxTACPointsText
local fstext3 = 'Generation starts in: 5 Minutes'
local fstext4 = 'No available Points'
local fstext5 = 'Generation starts in: 5 Minutes'
local NWave = 'Next Wave available in:'
local Arrivaltext = 'Arrival in: '
local Storage = 4 -- Units Storage
local number = 4	-- Reinforcement Waves (If 0 you will be able to Call the first 4 Units at the beginning of the Match)
local Minutes = 0 -- Interval in Minutes
local MinInterval = 0
local Seconds = 0
local step = 0		
local Interval = 300 -- Interval in Seconds
local Intervalstep = 300 -- Interval in Seconds
local TacPoints = 0
local MainTacPoints = 0
Tacticalpoints = 0
local Transmaxamount = 0

--#################################################################### 

-- UI Text Definitions and Hide UI Elements 

--#################################################################### 


textboxUI:Hide()
textbox:Hide()
headerbox:Hide()
headerboxtext:Hide()
headerboxtext2:Hide()
arrivalbox:Hide()
arrivalboxtext:Hide()
availablebox:Hide()
availableboxtext:Hide()
textbox2:SetText(Arrivaltext)
textbox2:Hide()
fsheaderbox:Hide()
fsheaderboxtext:Hide()
fsheaderboxtext2:Hide()
fstextboxUI:Hide()
fstextbox:Hide()
fstextbox2:Hide()
fstextbox3:Hide()
fstextbox:SetText(fstext4)
fstextbox2:SetText(fstext5)
fsheaderboxtext:SetText(fstext3)
FSPUItext:SetText(fstext)
FSPUItext:Hide()
fsheaderboxtext2:SetText(fstext4)

--[[
--#################################################################### 

-- Unused Code for Tooltips 

--#################################################################### 


local bp = __blueprints[id]
local name = bp.General.UnitName
local desc = bp.Description
Tooltip.AddForcedControlTooltipManual(ExampleUI.Images[c], name, desc, 1)


]]--


--#################################################################### 

-- Generate Tactical Points

--#################################################################### 


local aiThread
local uiThread
local ifnoThread

BrainCheck = function(brain)
	WaitSeconds(5)
	ForkThread(TacticalCenterPointsThread, aiBrain)
end

TacticalCenterPointsThread = function(self)
    aiThread = ForkThread(function() 
	    while true do
		    local labs = self:GetListOfUnits(categories.TACTICALCENTER, false)
			if labs then
			    if table.getn(labs) > 0 then
				    for k,v in labs do
					    if v:GetFractionComplete() == 1 then
						    Sync.HasResearchLab = true
							if not ifnoThread then
							    ForkThread(IfNoTacticalCenterPointsThread, self)
							end
							KillThread(aiThread)
							aiThread = nil
						end
					end
				end
			end
			WaitSeconds(1)
		end
	end)
end
	
IfNoTacticalCenterPointsThread = function(self)
    ifnoThread = ForkThread(function()
	    while true do
		    local labs = self:GetListOfUnits(categories.TACTICALCENTER, false)
			if labs then
			    if table.getn(labs) == 0 then
				    Sync.LostResearchLab = true
					if not aiThread then
					    ForkThread(TacticalCenterPointsThread, self)
					end
					KillThread(ifnoThread)
					ifnoThread = nil
				end
			end
			WaitSeconds(2)
		end
	end)
end

function TacticalCenterPointsHandle(generated)
	ForkThread(function()
		TacticalCenterpoints = generated
	end)
end 

function CollectedAbility(Collected)
	TacticalCenterpoints = Collected
end

function CheckUnitCapReached(Value)
Tacticalpoints = Tacticalpoints + Value
end


ForkThread(
	function()
		repeat	
		if ChoosedInterval == nil then
		WaitSeconds(0.1)
		else
			local MathFloor = math.floor
			local hours = MathFloor(GetGameTimeSeconds() / 3600)
			local Seconds = GetGameTimeSeconds() - hours * 3600
			WaitSeconds(ChoosedInterval) -- Generated Points per 3 Seconds
			if Seconds < TacWaitInterval and Tacticalpoints < StartTACPoints then
				if TacWaitInterval == 300 then 
					fstext4 = 'Generation starts in: 5 Minutes'
					fsheaderboxtext:SetText(fstext4)
				elseif TacWaitInterval == 600 then 
					fstext4 = 'Generation starts in: 10 Minutes'
					fsheaderboxtext:SetText(fstext4)
				elseif TacWaitInterval == 900 then 
					fstext4 = 'Generation starts in: 15 Minutes'
					fsheaderboxtext:SetText(fstext4)
				elseif TacWaitInterval == 1200 then 
					fstext4 = 'Generation starts in: 20 Minutes'
					fsheaderboxtext:SetText(fstext4)	
				elseif TacWaitInterval == 1500 then 
					fstext4 = 'Generation starts in: 25 Minutes'
					fsheaderboxtext:SetText(fstext4)
				elseif TacWaitInterval == 1800 then 
					fstext4 = 'Generation starts in: 30 Minutes'
					fsheaderboxtext:SetText(fstext4)
				elseif TacWaitInterval == 2100 then 
					fstext4 = 'Generation starts in: 35 Minutes'
					fsheaderboxtext:SetText(fstext4)
				elseif TacWaitInterval == 2400 then 
					fstext4 = 'Generation starts in: 40 Minutes'
					fsheaderboxtext:SetText(fstext4)
				elseif TacWaitInterval == 2700 then 
					fstext4 = 'Generation starts in: 45 Minutes'
					fsheaderboxtext:SetText(fstext4)	
				elseif TacWaitInterval == 3000 then 
					fstext4 = 'Generation starts in: 55 Minutes'
					fsheaderboxtext:SetText(fstext4)
				elseif TacWaitInterval == 3300 then 
					fstext4 = 'Generation starts in: 55 Minutes'
					fsheaderboxtext:SetText(fstext4)
				elseif TacWaitInterval == 3600 then 
					fstext4 = 'Generation starts in: 60 Minutes'
					fsheaderboxtext:SetText(fstext4)					
				end
				fstext5 = 'No avaiable Points.'
				fsheaderboxtext2:SetText(fstext5)
			end
			if Seconds > TacWaitInterval and Tacticalpoints >= StartTACPoints and Tacticalpoints < MaxTACPoints then 
				fstext4 = 'Points available'
				fsheaderboxtext:SetText(fstext4)
				fstext5 = 'Awaiting Orders'
				fsheaderboxtext2:SetText(fstext5)
				Tacticalpoints = Tacticalpoints + ChoosedRate + TacticalCenterpoints
			end
			if Seconds > TacWaitInterval and Tacticalpoints <= StartTACPoints and Tacticalpoints < MaxTACPoints then 
				fstext4 = 'Generation in Progress'
				fsheaderboxtext:SetText(fstext4)
				fstext5 = 'Not enough Points'
				fsheaderboxtext2:SetText(fstext5)
				Tacticalpoints = Tacticalpoints + ChoosedRate + TacticalCenterpoints
			end
			if Seconds > TacWaitInterval and Tacticalpoints == MaxTACPoints then
				fstext4 = 'Generation has stopped'
				fsheaderboxtext:SetText(fstext4)
				fstext5 = 'Point Limit reached'
				fsheaderboxtext2:SetText(fstext5)
				
				if Transmaxamount == 0 then
				if focusarmy >= 1 then
					if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
						Text1 = "Rhiza:"
						Text2 = "Regarding the tactical points."
						Text3 = "The Limit of collectable Points is reached."
						Text4 = "Use them wisely and we will continue the Transfer."
						Text5 = "Rhiza out."
						CreateTransmission(Text1, Text2, Text3, Text4, Text5)
						Transmaxamount = 1						
					end
					if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
						Text1 = "Brackman:"
						Text2 = "Regarding the tactical points."
						Text3 = "The Limit of collectable Points is reached."
						Text4 = "Use them wisely and we will continue the Transfer."
						Text5 = "Stay tuned for Updates my Child."
						CreateTransmission(Text1, Text2, Text3, Text4, Text5)
						Transmaxamount = 1
					end
					if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
						Text1 = "Command HQ:"
						Text2 = "Regarding the tactical points."
						Text3 = "The Limit of collectable Points is reached."
						Text4 = "Use them wisely and we will continue the Transfer."
						Text5 = "Stay tuned for Updates --- Command HQ out."
						CreateTransmission(Text1, Text2, Text3, Text4, Text5)
						Transmaxamount = 1
					end
					if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
						Text1 = "Oum-Eoshi (Translated):"
						Text2 = "Regarding the tactical points."
						Text3 = "The Limit of collectable Points is reached."
						Text4 = "Use them wisely and we will continue the Transfer."
						Text5 = "Stay tuned for Updates."
						CreateTransmission(Text1, Text2, Text3, Text4, Text5)
						Transmaxamount = 1
					end
				end
				else
				end

			end
			MainTacPoints = 'Collected Points: ' .. Tacticalpoints .. MaxTactpoints
			import('/mods/Commander Survival Kit/UI/Layout/MainPanel_Layout.lua').GetFireSupportPointValues(Tacticalpoints, MaxTACPointsText, ChoosedRate, TacticalCenterpoints, ChoosedInterval)
			TacPoints = Tacticalpoints .. MaxTactpoints
			--fsheaderboxtext:SetText(MainTacPoints)
			FSPUItext:SetText(TacPoints)
			end
		until(GetGameTimeSeconds() < 0)
	end
)

--#################################################################### 

-- Basic UI Definitions for both Manger Sections (Planetary and Space)

--#################################################################### 


local existed = {}



local function SetBtnTextures(ui, id)
	local location = '/mods/Commander Survival Kit/icons/units/up/' .. id .. '_icon.dds' 									-- Normal Icon
	local location2 = '/mods/Commander Survival Kit/icons/units/over/' .. id .. '_icon.dds'		-- Mouseover Icon
	local location3 = '/mods/Commander Survival Kit/icons/units/active/' .. id .. '_icon.dds'		-- Selected Icon
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), path)
end

local function arrayPosition(Position, existed, parent)
	if existed[1] then
		return existed[2]
	else
		local pos = {}
		for k,v in Position do
			pos[k] = parent[k][1]
		end
		pos.Height = pos.Top - pos.Bottom
		pos.Width = pos.Right - pos.Left
		existed[4] = pos.Left
		existed[1] = true
		return pos
	end
end

local function arrayPosition2(Position, existed, parent)
	if existed[1] then
		return existed[2]
	else
		local pos = {}
		for k,v in Position do
			pos[k] = parent[k][1]
		end
		pos.Height = pos.Top - pos.Bottom
		pos.Width = pos.Right - pos.Left
		existed[3] = pos.Left
		existed[1] = true
		return pos
	end
end


local function array(pos, total, Image, existed)
	if existed[3] then
		pos.Height = pos.Height / total
		pos.Width = pos.Width / total
		existed[3] = false 
	end
	local right = pos.Left + pos.Width
	local bottom = pos.Top - pos.Height
	Image.Top:Set(pos.Top) 
	Image.Bottom:Set(bottom)
	Image.Left:Set(pos.Left)
	Image.Right:Set(right)
	if right > pos.Right then
		right = existed[4]
		pos.Top = bottom
	end
	pos.Left = right
	return pos
end

function array2(pos, total, Image, Price, existed)
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
	if existed[3] then
		pos.Height = -54
		pos.Width = 54
		existed[3] = false 
	end
	else
	if existed[3] then
		pos.Height = -48
		pos.Width = 48
		existed[3] = false 
	end
	end
	local right = pos.Left + pos.Width 
	local bottom = pos.Top - pos.Height 
	Image.Top:Set(pos.Top) 
	Image.Bottom:Set(bottom)
	Image.Left:Set(pos.Left)
	Image.Right:Set(right)
	local focusarmy = GetFocusArmy()
    local armyInfo = GetArmiesTable()	
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
		Price:SetFont('Arial',11)
		Price:SetColor('ff00ff00')
		LayoutHelpers.AtCenterIn(Price, Image, 40, 5)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		Price:SetFont('Arial',11)
		Price:SetColor('fff0a20e')
		LayoutHelpers.AtCenterIn(Price, Image, 35, 5)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		Price:SetFont('Arial',11)
		Price:SetColor('ff54d1ef')
		LayoutHelpers.AtCenterIn(Price, Image, 30, 8)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		Price:SetFont('Arial',11)
		Price:SetColor('ffeeeeee')
		LayoutHelpers.AtCenterIn(Price, Image, 35, 5)
		end
	end	
	if right > pos.Right then
		right = existed[4]
		pos.Top = bottom
	end
	pos.Left = right
	return pos
end

local function linkup(pos, existed)
	existed[2] = pos
end

local function increasedBorder(ui, scale)
	ui.Top:Set(ui.Top[1] - scale - 15)
	ui.Left:Set(ui.Left[1] - scale + 5)
	ui.Right:Set(ui.Right[1] + scale + 80)
	ui.Bottom:Set(ui.Bottom[1] + scale + 15)
end



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
	Left = 40, 
	Top = 450, 
	Bottom = 670, 
	Right = 250
}

local DPosition = {
	Left = 30, 
	Top = 348, 
	Bottom = 670, 
	Right = 250
}

local DPosition2 = {
	Left = 35, 
	Top = 355, 
	Bottom = 670, 
	Right = 250
}

local DPosition3 = {
	Left = 30, 
	Top = 348, 
	Bottom = 670, 
	Right = 250
}

local SecondPosition = {
	Left = 30, 
	Top = 450, 
	Bottom = 670, 
	Right = 240
}

local OrbitalPosition = {
	Left = 30, 
	Top = 450, 
	Bottom = 670, 
	Right = 240
}

--#################################################################### 

-- Code for the Fire Support Manager

--#################################################################### 


local CreateFSButton = Class(Button){
    IconTextures = function(self, texture, texture2, texture3, path)
		self:SetTexture(texture)
		self.mNormal = texture 
        self.mActive = texture2
        self.mHighlight = texture3
        self.mDisabled = texture
		self.Depth:Set(15)
    end,
	
	OnClick = function(self, modifiers)
	LOG(Tacticalpoints)
	
	local Effects = {
		'crater01_albedo'
	}
	local ID = self.correspondedID
	local bp = __blueprints[ID]
	
	local Desc = bp.Description
	local Faction = bp.General.FactionName
	local Price = math.floor(bp.Economy.BuildCostMass)
	LOG('Price: ', Price)
	if Tacticalpoints >= StartTACPoints then
		if Tacticalpoints < Price then
			
		else
			Tacticalpoints = Tacticalpoints - Price
			local modeData = {
				cursor = 'RULEUCC_Attack',
				pingType = 'attack',
			}
			cmdMode.StartCommandMode("ping", modeData)
			function EndBehavior(mode, data)
				if mode == 'ping' and not data.isCancel then
					local position = GetMouseWorldPos()
					local flag = IsKeyDown('Shift')
					SimCallback({Func = 'SpawnFireSupport',Args = {id = ID, pos = position, yes = not flag, ArmyIndex = GetFocusArmy()}},true)
					ID = nil
				end
			end
			cmdMode.AddEndBehavior(EndBehavior)
		end
	end
	end,
	
	OnRolloverEvent = function(self, state) 
		local ID = self.correspondedID
		local bp = __blueprints[ID]
		local price = math.floor(bp.Economy.BuildCostMass)
		tostring(price)
		LOG('Price: ', price)
		local pricetext = 'Price: ' .. price
		local name = bp.General.UnitName
		local desc = bp.Description
		local fulldesc
		fulldesc = desc 
		infoboxtext:SetText(name)
		infoboxtext2:SetText(fulldesc)
		infoboxtext3:SetText(pricetext)
	    info:Show()
		infoboxtext:Show()
		infoboxtext2:Show()
		infoboxtext3:Show()
		info._closeBtn:Show()
	end
}

CreateDropTurretorDeviceButton = Class(Button){
    IconTextures = function(self, texture, texture2, texture3, path)
		self:SetTexture(texture)

		self.mNormal = texture 
        self.mActive = texture2
        self.mHighlight = texture3
        self.mDisabled = texture
		self.Depth:Set(15)
		
    end,
	
	OnClick = function(self, modifiers)
	
	local Effects = {
		'crater01_albedo'
	}
	local ID = self.correspondedID
	local bp = __blueprints[ID]
	
	local Desc = bp.Description
	local Faction = bp.General.FactionName
	local Price = math.floor(bp.Economy.BuildCostMass)
	local focusarmy = GetFocusArmy()
	local armyInfo = GetArmiesTable()
	LOG(Price)
	if Tacticalpoints >= StartTACPoints then
		if Tacticalpoints < Price then
			
		else
			Tacticalpoints = Tacticalpoints - Price
			local modeData = {
				cursor = 'RULEUCC_Transport',
				pingType = 'attack',
			}
			cmdMode.StartCommandMode("ping", modeData)
			function EndBehavior(mode, data)
				if mode == 'ping' and not data.isCancel then
					local position = GetMouseWorldPos()
					local flag = IsKeyDown('Shift')
					SimCallback({Func = 'SpawnDropTurretorDevice',Args = {id = ID, pos = position, yes = not flag, ArmyIndex = GetFocusArmy(), price = Price}},true)
					ID = nil
				end
			end
			cmdMode.AddEndBehavior(EndBehavior)
		end
	end
	end,
	
	OnRolloverEvent = function(self, state) 
		local ID = self.correspondedID
		local bp = __blueprints[ID]
		local Type = bp.General.Icon
		LOG('Type: ', Type)
		local TypeText
		if Type == 'land' then
			TypeText = 'Land only'
		elseif 	Type == 'amph' then
			TypeText = 'Land and Water'
		end
		local price = 'Price: ' .. math.floor(bp.Economy.BuildCostMass) .. '       Droppable above: ' .. TypeText
		local name = bp.General.UnitName
		local desc = bp.Description
		local fulldesc
		local Tech
		local Techlevel1 = EntityCategoryContains(categories.TECH1, ID)
		local Techlevel2 = EntityCategoryContains(categories.TECH2, ID)
		local Techlevel3 = EntityCategoryContains(categories.TECH3, ID)
		local Experimental = EntityCategoryContains(categories.EXPERIMENTALDROPCAPSULE, ID)
		local Experimental2 = EntityCategoryContains(categories.EXPERIMENTAL, ID)
		if Techlevel1 == true then
			Tech = 'Tech 1 '
		else		
		
		end
		if Techlevel2 == true then
			Tech = 'Tech 2 ' 
		else
		
		end
		if Techlevel3 == true then
			Tech = 'Tech 3 ' 
		else	
		
		end	
		if Experimental == true then
			Tech = '' 
		else	
		
		end	
		if Experimental2 == true then
			Tech = '' 
		else	
		
		end	
		if Experimental == true and Techlevel3 == true then
			Tech = '' 
		else	
		
		end		
		if name == nil then
		
		else
		if name:gsub("<LOC " .. ID .. "_name>","" ) == nil then 
		else 
			name = name:gsub("<LOC " .. ID .. "_name>","" ) 
			infoboxtext:SetText(name)
		end
		end
		if desc:gsub("<LOC " .. ID .. "_desc>","" ) == nil then
		
		else 
		   desc = desc:gsub("<LOC " .. ID .. "_desc>","" ) 
		end
		fulldesc = Tech .. desc 
		infoboxtext2:SetText(fulldesc)
		infoboxtext3:SetText(price)
	    info:Show()
		infoboxtext:Show()
		infoboxtext2:Show()
		infoboxtext3:Show()
		info._closeBtn:Show()
	end
}



local function increasedFSBorder(ui, scale)
	ui.Top:Set(ui.Top[1] - scale - 15)
	ui.Left:Set(ui.Left[1] - scale - 2)
	ui.Right:Set(ui.Right[1] + scale + 15)
	ui.Bottom:Set(ui.Bottom[1] + scale + 15)
end


local FSDefPosition = {
	Left = 20, -- 37
	Top = 320, 
	Bottom = 420, 
	Right = 335 -- 305
}

local FSASPosition = {
	Left = 20, 
	Top = 420, 
	Bottom = 720, 
	Right = 335
}

local FSArtPosition = {
	Left = 37, 
	Top = 450, 
	Bottom = 490, 
	Right = 305
}

local FSNavalPosition = {
	Left = 37, 
	Top = 550, 
	Bottom = 590, 
	Right = 305
}

local FSMissilePosition = {
	Left = 37, 
	Top = 650, 
	Bottom = 690, 
	Right = 305
}

local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	

FSDUI = CreateWindow(GetFrame(0),'Drop Turrets & Devices',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i,j in FSDefPosition do
	FSDUI[i]:Set(j)
end
local existed = {}
FSDUI.Images = {} 



ForkThread(
	function()
if Gametype == 'skirmish' then
if DropIncluded == 1 then
CreateDropUnits()
else
end
elseif Gametype == 'campaign_coop' then
if DropIncluded == 1 then
CreateDropUnits()
else
end
else
while true do
if FireSupportCampaignOptions == nil then

else

if FireSupportCampaignOptions[1] == 1 then
CreateDropUnits()
break
elseif FireSupportCampaignOptions[1] == 2 then
break
else
CreateDropUnits()
break
end
end
WaitSeconds(0.1)
end
end
end
)



CreateDropUnits = function()

if focusarmy >= 1 then
    if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
	for k,v in FSDUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	Level0 = {}
	Level1 = EntityCategoryGetUnitList(categories.DROPTURRET * categories.AEON)
	Level2 = EntityCategoryGetUnitList(categories.DROPSUPPLYDEVICE * categories.AEON)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		local bp = __blueprints[id]
		local Price = math.floor(bp.Economy.BuildCostMass)
		local PriceValue = tostring(Price)
		FSDUI.Images[c] = CreateDropTurretorDeviceButton(FSDUI)
		SetBtnTextures2(FSDUI.Images[c],id) 
		FSDUI.Images[c].correspondedID = id
		Text = CreateText(FSDUI)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		linkup2(array2(DPosition,x,FSDUI.Images[c],Text,existed),existed) 
		SetBtnTextures2(FSDUI.Images[c],id) 
		FSDUI.Images[c].correspondedID = id
		LOG(table.getn(FSDUI.Images))
	end
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
	for k,v in FSDUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	Level0 = {}
	Level1 = EntityCategoryGetUnitList(categories.DROPTURRET * categories.CYBRAN)
	Level2 = EntityCategoryGetUnitList(categories.DROPSUPPLYDEVICE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		local bp = __blueprints[id]
		local Price = math.floor(bp.Economy.BuildCostMass)
		local PriceValue = tostring(Price)
		FSDUI.Images[c] = CreateDropTurretorDeviceButton(FSDUI)
		SetBtnTextures2(FSDUI.Images[c],id) 
		FSDUI.Images[c].correspondedID = id
		Text = CreateText(FSDUI)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		linkup2(array2(DPosition3,x,FSDUI.Images[c],Text,existed),existed) 
		SetBtnTextures2(FSDUI.Images[c],id) 
		FSDUI.Images[c].correspondedID = id
		LOG(table.getn(FSDUI.Images))
	end
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
	for k,v in FSDUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	Level0 = {}
	Level1 = EntityCategoryGetUnitList(categories.DROPTURRET * categories.UEF)
	Level2 = EntityCategoryGetUnitList(categories.DROPSUPPLYDEVICE * categories.UEF)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		local bp = __blueprints[id]
		local Price = math.floor(bp.Economy.BuildCostMass)
		local PriceValue = tostring(Price)
		FSDUI.Images[c] = CreateDropTurretorDeviceButton(FSDUI)
		SetBtnTextures2(FSDUI.Images[c],id) 
		FSDUI.Images[c].correspondedID = id
		Text = CreateText(FSDUI)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		linkup2(array2(DPosition2,x,FSDUI.Images[c],Text,existed),existed) 
		SetBtnTextures2(FSDUI.Images[c],id) 
		FSDUI.Images[c].correspondedID = id
		LOG(table.getn(FSDUI.Images))
	end
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
	for k,v in FSDUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	Level0 = {}
	Level1 = EntityCategoryGetUnitList(categories.DROPTURRET * categories.SERAPHIM)
	Level2 = EntityCategoryGetUnitList(categories.DROPSUPPLYDEVICE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		local bp = __blueprints[id]
		local Price = math.floor(bp.Economy.BuildCostMass)
		local PriceValue = tostring(Price)
		FSDUI.Images[c] = CreateDropTurretorDeviceButton(FSDUI)
		SetBtnTextures2(FSDUI.Images[c],id) 
		FSDUI.Images[c].correspondedID = id
		Text = CreateText(FSDUI)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		linkup2(array2(DPosition3,x,FSDUI.Images[c],Text,existed),existed) 
		SetBtnTextures2(FSDUI.Images[c],id) 
		FSDUI.Images[c].correspondedID = id
		LOG(table.getn(FSDUI.Images))
	end
	existed = {}
	end
end

end


function CreateBarrage(ID)
LOG('Unit ID: ', ID)
local Effects = {
		'crater01_albedo'
	}
	local bp = __blueprints[ID]

	local Desc = bp.Description
	local Faction = bp.General.FactionName
	local Price = math.floor(bp.Economy.BuildCostMass)
	LOG('Price: ', Price)
	if Tacticalpoints >= StartTACPoints then
		if Tacticalpoints < Price then
			
		else
			Tacticalpoints = Tacticalpoints - Price
			local modeData = {
				cursor = 'RULEUCC_Attack',
				pingType = 'attack',
			}
			cmdMode.StartCommandMode("ping", modeData)
			function EndBehavior(mode, data)
				if mode == 'ping' and not data.isCancel then
					local position = GetMouseWorldPos()
					local flag = IsKeyDown('Shift')
					SimCallback({Func = 'SpawnFireSupport',Args = {id = ID, pos = position, yes = not flag, ArmyIndex = GetFocusArmy()}},true)
					ID = nil
				end
			end
			cmdMode.AddEndBehavior(EndBehavior)
		end
	end
end 

function CreateBarrageOnHover(ID)
		LOG('Unit ID: ', ID)
		local bp = __blueprints[ID]
		local Type = bp.General.Icon
		local price = math.floor(bp.Economy.BuildCostMass)
		tostring(price)
		LOG('Price: ', price)
		local TypeText
		if Type == 'air' then
			TypeText = 'Land and Water'
		end
		local pricetext = 'Price: ' .. price .. '       Callable above: ' .. TypeText
		local name = bp.General.UnitName
		local desc = bp.Description
		local fulldesc
		fulldesc = desc 
		infoboxtext:SetText(name)
		infoboxtext2:SetText(fulldesc)
		infoboxtext3:SetText(pricetext)
	    info:Show()
		infoboxtext:Show()
		infoboxtext2:Show()
		infoboxtext3:Show()
		info._closeBtn:Show()
end


function CreateAirStrike(ID, value)
LOG('Unit ID: ', ID)
local Effects = {
		'crater01_albedo'
	}
	local bp = __blueprints[ID]

	local Desc = bp.Description
	local Faction = bp.General.FactionName
	local Price = 0
	if ID == 'uafsas1001' or ID == 'uefsas1001' or ID == 'urfsas1001' or ID == 'xsfsas1001' then			
			if value == 1 then
				Price = 90
			end
			if value == 2 then
				Price = 180
			end
			if value == 3 then
				Price = 270
			end
			if value == 4 then
				Price = 360
			end
			if value == 5 then
				Price = 450
			end
			if value == 6 then
				Price = 540
			end
			if value == 7 then
				Price = 630
			end
			if value == 8 then
				Price = 720
			end
			if value == 9 then
				Price = 810
			end
			if value == 10 then
				Price = 900
			end
			if value == 11 then
				Price = 990
			end
			if value == 12 then
				Price = 1080
			end
			if value == 13 then
				Price = 1170
			end
			if value == 14 then
				Price = 1260
			end
			if value == 15 then
				Price = 1350
			end
	elseif ID == 'uafsas2001' or ID == 'uefsas2001' or ID == 'urfsas2001' or ID == 'xsfsas2001' then			
			if value == 1 then
				Price = 90
			end
			if value == 2 then
				Price = 180
			end
			if value == 3 then
				Price = 270
			end
			if value == 4 then
				Price = 360
			end
			if value == 5 then
				Price = 450
			end
			if value == 6 then
				Price = 540
			end
			if value == 7 then
				Price = 630
			end
			if value == 8 then
				Price = 720
			end
			if value == 9 then
				Price = 810
			end
			if value == 10 then
				Price = 900
			end
			if value == 11 then
				Price = 990
			end
			if value == 12 then
				Price = 1080
			end
			if value == 13 then
				Price = 1170
			end
			if value == 14 then
				Price = 1260
			end
			if value == 15 then
				Price = 1350
			end	
	elseif ID == 'uafsas3001' or ID == 'uefsas3001' or ID == 'urfsas3001' or ID == 'xsfsas3001' then			
			if value == 1 then
				Price = 90
			end
			if value == 2 then
				Price = 180
			end
			if value == 3 then
				Price = 270
			end
			if value == 4 then
				Price = 360
			end
			if value == 5 then
				Price = 450
			end
			if value == 6 then
				Price = 540
			end
			if value == 7 then
				Price = 630
			end
			if value == 8 then
				Price = 720
			end
			if value == 9 then
				Price = 810
			end
			if value == 10 then
				Price = 900
			end
			if value == 11 then
				Price = 990
			end
			if value == 12 then
				Price = 1080
			end
			if value == 13 then
				Price = 1170
			end
			if value == 14 then
				Price = 1260
			end
			if value == 15 then
				Price = 1350
			end	
	elseif ID == 'uafsas4001' or ID == 'uefsas4001' or ID == 'urfsas4001' or ID == 'xsfsas4001' then			
			if value == 1 then
				Price = 90
			end
			if value == 2 then
				Price = 180
			end
			if value == 3 then
				Price = 270
			end
			if value == 4 then
				Price = 360
			end
			if value == 5 then
				Price = 450
			end
			if value == 6 then
				Price = 540
			end
			if value == 7 then
				Price = 630
			end
			if value == 8 then
				Price = 720
			end
			if value == 9 then
				Price = 810
			end
			if value == 10 then
				Price = 900
			end
			if value == 11 then
				Price = 990
			end
			if value == 12 then
				Price = 1080
			end
			if value == 13 then
				Price = 1170
			end
			if value == 14 then
				Price = 1260
			end
			if value == 15 then
				Price = 1350
			end			
	elseif ID == 'uefsas5001' then
	LOG('Test: ', ID)
			if value == 1 then
				Price = 700
			end
			if value == 2 then
				Price = 1400
			end
			if value == 3 then
				Price = 2100
			end
	elseif ID == 'uefsas6001' then
	LOG('Test: ', ID)
			if value == 1 then
				Price = 800
			end
			if value == 2 then
				Price = 1600
			end
			if value == 3 then
				Price = 2400
			end
	elseif ID == 'uafsas7001' or ID == 'uefsas7001' or ID == 'urfsas7001' or ID == 'xsfsas7001' then		
			if value == 1 then
				Price = 250
			end
			if value == 2 then
				Price = 500
			end
			if value == 3 then
				Price = 750
			end
	elseif ID == 'uafsas8001' or ID == 'uefsas8001' or ID == 'urfsas8001' or ID == 'xsfsas8001' then			
			if value == 1 then
				Price = 90
			end
			if value == 2 then
				Price = 180
			end
			if value == 3 then
				Price = 270
			end
			if value == 4 then
				Price = 360
			end
			if value == 5 then
				Price = 450
			end
			if value == 6 then
				Price = 540
			end
			if value == 7 then
				Price = 630
			end
			if value == 8 then
				Price = 720
			end
			if value == 9 then
				Price = 810
			end
			if value == 10 then
				Price = 900
			end
			if value == 11 then
				Price = 990
			end
			if value == 12 then
				Price = 1080
			end
			if value == 13 then
				Price = 1170
			end
			if value == 14 then
				Price = 1260
			end
			if value == 15 then
				Price = 1350
			end
	elseif ID == 'uafsas9001' or ID == 'uefsas9001' or ID == 'urfsas9001' or ID == 'xsfsas9001' then			
			if value == 1 then
				Price = 90
			end
			if value == 2 then
				Price = 180
			end
			if value == 3 then
				Price = 270
			end
			if value == 4 then
				Price = 360
			end
			if value == 5 then
				Price = 450
			end
			if value == 6 then
				Price = 540
			end
			if value == 7 then
				Price = 630
			end
			if value == 8 then
				Price = 720
			end
			if value == 9 then
				Price = 810
			end
			if value == 10 then
				Price = 900
			end
			if value == 11 then
				Price = 990
			end
			if value == 12 then
				Price = 1080
			end
			if value == 13 then
				Price = 1170
			end
			if value == 14 then
				Price = 1260
			end
			if value == 15 then
				Price = 1350
			end
	elseif ID == 'uafsas10001' or ID == 'uefsas10001' or ID == 'urfsas10001' or ID == 'xsfsas10001' then		
			if value == 1 then
				Price = 250
			end
			if value == 2 then
				Price = 500
			end
			if value == 3 then
				Price = 750
			end
	elseif ID == 'uafsasex1' or ID == 'uefsasex1' or ID == 'urfsasex1' or ID == 'xsfsasex1' then		
			if value == 1 then
				Price = 2500
			end
	else
			if value == 1 then
				Price = 90
			end
			if value == 2 then
				Price = 180
			end
			if value == 3 then
				Price = 270
			end
			if value == 4 then
				Price = 360
			end
			if value == 5 then
				Price = 450
			end
			if value == 6 then
				Price = 540
			end
			if value == 7 then
				Price = 630
			end
			if value == 8 then
				Price = 720
			end
			if value == 9 then
				Price = 810
			end
			if value == 10 then
				Price = 900
			end
			if value == 11 then
				Price = 990
			end
			if value == 12 then
				Price = 1080
			end
			if value == 13 then
				Price = 1170
			end
			if value == 14 then
				Price = 1260
			end
			if value == 15 then
				Price = 1350
			end
			end	
	LOG('Price: ', Price)
	if Tacticalpoints >= StartTACPoints then
		if Tacticalpoints < Price then
			
		else
			Tacticalpoints = Tacticalpoints - Price
			local modeData = {
				cursor = 'RULEUCC_Attack',
				pingType = 'attack',
			}
			cmdMode.StartCommandMode("ping", modeData)
			function EndBehavior(mode, data)
				if mode == 'ping' and not data.isCancel then
					local position = GetMouseWorldPos()
					local flag = IsKeyDown('Shift')
					SimCallback({Func = 'SpawnAirStrike',Args = {id = ID, pos = position, amount = value, yes = not flag, ArmyIndex = GetFocusArmy()}},true)
					ID = nil
				end
			end
			cmdMode.AddEndBehavior(EndBehavior)
		end
	end
end 

function CreateAirStrikeOnHover(ID,value)
		LOG('Unit ID: ', ID)
		local bp = __blueprints[ID]
		local Type = bp.General.Icon
		local price = 0
		if ID == 'uafsas1001' or ID == 'uefsas1001' or ID == 'urfsas1001' or ID == 'xsfsas1001' then	
			if value == 1 then
				price = 90
			end
			if value == 2 then
				price = 180
			end
			if value == 3 then
				price = 270
			end
			if value == 4 then
				price = 360
			end
			if value == 5 then
				price = 450
			end
			if value == 6 then
				price = 540
			end
			if value == 7 then
				price = 630
			end
			if value == 8 then
				price = 720
			end
			if value == 9 then
				price = 810
			end
			if value == 10 then
				price = 900
			end
			if value == 11 then
				price = 990
			end
			if value == 12 then
				price = 1080
			end
			if value == 13 then
				price = 1170
			end
			if value == 14 then
				price = 1260
			end
			if value == 15 then
				price = 1350
			end
	elseif ID == 'uafsas2001' or ID == 'uefsas2001' or ID == 'urfsas2001' or ID == 'xsfsas2001' then	
			if value == 1 then
				price = 90
			end
			if value == 2 then
				price = 180
			end
			if value == 3 then
				price = 270
			end
			if value == 4 then
				price = 360
			end
			if value == 5 then
				price = 450
			end
			if value == 6 then
				price = 540
			end
			if value == 7 then
				price = 630
			end
			if value == 8 then
				price = 720
			end
			if value == 9 then
				price = 810
			end
			if value == 10 then
				price = 900
			end
			if value == 11 then
				price = 990
			end
			if value == 12 then
				price = 1080
			end
			if value == 13 then
				price = 1170
			end
			if value == 14 then
				price = 1260
			end
			if value == 15 then
				price = 1350
			end	
	elseif ID == 'uafsas3001' or ID == 'uefsas3001' or ID == 'urfsas3001' or ID == 'xsfsas3001' then	
			if value == 1 then
				price = 90
			end
			if value == 2 then
				price = 180
			end
			if value == 3 then
				price = 270
			end
			if value == 4 then
				price = 360
			end
			if value == 5 then
				price = 450
			end
			if value == 6 then
				price = 540
			end
			if value == 7 then
				price = 630
			end
			if value == 8 then
				price = 720
			end
			if value == 9 then
				price = 810
			end
			if value == 10 then
				price = 900
			end
			if value == 11 then
				price = 990
			end
			if value == 12 then
				price = 1080
			end
			if value == 13 then
				price = 1170
			end
			if value == 14 then
				price = 1260
			end
			if value == 15 then
				price = 1350
			end	
	elseif ID == 'uafsas4001' or ID == 'uefsas4001' or ID == 'urfsas4001' or ID == 'xsfsas4001' then	
			if value == 1 then
				price = 90
			end
			if value == 2 then
				price = 180
			end
			if value == 3 then
				price = 270
			end
			if value == 4 then
				price = 360
			end
			if value == 5 then
				price = 450
			end
			if value == 6 then
				price = 540
			end
			if value == 7 then
				price = 630
			end
			if value == 8 then
				price = 720
			end
			if value == 9 then
				price = 810
			end
			if value == 10 then
				price = 900
			end
			if value == 11 then
				price = 990
			end
			if value == 12 then
				price = 1080
			end
			if value == 13 then
				price = 1170
			end
			if value == 14 then
				price = 1260
			end
			if value == 15 then
				price = 1350
			end		
	elseif ID == 'uefsas5001' then
	LOG('Test: ', ID)
			if value == 1 then
				price = 700
			end
			if value == 2 then
				price = 1400
			end
			if value == 3 then
				price = 2100
			end
	elseif ID == 'uefsas6001' then
	LOG('Test: ', ID)
			if value == 1 then
				price = 800
			end
			if value == 2 then
				price = 1600
			end
			if value == 3 then
				price = 2400
			end
	elseif ID == 'uafsas7001' or ID == 'uefsas7001' or ID == 'urfsas7001' or ID == 'xsfsas7001' then		
			if value == 1 then
				price = 250
			end
			if value == 2 then
				price = 500
			end
			if value == 3 then
				price = 750
			end	
	elseif ID == 'uafsas8001' or ID == 'uefsas8001' or ID == 'urfsas8001' or ID == 'xsfsas8001' then	
			if value == 1 then
				price = 90
			end
			if value == 2 then
				price = 180
			end
			if value == 3 then
				price = 270
			end
			if value == 4 then
				price = 360
			end
			if value == 5 then
				price = 450
			end
			if value == 6 then
				price = 540
			end
			if value == 7 then
				price = 630
			end
			if value == 8 then
				price = 720
			end
			if value == 9 then
				price = 810
			end
			if value == 10 then
				price = 900
			end
			if value == 11 then
				price = 990
			end
			if value == 12 then
				price = 1080
			end
			if value == 13 then
				price = 1170
			end
			if value == 14 then
				price = 1260
			end
			if value == 15 then
				price = 1350
			end
	elseif ID == 'uafsas9001' or ID == 'uefsas9001' or ID == 'urfsas9001' or ID == 'xsfsas9001' then	
			if value == 1 then
				price = 90
			end
			if value == 2 then
				price = 180
			end
			if value == 3 then
				price = 270
			end
			if value == 4 then
				price = 360
			end
			if value == 5 then
				price = 450
			end
			if value == 6 then
				price = 540
			end
			if value == 7 then
				price = 630
			end
			if value == 8 then
				price = 720
			end
			if value == 9 then
				price = 810
			end
			if value == 10 then
				price = 900
			end
			if value == 11 then
				price = 990
			end
			if value == 12 then
				price = 1080
			end
			if value == 13 then
				price = 1170
			end
			if value == 14 then
				price = 1260
			end
			if value == 15 then
				price = 1350
			end
	elseif ID == 'uafsas10001' or ID == 'uefsas10001' or ID == 'urfsas10001' or ID == 'xsfsas10001' then		
			if value == 1 then
				price = 250
			end
			if value == 2 then
				price = 500
			end
			if value == 3 then
				price = 750
			end	
	elseif ID == 'uafsasex1' or ID == 'uefsasex1' or ID == 'urfsasex1' or ID == 'xsfsasex1' then		
			if value == 1 then
				price = 2500
			end			
	else
			if value == 1 then
				price = 90
			end
			if value == 2 then
				price = 180
			end
			if value == 3 then
				price = 270
			end
			if value == 4 then
				price = 360
			end
			if value == 5 then
				price = 450
			end
			if value == 6 then
				price = 540
			end
			if value == 7 then
				price = 630
			end
			if value == 8 then
				price = 720
			end
			if value == 9 then
				price = 810
			end
			if value == 10 then
				price = 900
			end
			if value == 11 then
				price = 990
			end
			if value == 12 then
				price = 1080
			end
			if value == 13 then
				price = 1170
			end
			if value == 14 then
				price = 1260
			end
			if value == 15 then
				price = 1350
			end
		end	
		tostring(price)
		LOG('Price: ', price)
		local TypeText
		if Type == 'sea' then
			TypeText = 'Water only'
		elseif 	Type == 'amph' then
			TypeText = 'Land and Water'
		end
		local pricetext = 'Price: ' .. price .. '       Callable above: ' .. TypeText
		local name = bp.General.UnitName
		local desc = bp.Description
		local fulldesc
		fulldesc = desc 
		infoboxtext:SetText(name)
		infoboxtext2:SetText(fulldesc)
		infoboxtext3:SetText(pricetext)
	    info:Show()
		infoboxtext:Show()
		infoboxtext2:Show()
		infoboxtext3:Show()
		info._closeBtn:Show()
end

local AirStrikes = nil

ForkThread(
	function()
if Gametype == 'skirmish' then
if AirStrikesInclude == 1 then

else
HideAirStrikes()
end
elseif Gametype == 'campaign_coop' then
if AirStrikesInclude == 1 then

else
HideAirStrikes()
end
else
while true do
if FireSupportCampaignOptions == nil then

else

if FireSupportCampaignOptions[5] == 1 then

break
elseif FireSupportCampaignOptions[5] == 2 then
HideAirStrikes()

break
else

end
end
WaitSeconds(0.1)
end
end
end
)

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

HideAirStrikes = function()
ForkThread(
	function()
	while true do
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')
LayoutHelpers.DepthOverParent(asfwbutton, FSAS1UI, 0)
LayoutHelpers.DepthOverParent(asbbbutton, FSAS2UI, 0)
LayoutHelpers.DepthOverParent(airstrike1, FSAS1UI, 0)
LayoutHelpers.DepthOverParent(airstrike2, FSAS2UI, 0)
LayoutHelpers.DepthOverParent(airstrike3, FSAS3UI, 0)
LayoutHelpers.DepthOverParent(AS1Slider, FSAS1UI, 0)
LayoutHelpers.DepthOverParent(AS2Slider, FSAS2UI, 0)
LayoutHelpers.DepthOverParent(AS3Slider, FSAS3UI, 0)
LayoutHelpers.DepthOverParent(as1onebuttonlrg, FSAS1UI, 0)
LayoutHelpers.DepthOverParent(as2onebuttonlrg, FSAS2UI, 0)
LayoutHelpers.DepthOverParent(as3onebuttonlrg, FSAS3UI, 0)
WaitSeconds(0.01)
end
end
)
end

FSASUI = CreateWindow(GetFrame(0),'Air Strikes',nil,false,false,true,true,'Reinforcements',Position,Border) 
FSAS1UI = CreateWindow(FSASUI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
FSAS2UI = CreateWindow(FSASUI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
FSAS3UI = CreateWindow(FSASUI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
--as1onebuttonlrg = UIUtil.CreateButtonStd(FSAS1UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
--as2onebuttonlrg = UIUtil.CreateButtonStd(FSAS2UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
--as3onebuttonlrg = UIUtil.CreateButtonStd(FSAS3UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
FSAS1UI._closeBtn:Hide()
FSAS2UI._closeBtn:Hide()
FSAS3UI._closeBtn:Hide()
for i,j in FSASPosition do
	FSASUI[i]:Set(j)
end

local FSAS1Position = {
	Left = 30, 
	Top = 445, 
	Bottom = 530, 
	Right = 325
}

local FSAS2Position = {
	Left = 30, 
	Top = 530, 
	Bottom = 618, 
	Right = 325
}

local FSAS3Position = {
	Left = 30, 
	Top = 618, 
	Bottom = 708, 
	Right = 325
}

for i,j in FSAS1Position do
	FSAS1UI[i]:Set(j)
end

for i,j in FSAS2Position do
	FSAS2UI[i]:Set(j)
end

for i,j in FSAS3Position do
	FSAS3UI[i]:Set(j)
end

local FSAS1PicPosition = {
	Left = 69, 
	Top = 467, 
	Bottom = 525, 
	Right = 316
}

local FSAS2PicPosition = {
	Left = 69, 
	Top = 554, 
	Bottom = 613, 
	Right = 316
}

local FSAS3PicPosition = {
	Left = 69, 
	Top = 642, 
	Bottom = 703, 
	Right = 316
}

local Button1lrgPosition = {
	Left = 35, 
	Top = 446, 
	Bottom = 526, 
	Right = 69
}

local Button2lrgPosition = {
	Left = 35, 
	Top = 533, 
	Bottom = 613, 
	Right = 69
}

local Button3lrgPosition = {
	Left = 35, 
	Top = 621, 
	Bottom = 701, 
	Right = 69
}

local Button1Position = {
	Left = 35, 
	Top = 446, 
	Bottom = 466, 
	Right = 69
}

local Button2Position = {
	Left = 35, 
	Top = 466, 
	Bottom = 486, 
	Right = 69
}

local Button3Position = {
	Left = 35, 
	Top = 486, 
	Bottom = 506, 
	Right = 69
}

local Button4Position = {
	Left = 35, 
	Top = 506, 
	Bottom = 526, 
	Right = 69
}

local Button5Position = {
	Left = 35, 
	Top = 533, 
	Bottom = 553, 
	Right = 69
}

local Button6Position = {
	Left = 35, 
	Top = 553, 
	Bottom = 573, 
	Right = 69
}

local Button7Position = {
	Left = 35, 
	Top = 573, 
	Bottom = 593, 
	Right = 69
}

local Button8Position = {
	Left = 35, 
	Top = 593, 
	Bottom = 613, 
	Right = 69
}

local Button9Position = {
	Left = 35, 
	Top = 621, 
	Bottom = 641, 
	Right = 69
}

local Button10Position = {
	Left = 35, 
	Top = 641, 
	Bottom = 661, 
	Right = 69
}

local Button11Position = {
	Left = 35, 
	Top = 661, 
	Bottom = 681, 
	Right = 69
}

local Button12Position = {
	Left = 35, 
	Top = 681, 
	Bottom = 701, 
	Right = 69
}

local asbbButtonPosition = {
	Left = 270, 
	Top = 425, 
	Bottom = 445, 
	Right = 290
}

local asfwButtonPosition = {
	Left = 290, 
	Top = 425, 
	Bottom = 445, 
	Right = 310
}



AS1Slider = Slider(FSAS1UI, false,1, 15, UIUtil.SkinnableFile('/slider02/slider_btn_up.dds'), UIUtil.SkinnableFile('/slider02/slider_btn_over.dds'), UIUtil.SkinnableFile('/slider02/slider_btn_down.dds'), UIUtil.SkinnableFile('/slider02/slider-back_bmp.dds'))  
AS2Slider = Slider(FSAS2UI, false,1, 15, UIUtil.SkinnableFile('/slider02/slider_btn_up.dds'), UIUtil.SkinnableFile('/slider02/slider_btn_over.dds'), UIUtil.SkinnableFile('/slider02/slider_btn_down.dds'), UIUtil.SkinnableFile('/slider02/slider-back_bmp.dds'))  
AS3Slider = Slider(FSAS3UI, false,1, 15, UIUtil.SkinnableFile('/slider02/slider_btn_up.dds'), UIUtil.SkinnableFile('/slider02/slider_btn_over.dds'), UIUtil.SkinnableFile('/slider02/slider_btn_down.dds'), UIUtil.SkinnableFile('/slider02/slider-back_bmp.dds'))  

AS1SliderText = CreateText(FSAS1UI)	
AS1SliderText:SetFont('Arial',11) 
AS1SliderText:SetColor('FFbadbdb')

AS2SliderText = CreateText(FSAS2UI)	
AS2SliderText:SetFont('Arial',11) 
AS2SliderText:SetColor('FFbadbdb')

AS3SliderText = CreateText(FSAS3UI)	
AS3SliderText:SetFont('Arial',11) 
AS3SliderText:SetColor('FFbadbdb')

ForkThread(
function()
while true do
AS1SliderText:SetText(math.floor(AS1Slider:GetValue()))
AS2SliderText:SetText(math.floor(AS2Slider:GetValue()))
AS3SliderText:SetText(math.floor(AS3Slider:GetValue()))
AS1SliderText.Depth:Set(30)
AS2SliderText.Depth:Set(30)
AS3SliderText.Depth:Set(30)
WaitSeconds(0.1)
end
end)



local AS1SliderPosition = {
	Left = 70, 
	Top = 446, 
	Bottom = 466, 
	Right = 270
}

local AS2SliderPosition = {
	Left = 70, 
	Top = 533, 
	Bottom = 553, 
	Right = 270
}

local AS3SliderPosition = {
	Left = 70, 
	Top = 621, 
	Bottom = 641, 
	Right = 270
}

local AS1SliderTextPosition = {
	Left = 270, 
	Top = 446, 
	Bottom = 466, 
	Right = 275
}

local AS2SliderTextPosition = {
	Left = 270, 
	Top = 533, 
	Bottom = 553, 
	Right = 275
}

local AS3SliderTextPosition = {
	Left = 270, 
	Top = 621, 
	Bottom = 641, 
	Right = 275
}

--[[
for i,j in Button1lrgPosition do
	as1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	as2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	as3onebuttonlrg[i]:Set(j)
end
]]--

local asfwbuttonpress = 0
local asbbbuttonpress = 0

if focusarmy >= 1 then
    if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

airstrike1 = Bitmap(FSAS1UI, '/mods/Commander Survival Kit/textures/aeonairstrike1.dds')
airstrike2 = Bitmap(FSAS2UI, '/mods/Commander Survival Kit/textures/aeonairstrike2.dds')
airstrike3 = Bitmap(FSAS3UI, '/mods/Commander Survival Kit/textures/aeonairstrike3.dds')
as1onebuttonlrg = UIUtil.CreateButtonStd(FSAS1UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', nil, 13, 5, -82)
as2onebuttonlrg = UIUtil.CreateButtonStd(FSAS2UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', nil, 13, 5, -82)
as3onebuttonlrg = UIUtil.CreateButtonStd(FSAS3UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', nil, 13, 5, -82)

for i,j in FSAS1PicPosition do
	airstrike1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	airstrike2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	airstrike3[i]:Set(j)
end

for i,j in AS1SliderPosition do
	AS1Slider[i]:Set(j)
end

for i,j in AS2SliderPosition do
	AS2Slider[i]:Set(j)
end

for i,j in AS3SliderPosition do
	AS3Slider[i]:Set(j)
end

for i,j in AS1SliderTextPosition do
	AS1SliderText[i]:Set(j)
end

for i,j in AS2SliderTextPosition do
	AS2SliderText[i]:Set(j)
end

for i,j in AS3SliderTextPosition do
	AS3SliderText[i]:Set(j)
end

for i,j in Button1lrgPosition do
	as1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	as2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	as3onebuttonlrg[i]:Set(j)
end

--[[
Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)
Tooltip.AddButtonTooltip(as1fifteenbutton, "asbfifteenBtn", 1)
Tooltip.AddButtonTooltip(as2onebutton, "asboneBtn", 1)
Tooltip.AddButtonTooltip(as2fivebutton, "asbfiveBtn", 1)
Tooltip.AddButtonTooltip(as2tenbutton, "asbtenBtn", 1)
Tooltip.AddButtonTooltip(as2fifteenbutton, "asbfifteenBtn", 1)
Tooltip.AddButtonTooltip(as3onebutton, "asboneBtn", 1)
Tooltip.AddButtonTooltip(as3fivebutton, "asbfiveBtn", 1)
Tooltip.AddButtonTooltip(as3tenbutton, "asbtenBtn", 1)
Tooltip.AddButtonTooltip(as3fifteenbutton, "asbfifteenBtn", 1)
]]--

LayoutHelpers.DepthOverParent(airstrike1, FSAS1UI, 10)
LayoutHelpers.DepthOverParent(airstrike2, FSAS2UI, 10)
LayoutHelpers.DepthOverParent(airstrike3, FSAS3UI, 10)
LayoutHelpers.DepthOverParent(AS1Slider, FSAS1UI, 10)
LayoutHelpers.DepthOverParent(AS2Slider, FSAS2UI, 10)
LayoutHelpers.DepthOverParent(AS3Slider, FSAS3UI, 10)
LayoutHelpers.DepthOverParent(as1onebuttonlrg, FSAS1UI, 10)
LayoutHelpers.DepthOverParent(as2onebuttonlrg, FSAS2UI, 10)
LayoutHelpers.DepthOverParent(as3onebuttonlrg, FSAS3UI, 10)

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end

as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end

as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end



asfwbutton = UIUtil.CreateButtonStd(FSASUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', ">", 13, -23, -88)
asbbbutton = UIUtil.CreateButtonStd(FSASUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "<", 13, -23, -88)


for i,j in asfwButtonPosition do
	asfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	asbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(asfwbutton, FSASUI, 10)
LayoutHelpers.DepthOverParent(asbbbutton, FSASUI, 10)


asfwbutton.OnClick = function(self)

asfwbuttonpress = asfwbuttonpress + 1
if asfwbuttonpress == 1 then
asbbbuttonpress = 2
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/aeonairstrike4.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/aeontorpedoairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/aeonpgairstrike.dds')

AS1Slider:SetEndValue(3) 
AS3Slider:SetEndValue(3) 



as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end


as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end


end
if asfwbuttonpress == 2 then
asbbbuttonpress = 1
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/aeongroundairstrike.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/aeonhgroundairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/aeonexairstrike.dds')

AS1Slider:SetEndValue(15) 
AS2Slider:SetEndValue(15)
AS3Slider:SetEndValue(15) 

--FSAS2UI:Hide()
--FSAS3UI:Hide()

if ExAirStrikesInclude == 1 then
FSAS3UI:Show()
FSAS3UI._closeBtn:Hide()
AS3Slider:Hide()
AS3SliderText:Hide()
else
FSAS3UI:Hide()
end

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.AEON)
CreateAirStrike(ID[1], 1)
end


as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], 1)
end


end
if asfwbuttonpress == 3 then


asbbbuttonpress = 0
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/aeonairstrike1.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/aeonairstrike2.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/aeonairstrike3.dds')

--[[
FSAS2UI:Show()
FSAS3UI:Show()
FSAS2UI._closeBtn:Hide()
FSAS3UI._closeBtn:Hide()
]]--

AS3Slider:Show()
AS3SliderText:Show()

AS1Slider:SetEndValue(15) 
AS3Slider:SetEndValue(15) 

if ExAirStrikesInclude == 1 then

else
FSAS3UI:Show()
FSAS3UI._closeBtn:Hide()
end

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end



asfwbuttonpress = 0
end

end

asbbbutton.OnClick = function(self)

asbbbuttonpress = asbbbuttonpress + 1

if asbbbuttonpress == 1 then
asfwbuttonpress = 2
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/aeongroundairstrike.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/aeonhgroundairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/aeonexairstrike.dds')

AS1Slider:SetEndValue(15) 
AS2Slider:SetEndValue(15)
AS3Slider:SetEndValue(15) 

--FSAS2UI:Hide()
--FSAS3UI:Hide()

if ExAirStrikesInclude == 1 then
FSAS3UI:Show()
FSAS3UI._closeBtn:Hide()
AS3Slider:Hide()
AS3SliderText:Hide()
else
FSAS3UI:Hide()
end

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.AEON)
CreateAirStrike(ID[1], 1)
end


as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], 1)
end


end

if asbbbuttonpress == 2 then
asfwbuttonpress = 1
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/aeonairstrike4.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/aeontorpedoairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/aeonpgairstrike.dds')

AS1Slider:SetEndValue(3) 
AS3Slider:SetEndValue(3) 

AS3Slider:Show()
AS3SliderText:Show()

--[[
FSAS2UI:Show()
FSAS3UI:Show()
FSAS2UI._closeBtn:Hide()
FSAS3UI._closeBtn:Hide()
]]--

if ExAirStrikesInclude == 1 then

else
FSAS3UI:Show()
FSAS3UI._closeBtn:Hide()
end

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end


as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end

end


if asbbbuttonpress == 3 then
asfwbuttonpress = 0
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/aeonairstrike1.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/aeonairstrike2.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/aeonairstrike3.dds')

AS1Slider:SetEndValue(15) 
AS3Slider:SetEndValue(15) 


as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.AEON)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.AEON)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end

asbbbuttonpress = 0

end

end

Tooltip.AddButtonTooltip(asfwbutton, "ASFWtn", 1)
Tooltip.AddButtonTooltip(asbbbutton, "ASBBtn", 1)

	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--


airstrike1 = Bitmap(FSAS1UI, '/mods/Commander Survival Kit/textures/cybranairstrike1.dds')
airstrike2 = Bitmap(FSAS2UI, '/mods/Commander Survival Kit/textures/cybranairstrike2.dds')
airstrike3 = Bitmap(FSAS3UI, '/mods/Commander Survival Kit/textures/cybranairstrike3.dds')
as1onebuttonlrg = UIUtil.CreateButtonStd(FSAS1UI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', nil, 13, 5, -82)
as2onebuttonlrg = UIUtil.CreateButtonStd(FSAS2UI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', nil, 13, 5, -82)
as3onebuttonlrg = UIUtil.CreateButtonStd(FSAS3UI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', nil, 13, 5, -82)


for i,j in FSAS1PicPosition do
	airstrike1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	airstrike2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	airstrike3[i]:Set(j)
end

for i,j in AS1SliderPosition do
	AS1Slider[i]:Set(j)
end

for i,j in AS2SliderPosition do
	AS2Slider[i]:Set(j)
end

for i,j in AS3SliderPosition do
	AS3Slider[i]:Set(j)
end

for i,j in AS1SliderTextPosition do
	AS1SliderText[i]:Set(j)
end

for i,j in AS2SliderTextPosition do
	AS2SliderText[i]:Set(j)
end

for i,j in AS3SliderTextPosition do
	AS3SliderText[i]:Set(j)
end

for i,j in Button1lrgPosition do
	as1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	as2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	as3onebuttonlrg[i]:Set(j)
end

--[[
Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)
Tooltip.AddButtonTooltip(as1fifteenbutton, "asbfifteenBtn", 1)
Tooltip.AddButtonTooltip(as2onebutton, "asboneBtn", 1)
Tooltip.AddButtonTooltip(as2fivebutton, "asbfiveBtn", 1)
Tooltip.AddButtonTooltip(as2tenbutton, "asbtenBtn", 1)
Tooltip.AddButtonTooltip(as2fifteenbutton, "asbfifteenBtn", 1)
Tooltip.AddButtonTooltip(as3onebutton, "asboneBtn", 1)
Tooltip.AddButtonTooltip(as3fivebutton, "asbfiveBtn", 1)
Tooltip.AddButtonTooltip(as3tenbutton, "asbtenBtn", 1)
Tooltip.AddButtonTooltip(as3fifteenbutton, "asbfifteenBtn", 1)
]]--

LayoutHelpers.DepthOverParent(airstrike1, FSAS1UI, 10)
LayoutHelpers.DepthOverParent(airstrike2, FSAS2UI, 10)
LayoutHelpers.DepthOverParent(airstrike3, FSAS3UI, 10)
LayoutHelpers.DepthOverParent(AS1Slider, FSAS1UI, 10)
LayoutHelpers.DepthOverParent(AS2Slider, FSAS2UI, 10)
LayoutHelpers.DepthOverParent(AS3Slider, FSAS3UI, 10)
LayoutHelpers.DepthOverParent(as1onebuttonlrg, FSAS1UI, 10)
LayoutHelpers.DepthOverParent(as2onebuttonlrg, FSAS2UI, 10)
LayoutHelpers.DepthOverParent(as3onebuttonlrg, FSAS3UI, 10)


as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end

as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end

as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end

asfwbutton = UIUtil.CreateButtonStd(FSASUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', ">", 13, -23, -88)
asbbbutton = UIUtil.CreateButtonStd(FSASUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "<", 13, -23, -88)

for i,j in asfwButtonPosition do
	asfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	asbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(asfwbutton, FSASUI, 10)
LayoutHelpers.DepthOverParent(asbbbutton, FSASUI, 10)


asfwbutton.OnClick = function(self)

asfwbuttonpress = asfwbuttonpress + 1
if asfwbuttonpress == 1 then
asbbbuttonpress = 2
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/cybranairstrike4.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/cybrantorpedoairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/cybranpgairstrike.dds')

AS1Slider:SetEndValue(3) 
AS3Slider:SetEndValue(3) 



as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end


as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end


end

if asfwbuttonpress == 2 then


asbbbuttonpress = 1
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/cybrangroundairstrike.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/cybranhgroundairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/cybranexairstrike.dds')

AS1Slider:SetEndValue(15) 
AS2Slider:SetEndValue(15) 
AS3Slider:SetEndValue(15)

--FSAS2UI:Hide()



if ExAirStrikesInclude == 1 then
FSAS3UI:Show()
FSAS3UI._closeBtn:Hide()
AS3Slider:Hide()
AS3SliderText:Hide()
else
FSAS3UI:Hide()
end

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], 1)
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], 1)
end


end

if asfwbuttonpress == 3 then


asbbbuttonpress = 0
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/cybranairstrike1.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/cybranairstrike2.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/cybranairstrike3.dds')

AS1Slider:SetEndValue(15) 
AS3Slider:SetEndValue(15)

--[[
FSAS2UI:Show()
FSAS3UI:Show()
FSAS2UI._closeBtn:Hide()
FSAS3UI._closeBtn:Hide()
]]--

if ExAirStrikesInclude == 1 then

else
FSAS3UI:Show()
FSAS3UI._closeBtn:Hide()
end

AS3Slider:Show()
AS3SliderText:Show()

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end



asfwbuttonpress = 0
end

end

asbbbutton.OnClick = function(self)

asbbbuttonpress = asbbbuttonpress + 1


if asbbbuttonpress == 1 then

asfwbuttonpress = 2
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/cybrangroundairstrike.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/cybranhgroundairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/cybranexairstrike.dds')

AS1Slider:SetEndValue(15) 
AS2Slider:SetEndValue(15) 
AS3Slider:SetEndValue(15)

--FSAS2UI:Hide()
--FSAS3UI:Hide()


if ExAirStrikesInclude == 1 then
FSAS3UI:Show()
FSAS3UI._closeBtn:Hide()
AS3Slider:Hide()
AS3SliderText:Hide()
else
FSAS3UI:Hide()
end

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], 1)
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], 1)
end


end



if asbbbuttonpress == 2 then
asfwbuttonpress = 1
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/cybranairstrike4.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/cybrantorpedoairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/cybranpgairstrike.dds')

AS1Slider:SetEndValue(3) 
AS3Slider:SetEndValue(3) 

--[[
FSAS2UI:Show()
FSAS3UI:Show()
FSAS2UI._closeBtn:Hide()
FSAS3UI._closeBtn:Hide()
]]--

AS3Slider:Show()
AS3SliderText:Show()

if ExAirStrikesInclude == 1 then

else
FSAS3UI:Show()
FSAS3UI._closeBtn:Hide()
end

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end


as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end

end
if asbbbuttonpress == 3 then
asfwbuttonpress = 0
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/cybranairstrike1.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/cybranairstrike2.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/cybranairstrike3.dds')

AS1Slider:SetEndValue(15) 
AS3Slider:SetEndValue(15) 

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.CYBRAN)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.CYBRAN)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end

asbbbuttonpress = 0

end

end


Tooltip.AddButtonTooltip(asfwbutton, "ASFWtn", 1)
Tooltip.AddButtonTooltip(asbbbutton, "ASBBtn", 1)

	end
    if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then

--[[
Text = CreateText(FSAS3UI)	
Text:SetFont('Arial',11) 
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS3UI)
]]--
airstrike1 = Bitmap(FSAS1UI, '/mods/Commander Survival Kit/textures/uefairstrike1.dds')
airstrike2 = Bitmap(FSAS2UI, '/mods/Commander Survival Kit/textures/uefairstrike2.dds')
airstrike3 = Bitmap(FSAS3UI, '/mods/Commander Survival Kit/textures/uefairstrike3.dds')
as1onebuttonlrg = UIUtil.CreateButtonStd(FSAS1UI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', nil, 13, 5, -82)
as2onebuttonlrg = UIUtil.CreateButtonStd(FSAS2UI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', nil, 13, 5, -82)
as3onebuttonlrg = UIUtil.CreateButtonStd(FSAS3UI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', nil, 13, 5, -82)



for i,j in FSAS1PicPosition do
	airstrike1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	airstrike2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	airstrike3[i]:Set(j)
end

for i,j in AS1SliderPosition do
	AS1Slider[i]:Set(j)
end

for i,j in AS2SliderPosition do
	AS2Slider[i]:Set(j)
end

for i,j in AS3SliderPosition do
	AS3Slider[i]:Set(j)
end

for i,j in AS1SliderTextPosition do
	AS1SliderText[i]:Set(j)
end

for i,j in AS2SliderTextPosition do
	AS2SliderText[i]:Set(j)
end

for i,j in AS3SliderTextPosition do
	AS3SliderText[i]:Set(j)
end

for i,j in Button1lrgPosition do
	as1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	as2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	as3onebuttonlrg[i]:Set(j)
end

--[[
Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)
Tooltip.AddButtonTooltip(as1fifteenbutton, "asbfifteenBtn", 1)
Tooltip.AddButtonTooltip(as2onebutton, "asboneBtn", 1)
Tooltip.AddButtonTooltip(as2fivebutton, "asbfiveBtn", 1)
Tooltip.AddButtonTooltip(as2tenbutton, "asbtenBtn", 1)
Tooltip.AddButtonTooltip(as2fifteenbutton, "asbfifteenBtn", 1)
Tooltip.AddButtonTooltip(as3onebutton, "asboneBtn", 1)
Tooltip.AddButtonTooltip(as3fivebutton, "asbfiveBtn", 1)
Tooltip.AddButtonTooltip(as3tenbutton, "asbtenBtn", 1)
Tooltip.AddButtonTooltip(as3fifteenbutton, "asbfifteenBtn", 1)
]]--

LayoutHelpers.DepthOverParent(airstrike1, FSAS1UI, 10)
LayoutHelpers.DepthOverParent(airstrike2, FSAS2UI, 10)
LayoutHelpers.DepthOverParent(airstrike3, FSAS3UI, 10)
LayoutHelpers.DepthOverParent(AS1Slider, FSAS1UI, 10)
LayoutHelpers.DepthOverParent(AS2Slider, FSAS2UI, 10)
LayoutHelpers.DepthOverParent(AS3Slider, FSAS3UI, 10)
LayoutHelpers.DepthOverParent(as1onebuttonlrg, FSAS1UI, 10)
LayoutHelpers.DepthOverParent(as2onebuttonlrg, FSAS2UI, 10)
LayoutHelpers.DepthOverParent(as3onebuttonlrg, FSAS3UI, 10)


as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end

as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end

as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end


asfwbutton = UIUtil.CreateButtonStd(FSASUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', ">", 13, -23, -88)
asbbbutton = UIUtil.CreateButtonStd(FSASUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "<", 13, -23, -88)


for i,j in asfwButtonPosition do
	asfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	asbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(asfwbutton, FSASUI, 10)
LayoutHelpers.DepthOverParent(asbbbutton, FSASUI, 10)


asfwbutton.OnClick = function(self)

asfwbuttonpress = asfwbuttonpress + 1
if asfwbuttonpress == 1 then
asbbbuttonpress = 3
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/uefairstrike4.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/ueftorpedoairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/uefsp4.dds')

AS1Slider:SetEndValue(3) 
AS2Slider:SetEndValue(15) 
AS3Slider:SetEndValue(3) 

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE5LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end


as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE5LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end


end
if asfwbuttonpress == 2 then
asbbbuttonpress = 2
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/uefsp5.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/uefpgairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/uefgroundairstrike.dds')

--FSAS3UI:Hide()

AS1Slider:SetEndValue(3) 
AS2Slider:SetEndValue(3) 
AS3Slider:SetEndValue(15) 

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE6LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE6LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end


as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end


end

if asfwbuttonpress == 3 then

AS1Slider:SetEndValue(15) 
AS2Slider:SetEndValue(15) 
AS3Slider:SetEndValue(15)

asbbbuttonpress = 1
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/uefhgroundairstrike.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/uefexairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')


if ExAirStrikesInclude == 1 then
FSAS2UI:Show()
FSAS2UI._closeBtn:Hide()
AS2Slider:Hide()
AS2SliderText:Hide()
else
FSAS2UI:Hide()
end

FSAS3UI:Hide()

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.UEF)
CreateAirStrike(ID[1], 1)
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], 1)
end


as3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.UEF)
--CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.UEF)
--CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end

end

if asfwbuttonpress == 4 then

AS1Slider:SetEndValue(15) 
AS2Slider:SetEndValue(15) 
AS3Slider:SetEndValue(15)

asbbbuttonpress = 0
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/uefairstrike1.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/uefairstrike2.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/uefairstrike3.dds')



if ExAirStrikesInclude == 1 then

else
FSAS2UI:Show()
FSAS2UI._closeBtn:Hide()
AS2Slider:Show()
AS2SliderText:Show()
end

AS2Slider:Show()
AS2SliderText:Show()

FSAS3UI:Show()
FSAS3UI._closeBtn:Hide()

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end



asfwbuttonpress = 0
end

end

asbbbutton.OnClick = function(self)

asbbbuttonpress = asbbbuttonpress + 1
if asbbbuttonpress == 1 then
asfwbuttonpress = 3
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/uefhgroundairstrike.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/uefexairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')


if ExAirStrikesInclude == 1 then
FSAS2UI:Show()
FSAS2UI._closeBtn:Hide()
AS2Slider:Hide()
AS2SliderText:Hide()
else
FSAS2UI:Hide()
end

FSAS3UI:Hide()

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.UEF)
CreateAirStrike(ID[1], 1)
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], 1)
end


as3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.UEF)
--CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.UEF)
--CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end

end

if asbbbuttonpress == 2 then
asfwbuttonpress = 2
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/uefsp5.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/uefpgairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/uefgroundairstrike.dds')


if ExAirStrikesInclude == 1 then

else
FSAS2UI:Show()
FSAS2UI._closeBtn:Hide()
AS2Slider:Show()
AS2SliderText:Show()
end

AS2Slider:Show()
AS2SliderText:Show()

FSAS3UI:Show()
FSAS3UI._closeBtn:Hide()

AS1Slider:SetEndValue(3) 
AS2Slider:SetEndValue(3) 
AS3Slider:SetEndValue(15) 

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE6LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE6LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE6LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end


as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end

end
if asbbbuttonpress == 3 then
asfwbuttonpress = 1

airstrike1:SetTexture('/mods/Commander Survival Kit/textures/uefairstrike4.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/ueftorpedoairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/uefsp4.dds')

AS1Slider:SetEndValue(3) 
AS2Slider:SetEndValue(15) 
AS3Slider:SetEndValue(3) 

--FSAS3UI:Show()
--FSAS3UI._closeBtn:Hide()

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE5LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end


as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE5LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end


end
if asbbbuttonpress == 4 then


asbbbuttonpress = 0
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/uefairstrike1.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/uefairstrike2.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/uefairstrike3.dds')


AS1Slider:SetEndValue(15) 
AS2Slider:SetEndValue(15) 
AS3Slider:SetEndValue(15) 

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.UEF)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.UEF)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end

asfwbuttonpress = 0

end

end

Tooltip.AddButtonTooltip(asfwbutton, "ASFWtn", 1)
Tooltip.AddButtonTooltip(asbbbutton, "ASBBtn", 1)


end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--


airstrike1 = Bitmap(FSAS1UI, '/mods/Commander Survival Kit/textures/seraairstrike1.dds')
airstrike2 = Bitmap(FSAS2UI, '/mods/Commander Survival Kit/textures/seraairstrike2.dds')
airstrike3 = Bitmap(FSAS3UI, '/mods/Commander Survival Kit/textures/seraairstrike3.dds')

as1onebuttonlrg = UIUtil.CreateButtonStd(FSAS1UI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', nil, 13, 5, -82)
as2onebuttonlrg = UIUtil.CreateButtonStd(FSAS2UI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', nil, 13, 5, -82)
as3onebuttonlrg = UIUtil.CreateButtonStd(FSAS3UI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', nil, 13, 5, -82)

for i,j in FSAS1PicPosition do
	airstrike1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	airstrike2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	airstrike3[i]:Set(j)
end

for i,j in AS1SliderPosition do
	AS1Slider[i]:Set(j)
end

for i,j in AS2SliderPosition do
	AS2Slider[i]:Set(j)
end

for i,j in AS3SliderPosition do
	AS3Slider[i]:Set(j)
end

for i,j in AS1SliderTextPosition do
	AS1SliderText[i]:Set(j)
end

for i,j in AS2SliderTextPosition do
	AS2SliderText[i]:Set(j)
end

for i,j in AS3SliderTextPosition do
	AS3SliderText[i]:Set(j)
end

for i,j in Button1lrgPosition do
	as1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	as2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	as3onebuttonlrg[i]:Set(j)
end

--[[
Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)
Tooltip.AddButtonTooltip(as1fifteenbutton, "asbfifteenBtn", 1)
Tooltip.AddButtonTooltip(as2onebutton, "asboneBtn", 1)
Tooltip.AddButtonTooltip(as2fivebutton, "asbfiveBtn", 1)
Tooltip.AddButtonTooltip(as2tenbutton, "asbtenBtn", 1)
Tooltip.AddButtonTooltip(as2fifteenbutton, "asbfifteenBtn", 1)
Tooltip.AddButtonTooltip(as3onebutton, "asboneBtn", 1)
Tooltip.AddButtonTooltip(as3fivebutton, "asbfiveBtn", 1)
Tooltip.AddButtonTooltip(as3tenbutton, "asbtenBtn", 1)
Tooltip.AddButtonTooltip(as3fifteenbutton, "asbfifteenBtn", 1)
]]--

LayoutHelpers.DepthOverParent(airstrike1, FSAS1UI, 10)
LayoutHelpers.DepthOverParent(airstrike2, FSAS2UI, 10)
LayoutHelpers.DepthOverParent(airstrike3, FSAS3UI, 10)
LayoutHelpers.DepthOverParent(AS1Slider, FSAS1UI, 10)
LayoutHelpers.DepthOverParent(AS2Slider, FSAS2UI, 10)
LayoutHelpers.DepthOverParent(AS3Slider, FSAS3UI, 10)
LayoutHelpers.DepthOverParent(as1onebuttonlrg, FSAS1UI, 10)
LayoutHelpers.DepthOverParent(as2onebuttonlrg, FSAS2UI, 10)
LayoutHelpers.DepthOverParent(as3onebuttonlrg, FSAS3UI, 10)

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end

as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end

as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end

asfwbutton = UIUtil.CreateButtonStd(FSASUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', ">", 13, -23, -88)
asbbbutton = UIUtil.CreateButtonStd(FSASUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "<", 13, -23, -88)


for i,j in asfwButtonPosition do
	asfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	asbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(asfwbutton, FSASUI, 10)
LayoutHelpers.DepthOverParent(asbbbutton, FSASUI, 10)


asfwbutton.OnClick = function(self)

asfwbuttonpress = asfwbuttonpress + 1
if asfwbuttonpress == 1 then
asbbbuttonpress = 2
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/seraairstrike4.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/seratorpedoairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/serapgairstrike.dds')


AS1Slider:SetEndValue(3) 
AS3Slider:SetEndValue(3) 

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end


as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end


end


if asfwbuttonpress == 2 then
asbbbuttonpress = 1
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/seragroundairstrike.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/serahgroundairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/seraexairstrike.dds')


AS1Slider:SetEndValue(15) 
AS3Slider:SetEndValue(15) 
AS3Slider:SetEndValue(15) 

--FSAS2UI:Hide()
--FSAS3UI:Hide()



if ExAirStrikesInclude == 1 then
FSAS3UI:Show()
FSAS3UI._closeBtn:Hide()
AS3Slider:Hide()
AS3SliderText:Hide()
else
FSAS3UI:Hide()
end

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], 1)
end


as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], 1)
end


end

if asfwbuttonpress == 3 then


asbbbuttonpress = 0
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/seraairstrike1.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/seraairstrike2.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/seraairstrike3.dds')

AS1Slider:SetEndValue(15) 
AS3Slider:SetEndValue(15) 

--[[
FSAS2UI:Show()
FSAS3UI:Show()
FSAS2UI._closeBtn:Hide()
FSAS3UI._closeBtn:Hide()
]]--

AS3Slider:Show()
AS3SliderText:Show()

if ExAirStrikesInclude == 1 then

else
FSAS3UI:Show()
FSAS3UI._closeBtn:Hide()
end

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end



asfwbuttonpress = 0
end

end

asbbbutton.OnClick = function(self)

asbbbuttonpress = asbbbuttonpress + 1


if asbbbuttonpress == 1 then
asfwbuttonpress = 2
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/seragroundairstrike.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/serahgroundairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/seraexairstrike.dds')


AS1Slider:SetEndValue(15) 
AS3Slider:SetEndValue(15) 
AS3Slider:SetEndValue(15) 

--FSAS2UI:Hide()
--FSAS3UI:Hide()

AS3Slider:Hide()
AS3SliderText:Hide()

if ExAirStrikesInclude == 1 then
FSAS3UI:Show()
FSAS3UI._closeBtn:Hide()
AS3Slider:Hide()
AS3SliderText:Hide()
else
FSAS3UI:Hide()
end

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE8LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE9LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], 1)
end


as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALAIRSTRIKELEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], 1)
end


end

if asbbbuttonpress == 2 then
asfwbuttonpress = 1
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/seraairstrike4.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/seratorpedoairstrike.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/serapgairstrike.dds')

AS1Slider:SetEndValue(3) 
AS3Slider:SetEndValue(3) 

--[[
FSAS2UI:Show()
FSAS3UI:Show()
FSAS2UI._closeBtn:Hide()
FSAS3UI._closeBtn:Hide()
]]--

AS3Slider:Show()
AS3SliderText:Show()

if ExAirStrikesInclude == 1 then

else
FSAS3UI:Show()
FSAS3UI._closeBtn:Hide()
end

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE7LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE4LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end


as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.PATROLGUNSHIPAIRSTRIKELEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end

end
if asbbbuttonpress == 3 then
asbbbuttonpress = 0
airstrike1:SetTexture('/mods/Commander Survival Kit/textures/seraairstrike1.dds')
airstrike2:SetTexture('/mods/Commander Survival Kit/textures/seraairstrike2.dds')
airstrike3:SetTexture('/mods/Commander Survival Kit/textures/seraairstrike3.dds')

AS1Slider:SetEndValue(15) 
AS3Slider:SetEndValue(15) 

as1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS1Slider:GetValue()))
end


as1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE1LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS1Slider:GetValue()))
end


as2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS2Slider:GetValue()))
end


as2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE2LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS2Slider:GetValue()))
end


as3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.SERAPHIM)
CreateAirStrike(ID[1], math.floor(AS3Slider:GetValue()))
end

as3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.AIRSTRIKE3LEVEL1 * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1], math.floor(AS3Slider:GetValue()))
end

asfwbuttonpress = 0

end

end

Tooltip.AddButtonTooltip(asfwbutton, "ASFWtn", 1)
Tooltip.AddButtonTooltip(asbbbutton, "ASBBtn", 1)

	end
end




local function SetFSARTBtnTextures(ui, id)
	local location = '/mods/Commander Survival Kit/icons/firesupport/up/'.. id ..'_btn_up.dds' 									-- Normal Icon
	local location2 = '/mods/Commander Survival Kit/icons/firesupport/over/'.. id ..'_btn_over.dds'		-- Mouseover Icon
	local location3 = '/mods/Commander Survival Kit/icons/firesupport/active/'.. id ..'_btn_down.dds'		-- Selected Icon
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), path)
end

local function SetFSNVBtnTextures(ui, id)
	local location = '/mods/Commander Survival Kit/icons/firesupport/up/'.. id ..'_btn_up.dds' 									-- Normal Icon
	local location2 = '/mods/Commander Survival Kit/icons/firesupport/over/'.. id ..'_btn_over.dds'		-- Mouseover Icon
	local location3 = '/mods/Commander Survival Kit/icons/firesupport/active/'.. id ..'_btn_down.dds'
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), path)
end

local function SetFSMBtnTextures(ui, id)
	local location = '/mods/Commander Survival Kit/icons/firesupport/up/'.. id ..'_btn_up.dds' 									-- Normal Icon
	local location2 = '/mods/Commander Survival Kit/icons/firesupport/over/'.. id ..'_btn_over.dds'		-- Mouseover Icon
	local location3 = '/mods/Commander Survival Kit/icons/firesupport/active/'.. id ..'_btn_down.dds'
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), path)
end

local function SetFSRFBtnTextures(ui, id)
	local location = '/mods/Commander Survival Kit/icons/firesupport/test/rapid_fire_btn_up.dds' 									-- Normal Icon
	local location2 = '/mods/Commander Survival Kit/icons/firesupport/test/rapid_fire_btn_over.dds'		-- Mouseover Icon
	local location3 = '/mods/Commander Survival Kit/icons/firesupport/test/rapid_fire_btn_down.dds'		-- Selected Icon
	
	--local location = '/mods/Commander Survival Kit/icons/firesupport/up/'.. id ..'_btn_up.dds' 									-- Normal Icon
	--local location2 = '/mods/Commander Survival Kit/icons/firesupport/over/'.. id ..'_btn_over.dds'		-- Mouseover Icon
	--local location3 = '/mods/Commander Survival Kit/icons/firesupport/active/'.. id ..'_btn_down.dds'		-- Selected Icon
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), path)
end

local function SetFSRFBtnTextures2(ui, id)
	local location = '/mods/Commander Survival Kit/icons/firesupport/up/'.. id ..'_btn_up.dds' 									-- Normal Icon
	local location2 = '/mods/Commander Survival Kit/icons/firesupport/over/'.. id ..'_btn_over.dds'		-- Mouseover Icon
	local location3 = '/mods/Commander Survival Kit/icons/firesupport/active/'.. id ..'_btn_down.dds'		-- Selected Icon
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), path)
end

local function SetFSBBtnTextures(ui, id)
	local location = '/mods/Commander Survival Kit/icons/firesupport/test/Beam_btn_up.dds' 									-- Normal Icon
	local location2 = '/mods/Commander Survival Kit/icons/firesupport/test/Beam_btn_over.dds'		-- Mouseover Icon
	local location3 = '/mods/Commander Survival Kit/icons/firesupport/test/Beam_btn_down.dds'		-- Selected Icon
	--local location = '/mods/Commander Survival Kit/icons/firesupport/up/'.. id ..'_btn_up.dds' 									-- Normal Icon
	--local location2 = '/mods/Commander Survival Kit/icons/firesupport/over/'.. id ..'_btn_over.dds'		-- Mouseover Icon
	--local location3 = '/mods/Commander Survival Kit/icons/firesupport/active/'.. id ..'_btn_down.dds'		-- Selected Icon
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), path)
end

local function SetFSBBtnTextures2(ui, id)
	local location = '/mods/Commander Survival Kit/icons/firesupport/up/'.. id ..'_btn_up.dds' 									-- Normal Icon
	local location2 = '/mods/Commander Survival Kit/icons/firesupport/over/'.. id ..'_btn_over.dds'		-- Mouseover Icon
	local location3 = '/mods/Commander Survival Kit/icons/firesupport/active/'.. id ..'_btn_down.dds'		-- Selected Icon
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), path)
end

local function SetFSSPBtnTextures(ui, id)
	local location = '/mods/Commander Survival Kit/icons/firesupport/test/fire_btn_up.dds' 									-- Normal Icon
	local location2 = '/mods/Commander Survival Kit/icons/firesupport/test/fire_btn_over.dds'		-- Mouseover Icon
	local location3 = '/mods/Commander Survival Kit/icons/firesupport/test/fire_btn_down.dds'		-- Selected Icon
	--local location = '/mods/Commander Survival Kit/icons/firesupport/up/'.. id ..'_btn_up.dds' 									-- Normal Icon
	--local location2 = '/mods/Commander Survival Kit/icons/firesupport/over/'.. id ..'_btn_over.dds'		-- Mouseover Icon
	--local location3 = '/mods/Commander Survival Kit/icons/firesupport/active/'.. id ..'_btn_down.dds'		-- Selected Icon
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), path)
end

local function SetFSSPBtnTextures2(ui, id)
	local location = '/mods/Commander Survival Kit/icons/firesupport/up/'.. id ..'_btn_up.dds' 									-- Normal Icon
	local location2 = '/mods/Commander Survival Kit/icons/firesupport/over/'.. id ..'_btn_over.dds'		-- Mouseover Icon
	local location3 = '/mods/Commander Survival Kit/icons/firesupport/active/'.. id ..'_btn_down.dds'		-- Selected Icon
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), path)
end

local function FSarrayPosition(Position, existed, parent)
	if existed[1] then
		return existed[2]
	else
		local pos = {}
		for k,v in Position do
			pos[k] = parent[k][1]
		end
		pos.Height = pos.Top - pos.Bottom
		pos.Width = pos.Right - pos.Left
		existed[4] = pos.Left
		existed[1] = true
		return pos
	end
end

local function FSArtarray(pos, total, Image, existed)
	if existed[3] then
		pos.Height = -115/ total
		pos.Width = 115 / total
		existed[3] = false 
	end
	local right = pos.Left + pos.Width
	local bottom = pos.Top - pos.Height
	Image.Top:Set(pos.Top) 
	Image.Bottom:Set(bottom)
	Image.Left:Set(pos.Left)
	Image.Right:Set(right)
	if right > pos.Right then
		right = existed[4]
		pos.Top = bottom
	end
	pos.Left = right
	return pos
end

local function FSMissilearray(pos, total, Image, existed)
	if existed[3] then
		pos.Height = -100 / total
		pos.Width = 100 / total
		existed[3] = false 
	end
	local right = pos.Left + pos.Width
	local bottom = pos.Top - pos.Height
	Image.Top:Set(pos.Top) 
	Image.Bottom:Set(bottom)
	Image.Left:Set(pos.Left)
	Image.Right:Set(right)
	if right > pos.Right then
		right = existed[4]
		pos.Top = bottom
	end
	pos.Left = right
	return pos
end

local function FSNavalarray(pos, total, Image, existed)
	if existed[3] then
		pos.Height = -100 / total
		pos.Width = 100 / total
		existed[3] = false 
	end
	local right = pos.Left + pos.Width
	local bottom = pos.Top - pos.Height
	Image.Top:Set(pos.Top) 
	Image.Bottom:Set(bottom)
	Image.Left:Set(pos.Left)
	Image.Right:Set(right)
	if right > pos.Right then
		right = existed[4]
		pos.Top = bottom
	end
	pos.Left = right
	return pos
end

local function FSlinkup(pos, existed)
	existed[2] = pos
end

FSUI = CreateWindow(GetFrame(0),'Artillery',nil,false,false,true,true,'Reinforcements',Position,Border) 
FS1UI = CreateWindow(FSUI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
FS2UI = CreateWindow(FSUI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
FS3UI = CreateWindow(FSUI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
--as1onebuttonlrg = UIUtil.CreateButtonStd(FSAS1UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
--as2onebuttonlrg = UIUtil.CreateButtonStd(FSAS2UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
--as3onebuttonlrg = UIUtil.CreateButtonStd(FSAS3UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
FS1UI._closeBtn:Hide()
FS2UI._closeBtn:Hide()
FS3UI._closeBtn:Hide()
for i,j in FSASPosition do
	FSUI[i]:Set(j)
end

for i,j in FSAS1Position do
	FS1UI[i]:Set(j)
end

for i,j in FSAS2Position do
	FS2UI[i]:Set(j)
end

for i,j in FSAS3Position do
	FS3UI[i]:Set(j)
end


--[[
for i,j in Button1lrgPosition do
	as1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	as2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	as3onebuttonlrg[i]:Set(j)
end
]]--

local artfwbuttonpress = 0
local artbbbuttonpress = 0
local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	

if focusarmy >= 1 then
    if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

artillery1 = Bitmap(FS1UI, '/mods/Commander Survival Kit/textures/aeonart1.dds')
artillery2 = Bitmap(FS2UI, '/mods/Commander Survival Kit/textures/aeonart2.dds')
artillery3 = Bitmap(FS3UI, '/mods/Commander Survival Kit/textures/aeonart3.dds')
art1onebuttonlrg = UIUtil.CreateButtonStd(FS1UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
art2onebuttonlrg = UIUtil.CreateButtonStd(FS2UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
art3onebuttonlrg = UIUtil.CreateButtonStd(FS3UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)

for i,j in FSAS1PicPosition do
	artillery1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	artillery2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	artillery3[i]:Set(j)
end


for i,j in Button1lrgPosition do
	art1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	art2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	art3onebuttonlrg[i]:Set(j)
end

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(artillery1, FS1UI, 10)
LayoutHelpers.DepthOverParent(artillery2, FS2UI, 10)
LayoutHelpers.DepthOverParent(artillery3, FS3UI, 10)
LayoutHelpers.DepthOverParent(art1onebuttonlrg, FS1UI, 10)
LayoutHelpers.DepthOverParent(art2onebuttonlrg, FS2UI, 10)
LayoutHelpers.DepthOverParent(art3onebuttonlrg, FS3UI, 10)


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end


artfwbutton = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', ">", 13, -23, -88)
artbbbutton = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "<", 13, -23, -88)


for i,j in asfwButtonPosition do
	artfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	artbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(artfwbutton, FSUI, 10)
LayoutHelpers.DepthOverParent(artbbbutton, FSUI, 10)


artfwbutton.OnClick = function(self)
artfwbuttonpress = artfwbuttonpress + 1
if artfwbuttonpress == 1 then
artbbbuttonpress = 4
LOG(artfwbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/aeonart4.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/aeonart5.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/aeonrf1.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end
end

if artfwbuttonpress == 2 then
artbbbuttonpress = 3
LOG(artfwbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/aeonrf2.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/aeonrf3.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/aeonrf4.dds')

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

end

if artfwbuttonpress == 3 then
artbbbuttonpress = 2
LOG(artfwbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/aeonrf5.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/aeonn1.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/aeonn2.dds')

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

end

if artfwbuttonpress == 4 then
artbbbuttonpress = 1
LOG(artfwbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/aeonn3.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')

FS2UI:Hide()
art2onebuttonlrg:Hide()
FS3UI:Hide()
art3onebuttonlrg:Hide()


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.AEON)
--CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrageOnHover(ID[1])
end

end

if artfwbuttonpress == 5 then
artbbbuttonpress = 0
LOG(artfwbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/aeonart1.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/aeonart2.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/aeonart3.dds')
FS2UI:Show()
art2onebuttonlrg:Show()
FS2UI._closeBtn:Hide()
FS3UI:Show()
art3onebuttonlrg:Show()
FS3UI._closeBtn:Hide()

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

artfwbuttonpress = 0
end
end


artbbbutton.OnClick = function(self)
artbbbuttonpress = artbbbuttonpress + 1
if artbbbuttonpress == 1 then
artfwbuttonpress = 4
LOG(artbbbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/aeonn3.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')

FS2UI:Hide()
art2onebuttonlrg:Hide()
FS3UI:Hide()
art3onebuttonlrg:Hide()

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.AEON)
--CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 2 then
artfwbuttonpress = 3
LOG(artbbbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/aeonrf5.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/aeonn1.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/aeonn2.dds')
FS2UI:Show()
art2onebuttonlrg:Show()
FS2UI._closeBtn:Hide()
FS3UI:Show()
art3onebuttonlrg:Show()
FS3UI._closeBtn:Hide()

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 3 then
artfwbuttonpress = 2
LOG(artbbbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/aeonrf2.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/aeonrf3.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/aeonrf4.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 4 then
artfwbuttonpress = 1
LOG(artbbbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/aeonart4.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/aeonart5.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/aeonrf1.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 5 then
artfwbuttonpress = 0
LOG(artbbbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/aeonart1.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/aeonart2.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/aeonart3.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

artbbbuttonpress = 0
end
end


Tooltip.AddButtonTooltip(artfwbutton, "ArtFWtn", 1)
Tooltip.AddButtonTooltip(artbbbutton, "ArtBBtn", 1)

	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

artillery1 = Bitmap(FS1UI, '/mods/Commander Survival Kit/textures/cybranart1.dds')
artillery2 = Bitmap(FS2UI, '/mods/Commander Survival Kit/textures/cybranart2.dds')
artillery3 = Bitmap(FS3UI, '/mods/Commander Survival Kit/textures/cybranart3.dds')
art1onebuttonlrg = UIUtil.CreateButtonStd(FS1UI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "1", 13, 5, -82)
art2onebuttonlrg = UIUtil.CreateButtonStd(FS2UI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "1", 13, 5, -82)
art3onebuttonlrg = UIUtil.CreateButtonStd(FS3UI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "1", 13, 5, -82)

for i,j in FSAS1PicPosition do
	artillery1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	artillery2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	artillery3[i]:Set(j)
end


for i,j in Button1lrgPosition do
	art1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	art2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	art3onebuttonlrg[i]:Set(j)
end

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(artillery1, FS1UI, 10)
LayoutHelpers.DepthOverParent(artillery2, FS2UI, 10)
LayoutHelpers.DepthOverParent(artillery3, FS3UI, 10)
LayoutHelpers.DepthOverParent(art1onebuttonlrg, FS1UI, 10)
LayoutHelpers.DepthOverParent(art2onebuttonlrg, FS2UI, 10)
LayoutHelpers.DepthOverParent(art3onebuttonlrg, FS3UI, 10)


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end


artfwbutton = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', ">", 13, -23, -88)
artbbbutton = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "<", 13, -23, -88)


for i,j in asfwButtonPosition do
	artfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	artbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(artfwbutton, FSUI, 10)
LayoutHelpers.DepthOverParent(artbbbutton, FSUI, 10)


artfwbutton.OnClick = function(self)
artfwbuttonpress = artfwbuttonpress + 1
if artfwbuttonpress == 1 then
artbbbuttonpress = 4
LOG(artfwbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/cybranart4.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/cybranart5.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/cybranrf1.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end
end

if artfwbuttonpress == 2 then
artbbbuttonpress = 3
LOG(artfwbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/cybranrf2.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/cybranrf3.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/cybranrf4.dds')

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

end

if artfwbuttonpress == 3 then
artbbbuttonpress = 2
LOG(artfwbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/cybranrf5.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/cybrann1.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/cybrann2.dds')

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

end

if artfwbuttonpress == 4 then
artbbbuttonpress = 1
LOG(artfwbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/cybrann3.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')

FS2UI:Hide()
art2onebuttonlrg:Hide()
FS3UI:Hide()
art3onebuttonlrg:Hide()


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrageOnHover(ID[1])
end

end

if artfwbuttonpress == 5 then
artbbbuttonpress = 0
LOG(artfwbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/cybranart1.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/cybranart2.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/cybranart3.dds')
FS2UI:Show()
art2onebuttonlrg:Show()
FS2UI._closeBtn:Hide()
FS3UI:Show()
art3onebuttonlrg:Show()
FS3UI._closeBtn:Hide()

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

artfwbuttonpress = 0
end
end


artbbbutton.OnClick = function(self)
artbbbuttonpress = artbbbuttonpress + 1
if artbbbuttonpress == 1 then
artfwbuttonpress = 4
LOG(artbbbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/cybrann3.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')

FS2UI:Hide()
art2onebuttonlrg:Hide()
FS3UI:Hide()
art3onebuttonlrg:Hide()

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 2 then
artfwbuttonpress = 3
LOG(artbbbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/cybranrf5.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/cybrann1.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/cybrann2.dds')
FS2UI:Show()
art2onebuttonlrg:Show()
FS2UI._closeBtn:Hide()
FS3UI:Show()
art3onebuttonlrg:Show()
FS3UI._closeBtn:Hide()

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 3 then
artfwbuttonpress = 2
LOG(artbbbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/cybranrf2.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/cybranrf3.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/cybranrf4.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 4 then
artfwbuttonpress = 1
LOG(artbbbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/cybranart4.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/cybranart5.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/cybranrf1.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 5 then
artfwbuttonpress = 0
LOG(artbbbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/cybranart1.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/cybranart2.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/cybranart3.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

artbbbuttonpress = 0
end
end


Tooltip.AddButtonTooltip(artfwbutton, "ArtFWtn", 1)
Tooltip.AddButtonTooltip(artbbbutton, "ArtBBtn", 1)

	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

artillery1 = Bitmap(FS1UI, '/mods/Commander Survival Kit/textures/uefart1.dds')
artillery2 = Bitmap(FS2UI, '/mods/Commander Survival Kit/textures/uefart2.dds')
artillery3 = Bitmap(FS3UI, '/mods/Commander Survival Kit/textures/uefart3.dds')
art1onebuttonlrg = UIUtil.CreateButtonStd(FS1UI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "1", 13, 5, -82)
art2onebuttonlrg = UIUtil.CreateButtonStd(FS2UI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "1", 13, 5, -82)
art3onebuttonlrg = UIUtil.CreateButtonStd(FS3UI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "1", 13, 5, -82)

for i,j in FSAS1PicPosition do
	artillery1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	artillery2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	artillery3[i]:Set(j)
end


for i,j in Button1lrgPosition do
	art1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	art2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	art3onebuttonlrg[i]:Set(j)
end

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(artillery1, FS1UI, 10)
LayoutHelpers.DepthOverParent(artillery2, FS2UI, 10)
LayoutHelpers.DepthOverParent(artillery3, FS3UI, 10)
LayoutHelpers.DepthOverParent(art1onebuttonlrg, FS1UI, 10)
LayoutHelpers.DepthOverParent(art2onebuttonlrg, FS2UI, 10)
LayoutHelpers.DepthOverParent(art3onebuttonlrg, FS3UI, 10)


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end


artfwbutton = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', ">", 13, -23, -88)
artbbbutton = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "<", 13, -23, -88)


for i,j in asfwButtonPosition do
	artfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	artbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(artfwbutton, FSUI, 10)
LayoutHelpers.DepthOverParent(artbbbutton, FSUI, 10)


artfwbutton.OnClick = function(self)
artfwbuttonpress = artfwbuttonpress + 1
if artfwbuttonpress == 1 then
artbbbuttonpress = 4
LOG(artfwbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/uefart4.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/uefart5.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/uefrf1.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end
end

if artfwbuttonpress == 2 then
artbbbuttonpress = 3
LOG(artfwbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/uefrf2.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/uefrf3.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/uefrf4.dds')

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

end

if artfwbuttonpress == 3 then
artbbbuttonpress = 2
LOG(artfwbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/uefrf5.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/uefn1.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/uefn2.dds')

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

end

if artfwbuttonpress == 4 then
artbbbuttonpress = 1
LOG(artfwbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/uefn3.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')

FS2UI:Hide()
art2onebuttonlrg:Hide()
FS3UI:Hide()
art3onebuttonlrg:Hide()


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.UEF)
--CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
--CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.UEF)
--CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
--CreateBarrageOnHover(ID[1])
end

end

if artfwbuttonpress == 5 then
artbbbuttonpress = 0
LOG(artfwbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/uefart1.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/uefart2.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/uefart3.dds')
FS2UI:Show()
art2onebuttonlrg:Show()
FS2UI._closeBtn:Hide()
FS3UI:Show()
art3onebuttonlrg:Show()
FS3UI._closeBtn:Hide()

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

artfwbuttonpress = 0
end
end


artbbbutton.OnClick = function(self)
artbbbuttonpress = artbbbuttonpress + 1
if artbbbuttonpress == 1 then
artfwbuttonpress = 4
LOG(artbbbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/uefn3.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')

FS2UI:Hide()
art2onebuttonlrg:Hide()
FS3UI:Hide()
art3onebuttonlrg:Hide()

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.UEF)
--CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
--CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.UEF)
--CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
--CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 2 then
artfwbuttonpress = 3
LOG(artbbbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/uefrf5.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/uefn1.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/uefn2.dds')
FS2UI:Show()
art2onebuttonlrg:Show()
FS2UI._closeBtn:Hide()
FS3UI:Show()
art3onebuttonlrg:Show()
FS3UI._closeBtn:Hide()

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 3 then
artfwbuttonpress = 2
LOG(artbbbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/uefrf2.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/uefrf3.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/uefrf4.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 4 then
artfwbuttonpress = 1
LOG(artbbbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/uefart4.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/uefart5.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/uefrf1.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 5 then
artfwbuttonpress = 0
LOG(artbbbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/uefart1.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/uefart2.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/uefart3.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

artbbbuttonpress = 0
end
end


Tooltip.AddButtonTooltip(artfwbutton, "ArtFWtn", 1)
Tooltip.AddButtonTooltip(artbbbutton, "ArtBBtn", 1)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

artillery1 = Bitmap(FS1UI, '/mods/Commander Survival Kit/textures/seraart1.dds')
artillery2 = Bitmap(FS2UI, '/mods/Commander Survival Kit/textures/seraart2.dds')
artillery3 = Bitmap(FS3UI, '/mods/Commander Survival Kit/textures/seraart3.dds')
art1onebuttonlrg = UIUtil.CreateButtonStd(FS1UI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "1", 13, 5, -82)
art2onebuttonlrg = UIUtil.CreateButtonStd(FS2UI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "1", 13, 5, -82)
art3onebuttonlrg = UIUtil.CreateButtonStd(FS3UI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "1", 13, 5, -82)

for i,j in FSAS1PicPosition do
	artillery1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	artillery2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	artillery3[i]:Set(j)
end


for i,j in Button1lrgPosition do
	art1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	art2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	art3onebuttonlrg[i]:Set(j)
end

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(artillery1, FS1UI, 10)
LayoutHelpers.DepthOverParent(artillery2, FS2UI, 10)
LayoutHelpers.DepthOverParent(artillery3, FS3UI, 10)
LayoutHelpers.DepthOverParent(art1onebuttonlrg, FS1UI, 10)
LayoutHelpers.DepthOverParent(art2onebuttonlrg, FS2UI, 10)
LayoutHelpers.DepthOverParent(art3onebuttonlrg, FS3UI, 10)


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end


artfwbutton = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', ">", 13, -23, -88)
artbbbutton = UIUtil.CreateButtonStd(FSUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "<", 13, -23, -88)


for i,j in asfwButtonPosition do
	artfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	artbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(artfwbutton, FSUI, 10)
LayoutHelpers.DepthOverParent(artbbbutton, FSUI, 10)


artfwbutton.OnClick = function(self)
artfwbuttonpress = artfwbuttonpress + 1
if artfwbuttonpress == 1 then
artbbbuttonpress = 4
LOG(artfwbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/seraart4.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/seraart5.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/serarf1.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end
end

if artfwbuttonpress == 2 then
artbbbuttonpress = 3
LOG(artfwbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/serarf2.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/serarf3.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/serarf4.dds')

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

end

if artfwbuttonpress == 3 then
artbbbuttonpress = 2
LOG(artfwbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/serarf5.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/seran1.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/seran2.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

end

if artfwbuttonpress == 4 then
artbbbuttonpress = 1
LOG(artfwbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/seran3.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')

FS2UI:Hide()
art2onebuttonlrg:Hide()
FS3UI:Hide()
art3onebuttonlrg:Hide()


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrageOnHover(ID[1])
end

end

if artfwbuttonpress == 5 then
artbbbuttonpress = 0
LOG(artfwbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/seraart1.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/seraart2.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/seraart3.dds')
FS2UI:Show()
art2onebuttonlrg:Show()
FS2UI._closeBtn:Hide()
FS3UI:Show()
art3onebuttonlrg:Show()
FS3UI._closeBtn:Hide()

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

artfwbuttonpress = 0
end
end


artbbbutton.OnClick = function(self)
artbbbuttonpress = artbbbuttonpress + 1
if artbbbuttonpress == 1 then
artfwbuttonpress = 4
LOG(artbbbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/seran3.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')

FS2UI:Hide()
art2onebuttonlrg:Hide()
FS3UI:Hide()
art3onebuttonlrg:Hide()

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 2 then
artfwbuttonpress = 3
LOG(artbbbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/serarf5.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/seran1.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/seran2.dds')
FS2UI:Show()
art2onebuttonlrg:Show()
FS2UI._closeBtn:Hide()
FS3UI:Show()
art3onebuttonlrg:Show()
FS3UI._closeBtn:Hide()

art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 3 then
artfwbuttonpress = 2
LOG(artbbbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/serarf2.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/serarf3.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/serarf4.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 4 then
artfwbuttonpress = 1
LOG(artbbbuttonpress)

artillery1:SetTexture('/mods/Commander Survival Kit/textures/seraart4.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/seraart5.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/serarf1.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

end

if artbbbuttonpress == 5 then
artfwbuttonpress = 0
LOG(artbbbuttonpress)
artillery1:SetTexture('/mods/Commander Survival Kit/textures/seraart1.dds')
artillery2:SetTexture('/mods/Commander Survival Kit/textures/seraart2.dds')
artillery3:SetTexture('/mods/Commander Survival Kit/textures/seraart3.dds')


art1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

art3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


art1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

art3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

artbbbuttonpress = 0
end
end


Tooltip.AddButtonTooltip(artfwbutton, "ArtFWtn", 1)
Tooltip.AddButtonTooltip(artbbbutton, "ArtBBtn", 1)
	end
end	

FSMissileUI = CreateWindow(GetFrame(0),'Missile',nil,false,false,true,true,'Reinforcements',Position,Border) 
FS1MissileUI = CreateWindow(FSMissileUI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
FS2MissileUI = CreateWindow(FSMissileUI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
FS3MissileUI = CreateWindow(FSMissileUI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
--as1onebuttonlrg = UIUtil.CreateButtonStd(FSAS1UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
--as2onebuttonlrg = UIUtil.CreateButtonStd(FSAS2UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
--as3onebuttonlrg = UIUtil.CreateButtonStd(FSAS3UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
FS1MissileUI._closeBtn:Hide()
FS2MissileUI._closeBtn:Hide()
FS3MissileUI._closeBtn:Hide()
for i,j in FSASPosition do
	FSMissileUI[i]:Set(j)
end

for i,j in FSAS1Position do
	FS1MissileUI[i]:Set(j)
end

for i,j in FSAS2Position do
	FS2MissileUI[i]:Set(j)
end

for i,j in FSAS3Position do
	FS3MissileUI[i]:Set(j)
end


--[[
for i,j in Button1lrgPosition do
	as1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	as2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	as3onebuttonlrg[i]:Set(j)
end
]]--

local mfwbuttonpress = 0
local mbbuttonpress = 0
local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	

if focusarmy >= 1 then
    if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
mfwbutton = UIUtil.CreateButtonStd(FSMissileUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', ">", 13, -23, -88)
mbbutton = UIUtil.CreateButtonStd(FSMissileUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "<", 13, -23, -88)	
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

missile1 = Bitmap(FS1MissileUI, '/mods/Commander Survival Kit/textures/aeonm1.dds')
missile2 = Bitmap(FS2MissileUI, '/mods/Commander Survival Kit/textures/aeonm2.dds')
missile3 = Bitmap(FS3MissileUI, '/mods/Commander Survival Kit/textures/aeonm3.dds')
m1onebuttonlrg = UIUtil.CreateButtonStd(FS1MissileUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
m2onebuttonlrg = UIUtil.CreateButtonStd(FS2MissileUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
m3onebuttonlrg = UIUtil.CreateButtonStd(FS3MissileUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)

for i,j in FSAS1PicPosition do
	missile1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	missile2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	missile3[i]:Set(j)
end

for i,j in Button1lrgPosition do
	m1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	m2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	m3onebuttonlrg[i]:Set(j)
end

for i,j in asfwButtonPosition do
	mfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	mbbutton[i]:Set(j)
end	

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(missile1, FS1MissileUI, 10)
LayoutHelpers.DepthOverParent(missile2, FS2MissileUI, 10)
LayoutHelpers.DepthOverParent(missile3, FS3MissileUI, 10)
LayoutHelpers.DepthOverParent(m1onebuttonlrg, FS1MissileUI, 10)
LayoutHelpers.DepthOverParent(m2onebuttonlrg, FS2MissileUI, 10)
LayoutHelpers.DepthOverParent(m3onebuttonlrg, FS3MissileUI, 10)
LayoutHelpers.DepthOverParent(mfwbutton, FSMissileUI, 10)
LayoutHelpers.DepthOverParent(mbbutton, FSMissileUI, 10)


m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

mfwbutton.OnClick = function(self)
mfwbuttonpress = mfwbuttonpress + 1
if mfwbuttonpress == 1 then
mbbuttonpress = 1
LOG(mfwbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/aeonm4.dds')
missile2:SetTexture('/mods/Commander Survival Kit/textures/aeonm5.dds') 
missile3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FS3MissileUI:Hide()
m3onebuttonlrg:Hide()



m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrageOnHover(ID[1])
end
end

if mfwbuttonpress == 2 then
mbbuttonpress = 0
LOG(mfwbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/aeonm1.dds') 
missile2:SetTexture('/mods/Commander Survival Kit/textures/aeonm2.dds') 
missile3:SetTexture('/mods/Commander Survival Kit/textures/aeonm3.dds')
FS3MissileUI:Show()
m3onebuttonlrg:Show()
FS3MissileUI._closeBtn:Hide()

m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

mfwbuttonpress = 0
end
end

mbbutton.OnClick = function(self)
mbbuttonpress = mbbuttonpress + 1
if mbbuttonpress == 1 then
mfwbuttonpress = 1
LOG(mbbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/aeonm4.dds')
missile2:SetTexture('/mods/Commander Survival Kit/textures/aeonm5.dds') 
missile3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FS3MissileUI:Hide()
m3onebuttonlrg:Hide()



m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrageOnHover(ID[1])
end

end

if mbbuttonpress == 2 then
mfwbuttonpress = 0
LOG(mbbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/aeonm1.dds') 
missile2:SetTexture('/mods/Commander Survival Kit/textures/aeonm2.dds') 
missile3:SetTexture('/mods/Commander Survival Kit/textures/aeonm3.dds')
FS3MissileUI:Show()
m3onebuttonlrg:Show()
FS3MissileUI._closeBtn:Hide()

m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

mbbuttonpress = 0
end
end
Tooltip.AddButtonTooltip(mfwbutton, "MFWtn", 1)
Tooltip.AddButtonTooltip(mbbutton, "MBBtn", 1)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
mfwbutton = UIUtil.CreateButtonStd(FSMissileUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', ">", 13, -23, -88)
mbbutton = UIUtil.CreateButtonStd(FSMissileUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "<", 13, -23, -88)	
	
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

missile1 = Bitmap(FS1MissileUI, '/mods/Commander Survival Kit/textures/cybranm1.dds')
missile2 = Bitmap(FS2MissileUI, '/mods/Commander Survival Kit/textures/cybranm2.dds')
missile3 = Bitmap(FS3MissileUI, '/mods/Commander Survival Kit/textures/cybranm3.dds')
m1onebuttonlrg = UIUtil.CreateButtonStd(FS1MissileUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "1", 13, 5, -82)
m2onebuttonlrg = UIUtil.CreateButtonStd(FS2MissileUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "1", 13, 5, -82)
m3onebuttonlrg = UIUtil.CreateButtonStd(FS3MissileUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "1", 13, 5, -82)

for i,j in FSAS1PicPosition do
	missile1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	missile2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	missile3[i]:Set(j)
end

for i,j in Button1lrgPosition do
	m1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	m2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	m3onebuttonlrg[i]:Set(j)
end

for i,j in asfwButtonPosition do
	mfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	mbbutton[i]:Set(j)
end	

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(missile1, FS1MissileUI, 10)
LayoutHelpers.DepthOverParent(missile2, FS2MissileUI, 10)
LayoutHelpers.DepthOverParent(missile3, FS3MissileUI, 10)
LayoutHelpers.DepthOverParent(m1onebuttonlrg, FS1MissileUI, 10)
LayoutHelpers.DepthOverParent(m2onebuttonlrg, FS2MissileUI, 10)
LayoutHelpers.DepthOverParent(m3onebuttonlrg, FS3MissileUI, 10)
LayoutHelpers.DepthOverParent(mfwbutton, FSMissileUI, 10)
LayoutHelpers.DepthOverParent(mbbutton, FSMissileUI, 10)


m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

mfwbutton.OnClick = function(self)
mfwbuttonpress = mfwbuttonpress + 1
if mfwbuttonpress == 1 then
mbbuttonpress = 1
LOG(mfwbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/cybranm4.dds') 
missile2:SetTexture('/mods/Commander Survival Kit/textures/cybranm5.dds') 
missile3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FS3MissileUI:Hide()
m3onebuttonlrg:Hide()



m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrageOnHover(ID[1])
end
end

if mfwbuttonpress == 2 then
mbbuttonpress = 0
LOG(mfwbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/cybranm1.dds') 
missile2:SetTexture('/mods/Commander Survival Kit/textures/cybranm2.dds') 
missile3:SetTexture('/mods/Commander Survival Kit/textures/cybranm3.dds')
FS3MissileUI:Show()
m3onebuttonlrg:Show()
FS3MissileUI._closeBtn:Hide()

m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

mfwbuttonpress = 0
end
end

mbbutton.OnClick = function(self)
mbbuttonpress = mbbuttonpress + 1
if mbbuttonpress == 1 then
mfwbuttonpress = 1
LOG(mbbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/cybranm4.dds') 
missile2:SetTexture('/mods/Commander Survival Kit/textures/cybranm5.dds') 
missile3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FS3MissileUI:Hide()
m3onebuttonlrg:Hide()



m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrageOnHover(ID[1])
end

end

if mbbuttonpress == 2 then
mfwbuttonpress = 0
LOG(mbbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/cybranm1.dds') 
missile2:SetTexture('/mods/Commander Survival Kit/textures/cybranm2.dds') 
missile3:SetTexture('/mods/Commander Survival Kit/textures/cybranm3.dds')
FS3MissileUI:Show()
m3onebuttonlrg:Show()
FS3MissileUI._closeBtn:Hide()

m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

mbbuttonpress = 0
end
end
Tooltip.AddButtonTooltip(mfwbutton, "MFWtn", 1)
Tooltip.AddButtonTooltip(mbbutton, "MBBtn", 1)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
	
mfwbutton = UIUtil.CreateButtonStd(FSMissileUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', ">", 13, -23, -88)
mbbutton = UIUtil.CreateButtonStd(FSMissileUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "<", 13, -23, -88)


--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

missile1 = Bitmap(FS1MissileUI, '/mods/Commander Survival Kit/textures/uefm1.dds')
missile2 = Bitmap(FS2MissileUI, '/mods/Commander Survival Kit/textures/uefm2.dds')
missile3 = Bitmap(FS3MissileUI, '/mods/Commander Survival Kit/textures/uefm3.dds')
m1onebuttonlrg = UIUtil.CreateButtonStd(FS1MissileUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "1", 13, 5, -82)
m2onebuttonlrg = UIUtil.CreateButtonStd(FS2MissileUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "1", 13, 5, -82)
m3onebuttonlrg = UIUtil.CreateButtonStd(FS3MissileUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "1", 13, 5, -82)

for i,j in FSAS1PicPosition do
	missile1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	missile2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	missile3[i]:Set(j)
end

for i,j in Button1lrgPosition do
	m1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	m2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	m3onebuttonlrg[i]:Set(j)
end

for i,j in asfwButtonPosition do
	mfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	mbbutton[i]:Set(j)
end	

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(missile1, FS1MissileUI, 10)
LayoutHelpers.DepthOverParent(missile2, FS2MissileUI, 10)
LayoutHelpers.DepthOverParent(missile3, FS3MissileUI, 10)
LayoutHelpers.DepthOverParent(m1onebuttonlrg, FS1MissileUI, 10)
LayoutHelpers.DepthOverParent(m2onebuttonlrg, FS2MissileUI, 10)
LayoutHelpers.DepthOverParent(m3onebuttonlrg, FS3MissileUI, 10)
LayoutHelpers.DepthOverParent(mfwbutton, FSMissileUI, 10)
LayoutHelpers.DepthOverParent(mbbutton, FSMissileUI, 10)


m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

mfwbutton.OnClick = function(self)
mfwbuttonpress = mfwbuttonpress + 1
if mfwbuttonpress == 1 then
mbbuttonpress = 1
LOG(mfwbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/uefm4.dds')
missile2:SetTexture('/mods/Commander Survival Kit/textures/uefm5.dds')
missile3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FS3MissileUI:Hide()
m3onebuttonlrg:Hide()



m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
--CreateBarrageOnHover(ID[1])
end
end

if mfwbuttonpress == 2 then
mbbuttonpress = 0
LOG(mfwbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/uefm1.dds') 
missile2:SetTexture('/mods/Commander Survival Kit/textures/uefm2.dds') 
missile3:SetTexture('/mods/Commander Survival Kit/textures/uefm3.dds')
FS3MissileUI:Show()
m3onebuttonlrg:Show()
FS3MissileUI._closeBtn:Hide()

m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

mfwbuttonpress = 0
end
end

mbbutton.OnClick = function(self)
mbbuttonpress = mbbuttonpress + 1
if mbbuttonpress == 1 then
mfwbuttonpress = 1
LOG(mbbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/uefm4.dds')
missile2:SetTexture('/mods/Commander Survival Kit/textures/uefm5.dds')
missile3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FS3MissileUI:Hide()
m3onebuttonlrg:Hide()



m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
--CreateBarrageOnHover(ID[1])
end

end

if mbbuttonpress == 2 then
mfwbuttonpress = 0
LOG(mbbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/uefm1.dds') 
missile2:SetTexture('/mods/Commander Survival Kit/textures/uefm2.dds') 
missile3:SetTexture('/mods/Commander Survival Kit/textures/uefm3.dds')
FS3MissileUI:Show()
m3onebuttonlrg:Show()
FS3MissileUI._closeBtn:Hide()

m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

mbbuttonpress = 0
end
end

Tooltip.AddButtonTooltip(mfwbutton, "MFWtn", 1)
Tooltip.AddButtonTooltip(mbbutton, "MBBtn", 1)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
mfwbutton = UIUtil.CreateButtonStd(FSMissileUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', ">", 13, -23, -88)
mbbutton = UIUtil.CreateButtonStd(FSMissileUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "<", 13, -23, -88)	
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

missile1 = Bitmap(FS1MissileUI, '/mods/Commander Survival Kit/textures/seram1.dds')
missile2 = Bitmap(FS2MissileUI, '/mods/Commander Survival Kit/textures/seram2.dds')
missile3 = Bitmap(FS3MissileUI, '/mods/Commander Survival Kit/textures/seram3.dds')
m1onebuttonlrg = UIUtil.CreateButtonStd(FS1MissileUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "1", 13, 5, -82)
m2onebuttonlrg = UIUtil.CreateButtonStd(FS2MissileUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "1", 13, 5, -82)
m3onebuttonlrg = UIUtil.CreateButtonStd(FS3MissileUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "1", 13, 5, -82)

for i,j in FSAS1PicPosition do
	missile1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	missile2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	missile3[i]:Set(j)
end

for i,j in Button1lrgPosition do
	m1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	m2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	m3onebuttonlrg[i]:Set(j)
end

for i,j in asfwButtonPosition do
	mfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	mbbutton[i]:Set(j)
end	

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(missile1, FS1MissileUI, 10)
LayoutHelpers.DepthOverParent(missile2, FS2MissileUI, 10)
LayoutHelpers.DepthOverParent(missile3, FS3MissileUI, 10)
LayoutHelpers.DepthOverParent(m1onebuttonlrg, FS1MissileUI, 10)
LayoutHelpers.DepthOverParent(m2onebuttonlrg, FS2MissileUI, 10)
LayoutHelpers.DepthOverParent(m3onebuttonlrg, FS3MissileUI, 10)
LayoutHelpers.DepthOverParent(mfwbutton, FSMissileUI, 10)
LayoutHelpers.DepthOverParent(mbbutton, FSMissileUI, 10)


m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

mfwbutton.OnClick = function(self)
mfwbuttonpress = mfwbuttonpress + 1
if mfwbuttonpress == 1 then
mbbuttonpress = 1
LOG(mfwbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/seram4.dds') -- seram4
missile2:SetTexture('/mods/Commander Survival Kit/textures/seram5.dds') -- seram5
missile3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds') -- seram6
FS3MissileUI:Hide()
m3onebuttonlrg:Hide()



m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALNUKEMISSILEBARRAGE * categories.SERAPHIM)
--CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALNUKEMISSILEBARRAGE * categories.SERAPHIM)
--CreateBarrageOnHover(ID[1])
end
end

if mfwbuttonpress == 2 then
mbbuttonpress = 0
LOG(mfwbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/seram1.dds') 
missile2:SetTexture('/mods/Commander Survival Kit/textures/seram2.dds') 
missile3:SetTexture('/mods/Commander Survival Kit/textures/seram3.dds')
FS3MissileUI:Show()
m3onebuttonlrg:Show()
FS3MissileUI._closeBtn:Hide()

m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

mfwbuttonpress = 0
end
end

mbbutton.OnClick = function(self)
mbbuttonpress = mbbuttonpress + 1
if mbbuttonpress == 1 then
mfwbuttonpress = 1
LOG(mbbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/seram4.dds') -- seram4
missile2:SetTexture('/mods/Commander Survival Kit/textures/seram5.dds') -- seram5
missile3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds') -- seram6
FS3MissileUI:Hide()
m3onebuttonlrg:Hide()



m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALNUKEMISSILEBARRAGE * categories.SERAPHIM)
--CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.NUKEMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.ANTINUKEMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALNUKEMISSILEBARRAGE * categories.SERAPHIM)
--CreateBarrageOnHover(ID[1])
end

end

if mbbuttonpress == 2 then
mfwbuttonpress = 0
LOG(mbbuttonpress)
missile1:SetTexture('/mods/Commander Survival Kit/textures/seram1.dds') 
missile2:SetTexture('/mods/Commander Survival Kit/textures/seram2.dds') 
missile3:SetTexture('/mods/Commander Survival Kit/textures/seram3.dds')
FS3MissileUI:Show()
m3onebuttonlrg:Show()
FS3MissileUI._closeBtn:Hide()

m1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

m2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

m3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


m1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

m2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

m3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSILEBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

mbbuttonpress = 0
end
end
Tooltip.AddButtonTooltip(mfwbutton, "MFWtn", 1)
Tooltip.AddButtonTooltip(mbbutton, "MBBtn", 1)
	end
end	


FSBUI = CreateWindow(GetFrame(0),'Beam',nil,false,false,true,true,'Reinforcements',Position,Border) 
FSB1UI = CreateWindow(FSBUI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
FSB2UI = CreateWindow(FSBUI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
FSB3UI = CreateWindow(FSBUI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
--as1onebuttonlrg = UIUtil.CreateButtonStd(FSAS1UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
--as2onebuttonlrg = UIUtil.CreateButtonStd(FSAS2UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
--as3onebuttonlrg = UIUtil.CreateButtonStd(FSAS3UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
FSB1UI._closeBtn:Hide()
FSB2UI._closeBtn:Hide()
FSB3UI._closeBtn:Hide()
for i,j in FSASPosition do
	FSBUI[i]:Set(j)
end

for i,j in FSAS1Position do
	FSB1UI[i]:Set(j)
end

for i,j in FSAS2Position do
	FSB2UI[i]:Set(j)
end

for i,j in FSAS3Position do
	FSB3UI[i]:Set(j)
end


--[[
for i,j in Button1lrgPosition do
	as1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	as2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	as3onebuttonlrg[i]:Set(j)
end
]]--

local bfwbuttonpress = 0
local bbbbuttonpress = 0
local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	

if focusarmy >= 1 then
    if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

beam1 = Bitmap(FSB1UI, '/mods/Commander Survival Kit/textures/aeonb1.dds')
beam2 = Bitmap(FSB2UI, '/mods/Commander Survival Kit/textures/aeonb2.dds')
beam3 = Bitmap(FSB3UI, '/mods/Commander Survival Kit/textures/aeonb3.dds')
b1onebuttonlrg = UIUtil.CreateButtonStd(FSB1UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
b2onebuttonlrg = UIUtil.CreateButtonStd(FSB2UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
b3onebuttonlrg = UIUtil.CreateButtonStd(FSB3UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)

for i,j in FSAS1PicPosition do
	beam1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	beam2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	beam3[i]:Set(j)
end

for i,j in Button1lrgPosition do
	b1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	b2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	b3onebuttonlrg[i]:Set(j)
end

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(beam1, FSB1UI, 10)
LayoutHelpers.DepthOverParent(beam2, FSB2UI, 10)
LayoutHelpers.DepthOverParent(beam3, FSB3UI, 10)
LayoutHelpers.DepthOverParent(b1onebuttonlrg, FSB1UI, 10)
LayoutHelpers.DepthOverParent(b2onebuttonlrg, FSB2UI, 10)
LayoutHelpers.DepthOverParent(b3onebuttonlrg, FSB3UI, 10)


b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end


bfwbutton = UIUtil.CreateButtonStd(FSBUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', ">", 13, -23, -88)
bbbbutton = UIUtil.CreateButtonStd(FSBUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "<", 13, -23, -88)


for i,j in asfwButtonPosition do
	bfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	bbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(bfwbutton, FSBUI, 10)
LayoutHelpers.DepthOverParent(bbbbutton, FSBUI, 10)


bfwbutton.OnClick = function(self)
bfwbuttonpress = bfwbuttonpress + 1
if bfwbuttonpress == 1 then
bbbbuttonpress = 1
LOG(bfwbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/aeonb4.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/aeonb5.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FSB3UI:Hide()
b3onebuttonlrg:Hide()



b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrageOnHover(ID[1])
end
end

if bfwbuttonpress == 2 then
bbbbuttonpress = 0
LOG(bfwbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/aeonb1.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/aeonb2.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/aeonb3.dds')
FSB2UI:Show()
b2onebuttonlrg:Show()
FSB2UI._closeBtn:Hide()
FSB3UI:Show()
b3onebuttonlrg:Show()
FSB3UI._closeBtn:Hide()

b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

bfwbuttonpress = 0
end
end

bbbbutton.OnClick = function(self)
bbbbuttonpress = bbbbuttonpress + 1
if bbbbuttonpress == 1 then
bfwbuttonpress = 1
LOG(bbbbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/aeonb4.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/aeonb5.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FSB3UI:Hide()
b3onebuttonlrg:Hide()



b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrageOnHover(ID[1])
end

end

if bbbbuttonpress == 2 then
bfwbuttonpress = 0
LOG(bbbbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/aeonb1.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/aeonb2.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/aeonb3.dds')
FSB2UI:Show()
b2onebuttonlrg:Show()
FSB2UI._closeBtn:Hide()
FSB3UI:Show()
b3onebuttonlrg:Show()
FSB3UI._closeBtn:Hide()

b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

bbbbuttonpress = 0
end
end

Tooltip.AddButtonTooltip(bfwbutton, "BFWtn", 1)
Tooltip.AddButtonTooltip(bbbbutton, "BBBtn", 1)

	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

beam1 = Bitmap(FSB1UI, '/mods/Commander Survival Kit/textures/cybranb1.dds')
beam2 = Bitmap(FSB2UI, '/mods/Commander Survival Kit/textures/cybranb2.dds')
beam3 = Bitmap(FSB3UI, '/mods/Commander Survival Kit/textures/cybranb3.dds')
b1onebuttonlrg = UIUtil.CreateButtonStd(FSB1UI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "1", 13, 5, -82)
b2onebuttonlrg = UIUtil.CreateButtonStd(FSB2UI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "1", 13, 5, -82)
b3onebuttonlrg = UIUtil.CreateButtonStd(FSB3UI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "1", 13, 5, -82)

for i,j in FSAS1PicPosition do
	beam1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	beam2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	beam3[i]:Set(j)
end

for i,j in Button1lrgPosition do
	b1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	b2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	b3onebuttonlrg[i]:Set(j)
end

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(beam1, FSB1UI, 10)
LayoutHelpers.DepthOverParent(beam2, FSB2UI, 10)
LayoutHelpers.DepthOverParent(beam3, FSB3UI, 10)
LayoutHelpers.DepthOverParent(b1onebuttonlrg, FSB1UI, 10)
LayoutHelpers.DepthOverParent(b2onebuttonlrg, FSB2UI, 10)
LayoutHelpers.DepthOverParent(b3onebuttonlrg, FSB3UI, 10)


b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end


bfwbutton = UIUtil.CreateButtonStd(FSBUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', ">", 13, -23, -88)
bbbbutton = UIUtil.CreateButtonStd(FSBUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "<", 13, -23, -88)


for i,j in asfwButtonPosition do
	bfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	bbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(bfwbutton, FSBUI, 10)
LayoutHelpers.DepthOverParent(bbbbutton, FSBUI, 10)


bfwbutton.OnClick = function(self)
bfwbuttonpress = bfwbuttonpress + 1
if bfwbuttonpress == 1 then
bbbbuttonpress = 1
LOG(bfwbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/cybranb4.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/cybranb5.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FSB3UI:Hide()
b3onebuttonlrg:Hide()



b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrageStrike(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrageOnHover(ID[1])
end
end

if bfwbuttonpress == 2 then
bbbbuttonpress = 0
LOG(bfwbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/cybranb1.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/cybranb2.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/cybranb3.dds')
FSB2UI:Show()
b2onebuttonlrg:Show()
FSB2UI._closeBtn:Hide()
FSB3UI:Show()
b3onebuttonlrg:Show()
FSB3UI._closeBtn:Hide()

b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

bfwbuttonpress = 0
end
end

bbbbutton.OnClick = function(self)
bbbbuttonpress = bbbbuttonpress + 1
if bbbbuttonpress == 1 then
bfwbuttonpress = 1
LOG(bbbbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/cybranb4.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/cybranb5.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FSB3UI:Hide()
b3onebuttonlrg:Hide()



b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrageOnHover(ID[1])
end

end

if bbbbuttonpress == 2 then
bfwbuttonpress = 0
LOG(bbbbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/cybranb1.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/cybranb2.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/cybranb3.dds')
FSB2UI:Show()
b2onebuttonlrg:Show()
FSB2UI._closeBtn:Hide()
FSB3UI:Show()
b3onebuttonlrg:Show()
FSB3UI._closeBtn:Hide()

b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

bbbbuttonpress = 0
end
end

Tooltip.AddButtonTooltip(bfwbutton, "BFWtn", 1)
Tooltip.AddButtonTooltip(bbbbutton, "BBBtn", 1)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

beam1 = Bitmap(FSB1UI, '/mods/Commander Survival Kit/textures/uefb1.dds')
beam2 = Bitmap(FSB2UI, '/mods/Commander Survival Kit/textures/uefb2.dds')
beam3 = Bitmap(FSB3UI, '/mods/Commander Survival Kit/textures/uefb3.dds')
b1onebuttonlrg = UIUtil.CreateButtonStd(FSB1UI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "1", 13, 5, -82)
b2onebuttonlrg = UIUtil.CreateButtonStd(FSB2UI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "1", 13, 5, -82)
b3onebuttonlrg = UIUtil.CreateButtonStd(FSB3UI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "1", 13, 5, -82)

for i,j in FSAS1PicPosition do
	beam1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	beam2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	beam3[i]:Set(j)
end

for i,j in Button1lrgPosition do
	b1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	b2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	b3onebuttonlrg[i]:Set(j)
end

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(beam1, FSB1UI, 10)
LayoutHelpers.DepthOverParent(beam2, FSB2UI, 10)
LayoutHelpers.DepthOverParent(beam3, FSB3UI, 10)
LayoutHelpers.DepthOverParent(b1onebuttonlrg, FSB1UI, 10)
LayoutHelpers.DepthOverParent(b2onebuttonlrg, FSB2UI, 10)
LayoutHelpers.DepthOverParent(b3onebuttonlrg, FSB3UI, 10)


b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end


bfwbutton = UIUtil.CreateButtonStd(FSBUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', ">", 13, -23, -88)
bbbbutton = UIUtil.CreateButtonStd(FSBUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "<", 13, -23, -88)


for i,j in asfwButtonPosition do
	bfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	bbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(bfwbutton, FSBUI, 10)
LayoutHelpers.DepthOverParent(bbbbutton, FSBUI, 10)


bfwbutton.OnClick = function(self)
bfwbuttonpress = bfwbuttonpress + 1
if bfwbuttonpress == 1 then
bbbbuttonpress = 1
LOG(bfwbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/uefb4.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/uefb5.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FSB3UI:Hide()
b3onebuttonlrg:Hide()



b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
--CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
--CreateBarrageOnHover(ID[1])
end
end

if bfwbuttonpress == 2 then
bbbbuttonpress = 0
LOG(bfwbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/uefb1.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/uefb2.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/uefb3.dds')
FSB2UI:Show()
b2onebuttonlrg:Show()
FSB2UI._closeBtn:Hide()
FSB3UI:Show()
b3onebuttonlrg:Show()
FSB3UI._closeBtn:Hide()

b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end
bfwbuttonpress = 0
end

end

bbbbutton.OnClick = function(self)
bbbbuttonpress = bbbbuttonpress + 1
if bbbbuttonpress == 1 then
bfwbuttonpress = 1
LOG(bbbbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/uefb4.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/uefb5.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FSB3UI:Hide()
b3onebuttonlrg:Hide()



b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
--CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
--CreateBarrageOnHover(ID[1])
end

end

if bbbbuttonpress == 2 then
bfwbuttonpress = 0
LOG(bbbbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/uefb1.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/uefb2.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/uefb3.dds')
FSB2UI:Show()
b2onebuttonlrg:Show()
FSB2UI._closeBtn:Hide()
FSB3UI:Show()
b3onebuttonlrg:Show()
FSB3UI._closeBtn:Hide()

b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

bbbbuttonpress = 0
end
end

Tooltip.AddButtonTooltip(bfwbutton, "BFWtn", 1)
Tooltip.AddButtonTooltip(bbbbutton, "BBBtn", 1)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

beam1 = Bitmap(FSB1UI, '/mods/Commander Survival Kit/textures/serab1.dds')
beam2 = Bitmap(FSB2UI, '/mods/Commander Survival Kit/textures/serab2.dds')
beam3 = Bitmap(FSB3UI, '/mods/Commander Survival Kit/textures/serab3.dds')
b1onebuttonlrg = UIUtil.CreateButtonStd(FSB1UI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "1", 13, 5, -82)
b2onebuttonlrg = UIUtil.CreateButtonStd(FSB2UI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "1", 13, 5, -82)
b3onebuttonlrg = UIUtil.CreateButtonStd(FSB3UI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "1", 13, 5, -82)

for i,j in FSAS1PicPosition do
	beam1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	beam2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	beam3[i]:Set(j)
end

for i,j in Button1lrgPosition do
	b1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	b2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	b3onebuttonlrg[i]:Set(j)
end

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(beam1, FSB1UI, 10)
LayoutHelpers.DepthOverParent(beam2, FSB2UI, 10)
LayoutHelpers.DepthOverParent(beam3, FSB3UI, 10)
LayoutHelpers.DepthOverParent(b1onebuttonlrg, FSB1UI, 10)
LayoutHelpers.DepthOverParent(b2onebuttonlrg, FSB2UI, 10)
LayoutHelpers.DepthOverParent(b3onebuttonlrg, FSB3UI, 10)


b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end


bfwbutton = UIUtil.CreateButtonStd(FSBUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', ">", 13, -23, -88)
bbbbutton = UIUtil.CreateButtonStd(FSBUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "<", 13, -23, -88)


for i,j in asfwButtonPosition do
	bfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	bbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(bfwbutton, FSBUI, 10)
LayoutHelpers.DepthOverParent(bbbbutton, FSBUI, 10)


bfwbutton.OnClick = function(self)
bfwbuttonpress = bfwbuttonpress + 1
if bfwbuttonpress == 1 then
bbbbuttonpress = 1
LOG(bfwbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/serab4.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')
FSB2UI:Hide()
b2onebuttonlrg:Hide()
FSB3UI:Hide()
b3onebuttonlrg:Hide()



b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.SERAPHIM)
--CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.SERAPHIM)
--CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrageOnHover(ID[1])
end
end

if bfwbuttonpress == 2 then
bbbbuttonpress = 0
LOG(bfwbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/serab1.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/serab2.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/serab3.dds')
FSB2UI:Show()
b2onebuttonlrg:Show()
FSB2UI._closeBtn:Hide()
FSB3UI:Show()
b3onebuttonlrg:Show()
FSB3UI._closeBtn:Hide()

b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

bfwbuttonpress = 0
end
end

bbbbutton.OnClick = function(self)
bbbbuttonpress = bbbbuttonpress + 1
if bbbbuttonpress == 1 then
bfwbuttonpress = 1
LOG(bbbbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/serab4.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/empty.dds')
FSB2UI:Hide()
b2onebuttonlrg:Hide()
FSB3UI:Hide()
b3onebuttonlrg:Hide()



b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrageOnHover(ID[1])
end

end

if bbbbuttonpress == 2 then
bfwbuttonpress = 0
LOG(bbbbuttonpress)
beam1:SetTexture('/mods/Commander Survival Kit/textures/serab1.dds')
beam2:SetTexture('/mods/Commander Survival Kit/textures/serab2.dds')
beam3:SetTexture('/mods/Commander Survival Kit/textures/serab3.dds')
FSB2UI:Show()
b2onebuttonlrg:Show()
FSB2UI._closeBtn:Hide()
FSB3UI:Show()
b3onebuttonlrg:Show()
FSB3UI._closeBtn:Hide()

b1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

b2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

b3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


b1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

b2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

b3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

bbbbuttonpress = 0
end
end

Tooltip.AddButtonTooltip(bfwbutton, "BFWtn", 1)
Tooltip.AddButtonTooltip(bbbbutton, "BBBtn", 1)
	end
end	


FSSPUI = CreateWindow(GetFrame(0),'Special',nil,false,false,true,true,'Reinforcements',Position,Border) 
FSSP1UI = CreateWindow(FSSPUI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
FSSP2UI = CreateWindow(FSSPUI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
FSSP3UI = CreateWindow(FSSPUI,nil,nil,false,false,true,true,'Reinforcements',Position,Border) 
--as1onebuttonlrg = UIUtil.CreateButtonStd(FSAS1UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
--as2onebuttonlrg = UIUtil.CreateButtonStd(FSAS2UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
--as3onebuttonlrg = UIUtil.CreateButtonStd(FSAS3UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
FSSP1UI._closeBtn:Hide()
FSSP2UI._closeBtn:Hide()
FSSP3UI._closeBtn:Hide()
for i,j in FSASPosition do
	FSSPUI[i]:Set(j)
end

for i,j in FSAS1Position do
	FSSP1UI[i]:Set(j)
end

for i,j in FSAS2Position do
	FSSP2UI[i]:Set(j)
end

for i,j in FSAS3Position do
	FSSP3UI[i]:Set(j)
end


--[[
for i,j in Button1lrgPosition do
	as1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	as2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	as3onebuttonlrg[i]:Set(j)
end
]]--

local spfwbuttonpress = 0
local spbbbuttonpress = 0
local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	

if focusarmy >= 1 then
    if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

special1 = Bitmap(FSSP1UI, '/mods/Commander Survival Kit/textures/aeonsp1.dds')
special2 = Bitmap(FSSP2UI, '/mods/Commander Survival Kit/textures/aeonsp2.dds')
special3 = Bitmap(FSSP3UI, '/mods/Commander Survival Kit/textures/aeonsp3.dds')
sp1onebuttonlrg = UIUtil.CreateButtonStd(FSSP1UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
sp2onebuttonlrg = UIUtil.CreateButtonStd(FSSP2UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)
sp3onebuttonlrg = UIUtil.CreateButtonStd(FSSP3UI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "1", 13, 5, -82)

for i,j in FSAS1PicPosition do
	special1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	special2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	special3[i]:Set(j)
end

for i,j in Button1lrgPosition do
	sp1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	sp2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	sp3onebuttonlrg[i]:Set(j)
end

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(special1, FSSP1UI, 10)
LayoutHelpers.DepthOverParent(special2, FSSP2UI, 10)
LayoutHelpers.DepthOverParent(special3, FSSP3UI, 10)
LayoutHelpers.DepthOverParent(sp1onebuttonlrg, FSSP1UI, 10)
LayoutHelpers.DepthOverParent(sp2onebuttonlrg, FSSP2UI, 10)
LayoutHelpers.DepthOverParent(sp3onebuttonlrg, FSSP3UI, 10)


sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.SPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.SPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end


spfwbutton = UIUtil.CreateButtonStd(FSSPUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', ">", 13, -23, -88)
spbbbutton = UIUtil.CreateButtonStd(FSSPUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "<", 13, -23, -88)


for i,j in asfwButtonPosition do
	spfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	spbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(spfwbutton, FSSPUI, 10)
LayoutHelpers.DepthOverParent(spbbbutton, FSSPUI, 10)


spfwbutton.OnClick = function(self)
spfwbuttonpress = spfwbuttonpress + 1
if spfwbuttonpress == 1 then
spbbbuttonpress = 1
LOG(spfwbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/aeonsp4.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/aeonsp5.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FSSP3UI:Hide()
sp3onebuttonlrg:Hide()


sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrageOnHover(ID[1])
end
end

if spfwbuttonpress == 2 then
spbbbuttonpress = 0
LOG(spfwbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/aeonsp1.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/aeonsp2.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/aeonsp3.dds')
FSSP3UI:Show()
sp3onebuttonlrg:Show()
FSSP3UI._closeBtn:Hide()

sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.SPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.SPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

spfwbuttonpress = 0
end
end

spbbbutton.OnClick = function(self)
spbbbuttonpress = spbbbuttonpress + 1
if spbbbuttonpress == 1 then
spfwbuttonpress = 1
LOG(spbbbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/aeonsp4.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/aeonsp5.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FSSP3UI:Hide()
sp3onebuttonlrg:Hide()


sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrageOnHover(ID[1])
end

end

if spbbbuttonpress == 2 then
spfwbuttonpress = 0
LOG(spbbbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/aeonsp1.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/aeonsp2.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/aeonsp3.dds')
FSSP3UI:Show()
sp3onebuttonlrg:Show()
FSSP3UI._closeBtn:Hide()

sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.SPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.SPECIALARTILLERYBARRAGE * categories.AEON)
CreateBarrageOnHover(ID[1])
end

spbbbuttonpress = 0
end
end

Tooltip.AddButtonTooltip(spfwbutton, "SPFWtn", 1)
Tooltip.AddButtonTooltip(spbbbutton, "SPBBtn", 1)

	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

special1 = Bitmap(FSSP1UI, '/mods/Commander Survival Kit/textures/cybransp1.dds')
special2 = Bitmap(FSSP2UI, '/mods/Commander Survival Kit/textures/cybransp2.dds')
special3 = Bitmap(FSSP3UI, '/mods/Commander Survival Kit/textures/cybransp3.dds')
sp1onebuttonlrg = UIUtil.CreateButtonStd(FSSP1UI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "1", 13, 5, -82)
sp2onebuttonlrg = UIUtil.CreateButtonStd(FSSP2UI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "1", 13, 5, -82)
sp3onebuttonlrg = UIUtil.CreateButtonStd(FSSP3UI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "1", 13, 5, -82)

for i,j in FSAS1PicPosition do
	special1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	special2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	special3[i]:Set(j)
end

for i,j in Button1lrgPosition do
	sp1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	sp2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	sp3onebuttonlrg[i]:Set(j)
end

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(special1, FSSP1UI, 10)
LayoutHelpers.DepthOverParent(special2, FSSP2UI, 10)
LayoutHelpers.DepthOverParent(special3, FSSP3UI, 10)
LayoutHelpers.DepthOverParent(sp1onebuttonlrg, FSSP1UI, 10)
LayoutHelpers.DepthOverParent(sp2onebuttonlrg, FSSP2UI, 10)
LayoutHelpers.DepthOverParent(sp3onebuttonlrg, FSSP3UI, 10)


sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

spfwbutton = UIUtil.CreateButtonStd(FSSPUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', ">", 13, -23, -88)
spbbbutton = UIUtil.CreateButtonStd(FSSPUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "<", 13, -23, -88)


for i,j in asfwButtonPosition do
	spfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	spbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(spfwbutton, FSSPUI, 10)
LayoutHelpers.DepthOverParent(spbbbutton, FSSPUI, 10)


spfwbutton.OnClick = function(self)
spfwbuttonpress = spfwbuttonpress + 1
if spfwbuttonpress == 1 then
spbbbuttonpress = 1
LOG(spfwbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/cybransp4.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/cybransp5.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FSSP3UI:Hide()
sp3onebuttonlrg:Hide()


sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrageOnHover(ID[1])
end
end

if spfwbuttonpress == 2 then
spbbbuttonpress = 0
LOG(spfwbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/cybransp1.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/cybransp2.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/cybransp3.dds')
FSSP3UI:Show()
sp3onebuttonlrg:Show()
FSSP3UI._closeBtn:Hide()

sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

spfwbuttonpress = 0
end
end

spbbbutton.OnClick = function(self)
spbbbuttonpress = spbbbuttonpress + 1
if spbbbuttonpress == 1 then
spfwbuttonpress = 1
LOG(spbbbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/cybransp4.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/cybransp5.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FSSP3UI:Hide()
sp3onebuttonlrg:Hide()


sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
--CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
--CreateBarrageOnHover(ID[1])
end

end

if spbbbuttonpress == 2 then
spfwbuttonpress = 0
LOG(spbbbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/cybransp1.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/cybransp2.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/cybransp3.dds')
FSSP3UI:Show()
sp3onebuttonlrg:Show()
FSSP3UI._closeBtn:Hide()

sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.CYBRAN)
CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.CYBRAN)
CreateBarrageOnHover(ID[1])
end

spbbbuttonpress = 0
end
end

Tooltip.AddButtonTooltip(spfwbutton, "SPFWtn", 1)
Tooltip.AddButtonTooltip(spbbbutton, "SPBBtn", 1)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

special1 = Bitmap(FSSP1UI, '/mods/Commander Survival Kit/textures/uefsp1.dds')
special2 = Bitmap(FSSP2UI, '/mods/Commander Survival Kit/textures/uefsp2.dds')
special3 = Bitmap(FSSP3UI, '/mods/Commander Survival Kit/textures/uefsp3.dds')
sp1onebuttonlrg = UIUtil.CreateButtonStd(FSSP1UI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "1", 13, 5, -82)
sp2onebuttonlrg = UIUtil.CreateButtonStd(FSSP2UI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "1", 13, 5, -82)
sp3onebuttonlrg = UIUtil.CreateButtonStd(FSSP3UI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "1", 13, 5, -82)


for i,j in FSAS1PicPosition do
	special1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	special2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	special3[i]:Set(j)
end

for i,j in Button1lrgPosition do
	sp1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	sp2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	sp3onebuttonlrg[i]:Set(j)
end

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(special1, FSSP1UI, 10)
LayoutHelpers.DepthOverParent(special2, FSSP2UI, 10)
LayoutHelpers.DepthOverParent(special3, FSSP3UI, 10)
LayoutHelpers.DepthOverParent(sp1onebuttonlrg, FSSP1UI, 10)
LayoutHelpers.DepthOverParent(sp2onebuttonlrg, FSSP2UI, 10)
LayoutHelpers.DepthOverParent(sp3onebuttonlrg, FSSP3UI, 10)


sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.SPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.SPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end


spfwbutton = UIUtil.CreateButtonStd(FSSPUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', ">", 13, -23, -88)
spbbbutton = UIUtil.CreateButtonStd(FSSPUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "<", 13, -23, -88)


for i,j in asfwButtonPosition do
	spfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	spbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(spfwbutton, FSSPUI, -10)
LayoutHelpers.DepthOverParent(spbbbutton, FSSPUI, -10)


spfwbutton.OnClick = function(self)
spfwbuttonpress = spfwbuttonpress + 1
if spfwbuttonpress == 1 then
spbbbuttonpress = 1
LOG(spfwbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/uefsp4.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/uefsp5.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FSSP3UI:Hide()
sp3onebuttonlrg:Hide()


sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
--CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
--CreateBarrageOnHover(ID[1])
end
end

if spfwbuttonpress == 2 then
spbbbuttonpress = 0
LOG(spfwbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/uefsp1.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/uefsp2.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/uefsp3.dds')
FSSP3UI:Show()
sp3onebuttonlrg:Show()
FSSP3UI._closeBtn:Hide()

sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.SPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.SPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

spfwbuttonpress = 0
end
end

spbbbutton.OnClick = function(self)
spbbbuttonpress = spbbbuttonpress + 1
if spbbbuttonpress == 1 then
spfwbuttonpress = 1
LOG(spbbbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/uefsp4.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/uefsp5.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FSSP3UI:Hide()
sp3onebuttonlrg:Hide()


sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
--CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
--CreateBarrageOnHover(ID[1])
end

end

if spbbbuttonpress == 2 then
spfwbuttonpress = 0
LOG(spbbbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/uefsp1.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/uefsp2.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/uefsp3.dds')
FSSP3UI:Show()
sp3onebuttonlrg:Show()
FSSP3UI._closeBtn:Hide()

sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.SPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.SPECIALARTILLERYBARRAGE * categories.UEF)
CreateBarrageOnHover(ID[1])
end

spbbbuttonpress = 0
end
end

Tooltip.AddButtonTooltip(spfwbutton, "SPFWtn", 1)
Tooltip.AddButtonTooltip(spbbbutton, "SPBBtn", 1)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
--[[
Text = CreateText(FSAS1UI)	
Text:SetFont('Arial',11) --Oh well . You must have font and larger depth otherwise text would not come out
Text:SetColor('FFbadbdb')
Text:SetText('[...COMING SOON...]')
Text.Depth:Set(30)

LayoutHelpers.AtCenterIn(Text, FSAS1UI)
]]--

special1 = Bitmap(FSSP1UI, '/mods/Commander Survival Kit/textures/serasp1.dds')
special2 = Bitmap(FSSP2UI, '/mods/Commander Survival Kit/textures/serasp2.dds')
special3 = Bitmap(FSSP3UI, '/mods/Commander Survival Kit/textures/serasp3.dds')
sp1onebuttonlrg = UIUtil.CreateButtonStd(FSSP1UI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "1", 13, 5, -82)
sp2onebuttonlrg = UIUtil.CreateButtonStd(FSSP2UI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "1", 13, 5, -82)
sp3onebuttonlrg = UIUtil.CreateButtonStd(FSSP3UI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "1", 13, 5, -82)

for i,j in FSAS1PicPosition do
	special1[i]:Set(j)
end

for i,j in FSAS2PicPosition do
	special2[i]:Set(j)
end

for i,j in FSAS3PicPosition do
	special3[i]:Set(j)
end

for i,j in Button1lrgPosition do
	sp1onebuttonlrg[i]:Set(j)
end

for i,j in Button2lrgPosition do
	sp2onebuttonlrg[i]:Set(j)
end

for i,j in Button3lrgPosition do
	sp3onebuttonlrg[i]:Set(j)
end

--Tooltip.AddButtonTooltip(as1onebutton, "asboneBtn", 1)
--Tooltip.AddButtonTooltip(as1fivebutton, "asbfiveBtn", 1)
--Tooltip.AddButtonTooltip(as1tenbutton, "asbtenBtn", 1)


LayoutHelpers.DepthOverParent(special1, FSSP1UI, 10)
LayoutHelpers.DepthOverParent(special2, FSSP2UI, 10)
LayoutHelpers.DepthOverParent(special3, FSSP3UI, 10)
LayoutHelpers.DepthOverParent(sp1onebuttonlrg, FSSP1UI, 10)
LayoutHelpers.DepthOverParent(sp2onebuttonlrg, FSSP2UI, 10)
LayoutHelpers.DepthOverParent(sp3onebuttonlrg, FSSP3UI, 10)


sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end


spfwbutton = UIUtil.CreateButtonStd(FSSPUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', ">", 13, -23, -88)
spbbbutton = UIUtil.CreateButtonStd(FSSPUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "<", 13, -23, -88)


for i,j in asfwButtonPosition do
	spfwbutton[i]:Set(j)
end
for i,j in asbbButtonPosition do
	spbbbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(spfwbutton, FSSPUI, 10)
LayoutHelpers.DepthOverParent(spbbbutton, FSSPUI, 10)


spfwbutton.OnClick = function(self)
--[[
spfwbuttonpress = spfwbuttonpress + 1
if spfwbuttonpress == 1 then
spbbbuttonpress = 1
LOG(spfwbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/serasp4.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')

FSSP2UI:Hide()
sp2onebuttonlrg:Hide()
FSSP3UI:Hide()
sp3onebuttonlrg:Hide()


sp1onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALBARRAGE * categories.SERAPHIM)
--CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALBARRAGE * categories.SERAPHIM)
--CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALBARRAGE * categories.SERAPHIM)
--CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALBARRAGE * categories.SERAPHIM)
--CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrageOnHover(ID[1])
end
end

if spfwbuttonpress == 2 then
spbbbuttonpress = 0
LOG(spfwbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/serasp1.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/serasp2.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/serasp3.dds')
FSSP2UI:Show()
sp2onebuttonlrg:Show()
FSSP2UI._closeBtn:Hide()
FSSP3UI:Show()
sp3onebuttonlrg:Show()
FSSP3UI._closeBtn:Hide()

sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

spfwbuttonpress = 0
end
]]--
end

spbbbutton.OnClick = function(self)
--[[
spbbbuttonpress = spbbbuttonpress + 1
if spbbbuttonpress == 1 then
spfwbuttonpress = 1
LOG(spbbbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/serasp4.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/emptytext.dds')
FSSP2UI:Hide()
sp2onebuttonlrg:Hide()
FSSP3UI:Hide()
sp3onebuttonlrg:Hide()


sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALBARRAGE * categories.SERAPHIM)
CreateBarrage(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALBARRAGE * categories.SERAPHIM)
--CreateBarrage(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrage(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.HEAVYSPECIALBARRAGE * categories.SERAPHIM)
CreateBarrageOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALBARRAGE * categories.SERAPHIM)
--CreateBarrageOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
--local ID = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
--CreateBarrageOnHover(ID[1])
end

end

if spbbbuttonpress == 2 then
spfwbuttonpress = 0
LOG(spbbbuttonpress)
special1:SetTexture('/mods/Commander Survival Kit/textures/serasp1.dds')
special2:SetTexture('/mods/Commander Survival Kit/textures/serasp2.dds')
special3:SetTexture('/mods/Commander Survival Kit/textures/serasp3.dds')
FSSP2UI:Show()
sp2onebuttonlrg:Show()
FSSP2UI._closeBtn:Hide()
FSSP3UI:Show()
sp3onebuttonlrg:Show()
FSSP3UI._closeBtn:Hide()

sp1onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.SERAPHIM)
CreateAirStrike(ID[1])
end

sp2onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.SERAPHIM)
CreateAirStrike(ID[1])
end

sp3onebuttonlrg.OnClick = function(self)
local ID = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.SERAPHIM)
CreateAirStrike(ID[1])
end


sp1onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1])
end

sp2onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1])
end

sp3onebuttonlrg.OnRolloverEvent = function(self) 
local ID = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.SERAPHIM)
CreateAirStrikeOnHover(ID[1])
end

spbbbuttonpress = 0
end
]]--
end

Tooltip.AddButtonTooltip(spfwbutton, "CSPFWtn", 1)
Tooltip.AddButtonTooltip(spbbbutton, "CSPBBtn", 1)
	end
end	

--[[
FSSPUI = CreateWindow(GetFrame(0),'Special',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in FSMissilePosition do 
	FSSPUI[i]:Set(v)
end
FSSPUI._closeBtn:Hide()
FSSPUI.Images = {} 
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()		
if FBPOPath then
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSPUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.SPECIALARTILLERYBARRAGE * categories.AEON)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYSPECIALARTILLERYBARRAGE * categories.AEON)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALARTILLERYBARRAGE * categories.AEON)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level4) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level5) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSPUI.Images[c] = CreateFSButton(FSSPUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
		SetFSSPBtnTextures2(FSSPUI.Images[c],id) 
		FSSPUI.Images[c].correspondedID = id
		LOG(table.getn(FSSPUI.Images))
	end
	increasedFSBorder(FSSPUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSPUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.CYBRAN)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYSPECIALBARRAGE * categories.CYBRAN)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALBARRAGE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level4) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level5) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSPUI.Images[c] = CreateFSButton(FSSPUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
		SetFSSPBtnTextures2(FSSPUI.Images[c],id) 
		FSSPUI.Images[c].correspondedID = id
		LOG(table.getn(FSSPUI.Images))
			end
			increasedFSBorder(FSSPUI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSPUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYSPECIALARTILLERYBARRAGE * categories.UEF)
	local Level4 = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALARTILLERYBARRAGE * categories.UEF)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level4) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSPUI.Images[c] = CreateFSButton(FSSPUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
		SetFSSPBtnTextures2(FSSPUI.Images[c],id) 
		FSSPUI.Images[c].correspondedID = id
		LOG(table.getn(FSSPUI.Images))
	end
		increasedFSBorder(FSSPUI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSPUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSPUI.Images[c] = CreateFSButton(FSSPUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
		SetFSSPBtnTextures(FSSPUI.Images[c],id) 
		FSSPUI.Images[c].correspondedID = id
		LOG(table.getn(FSSPUI.Images))
	end
		increasedFSBorder(FSSPUI,15)
		existed = {}
    end	
	    end
	LOG('Active')
else
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSPUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.SPECIALARTILLERYBARRAGE * categories.AEON)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYSPECIALARTILLERYBARRAGE * categories.AEON)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALARTILLERYBARRAGE * categories.AEON)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level4) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level5) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSPUI.Images[c] = CreateFSButton(FSSPUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
		SetFSSPBtnTextures2(FSSPUI.Images[c],id) 
		FSSPUI.Images[c].correspondedID = id
		LOG(table.getn(FSSPUI.Images))
	end
	increasedFSBorder(FSSPUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSPUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.CYBRAN)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYSPECIALBARRAGE * categories.CYBRAN)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALBARRAGE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level4) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level5) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSPUI.Images[c] = CreateFSButton(FSSPUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
		SetFSSPBtnTextures2(FSSPUI.Images[c],id) 
		FSSPUI.Images[c].correspondedID = id
		LOG(table.getn(FSSPUI.Images))
			end
			increasedFSBorder(FSSPUI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSPUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTSPECIALARTILLERYBARRAGE * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMSPECIALARTILLERYBARRAGE * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYSPECIALARTILLERYBARRAGE * categories.UEF)
	local Level4 = EntityCategoryGetUnitList(categories.EXPERIMENTALSPECIALARTILLERYBARRAGE * categories.UEF)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level4) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSPUI.Images[c] = CreateFSButton(FSSPUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
		SetFSSPBtnTextures2(FSSPUI.Images[c],id) 
		FSSPUI.Images[c].correspondedID = id
		LOG(table.getn(FSSPUI.Images))
	end
		increasedFSBorder(FSSPUI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSPUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTSPECIALBARRAGE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMSPECIALBARRAGE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.SPECIALBARRAGE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSPUI.Images[c] = CreateFSButton(FSSPUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
		SetFSSPBtnTextures(FSSPUI.Images[c],id) 
		FSSPUI.Images[c].correspondedID = id
		LOG(table.getn(FSSPUI.Images))
	end
		increasedFSBorder(FSSPUI,15)
		existed = {}
    end	
LOG('Not active')
    end
end 

]]--

FSSpaceUI = CreateWindow(GetFrame(0),'Space',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in FSMissilePosition do 
	FSSpaceUI[i]:Set(v)
end
FSSpaceUI._closeBtn:Hide()
FSSpaceUI.Images = {} 
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()		
if FBPOPath then
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSpaceUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.METEORSHOWER * categories.UEF)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSpaceUI.Images[c] = CreateFSButton(FSSpaceUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSpaceUI),x,FSSpaceUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSSpaceUI.Images[c],id) 
		FSSpaceUI.Images[c].correspondedID = id
		LOG(table.getn(FSSpaceUI.Images))
	end
	increasedFSBorder(FSSpaceUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSpaceUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.METEORSHOWER * categories.UEF)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSpaceUI.Images[c] = CreateFSButton(FSSpaceUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSpaceUI),x,FSSpaceUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSSpaceUI.Images[c],id) 
		FSSpaceUI.Images[c].correspondedID = id
		LOG(table.getn(FSSpaceUI.Images))
			end
			increasedFSBorder(FSSpaceUI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSpaceUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.METEORSHOWER * categories.UEF)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSpaceUI.Images[c] = CreateFSButton(FSSpaceUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSpaceUI),x,FSSpaceUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSSpaceUI.Images[c],id) 
		FSSpaceUI.Images[c].correspondedID = id
		LOG(table.getn(FSSpaceUI.Images))
	end
		increasedFSBorder(FSSpaceUI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSpaceUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.METEORSHOWER * categories.UEF)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSpaceUI.Images[c] = CreateFSButton(FSSpaceUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSpaceUI),x,FSSpaceUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSSpaceUI.Images[c],id) 
		FSSpaceUI.Images[c].correspondedID = id
		LOG(table.getn(FSSpaceUI.Images))
	end
		increasedFSBorder(FSSpaceUI,15)
		existed = {}
    end	
	    end
	LOG('Active')
else
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSpaceUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.METEORSHOWER * categories.UEF)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSpaceUI.Images[c] = CreateFSButton(FSSpaceUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSpaceUI),x,FSSpaceUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSSpaceUI.Images[c],id) 
		FSSpaceUI.Images[c].correspondedID = id
		LOG(table.getn(FSSpaceUI.Images))
	end
	increasedFSBorder(FSSpaceUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSpaceUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.METEORSHOWER * categories.UEF)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSpaceUI.Images[c] = CreateFSButton(FSSpaceUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSpaceUI),x,FSSpaceUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSSpaceUI.Images[c],id) 
		FSSpaceUI.Images[c].correspondedID = id
		LOG(table.getn(FSSpaceUI.Images))
			end
			increasedFSBorder(FSSpaceUI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSpaceUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.METEORSHOWER * categories.UEF)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSpaceUI.Images[c] = CreateFSButton(FSSpaceUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSpaceUI),x,FSSpaceUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSSpaceUI.Images[c],id) 
		FSSpaceUI.Images[c].correspondedID = id
		LOG(table.getn(FSSpaceUI.Images))
	end
		increasedFSBorder(FSSpaceUI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSSpaceUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.METEORSHOWER * categories.UEF)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	data = Level0
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSSpaceUI.Images[c] = CreateFSButton(FSSpaceUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSpaceUI),x,FSSpaceUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSSpaceUI.Images[c],id) 
		FSSpaceUI.Images[c].correspondedID = id
		LOG(table.getn(FSSpaceUI.Images))
	end
		increasedFSBorder(FSSpaceUI,15)
		existed = {}
    end	
LOG('Not active')
    end
end   


FSASUI:Hide()
FSUI:Hide()
FSMissileUI:Hide()
FSBUI:Hide()
FSSPUI:Hide()
FSSpaceUI:Hide()
 
--####################################################################

-- Close Button Code

--#################################################################### 

arrivalbox._closeBtn.OnClick = function(control)
		arrivalbox:Hide()
		arrivalboxtext:Hide()
end

availablebox._closeBtn.OnClick = function(control)
		availablebox:Hide()
		availableboxtext:Hide()
end







