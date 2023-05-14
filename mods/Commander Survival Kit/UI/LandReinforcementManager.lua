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
CreateLandButton = import(path .. 'ReinforcementButtons.lua').CreateLandButton
linkup = import(path .. 'ReinforcementButtons.lua').linkup
SetBtnTextures = import(path .. 'ReinforcementButtons.lua').SetBtnTextures
arrayPosition = import(path .. 'ReinforcementButtons.lua').arrayPosition
array = import(path .. 'ReinforcementButtons.lua').array
increasedBorder = import(path .. 'ReinforcementButtons.lua').increasedBorder
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
local fstext3 = 'Generation starts in: 5 Minutes'
local fstext4 = 'No available Points'
local fstext5 = 'Generation starts in:'
local fstext6 = '5 Minutes'
local reftext = '0/2500'
local reftext2 = 'Collected Points: 0/2500'
local reftext3 = 'Generation starts in: 5 Minutes'
local reftext4 = 'No available Points'
local reftext5 = 'Generation starts in:'
local reftext6 = '5 Minutes'
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
--refheaderboxtext:SetText(reftext2)
--refheaderboxtext2:SetText(reftext3)
reftextbox:SetText(reftext4)
reftextbox2:SetText(reftext5)
reftextbox3:SetText(reftext6)
info:Hide()
infoboxtext:Hide()
infoboxtext2:Hide()
infoboxtext3:Hide()


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
	Top = 370, 
	Bottom = 670,
	Right = 240
}

local existed = {}

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
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTDROPCAPSULE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMDROPCAPSULE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYDROPCAPSULE * categories.AEON)
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
		local bp = __blueprints[id]
		local Price = math.floor(bp.Economy.BuildCostMass)
		local PriceValue = tostring(Price)
		local Text = CreateText(LandUI)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],Text,existed),existed) 
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
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTDROPCAPSULE * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMDROPCAPSULE * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYDROPCAPSULE * categories.CYBRAN)
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
		local bp = __blueprints[id]
		local Price = math.floor(bp.Economy.BuildCostMass)
		local PriceValue = tostring(Price)
		local Text = CreateText(LandUI)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],Text,existed),existed) 
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
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTDROPCAPSULE * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMDROPCAPSULE * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYDROPCAPSULE * categories.UEF)
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
		local bp = __blueprints[id]
		local Price = math.floor(bp.Economy.BuildCostMass)
		local PriceValue = tostring(Price)
		local Text = CreateText(LandUI)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],Text,existed),existed) 
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
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTDROPCAPSULE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMDROPCAPSULE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYDROPCAPSULE * categories.SERAPHIM)
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
		local bp = __blueprints[id]
		local Price = math.floor(bp.Economy.BuildCostMass)
		local PriceValue = tostring(Price)
		local Text = CreateText(LandUI)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],Text,existed),existed) 
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
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTDROPCAPSULE * categories.AEON)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMDROPCAPSULE * categories.AEON)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYDROPCAPSULE * categories.AEON)
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
		local bp = __blueprints[id]
		local Price = math.floor(bp.Economy.BuildCostMass)
		local PriceValue = tostring(Price)
		local Text = CreateText(LandUI)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],Text,existed),existed) 
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
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTDROPCAPSULE * categories.CYBRAN)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMDROPCAPSULE * categories.CYBRAN)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYDROPCAPSULE * categories.CYBRAN)
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
		local bp = __blueprints[id]
		local Price = math.floor(bp.Economy.BuildCostMass)
		local PriceValue = tostring(Price)
		local Text = CreateText(LandUI)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],Text,existed),existed) 
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
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTDROPCAPSULE * categories.UEF)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMDROPCAPSULE * categories.UEF)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYDROPCAPSULE * categories.UEF)
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
		local bp = __blueprints[id]
		local Price = math.floor(bp.Economy.BuildCostMass)
		local PriceValue = tostring(Price)
		local Text = CreateText(LandUI)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],Text,existed),existed) 
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
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTDROPCAPSULE * categories.SERAPHIM)
	local Level2 = EntityCategoryGetUnitList(categories.MEDIUMDROPCAPSULE * categories.SERAPHIM)
	local Level3 = EntityCategoryGetUnitList(categories.HEAVYDROPCAPSULE * categories.SERAPHIM)
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
		local bp = __blueprints[id]
		local Price = math.floor(bp.Economy.BuildCostMass)
		local PriceValue = tostring(Price)
		local Text = CreateText(LandUI)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		LandUI.Images[c] = CreateLandButton(LandUI) 
		linkup(array(arrayPosition(Position,existed,LandUI),x,LandUI.Images[c],Text,existed),existed) 
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




