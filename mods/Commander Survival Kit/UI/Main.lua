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



local pointpath = '/mods/Commander Survival Kit/PointDefinition.lua'
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
local info = import(path .. 'info.lua').UI
local infoboxtext = import(path .. 'info.lua').Text
local infoboxtext2 = import(path .. 'info.lua').Text2
local infoboxtext3 = import(path .. 'info.lua').Text3
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
local refheaderbox = import(path .. 'refheader.lua').UI
local reftextboxUI = import(path .. 'refreminder.lua').UI
local reftextbox = import(path .. 'refreminder.lua').Text
local reftextbox2 = import(path .. 'refreminder.lua').Text2
local reftextbox3 = import(path .. 'refreminder.lua').Text3
local refheaderboxtext = import(path .. 'refheader.lua').Text
local refheaderboxtext2 = import(path .. 'refheader.lua').Text2
local RefLandUI = import(path .. 'LandReinforcementManager.lua').LandUI
local RefAirUI = import(path .. 'AirReinforcementManager.lua').UI
local RefSpaceUI = import(path .. 'SpaceReinforcementManager.lua').FBPOUI
local FSUI = import(path .. 'FireSupportManager.lua').FSUI
local FSMissileUI = import(path .. 'FireSupportManager.lua').FSMissileUI
local FSSpaceUI = import(path .. 'FireSupportManager.lua').FSSpaceUI
local FSBUI = import(path .. 'FireSupportManager.lua').FSBUI
local FSSPUI = import(path .. 'FireSupportManager.lua').FSSPUI
local FSDUI = import(path .. 'FireSupportManager.lua').FSDUI
local FSASUI = import(path .. 'FireSupportManager.lua').FSASUI
local FSAS1UI = import(path .. 'FireSupportManager.lua').FSAS1UI
local FSAS2UI = import(path .. 'FireSupportManager.lua').FSAS2UI
local FSAS3UI = import(path .. 'FireSupportManager.lua').FSAS3UI
local FS1UI = import(path .. 'FireSupportManager.lua').FS1UI
local FS2UI = import(path .. 'FireSupportManager.lua').FS2UI
local FS3UI = import(path .. 'FireSupportManager.lua').FS3UI
local FS1MissileUI = import(path .. 'FireSupportManager.lua').FS1MissileUI
local FS2MissileUI = import(path .. 'FireSupportManager.lua').FS2MissileUI
local FS3MissileUI = import(path .. 'FireSupportManager.lua').FS3MissileUI
local FSB1UI = import(path .. 'FireSupportManager.lua').FSB1UI
local FSB2UI = import(path .. 'FireSupportManager.lua').FSB2UI
local FSB3UI = import(path .. 'FireSupportManager.lua').FSB3UI
local FSSP1UI = import(path .. 'FireSupportManager.lua').FSSP1UI
local FSSP2UI = import(path .. 'FireSupportManager.lua').FSSP2UI
local FSSP3UI = import(path .. 'FireSupportManager.lua').FSSP3UI
local Tooltip = import("/lua/ui/game/tooltip.lua")
local helpcenter = import(path .. 'Helpcenter.lua').UI
local helpcentermovie = import(path .. 'HelpcenterMovie.lua').UI
local helpcentermovieoptions = import(path .. 'HelpcenterMovie.lua').OUI

local CreateTransmission = import(path .. 'CreateTransmission.lua')
local CreateTransmission = import(path .. 'CreateTransmission.lua').CreateTransmission


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
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()	
LOG('MapWidth: ', mapWidth)
LOG('MapHeigth: ', mapHeight)


--#################################################################### 

-- Hide UI Elements at Start

--#################################################################### 
FSASUI:Hide()
FSDUI:Hide()
FSUI:Hide()
FSSPUI:Hide()
FSBUI:Hide()
FSMissileUI:Hide()
RefSpaceUI:Hide()
RefAirUI:Hide()
RefLandUI:Hide()
textboxUI:Hide()
textbox:Hide()
headerbox:Hide()
headerboxtext:Hide()
headerboxtext2:Hide()
arrivalbox:Hide()
arrivalboxtext:Hide()
availablebox:Hide()
availableboxtext:Hide()
textbox2:Hide()
fsheaderbox:Hide()
fsheaderboxtext:Hide()
fsheaderboxtext2:Hide()
fstextboxUI:Hide()
fstextbox:Hide()
fstextbox2:Hide()
fstextbox3:Hide()
refheaderbox:Hide()
reftextboxUI:Hide()
reftextbox:Hide()
reftextbox2:Hide()
reftextbox3:Hide()
refheaderboxtext:Hide()
refheaderboxtext2:Hide()
helpcenter:Hide()
helpcentermovie:Hide()
helpcentermovieoptions:Hide()



--#################################################################### 

-- Transmissions

--#################################################################### 


local TPWaitTime = SessionGetScenarioInfo().Options.TacPoints
local RPWaitTime = SessionGetScenarioInfo().Options.RefPoints
local Text1
local Text2
local Text3
local Text4
local Text5

-- Transmission after the Start of the Game 
if focusarmy >= 1 then
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
		Text1 = "Rhiza:"
		Text2 = "Commander its good to hear you have arrived."
		Text3 = "Now prepare your Base for the upcoming Battle."
		Text4 = "We will transfer the points soon."
		Text5 = "Stay tuned for Updates --- Rhiza out."
		CreateTransmission(Text1, Text2, Text3, Text4, Text5)	
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		Text1 = "Brackman:"
		Text2 = "Commander its good to hear you have arrived."
		Text3 = "Now prepare your Base for the upcoming Battle."
		Text4 = "We will transfer the points soon. Oh yes"
		Text5 = "Stay tuned for new Parameters my Child."
		CreateTransmission(Text1, Text2, Text3, Text4, Text5)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		Text1 = "Command HQ:"
		Text2 = "Commander its good to hear you have arrived."
		Text3 = "Now prepare your Base for the upcoming Battle."
		Text4 = "We will transfer the points soon."
		Text5 = "Stay tuned for Updates --- Command HQ out."
		CreateTransmission(Text1, Text2, Text3, Text4, Text5)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		Text1 = "Oum-Eoshi (Translated):"
		Text2 = "Our Warrior has arrived very good."
		Text3 = "Now prepare your Base for the upcoming Battle."
		Text4 = "We will transfer the points soon."
		Text5 = "Stay tuned for Updates."
		CreateTransmission(Text1, Text2, Text3, Text4, Text5)
	end
end


if TPWaitTime != RPWaitTime or RPWaitTime != TPWaitTime then
	ForkThread(
		function()
			repeat	
				local MathFloor = math.floor
				local hours = MathFloor(GetGameTimeSeconds() / 3600)
				local Seconds = GetGameTimeSeconds() - hours * 3600
				WaitSeconds(1)
				if Seconds > TPWaitTime then
					if focusarmy >= 1 then
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
							Text1 = "Rhiza:"
							Text2 = "Regarding the tactical points."
							Text3 = "We've now started transferring the points."
							Text4 = "Collect and use them wisely."
							Text5 = "Good luck --- Rhiza out."
							CreateTransmission(Text1, Text2, Text3, Text4, Text5)	
							break
						end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
							Text1 = "Brackman:"
							Text2 = "Regarding the tactical points."
							Text3 = "We've now started transferring the points."
							Text4 = "Collect and use them wisely. Oh yes."
							Text5 = "For the freedom of the Symbionts!"
							CreateTransmission(Text1, Text2, Text3, Text4, Text5)
							break
						end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
							Text1 = "Command HQ:"
							Text2 = "Regarding the tactical points."
							Text3 = "We've now started transferring the points."
							Text4 = "Collect and use them wisely."
							Text5 = "Good Hunting --- Command HQ out."
							CreateTransmission(Text1, Text2, Text3, Text4, Text5)
							break
						end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
							Text1 = "Oum-Eoshi (Translated):"
							Text2 = "Regarding the tactical points."
							Text3 = "We've now started transferring the points."
							Text4 = "Collect and use them wisely."
							Text5 = "Fight smart and you will be rewarded."
							CreateTransmission(Text1, Text2, Text3, Text4, Text5)
							break
						end
					end
				end
			until(GetGameTimeSeconds() < 0)
		end
	)

	ForkThread(
		function()
			repeat	
				local MathFloor = math.floor
				local hours = MathFloor(GetGameTimeSeconds() / 3600)
				local Seconds = GetGameTimeSeconds() - hours * 3600
				WaitSeconds(1)
				--LOG(Seconds)
				if Seconds > RPWaitTime then
					if focusarmy >= 1 then
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
							Text1 = "Rhiza:"
							Text2 = "Regarding the reinforcement points."
							Text3 = "We've now started transferring the points."
							Text4 = "Collect and use them wisely."
							Text5 = "Good luck --- Rhiza out."
							CreateTransmission(Text1, Text2, Text3, Text4, Text5)	
							break
						end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
							Text1 = "Brackman:"
							Text2 = "Regarding the reinforcement points."
							Text3 = "We've now started transferring the points."
							Text4 = "Collect and use them wisely. Oh yes."
							Text5 = "For the freedom of the Symbionts!"
							CreateTransmission(Text1, Text2, Text3, Text4, Text5)
							break
						end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
							Text1 = "Command HQ:"
							Text2 = "Regarding the reinforcement points."
							Text3 = "We've now started transferring the points."
							Text4 = "Collect and use them wisely."
							Text5 = "Good Hunting --- Command HQ out."
							CreateTransmission(Text1, Text2, Text3, Text4, Text5)
							break
						end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
							Text1 = "Oum-Eoshi (Translated):"
							Text2 = "Regarding the reinforcement points."
							Text3 = "We've now started transferring the points."
							Text4 = "Collect and use them wisely."
							Text5 = "Fight smart and you will be rewarded."
							CreateTransmission(Text1, Text2, Text3, Text4, Text5)
							break
						end
					end
				end
			until(GetGameTimeSeconds() < 0)
		end
	)

end

if TPWaitTime == RPWaitTime then

	ForkThread(
		function()
			repeat	
				local MathFloor = math.floor
				local hours = MathFloor(GetGameTimeSeconds() / 3600)
				local Seconds = GetGameTimeSeconds() - hours * 3600
				WaitSeconds(1)
				--LOG(Seconds)
				--LOG("Selected Time: ", selectedtime)
				if Seconds > TPWaitTime and Seconds > RPWaitTime then
					if focusarmy >= 1 then
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
							Text1 = "Rhiza:"
							Text2 = "Regarding the two point systems."
							Text3 = "We've now started transferring the points."
							Text4 = "Collect and use them wisely."
							Text5 = "Good luck --- Rhiza out."
							CreateTransmission(Text1, Text2, Text3, Text4, Text5)	
							break
						end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
							Text1 = "Brackman:"
							Text2 = "Regarding the two point systems."
							Text3 = "We've now started transferring the points."
							Text4 = "Collect and use them wisely. Oh yes."
							Text5 = "For the freedom of the Symbionts!"
							CreateTransmission(Text1, Text2, Text3, Text4, Text5)
							break
						end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
							Text1 = "Command HQ:"
							Text2 = "Regarding the two point systems."
							Text3 = "We've now started transferring the points."
							Text4 = "Collect and use them wisely."
							Text5 = "Good Hunting --- Command HQ out."
							CreateTransmission(Text1, Text2, Text3, Text4, Text5)
							break
						end
						if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
							Text1 = "Oum-Eoshi (Translated):"
							Text2 = "Regarding the two point systems."
							Text3 = "We've now started transferring the points."
							Text4 = "Collect and use them wisely."
							Text5 = "Fight smart and you will be rewarded."
							CreateTransmission(Text1, Text2, Text3, Text4, Text5)
							break
						end
					end
				end
			until(GetGameTimeSeconds() < 0)
		end
	)

end


--#################################################################### 

-- Basic UI Definitions

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
   
--#################################################################### 

-- Toggle Buttons for both Managers

--#################################################################### 
		
 local buttonpress = 0
 local landbuttonpress = 0
 local airbuttonpress = 0
 local spacebuttonpress = 0
 local buttonlock = 0
 local emptystring = ''



local fsforwardbuttonpress = 0
 local fsbackbuttonpress = 0
 local fsbuttonpress = 0


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
		if FBPOPath then
		RefSpaceUI:Hide()
		end
		RefAirUI:Hide()
		headerbox:Hide()
		RefLandUI:Show()
		RefLandUI._closeBtn:Hide()
		refheaderbox:Show()
		refheaderboxtext:Show()
		refheaderboxtext2:Show()
		refheaderbox._closeBtn:Hide()
		info:Hide()
		info._closeBtn:Hide()
		end
		if landbuttonpress == 2 then
		if FBPOPath then
		RefSpaceUI:Hide()
		end
		RefAirUI:Hide()
		RefLandUI:Hide()
		refheaderbox:Hide()
		refheaderboxtext:Hide()
		refheaderboxtext2:Hide()
		headerbox:Hide()
		headerboxtext:Hide()
		headerboxtext2:Hide()
		info:Hide()
		infoboxtext:Hide()
		infoboxtext2:Hide()
		infoboxtext3:Hide()
		info._closeBtn:Hide()
		landbuttonpress = 0
		end
	end
}

Tooltip.AddButtonTooltip(LandButton, "LBtn", 1)

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
		refheaderbox:Hide()
		reftextboxUI:Hide()
		RefLandUI:Hide()
		if FBPOPath then
		RefSpaceUI:Hide()
		end
		RefAirUI:Show()
		RefAirUI._closeBtn:Hide()
		headerbox:Show()
		headerbox._closeBtn:Hide()
		refheaderboxtext:Show()
		refheaderboxtext2:Show()
		info:Hide()
		info._closeBtn:Hide()
		end
		if airbuttonpress == 2 then
				if FBPOPath then
		RefSpaceUI:Hide()
		end
				RefLandUI:Hide()
		RefAirUI:Hide()
		headerbox:Hide()
				refheaderbox:Hide()
		refheaderboxtext:Hide()
		refheaderboxtext2:Hide()
		textboxUI:Hide()
		reftextbox:Hide()
		reftextbox2:Hide()
		reftextbox3:Hide()
		info:Hide()
		infoboxtext:Hide()
		infoboxtext2:Hide()
		infoboxtext3:Hide()
		info._closeBtn:Hide()
		airbuttonpress = 0
		end
	end
}

Tooltip.AddButtonTooltip(AirButton, "ABtn", 1)

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
		refheaderbox:Hide()
		reftextboxUI:Hide()
		RefLandUI:Hide()
		RefAirUI:Hide()
		RefSpaceUI:Show()
		headerbox:Show()
		refheaderboxtext:Show()
		refheaderboxtext2:Show()
		RefSpaceUI._closeBtn:Hide()
		headerbox._closeBtn:Hide()
		textboxUI._closeBtn:Hide()
		info:Hide()
		info._closeBtn:Hide()
		end
		if spacebuttonpress == 2 then
		RefSpaceUI:Hide()
				RefLandUI:Hide()
		RefAirUI:Hide()
		headerbox:Hide()
				refheaderbox:Hide()
		refheaderboxtext:Hide()
		refheaderboxtext2:Hide()
		textboxUI:Hide()
		reftextbox:Hide()
		reftextbox2:Hide()
		reftextbox3:Hide()
		info:Hide()
		infoboxtext:Hide()
		infoboxtext2:Hide()
		infoboxtext3:Hide()
		info._closeBtn:Hide()
		spacebuttonpress = 0
		end
	end
}

Tooltip.AddButtonTooltip(SpaceButton, "SBtn", 1)

--#################################################################### 

-- Land Button Definitions

--#################################################################### 


existed = {}

local function SetLBtnTextures(ui)
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Layer Buttons/Aeon/Land.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Aeon/Land active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Aeon/Land deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Aeon/Land hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Layer Buttons/Cybran/Land.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Cybran/Land active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Cybran/Land deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Cybran/Land hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Layer Buttons/UEF/Land.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Layer Buttons/UEF/Land active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Layer Buttons/UEF/Land deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Layer Buttons/UEF/Land hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			LOG('Faction is Seraphim', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Layer Buttons/Seraphim/Land.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Seraphim/Land active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Seraphim/Land deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Seraphim/Land hover.dds'
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
			local location = '/mods/Commander Survival Kit/buttons/Layer Buttons/Aeon/Air.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Aeon/Air active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Aeon/Air deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Aeon/Air hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Layer Buttons/Cybran/Air.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Cybran/Air active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Cybran/Air deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Cybran/Air hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Layer Buttons/UEF/Air.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Layer Buttons/UEF/Air active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Layer Buttons/UEF/Air deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Layer Buttons/UEF/Air hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			LOG('Faction is Seraphim', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Layer Buttons/Seraphim/Air.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Seraphim/Air active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Seraphim/Air deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Seraphim/Air hover.dds'
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
			local location = '/mods/Commander Survival Kit/buttons/Layer Buttons/Aeon/Space.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Aeon/Space active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Aeon/Space deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Aeon/Space hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Layer Buttons/Cybran/Space.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Cybran/Space active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Cybran/Space deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Cybran/Space hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Layer Buttons/UEF/Space.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Layer Buttons/UEF/Space active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Layer Buttons/UEF/Space deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Layer Buttons/UEF/Space hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			LOG('Faction is Seraphim', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Layer Buttons/Seraphim/Space.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Seraphim/Space active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Seraphim/Space deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Layer Buttons/Seraphim/Space hover.dds'
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

-- Forward Button Definitions

--#################################################################### 

	
local FWBTNPosition = {
	Left = 230, 
	Top = 150, 
	Bottom = 220, 
	Right = 300
}  
----actions----
FWBTNUI = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Construction',Position,Border) 
local ForwardButton
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
ForwardButton = UIUtil.CreateButtonStd(FWBTNUI, '/mods/Commander Survival Kit/textures/aeon_fw_btn/aeon_fw', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
ForwardButton = UIUtil.CreateButtonStd(FWBTNUI, '/mods/Commander Survival Kit/textures/cybran_fw_btn/cybran_fw', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
ForwardButton = UIUtil.CreateButtonStd(FWBTNUI, '/mods/Commander Survival Kit/textures/uef_fw_btn/uef_fw', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
ForwardButton = UIUtil.CreateButtonStd(FWBTNUI, '/mods/Commander Survival Kit/textures/sera_fw_btn/sera_fw', nil, 11)
		end
	end	
LayoutHelpers.FillParentFixedBorder(ForwardButton, FWBTNUI, 5)
LayoutHelpers.DepthOverParent(ForwardButton, FWBTNUI, 10)
for i, v in FWBTNPosition do 
	FWBTNUI[i]:Set(v)
end

ForwardButton.OnClick = function(self)
		fsforwardbuttonpress = fsforwardbuttonpress + 1
		LOG(fsforwardbuttonpress)
		if fsforwardbuttonpress == 1 then
		FSASUI:Hide()
		FSUI:Show()
		FS1UI._closeBtn:Hide()
		FS2UI._closeBtn:Hide()
		FS3UI._closeBtn:Hide()
		FSUI._closeBtn:Hide()
		fsbackbuttonpress = 4
		end
		if fsforwardbuttonpress == 2 then
		FSUI:Hide()
		FSMissileUI:Show()
		FSMissileUI._closeBtn:Hide()
		FS1MissileUI._closeBtn:Hide()
		FS2MissileUI._closeBtn:Hide()
		FS3MissileUI._closeBtn:Hide()
		fsbackbuttonpress = 3
		end
		if fsforwardbuttonpress == 3 then
		FSMissileUI:Hide()
		FSBUI:Show()
		FSBUI._closeBtn:Hide()
		FSB1UI._closeBtn:Hide()
		FSB2UI._closeBtn:Hide()
		FSB3UI._closeBtn:Hide()
		fsbackbuttonpress = 2
		end
		if fsforwardbuttonpress == 4 then
		FSBUI:Hide()
		FSSPUI:Show()
		FSSPUI._closeBtn:Hide()
		FSSP1UI._closeBtn:Hide()
		FSSP2UI._closeBtn:Hide()
		FSSP3UI._closeBtn:Hide()
		fsbackbuttonpress = 1
		end
		if fsforwardbuttonpress == 5 then
		FSSPUI:Hide()
		FSASUI:Show()
		FSASUI._closeBtn:Hide()
		FSAS1UI._closeBtn:Hide()
		FSAS2UI._closeBtn:Hide()
		FSAS3UI._closeBtn:Hide()
		fsforwardbuttonpress = 0
		fsbackbuttonpress = 0
		end
end

Tooltip.AddButtonTooltip(ForwardButton, "FWBtn", 1)

FWBTNUI:Hide() 
FWBTNUI._closeBtn:Hide()

--#################################################################### 

-- Back Button Definitions

--#################################################################### 

	
local BBTNPosition = {
	Left = 160, 
	Top = 150, 
	Bottom = 220, 
	Right = 230
}  
----actions----
BBTNUI = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Construction',Position,Border) 

local BackButton
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
BackButton = UIUtil.CreateButtonStd(FWBTNUI, '/mods/Commander Survival Kit/textures/aeon_bb_btn/aeon_bb', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
BackButton = UIUtil.CreateButtonStd(FWBTNUI, '/mods/Commander Survival Kit/textures/cybran_bb_btn/cybran_bb', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
BackButton = UIUtil.CreateButtonStd(FWBTNUI, '/mods/Commander Survival Kit/textures/uef_bb_btn/uef_bb', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
BackButton = UIUtil.CreateButtonStd(FWBTNUI, '/mods/Commander Survival Kit/textures/sera_bb_btn/sera_bb', nil, 11)
		end
	end	
LayoutHelpers.FillParentFixedBorder(BackButton, BBTNUI, 5)
LayoutHelpers.DepthOverParent(BackButton, BBTNUI, 10)
for i, v in BBTNPosition do 
	BBTNUI[i]:Set(v)
end

BackButton.OnClick = function(self)
		fsbackbuttonpress = fsbackbuttonpress + 1
		if fsbackbuttonpress == 1 then
		FSASUI:Hide()
		FSSPUI:Show()
		FSSPUI._closeBtn:Hide()
		FSSP1UI._closeBtn:Hide()
		FSSP2UI._closeBtn:Hide()
		FSSP3UI._closeBtn:Hide()
		fsforwardbuttonpress = 4
		end
		if fsbackbuttonpress == 2 then
		FSSPUI:Hide()
		FSBUI:Show()
		FSBUI._closeBtn:Hide()
		FSB1UI._closeBtn:Hide()
		FSB2UI._closeBtn:Hide()
		FSB3UI._closeBtn:Hide()
		fsforwardbuttonpress = 3
		end
		if fsbackbuttonpress == 3 then
		FSBUI:Hide()
		FSMissileUI:Show()
		FSMissileUI._closeBtn:Hide()
		FS1MissileUI._closeBtn:Hide()
		FS2MissileUI._closeBtn:Hide()
		FS3MissileUI._closeBtn:Hide()
		fsforwardbuttonpress = 2
		end
		if fsbackbuttonpress == 4 then
		FSMissileUI:Hide()
		FSUI:Show()
		FS1UI._closeBtn:Hide()
		FS2UI._closeBtn:Hide()
		FS3UI._closeBtn:Hide()
		FSUI._closeBtn:Hide()
		fsforwardbuttonpress = 1
		end
		if fsbackbuttonpress == 5 then
		FSUI:Hide()
		FSASUI:Show()
		FSAS1UI._closeBtn:Hide()
		FSAS2UI._closeBtn:Hide()
		FSAS3UI._closeBtn:Hide()
		FSASUI._closeBtn:Hide()
		fsforwardbuttonpress = 0
		fsbackbuttonpress = 0
		end
end

Tooltip.AddButtonTooltip(BackButton, "BBtn", 1)

BBTNUI:Hide() 
BBTNUI._closeBtn:Hide()

--#################################################################### 

-- Reinforcement Button Definitions

--#################################################################### 

	
local RBTNPosition = {
	Left = 90, 
	Top = 150, 
	Bottom = 220, 
	Right = 160
}
   
----actions----
RBTNUI = CreateWindow(GetFrame(0),nil,nil,false,false,true,true,'Construction',Position,Border) 


local ReinforcementButton
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
ReinforcementButton = UIUtil.CreateButtonStd(RBTNUI, '/mods/Commander Survival Kit/textures/aeon_ref_btn/aeon_ref', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
ReinforcementButton = UIUtil.CreateButtonStd(RBTNUI, '/mods/Commander Survival Kit/textures/cybran_ref_btn/cybran_ref', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
ReinforcementButton = UIUtil.CreateButtonStd(RBTNUI, '/mods/Commander Survival Kit/textures/uef_ref_btn/uef_ref', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
ReinforcementButton = UIUtil.CreateButtonStd(RBTNUI, '/mods/Commander Survival Kit/textures/sera_ref_btn/sera_ref', nil, 11)
		end
	end	
LayoutHelpers.FillParentFixedBorder(ReinforcementButton, RBTNUI, 5)
LayoutHelpers.DepthOverParent(ReinforcementButton, RBTNUI, 10)

for i, v in RBTNPosition do 
	RBTNUI[i]:Set(v)
end

ReinforcementButton.OnClick = function(self)
		fsbuttonpress = 0
		buttonpress = buttonpress + 1
		if buttonpress == 1 then
		helpcenter:Hide()
		helpcentermovie:Hide()
		helpcentermovieoptions:Hide()
		info:Hide()
		FSASUI:Hide()
		FSDUI:Hide()
		FWBTNUI:Hide()
		BBTNUI:Hide()
		FSUI:Hide()
		FSMissileUI:Hide()
		FSBUI:Hide()
		FSSPUI:Hide()
		fsheaderbox:Hide()
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
		buttonpress = 0
		helpcenter:Hide()
		helpcentermovie:Hide()
		helpcentermovieoptions:Hide()
		if FBPOPath then
		SBTNUI:Hide()
		RefSpaceUI:Hide()
		end
		RefAirUI:Hide()
		RefLandUI:Hide()
		refheaderbox:Hide()
		LBTNUI:Hide()
		ABTNUI:Hide()
		headerbox:Hide()
		end		
end

Tooltip.AddButtonTooltip(ReinforcementButton, "RefBtn", 1)

RBTNUI._closeBtn:Hide()
RBTNUI.Images = {} 
	

--#################################################################### 

-- Fire Support Button Definitions
	
--#################################################################### 

local FSBTNPosition = {
	Left = 20, 
	Top = 150, 
	Bottom = 220, 
	Right = 90
}
   
----actions----
FSBTNUI = CreateWindow(GetFrame(0),nil,nil,nil,nil,true,true,'Construction',Position,Border) 

local FiresupportButton
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
FiresupportButton = UIUtil.CreateButtonStd(FSBTNUI, '/mods/Commander Survival Kit/textures/aeon_fs_btn/aeon_fs', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
FiresupportButton = UIUtil.CreateButtonStd(FSBTNUI, '/mods/Commander Survival Kit/textures/cybran_fs_btn/cybran_fs', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
FiresupportButton = UIUtil.CreateButtonStd(FSBTNUI, '/mods/Commander Survival Kit/textures/uef_fs_btn/uef_fs', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
FiresupportButton = UIUtil.CreateButtonStd(FSBTNUI, '/mods/Commander Survival Kit/textures/sera_fs_btn/sera_fs', nil, 11)
		end
	end	
LayoutHelpers.FillParentFixedBorder(FiresupportButton, FSBTNUI, 5)
LayoutHelpers.DepthOverParent(FiresupportButton, FSBTNUI, 10)

for i, v in FSBTNPosition do 
	FSBTNUI[i]:Set(v)
end

FiresupportButton.OnClick = function(self)
		landbuttonpress = 0
		airbuttonpress = 0
		spacebuttonpress = 0
		buttonpress = 0
		fsbuttonpress = fsbuttonpress + 1
		if fsbuttonpress == 1 then
		helpcenter:Hide()
		helpcentermovie:Hide()
		helpcentermovieoptions:Hide()
		info:Hide()
		if FBPOPath then
		SBTNUI:Hide()
		RefSpaceUI:Hide()
		end
		RefAirUI:Hide()
		RefLandUI:Hide()
		FSUI:Hide()
		FSMissileUI:Hide()
		FSBUI:Hide()
		FSSPUI:Hide()
		refheaderbox:Hide()
		LBTNUI:Hide()
		ABTNUI:Hide()
		headerbox:Hide()
		textboxUI:Hide()
		textbox:Hide()
		textbox2:Hide()
		FWBTNUI:Show()
		FWBTNUI._closeBtn:Hide()
		BBTNUI:Show()
		BBTNUI._closeBtn:Hide()
		FSDUI:Show()
		FSDUI._closeBtn:Hide()
		FSASUI:Show()
		FSASUI._closeBtn:Hide()
		FSAS1UI._closeBtn:Hide()
		FSAS2UI._closeBtn:Hide()
		FSAS3UI._closeBtn:Hide()
		fsheaderbox:Show()
		fsheaderbox._closeBtn:Hide()
		end
		if fsbuttonpress == 2 then
				info:Hide()
				helpcenter:Hide()
				helpcentermovie:Hide()
				helpcentermovieoptions:Hide()
		FWBTNUI:Hide()
		BBTNUI:Hide()
		FSASUI:Hide()
		FSUI:Hide()
		FSMissileUI:Hide()
		FSBUI:Hide()
		FSSPUI:Hide()
		FSDUI:Hide()
		fsheaderbox:Hide()
		fsforwardbuttonpress = 0
		fsbackbuttonpress = 0
		fsbuttonpress = 0
		end	
end

Tooltip.AddButtonTooltip(FiresupportButton, "FSBtn", 1)

FSBTNUI._closeBtn:Hide()
--FSPUI._closeBtn:Hide()

 
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

info._closeBtn.OnClick = function(control)
		info:Hide()
		infoboxtext:Hide()
		infoboxtext2:Hide()
		infoboxtext3:Hide()
end

helpcenter._closeBtn.OnClick = function(control)
		helpcenter:Hide()
end

helpcentermovie._closeBtn.OnClick = function(control)
		helpcentermovie:Hide()
end

helpcentermovieoptions._closeBtn.OnClick = function(control)
		helpcentermovieoptions:Hide()
end






