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
local reftext = '0/1200'
local reftext2 = 'Collected Points: 0/1200'
local reftext3 = 'Rate: 1 Point per 3 Seconds'
local reftext4 = 'No available Points'
local reftext5 = 'Generation starts in:'
local reftext6 = '5 Minutes'
local NWave = 'Next Wave available in:'
local MaxRefpoints = '/1200'
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
RefUItext:SetText(reftext)
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
--#################################################################### 

-- Reinforcements Points Definition

--#################################################################### 

local StartRefPoints = 50 
local MaxReinforcementsPoints = 1200 	-- Maximum collectable Tactical Points
local RefWaitInterval = 300 -- Set Wait Time (5 Minutes)

local T1S  = 50   -- Scout
local T1BOT  = 55   -- Light Assault Bot
local T1Tank  = 60  -- Tank
local T1AA  = 60  -- Mobile Anti Air
local T1ART  = 70  -- Mobile Arty
local T1ENGI  = 100  -- Engineer

local T2BOT  = 250   -- Assault Bot
local T2Tank  = 200  -- Tank
local T2AA  = 220  -- Mobile Anti Air
local T2MIS  = 280  -- Mobile Missile
local T2SH  = 300  -- Mobile Shield Gen /Stealth Gen

local T3BOT  = 600   -- Assault Bot
local T3SBOT  = 700   -- Assault Bot
local T3Tank  = 500  -- Tank
local T3AA  = 500  -- Mobile Anti Air
local T3MIS  = 600  -- Mobile Missile
local T3SH  = 800  -- Mobile Shield Gen /Stealth Gen
local T3ART  = 600  -- Mobile Arty

--#################################################################### 

-- Generate Reinforcement Points

--#################################################################### 

ForkThread(
	function()
		repeat	
			local MathFloor = math.floor
			local hours = MathFloor(GetGameTimeSeconds() / 3600)
			local Seconds = GetGameTimeSeconds() - hours * 3600
			WaitSeconds(3) -- Generated Points per 3 Seconds
			if Seconds > RefWaitInterval then
				reftext5 = 'Generation in Progress'
				fstextbox2:SetText(reftext5)
				reftext6 = ''
				fstextbox3:SetText(reftext6)
				Reinforcementpoints = Reinforcementpoints + 1
				LOG(Reinforcementpoints)
			end
			if Reinforcementpoints > 50 then 
				reftext4 = 'Points available'
				fstextbox:SetText(fstext4)
				reftext5 = 'Awaiting Orders'
				fstextbox2:SetText(fstext5)
			end
			if Reinforcementpoints < 50 then 
				reftext4 = 'Not enough Points'
				fstextbox:SetText(reftext4)
				reftext5 = 'Generation in Progress'
				fstextbox2:SetText(reftext5)
			end
			if Reinforcementpoints == MaxReinforcementsPoints then
				availableboxtext:SetText('Maximum of Tactical Points reached!')
				availablebox:Show()
				availableboxtext:Show()
			end
			MainRefPoints = 'Collected Points: ' .. Reinforcementpoints .. MaxRefpoints
			RefPoints = Reinforcementpoints .. MaxRefpoints
			refheaderboxtext:SetText(MainRefPoints)
			RefUItext:SetText(RefPoints)
		until(GetGameTimeSeconds() < 0)
	end
)

--#################################################################### 

-- Basic UI Definitions for both Manger Sections (Planetary and Space)

--#################################################################### 


local UI
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
	Left = 30, 
	Top = 450, 
	Bottom = 670, 
	Right = 240
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

-- Code for Land Reinforcements 
-- This is the regular Manager Section

--#################################################################### 

local CreateLandButton = Class(Button){
    IconTextures = function(self, texture, texture2, texture3, path)
		self:SetTexture(texture)
		self.mNormal = texture 
        self.mActive = texture2
        self.mHighlight = texture3
        self.mDisabled = texture
		self.Depth:Set(15)
    end,
	
	OnClick = function(self, modifiers)
	LOG(Reinforcementpoints)
	
	local Effects = {
		'crater01_albedo'
	}
	local ID = self.correspondedID
	local bp = __blueprints[ID]
	
	local ScoutDesc = '<LOC ' .. ID .. '_desc>Land Scout'
	local MobileLightArtyDesc = '<LOC ' .. ID .. '_desc>Mobile Light Artillery'
	local MobileAADesc = '<LOC ' .. ID .. '_desc>Mobile Anti-Air Gun'
	local EngiDesc = '<LOC ' .. ID .. '_desc>Engineer'
	local LABDesc = '<LOC ' .. ID .. '_desc>Light Assault Bot'
	local MTMLDesc = '<LOC ' .. ID .. '_desc>Mobile Missile Launcher'
	local LTankDesc = '<LOC ' .. ID .. '_desc>Light Tank'
	local HTankDesc = '<LOC ' .. ID .. '_desc>Heavy Tank'
	local MobileHAADesc = '<LOC ' .. ID .. '_desc>Mobile AA Flak Artillery'
	local MobileHArtyDesc = '<LOC ' .. ID .. '_desc>Mobile Heavy Artillery'
	local HABDesc = '<LOC ' .. ID .. '_desc>Heavy Assault Bot'
	local MSDesc = '<LOC ' .. ID .. '_desc>Mobile Shield Generator'
	local HovTankDesc = '<LOC ' .. ID .. '_desc>Amphibious Tank'
	local GatBotDesc = '<LOC ' .. ID .. '_desc>Gatling Bot'
	
	local Desc = bp.Description
	local Faction = bp.General.FactionName
	
	if Reinforcementpoints >= StartRefPoints then
		if Desc == ScoutDesc then
			if Reinforcementpoints < T1S then
			
			else
			Reinforcementpoints = Reinforcementpoints - T1S
			SpawnReinforcement(ID)
			end
		end
		if Desc == MobileLightArtyDesc then
			if Reinforcementpoints < T1ART then
			
			else
			Reinforcementpoints = Reinforcementpoints - T1ART
			SpawnReinforcement(ID)
			end
		end
		if Desc == MobileAADesc then
			if Reinforcementpoints < T1AA then
			
			else
			Reinforcementpoints = Reinforcementpoints - T1AA
			SpawnReinforcement(ID)
			end
		end
		if Desc == EngiDesc then
			if Reinforcementpoints < T1ENGI then
			
			else
			Reinforcementpoints = Reinforcementpoints - T1ENGI
			SpawnReinforcement(ID)
			end
		end
		if Desc == LABDesc then
			if Reinforcementpoints < T1BOT then
			
			else
			Reinforcementpoints = Reinforcementpoints - T1BOT
			SpawnReinforcement(ID)
			end
		end
		if Desc == MTMLDesc then
			if Reinforcementpoints < T2MIS then
			
			else
			Reinforcementpoints = Reinforcementpoints - T2MIS
			SpawnReinforcement(ID)
			end
		end
		if Desc == LTankDesc then
			if Reinforcementpoints < T1Tank then
			
			else
			Reinforcementpoints = Reinforcementpoints - T1Tank
			SpawnReinforcement(ID)
			end
		end
		if Desc == HTankDesc then
			if Reinforcementpoints < T2Tank then
			
			else
			Reinforcementpoints = Reinforcementpoints - T2Tank
			SpawnReinforcement(ID)
			end
		end
		if Desc == MobileHAADesc then
			if Reinforcementpoints < T2AA then
			
			else
			Reinforcementpoints = Reinforcementpoints - T2AA
			SpawnReinforcement(ID)
			end
		end
		if Desc == MobileHArtyDesc then
			if Reinforcementpoints < T3ART then
			
			else
			Reinforcementpoints = Reinforcementpoints - T3ART
			SpawnReinforcement(ID)
			end
		end
		if Desc == HABDesc then
			if Reinforcementpoints < T3BOT then
			
			else
			Reinforcementpoints = Reinforcementpoints - T3BOT
			SpawnReinforcement(ID)
			end
		end
		if Desc == MSDesc then
			if Reinforcementpoints < T2SH then
			
			else
			Reinforcementpoints = Reinforcementpoints - T2SH
			SpawnReinforcement(ID)
			end
		end
		if Desc == HovTankDesc then
			if Reinforcementpoints < T2Tank then
			
			else
			Reinforcementpoints = Reinforcementpoints - T2Tank
			SpawnReinforcement(ID)
			end
		end
		if Desc == GatBotDesc then
			if Reinforcementpoints < T2BOT then
			
			else
			Reinforcementpoints = Reinforcementpoints - T2BOT
			SpawnReinforcement(ID)
			end
		end
	end
	end
}

function SpawnReinforcement(UnitID)
			local modeData = {
				cursor = 'RULEUCC_Attack',
				pingType = 'attack',
			}
			cmdMode.StartCommandMode("ping", modeData)
			function EndBehavior(mode, data)
				if mode == 'ping' and not data.isCancel then
					local position = GetMouseWorldPos()
					local flag = IsKeyDown('Shift')
					SimCallback({Func = 'SpawnFireSupport',Args = {id = UnitID, pos = position, yes = not flag, ArmyIndex = GetFocusArmy()}},true)
					UnitID = nil
				end
			end
			cmdMode.AddEndBehavior(EndBehavior)
end


LandUI = CreateWindow(GetFrame(0),'Available Units',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position do 
	LandUI[i]:Set(v)
end
LandUI._closeBtn:Hide()
LandUI.Images = {} 
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()	
if FBPOPath then
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in LandUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.T1LANDREINFORCEMENT * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.T2LANDREINFORCEMENT * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.T3LANDREINFORCEMENT * categories.AEON)
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
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],existed),existed) 
		SetBtnTextures(LandUI.Images[c],id) 
		LandUI.Images[c].correspondedID = id
		LOG(table.getn(LandUI.Images))
	end
	increasedBorder(LandUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in LandUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.T1LANDREINFORCEMENT * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.T2LANDREINFORCEMENT * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.T3LANDREINFORCEMENT * categories.CYBRAN)
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
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],existed),existed) 
		SetBtnTextures(LandUI.Images[c],id) 
		LandUI.Images[c].correspondedID = id
		LOG(table.getn(LandUI.Images))
	end
	increasedBorder(LandUI,15)
	existed = {}
	end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in LandUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.T1LANDREINFORCEMENT * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.T2LANDREINFORCEMENT * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.T3LANDREINFORCEMENT * categories.UEF)
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
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],existed),existed) 
		SetBtnTextures(LandUI.Images[c],id) 
		LandUI.Images[c].correspondedID = id
		LOG(table.getn(LandUI.Images))
	end
	increasedBorder(LandUI,15)
	existed = {}
    end			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in LandUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.T1LANDREINFORCEMENT * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.T2LANDREINFORCEMENT * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.T3LANDREINFORCEMENT * categories.SERAPHIM)
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
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],existed),existed) 
		SetBtnTextures(LandUI.Images[c],id) 
		LandUI.Images[c].correspondedID = id
		LOG(table.getn(LandUI.Images))
	end
	increasedBorder(LandUI,15)
	existed = {}
    end	
	    end
	LOG('Active')
else
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in LandUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.T1LANDREINFORCEMENT * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.T2LANDREINFORCEMENT * categories.AEON)
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
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],existed),existed) 
		SetBtnTextures(LandUI.Images[c],id) 
		LandUI.Images[c].correspondedID = id
		LOG(table.getn(LandUI.Images))
	end
	increasedBorder(LandUI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in LandUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.T1LANDREINFORCEMENT * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.T2LANDREINFORCEMENT * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.T3LANDREINFORCEMENT * categories.CYBRAN)
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
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],existed),existed) 
		SetBtnTextures(LandUI.Images[c],id) 
		LandUI.Images[c].correspondedID = id
		LOG(table.getn(LandUI.Images))
	end
	increasedBorder(LandUI,15)
	existed = {}
    end		
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in LandUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.T1LANDREINFORCEMENT * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.T2LANDREINFORCEMENT * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.T3LANDREINFORCEMENT * categories.UEF)
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
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],existed),existed) 
		SetBtnTextures(LandUI.Images[c],id) 
		LandUI.Images[c].correspondedID = id
		LOG(table.getn(LandUI.Images))
	end
	increasedBorder(LandUI,15)
	existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in LandUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.T1LANDREINFORCEMENT * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.T1LANDREINFORCEMENT * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.T1LANDREINFORCEMENT * categories.SERAPHIM)
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
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],existed),existed) 
		SetBtnTextures(LandUI.Images[c],id) 
		LandUI.Images[c].correspondedID = id
		LOG(table.getn(LandUI.Images))
	end
	increasedBorder(LandUI,15)
	existed = {}
    end	
LOG('Not active')
    end
end  

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




