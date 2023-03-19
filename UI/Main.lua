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

local transpath = '/mods/Commander Survival Kit/UI/Transmissions/'
local atranspath = '/mods/Commander Survival Kit/UI/Transmissions/Aeon/'
local ctranspath = '/mods/Commander Survival Kit/UI/Transmissions/Cybran/'
local ttranspath = '/mods/Commander Survival Kit/UI/Transmissions/UEF/'
local stranspath = '/mods/Commander Survival Kit/UI/Transmissions/Seraphim/'
local ntranspath = '/mods/Commander Survival Kit/UI/Transmissions/Nomads/'


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
local FSNUI = import(path .. 'FireSupportManager.lua').FSNUI
local FSMissileUI = import(path .. 'FireSupportManager.lua').FSMissileUI
local FSSpaceUI = import(path .. 'FireSupportManager.lua').FSSpaceUI
local FSRFUI = import(path .. 'FireSupportManager.lua').FSRFUI
local FSBUI = import(path .. 'FireSupportManager.lua').FSBUI
local FSSPUI = import(path .. 'FireSupportManager.lua').FSSPUI
local FSDUI = import(path .. 'FireSupportManager.lua').FSDUI
local ACTransmissionUI = import(atranspath .. 'AComingTransmission.lua').UI
local AETransmissionUI = import(atranspath .. 'AEndingTransmission.lua').UI
local CCTransmissionUI = import(ctranspath .. 'CComingTransmission.lua').UI
local CETransmissionUI = import(ctranspath .. 'CEndingTransmission.lua').UI
local TCTransmissionUI = import(ttranspath .. 'TComingTransmission.lua').UI
local TETransmissionUI = import(ttranspath .. 'TEndingTransmission.lua').UI
local SCTransmissionUI = import(stranspath .. 'SComingTransmission.lua').UI
local SETransmissionUI = import(stranspath .. 'SEndingTransmission.lua').UI
local ATransmissionUI = import(atranspath .. 'ATransmission1.lua').UI
local CTransmissionUI = import(ctranspath .. 'CTransmission1.lua').UI
local TTransmissionUI = import(ttranspath .. 'TTransmission1.lua').UI
local STransmissionUI = import(stranspath .. 'STransmission1.lua').UI

TimeSelectionUI = import(path .. 'TimeSelection.lua').UI
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
FSDUI:Hide()
FSUI:Hide()
FSNUI:Hide()
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
ATransmissionUI:Hide()
CTransmissionUI:Hide()
TTransmissionUI:Hide()
STransmissionUI:Hide()
ACTransmissionUI:Hide()
AETransmissionUI:Hide()
CCTransmissionUI:Hide()
CETransmissionUI:Hide()
TCTransmissionUI:Hide()
TETransmissionUI:Hide()
SCTransmissionUI:Hide()
SETransmissionUI:Hide()


		ForkThread(
		function()
if focusarmy >= 1 then
    if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			WaitSeconds(10) -- Generated Points per 3 Seconds

				ACTransmissionUI:Show()
				ACTransmissionUI._closeBtn:Hide()

			WaitSeconds(1)

				ACTransmissionUI:Hide()
				ATransmissionUI:Show()
				ATransmissionUI._closeBtn:Hide()
			WaitSeconds(10)

				ATransmissionUI:Hide()
				AETransmissionUI:Show()
				AETransmissionUI._closeBtn:Hide()
			WaitSeconds(1)
				AETransmissionUI:Hide()
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			WaitSeconds(10) -- Generated Points per 3 Seconds

				CCTransmissionUI:Show()
				CCTransmissionUI._closeBtn:Hide()

			WaitSeconds(1)

				CCTransmissionUI:Hide()
				CTransmissionUI:Show()
				CTransmissionUI._closeBtn:Hide()
			WaitSeconds(10)

				CTransmissionUI:Hide()
				CETransmissionUI:Show()
				CETransmissionUI._closeBtn:Hide()
			WaitSeconds(1)
				CETransmissionUI:Hide()
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			WaitSeconds(10) -- Generated Points per 3 Seconds

				TCTransmissionUI:Show()
				TCTransmissionUI._closeBtn:Hide()

			WaitSeconds(1)

				TCTransmissionUI:Hide()
				TTransmissionUI:Show()
				TTransmissionUI._closeBtn:Hide()
			WaitSeconds(10)

				TTransmissionUI:Hide()
				TETransmissionUI:Show()
				TETransmissionUI._closeBtn:Hide()
			WaitSeconds(1)
				TETransmissionUI:Hide()
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			WaitSeconds(10) -- Generated Points per 3 Seconds

				SCTransmissionUI:Show()
				SCTransmissionUI._closeBtn:Hide()

			WaitSeconds(1)

				SCTransmissionUI:Hide()
				STransmissionUI:Show()
				STransmissionUI._closeBtn:Hide()
			WaitSeconds(10)

				STransmissionUI:Hide()
				SETransmissionUI:Show()
				SETransmissionUI._closeBtn:Hide()
			WaitSeconds(1)
				SETransmissionUI:Hide()
	end
end
		end
		)

--TimeSelectionUI:Show()
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
		info:Hide()
		FSDUI:Hide()
		FWBTNUI:Hide()
		BBTNUI:Hide()
		FSUI:Hide()
		FSNUI:Hide()
		FSMissileUI:Hide()
		FSRFUI:Hide()
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
}

local fsforwardbuttonpress = 0
 local fsbackbuttonpress = 0
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
		info:Show()
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
		textboxUI:Hide()
		textbox:Hide()
		textbox2:Hide()
		FWBTNUI:Show()
		FWBTNUI._closeBtn:Hide()
		BBTNUI:Show()
		BBTNUI._closeBtn:Hide()
		FSDUI:Show()
		FSDUI._closeBtn:Hide()
		FSUI:Show()
		FSNUI:Show()
		FSMissileUI:Show()
		FSMissileUI._closeBtn:Hide()
		FSUI._closeBtn:Hide()
		FSNUI._closeBtn:Hide()
		fsheaderbox:Show()
		fsheaderbox._closeBtn:Hide()
		end
		if fsbuttonpress == 2 then
				info:Hide()
		FWBTNUI:Hide()
		BBTNUI:Hide()
		FSUI:Hide()
		FSNUI:Hide()
		FSMissileUI:Hide()
		FSRFUI:Hide()
		FSBUI:Hide()
		FSSPUI:Hide()
		FSDUI:Hide()
		fsheaderbox:Hide()
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
		info:Show()
		info._closeBtn:Show()
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
		info:Show()
		info._closeBtn:Show()
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
		info:Show()
		info._closeBtn:Show()
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

-- Switch Buttons for FS Manager

--#################################################################### 
 local ForwardButton = Class(Button){

    IconTextures = function(self, texture, texture2 ,texture3, texture4, path)
		self:SetTexture(texture)
		self.mNormal = texture 	-- texture
        self.mActive = texture4 	-- texture 4
        self.mHighlight = texture2 	-- texture 2
        self.mDisabled = texture3
		self.Depth:Set(10)
    end,
	
	OnClick = function(self, modifiers)
		fsforwardbuttonpress = fsforwardbuttonpress + 1
		if fsforwardbuttonpress == 1 then
		FSUI:Hide()
		FSNUI:Hide()
		FSMissileUI:Hide()
		FSRFUI:Show()
		FSBUI:Show()
		FSSPUI:Show()
		FSRFUI._closeBtn:Hide()
		FSBUI._closeBtn:Hide()
		FSSPUI._closeBtn:Hide()
		end
		if fsforwardbuttonpress == 2 then
		FSRFUI:Hide()
		FSBUI:Hide()
		FSSPUI:Hide()
		FSUI:Show()
		FSNUI:Show()
		FSMissileUI:Show()
		FSUI._closeBtn:Hide()
		FSNUI._closeBtn:Hide()
		FSMissileUI._closeBtn:Hide()
		fsforwardbuttonpress = 0
		end
		--[[
		if fsforwardbuttonpress == 2 then
		FSRFUI:Hide()
		FSBUI:Hide()
		FSSPUI:Hide()
		FSSpaceUI:Show()
		FSSpaceUI._closeBtn:Hide()
		end
		if fsforwardbuttonpress == 3 then
		FSSpaceUI:Hide()
		FSUI:Show()
		FSNUI:Show()
		FSMissileUI:Show()
		FSUI._closeBtn:Hide()
		FSNUI._closeBtn:Hide()
		FSMissileUI._closeBtn:Hide()
		fsforwardbuttonpress = 0
		end
		--]]
	end
}

 local BackButton = Class(Button){

    IconTextures = function(self, texture, texture2 ,texture3, texture4, path)
		self:SetTexture(texture)
		self.mNormal = texture 	-- texture
        self.mActive = texture4 	-- texture 4
        self.mHighlight = texture2 	-- texture 2
        self.mDisabled = texture3
		self.Depth:Set(10)
    end,
	
	OnClick = function(self, modifiers)
		fsbackbuttonpress = fsbackbuttonpress + 1
		--[[
		if fsbackbuttonpress == 1 then
		FSUI:Hide()
		FSNUI:Hide()
		FSMissileUI:Hide()
		FSSpaceUI:Show()
		FSSpaceUI._closeBtn:Hide()
		end
		
		if fsbackbuttonpress == 2 then
		FSSpaceUI:Hide()
		FSRFUI:Show()
		FSBUI:Show()
		FSSPUI:Show()
		FSRFUI._closeBtn:Hide()
		FSBUI._closeBtn:Hide()
		FSSPUI._closeBtn:Hide()
		end
		if fsbackbuttonpress == 3 then
		FSRFUI:Hide()
		FSBUI:Hide()
		FSSPUI:Hide()
		FSUI:Show()
		FSNUI:Show()
		FSMissileUI:Show()
		FSUI._closeBtn:Hide()
		FSNUI._closeBtn:Hide()
		FSMissileUI._closeBtn:Hide()
		fsbackbuttonpress = 0
		end
		]]--
		
		if fsbackbuttonpress == 1 then
		FSUI:Hide()
		FSNUI:Hide()
		FSMissileUI:Hide()
		FSRFUI:Show()
		FSBUI:Show()
		FSSPUI:Show()
		FSRFUI._closeBtn:Hide()
		FSBUI._closeBtn:Hide()
		FSSPUI._closeBtn:Hide()
		end
		if fsbackbuttonpress == 2 then
		FSRFUI:Hide()
		FSBUI:Hide()
		FSSPUI:Hide()
		FSUI:Show()
		FSNUI:Show()
		FSMissileUI:Show()
		FSUI._closeBtn:Hide()
		FSNUI._closeBtn:Hide()
		FSMissileUI._closeBtn:Hide()
		fsbackbuttonpress = 0
		end
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
			local location = '/mods/Commander Survival Kit/buttons/Switch Buttons/Aeon/Forward.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Aeon/Forward active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Aeon/Forward deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Aeon/Forward hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Switch Buttons/Cybran/Forward.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Cybran/Forward active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Cybran/Forward deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Cybran/Forward hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Switch Buttons/UEF/Forward.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Switch Buttons/UEF/Forward active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Switch Buttons/UEF/Forward deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Switch Buttons/UEF/Forward hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			LOG('Faction is Seraphim', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Switch Buttons/Seraphim/Forward.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Seraphim/Forward active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Seraphim/Forward deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Seraphim/Forward hover.dds'
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
			local location = '/mods/Commander Survival Kit/buttons/Switch Buttons/Aeon/Back.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Aeon/Back active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Aeon/Back deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Aeon/Back hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
			LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Switch Buttons/Cybran/Back.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Cybran/Back active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Cybran/Back deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Cybran/Back hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
			LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Switch Buttons/UEF/Back.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Switch Buttons/UEF/Back active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Switch Buttons/UEF/Back deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Switch Buttons/UEF/Back hover.dds'
			ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
			LOG('Faction is Seraphim', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			local location = '/mods/Commander Survival Kit/buttons/Switch Buttons/Seraphim/Back.dds'
			local location2 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Seraphim/Back active.dds'
			local location3 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Seraphim/Back deactive.dds'
			local location4 = '/mods/Commander Survival Kit/buttons/Switch Buttons/Seraphim/Back hover.dds'
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
	local location = '/mods/Commander Survival Kit/buttons/reinforcement_btn_up.dds'
	local location2 = '/mods/Commander Survival Kit/buttons/reinforcement_btn_over.dds'
	local location3 = '/mods/Commander Survival Kit/buttons/reinforcement_btn_dis.dds'
	local location4 = '/mods/Commander Survival Kit/buttons/reinforcement_btn_down.dds'
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
end


local function increasedRBTNBorder(ui, scale)
	ui.Top:Set(ui.Top[1] - scale -15)
	ui.Left:Set(ui.Left[1] - scale - 4)
	ui.Right:Set(ui.Right[1] + scale + 5)
	ui.Bottom:Set(ui.Bottom[1] + scale - 5)
end
	
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
	local location = '/mods/Commander Survival Kit/buttons/firesupport_btn_up.dds'
	local location2 = '/mods/Commander Survival Kit/buttons/firesupport_btn_over.dds'
	local location3 = '/mods/Commander Survival Kit/buttons/firesupport_btn_dis.dds'
	local location4 = '/mods/Commander Survival Kit/buttons/firesupport_btn_down.dds'
	ui:IconTextures(UIFile(location, true), UIFile(location2, true), UIFile(location3, true), UIFile(location4, true),path)
end


local function increasedFSBTNBorder(ui, scale)
	ui.Top:Set(ui.Top[1] - scale -15)
	ui.Left:Set(ui.Left[1] - scale - 4)
	ui.Right:Set(ui.Right[1] + scale + 5)
	ui.Bottom:Set(ui.Bottom[1] + scale - 5)
end
	
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






