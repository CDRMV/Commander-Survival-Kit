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

local NWave = 'Next Wave available in:'
local MaxTactpoints = '/1200'
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
headerboxtext:SetText(NWave)

--#################################################################### 

-- Main Code for Space Reinforcement Buttons
-- This Code is indentical to the Air Reinforcement Manager 
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

-- Code for Space Reinforcements 
-- This Manager Section will appear if FBP Orbital is activated

--#################################################################### 

FBPOUI = CreateWindow(GetFrame(0),'Available Units',nil,false,false,true,true,'Reinforcements',SecondPosition,Border) 
for i, v in SecondPosition do 
	FBPOUI[i]:Set(v)
end
FBPOUI._closeBtn:Hide()
FBPOUI.Images = {} 
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()	
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


