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
local Tooltip = import("/lua/ui/game/tooltip.lua")
local Button = import('/lua/maui/button.lua').Button
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local GetClickPosition = import('/lua/ui/game/commandmode.lua').ClickListener
local GetPause = import ('/lua/ui/game/tabs.lua').OnPause
local info = import(path .. 'info.lua').UI
local infoboxtext = import(path .. 'info.lua').Text
local infoboxtext2 = import(path .. 'info.lua').Text2
local infoboxtext3 = import(path .. 'info.lua').Text3
local Combo = import("/lua/ui/controls/combo.lua").Combo
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
CreateNavalButton = import(path .. 'ReinforcementButtons.lua').CreateNavalButton
linkup = import(path .. 'ReinforcementButtons.lua').linkup
SetBtnTextures = import(path .. 'ReinforcementButtons.lua').SetBtnTextures
arrayPosition = import(path .. 'ReinforcementButtons.lua').arrayPosition
navalarray = import(path .. 'ReinforcementButtons.lua').navalarray
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


local GetFBPOPath = function() for i, mod in __active_mods do if mod.FBPProjectModName == "FBP-Orbital" then return mod.location end end end
local FBPOPath = GetFBPOPath()


--#################################################################### 

-- Variable Definitions

--#################################################################### 
local Gametype = SessionGetScenarioInfo().type
local NavalRefCampaignOptions = {}

function GetNavalRefCampaignOptions(Array)
NavalRefCampaignOptions = Array
end

local ExperimentalReinforcements = SessionGetScenarioInfo().Options.EXPRef

local quantity = math.max(1, 1)
local mapsize = SessionGetScenarioInfo().size
local mapWidth = mapsize[1]
local mapHeight = mapsize[2]
LOG('MapWidth: ', mapWidth)
LOG('MapHeigth: ', mapHeight)



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

local Position2 = {
	Left = 35, 
	Top = 395, 
	Bottom = 665,
	Right = 235
}

local bButtonPosition = {
	Left = 270, 
	Top = 325, 
	Bottom = 345, 
	Right = 290
}

local fwButtonPosition = {
	Left = 290, 
	Top = 325, 
	Bottom = 345, 
	Right = 310
}


local existed = {}

local fwbuttonpress = 0
local bbuttonpress = 0

function Getfwbuttonpress(Value)
fwbuttonpress = Value
end

function Getbbbuttonpress(Value)
bbuttonpress = Value
end

NavalUI = CreateWindow(GetFrame(0),'<LOC AvailableUnits>Available Units',nil,false,false,true,true,'Reinforcements',Position,Border) 
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 

for i, v in Position do 
	NavalUI[i]:Set(v)
end

for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
NavalUI._closeBtn:Hide()
NavalUI.Images = {} 
		local focusarmy = GetFocusArmy()
        local armyInfo = GetArmiesTable()

	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
Text3 = CreateText(NavalUI)
Text3:SetFont('Arial',13) 
Text3:SetColor('FFbadbdb')
Text3:SetText('Origin:')
Text3.Depth:Set(30)
NavalRefSpawmFromCombo = Combo(NavalUI, 12, 5, false, nil, "UI_Tab_Rollover_01", "UI_Tab_Click_01")
NavalRefSpawmFromCombo:AddItems({'<LOC North>North', '<LOC East>East', '<LOC South>South', '<LOC West>West', '<LOC Random>Random'})
NavalRefSpawmFromCombo:SetItem(5)
LayoutHelpers.SetWidth(NavalRefSpawmFromCombo, 75)
LayoutHelpers.SetHeight(NavalRefSpawmFromCombo, 20)
LayoutHelpers.AtCenterIn(NavalRefSpawmFromCombo, NavalUI, -158, 95)
LayoutHelpers.DepthOverParent(NavalRefSpawmFromCombo, NavalUI, 10)

Tooltip.AddControlTooltip(NavalRefSpawmFromCombo, import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').NavalRefSpawmFromCombo)

NavalOriginComboTooltips = import('/mods/Commander Survival Kit/lua/AI/CustomAITooltips/CSKTooltips.lua').NavalOriginComboTooltips
Tooltip.AddComboTooltip(NavalRefSpawmFromCombo, NavalOriginComboTooltips)

CheckforNavalRefOrigin = function(value)	
    data = {
        From = GetFocusArmy(),
        To = -1,
        Name = "CheckforNavalRefOrigin",
        Args = {selection = value }
    }
    local QueryCb = function() end
    import('/lua/UserPlayerQuery.lua').Query( data, QueryCb) 


end

ForkThread(
function()
while true do
import('/mods/Commander Survival Kit/UI/ReinforcementButtons.lua').GetNavalRefOrigin(NavalRefSpawmFromCombo:GetItem())
CheckforNavalRefOrigin(NavalRefSpawmFromCombo:GetItem())
WaitSeconds(0.1)
end
end
)

local TextPosition3 = {
	Left = 190, 
	Top = 351, 
	Bottom = 371, 
	Right = 100
}

for k,v in TextPosition3 do
	Text3[k]:Set(v)
end
		

		else

			
		end	
	end	

ForkThread(
	function()
if Gametype == 'skirmish' then
if ExperimentalReinforcements == 1 then
CreateEXPNavalRef()
else
CreateNoEXPNavalRef()
end
elseif Gametype == 'campaign_coop' then
if ExperimentalReinforcements == 1 then
CreateEXPNavalRef()
else
CreateNoEXPNavalRef()
end
else
while true do
if NavalRefCampaignOptions == nil then

else

if NavalRefCampaignOptions[8] == 1 then
CreateEXPNavalRef()
break
elseif NavalRefCampaignOptions[8] == 2 then
CreateNoEXPNavalRef()
break
else

end
end
WaitSeconds(0.1)
end
end
end
)
		
		
CreateEXPNavalRef = function()
		
if FBPOPath then
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			
				fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "<", 13, -23, -88)

for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)

		
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.EXPERIMENTALNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.EXPERIMENTALNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 2 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 3 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

end	
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
							fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "<", 13, -23, -88)
for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)	

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)
		
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.EXPERIMENTALNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.EXPERIMENTALNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 2 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 3 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

end	
    end		
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
		
						fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "<", 13, -23, -88)
for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)

	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.EXPERIMENTALNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 2 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 3 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

end			

    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
							fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "<", 13, -23, -88)

for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)

	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.EXPERIMENTALNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.EXPERIMENTALNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 2 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 3 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end
    end	
	    end
	LOG('Active')
else
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			
				fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "<", 13, -23, -88)

for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)

		
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.EXPERIMENTALNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.EXPERIMENTALNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 2 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 3 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

end	
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
							fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "<", 13, -23, -88)
for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)	

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)
		
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.EXPERIMENTALNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.EXPERIMENTALNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 2 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 3 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

end	
    end		
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
		
						fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "<", 13, -23, -88)
for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)

	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.EXPERIMENTALNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.EXPERIMENTALNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 2 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 3 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

end			

    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
							fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "<", 13, -23, -88)

for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)

	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.EXPERIMENTALNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 3
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Experimental',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.EXPERIMENTALNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 2 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 3 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 4 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end
    end	
	    end
	LOG('Not Active')
end  
end
CreateNoEXPNavalRef = function()

if FBPOPath then
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			
				fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "<", 13, -23, -88)

for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)

		
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 2 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

end	
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
							fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "<", 13, -23, -88)
for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)	

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)
		
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 2 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

end	
    end		
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
		
						fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "<", 13, -23, -88)
for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)

	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 2 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

end			

    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
							fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "<", 13, -23, -88)

for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)

	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 2 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end
    end	
	    end
	LOG('Active')
else
	if focusarmy >= 1 then
        if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
			LOG('Faction is Aeon', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
			
				fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-aeon_btn/small-aeon', "<", 13, -23, -88)

for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)

		
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 2 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.AEON)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

end	
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		LOG('Faction is Cybran', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
							fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-cybran_btn/small-cybran', "<", 13, -23, -88)
for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)	

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)
		
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 2 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.CYBRAN)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

end	
    end		
			
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
		
						fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-uef_btn/small-uef', "<", 13, -23, -88)
for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)

	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 2 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.UEF)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

end			

    end		
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		LOG('Faction is UEF', factions[armyInfo.armiesTable[focusarmy].faction+1].Category)
							fwbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', ">", 13, -23, -88)
bbutton = UIUtil.CreateButtonStd(NavalUI, '/mods/Commander Survival Kit/textures/medium-seraphim_btn/small-seraphim', "<", 13, -23, -88)

for i,j in fwButtonPosition do
	fwbutton[i]:Set(j)
end
for i,j in bButtonPosition do
	bbutton[i]:Set(j)
end

LayoutHelpers.DepthOverParent(fwbutton, NavalUI, 10)
LayoutHelpers.DepthOverParent(bbutton, NavalUI, 10)

Tooltip.AddButtonTooltip(fwbutton, "TechFWBtn", 1)
Tooltip.AddButtonTooltip(bbutton, "TechBBtn", 1)

	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI,15)
	increasedBorder(NavalUI2,15)
	existed = {}

fwbutton.OnClick = function(self)
fwbuttonpress = fwbuttonpress + 1
LOG('fwbuttonpress: ', fwbuttonpress)
if fwbuttonpress == 1 then
bbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 2 then
bbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if fwbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end

bbutton.OnClick = function(self)
bbuttonpress = bbuttonpress + 1

if bbuttonpress == 1 then
fwbuttonpress = 2
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 3',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.HEAVYNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end


if bbuttonpress == 2 then
fwbuttonpress = 1
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 2',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.MEDIUMNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end

if bbuttonpress == 3 then
bbuttonpress = 0
fwbuttonpress = 0
NavalUI2:Destroy()
NavalUI2 = CreateWindow(NavalUI,'Tech 1',nil,false,false,true,true,'Reinforcements',Position,Border) 
for i, v in Position2 do 
	NavalUI2[i]:Set(v)
end
NavalUI2._closeBtn:Hide()
	for k,v in NavalUI.Images do
		if k and v then v:Destroy() end 
	end
				
	local data
	local Level0 = {}
	local Level1 = EntityCategoryGetUnitList(categories.LIGHTNAVALDROPCAPSULE * categories.SERAPHIM)
	for _,v in ipairs(Level1) do 
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
		local Text = CreateText(NavalUI2)
		Text:SetFont('Arial',11)
		Text:SetColor('ffFFFFFF')
		Text:SetText(PriceValue)
		Text.Depth:Set(30)
		NavalUI.Images[c] = CreateNavalButton(NavalUI2) 
		linkup(navalarray(arrayPosition(Position,existed,NavalUI2),x,NavalUI.Images[c],Text,existed),existed) 
		SetBtnTextures(NavalUI.Images[c],id) 
		NavalUI.Images[c].correspondedID = id
		LOG(table.getn(NavalUI.Images))
	end
	increasedBorder(NavalUI2,15)
	existed = {}
end
end
    end	
	    end
	LOG('Not Active')		
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




