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

local fstext = '0/2500'
local fstext2 = 'Collected Points: 0/2500'
local fstext3 = 'Rate: 1 Point per 3 Seconds'
local fstext4 = 'No available Points'
local fstext5 = 'Generation starts in:'
local fstext6 = '5 Minutes'
local reftext = '0/2500'
local reftext2 = ''
local reftext3 = ''
local reftext4 = ''
local reftext5 = 'Generation starts in:'
local reftext6 = '5 Minutes'
local NWave = 'Next Wave available in:'
local MaxRefpoints = '/2500'
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
info:Hide()
infoboxtext:Hide()
infoboxtext2:Hide()
infoboxtext3:Hide()
--#################################################################### 

-- Reinforcements Points Definition

--#################################################################### 

local StartRefPoints = 25 
local MaxReinforcementsPoints = 2500 	-- Maximum collectable Tactical Points
local RefWaitInterval = 300 -- Set Wait Time (5 Minutes)

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
			if Seconds < RefWaitInterval and Reinforcementpoints < StartRefPoints then
				reftext2 = 'Generation starts in: 5 Minutes'
				refheaderboxtext:SetText(reftext2)
				reftext4 = 'No avaiable Points.'
				refheaderboxtext2:SetText(reftext4)
			end
			if Seconds > RefWaitInterval and Reinforcementpoints >= StartRefPoints then
				reftext2 = 'Points available'
				refheaderboxtext:SetText(reftext2)
				reftext4 = 'Awaiting Orders'
				refheaderboxtext2:SetText(reftext4)
				Reinforcementpoints = Reinforcementpoints + 1
			end
			if Seconds > RefWaitInterval and Reinforcementpoints <= StartRefPoints then 
				reftext2 = 'Generation in Progress'
				refheaderboxtext:SetText(reftext2)
				reftext4 = 'Not enough Points'
				refheaderboxtext2:SetText(reftext4)
				Reinforcementpoints = Reinforcementpoints + 1
			end
			if Seconds > RefWaitInterval and Reinforcementpoints == MaxReinforcementsPoints then
				availableboxtext:SetText('Points Limit reached!')
				availablebox:Show()
				availableboxtext:Show()
			end
			MainRefPoints = 'Collected Points: ' .. Reinforcementpoints .. MaxRefpoints
			RefPoints = Reinforcementpoints .. MaxRefpoints
			--refheaderboxtext:SetText(MainRefPoints)
			RefUItext:SetText(RefPoints)
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

function array(pos, total, Image, existed)
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
	local Price = bp.Economy.BuildCostMass
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
			SpawnReinforcement(ID)
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
		local Tech
		local Techlevel1 = EntityCategoryContains(categories.TECH1, ID)
		local Techlevel2 = EntityCategoryContains(categories.TECH2, ID)
		local Techlevel3 = EntityCategoryContains(categories.TECH3, ID)
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
			price = 'Price: ' .. 25 -- Land Scouts cost normally 8 Mass 
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
	
	--[[
	OnClick = function(self, modifiers)
		LOG(Reinforcementpoints)
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
	]]--
	OnClick = function(self, modifiers)
	
	local Effects = {
		'crater01_albedo'
	}
	local ID = self.correspondedID
	local bp = __blueprints[ID]
	
	local Desc = bp.Description
	local Faction = bp.General.FactionName
	local Price = bp.Economy.BuildCostMass
	LOG(Price)
	if Reinforcementpoints >= StartRefPoints then
		if Reinforcementpoints < Price then
			
		else
			Reinforcementpoints = Reinforcementpoints - Price
			RefPoints = Reinforcementpoints .. MaxRefpoints
			RefUItext:SetText(RefPoints)
			SpawnAirReinforcement(ID)
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
		local Tech
		local Techlevel1 = EntityCategoryContains(categories.TECH1, ID)
		local Techlevel2 = EntityCategoryContains(categories.TECH2, ID)
		local Techlevel3 = EntityCategoryContains(categories.TECH3, ID)
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
--[[	
	OnClick = function(self, modifiers)
		LOG(Reinforcementpoints)
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
]]--
OnClick = function(self, modifiers)
	
	local Effects = {
		'crater01_albedo'
	}
	local ID = self.correspondedID
	local bp = __blueprints[ID]
	
	local Desc = bp.Description
	local Faction = bp.General.FactionName
	local Price = bp.Economy.BuildCostMass
	LOG(Price)
	
	if Reinforcementpoints >= StartRefPoints then
		if Reinforcementpoints < Price then
			
		else
			Reinforcementpoints = Reinforcementpoints - Price
			RefPoints = Reinforcementpoints .. MaxRefpoints
			RefUItext:SetText(RefPoints)
			SpawnReinforcement(ID)
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
		local Tech
		local Techlevel1 = EntityCategoryContains(categories.TECH1, ID)
		local Techlevel2 = EntityCategoryContains(categories.TECH2, ID)
		local Techlevel3 = EntityCategoryContains(categories.TECH3, ID)
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

function SpawnSpaceReinforcement(UnitID)
		local BorderPos, OppBorPos
		local position = GetMouseWorldPos()
		local flag = IsKeyDown('Shift')
		for _, v in position do
			local var = v
			if var >= 0  then
				var = var * -1
			end
		end
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
		SimCallback({Func = 'SpawnReinforcements',Args = {id = UnitID, pos = BorderPos, yes = not flag, ArmyIndex = GetFocusArmy(), Quantity = quantity, X = x, Z = z}},true)
		UnitID = nil
		arrivalbox:Show()
		arrivalboxtext:Show()
end

function SpawnAirReinforcement(UnitID)
		local BorderPos, OppBorPos
		local position = GetMouseWorldPos()
		local flag = IsKeyDown('Shift')
		for _, v in position do
			local var = v
			if var >= 0  then
				var = var * -1
			end
		end
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
		SimCallback({Func = 'SpawnReinforcements',Args = {id = UnitID, pos = BorderPos, yes = not flag, ArmyIndex = GetFocusArmy(), Quantity = quantity, X = x, Z = z}},true)
		UnitID = nil
		arrivalbox:Show()
		arrivalboxtext:Show()
end

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
					--arrivalbox:Show()
					--arrivalboxtext:Show()
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





