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
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local CreateWindow = import('/lua/maui/window.lua').Window
local CreateText = import('/lua/maui/text.lua').Text 
local Button = import('/lua/maui/button.lua').Button
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local GetClickPosition = import('/lua/ui/game/commandmode.lua').ClickListener
local GetPause = import ('/lua/ui/game/tabs.lua').OnPause
local info = import(path .. 'info.lua').UI
local infoboxtext = import(path .. 'info.lua').Text
local infoboxtext2 = import(path .. 'info.lua').Text2
local infoboxtext3 = import(path .. 'info.lua').Text3
local arrivalbox = import(path .. 'Arrives.lua').UI
local arrivalboxtext = import(path .. 'Arrives.lua').Text
local availablebox = import(path .. 'Availability.lua').UI
local availableboxtext = import(path .. 'Availability.lua').Text
local headerbox = import(path .. 'header.lua').UI
local headerboxtext = import(path .. 'header.lua').Text
local headerboxtext2 = import(path .. 'header.lua').Text2
local fsheaderbox = import(path .. 'fsheader.lua').UI
local fsheaderboxtext = import(path .. 'fsheader.lua').Text
local fsheaderboxtext2 = import(path .. 'fsheader.lua').Text2
local fstextboxUI = import(path .. 'fsreminder.lua').UI
--local FSPUI = import(path .. 'tacui.lua').UI
local RefUItext = import(path .. 'refui.lua').Text
local fstextbox = import(path .. 'fsreminder.lua').Text
local fstextbox2 = import(path .. 'fsreminder.lua').Text2
local fstextbox3 = import(path .. 'fsreminder.lua').Text3
local textboxUI = import(path .. 'reminder.lua').UI
local textbox = import(path .. 'reminder.lua').Text
local textbox2 = import(path .. 'reminder.lua').Text2
local UIPing = import('/lua/ui/game/ping.lua')
local cmdMode = import('/lua/ui/game/commandmode.lua')
local factions = import('/lua/factions.lua').Factions
--local posx = import('/lua/aibrain.lua').OnSpawnPreBuiltUnits.posX
--local posy = import('/lua/aibrain.lua').OnSpawnPreBuiltUnits.posY
refheaderbox = import(path .. 'refheader.lua').UI
reftextboxUI = import(path .. 'refreminder.lua').UI
reftextbox = import(path .. 'refreminder.lua').Text
reftextbox2 = import(path .. 'refreminder.lua').Text2
reftextbox3 = import(path .. 'refreminder.lua').Text3
refheaderboxtext = import(path .. 'refheader.lua').Text
refheaderboxtext2 = import(path .. 'refheader.lua').Text2
local Tooltip = import("/lua/ui/game/tooltip.lua")

local CreateTransmission = import(path .. 'CreateTransmission.lua')
local CreateTransmission = import(path .. 'CreateTransmission.lua').CreateTransmission

HQComCenterDetected = false
HQComCenterDisabled = false
--#################################################################### 

-- Check for FBP Orbital activation

--#################################################################### 


local GetFBPOPath = function() for i, mod in __active_mods do if mod.name == "(F.B.P.) Future Battlefield Pack: Orbital" then return mod.location end end end
local FBPOPath = GetFBPOPath()


--#################################################################### 

-- Variable Definitions

--#################################################################### 

local RefCampaignOptions = {}
local RefCampaignOptionsMaxPointValue = nil
local RefCampaignOptionsGenIntervalValue = nil
local RefCampaignOptionsGenRateValue = nil
local RefCampaignOptionsWaitTimeValue = nil

function GetRefCampaignOptions(Array)
RefCampaignOptions = Array
end

function GetRefWaitTimeCampaignOptionValue(Value)
RefCampaignOptionsWaitTimeValue = Value
end

function GetRefMaxPointCampaignOptionValue(Value)
RefCampaignOptionsMaxPointValue = Value
end

function GetRefGenIntervalCampaignOptionValue(Value)
RefCampaignOptionsGenIntervalValue = Value
end

function GetRefGenRateCampaignOptionValue(Value)
RefCampaignOptionsGenRateValue = Value
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

local AddReinforcementPointStorage = 0

local LandRefInclude = SessionGetScenarioInfo().Options.LandRefInclude
local AirRefInclude = SessionGetScenarioInfo().Options.AirRefInclude
local NavalRefInclude = SessionGetScenarioInfo().Options.NavalRefInclude
local RefWaitInterval = SessionGetScenarioInfo().Options.RefPoints
local ChoosedRefInterval = SessionGetScenarioInfo().Options.RefPointsGenInt
local ChoosedRefRate = SessionGetScenarioInfo().Options.RefPointsGenRate
local MaxReinforcementsPoints = SessionGetScenarioInfo().Options.RefPointsMax 	-- Maximum collectable Tactical Points
local MaxRefPointsText = tostring(MaxReinforcementsPoints)
local MaxRefpoints = '/' .. MaxRefPointsText

function ReinforcementPointStorageHandle(Value)
	ForkThread(function()
	AddReinforcementPointStorage = Value
		if AddReinforcementPointStorage == 0 and MaxReinforcementsPoints < 10000 then
		if SessionGetScenarioInfo().Options.RefPointsMax > 0 then
		MaxReinforcementsPoints = SessionGetScenarioInfo().Options.RefPointsMax
		MaxRefPointsText = tostring(MaxReinforcementsPoints)
		MaxRefpoints = '/' .. MaxRefPointsText
		else
		MaxReinforcementsPoints = 0
		MaxRefPointsText = tostring(MaxReinforcementsPoints)
		MaxRefpoints = '/' .. MaxRefPointsText
		end
		else
		if AddReinforcementPointStorage > 0 and MaxReinforcementsPoints < 10000 then
		MaxReinforcementsPoints = MaxReinforcementsPoints + AddReinforcementPointStorage
		MaxRefPointsText = tostring(MaxReinforcementsPoints)
		MaxRefpoints = '/' .. MaxRefPointsText
		AddReinforcementPointStorage = 0
		elseif MaxReinforcementsPoints < 10000 then
		MaxReinforcementsPoints = MaxReinforcementsPoints + AddReinforcementPointStorage
		MaxRefPointsText = tostring(MaxReinforcementsPoints)
		MaxRefpoints = '/' .. MaxRefPointsText
		AddReinforcementPointStorage = 0
		end
		end
	end)
end 


ForkThread(
	function()
if Gametype == 'campaign' then
while true do
if RefWaitInterval == nil then
if RefCampaignOptionsWaitTimeValue == nil then

else
RefWaitInterval = RefCampaignOptionsWaitTimeValue
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
if MaxReinforcementsPoints == nil then
if RefCampaignOptionsMaxPointValue == nil then

else
MaxReinforcementsPoints = RefCampaignOptionsMaxPointValue + AddReinforcementPointStorage
MaxRefPointsText = tostring(MaxReinforcementsPoints)
MaxRefpoints = '/' .. MaxRefPointsText
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
if ChoosedRefInterval == nil then
if RefCampaignOptionsGenIntervalValue == nil then

else
ChoosedRefInterval = RefCampaignOptionsGenIntervalValue
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
if ChoosedRefRate == nil then
if RefCampaignOptionsGenRateValue == nil then

else
ChoosedRefRate = RefCampaignOptionsGenRateValue
break
end
end
WaitSeconds(0.1)
end
end
end
)

--[[

if RefWaitInterval == nil and ChoosedRefInterval == nil and ChoosedRefRate == nil and MaxReinforcementsPoints == nil then
RefWaitInterval = 300
ChoosedRefInterval = 3
ChoosedRefRate = 1
MaxReinforcementsPoints = 3000 + AddReinforcementPointStorage
MaxRefPointsText = tostring(MaxReinforcementsPoints)
MaxRefpoints = '/' .. MaxRefPointsText
else

end

]]--



local CommandCenterPoints = 0


local StartRefPoints = 25 


local Text1
local Text2
local Text3
local Text4
local Text5

local fstext = '0/' .. MaxRefPointsText
local fstext2 = 'Collected Points: 0/' .. MaxRefPointsText
local fstext3 = 'Rate: 1 Point per 3 Seconds'
local fstext4 = 'No available Points'
local fstext5 = 'Generation starts in:'
local fstext6 = '5 Minutes'
local reftext = '0/' .. MaxRefPointsText
local reftext2 = ''
local reftext3 = ''
local reftext4 = ''
local reftext5 = 'Generation starts in:'
local reftext6 = '5 Minutes'
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
local RefPoints = 0
local MainRefPoints = 0
Reinforcementpoints = 0
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
fstextbox3:SetText(fstext6)
fsheaderboxtext:SetText(fstext2)
RefUItext:SetText(reftext)
RefUItext:Hide()
fsheaderboxtext2:SetText(fstext3)
refheaderbox:Hide()
reftextboxUI:Hide()
reftextbox:Hide()
reftextbox2:Hide()
reftextbox3:Hide()
refheaderboxtext:Hide()
refheaderboxtext2:Hide()
refheaderboxtext:SetText(reftext2)
refheaderboxtext2:SetText(reftext3)
reftextbox:SetText(reftext4)
reftextbox2:SetText(reftext5)
reftextbox3:SetText(reftext6)
info:Hide()
infoboxtext:Hide()
infoboxtext2:Hide()
infoboxtext3:Hide()



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

-- Generate Reinforcement Points

--#################################################################### 
local aiThread
local uiThread
local ifnoThread

BrainCheck = function(brain)
	WaitSeconds(5)
	ForkThread(CommandCenterPointsThread, aiBrain)
end

CommandCenterPointsThread = function(self)
    aiThread = ForkThread(function() 
	    while true do
		    local labs = self:GetListOfUnits(categories.COMMANDCENTER, false)
			if labs then
			    if table.getn(labs) > 0 then
				    for k,v in labs do
					    if v:GetFractionComplete() == 1 then
						    Sync.HasResearchLab = true
							if not ifnoThread then
							    ForkThread(IfNoCommandCenterPointsThread, self)
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
	
IfNoCommandCenterPointsThread = function(self)
    ifnoThread = ForkThread(function()
	    while true do
		    local labs = self:GetListOfUnits(categories.COMMANDCENTER, false)
			if labs then
			    if table.getn(labs) == 0 then
				    Sync.LostResearchLab = true
					if not aiThread then
					    ForkThread(CommandCenterPointsThread, self)
					end
					KillThread(ifnoThread)
					ifnoThread = nil
				end
			end
			WaitSeconds(2)
		end
	end)
end

function CommandCenterPointsHandle(generated)
	ForkThread(function()
		CommandCenterPoints = generated
	end)
end 

function CollectedAbility(Collected)
	CommandCenterPoints = Collected
end


function CheckUnitCapReached(Value)
Reinforcementpoints = Reinforcementpoints + Value
end


ForkThread(
	function()
		repeat	
		if ChoosedRefInterval == nil then
		WaitSeconds(0.1)
		else
			local MathFloor = math.floor
			local hours = MathFloor(GetGameTimeSeconds() / 3600)
			local Seconds = GetGameTimeSeconds() - hours * 3600
			WaitSeconds(ChoosedRefInterval) -- Generated Points per 3 Seconds
			if Seconds < RefWaitInterval and Reinforcementpoints < StartRefPoints then
				if RefWaitInterval == 300 then 
					reftext2 = 'Generation starts in: 5 Minutes'
					refheaderboxtext:SetText(reftext2)
				elseif RefWaitInterval == 600 then 
					reftext2 = 'Generation starts in: 10 Minutes'
					refheaderboxtext:SetText(reftext2)
				elseif RefWaitInterval == 900 then 
					reftext2 = 'Generation starts in: 15 Minutes'
					refheaderboxtext:SetText(reftext2)
				elseif RefWaitInterval == 1200 then 
					reftext2 = 'Generation starts in: 20 Minutes'
					refheaderboxtext:SetText(reftext2)
				elseif RefWaitInterval == 1500 then 
					reftext2 = 'Generation starts in: 25 Minutes'
					refheaderboxtext:SetText(reftext2)
				elseif RefWaitInterval == 1800 then 
					reftext2 = 'Generation starts in: 30 Minutes'
					refheaderboxtext:SetText(reftext2)
				elseif RefWaitInterval == 2100 then 
					reftext2 = 'Generation starts in: 35 Minutes'
					refheaderboxtext:SetText(reftext2)
				elseif RefWaitInterval == 2400 then 
					reftext2 = 'Generation starts in: 40 Minutes'
					refheaderboxtext:SetText(reftext2)
				elseif RefWaitInterval == 2700 then 
					reftext2 = 'Generation starts in: 45 Minutes'
					refheaderboxtext:SetText(reftext2)
				elseif RefWaitInterval == 3000 then 
					reftext2 = 'Generation starts in: 50 Minutes'
					refheaderboxtext:SetText(reftext2)
				elseif RefWaitInterval == 3300 then 
					reftext2 = 'Generation starts in: 55 Minutes'
					refheaderboxtext:SetText(reftext2)
				elseif RefWaitInterval == 3600 then 
					reftext2 = 'Generation starts in: 60 Minutes'
					refheaderboxtext:SetText(reftext2)
				end
				reftext4 = 'No avaiable Points.'
				refheaderboxtext2:SetText(reftext4)
			end
			if Seconds > RefWaitInterval and Reinforcementpoints >= StartRefPoints and Reinforcementpoints < MaxReinforcementsPoints then
				reftext2 = 'Points available'
				refheaderboxtext:SetText(reftext2)
				reftext4 = 'Awaiting Orders'
				refheaderboxtext2:SetText(reftext4)
				Reinforcementpoints = Reinforcementpoints + ChoosedRefRate + CommandCenterPoints
			end
			if Seconds > RefWaitInterval and Reinforcementpoints <= StartRefPoints and Reinforcementpoints < MaxReinforcementsPoints then		
				reftext2 = 'Generation in Progress'
				refheaderboxtext:SetText(reftext2)
				reftext4 = 'Not enough Points'
				refheaderboxtext2:SetText(reftext4)
				Reinforcementpoints = Reinforcementpoints + ChoosedRefRate + CommandCenterPoints
			end
			if Seconds > RefWaitInterval and Reinforcementpoints == MaxReinforcementsPoints then
				reftext2 = 'Generation has stopped'
				refheaderboxtext:SetText(reftext2)
				reftext4 = 'Point Limit reached'
				refheaderboxtext2:SetText(reftext4)
				
				if Transmaxamount == 0 then
				if focusarmy >= 1 then
					if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
						Text1 = "Rhiza:"
						Text2 = "Regarding the reinforcement points."
						Text3 = "The Limit of collectable Points is reached."
						Text4 = "Use them wisely and we will continue the Transfer."
						Text5 = "Rhiza out."
						CreateTransmission(Text1, Text2, Text3, Text4, Text5)
						Transmaxamount = 1
					end
					if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
						Text1 = "Brackman:"
						Text2 = "Regarding the reinforcement points."
						Text3 = "The Limit of collectable Points is reached."
						Text4 = "Use them wisely and we will continue the Transfer."
						Text5 = "Stay tuned for Updates my Child."
						CreateTransmission(Text1, Text2, Text3, Text4, Text5)
						Transmaxamount = 1
					end
					if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
						Text1 = "Command HQ:"
						Text2 = "Regarding the reinforcement points."
						Text3 = "The Limit of collectable Points is reached."
						Text4 = "Use them wisely and we will continue the Transfer."
						Text5 = "Stay tuned for Updates --- Command HQ out."
						CreateTransmission(Text1, Text2, Text3, Text4, Text5)
						Transmaxamount = 1
					end
					if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
						Text1 = "Oum-Eoshi (Translated):"
						Text2 = "Regarding the reinforcement points."
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
			MainRefPoints = 'Collected Points: ' .. Reinforcementpoints .. MaxRefpoints
			RefPoints = Reinforcementpoints .. MaxRefpoints
			--refheaderboxtext:SetText(MainRefPoints)
			RefUItext:SetText(RefPoints)
			end
		until(GetGameTimeSeconds() < 0)
	end
)

--#################################################################### 

-- Basic UI Definitions for both Manger Sections (Planetary and Space)

--#################################################################### 


local UI
local existed = {}



function SetBtnTextures(ui, id)
	local location = '/mods/Commander Survival Kit/icons/units/up/' .. id .. '_icon.dds' 									-- Normal Icon
	local location2 = '/mods/Commander Survival Kit/icons/units/over/' .. id .. '_icon.dds'		-- Mouseover Icon
	local location3 = '/mods/Commander Survival Kit/icons/units/active/' .. id .. '_icon.dds'		-- Selected Icon
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), path)
end

function arrayPosition(Position, existed, parent)
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


function array(pos, total, Image, Price, existed)
	if existed[3] then
		pos.Height = -48
		pos.Width = 48
		existed[3] = false 
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
		LayoutHelpers.AtCenterIn(Price, Image, 20, 0)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		Price:SetFont('Arial',11)
		Price:SetColor('fff0a20e')
		LayoutHelpers.AtCenterIn(Price, Image, 20,0)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		Price:SetFont('Arial',11)
		Price:SetColor('ff54d1ef')
		LayoutHelpers.AtCenterIn(Price, Image, 20, 0)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		Price:SetFont('Arial',11)
		Price:SetColor('ffeeeeee')
		LayoutHelpers.AtCenterIn(Price, Image, 20, 0)
		end
	end	
	if right > pos.Right then
		right = existed[4]
		pos.Top = bottom
	end
	pos.Left = right
	return pos
end

function navalarray(pos, total, Image, Price, existed)
	if existed[3] then
		pos.Height = -48
		pos.Width = 48
		existed[3] = false 
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
		LayoutHelpers.AtCenterIn(Price, Image, 20, 0)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		Price:SetFont('Arial',11)
		Price:SetColor('fff0a20e')
		LayoutHelpers.AtCenterIn(Price, Image, 20,0)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		Price:SetFont('Arial',11)
		Price:SetColor('ff54d1ef')
		LayoutHelpers.AtCenterIn(Price, Image, 20, 0)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		Price:SetFont('Arial',11)
		Price:SetColor('ffeeeeee')
		LayoutHelpers.AtCenterIn(Price, Image, 20, 0)
		end
	end	
	if right > pos.Right then
		right = existed[4]
		pos.Top = bottom
	end
	pos.Left = right
	return pos
end


function airarray(pos, total, Image, Price, existed)
	if existed[3] then
		pos.Height = -48
		pos.Width = 48
		existed[3] = false 
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
		LayoutHelpers.AtCenterIn(Price, Image, 20, 0)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		Price:SetFont('Arial',11)
		Price:SetColor('fff0a20e')
		LayoutHelpers.AtCenterIn(Price, Image, 20,0)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		Price:SetFont('Arial',11)
		Price:SetColor('ff54d1ef')
		LayoutHelpers.AtCenterIn(Price, Image, 20, 0)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		Price:SetFont('Arial',11)
		Price:SetColor('ffeeeeee')
		LayoutHelpers.AtCenterIn(Price, Image, 20, 0)
		end
	end	
	if right > pos.Right then
		right = existed[4]
		pos.Top = bottom
	end
	pos.Left = right
	return pos
end

function linkup(pos, existed)
	existed[2] = pos
end

function increasedBorder(ui, scale)
	ui.Top:Set(ui.Top[1] - scale - 35)
	ui.Left:Set(ui.Left[1] - scale + 5)
	ui.Right:Set(ui.Right[1] + scale + 80)
	ui.Bottom:Set(ui.Bottom[1] + scale + 35)
end


----parameters----
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
	
Position = {
	Left = 30, 
	Top = 450, 
	Bottom = 670, 
	Right = 240
}

SecondPosition = {
	Left = 30, 
	Top = 450, 
	Bottom = 670, 
	Right = 240
}

OrbitalPosition = {
	Left = 30, 
	Top = 450, 
	Bottom = 670, 
	Right = 240
}
   
 --#################################################################### 

-- Code for Land Reinforcements 
-- This is the regular Manager Section

--#################################################################### 

CreateLandButton = Class(Button){
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
	if Reinforcementpoints >= StartRefPoints then
		if Reinforcementpoints < Price then
			
		else
			if Desc:gsub("<LOC " .. ID .. "_desc>","" ) == nil then
		
			else 
				Desc = Desc:gsub("<LOC " .. ID .. "_desc>","" ) 
			end
			if Desc == 'Land Scout' then
				Price = 25 -- Land Scouts cost normally 8 Mass 
			end
			Reinforcementpoints = Reinforcementpoints - Price
			RefPoints = Reinforcementpoints .. MaxRefpoints
			RefUItext:SetText(RefPoints)
			SpawnLandReinforcement(ID, Price)
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
		if desc == 'Engineer' then
			name = 'Unit doesnt has an Name' 
			infoboxtext:SetText(name)
		end
		if desc == 'Land Scout' then
			price = 'Price: ' .. 25 .. '       Droppable above: ' .. TypeText -- Land Scouts cost normally 8 Mass 
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


CreateNavalButton = Class(Button){
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
	if Reinforcementpoints >= StartRefPoints then
		if Reinforcementpoints < Price then
			
		else
			if Desc:gsub("<LOC " .. ID .. "_desc>","" ) == nil then
		
			else 
				Desc = Desc:gsub("<LOC " .. ID .. "_desc>","" ) 
			end
			if Desc == 'Land Scout' then
				Price = 25 -- Land Scouts cost normally 8 Mass 
			end
			Reinforcementpoints = Reinforcementpoints - Price
			RefPoints = Reinforcementpoints .. MaxRefpoints
			RefUItext:SetText(RefPoints)
			SpawnNavalReinforcement(ID, Price)
		end
	end
	end,
	
	OnRolloverEvent = function(self, state) 
		local ID = self.correspondedID
		local bp = __blueprints[ID]
		local Type = bp.General.Icon
		LOG('Type: ', Type)
		local TypeText
		if Type == 'sea' then
			TypeText = 'Water only'
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

CreateAirButton = Class(Button){
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
	LOG(Price)
	if Reinforcementpoints >= StartRefPoints then
		if Reinforcementpoints < Price then
			
		else
			Reinforcementpoints = Reinforcementpoints - Price
			RefPoints = Reinforcementpoints .. MaxRefpoints
			RefUItext:SetText(RefPoints)
			SpawnAirReinforcement(ID, Price)
		end
	end
	end,
	
	OnRolloverEvent = function(self, state) 
		local ID = self.correspondedID
		local bp = __blueprints[ID]
		local price = 'Price: ' .. math.floor(bp.Economy.BuildCostMass)
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
		if name:gsub("<LOC " .. ID .. "_name>","" ) == nil or name == nil then 
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

CreateSpaceButton = Class(Button){
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
	LOG(Price)
	
	if Reinforcementpoints >= StartRefPoints then
		if Reinforcementpoints < Price then
			
		else
			Reinforcementpoints = Reinforcementpoints - Price
			RefPoints = Reinforcementpoints .. MaxRefpoints
			RefUItext:SetText(RefPoints)
			SpawnSpaceReinforcement(ID, Price)
		end
	end
	end,
	
	OnRolloverEvent = function(self, state) 
		local ID = self.correspondedID
		local bp = __blueprints[ID]
		local price = 'Price: ' .. math.floor(bp.Economy.BuildCostMass)
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
		if name:gsub("<LOC " .. ID .. "_name>","" ) == nil or name == nil then 
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

function SpawnSpaceReinforcement(UnitID, Price)
			local modeData = {
				cursor = 'RULEUCC_Transport',
				pingType = 'attack',
			}
			cmdMode.StartCommandMode("ping", modeData)
			function EndBehavior(mode, data)
				if mode == 'ping' and not data.isCancel then
					local position = GetMouseWorldPos()
					local flag = IsKeyDown('Shift')
					SimCallback({Func = 'SpawnReinforcements',Args = {id = UnitID, pos = position, yes = not flag, ArmyIndex = GetFocusArmy(), price = Price}},true)
					UnitID = nil
				end
			end
			cmdMode.AddEndBehavior(EndBehavior)
end

function SpawnAirReinforcement(UnitID, Price)
			local modeData = {
				cursor = 'RULEUCC_Transport',
				pingType = 'attack',
			}
			cmdMode.StartCommandMode("ping", modeData)
			function EndBehavior(mode, data)
				if mode == 'ping' and not data.isCancel then
					local position = GetMouseWorldPos()
					local flag = IsKeyDown('Shift')
					SimCallback({Func = 'SpawnReinforcements',Args = {id = UnitID, pos = position, yes = not flag, ArmyIndex = GetFocusArmy(), price = Price}},true)
					UnitID = nil
				end
			end
			cmdMode.AddEndBehavior(EndBehavior)
end

function SpawnLandReinforcement(UnitID, Price)
			local modeData = {
				cursor = 'RULEUCC_Transport',
				pingType = 'attack',
			}
			cmdMode.StartCommandMode("ping", modeData)
			function EndBehavior(mode, data)
				if mode == 'ping' and not data.isCancel then
					local position = GetMouseWorldPos()
					local flag = IsKeyDown('Shift')
					SimCallback({Func = 'SpawnReinforcements',Args = {id = UnitID, pos = position, yes = not flag, ArmyIndex = GetFocusArmy(), price = Price}},true)
					UnitID = nil
				end
			end
			cmdMode.AddEndBehavior(EndBehavior)
end

function SpawnNavalReinforcement(UnitID, Price)
			local modeData = {
				cursor = 'RULEUCC_Transport',
				pingType = 'attack',
			}
			cmdMode.StartCommandMode("ping", modeData)
			function EndBehavior(mode, data)
				if mode == 'ping' and not data.isCancel then
					local position = GetMouseWorldPos()
					local flag = IsKeyDown('Shift')
					SimCallback({Func = 'SpawnReinforcements',Args = {id = UnitID, pos = position, yes = not flag, ArmyIndex = GetFocusArmy(), price = Price}},true)
					UnitID = nil
				end
			end
			cmdMode.AddEndBehavior(EndBehavior)
end

info._closeBtn.OnClick = function(control)
		info:Hide()
		infoboxtext:Hide()
		infoboxtext2:Hide()
		infoboxtext3:Hide()
end

--####################################################################

-- Open Sequence

--#################################################################### 


ForkThread(
	function()
		if Gametype == 'skirmish' then
		RefUItext:Hide()
		while true do 
		if HQComCenterDisabled == false then
		RefUItext:Hide()
		if HQComCenterDetected == false then
		RefUItext:Hide()
		else
		RefUItext:Show()
		end
		else
		RefUItext:Show()
		end
		WaitSeconds(1)
		end
		else
		RefUItext:Hide()
		while true do 
		if HQComCenterDisabled == false then
		RefUItext:Hide()
		if HQComCenterDetected == false then
		RefUItext:Hide()
		else
		RefUItext:Show()
		end
		else
		RefUItext:Show()
		end
		WaitSeconds(1)
		end
		end
	end
)
