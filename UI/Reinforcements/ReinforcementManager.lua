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

local path = '/mods/Reinforcement Manager/UI/Reinforcements/'
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local CreateWindow = import('/lua/maui/window.lua').Window
local CreateText = import('/lua/maui/text.lua').Text 
local Button = import('/lua/maui/button.lua').Button
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local GetClickPosition = import('/lua/ui/game/commandmode.lua').ClickListener
local textbox = import(path .. 'reminder.lua').Text
local textbox2 = import(path .. 'reminder.lua').Text2
local UIPing = import('/lua/ui/game/ping.lua')
local cmdMode = import('/lua/ui/game/commandmode.lua')
local factions = import('/lua/factions.lua').Factions
local GetFBPOPath = function() for i, mod in __active_mods do if mod.name == "(F.B.P.) Future Battlefield Pack: Orbital" then return mod.location end end end
local FBPOPath = GetFBPOPath()

local number = 0

local CreateButton = Class(Button){
    IconTextures = function(self, texture, path)
		self:SetTexture(texture)
		self.mNormal = texture 
        self.mActive = path .. 'dk.png'
        self.mHighlight = path .. 'hl.png'
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
				if number == 4 then
					WaitSeconds(60) -- Recharge Time for the next Reinforcement Wave
				else
				textbox:SetText('Is on the way')
				local ArrivalTime = 12
				local count = ArrivalTime
				local Arrivaltext = 'Arrival in: '
				for i=count,0,-1 do 
				LOG('i: ',i)				
				tostring(i)
				Arrivaltext = 'Arrival in: ' .. ArrivalTime .. ' Seconds'
				end
				textbox2:Show()
				textbox2:SetText(Arrivaltext)
				WaitSeconds(ArrivalTime) -- Set Arrival Time for the Unit
				SimCallback({Func = 'SpawnReinforcements',Args = {id = self.correspondedID, pos = position, yes = not flag, ArmyIndex = GetFocusArmy()}},true)
				number = number + 1
				textbox:SetText('Unit has arrived')
				textbox2:Hide()
				WaitSeconds(10)
				textbox:SetText('Awaiting Orders')
				LOG(number)
				end
			end
		)
	end

}




local UI
local existed = {}



local function SetBtnTextures(ui, id)
	local location = '/icons/units/' .. id .. '_icon.dds'
	ui:IconTextures(UIFile(location, true),path)
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
 

UI._closeBtn.OnClick = function(control)
	for k,v in UI.Images do
		if k and v then v:Destroy() end 
	end
end

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


