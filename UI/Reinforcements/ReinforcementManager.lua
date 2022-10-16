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

local path = '/mods/Reinforcement Manager/UI/Reinforcements/'
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
local fstextbox = import(path .. 'fsreminder.lua').Text
local fstextbox2 = import(path .. 'fsreminder.lua').Text2
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
headerboxtext:SetText(NWave)
fsheaderboxtext:SetText(fstext)


--#################################################################### 

-- Tactical Points Definition

--#################################################################### 

local StartTACPoints = 50 

local LAB  = 50   -- LIGHTARTILLERYBARRAGE
local MAB  = 150  -- MEDIUMARTILLERYBARRAGE
local AB   = 300  -- ARTILLERYBARRAGE
local HAB  = 600  -- HEAVYARTILLERYBARRAGE
local EXAB = 1200 -- EXPERIMENTALARTILLERYBARRAGE

local LBB  = 100  -- LIGHTBATTLESHIPBARRAGE
local MBB  = 300  -- MEDIUMBATTLESHIPBARRAGE
local HBB  = 600  -- HEAVYBATTLESHIPBARRAGE

local LMB  = 100  -- LIGHTMISSLEBARRAGE
local MMB  = 300  -- MEDIUMMISSLEBARRAGE
local TNMB = 600  -- TACTICALNUKEMISSLEBARRAGE

--#################################################################### 

-- Generate Tactical Points

--#################################################################### 

ForkThread(
	function()
		WaitSeconds(300) -- Start Time (5 Minutes)
		repeat	
			WaitSeconds(3) -- Generated Points per 3 Seconds
			Tacticalpoints = Tacticalpoints + 1
			if Tacticalpoints == 1200 then
		
			end
			TacPoints = Tacticalpoints .. MaxTactpoints
			fsheaderboxtext:SetText(TacPoints)
	
		until(GetGameTimeSeconds() < 0)
	end
)

--#################################################################### 

-- Main Code for Reinforcement Buttons 
-- If clicked it will start the Timer to the next Reinforcement Wave
-- Or it calls 4 Units as Reinforcements and spawn them on a random Map Location

--#################################################################### 


local CreateButton = Class(Button){
    IconTextures = function(self, texture, texture2, texture3, path)
		self:SetTexture(texture)
		self.mNormal = texture 
        self.mActive = texture2
        self.mHighlight = texture3
        self.mDisabled = texture
		self.Depth:Set(15)
    end,
	
	OnClick = function(self, modifiers)
		ForkThread(
			function()
				local position = GetMouseWorldPos()
				for _, v in position do
					local var = v
					if var >= 0  then
						var = var * -1
					end
				end
				local flag = IsKeyDown('Shift')
				
				local BorderPos, OppBorPos
				local x, z = position[1] / mapWidth - 0.5, position[3] / mapHeight - 0.5
				
				if math.abs(x) <= math.abs(z) then
					BorderPos = {position[1], nil, math.ceil(z) * mapHeight}
					OppBorPos = {position[1], nil, BorderPos[3]==0 and mapHeight or 0}
					x, z = 1, 1
				else
					BorderPos = {math.ceil(x) * mapWidth, nil, position[3]}
					OppBorPos = {BorderPos[1]==0 and mapWidth or 0, nil, position[3]}
					x, z = 1, 1
				end
				
				number = number + 1
				LOG(number)
				if number == 5 then
				NWave = 'Next Wave available in: + 05:00'
				headerboxtext:SetText(NWave)
				local MathFloor = math.floor
				local hours = MathFloor(GetGameTimeSeconds() / 3600)
				local Seconds = GetGameTimeSeconds() - hours * 3600
				local minutes = MathFloor(GetGameTimeSeconds() / 60)
				Seconds = MathFloor(Seconds - minutes * 60)
				local Timer = ("%02d:%02d:%02d"):format(hours, minutes, Seconds)
				textbox:SetText('No available units')
				-- Start Available Countdown then new Reinforcement if reach 0
				repeat
				if GetGameTimeSeconds() > Interval then
					NWave = 'Next Wave available in:'
					headerboxtext:SetText(NWave)
					Interval = Interval + Intervalstep
					step = 0
					number = 0
					textbox:SetText('Awaiting Orders')
					LOG(number)
					availablebox:Show()
					availableboxtext:Show()
					break
				end
				WaitSeconds(1)
				step = step + 1
				NWave = 'Time: ' .. Timer .. '       Storage: 4'
				LOG(GetGameTimeSeconds())
				headerboxtext2:SetText(NWave)
				until(GetGameTimeSeconds() < 0)
				
				elseif number < 5 then
				Storage = Storage - 1
				LOG('Storage: ', Storage)
				local Storagetext = 'Timer:                Storage: '
				Storagetext = 'Timer:                Storage: ' .. Storage
				headerboxtext2:SetText(Storagetext)
				if Storage == 0 then
					Storage = 0
				end
				Storagetext = 'Timer:                Storage: ' .. Storage
				headerboxtext2:SetText(Storagetext)
				local ArrivalTime = 12
				local Minutes = 0
				local Seconds = ArrivalTime
				repeat
				textbox:SetText('Is on the way')
				if Minutes < 10 and Seconds < 10 then
					Arrivaltext = 'Arrival in: ' .. '0' .. Minutes .. ':' .. '0' .. Seconds
				else
					Arrivaltext = 'Arrival in: ' .. '0' .. Minutes .. ':' .. Seconds
					-- Arrivaltext = 'Arrival in: ' .. Minutes .. ':' .. Seconds 					-- If we need Minutes in the future
				end
				textbox2:SetText(Arrivaltext)
				if Seconds == 0 then 
					SimCallback({Func = 'SpawnReinforcements',Args = {id = self.correspondedID, pos = BorderPos, yes = not flag, ArmyIndex = GetFocusArmy(), Quantity = quantity, X = x, Z = z}},true)
					arrivalbox:Show()
					arrivalboxtext:Show()
					textbox:SetText('Unit has arrived')
					WaitSeconds(10)
					textbox:SetText('Awaiting Orders')
					Arrivaltext = 'Arrival in: '
					textbox2:SetText(Arrivaltext)
					break
				end
				WaitSeconds(1)
				Seconds = Seconds - 1
				textbox2:SetText(Arrivaltext)
				WaitSeconds(1)
				until(Seconds > ArrivalTime)
				-- End
				else
					Storage = 4
					textbox:SetText('No available units')
					WaitSeconds(10)
				end
			end
		)
	end

}


--#################################################################### 

-- Basic UI Definitions for both Manger Sections (Planetary and Space)

--#################################################################### 


local UI
local existed = {}



local function SetBtnTextures(ui, id)
	local location = '/mods/Reinforcement Manager/icons/units/up/' .. id .. '_icon.dds' 									-- Normal Icon
	local location2 = '/mods/Reinforcement Manager/icons/units/over/' .. id .. '_icon.dds'		-- Mouseover Icon
	local location3 = '/mods/Reinforcement Manager/icons/units/active/' .. id .. '_icon.dds'		-- Selected Icon
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
	Top = 730, 
	Bottom = 940, 
	Right = 240
}

local OrbitalPosition = {
	Left = 40, 
	Top = 375, 
	Bottom = 420, 
	Right = 240
}
   
   
   
   
   
----actions----


--#################################################################### 

-- Code for Planetary Reinforcements 
-- This is the regular Manager Section

--#################################################################### 

UI = CreateWindow(GetFrame(0),'Planetary',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position do 
	UI[i]:Set(v)
end
UI._closeBtn:Hide()
UI.Images = {} 
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()	
if FBPOPath then
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in UI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.REINFORCEMENTTRANSPORT * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL1 * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL2 * categories.AEON)
	local Level5 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL3 * categories.AEON)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
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
		UI.Images[c] = CreateButton(UI) 
		linkup(array(arrayPosition(Position,existed,UI),x,UI.Images[c],existed),existed) 
		SetBtnTextures(UI.Images[c],id) 
		UI.Images[c].correspondedID = id
		LOG(table.getn(UI.Images))
	end
	increasedBorder(UI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in UI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.REINFORCEMENTTRANSPORT * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL1 * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL2 * categories.CYBRAN)
	local Level5 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL3 * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
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
		UI.Images[c] = CreateButton(UI) 
		linkup(array(arrayPosition(Position,existed,UI),x,UI.Images[c],existed),existed) 
		SetBtnTextures(UI.Images[c],id) 
		UI.Images[c].correspondedID = id
		LOG(table.getn(UI.Images))
			end
			increasedBorder(UI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in UI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.REINFORCEMENTTRANSPORT * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL1 * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL2 * categories.UEF)
	local Level5 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL3 * categories.UEF)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
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
		UI.Images[c] = CreateButton(UI) 
		linkup(array(arrayPosition(Position,existed,UI),x,UI.Images[c],existed),existed) 
		SetBtnTextures(UI.Images[c],id) 
		UI.Images[c].correspondedID = id
		LOG(table.getn(UI.Images))
	end
		increasedBorder(UI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in UI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.REINFORCEMENTTRANSPORT * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL1 * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL2 * categories.SERAPHIM)
	local Level5 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL3 * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
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
		UI.Images[c] = CreateButton(UI) 
		linkup(array(arrayPosition(Position,existed,UI),x,UI.Images[c],existed),existed) 
		SetBtnTextures(UI.Images[c],id) 
		UI.Images[c].correspondedID = id
		LOG(table.getn(UI.Images))
	end
		increasedBorder(UI,15)
		existed = {}
    end	
	    end
	LOG('Active')
else
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in UI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.REINFORCEMENTTRANSPORT * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL1 * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL2 * categories.AEON)
	local Level5 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL3 * categories.AEON)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
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
		UI.Images[c] = CreateButton(UI) 
		linkup(array(arrayPosition(Position,existed,UI),x,UI.Images[c],existed),existed) 
		SetBtnTextures(UI.Images[c],id) 
		UI.Images[c].correspondedID = id
		LOG(table.getn(UI.Images))
	end
	increasedBorder(UI,15)
	existed = {}
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in UI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.REINFORCEMENTTRANSPORT * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL1 * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL2 * categories.CYBRAN)
	local Level5 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL3 * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
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
		UI.Images[c] = CreateButton(UI) 
		linkup(array(arrayPosition(Position,existed,UI),x,UI.Images[c],existed),existed) 
		SetBtnTextures(UI.Images[c],id) 
		UI.Images[c].correspondedID = id
		LOG(table.getn(UI.Images))
			end
			increasedBorder(UI,15)
			existed = {}
            end
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in UI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.REINFORCEMENTTRANSPORT * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL1 * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL2 * categories.UEF)
	local Level5 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL3 * categories.UEF)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
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
		UI.Images[c] = CreateButton(UI) 
		linkup(array(arrayPosition(Position,existed,UI),x,UI.Images[c],existed),existed) 
		SetBtnTextures(UI.Images[c],id) 
		UI.Images[c].correspondedID = id
		LOG(table.getn(UI.Images))
	end
		increasedBorder(UI,15)
		existed = {}
    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
	for k,v in UI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.REINFORCEMENTTRANSPORT * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL1 * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL2 * categories.SERAPHIM)
	local Level5 = EntityCategoryGetUnitList(categories.PREINFORCEMENTLEVEL3 * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level2) do 
    table.insert(Level0, v)
	end
	for _,v in ipairs(Level3) do 
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
		UI.Images[c] = CreateButton(UI) 
		linkup(array(arrayPosition(Position,existed,UI),x,UI.Images[c],existed),existed) 
		SetBtnTextures(UI.Images[c],id) 
		UI.Images[c].correspondedID = id
		LOG(table.getn(UI.Images))
	end
		increasedBorder(UI,15)
		existed = {}
    end	
LOG('Not active')
    end
end

--#################################################################### 

-- Code for Space Reinforcements 
-- This Manager Section will appear if FBP Orbital is activated

--#################################################################### 

FBPOUI = CreateWindow(GetFrame(0),'Space',nil,false,false,true,true,'Reinforcements',SecondPosition,Border) 
for i, v in SecondPosition do 
	FBPOUI[i]:Set(v)
end
FBPOUI._closeBtn:Hide()
FBPOUI.Images = {} 
	if FBPOPath then
		       if focusarmy >= 1 then
            local factions = import('/lua/factions.lua').Factions
            if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
				LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
					for k,v in FBPOUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.SPACESHIP * categories.AEON  * categories.TECH1)
	local Level2 = EntityCategoryGetUnitList(categories.SPACESHIP * categories.AEON  * categories.TECH2)
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
		FBPOUI.Images[c] = CreateButton(FBPOUI) 
		linkup(array(arrayPosition(SecondPosition,existed,FBPOUI),x,FBPOUI.Images[c],existed),existed) 
		SetBtnTextures(FBPOUI.Images[c],id) 
		FBPOUI.Images[c].correspondedID = id
		LOG(table.getn(FBPOUI.Images))
	end
	increasedBorder(FBPOUI,15)
	existed = {}
            end
			if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
				LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
					for k,v in FBPOUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.SPACESHIP * categories.CYBRAN  * categories.TECH1)
	local Level2 = EntityCategoryGetUnitList(categories.SPACESHIP * categories.CYBRAN  * categories.TECH2)
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
		FBPOUI.Images[c] = CreateButton(FBPOUI) 
		linkup(array(arrayPosition(SecondPosition,existed,FBPOUI),x,FBPOUI.Images[c],existed),existed) 
		SetBtnTextures(FBPOUI.Images[c],id) 
		FBPOUI.Images[c].correspondedID = id
		LOG(table.getn(FBPOUI.Images))
			end
			increasedBorder(FBPOUI,15)
			existed = {}
            end
			if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
				LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
									for k,v in FBPOUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.SPACESHIP * categories.UEF  * categories.TECH1)
	local Level2 = EntityCategoryGetUnitList(categories.SPACESHIP * categories.UEF  * categories.TECH2)
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
		FBPOUI.Images[c] = CreateButton(FBPOUI) 
		linkup(array(arrayPosition(SecondPosition,existed,FBPOUI),x,FBPOUI.Images[c],existed),existed) 
		SetBtnTextures(FBPOUI.Images[c],id) 
		FBPOUI.Images[c].correspondedID = id
		LOG(table.getn(FBPOUI.Images))
			end
			increasedBorder(FBPOUI,15)
			existed = {}
            end
			if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
				LOG('Faction is Seraphim', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
									for k,v in FBPOUI.Images do
		if k and v then v:Destroy() end 
	end
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.SPACESHIP * categories.SERAPHIM  * categories.TECH1)
	local Level2 = EntityCategoryGetUnitList(categories.SPACESHIP * categories.SERAPHIM  * categories.TECH2)
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
		FBPOUI.Images[c] = CreateButton(FBPOUI) 
		linkup(array(arrayPosition(SecondPosition,existed,FBPOUI),x,FBPOUI.Images[c],existed),existed) 
		SetBtnTextures(FBPOUI.Images[c],id) 
		FBPOUI.Images[c].correspondedID = id
		LOG(table.getn(FBPOUI.Images))
			end
			increasedBorder(FBPOUI,15)
			existed = {}
            end
        end
	else
	FBPOUI:Destroy()


	end


--#################################################################### 

-- Toggle Buttons for both Managers

--#################################################################### 
 
UI:Hide()
FBPOUI:Hide()
FBPOUI._closeBtn:Hide()
		
 local buttonpress = 0
 local ReinforcementButton = Class(Button){

    IconTextures = function(self, texture, texture2 ,texture3, texture4, path)
		self:SetTexture(texture)
		self.mNormal = texture 
        self.mActive = texture4
        self.mHighlight = texture2
        self.mDisabled = texture3
		self.Depth:Set(10)
    end,
	
	OnClick = function(self, modifiers)
		buttonpress = buttonpress + 1
		if buttonpress == 1 then
		if FBPOPath then
		FBPOUI:Show()
		FBPOUI._closeBtn:Hide()
		end
		UI:Show()
		headerbox:Show()
		headerboxtext:Show()
		headerboxtext2:Show()
		textboxUI:Show()
		textbox:Show()
		textbox2:Show()
		UI._closeBtn:Hide()
		headerbox._closeBtn:Hide()
		textboxUI._closeBtn:Hide()
		end
		if buttonpress == 2 then
		if FBPOPath then
		FBPOUI._closeBtn:Hide()
		FBPOUI:Hide()
		end
		UI:Hide()
		headerbox:Hide()
		headerboxtext:Hide()
		headerboxtext2:Hide()
		textboxUI:Hide()
		textbox:Hide()
		textbox2:Hide()
		buttonpress = 0
		end
		
	end
}


 local buttonpress = 0
 local FiresupportButton = Class(Button){

    IconTextures = function(self, texture, texture2 ,texture3, texture4, path)
		self:SetTexture(texture)
		self.mNormal = texture 
        self.mActive = texture4
        self.mHighlight = texture2
        self.mDisabled = texture3
		self.Depth:Set(10)
    end,
	
	OnClick = function(self, modifiers)
		buttonpress = buttonpress + 1
		if buttonpress == 1 then
		FSUI:Show()
		FSNUI:Show()
		FSMissileUI:Show()
		fsheaderbox:Show()
		fsheaderboxtext:Show()
		fsheaderboxtext2:Show()
		fstextboxUI:Show()
		fstextbox:Show()
		fstextbox2:Show()
		FSUI._closeBtn:Hide()
		FSNUI._closeBtn:Hide()
		FSMissileUI._closeBtn:Hide()
		fsheaderbox._closeBtn:Hide()
		fstextboxUI._closeBtn:Hide()
		end
		if buttonpress == 2 then
		FSUI:Hide()
		FSNUI:Hide()
		FSMissileUI:Hide()
		fsheaderbox:Hide()
		fsheaderboxtext:Hide()
		fsheaderboxtext2:Hide()
		fstextboxUI:Hide()
		fstextbox:Hide()
		fstextbox2:Hide()
		buttonpress = 0
		end
		
	end
}


--#################################################################### 

-- Reinforcement Button Definitions

--#################################################################### 


existed = {}

local function SetRBtnTextures(ui)
	local location = '/mods/Reinforcement Manager/buttons/reinforcement_btn_up.dds'
	local location2 = '/mods/Reinforcement Manager/buttons/reinforcement_btn_over.dds'
	local location3 = '/mods/Reinforcement Manager/buttons/reinforcement_btn_dis.dds'
	local location4 = '/mods/Reinforcement Manager/buttons/reinforcement_btn_down.dds'
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
end


local function increasedRBTNBorder(ui, scale)
	ui.Top:Set(ui.Top[1] - scale -15)
	ui.Left:Set(ui.Left[1] - scale - 4)
	ui.Right:Set(ui.Right[1] + scale + 5)
	ui.Bottom:Set(ui.Bottom[1] + scale - 5)
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
	
local RBTNPosition = {
	Left = 620, 
	Top = 37, 
	Bottom = 120, 
	Right = 700
}
   
----actions----
RBTNUI = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Construction',Position,Border) 
for i, v in RBTNPosition do 
	RBTNUI[i]:Set(v)
end
RBTNUI._closeBtn:Hide()
RBTNUI.Images = {} 
	for k,v in RBTNUI.Images do
		if k and v then v:Destroy() end 
	end
	local data = {0} 
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		RBTNUI.Images[c] = ReinforcementButton(RBTNUI) 
		linkup(array(arrayPosition(Position,existed,RBTNUI),x,RBTNUI.Images[c],existed),existed) 
		SetRBtnTextures(RBTNUI.Images[c]) 
	end
	increasedRBTNBorder(RBTNUI,15)
	existed = {}
	

--#################################################################### 

-- Fire Support Button Definitions
	
--#################################################################### 
	
existed = {}



local function SetFSBtnTextures(ui)
	local location = '/mods/Reinforcement Manager/buttons/firesupport_btn_up.dds'
	local location2 = '/mods/Reinforcement Manager/buttons/firesupport_btn_over.dds'
	local location3 = '/mods/Reinforcement Manager/buttons/firesupport_btn_dis.dds'
	local location4 = '/mods/Reinforcement Manager/buttons/firesupport_btn_down.dds'
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
end


local function increasedFSBTNBorder(ui, scale)
	ui.Top:Set(ui.Top[1] - scale -15)
	ui.Left:Set(ui.Left[1] - scale - 4)
	ui.Right:Set(ui.Right[1] + scale + 5)
	ui.Bottom:Set(ui.Bottom[1] + scale - 5)
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
	
local FSBTNPosition = {
	Left = 1270, 
	Top = 37, 
	Bottom = 120, 
	Right = 1350
}
   
----actions----
FSBTNUI = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Construction',Position,Border) 
for i, v in FSBTNPosition do 
	FSBTNUI[i]:Set(v)
end
FSBTNUI._closeBtn:Hide()
FSBTNUI.Images = {} 
	for k,v in FSBTNUI.Images do
		if k and v then v:Destroy() end 
	end
	local data = {0} 
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FSBTNUI.Images[c] = FiresupportButton(FSBTNUI) 
		linkup(array(arrayPosition(Position,existed,FSBTNUI),x,FSBTNUI.Images[c],existed),existed) 
		SetFSBtnTextures(FSBTNUI.Images[c]) 
	end
	increasedFSBTNBorder(FSBTNUI,15)
	existed = {}	
 
 
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
	
	if Tacticalpoints >= StartTACPoints then
		if bp.Description == 'Light Artillery Barrage' then
			Tacticalpoints = Tacticalpoints - LAB
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
		if bp.Description == 'Medium Artillery Barrage' then
			if Tacticalpoints < MAB then
			
			else
			Tacticalpoints = Tacticalpoints - MAB
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
		if bp.Description == 'Artillery Barrage' then
			if Tacticalpoints < AB then
			
			else
			Tacticalpoints = Tacticalpoints - AB
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
		if bp.Description == 'Heavy Artillery Barrage' then
			if Tacticalpoints < HAB then
			
			else
			Tacticalpoints = Tacticalpoints - HAB
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
		if bp.Description == 'Experimental Artillery Barrage' then
			if Tacticalpoints < EXAB then
			
			else
			Tacticalpoints = Tacticalpoints - EXAB
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
		
		if bp.Description == 'Light Battleship Barrage' then
			if Tacticalpoints < LBB then
			
			else
			Tacticalpoints = Tacticalpoints - LBB
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
		
		if bp.Description == 'Medium Battleship Barrage' then
			if Tacticalpoints < MBB then
			
			else
			Tacticalpoints = Tacticalpoints - MBB
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
		
		if bp.Description == 'Heavy Battleship Barrage (Full Broadside)' then
			if Tacticalpoints < HBB then
			
			else
			Tacticalpoints = Tacticalpoints - HBB
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
		
		if bp.Description == 'Light Missile Barrage' then
			if Tacticalpoints < LMB then
			
			else
			Tacticalpoints = Tacticalpoints - LMB
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
		
		if bp.Description == 'Medium Missile Barrage' then
			if Tacticalpoints < MMB then
			
			else
			Tacticalpoints = Tacticalpoints - MMB
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
		
		if bp.Description == 'Tactical Nuke Missile Barrage' then
			if Tacticalpoints < TNMB then
			
			else
			Tacticalpoints = Tacticalpoints - TNMB
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
	end
}


local function increasedFSBorder(ui, scale)
	ui.Top:Set(ui.Top[1] - scale - 15)
	ui.Left:Set(ui.Left[1] - scale - 2)
	ui.Right:Set(ui.Right[1] + scale + 15)
	ui.Bottom:Set(ui.Bottom[1] + scale + 15)
end


local FSArtPosition = {
	Left = 1680, 
	Top = 600, 
	Bottom = 640, 
	Right = 1920
}

local FSNavalPosition = {
	Left = 1680, 
	Top = 700, 
	Bottom = 740, 
	Right = 1920
}

local FSMissilePosition = {
	Left = 1680, 
	Top = 800, 
	Bottom = 840, 
	Right = 1920
}

local function SetFSARTBtnTextures(ui, id)
	local location = '/mods/Reinforcement Manager/icons/firesupport/activate-weapon_btn_up.dds' 									-- Normal Icon
	local location2 = '/mods/Reinforcement Manager/icons/firesupport/activate-weapon_btn_over.dds'		-- Mouseover Icon
	local location3 = '/mods/Reinforcement Manager/icons/firesupport/activate-weapon_btn_down.dds'		-- Selected Icon
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), path)
end

local function SetFSNVBtnTextures(ui, id)
	local location = '/mods/Reinforcement Manager/icons/units/up/' .. id .. '_icon.dds' 									-- Normal Icon
	local location2 = '/mods/Reinforcement Manager/icons/units/over/' .. id .. '_icon.dds'		-- Mouseover Icon
	local location3 = '/mods/Reinforcement Manager/icons/units/active/' .. id .. '_icon.dds'		-- Selected Icon
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), path)
end

local function SetFSMBtnTextures(ui, id)
	local location = '/mods/Reinforcement Manager/icons/firesupport/silo-build-tactical_btn_up.dds' 									-- Normal Icon
	local location2 = '/mods/Reinforcement Manager/icons/firesupport/silo-build-tactical_btn_over.dds'		-- Mouseover Icon
	local location3 = '/mods/Reinforcement Manager/icons/firesupport/silo-build-tactical_btn_down.dds'		-- Selected Icon
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
		pos.Height = -113 / total
		pos.Width = 113 / total
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

FSUI:Hide()
FSNUI:Hide()
FSMissileUI:Hide()
 
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


--#################################################################### 

-- Unused Code (archived for later use -- maybe)

--#################################################################### 

    PlayHyperspaceOutEffects = function(self)
        local army = GetFocusArmy()
        local emit = nil
		local bp = __blueprints[self.correspondedID]
		local EffectSize = bp.Physics.MeshExtentsX
		local YOffset = bp.Physics.MeshExtentsY
		local faction = bp.General.FactionName
		
		if faction == 'UEF' then
        for k, v in FBPOEffectTemplates.UEFHyperspaceOut01 do
            emit = CreateAttachedEmitter(self, 0, self.Army, v):OffsetEmitter(0, YOffset, bp.Physics.MeshExtentsZ -9)
			emit:ScaleEmitter(EffectSize)
			emit:SetEmitterCurveParam('Y_POSITION_CURVE', 0, YOffset * 2) -- To make effects cover entire height of unit
        end
		elseif faction == 'Cybran' then
        for k, v in FBPOEffectTemplates.CybranHyperspaceOut01 do
            emit = CreateAttachedEmitter(self, 0, self.Army, v):OffsetEmitter(0, YOffset, bp.Physics.MeshExtentsZ -9)
			emit:ScaleEmitter(EffectSize)
			emit:SetEmitterCurveParam('Y_POSITION_CURVE', 0, YOffset * 2) -- To make effects cover entire height of unit
        end
		elseif faction == 'Aeon' then
        for k, v in FBPOEffectTemplates.AeonHyperspaceOut01 do
            emit = CreateAttachedEmitter(self, 0, self.Army, v):OffsetEmitter(0, YOffset, bp.Physics.MeshExtentsZ -9)
			emit:ScaleEmitter(EffectSize)
			emit:SetEmitterCurveParam('Y_POSITION_CURVE', 0, YOffset * 2) -- To make effects cover entire height of unit
        end
		elseif faction == 'Seraphim' then
        for k, v in FBPOEffectTemplates.SeraphimHyperspaceOut01 do
            emit = CreateAttachedEmitter(self, 0, self.Army, v):OffsetEmitter(0, YOffset, bp.Physics.MeshExtentsZ -9)
			emit:ScaleEmitter(EffectSize)
			emit:SetEmitterCurveParam('Y_POSITION_CURVE', 0, YOffset * 2) -- To make effects cover entire height of unit
        end
		else
		end
    end


PingTypes = {
    nuke = {Lifetime = 10, Mesh = 'nuke_marker', Ring = '/textures/ui/common/game/marker/ring_nuke04-blur.dds', ArrowColor = 'red', Sound = 'Aeon_Select_Radar'},
}

local lastPingData = {}
local redundantPingCheckDistance = 10
local redundantPingCheckTime = 8

function DoNukePing(position)
    local pingType = 'nuke'
    if SessionIsReplay() or import('/lua/ui/game/gamemain.lua').supressExitDialog or import('/lua/ui/game/gamemain.lua').IsNISMode() then return end
        for _, v in position do
            local var = v
            if var ~= v then
                return
            end
        end
        local army = launchData.army

        -- Check ping table do determine if this is another ping near the same place at the same time
        local pingTime = GetGameTimeSeconds()
        local pingOkFlag = false
        if lastPingData[army] then
            -- If data has been set, check it...
            if VDist3(lastPingData[army].loc, position) > redundantPingCheckDistance or lastPingData[army].tm < pingTime - redundantPingCheckTime then
                pingOkFlag = true
                lastPingData[army] = {loc = position, tm = pingTime}
            end
        else
            -- If no data has been set for this army, set some
            lastPingData[army] = {loc = position, tm = pingTime}
            pingOkFlag = true
        end

        if pingOkFlag then
            local data = {Owner = army, Type = pingType, Location = position}
            data = table.merged(data, PingTypes[pingType])
            SimCallback({Func = 'SpawnSpecialPing', Args = data})
        end
end



		

	--[[
    local modeData = {
        cursor = 'RULEUCC_Move',
        pingType = 'move',
    }
    cmdMode.StartCommandMode("ping", modeData)
	textbox:SetText('Is on the way')
	    function EndBehavior(mode, data)
        if mode == 'ping' and not data.isCancel then
			local position = GetMouseWorldPos()
			local flag = IsKeyDown('Shift')
			SimCallback({Func = 'SpawnReinforcements',Args = {id = self.correspondedID, pos = position, yes = not flag, ArmyIndex = GetFocusArmy()}},true)
			self.correspondedID = nil
        end
    end
    cmdMode.AddEndBehavior(EndBehavior)
	textbox:SetText('Unit has arrived')
	textbox:SetText('Waiting for target position')
	]]--
	
	
	--[[
	number = number + 1
	LOG(number)
		local selection = GetSelectedUnits()
		if selection then 
			local engs = EntityCategoryFilterDown(categories.ENGINEER,selection)
			if engs[1] then
				textbox:SetText('Unit selected')
				ForkThread(
					function()
						local cpos = GetClickPosition()
						local flag = IsKeyDown('Shift')
						cpos[1] = nil
						while not cpos[1] do
							WaitSeconds(0.1)
						end
						if flag then
							-- For Multi Reinforcements Calls when Shift is pressed
							if number >= 4 then 
								textbox:SetText('No available Units')
							else
								local UnitCategories = __blueprints[self.correspondedID].Categories
								LOG(UnitCategories)
								--local arrivaltime = __blueprints[self.correspondedID].Economy.BuildTime -- Set the arrival Time for the Unit (based on it's Build Time to make it more individually)
								--LOG(arrivaltime)
								local arrivaltime = 10
								textbox:SetText('Is on the way')
								textbox:SetText('Arrival: 10 Seconds')
								WaitSeconds(arrivaltime)
								SimCallback({Func = 'TheSecondConstructionPanel',Args = {id = self.correspondedID, pos = cpos[1], yes = not flag, aiBrain = GetFocusArmy()}},true)
								WaitSeconds(2)
								textbox:SetText('Units have arrived')
								WaitSeconds(2)
								textbox:SetText('Waiting for target position')
							end
						else
							-- For Single Reinforcements Calls (without Shift)
							if number >= 4 then 
								textbox:SetText('No available Units')
							else
								local arrivaltime = 0
								LOG(arrivaltime)
								--local arrivaltime = __blueprints[self.correspondedID].Economy.BuildTime -- Set the arrival Time for the Unit (based on it's Build Time to make it more individually)
								if EntityCategoryContains(categories.FRIGATE, self.correspondedID) then
									arrivaltime = 10
									LOG(arrivaltime)
								end
								if EntityCategoryContains(categories.FRIGATE, self.correspondedID) then
									arrivaltime = 10
									LOG(arrivaltime)
								end
								textbox:SetText('Is on the way')
								textbox:SetText('Arrival: 10 Seconds')
								WaitSeconds(arrivaltime)
								SimCallback({Func = 'TheSecondConstructionPanel',Args = {id = self.correspondedID, pos = cpos[1], yes = not flag, aiBrain = GetFocusArmy()}},true)
								PlayHyperspaceOutEffects()
								WaitSeconds(2)
								textbox:SetText('Unit has arrived')
								WaitSeconds(2)
								textbox:SetText('Waiting for target position')
							end
						end
					end
				)
			end
		else 
			textbox:SetText('Please keep the Unit selected')
			return
		end	
			]]--


