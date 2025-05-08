--[[

Modified Unitview.lua for Vanilla and FAF with an new Panel to display the current and maximum amount of Ammunition.
However the Panel doesn't display the amount individual for each Unit by their own. 

]]--



local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 



local MyUnitIdTable = {

 -- New Units
 
 -- Aeon
 
  -- Land
  	cskaal0100=true,
 	cskaal0200=true,
	cskaal0300=true,
	
	cskaaltest01=true,
 
 -- Structures
	  --uab8500=true, 
 
 -- UEF
   
 -- Land
  	cskatl0100=true,
 	cskatl0200=true,
	cskatl0300=true,
	
	cskatltest01=true,
   
-- Structures	  
	  
-- Cybran

  -- Land
  	cskacl0100=true,
 	cskacl0200=true,
	cskacl0300=true,
	
	cskacltest01=true,

-- Structures

	  
 -- Seraphim
 
 -- Structures

}


local IconPath = "/Mods/Commander Survival Kit Ammunition"
	local oldUpdateWindow = UpdateWindow
	function UpdateWindow(info)
		oldUpdateWindow(info)
		if MyUnitIdTable[info.blueprintId] then
			controls.icon:SetTexture(IconPath .. '/icons/units/' .. info.blueprintId .. '_icon.dds')
		end
		
		local techLevel = false
        local levels = {TECH1 = 1,TECH2 = 2,TECH3 = 3, ELITE = 35, TITAN = 5, HERO = 6}
		local bp = __blueprints[info.blueprintId]
		local description = LOC(bp.Description)
        for i, v in bp.Categories do
            if levels[v] then
                techLevel = levels[v]
                break
            end
		end	
	
	
		if techLevel == false then
		description = LOCF("%s", bp.Description)
		else
	
	    if techLevel == 35 then
            description = LOCF("Elite %s", bp.Description)
		elseif techLevel == 5 then
			description = LOCF("Titan %s", bp.Description)
		elseif techLevel == 6 then
			description = LOCF("Hero %s", bp.Description)
		else
		description = LOCF("Tech %d %s", techLevel, bp.Description)
        end
		end
		
		if info.customName then
            controls.name:SetText(LOCF('%s: %s', info.customName, description))
        elseif bp.General.UnitName then
            controls.name:SetText(LOCF('%s: %s', bp.General.UnitName, description))
        else
            controls.name:SetText(LOCF('%s', description))
        end
		if controls.name:GetStringAdvance(controls.name:GetText()) > controls.name.Width() then
            LayoutHelpers.AtTopIn(controls.name, controls.bg, 14)
            controls.name:SetFont(UIUtil.bodyFont, 10)
        end
        for index = 1, 6 do
            local i = index
            if statFuncs[i](info, bp) then
                if i == 1 then
                    local value, iconType, color = statFuncs[i](info, bp)
                    controls.statGroups[i].color:SetSolidColor(color)
                    controls.statGroups[i].icon:SetTexture(iconType)
                    controls.statGroups[i].value:SetText(value)
                elseif i == 4 then
                    local text, iconType = statFuncs[i](info, bp)
                    controls.statGroups[i].value:SetText(text)
                    if iconType == 'strategic' then
                        controls.statGroups[i].icon:SetTexture(UIUtil.UIFile('/game/unit_view_icons/missiles.dds'))
                    elseif iconType == 'attached' then
                        controls.statGroups[i].icon:SetTexture(UIUtil.UIFile('/game/unit_view_icons/attached.dds'))
                    else
                        controls.statGroups[i].icon:SetTexture(UIUtil.UIFile('/game/unit_view_icons/tactical.dds'))
                    end
                else
                    controls.statGroups[i].value:SetText(statFuncs[i](info, bp))
                end
                controls.statGroups[i].icon:Show()
            else
                controls.statGroups[i].icon:Hide()
                if controls.statGroups[i].color then
                    controls.statGroups[i].color:SetSolidColor('00000000')
                end
            end
        end
        
        controls.shieldBar:Hide()
        controls.fuelBar:Hide()

        if info.shieldRatio > 0 then
            controls.shieldBar:Show()
            controls.shieldBar:SetValue(info.shieldRatio)
        end
        
        if info.fuelRatio > 0 then
            controls.fuelBar:Show()
            controls.fuelBar:SetValue(info.fuelRatio)
        end

        if info.health then
            controls.healthBar:Show()
            controls.healthBar:SetValue(info.health/info.maxHealth)
            if info.health/info.maxHealth > .75 then
                controls.healthBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_green.dds'))
            elseif info.health/info.maxHealth > .25 then
                controls.healthBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_yellow.dds'))
            else
                controls.healthBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_red.dds'))
            end
            controls.health:SetText(string.format("%d / %d", info.health, info.maxHealth))
        else
            controls.healthBar:Hide()
        end
        local veterancyLevels = bp.Veteran or veterancyDefaults
        for index = 1, 5 do
            local i = index
            if info.kills >= veterancyLevels[string.format('Level%d', i)] then
                controls.vetIcons[i]:Show()
                controls.vetIcons[i]:SetTexture(UIUtil.UIFile(Factions.Factions[Factions.FactionIndexMap[string.lower(bp.General.FactionName)]].VeteranIcon))
            else
                controls.vetIcons[i]:Hide()
            end
        end
        local unitQueue = false
        if info.userUnit then
            unitQueue = info.userUnit:GetCommandQueue()
        end
        if info.focus then
            if DiskGetFileInfo('/textures/ui/common/icons/units/'..info.focus.blueprintId..'_icon.dds') then
                controls.actionIcon:SetTexture('/textures/ui/common/icons/units/'..info.focus.blueprintId..'_icon.dds')
            else
                controls.actionIcon:SetTexture('/textures/ui/common/game/unit_view_icons/unidentified.dds')
            end
            if info.focus.health and info.focus.maxHealth then
                controls.actionText:SetFont(UIUtil.bodyFont, 14)
                controls.actionText:SetText(string.format('%d%%', (info.focus.health / info.focus.maxHealth) * 100))
            elseif queueTextures[unitQueue[1].type] then
                controls.actionText:SetFont(UIUtil.bodyFont, 10)
                controls.actionText:SetText(LOC(queueTextures[unitQueue[1].type].text))
            else
                controls.actionText:SetText('')
            end
            controls.actionIcon:Show()
            controls.actionText:Show()
        elseif info.focusUpgrade then
            controls.actionIcon:SetTexture(queueTextures.Upgrade.texture)
            controls.actionText:SetFont(UIUtil.bodyFont, 14)
            controls.actionText:SetText(string.format('%d%%', info.workProgress * 100))
            controls.actionIcon:Show()
            controls.actionText:Show()
        elseif info.userUnit and queueTextures[unitQueue[1].type] and not info.userUnit:IsInCategory('FACTORY') then
            controls.actionText:SetFont(UIUtil.bodyFont, 10)
            controls.actionText:SetText(LOC(queueTextures[unitQueue[1].type].text))
            controls.actionIcon:SetTexture(queueTextures[unitQueue[1].type].texture)
            controls.actionIcon:Show()
            controls.actionText:Show()
        elseif info.userUnit and info.userUnit:IsIdle() then
            controls.actionIcon:SetTexture(UIUtil.UIFile('/game/unit_view_icons/idle.dds'))
            controls.actionText:SetFont(UIUtil.bodyFont, 10)
            controls.actionText:SetText(LOC('<LOC _Idle>'))
            controls.actionIcon:Show()
            controls.actionText:Show()
        else    
            controls.actionIcon:Hide()
            controls.actionText:Hide()
        end
        
        if Prefs.GetOption('uvd_format') == 'full' and bp.Display.Abilities then
            local i = 1
            local maxWidth = 0
            local index = table.getn(bp.Display.Abilities)
            while bp.Display.Abilities[index] do
                if not controls.abilityText[i] then
                    controls.abilityText[i] = UIUtil.CreateText(controls.abilities, LOC(bp.Display.Abilities[index]), 12, UIUtil.bodyFont)
                    controls.abilityText[i]:DisableHitTest()
                    if i == 1 then
                        LayoutHelpers.AtLeftIn(controls.abilityText[i], controls.abilities)
                        LayoutHelpers.AtBottomIn(controls.abilityText[i], controls.abilities)
                    else
                        LayoutHelpers.Above(controls.abilityText[i], controls.abilityText[i-1])
                    end
                else
                    controls.abilityText[i]:SetText(LOC(bp.Display.Abilities[index]))
                end
                maxWidth = math.max(maxWidth, controls.abilityText[i].Width())
                index = index - 1
                i = i + 1
            end
            while controls.abilityText[i] do
                controls.abilityText[i]:Destroy()
                controls.abilityText[i] = nil
                i = i + 1
            end
            controls.abilities.Width:Set(maxWidth)
            controls.abilities.Height:Set(function() return controls.abilityText[1].Height() * table.getsize(controls.abilityText) end)
            if controls.abilities:IsHidden() then
                controls.abilities:Show()
            end
        elseif not controls.abilities:IsHidden() then
            controls.abilities:Hide()
        end
		if Prefs.GetOption('uvd_format') == 'full' and bp.Economy.Ammunition.CurrentAmmunition then
		local maxWidth = 0
            controls.ammunitionText:DisableHitTest()
			if bp.Economy.Ammunition.CurrentAmmunition then
			if Sync.CurrentAmmunition == nil then
			
			else
			LOG('Sync.CurrentAmmunition: ', Sync.CurrentAmmunition)
			controls.ammunitionText:SetText('')
			controls.ammunitionText:SetText(string.format('%d / %d', Sync.CurrentAmmunition, bp.Economy.Ammunition.MaxAmmunition))
			end
			end
			maxWidth = math.max(maxWidth, controls.ammunitionTitle.Width())
            controls.ammunition.Width:Set(maxWidth)
            controls.ammunition.Height:Set(15)
            if controls.ammunition:IsHidden() then
                controls.ammunition:Show()
            end
		elseif Prefs.GetOption('uvd_format') == 'full' and bp.Economy.Ammunition.AmmunitionStorage then
		local maxWidth = 0
            controls.ammunitionText:DisableHitTest()
			if bp.Economy.Ammunition.AmmunitionStorage then
			if Sync.CurrentAmmunitionStorage == nil then
			
			else
			LOG('Sync.CurrentAmmunitionStorage: ', Sync.CurrentAmmunitionStorage)
			controls.ammunitionText:SetText('')
			controls.ammunitionText:SetText(string.format('%d / %d', Sync.CurrentAmmunitionStorage, bp.Economy.Ammunition.MaxAmmunitionStorage))
			end
			end
			maxWidth = math.max(maxWidth, controls.ammunitionTitle.Width())
            controls.ammunition.Width:Set(maxWidth)
            controls.ammunition.Height:Set(15)
            if controls.ammunition:IsHidden() then
                controls.ammunition:Show()
            end	
        elseif not controls.ammunition:IsHidden() then
            controls.ammunition:Hide()
        end
	end
	
	function CreateUI()
    controls.bg = Bitmap(controls.parent)
    controls.bracket = Bitmap(controls.bg)
    controls.name = UIUtil.CreateText(controls.bg, '', 14, UIUtil.bodyFont)
    controls.icon = Bitmap(controls.bg)
    controls.stratIcon = Bitmap(controls.bg)
    controls.vetIcons = {}
    for i = 1, 5 do
        controls.vetIcons[i] = Bitmap(controls.bg)
    end
    controls.healthBar = StatusBar(controls.bg, 0, 1, false, false, nil, nil, true)
    controls.shieldBar = StatusBar(controls.bg, 0, 1, false, false, nil, nil, true)
    controls.fuelBar = StatusBar(controls.bg, 0, 1, false, false, nil, nil, true)
    controls.health = UIUtil.CreateText(controls.healthBar, '', 14, UIUtil.bodyFont)
    controls.statGroups = {}
    for i = 1, 6 do
        controls.statGroups[i] = {}
        controls.statGroups[i].icon = Bitmap(controls.bg)
        controls.statGroups[i].value = UIUtil.CreateText(controls.statGroups[i].icon, '', 12, UIUtil.bodyFont)
        if i == 1 then
            controls.statGroups[i].color = Bitmap(controls.bg)
            LayoutHelpers.FillParent(controls.statGroups[i].color, controls.statGroups[i].icon)
            controls.statGroups[i].color.Depth:Set(function() return controls.statGroups[i].icon.Depth() - 1 end)
        end
    end
    controls.actionIcon = Bitmap(controls.bg)
    controls.actionText = UIUtil.CreateText(controls.bg, '', 14, UIUtil.bodyFont)
    
    controls.abilities = Group(controls.bg)
    controls.abilityText = {}
    controls.abilityBG = {}
    controls.abilityBG.TL = Bitmap(controls.abilities)
    controls.abilityBG.TR = Bitmap(controls.abilities)
    controls.abilityBG.TM = Bitmap(controls.abilities)
    controls.abilityBG.ML = Bitmap(controls.abilities)
    controls.abilityBG.MR = Bitmap(controls.abilities)
    controls.abilityBG.M = Bitmap(controls.abilities)
    controls.abilityBG.BL = Bitmap(controls.abilities)
    controls.abilityBG.BR = Bitmap(controls.abilities)
    controls.abilityBG.BM = Bitmap(controls.abilities)
	
	controls.ammunition = Group(controls.abilities)
	controls.ammunitionTitle = UIUtil.CreateText(controls.ammunition, 'Ammunition', 12, UIUtil.bodyFont)
    controls.ammunitionText = UIUtil.CreateText(controls.ammunition, '0/0', 12, UIUtil.bodyFont)
    controls.ammunitionBG = {}
    controls.ammunitionBG.TL = Bitmap(controls.ammunition)
    controls.ammunitionBG.TR = Bitmap(controls.ammunition)
    controls.ammunitionBG.TM = Bitmap(controls.ammunition)
    controls.ammunitionBG.ML = Bitmap(controls.ammunition)
    controls.ammunitionBG.MR = Bitmap(controls.ammunition)
    controls.ammunitionBG.M = Bitmap(controls.ammunition)
    controls.ammunitionBG.BL = Bitmap(controls.ammunition)
    controls.ammunitionBG.BR = Bitmap(controls.ammunition)
    controls.ammunitionBG.BM = Bitmap(controls.ammunition)
	
	
	LayoutHelpers.AtCenterIn(controls.ammunitionTitle, controls.ammunition)
	LayoutHelpers.AtCenterIn(controls.ammunitionText, controls.ammunition)
	LayoutHelpers.AtTopIn(controls.ammunitionTitle, controls.ammunition, -10)
    LayoutHelpers.AtTopIn(controls.ammunitionText, controls.ammunition, 5)
	LayoutHelpers.DepthOverParent(controls.ammunitionText, controls.ammunition, 10)
    LayoutHelpers.DepthOverParent(controls.ammunitionTitle, controls.ammunition, 10)
    controls.bg:DisableHitTest(true)
    
    controls.bg:SetNeedsFrameUpdate(true)
    controls.bg.OnFrame = function(self, delta)
        local info = GetRolloverInfo()
        if info then
            UpdateWindow(info)
            if self:GetAlpha() < 1 then
                self:SetAlpha(math.min(self:GetAlpha() + (delta*3), 1), true)
            end
            import(UIUtil.GetLayoutFilename('unitview')).PositionWindow()
        elseif self:GetAlpha() > 0 then
            self:SetAlpha(math.max(self:GetAlpha() - (delta*3), 0), true)
        end
    end
end

else

function CreateUI()
    controls.bg = Bitmap(controls.parent)
    controls.bracket = Bitmap(controls.bg)
    controls.name = UIUtil.CreateText(controls.bg, '', 14, UIUtil.bodyFont)
    controls.icon = Bitmap(controls.bg)
    controls.stratIcon = Bitmap(controls.bg)
    controls.vetIcons = {}
    for i = 1, 5 do
        controls.vetIcons[i] = Bitmap(controls.bg)
    end
    controls.healthBar = StatusBar(controls.bg, 0, 1, false, false, nil, nil, true)
    controls.shieldBar = StatusBar(controls.bg, 0, 1, false, false, nil, nil, true)
    controls.fuelBar = StatusBar(controls.bg, 0, 1, false, false, nil, nil, true)
    controls.health = UIUtil.CreateText(controls.healthBar, '', 14, UIUtil.bodyFont)
    controls.vetBar = StatusBar(controls.bg, 0, 1, false, false, nil, nil, true)
    controls.nextVet = UIUtil.CreateText(controls.vetBar, '', 10, UIUtil.bodyFont)
    controls.vetTitle = UIUtil.CreateText(controls.vetBar, 'Veterancy', 10, UIUtil.bodyFont)

    controls.ReclaimGroup = Group(controls.bg)
    -- controls.ReclaimGroup.Title = UIUtil.CreateText(controls.ReclaimGroup, 'Reclaimed', 10, UIUtil.bodyFont)
    controls.ReclaimGroup.Debug = Bitmap(controls.ReclaimGroup)
    controls.ReclaimGroup.MassIcon = Bitmap(controls.ReclaimGroup)
    controls.ReclaimGroup.EnergyIcon = Bitmap(controls.ReclaimGroup)
    controls.ReclaimGroup.MassText = UIUtil.CreateText(controls.ReclaimGroup, '0', 10, UIUtil.bodyFont)
    controls.ReclaimGroup.EnergyText = UIUtil.CreateText(controls.ReclaimGroup, '0', 10, UIUtil.bodyFont)
    -- controls.ReclaimGroup.MassReclaimed = UIUtil.CreateText(controls.ReclaimGroup, '0', 10, UIUtil.bodyFont)
    -- controls.ReclaimGroup.MassIcon = Bitmap(controls.ReclaimGroup)
    -- controls.ReclaimGroup.MassReclaimed = UIUtil.CreateText(controls.ReclaimGroup, '0', 10, UIUtil.bodyFont)

    controls.statGroups = {}
    for i = 1, table.getn(statFuncs) do
        controls.statGroups[i] = {}
        controls.statGroups[i].icon = Bitmap(controls.bg)
        controls.statGroups[i].value = UIUtil.CreateText(controls.statGroups[i].icon, '', 12, UIUtil.bodyFont)
        if i == 1 then
            controls.statGroups[i].color = Bitmap(controls.bg)
            LayoutHelpers.FillParent(controls.statGroups[i].color, controls.statGroups[i].icon)
            controls.statGroups[i].color.Depth:Set(function() return controls.statGroups[i].icon.Depth() - 1 end)
        end
    end
    controls.actionIcon = Bitmap(controls.bg)
    controls.actionText = UIUtil.CreateText(controls.bg, '', 14, UIUtil.bodyFont)

    controls.abilities = Group(controls.bg)
    controls.abilityText = {}

    controls.ammunition = Group(controls.abilities)
    controls.ammunitionText = UIUtil.CreateText(controls.ammunition, '0/0', 12, UIUtil.bodyFont)
	
	LayoutHelpers.AtLeftIn(controls.ammunitionText, controls.ammunition)
    LayoutHelpers.AtBottomIn(controls.ammunitionText, controls.ammunition)
	LayoutHelpers.DepthOverParent(controls.ammunitionText, controls.ammunition, 10)

    controls.bg:DisableHitTest(true)

    controls.bg:SetNeedsFrameUpdate(true)

    if options.gui_detailed_unitview ~= 0 then
        controls.shieldText = UIUtil.CreateText(controls.bg, '', 13, UIUtil.bodyFont)
    end

    controls.bg.OnFrame = function(self, delta)
        local info = GetRolloverInfo()
        if not info and selectedUnit and options.gui_enhanced_unitview ~= 0 then
            info = GetUnitRolloverInfo(selectedUnit)
        end

        if info and import("/lua/ui/game/unitviewdetail.lua").View:IsHidden() then
            UpdateWindow(info)
            if self:GetAlpha() < 1 then
                self:SetAlpha(1, true)
            end
            unitViewLayout.PositionWindow()
            unitViewLayout.UpdateStatusBars(controls)
        elseif self:GetAlpha() > 0 then
            self:SetAlpha(0, true)
        end
    end

    -- This section is for the small icons showing what active enhancements an ACU has
    controls.enhancements = {}
    controls.enhancements['RCH'] = Bitmap(controls.bg)
    controls.enhancements['Back'] = Bitmap(controls.bg)
    controls.enhancements['LCH'] = Bitmap(controls.bg)

    LayoutHelpers.AtLeftTopIn(controls.enhancements['RCH'], controls.bg, 10, -30)
    LayoutHelpers.AtLeftTopIn(controls.enhancements['Back'], controls.bg, 42, -30)
    LayoutHelpers.AtLeftTopIn(controls.enhancements['LCH'], controls.bg, 74, -30)
    CreateQueueGrid(controls.bg)
end

local oldUpdateWindow = UpdateWindow
function UpdateWindow(info)
		oldUpdateWindow(info)
	if info.blueprintId == 'unknown' then
        controls.name:SetText(LOC('<LOC rollover_0000>Unknown Unit'))
        controls.icon:SetTexture('/textures/ui/common/game/unit_view_icons/unidentified.dds')
        controls.stratIcon:SetTexture('/textures/ui/common/game/strategicicons/icon_structure_generic_selected.dds')
        for index = 1, table.getn(controls.statGroups) do
            local i = index
            controls.statGroups[i].icon:Hide()
            if controls.statGroups[i].color then
                controls.statGroups[i].color:SetSolidColor('00000000')
            end
            if controls.vetIcons[i] then
                controls.vetIcons[i]:Hide()
            end
        end
        controls.healthBar:Hide()
        controls.shieldBar:Hide()
        controls.fuelBar:Hide()
        controls.vetBar:Hide()
        controls.actionIcon:Hide()
        controls.actionText:Hide()
        controls.abilities:Hide()
		controls.ammunition:Hide()
        controls.ReclaimGroup:Hide()
    else
        local bp = __blueprints[info.blueprintId]
        local icon = '/icons/units/' .. (bp.BaseBlueprintId or bp.BlueprintId) .. '_icon.dds'
        if DiskGetFileInfo(UIUtil.UIFile(icon, true)) then
            controls.icon:SetTexture(UIUtil.UIFile(icon, true))
        else
            controls.icon:SetTexture('/textures/ui/common/game/unit_view_icons/unidentified.dds')
        end
        if DiskGetFileInfo('/textures/ui/common/game/strategicicons/' .. bp.StrategicIconName .. '_selected.dds') then
            controls.stratIcon:SetTexture('/textures/ui/common/game/strategicicons/' ..
                bp.StrategicIconName .. '_selected.dds')
        else
            controls.stratIcon:SetSolidColor('00000000')
        end
		
		local techLevel = false
        local levels = {TECH1 = 1,TECH2 = 2,TECH3 = 3, ELITE = 35, TITAN = 5, HERO = 6}
		local bp = __blueprints[info.blueprintId]
		local description = LOC(bp.Description)
        for i, v in bp.Categories do
            if levels[v] then
                techLevel = levels[v]
                break
            end
		end	
	
	
		if techLevel == false then
		description = LOCF("%s", bp.Description)
		else
	
	    if techLevel == 35 then
            description = LOCF("Elite %s", bp.Description)
		elseif techLevel == 5 then
			description = LOCF("Titan %s", bp.Description)
		elseif techLevel == 6 then
			description = LOCF("Hero %s", bp.Description)
		else
		description = LOCF("Tech %d %s", techLevel, bp.Description)
        end
		end
		
		if info.customName then
            controls.name:SetText(LOCF('%s: %s', info.customName, description))
        elseif bp.General.UnitName then
            controls.name:SetText(LOCF('%s: %s', bp.General.UnitName, description))
        else
            controls.name:SetText(LOCF('%s', description))
        end
		
		local scale = controls.name.Width() / controls.name.TextAdvance()
        if scale < 1 then
            LayoutHelpers.AtTopIn(controls.name, controls.bg, 10 / scale)
            controls.name:SetFont(UIUtil.bodyFont, 14 * scale)
        end
        for index = 1, table.getn(statFuncs) do
            local i = index
            if statFuncs[i](info, bp) then
                if i == 1 then
                    local value, iconType, color = statFuncs[i](info, bp)
                    controls.statGroups[i].color:SetSolidColor(color)
                    controls.statGroups[i].icon:SetTexture(iconType)
                    controls.statGroups[i].value:SetText(value)
                elseif i == 3 then
                    local value, iconType, color = statFuncs[i](info, bp)
                    controls.statGroups[i].value:SetText(value)
                    controls.statGroups[i].icon:SetTexture(UIUtil.UIFile(Factions.Factions[
                        Factions.FactionIndexMap[string.lower(bp.General.FactionName)] ].VeteranIcon))
                elseif i == 5 then
                    local text, iconType = statFuncs[i](info, bp)
                    controls.statGroups[i].value:SetText(text)
                    if iconType == 'strategic' then
                        controls.statGroups[i].icon:SetTexture(UIUtil.UIFile('/game/unit_view_icons/missiles.dds'))
                    elseif iconType == 'attached' then
                        controls.statGroups[i].icon:SetTexture(UIUtil.UIFile('/game/unit_view_icons/attached.dds'))
                    else
                        controls.statGroups[i].icon:SetTexture(UIUtil.UIFile('/game/unit_view_icons/tactical.dds'))
                    end
                else
                    controls.statGroups[i].value:SetText(statFuncs[i](info, bp))
                end
                controls.statGroups[i].icon:Show()
            else
                controls.statGroups[i].icon:Hide()
                if controls.statGroups[i].color then
                    controls.statGroups[i].color:SetSolidColor('00000000')
                end
            end
        end

        controls.fuelBar:Hide()
        controls.vetBar:Hide()
        controls.ReclaimGroup:Hide()

        if info.shieldRatio > 0 then
            controls.shieldBar:Show()
            controls.shieldBar:SetValue(info.shieldRatio)
        else
            controls.shieldBar:Hide()
        end

        if info.fuelRatio > 0 then
            controls.fuelBar:Show()
            controls.fuelBar:SetValue(info.fuelRatio)
        end

        if info.shieldRatio > 0 and info.fuelRatio > 0 then
            controls.store = 1
        else
            controls.store = 0
        end

        if info.health then
            controls.healthBar:Show()

            -- Removing a MaxHealth buff causes health > maxhealth until a damage event for some reason
            info.health = math.min(info.health, info.maxHealth)

            if not info.userUnit then
                unitHP[1] = info.health
                unitHP.blueprintId = info.blueprintId
            end

            controls.healthBar:SetValue(info.health / info.maxHealth)
            if info.health / info.maxHealth > .75 then
                controls.healthBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_green.dds'))
            elseif info.health / info.maxHealth > .25 then
                controls.healthBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_yellow.dds'))
            else
                controls.healthBar._bar:SetTexture(UIUtil.UIFile('/game/unit-build-over-panel/healthbar_red.dds'))
            end
            controls.health:SetText(string.format("%d / %d", info.health, info.maxHealth))
        else
            controls.healthBar:Hide()
        end

        -- always hide veterancy stars initially
        for i = 1, 5 do
            controls.vetIcons[i]:Hide()
        end

        -- Control the veterancy stars
        if info.entityId then
            local unit = GetUnitById(info.entityId)
            if unit then
                local blueprint = unit:GetBlueprint()

                if blueprint.VetEnabled then
                    local level = unit:GetStat('VetLevel', 0).Value
                    local experience = unit:GetStat('VetExperience', 0).Value

                    local progress, title
                    local lowerThreshold, upperThreshold
                    if level < 5 then
                        lowerThreshold = blueprint.VetThresholds[level] or 0
                        upperThreshold = blueprint.VetThresholds[level + 1]
                    end

                    -- show stars
                    for i = 1, 5 do
                        if level >= i then
                            controls.vetIcons[i]:Show()
                            controls.vetIcons[i]:SetTexture(UIUtil.UIFile(Factions.Factions[Factions.FactionIndexMap[string.lower(bp.General.FactionName)] ].VeteranIcon))
                        end
                    end

                    -- show veterancy to gain
                    if lowerThreshold then
                        title = 'Veterancy'
                        progress = (experience - lowerThreshold) / (upperThreshold - lowerThreshold)

                        local text = ''
                        if upperThreshold >= 1000000 then
                            text = string.format('%.2fM/%.2fM', experience / 1000000, upperThreshold / 1000000)
                        elseif upperThreshold >= 100000 then
                            text = string.format('%.0fK/%.0fK', experience / 1000, upperThreshold / 1000)
                        elseif upperThreshold >= 10000 then
                            text = string.format('%.1fK/%.1fK', experience / 1000, upperThreshold / 1000)
                        else
                            text = experience .. '/' .. string.format('%d', upperThreshold)
                        end
                        controls.nextVet:SetText(text)

                    -- show total experience
                    else
                        title = 'Mass killed'
                        progress = 1

                        local text
                        if experience >= 1000000 then
                            text = string.format('%.2fM', experience / 1000000)
                        elseif experience >= 100000 then
                            text = string.format('%.0fK', experience / 1000)
                        elseif experience >= 10000 then
                            text = string.format('%.1fK', experience / 1000)
                        else
                            text = experience
                        end
                        controls.nextVet:SetText(text)
                    end

                    -- always show it, regardless
                    controls.vetBar:Show()
                    controls.vetBar:SetValue(progress)
                    controls.vetTitle:SetText(title)

                -- show reclaim statistics
                else
                    local reclaimedMass, reclaimedEnergy
                    if unit then
                        reclaimedMass = unit:GetStat('ReclaimedMass').Value
                        reclaimedEnergy = unit:GetStat('ReclaimedEnergy').Value
                    end
                    if reclaimedMass or reclaimedEnergy then
                        controls.ReclaimGroup:Show()
                        controls.ReclaimGroup.MassText:SetText(tostring(reclaimedMass or 0))
                        controls.ReclaimGroup.EnergyText:SetText(tostring(reclaimedEnergy or 0))
                    end
                end
            end
        end

        local unitQueue = false
        if info.userUnit then
            unitQueue = info.userUnit:GetCommandQueue()
        end

        -- -- Build queue upon hovering of unit

        local always = Prefs.GetFieldFromCurrentProfile('options').gui_queue_on_hover_02 == 'always'
        local isObserver = GameMain.OriginalFocusArmy == -1 or GetFocusArmy() == -1
        local whenObserving = Prefs.GetFieldFromCurrentProfile('options').gui_queue_on_hover_02 == 'only-obs'

        if always or (whenObserving and isObserver) then
            if (info.userUnit ~= nil) and EntityCategoryContains(UpdateWindowShowQueueOfUnit, info.userUnit) and
                (info.userUnit ~= selectedUnit) then

                -- find the main factory we're using the queue of
                local mainFactory
                local factory = info.userUnit
                while true do
                    mainFactory = factory:GetGuardedEntity()
                    if mainFactory == nil then
                        break
                    end
                    factory = mainFactory
                end

                -- show that queue
                controls.queue.grid:UpdateQueue(PeekCurrentFactoryForQueueDisplay(factory))
            else
                controls.queue:Hide()
            end
        else
            controls.queue:Hide()
        end

        if info.focus then
            if DiskGetFileInfo(UIUtil.UIFile('/icons/units/' .. info.focus.blueprintId .. '_icon.dds', true)) then
                controls.actionIcon:SetTexture(UIUtil.UIFile('/icons/units/' .. info.focus.blueprintId .. '_icon.dds',
                    true))
            else
                controls.actionIcon:SetTexture('/textures/ui/common/game/unit_view_icons/unidentified.dds')
            end
            if info.focus.health and info.focus.maxHealth then
                controls.actionText:SetFont(UIUtil.bodyFont, 14)
                controls.actionText:SetText(string.format('%d%%', (info.focus.health / info.focus.maxHealth) * 100))
            elseif queueTextures[unitQueue[1].type] then
                controls.actionText:SetFont(UIUtil.bodyFont, 10)
                controls.actionText:SetText(LOC(queueTextures[unitQueue[1].type].text))
            else
                controls.actionText:SetText('')
            end
            controls.actionIcon:Show()
            controls.actionText:Show()
        elseif info.focusUpgrade then
            controls.actionIcon:SetTexture(queueTextures.Upgrade.texture)
            controls.actionText:SetFont(UIUtil.bodyFont, 14)
            controls.actionText:SetText(string.format('%d%%', info.workProgress * 100))
            controls.actionIcon:Show()
            controls.actionText:Show()
        elseif info.userUnit and queueTextures[unitQueue[1].type] and not info.userUnit:IsInCategory('FACTORY') then
            controls.actionText:SetFont(UIUtil.bodyFont, 10)
            controls.actionText:SetText(LOC(queueTextures[unitQueue[1].type].text))
            controls.actionIcon:SetTexture(queueTextures[unitQueue[1].type].texture)
            controls.actionIcon:Show()
            controls.actionText:Show()
        elseif info.userUnit and info.userUnit:IsIdle() then
            controls.actionIcon:SetTexture(UIUtil.UIFile('/game/unit_view_icons/idle.dds'))
            controls.actionText:SetFont(UIUtil.bodyFont, 10)
            controls.actionText:SetText(LOC('<LOC _Idle>'))
            controls.actionIcon:Show()
            controls.actionText:Show()
        else
            controls.actionIcon:Hide()
            controls.actionText:Hide()
        end

        local lines = nil
        if Prefs.GetOption('uvd_format') == 'full' then
            lines = {}
            --Get not autodetected abilities
            if bp.Display.Abilities then
                for _, id in bp.Display.Abilities do
                    local ability = unitviewDetail.ExtractAbilityFromString(id)
                    if not unitviewDetail.IsAbilityExist[ability] then
                        table.insert(lines, LOC(id))
                    end
                end
            end
            --Autodetect abilities
            for id, func in unitviewDetail.IsAbilityExist do
                if (id ~= 'ability_building') and (id ~= 'ability_repairs') and
                    (id ~= 'ability_reclaim') and (id ~= 'ability_capture') and func(bp) then
                    table.insert(lines, LOC('<LOC ' .. id .. '>'))
                end
            end
        end
        if lines and (not table.empty(lines)) then
            local i = 1
            local maxWidth = 0
            local index = table.getn(lines)
            while lines[index] do
                if not controls.abilityText[i] then
                    controls.abilityText[i] = UIUtil.CreateText(controls.abilities, lines[index], 12, UIUtil.bodyFont)
                    controls.abilityText[i]:DisableHitTest()
                    if i == 1 then
                        LayoutHelpers.AtLeftIn(controls.abilityText[i], controls.abilities)
                        LayoutHelpers.AtBottomIn(controls.abilityText[i], controls.abilities)
                    else
                        LayoutHelpers.Above(controls.abilityText[i], controls.abilityText[i - 1])
                    end
                else
                    controls.abilityText[i]:SetText(lines[index])
                end
                maxWidth = math.max(maxWidth, controls.abilityText[i].Width())
                index = index - 1
                i = i + 1
            end
            while controls.abilityText[i] do
                controls.abilityText[i]:Destroy()
                controls.abilityText[i] = nil
                i = i + 1
            end
            controls.abilities.Width:Set(maxWidth)
            controls.abilities.Height:Set(function() return controls.abilityText[1].Height() *
                table.getsize(controls.abilityText) end)
            if controls.abilities:IsHidden() then
                controls.abilities:Show()
            end
        elseif not controls.abilities:IsHidden() then
            controls.abilities:Hide()
        end
		if bp.Economy.Ammunition then
		local maxWidth = 0
            controls.ammunitionText:DisableHitTest()
			if bp.Economy.Ammunition.CurrentAmmunition then
			controls.ammunitionText:SetText(string.format('%d / %d', bp.Economy.Ammunition.CurrentAmmunition, bp.Economy.Ammunition.MaxAmmunition))
			else
			controls.ammunitionText:SetText(string.format('%d / %d', bp.Economy.Ammunition.AmmunitionStorage, bp.Economy.Ammunition.MaxAmmunitionStorage))
			end
			maxWidth = math.max(maxWidth, controls.ammunitionText.Width())
            controls.ammunition.Width:Set(maxWidth)
            controls.ammunition.Height:Set(controls.ammunitionText.Height())
            if controls.ammunition:IsHidden() then
                controls.ammunition:Show()
            end
        elseif not controls.ammunition:IsHidden() then
            controls.ammunition:Hide()
        end
    end
    if options.gui_enhanced_unitview ~= 0 then
        -- Replace fuel bar with progress bar
        if info.blueprintId ~= 'unknown' then
            controls.fuelBar:Hide()
            if info.workProgress > 0 then
                controls.fuelBar:Show()
                controls.fuelBar:SetValue(info.workProgress)
            end
        end
    end
    if options.gui_detailed_unitview ~= 0 then
        if info.blueprintId ~= 'unknown' then
            controls.shieldText:Hide()

            if info.userUnit ~= nil then
                local regen = info.userUnit:GetStat("HitpointsRegeneration", 0).Value or 0
                controls.health:SetText(string.format("%d / %d +%d/s", info.health, info.maxHealth, regen))
            end

            if info.shieldRatio > 0 then
                local getEnh = import("/lua/enhancementcommon.lua")
                local unitBp = info.userUnit:GetBlueprint()
                local shield = unitBp.Defense.Shield
                if not shield.ShieldMaxHealth then
                    shield = unitBp.Enhancements[getEnh.GetEnhancements(info.entityId).Back]
                end
                local shieldMaxHealth, shieldRegenRate = shield.ShieldMaxHealth or 0, shield.ShieldRegenRate or 0
                if shieldMaxHealth > 0 then
                    local shieldHealth = math.floor(shieldMaxHealth * info.shieldRatio)
                    local shieldText = string.format("%d / %d", shieldHealth, shieldMaxHealth)
                    if shieldRegenRate > 0 then
                        shieldText = shieldText .. string.format("+%d/s", shieldRegenRate)
                    end
                    if shieldMaxHealth > 0 then
                        controls.shieldText:Show()
                        if shieldRegenRate > 0 then
                            controls.shieldText:SetText(string.format("%d / %d +%d/s",
                                math.floor(shieldMaxHealth * info.shieldRatio), shieldMaxHealth, shieldRegenRate))
                        else
                            controls.shieldText:SetText(string.format("%d / %d",
                                math.floor(shieldMaxHealth * info.shieldRatio), shieldMaxHealth))
                        end
                    end
                end
            end
        end
    end

    UpdateEnhancementIcons(info)
	end
end 