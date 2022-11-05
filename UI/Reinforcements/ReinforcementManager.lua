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
--local FSPUI = import(path .. 'tacui.lua').UI
local FSPUItext = import(path .. 'tacui.lua').Text
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
FSPUItext:SetText(fstext)
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
local MaxRefPoints = 1200 	-- Maximum collectable Tactical Points
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


--#################################################################### 

-- Tactical Points Definition

--#################################################################### 

local StartTACPoints = 50 
local MaxTACPoints = 1200 	-- Maximum collectable Tactical Points
local TacWaitInterval = 300 -- Set Wait Time (5 Minutes)

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
			end
			if Reinforcementpoints > 50 then 
				reftext4 = 'Points available'
				fstextbox:SetText(fstext4)
				reftext5 = 'Awaiting Orders'
				fstextbox2:SetText(fstext5)
			end
			if Reinforcementpoints < 50 then 
				reftext4 = 'No Points available'
				fstextbox:SetText(reftext4)
				reftext5 = 'Generation starts in:'
				fstextbox2:SetText(reftext5)
			end
			if Reinforcementpoints == MaxTACPoints then
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
	
	LOG(bp.Description)
	
	if Reinforcementpoints >= StartRefPoints then
		if bp.Description == ScoutDesc then
			if Reinforcementpoints < T1S then
			
			else
			Reinforcementpoints = Reinforcementpoints - T1S
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
		if bp.Description == MobileLightArtyDesc then
			if Reinforcementpoints < T1ART then
			
			else
			Reinforcementpoints = Reinforcementpoints - T1ART
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
		if bp.Description == MobileAADesc then
			if Reinforcementpoints < T1AA then
			
			else
			Reinforcementpoints = Reinforcementpoints - T1AA
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
		if bp.Description == EngiDesc then
			if Reinforcementpoints < T1ENGI then
			
			else
			Reinforcementpoints = Reinforcementpoints - T1ENGI
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
		if bp.Description == LABDesc then
			if Reinforcementpoints < T1BOT then
			
			else
			Reinforcementpoints = Reinforcementpoints - T1BOT
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
		if bp.Description == MTMLDesc then
			if Reinforcementpoints < T2MIS then
			
			else
			Reinforcementpoints = Reinforcementpoints - T2MIS
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
		if bp.Description == LTankDesc then
			if Reinforcementpoints < T1Tank then
			
			else
			Reinforcementpoints = Reinforcementpoints - T1Tank
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
		if bp.Description == HTankDesc then
			if Reinforcementpoints < T2Tank then
			
			else
			Reinforcementpoints = Reinforcementpoints - T2Tank
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
		if bp.Description == MobileHAADesc then
			if Reinforcementpoints < T2AA then
			
			else
			Reinforcementpoints = Reinforcementpoints - T2AA
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
				if bp.Description == MobileHArtyDesc then
			if Reinforcementpoints < T3ART then
			
			else
			Reinforcementpoints = Reinforcementpoints - T3ART
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
		if bp.Description == HABDesc then
			if Reinforcementpoints < T3BOT then
			
			else
			Reinforcementpoints = Reinforcementpoints - T3BOT
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
		if bp.Description == MSDesc then
			if Reinforcementpoints < T2SH then
			
			else
			Reinforcementpoints = Reinforcementpoints - T2SH
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

-- Code for Air Reinforcements 
-- This is the regular Manager Section

--#################################################################### 

UI = CreateWindow(GetFrame(0),'Available Units',nil,false,false,true,true,'Reinforcements',Position,Border) 
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

FBPOUI = CreateWindow(GetFrame(0),'Available Units',nil,false,false,true,true,'Reinforcements',SecondPosition,Border) 
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
LandUI:Hide()
UI:Hide()
FBPOUI:Hide()
FBPOUI._closeBtn:Hide()
		
 local buttonpress = 0
 local landbuttonpress = 0
 local airbuttonpress = 0
 local spacebuttonpress = 0
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
		SBTNUI:Show()
		end
		LBTNUI:Show()
		ABTNUI:Show()
		end
		if buttonpress == 2 then
		landbuttonpress = 0
		airbuttonpress = 0
		spacebuttonpress = 0
		if FBPOPath then
		SBTNUI:Hide()
		FBPOUI:Hide()
		end
		LBTNUI:Hide()
		ABTNUI:Hide()
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


 local fsbuttonpress = 0
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
		fsbuttonpress = fsbuttonpress + 1
		if fsbuttonpress == 1 then
		FWBTNUI:Show()
		FWBTNUI._closeBtn:Hide()
		BBTNUI:Show()
		BBTNUI._closeBtn:Hide()
		FSUI:Show()
		FSNUI:Show()
		FSMissileUI:Show()
		fsheaderbox:Show()
		fsheaderboxtext:Show()
		fsheaderboxtext2:Show()
		fstextboxUI:Show()
		fstextbox:Show()
		fstextbox2:Show()
		fstextbox3:Show()
		FSUI._closeBtn:Hide()
		FSNUI._closeBtn:Hide()
		FSMissileUI._closeBtn:Hide()
		fsheaderbox._closeBtn:Hide()
		fstextboxUI._closeBtn:Hide()
		end
		if fsbuttonpress == 2 then
		FWBTNUI:Hide()
		BBTNUI:Hide()
		FSUI:Hide()
		FSNUI:Hide()
		FSMissileUI:Hide()
		fsheaderbox:Hide()
		fsheaderboxtext:Hide()
		fsheaderboxtext2:Hide()
		fstextboxUI:Hide()
		fstextbox:Hide()
		fstextbox2:Hide()
		fstextbox3:Hide()
		fsbuttonpress = 0
		end
		
	end
}

--#################################################################### 

-- Layer Buttons for Reinforcement Manager

--#################################################################### 

 local LandButton = Class(Button){

    IconTextures = function(self, texture, texture2 ,texture3, texture4, path)
		self:SetTexture(texture)
		self.mNormal = texture 	-- texture
        self.mActive = texture2 	-- texture 2
        self.mHighlight = texture4 	-- texture 4
        self.mDisabled = texture3
		self.Depth:Set(10)
    end,
	
	OnClick = function(self, modifiers)
		landbuttonpress = landbuttonpress + 1
		if landbuttonpress == 1 then
		FBPOUI:Hide()
		UI:Hide()
		LandUI:Show()
		refheaderbox:Show()
		refheaderboxtext:Show()
		refheaderboxtext2:Show()
		reftextboxUI:Show()
		reftextbox:Show()
		reftextbox2:Show()
		reftextbox3:Show()
		refheaderbox._closeBtn:Hide()
		reftextboxUI._closeBtn:Hide()
		LandUI._closeBtn:Hide()
		headerbox._closeBtn:Hide()
		textboxUI._closeBtn:Hide()
		end
		if landbuttonpress == 2 then
		LandUI:Hide()
		refheaderbox:Hide()
		refheaderboxtext:Hide()
		refheaderboxtext2:Hide()
		reftextboxUI:Hide()
		reftextbox:Hide()
		reftextbox2:Hide()
		reftextbox3:Hide()
		headerbox:Hide()
		headerboxtext:Hide()
		headerboxtext2:Hide()
		textboxUI:Hide()
		textbox:Hide()
		textbox2:Hide()
		landbuttonpress = 0
		end
	end
}

 local AirButton = Class(Button){

    IconTextures = function(self, texture, texture2 ,texture3, texture4, path)
		self:SetTexture(texture)
		self.mNormal = texture 	-- texture
        self.mActive = texture2 	-- texture 2
        self.mHighlight = texture4 	-- texture 4
        self.mDisabled = texture3
		self.Depth:Set(10)
    end,
	
	OnClick = function(self, modifiers)
		airbuttonpress = airbuttonpress + 1
		if airbuttonpress == 1 then
		LandUI:Hide()
		FBPOUI:Hide()
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
		if airbuttonpress == 2 then
		UI:Hide()
		headerbox:Hide()
		headerboxtext:Hide()
		headerboxtext2:Hide()
		textboxUI:Hide()
		textbox:Hide()
		textbox2:Hide()
		airbuttonpress = 0
		end
	end
}

 local SpaceButton = Class(Button){

    IconTextures = function(self, texture, texture2 ,texture3, texture4, path)
		self:SetTexture(texture)
		self.mNormal = texture 	-- texture
        self.mActive = texture2 	-- texture 2
        self.mHighlight = texture4 	-- texture 4
        self.mDisabled = texture3
		self.Depth:Set(10)
    end,
	
	OnClick = function(self, modifiers)
		spacebuttonpress = spacebuttonpress + 1
		if spacebuttonpress == 1 then
		LandUI:Hide()
		FBPOUI:Show()
		FBPOUI._closeBtn:Hide()
		headerbox:Show()
		headerboxtext:Show()
		headerboxtext2:Show()
		textboxUI:Show()
		textbox:Show()
		textbox2:Show()
		headerbox._closeBtn:Hide()
		textboxUI._closeBtn:Hide()
		end
		if spacebuttonpress == 2 then
		FBPOUI:Hide()
		headerbox:Hide()
		headerboxtext:Hide()
		headerboxtext2:Hide()
		textboxUI:Hide()
		textbox:Hide()
		textbox2:Hide()
		spacebuttonpress = 0
		end
	end
}


		if FBPOPath then

		end
--#################################################################### 

-- Land Button Definitions

--#################################################################### 


existed = {}

local function SetLBtnTextures(ui)
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Layer Buttons/Aeon/Land.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Aeon/Land active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Aeon/Land deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Aeon/Land hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Layer Buttons/Cybran/Land.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Cybran/Land active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Cybran/Land deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Cybran/Land hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Layer Buttons/UEF/Land.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Layer Buttons/UEF/Land active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Layer Buttons/UEF/Land deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Layer Buttons/UEF/Land hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			LOG('Faction is Seraphim', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Layer Buttons/Seraphim/Land.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Seraphim/Land active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Seraphim/Land deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Seraphim/Land hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
	end	
end


local function increasedLBTNBorder(ui, scale)
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
	
local LBTNPosition = {
	Left = 160, 
	Top = 150, 
	Bottom = 170, 
	Right = 200
}  
----actions----
LBTNUI = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Construction',Position,Border) 
for i, v in LBTNPosition do 
	LBTNUI[i]:Set(v)
end
LBTNUI._closeBtn:Hide()
LBTNUI.Images = {} 
	for k,v in LBTNUI.Images do
		if k and v then v:Destroy() end 
	end
	local data = {0} 
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		LBTNUI.Images[c] = LandButton(LBTNUI) 
		linkup(array(arrayPosition(Position,existed,LBTNUI),x,LBTNUI.Images[c],existed),existed) 
		SetLBtnTextures(LBTNUI.Images[c]) 
	end
	existed = {}

LBTNUI:Hide() 
LBTNUI._closeBtn:Hide()

--#################################################################### 

-- Air Button Definitions

--#################################################################### 


existed = {}

local function SetABtnTextures(ui)
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Layer Buttons/Aeon/Air.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Aeon/Air active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Aeon/Air deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Aeon/Air hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Layer Buttons/Cybran/Air.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Cybran/Air active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Cybran/Air deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Cybran/Air hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Layer Buttons/UEF/Air.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Layer Buttons/UEF/Air active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Layer Buttons/UEF/Air deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Layer Buttons/UEF/Air hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			LOG('Faction is Seraphim', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Layer Buttons/Seraphim/Air.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Seraphim/Air active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Seraphim/Air deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Seraphim/Air hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
	end	
end


local function increasedABTNBorder(ui, scale)
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
	
local ABTNPosition = {
	Left = 160, 
	Top = 170, 
	Bottom = 190, 
	Right = 200
}  
----actions----
ABTNUI = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Construction',Position,Border) 
for i, v in ABTNPosition do 
	ABTNUI[i]:Set(v)
end
ABTNUI._closeBtn:Hide()
ABTNUI.Images = {} 
	for k,v in ABTNUI.Images do
		if k and v then v:Destroy() end 
	end
	local data = {0} 
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		ABTNUI.Images[c] = AirButton(ABTNUI) 
		linkup(array(arrayPosition(Position,existed,ABTNUI),x,ABTNUI.Images[c],existed),existed) 
		SetABtnTextures(ABTNUI.Images[c]) 
	end
	existed = {}

ABTNUI:Hide() 
ABTNUI._closeBtn:Hide()

--#################################################################### 

-- Space Button Definitions

--#################################################################### 


existed = {}

local function SetSBtnTextures(ui)
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Layer Buttons/Aeon/Space.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Aeon/Space active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Aeon/Space deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Aeon/Space hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Layer Buttons/Cybran/Space.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Cybran/Space active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Cybran/Space deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Cybran/Space hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Layer Buttons/UEF/Space.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Layer Buttons/UEF/Space active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Layer Buttons/UEF/Space deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Layer Buttons/UEF/Space hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			LOG('Faction is Seraphim', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Layer Buttons/Seraphim/Space.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Seraphim/Space active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Seraphim/Space deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Layer Buttons/Seraphim/Space hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
	end	
end


local function increasedSBTNBorder(ui, scale)
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
	
local SBTNPosition = {
	Left = 160, 
	Top = 190, 
	Bottom = 210, 
	Right = 200
}  
----actions----
SBTNUI = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Construction',Position,Border) 
for i, v in SBTNPosition do 
	SBTNUI[i]:Set(v)
end
SBTNUI._closeBtn:Hide()
SBTNUI.Images = {} 
	for k,v in SBTNUI.Images do
		if k and v then v:Destroy() end 
	end
	local data = {0} 
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		SBTNUI.Images[c] = SpaceButton(SBTNUI) 
		linkup(array(arrayPosition(Position,existed,SBTNUI),x,SBTNUI.Images[c],existed),existed) 
		SetSBtnTextures(SBTNUI.Images[c]) 
	end
	existed = {}

SBTNUI:Hide() 
SBTNUI._closeBtn:Hide()

--#################################################################### 

-- Switch Buttons for FS Manager

--#################################################################### 

 local ForwardButton = Class(Button){

    IconTextures = function(self, texture, texture2 ,texture3, texture4, path)
		self:SetTexture(texture3)
		self.mNormal = texture3 	-- texture
        self.mActive = texture3 	-- texture 4
        self.mHighlight = texture3 	-- texture 2
        self.mDisabled = texture3
		self.Depth:Set(10)
    end,
	
	OnClick = function(self, modifiers)
		
	end
}

 local BackButton = Class(Button){

    IconTextures = function(self, texture, texture2 ,texture3, texture4, path)
		self:SetTexture(texture3)
		self.mNormal = texture3 	-- texture
        self.mActive = texture3 	-- texture 4
        self.mHighlight = texture3 	-- texture 2
        self.mDisabled = texture3
		self.Depth:Set(10)
    end,
	
	OnClick = function(self, modifiers)
		
	end
}

--#################################################################### 

-- Forward Button Definitions

--#################################################################### 


existed = {}

local function SetFWBtnTextures(ui)
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Switch Buttons/Aeon/Forward.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Aeon/Forward active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Aeon/Forward deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Aeon/Forward hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Switch Buttons/Cybran/Forward.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Cybran/Forward active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Cybran/Forward deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Cybran/Forward hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Switch Buttons/UEF/Forward.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Switch Buttons/UEF/Forward active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Switch Buttons/UEF/Forward deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Switch Buttons/UEF/Forward hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			LOG('Faction is Seraphim', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Switch Buttons/Seraphim/Forward.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Seraphim/Forward active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Seraphim/Forward deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Seraphim/Forward hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
	end	
end


local function increasedFWBTNBorder(ui, scale)
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
	
local FWBTNPosition = {
	Left = 250, 
	Top = 180, 
	Bottom = 210, 
	Right = 280
}  
----actions----
FWBTNUI = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Construction',Position,Border) 
for i, v in FWBTNPosition do 
	FWBTNUI[i]:Set(v)
end
FWBTNUI._closeBtn:Hide()
FWBTNUI.Images = {} 
	for k,v in FWBTNUI.Images do
		if k and v then v:Destroy() end 
	end
	local data = {0} 
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		FWBTNUI.Images[c] = ForwardButton(FWBTNUI) 
		linkup(array(arrayPosition(Position,existed,FWBTNUI),x,FWBTNUI.Images[c],existed),existed) 
		SetFWBtnTextures(FWBTNUI.Images[c]) 
	end
	increasedFWBTNBorder(FWBTNUI,15)
	existed = {}

FWBTNUI:Hide() 
FWBTNUI._closeBtn:Hide()

--#################################################################### 

-- Back Button Definitions

--#################################################################### 


existed = {}

local function SetBBtnTextures(ui)
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Switch Buttons/Aeon/Back.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Aeon/Back active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Aeon/Back deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Aeon/Back hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Switch Buttons/Cybran/Back.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Cybran/Back active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Cybran/Back deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Cybran/Back hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Switch Buttons/UEF/Back.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Switch Buttons/UEF/Back active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Switch Buttons/UEF/Back deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Switch Buttons/UEF/Back hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			LOG('Faction is Seraphim', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Reinforcement Manager/buttons/Switch Buttons/Seraphim/Back.dds'
			local location2 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Seraphim/Back active.dds'
			local location3 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Seraphim/Back deactive.dds'
			local location4 = '/mods/Reinforcement Manager/buttons/Switch Buttons/Seraphim/Back hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
	end	
end


local function increasedBBTNBorder(ui, scale)
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
	
local BBTNPosition = {
	Left = 180, 
	Top = 180, 
	Bottom = 210, 
	Right = 210
}  
----actions----
BBTNUI = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Construction',Position,Border) 
for i, v in BBTNPosition do 
	BBTNUI[i]:Set(v)
end
BBTNUI._closeBtn:Hide()
BBTNUI.Images = {} 
	for k,v in BBTNUI.Images do
		if k and v then v:Destroy() end 
	end
	local data = {0} 
	local x = table.getn(data)
	x = math.sqrt(x) 
	existed[3] = true
	for c,id in data do
		BBTNUI.Images[c] = BackButton(BBTNUI) 
		linkup(array(arrayPosition(Position,existed,BBTNUI),x,BBTNUI.Images[c],existed),existed) 
		SetBBtnTextures(BBTNUI.Images[c]) 
	end
	increasedBBTNBorder(BBTNUI,15)
	existed = {}

BBTNUI:Hide() 
BBTNUI._closeBtn:Hide()

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
	Left = 110, 
	Top = 180, 
	Bottom = 210, 
	Right = 140
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
	Left = 40, 
	Top = 180, 
	Bottom = 210, 
	Right = 70
}
   
----actions----
FSBTNUI = CreateWindow(GetFrame(0),nil,nil,nil,nil,true,true,'Construction',Position,Border) 
for i, v in FSBTNPosition do 
	FSBTNUI[i]:Set(v)
end
FSBTNUI._closeBtn:Hide()
--FSPUI._closeBtn:Hide()
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
	Left = 30, 
	Top = 450, 
	Bottom = 490, 
	Right = 270
}

local FSNavalPosition = {
	Left = 30, 
	Top = 550, 
	Bottom = 590, 
	Right = 270
}

local FSMissilePosition = {
	Left = 30, 
	Top = 650, 
	Bottom = 690, 
	Right = 270
}

local function SetFSARTBtnTextures(ui, id)
	local location = '/mods/Reinforcement Manager/icons/firesupport/up/'.. id ..'_btn_up.dds' 									-- Normal Icon
	local location2 = '/mods/Reinforcement Manager/icons/firesupport/over/'.. id ..'_btn_over.dds'		-- Mouseover Icon
	local location3 = '/mods/Reinforcement Manager/icons/firesupport/active/'.. id ..'_btn_down.dds'		-- Selected Icon
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), path)
end

local function SetFSNVBtnTextures(ui, id)
	local location = '/mods/Reinforcement Manager/icons/firesupport/up/'.. id ..'_btn_up.dds' 									-- Normal Icon
	local location2 = '/mods/Reinforcement Manager/icons/firesupport/over/'.. id ..'_btn_over.dds'		-- Mouseover Icon
	local location3 = '/mods/Reinforcement Manager/icons/firesupport/active/'.. id ..'_btn_down.dds'
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), path)
end

local function SetFSMBtnTextures(ui, id)
	local location = '/mods/Reinforcement Manager/icons/firesupport/up/'.. id ..'_btn_up.dds' 									-- Normal Icon
	local location2 = '/mods/Reinforcement Manager/icons/firesupport/over/'.. id ..'_btn_over.dds'		-- Mouseover Icon
	local location3 = '/mods/Reinforcement Manager/icons/firesupport/active/'.. id ..'_btn_down.dds'
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


