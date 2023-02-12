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

local path = '/mods/Commander Survival Kit/UI/'
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local CreateWindow = import('/lua/maui/window.lua').Window
local CreateText = import('/lua/maui/text.lua').Text 
local Button = import('/lua/maui/button.lua').Button
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

local quantity = math.max(1, 1)
local mapsize = SessionGetScenarioInfo().size
local mapWidth = mapsize[1]
local mapHeight = mapsize[2]
LOG('MapWidth: ', mapWidth)
LOG('MapHeigth: ', mapHeight)

local fstext = '0/1200'
local fstext2 = 'Collected Points: 0/1200'
local fstext3 = 'Rate: 1 Point per 3 Seconds'
local fstext4 = 'No available Points'
local fstext5 = 'Generation starts in:'
local fstext6 = '5 Minutes'
local NWave = 'Next Wave available in:'
local MaxTactpoints = '/1200'
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
headerboxtext:SetText(NWave)
fsheaderboxtext:SetText(fstext2)
FSPUItext:SetText(fstext)
fsheaderboxtext2:SetText(fstext3)



--#################################################################### 

-- Tactical Points Definition

--#################################################################### 

local StartTACPoints = 50 
local MaxTACPoints = 1200 	-- Maximum collectable Tactical Points
local TacWaitInterval = 300 -- Set Wait Time (5 Minutes)

--#################################################################### 

-- Generate Tactical Points

--#################################################################### 

ForkThread(
	function()
		repeat	
			local MathFloor = math.floor
			local hours = MathFloor(GetGameTimeSeconds() / 3600)
			local Seconds = GetGameTimeSeconds() - hours * 3600
			WaitSeconds(3) -- Generated Points per 3 Seconds
			if Seconds > TacWaitInterval then
				fstext5 = 'Generation in Progress'
				fstextbox2:SetText(fstext5)
				fstext6 = ''
				fstextbox3:SetText(fstext6)
				Tacticalpoints = Tacticalpoints + 1
			end
			if Tacticalpoints > 50 then 
				fstext4 = 'Points available'
				fstextbox:SetText(fstext4)
				fstext5 = 'Awaiting Orders'
				fstextbox2:SetText(fstext5)
			end
			if Tacticalpoints < 50 then 
				fstext4 = 'No Points available'
				fstextbox:SetText(fstext4)
				fstext5 = 'Generation starts in:'
				fstextbox2:SetText(fstext5)
			end
			if Tacticalpoints == MaxTACPoints then
				availableboxtext:SetText('Maximum of Tactical Points reached!')
				availablebox:Show()
				availableboxtext:Show()
			end
			MainTacPoints = 'Collected Points: ' .. Tacticalpoints .. MaxTactpoints
			TacPoints = Tacticalpoints .. MaxTactpoints
			fsheaderboxtext:SetText(MainTacPoints)
			FSPUItext:SetText(TacPoints)
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
	local Price = bp.Economy.BuildCostMass
	
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
		local price = 'Price: ' .. bp.Economy.BuildCostMass
		local name = bp.General.UnitName
		local desc = bp.Description
		local fulldesc
		fulldesc = desc 
		infoboxtext:SetText(name)
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


local FSArtPosition = {
	Left = 37, 
	Top = 450, 
	Bottom = 490, 
	Right = 300
}

local FSNavalPosition = {
	Left = 37, 
	Top = 550, 
	Bottom = 590, 
	Right = 300
}

local FSMissilePosition = {
	Left = 37, 
	Top = 650, 
	Bottom = 690, 
	Right = 300
}

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

local function SetFSBBtnTextures(ui, id)
	local location = '/mods/Commander Survival Kit/icons/firesupport/test/Beam_btn_up.dds' 									-- Normal Icon
	local location2 = '/mods/Commander Survival Kit/icons/firesupport/test/Beam_btn_over.dds'		-- Mouseover Icon
	local location3 = '/mods/Commander Survival Kit/icons/firesupport/test/Beam_btn_down.dds'		-- Selected Icon
	--local location = '/mods/Commander Survival Kit/icons/firesupport/up/'.. id ..'_btn_up.dds' 									-- Normal Icon
	--local location2 = '/mods/Commander Survival Kit/icons/firesupport/over/'.. id ..'_btn_over.dds'		-- Mouseover Icon
	--local location3 = '/mods/Commander Survival Kit/icons/firesupport/active/'.. id ..'_btn_down.dds'		-- Selected Icon
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
for i, v in FSArtPosition do 
	FSUI[i]:Set(v)
end
FSUI._closeBtn:Hide()
FSUI.Images = {} 
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()	
if FBPOPath then
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.AEON)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.AEON)
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
		FSUI.Images[c] = CreateFSButton(FSUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSUI),x,FSUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSUI.Images[c],id) 
		FSUI.Images[c].correspondedID = id
		LOG(table.getn(FSUI.Images))
	end
	increasedFSBorder(FSUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.CYBRAN)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.CYBRAN)
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
		FSUI.Images[c] = CreateFSButton(FSUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSUI),x,FSUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSUI.Images[c],id) 
		FSUI.Images[c].correspondedID = id
		LOG(table.getn(FSUI.Images))
			end
			increasedFSBorder(FSUI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.UEF)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.UEF)
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
		FSUI.Images[c] = CreateFSButton(FSUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSUI),x,FSUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSUI.Images[c],id) 
		FSUI.Images[c].correspondedID = id
		LOG(table.getn(FSUI.Images))
	end
		increasedFSBorder(FSUI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.SERAPHIM)
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
		FSUI.Images[c] = CreateFSButton(FSUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSUI),x,FSUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSUI.Images[c],id) 
		FSUI.Images[c].correspondedID = id
		LOG(table.getn(FSUI.Images))
	end
		increasedFSBorder(FSUI,15)
		existed = {}
    end	
	    end
	LOG('Active')
else
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.AEON)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.AEON)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.AEON)
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
		FSUI.Images[c] = CreateFSButton(FSUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSUI),x,FSUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSUI.Images[c],id) 
		FSUI.Images[c].correspondedID = id
		LOG(table.getn(FSUI.Images))
	end
	increasedFSBorder(FSUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.CYBRAN)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.CYBRAN)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.CYBRAN)
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
		FSUI.Images[c] = CreateFSButton(FSUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSUI),x,FSUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSUI.Images[c],id) 
		FSUI.Images[c].correspondedID = id
		LOG(table.getn(FSUI.Images))
			end
			increasedFSBorder(FSUI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.UEF)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.UEF)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALARTILLERYBARRAGE * categories.UEF)
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
		FSUI.Images[c] = CreateFSButton(FSUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSUI),x,FSUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSUI.Images[c],id) 
		FSUI.Images[c].correspondedID = id
		LOG(table.getn(FSUI.Images))
	end
		increasedFSBorder(FSUI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTARTILLERYBARRAGE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMARTILLERYBARRAGE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.ARTILLERYBARRAGE * categories.SERAPHIM)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYARTILLERYBARRAGE * categories.SERAPHIM)
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
		FSUI.Images[c] = CreateFSButton(FSUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSUI),x,FSUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSUI.Images[c],id) 
		FSUI.Images[c].correspondedID = id
		LOG(table.getn(FSUI.Images))
	end
		increasedFSBorder(FSUI,15)
		existed = {}
    end	
LOG('Not active')
    end
end 

FSNUI = CreateWindow(GetFrame(0),'Naval',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in FSNavalPosition do 
	FSNUI[i]:Set(v)
end
FSNUI._closeBtn:Hide()
FSNUI.Images = {} 
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()	
	
if FBPOPath then
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSNUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.AEON)
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
		FSNUI.Images[c] = CreateFSButton(FSNUI) 
		FSlinkup(FSNavalarray(FSarrayPosition(Position,existed,FSNUI),x,FSNUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSNUI.Images[c],id) 
		FSNUI.Images[c].correspondedID = id
		LOG(table.getn(FSNUI.Images))
	end
	increasedFSBorder(FSNUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSNUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.CYBRAN)
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
		FSNUI.Images[c] = CreateFSButton(FSNUI) 
		FSlinkup(FSNavalarray(FSarrayPosition(Position,existed,FSNUI),x,FSNUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSNUI.Images[c],id) 
		FSNUI.Images[c].correspondedID = id
		LOG(table.getn(FSNUI.Images))
			end
			increasedFSBorder(FSNUI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSNUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.UEF)
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
		FSNUI.Images[c] = CreateFSButton(FSNUI) 
		FSlinkup(FSNavalarray(FSarrayPosition(Position,existed,FSNUI),x,FSNUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSNUI.Images[c],id) 
		FSNUI.Images[c].correspondedID = id
		LOG(table.getn(FSNUI.Images))
	end
		increasedFSBorder(FSNUI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSNUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.SERAPHIM)
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
		FSNUI.Images[c] = CreateFSButton(FSNUI) 
		FSlinkup(FSNavalarray(FSarrayPosition(Position,existed,FSNUI),x,FSNUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSNUI.Images[c],id) 
		FSNUI.Images[c].correspondedID = id
		LOG(table.getn(FSNUI.Images))
	end
		increasedFSBorder(FSNUI,15)
		existed = {}
    end	
	    end
	LOG('Active')
else
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSNUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.AEON)
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
		FSNUI.Images[c] = CreateFSButton(FSNUI) 
		FSlinkup(FSNavalarray(FSarrayPosition(Position,existed,FSNUI),x,FSNUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSNUI.Images[c],id) 
		FSNUI.Images[c].correspondedID = id
		LOG(table.getn(FSNUI.Images))
	end
	increasedFSBorder(FSNUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSNUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.CYBRAN)
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
		FSNUI.Images[c] = CreateFSButton(FSNUI) 
		FSlinkup(FSNavalarray(FSarrayPosition(Position,existed,FSNUI),x,FSNUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSNUI.Images[c],id) 
		FSNUI.Images[c].correspondedID = id
		LOG(table.getn(FSNUI.Images))
			end
			increasedFSBorder(FSNUI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSNUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.UEF)
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
		FSNUI.Images[c] = CreateFSButton(FSNUI) 
		FSlinkup(FSNavalarray(FSarrayPosition(Position,existed,FSNUI),x,FSNUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSNUI.Images[c],id) 
		FSNUI.Images[c].correspondedID = id
		LOG(table.getn(FSNUI.Images))
	end
		increasedFSBorder(FSNUI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSNUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBATTLESHIPBARRAGE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBATTLESHIPBARRAGE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYBATTLESHIPBARRAGE * categories.SERAPHIM)
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
		FSNUI.Images[c] = CreateFSButton(FSNUI) 
		FSlinkup(FSNavalarray(FSarrayPosition(Position,existed,FSNUI),x,FSNUI.Images[c],existed),existed) 
		SetFSARTBtnTextures(FSNUI.Images[c],id) 
		FSNUI.Images[c].correspondedID = id
		LOG(table.getn(FSNUI.Images))
	end
		increasedFSBorder(FSNUI,15)
		existed = {}
    end	
LOG('Not active')
    end
end 

 
FSMissileUI = CreateWindow(GetFrame(0),'Missile',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in FSMissilePosition do 
	FSMissileUI[i]:Set(v)
end
FSMissileUI._closeBtn:Hide()
FSMissileUI.Images = {} 
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()		
if FBPOPath then
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSMissileUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTMISSLEBARRAGE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMMISSLEBARRAGE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSLEBARRAGE * categories.AEON)
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
		FSMissileUI.Images[c] = CreateFSButton(FSMissileUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSMissileUI),x,FSMissileUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSMissileUI.Images[c],id) 
		FSMissileUI.Images[c].correspondedID = id
		LOG(table.getn(FSMissileUI.Images))
	end
	increasedFSBorder(FSMissileUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSMissileUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTMISSLEBARRAGE * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMMISSLEBARRAGE * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSLEBARRAGE * categories.CYBRAN)
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
		FSMissileUI.Images[c] = CreateFSButton(FSMissileUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSMissileUI),x,FSMissileUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSMissileUI.Images[c],id) 
		FSMissileUI.Images[c].correspondedID = id
		LOG(table.getn(FSMissileUI.Images))
			end
			increasedFSBorder(FSMissileUI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSMissileUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTMISSLEBARRAGE * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMMISSLEBARRAGE * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSLEBARRAGE * categories.UEF)
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
		FSMissileUI.Images[c] = CreateFSButton(FSMissileUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSMissileUI),x,FSMissileUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSMissileUI.Images[c],id) 
		FSMissileUI.Images[c].correspondedID = id
		LOG(table.getn(FSMissileUI.Images))
	end
		increasedFSBorder(FSMissileUI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSMissileUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTMISSLEBARRAGE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMMISSLEBARRAGE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSLEBARRAGE * categories.SERAPHIM)
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
		FSMissileUI.Images[c] = CreateFSButton(FSMissileUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSMissileUI),x,FSMissileUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSMissileUI.Images[c],id) 
		FSMissileUI.Images[c].correspondedID = id
		LOG(table.getn(FSMissileUI.Images))
	end
		increasedFSBorder(FSMissileUI,15)
		existed = {}
    end	
	    end
	LOG('Active')
else
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSMissileUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTMISSLEBARRAGE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMMISSLEBARRAGE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSLEBARRAGE * categories.AEON)
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
		FSMissileUI.Images[c] = CreateFSButton(FSMissileUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSMissileUI),x,FSMissileUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSMissileUI.Images[c],id) 
		FSMissileUI.Images[c].correspondedID = id
		LOG(table.getn(FSMissileUI.Images))
	end
	increasedFSBorder(FSMissileUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSMissileUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTMISSLEBARRAGE * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMMISSLEBARRAGE * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSLEBARRAGE * categories.CYBRAN)
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
		FSMissileUI.Images[c] = CreateFSButton(FSMissileUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSMissileUI),x,FSMissileUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSMissileUI.Images[c],id) 
		FSMissileUI.Images[c].correspondedID = id
		LOG(table.getn(FSMissileUI.Images))
			end
			increasedFSBorder(FSMissileUI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSMissileUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTMISSLEBARRAGE * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMMISSLEBARRAGE * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSLEBARRAGE * categories.UEF)
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
		FSMissileUI.Images[c] = CreateFSButton(FSMissileUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSMissileUI),x,FSMissileUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSMissileUI.Images[c],id) 
		FSMissileUI.Images[c].correspondedID = id
		LOG(table.getn(FSMissileUI.Images))
	end
		increasedFSBorder(FSMissileUI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSMissileUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTMISSLEBARRAGE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMMISSLEBARRAGE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSLEBARRAGE * categories.SERAPHIM)
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
		FSMissileUI.Images[c] = CreateFSButton(FSMissileUI) 
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSMissileUI),x,FSMissileUI.Images[c],existed),existed) 
		SetFSMBtnTextures(FSMissileUI.Images[c],id) 
		FSMissileUI.Images[c].correspondedID = id
		LOG(table.getn(FSMissileUI.Images))
	end
		increasedFSBorder(FSMissileUI,15)
		existed = {}
    end	
LOG('Not active')
    end
end 

FSRFUI = CreateWindow(GetFrame(0),'Rapid Fire',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in FSArtPosition do 
	FSRFUI[i]:Set(v)
end
FSRFUI._closeBtn:Hide()
FSRFUI.Images = {} 
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()	
if FBPOPath then
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSRFUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.AEON)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.AEON)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.AEON)
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
		FSRFUI.Images[c] = CreateFSButton(FSRFUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSRFUI),x,FSRFUI.Images[c],existed),existed) 
		SetFSRFBtnTextures(FSRFUI.Images[c],id) 
		FSRFUI.Images[c].correspondedID = id
		LOG(table.getn(FSRFUI.Images))
	end
	increasedFSBorder(FSRFUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSRFUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.CYBRAN)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.CYBRAN)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.CYBRAN)
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
		FSRFUI.Images[c] = CreateFSButton(FSRFUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSRFUI),x,FSRFUI.Images[c],existed),existed) 
		SetFSRFBtnTextures(FSRFUI.Images[c],id) 
		FSRFUI.Images[c].correspondedID = id
		LOG(table.getn(FSRFUI.Images))
			end
			increasedFSBorder(FSRFUI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSRFUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.UEF)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.UEF)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.UEF)
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
		FSRFUI.Images[c] = CreateFSButton(FSRFUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSRFUI),x,FSRFUI.Images[c],existed),existed) 
		SetFSRFBtnTextures(FSRFUI.Images[c],id) 
		FSRFUI.Images[c].correspondedID = id
		LOG(table.getn(FSRFUI.Images))
	end
		increasedFSBorder(FSRFUI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSRFUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.SERAPHIM)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.SERAPHIM)
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
		FSRFUI.Images[c] = CreateFSButton(FSRFUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSRFUI),x,FSRFUI.Images[c],existed),existed) 
		SetFSRFBtnTextures(FSRFUI.Images[c],id) 
		FSRFUI.Images[c].correspondedID = id
		LOG(table.getn(FSRFUI.Images))
	end
		increasedFSBorder(FSRFUI,15)
		existed = {}
    end	
	    end
	LOG('Active')
else
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSRFUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.AEON)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.AEON)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.AEON)
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
		FSRFUI.Images[c] = CreateFSButton(FSRFUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSRFUI),x,FSRFUI.Images[c],existed),existed) 
		SetFSRFBtnTextures(FSRFUI.Images[c],id) 
		FSRFUI.Images[c].correspondedID = id
		LOG(table.getn(FSRFUI.Images))
	end
	increasedFSBorder(FSRFUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSRFUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.CYBRAN)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.CYBRAN)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.CYBRAN)
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
		FSRFUI.Images[c] = CreateFSButton(FSRFUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSRFUI),x,FSRFUI.Images[c],existed),existed) 
		SetFSRFBtnTextures(FSRFUI.Images[c],id) 
		FSRFUI.Images[c].correspondedID = id
		LOG(table.getn(FSRFUI.Images))
			end
			increasedFSBorder(FSRFUI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSRFUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.UEF)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.UEF)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALRAPIDFIREBARRAGE * categories.UEF)
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
		FSRFUI.Images[c] = CreateFSButton(FSRFUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSRFUI),x,FSRFUI.Images[c],existed),existed) 
		SetFSRFBtnTextures(FSRFUI.Images[c],id) 
		FSRFUI.Images[c].correspondedID = id
		LOG(table.getn(FSRFUI.Images))
	end
		increasedFSBorder(FSRFUI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSRFUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTRAPIDFIREBARRAGE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMRAPIDFIREBARRAGE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.RAPIDFIREBARRAGE * categories.SERAPHIM)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYRAPIDFIREBARRAGE * categories.SERAPHIM)
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
		FSRFUI.Images[c] = CreateFSButton(FSRFUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSRFUI),x,FSRFUI.Images[c],existed),existed) 
		SetFSRFBtnTextures(FSRFUI.Images[c],id) 
		FSRFUI.Images[c].correspondedID = id
		LOG(table.getn(FSRFUI.Images))
	end
		increasedFSBorder(FSRFUI,15)
		existed = {}
    end	
LOG('Not active')
    end
end 

FSBUI = CreateWindow(GetFrame(0),'Beam',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in FSNavalPosition do 
	FSBUI[i]:Set(v)
end
FSBUI._closeBtn:Hide()
FSBUI.Images = {} 
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()	
	
if FBPOPath then
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSBUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.AEON)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.AEON)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.AEON)
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
		FSBUI.Images[c] = CreateFSButton(FSBUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSBUI),x,FSBUI.Images[c],existed),existed) 
		SetFSBBtnTextures(FSBUI.Images[c],id) 
		FSBUI.Images[c].correspondedID = id
		LOG(table.getn(FSBUI.Images))
	end
	increasedFSBorder(FSBUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSBUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.CYBRAN)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.CYBRAN)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.CYBRAN)
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
		FSBUI.Images[c] = CreateFSButton(FSBUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSBUI),x,FSBUI.Images[c],existed),existed) 
		SetFSBBtnTextures(FSBUI.Images[c],id) 
		FSBUI.Images[c].correspondedID = id
		LOG(table.getn(FSBUI.Images))
			end
			increasedFSBorder(FSBUI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSBUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.UEF)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.UEF)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.UEF)
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
		FSBUI.Images[c] = CreateFSButton(FSBUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSBUI),x,FSBUI.Images[c],existed),existed) 
		SetFSBBtnTextures(FSBUI.Images[c],id) 
		FSBUI.Images[c].correspondedID = id
		LOG(table.getn(FSBUI.Images))
	end
		increasedFSBorder(FSBUI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSBUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.SERAPHIM)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.SERAPHIM)
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
		FSBUI.Images[c] = CreateFSButton(FSBUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSBUI),x,FSBUI.Images[c],existed),existed) 
		SetFSBBtnTextures(FSBUI.Images[c],id) 
		FSBUI.Images[c].correspondedID = id
		LOG(table.getn(FSBUI.Images))
	end
		increasedFSBorder(FSBUI,15)
		existed = {}
    end	
	    end
	LOG('Active')
else
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSBUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.AEON)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.AEON)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.AEON)
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
		FSBUI.Images[c] = CreateFSButton(FSBUI) 
		FSlinkup(FSNavalarray(FSarrayPosition(Position,existed,FSBUI),x,FSBUI.Images[c],existed),existed) 
		SetFSBBtnTextures(FSBUI.Images[c],id) 
		FSBUI.Images[c].correspondedID = id
		LOG(table.getn(FSBUI.Images))
	end
	increasedFSBorder(FSBUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSBUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.CYBRAN)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.CYBRAN)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.CYBRAN)
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
		FSBUI.Images[c] = CreateFSButton(FSBUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSBUI),x,FSBUI.Images[c],existed),existed) 
		SetFSBBtnTextures(FSBUI.Images[c],id) 
		FSBUI.Images[c].correspondedID = id
		LOG(table.getn(FSBUI.Images))
			end
			increasedFSBorder(FSBUI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSBUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.UEF)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.UEF)
	local Level5 = EntityCategoryGetUnitList(categories.EXPERIMENTALBEAMBARRAGE * categories.UEF)
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
		FSBUI.Images[c] = CreateFSButton(FSBUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSBUI),x,FSBUI.Images[c],existed),existed) 
		SetFSBBtnTextures(FSBUI.Images[c],id) 
		FSBUI.Images[c].correspondedID = id
		LOG(table.getn(FSBUI.Images))
	end
		increasedFSBorder(FSBUI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in FSBUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTBEAMBARRAGE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMBEAMBARRAGE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.BEAMBARRAGE * categories.SERAPHIM)
	local Level4 = EntityCategoryGetUnitList(categories.HEAVYBEAMBARRAGE * categories.SERAPHIM)
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
		FSBUI.Images[c] = CreateFSButton(FSBUI) 
		FSlinkup(FSArtarray(FSarrayPosition(Position,existed,FSBUI),x,FSBUI.Images[c],existed),existed) 
		SetFSBBtnTextures(FSBUI.Images[c],id) 
		FSBUI.Images[c].correspondedID = id
		LOG(table.getn(FSBUI.Images))
	end
		increasedFSBorder(FSBUI,15)
		existed = {}
    end	
LOG('Not active')
    end
end 

 
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
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTMISSLEBARRAGE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMMISSLEBARRAGE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSLEBARRAGE * categories.AEON)
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
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
		SetFSSPBtnTextures(FSSPUI.Images[c],id) 
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
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
		SetFSSPBtnTextures(FSSPUI.Images[c],id) 
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
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
		SetFSSPBtnTextures(FSSPUI.Images[c],id) 
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
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTMISSLEBARRAGE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMMISSLEBARRAGE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSLEBARRAGE * categories.SERAPHIM)
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
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
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
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTMISSLEBARRAGE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMMISSLEBARRAGE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSLEBARRAGE * categories.AEON)
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
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
		SetFSSPBtnTextures(FSSPUI.Images[c],id) 
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
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
		SetFSSPBtnTextures(FSSPUI.Images[c],id) 
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
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
		SetFSSPBtnTextures(FSSPUI.Images[c],id) 
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
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTMISSLEBARRAGE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMMISSLEBARRAGE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.TACTICALNUKEMISSLEBARRAGE * categories.SERAPHIM)
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
		FSlinkup(FSMissilearray(FSarrayPosition(Position,existed,FSSPUI),x,FSSPUI.Images[c],existed),existed) 
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

FSUI:Hide()
FSNUI:Hide()
FSMissileUI:Hide()
FSRFUI:Hide()
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



