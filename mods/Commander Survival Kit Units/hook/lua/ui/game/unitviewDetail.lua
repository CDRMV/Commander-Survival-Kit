local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 
if DiskGetFileInfo('/lua/AI/CustomAIs_v2/ExtrasAI.lua') then
if import('/lua/AI/CustomAIs_v2/ExtrasAI.lua').AI.Name == 'AI Patch LOUD' then

local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Group = import('/lua/maui/group.lua').Group
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local GameCommon = import('/lua/ui/game/gamecommon.lua')
local ItemList = import('/lua/maui/itemlist.lua').ItemList
local Prefs = import('/lua/user/prefs.lua')
local UnitDescriptions = import('/lua/ui/help/unitdescription.lua').Description
local TitleCase = import('/lua/utilities.lua').LOUD_TitleCase

local __DMSI = false    --import('/mods/Domino_Mod_Support/lua/initialize.lua') or false

local enhancementSlotNames = {}

local LOUDFIND = string.find
local LOUDFORMAT = string.format
local LOUDFLOOR = math.floor
local LOUDUPPER = string.upper
local LOUDLOWER = string.lower
local LOUDSUB = string.sub

-- This function checks and converts Meters to Kilometers if the measurement (in meters) is >= 1000.
function LOUD_KiloCheck(aMeasurement)
	if aMeasurement >= 1000 then
		return LOUDFORMAT("%.2f", aMeasurement / 1000):gsub("%.?0+$", "") .. "km"
	else
		return tostring(aMeasurement) .. "m"
	end
end

-- This function checks and converts numbers to thousands if the number is >= 1000.
function LOUD_ThouCheck(aNumber)
	if aNumber >= 1000 then
		return LOUDFORMAT("%.1f", aNumber / 1000):gsub("%.?0+$", "") .. "K"
	else
		return tostring(aNumber)
	end
end

-- This function returns a formatted Fuel time value.
function LOUD_FuelCheck(aFuelTime)
	local minutes = LOUDFORMAT("%02.f", LOUDFLOOR(aFuelTime / 60)):gsub("%.?0+$", "")
	local seconds = LOUDFORMAT("%02.f", math.mod(aFuelTime, 60))
	
	return minutes..":"..seconds.."s"
end

-- This function checks and converts a speed value (o-grids per second) into a human-readable speed. (Meters/second)
function LOUD_SpeedCheck(aSpeed)
	return LOUDFORMAT("%.2f", aSpeed * 20):gsub("%.?0+$", "") .. "m/s"
end



-- if DMS is turned on --
if __DMSI then
    enhancementSlotNames = __DMSI.__DMod_EnhancementSlotNames
end

enhancementSlotNames.back = '<LOC uvd_0007>Back'
enhancementSlotNames.lch = '<LOC uvd_0008>LCH'
enhancementSlotNames.rch = '<LOC uvd_0009>RCH'

View = false
ViewState = "full"
MapView = false

function Contract()
	View:SetNeedsFrameUpdate(false)
	View:Hide()
end

function Expand()
	View:Show()
	View:SetNeedsFrameUpdate(true)
end

function GetTechLevelString(bp)
    if EntityCategoryContains(categories.TECH1, bp.BlueprintId) then
        return 1
    elseif EntityCategoryContains(categories.TECH2, bp.BlueprintId) then
        return 2
    elseif EntityCategoryContains(categories.TECH3, bp.BlueprintId) then
        return 3
    elseif EntityCategoryContains(categories.ELITE, bp.BlueprintId) then
        return 35
    elseif EntityCategoryContains(categories.EXPERIMENTAL, bp.BlueprintId) then
        return 4		
    elseif EntityCategoryContains(categories.TITAN, bp.BlueprintId) then
        return 5	
    elseif EntityCategoryContains(categories.HERO, bp.BlueprintId) then
        return 6			
    else
        return false
    end
end

-- Taken from Unitview.lua,
-- Instead of the original function which did this in a strange and long-winded process.
function FormatTime(seconds)
	return string.format("%02d:%02d", math.floor(seconds / 60), math.mod(seconds, 60))
end

function GetAbilityList(bp)
    local abilitiesList = {}

    return abilitiesList
end

function CheckFormat()
    if ViewState ~= Prefs.GetOption('uvd_format') then
        SetLayout()
    end
    if ViewState == "off" then
        return false
    else
        return true
    end
end

function ShowView( showUpKeep, enhancement, showecon, showShield )

	import('/lua/ui/game/unitview.lua').ShowROBox(false, false)
	
	View:Show()
    
    View.Hiding = false
	
	View.UpkeepGroup:SetHidden(not showUpKeep)
	
	View.BuildCostGroup:SetHidden(not showecon)
	View.UpkeepGroup:SetHidden(not showUpKeep)
	View.TimeStat:SetHidden(not showecon)
	View.HealthStat:SetHidden(not showecon)
	
	View.HealthStat:SetHidden(enhancement)
	
	View.ShieldStat:SetHidden(not showShield)
end

function ShowEnhancement( bp, bpID, iconID, iconPrefix, userUnit )

	if View and CheckFormat() then
    
        --LOG("*AI DEBUG ShowEnhancement")

		-- Name / Description
		-- View.UnitImg:SetTexture(UIUtil.UIFile(iconPrefix..'_btn_up.dds'))

		LayoutHelpers.AtTopIn(View.UnitShortDesc, View, 10)
		View.UnitShortDesc:SetFont(UIUtil.bodyFont, 14)

		local slotName = enhancementSlotNames[string.lower(bp.Slot)]
		slotName = slotName or bp.Slot

		if bp.Name ~= nil then
			View.UnitShortDesc:SetText(LOCF("%s: %s", bp.Name, slotName))
		else
			View.UnitShortDesc:SetText(LOC(slotName))
		end
		
		if View.UnitShortDesc:GetStringAdvance(View.UnitShortDesc:GetText()) > View.UnitShortDesc.Width() then
			LayoutHelpers.AtTopIn(View.UnitShortDesc, View, 14)
			View.UnitShortDesc:SetFont(UIUtil.bodyFont, 10)
		end

		local showecon = true
		local showAbilities = false
		local showUpKeep = false
		local time, energy, mass
		
		if bp.Icon ~= nil and not LOUDFIND(bp.Name, 'Remove') then
		
			time, energy, mass = import('/lua/game.lua').GetConstructEconomyModel(userUnit, bp)
			time = math.max(time, 1)

			local path = import('/lua/ui/game/construction.lua').GetEnhancementTextures(bpID, iconID)
			View.UnitImg:SetTexture(path)

			showUpKeep = DisplayResources(bp, time, energy, mass)
			View.TimeStat.Value:SetFont(UIUtil.bodyFont, 14)
			View.TimeStat.Value:SetText(string.format("%s", FormatTime(time)))
			
			if string.len(View.TimeStat.Value:GetText()) > 5 then
				View.TimeStat.Value:SetFont(UIUtil.bodyFont, 10)
			end
		else
			showecon = false
			
			if View.Description then
			
				View.Description:Hide()
				
				for i, v in View.Description.Value do
					v:SetText("")
				end
			end
		end

		if View.Description then
		
			local tempDescID = bpID.."-"..iconID
			
			if UnitDescriptions[tempDescID] and not LOUDFIND(bp.Name, 'Remove') then
			
				local tempDesc = LOC(UnitDescriptions[tempDescID])
				
				WrapAndPlaceText(nil, nil, nil, nil, nil, nil, tempDesc, View.Description)
			else
				WARN('No description found for unit: ', bpID, ' enhancement: ', iconID)
				
				View.Description:Hide()
				
				for i, v in View.Description.Value do
					v:SetText("")
				end
			end
		end

		local showShield = false
		
		if bp.ShieldMaxHealth then
			showShield = true
			View.ShieldStat.Value:SetText(bp.ShieldMaxHealth)
		end

		ShowView(showUpKeep, true, showecon, showShield)
		
		if time == 0 and energy == 0 and mass == 0 then
			View.BuildCostGroup:Hide()
			View.TimeStat:Hide()
		end
        
	elseif not View or not CheckFormat() then
    
		Hide()
        
	end
    
end

function WrapAndPlaceText(air, physics, intel, weapons, abilities, capCost, text, control)
	
	-- Create the table of text to be displayed once populated.
	local textLines = {}
	
	-- -1 so that no line color can change (As there won't be an index of -1),
	-- but only if there's no Air or Physics on the blueprint.
	local physics_line = -1
	local intel_line = -1
	local cap_line = -1
	
	if text ~= nil then
		textLines = import('/lua/maui/text.lua').WrapText(text, control.Value[1].Width(), function(text) 
			return control.Value[1]:GetStringAdvance(text) 
		end)
	end

	-- Keep a count of the Ability lines.
	local abilityLines = 0

	-- Check for abilities on the BP.
	if abilities ~= nil then

		local i = table.getn(abilities)

		if textLines[1] then
			table.insert(textLines, 1, "")
		end
		
		-- Insert each ability into the textLines table.
		while abilities[i] do
			table.insert(textLines, 1, LOC(abilities[i]))
			i = i - 1
		end
		
		--Update the count of Ability lines.
		abilityLines = table.getsize(abilities)
	end

	-- Inserts a blank line for readability.
	table.insert(textLines, "")

	-- Start point of the weapon lines.
	local weapon_start = table.getn(textLines)
	
	if weapons and not table.empty(weapons) then
		-- Import PhoenixMT's DPS Calculator script.
		doscript '/lua/PhxLib.lua'

		-- Used for comparing last weapon checked.
		local lastWeaponDmg = 0
		local lastWeaponDPS = 0
		local lastWeaponPPOF = 0
		local lastWeaponDoT = 0
		local lastWeaponDmgRad = 0
		local lastWeaponMinRad = 0
		local lastWeaponMaxRad = 0
		local lastWeaponROF = 0
		local lastWeaponFF = false
		local lastWeaponCF = false
		local lastWeaponTarget = ''
		local lastWeaponNukeInDmg = 0
		local lastWeaponNukeInRad = 0
		local lastWeaponNukeOutDmg = 0
		local lastWeaponNukeOutRad = 0
		local weaponText = ""
		
		-- BuffType.
		local bType = ""
		-- Weapon Category is checked to color lines, as well as checked for countermeasure weapons and differentiating the info displayed.
		local wepCategory = ""
		
		local dupWeaponCount = 1

		for i, weapon in weapons do
			-- Check for DummyWeapon Label (Used by Paragons for Range Rings).
			if not LOUDFIND(weapon.Label, 'Dummy') and not LOUDFIND(weapon.Label, 'Tractor') and not LOUDFIND(weapon.Label, 'Painter') then
				-- Check for RangeCategories.
				if weapon.RangeCategory ~= nil then
					if weapon.RangeCategory == 'UWRC_DirectFire' then
						wepCategory = "Direct"
					end
					if weapon.RangeCategory == 'UWRC_IndirectFire' then
						wepCategory = "Indirect"
					end
					if weapon.RangeCategory == 'UWRC_AntiAir' then
						wepCategory = "Anti Air"
					end
					if weapon.RangeCategory == 'UWRC_AntiNavy' then
						wepCategory = "Anti Navy"
					end
					if weapon.RangeCategory == 'UWRC_Countermeasure' then
						wepCategory = " Defense"
					end
				end
				
				-- Check for Death weapon labels
				if LOUDFIND(weapon.Label, 'Death') then
					wepCategory = "Volatile"
				end
				if weapon.Label == 'DeathImpact' then
					wepCategory = "Crash"
				end
				if weapon.Label == 'Suicide' then
					wepCategory = "Suicide"
				end
				
				-- These weapons have no RangeCategory, but do have Labels.
				if weapon.Label == 'Bomb' then
					wepCategory = "Indirect"
				end
				if weapon.Label == 'Torpedo' then
					wepCategory = "Anti Navy"
				end
				if weapon.Label == 'QuantumBeamGeneratorWeapon' then
					wepCategory = "Direct"
				end
				if weapon.Label == 'ChinGun' then
					wepCategory = "Direct"
				end
				if LOUDFIND(weapon.Label, 'Melee') then
					wepCategory = "Melee"
				end
				
				-- Check if we're a Nuke weapon by checking our InnerRingDamage, which all Nukes must have.
				if weapon.NukeInnerRingDamage > 0 then
					wepCategory = "Nuke"
				end
				
				-- Now categories are established, we check which category we ended up using.
				
				-- Check if it's a death weapon.
				if wepCategory == "Crash" or wepCategory == "Volatile" or wepCategory == "Suicide" then
					
					-- Start the weaponText string with the weapon category.
					weaponText = wepCategory
					
					-- Check DamageFriendly and concat.
					if weapon.CollideFriendly ~= false or weapon.DamageRadius > 0 then
						weaponText = (weaponText .. " (FF)")
					end
					
					-- Concat damage.
					weaponText = (weaponText .. " { Dmg: " .. LOUD_ThouCheck(weapon.Damage))
					
					-- Check DamageRadius and concat.
					if weapon.DamageRadius > 0 then
						weaponText = (weaponText .. ", AoE: " .. LOUD_KiloCheck(weapon.DamageRadius * 20))
					end

					-- Finish text line.
					weaponText = (weaponText .. " }")

					-- Insert death weapon text line.
					table.insert(textLines, weaponText)
					
				-- Check if it's a nuke weapon.
				elseif wepCategory == "Nuke" then
				
					-- Check if this nuke is a Death nuke.
					if LOUDFIND(weapon.Label, "Death") then
						wepCategory = "Volatile"
						weaponText = wepCategory
					else
						weaponText = wepCategory
					end
					
					-- Check DamageFriendly and Buffs
					if weapon.CollideFriendly ~= false or (weapon.NukeInnerRingRadius > 0 and weapon.DamageFriendly ~= false) or weapon.Buffs ~= nil then
						weaponText = (weaponText .. " (")
						if weapon.Buffs then
							for i, buff in weapon.Buffs do
								bType = buff.BuffType
								if i == 1 then
									weaponText = (weaponText .. bType)
								else
									weaponText = (weaponText .. ", " .. bType)
								end
							end
						end
						if weapon.CollideFriendly ~= false or (weapon.NukeInnerRingRadius > 0 and weapon.DamageFriendly ~= false) then
							if weapon.Buffs then
								weaponText = (weaponText .. ", FF")
							else
								weaponText = (weaponText .. "FF")
							end
						end
						weaponText = (weaponText .. ")")
					end
					
					weaponText = (weaponText .. " { Inner Dmg: " .. LOUD_ThouCheck(weapon.NukeInnerRingDamage) .. ", AoE: " .. LOUD_KiloCheck(weapon.NukeInnerRingRadius * 20) .. " | Outer Dmg: " .. LOUD_ThouCheck(weapon.NukeOuterRingDamage) .. ", AoE: " .. LOUD_KiloCheck(weapon.NukeOuterRingRadius * 20))
					
					-- Finish text lines.
					weaponText = (weaponText .. " }")

					if weapon.NukeInnerRingDamage == lastWeaponNukeInDmg and weapon.NukeInnerRingRadius == lastWeaponNukeInRad  and weapon.NukeOuterRingDamage == lastWeaponNukeOutDmg and weapon.NukeOuterRingRadius == lastWeaponNukeOutRad and weapon.DamageFriendly == lastWeaponFF then
						dupWeaponCount = dupWeaponCount + 1
						-- Remove the old lines, to insert the new ones with the updated weapon count.
						table.remove(textLines, table.getn(textLines))
						table.insert(textLines, LOUDFORMAT("%s (x%d)", weaponText, dupWeaponCount))
					else
						dupWeaponCount = 1
						-- Insert the textLine.
						table.insert(textLines, weaponText)
					end
				else
					-- Start the weaponText string if we do damage.
					if weapon.Damage > 0.01 then
						
						-- Start the weaponText string with the weapon category.
						weaponText = wepCategory
						
						-- Check DamageFriendly and Buffs
						if wepCategory ~= " Defense" and wepCategory ~= "Melee" then
							if weapon.CollideFriendly ~= false or (weapon.DamageRadius > 0 and weapon.DamageFriendly ~= false) or weapon.Buffs ~= nil then
								weaponText = (weaponText .. " (")
								if weapon.Buffs then
									for i, buff in weapon.Buffs do
										bType = buff.BuffType
										if i == 1 then
											weaponText = (weaponText .. bType)
										else
											weaponText = (weaponText .. ", " .. bType)
										end
									end
								end
								if weapon.CollideFriendly ~= false or (weapon.DamageRadius > 0 and weapon.DamageFriendly ~= false) then
									if weapon.Buffs then
										weaponText = (weaponText .. ", FF")
									else
										weaponText = (weaponText .. "FF")
									end
								end
								weaponText = (weaponText .. ")")
							end
						
							-- Concat Damage. We don't check it here because we already checked it exists to get this far.
							weaponText = (weaponText .. " { Dmg: " .. LOUD_ThouCheck(weapon.Damage))
							
							-- Check PPF and concat.
							if weapon.ProjectilesPerOnFire > 1 then
								weaponText = (weaponText .. " (" .. tostring(weapon.ProjectilesPerOnFire) .. " Shots)")
							end
							
							-- Check DoTPulses and concat.
							if weapon.DoTPulses > 0 then
								weaponText = (weaponText .. " (" .. tostring(weapon.DoTPulses) .. " Hits)")
							end
							
							-- Concat DPS, calculated from PhxLib.
							weaponText = (weaponText .. ", DPS: " .. LOUD_ThouCheck(LOUDFLOOR(PhxLib.PhxWeapDPS(weapon).DPS + 0.5)))
						
							-- Check DamageRadius and concat.
							if weapon.DamageRadius > 0 then
								weaponText = (weaponText .. ", AoE: " .. LOUD_KiloCheck(weapon.DamageRadius * 20))
							end
						else
							if wepCategory == " Defense" then
								-- Display Countermeasure Targets as the weapon type.
								if weapon.TargetRestrictOnlyAllow then
									weaponText = (TitleCase(weapon.TargetRestrictOnlyAllow) .. wepCategory)
								end
								
								-- If a weapon is a Countermeasure, we don't care about its damage or DPS,
								-- as it's all very small numbers purely for shooting projectiles.
								weaponText = (weaponText .. " {"):gsub(",", " ")

								-- Show RoF for Countermeasure weapons.
								if PhxLib.PhxWeapDPS(weapon).RateOfFire > 0 then
									weaponText = (weaponText .. " RoF: " .. LOUDFORMAT("%.2f", PhxLib.PhxWeapDPS(weapon).RateOfFire) .. "/s"):gsub("%.?0+$", "")
								end
							end
							-- Special case for Melee weapons, only showing Damage.
							if wepCategory == "Melee" then
								weaponText = (weaponText .. " { Dmg: " .. LOUD_ThouCheck(weapon.Damage))
							end
						end
						
						-- Check RateOfFire and concat.
						-- (NOTE: Commented out for now. DPS can infer ROF well enough and we have limited real-estate in the rollover box until someone figures out how to extend its width limit.)
						if PhxLib.PhxWeapDPS(weapon).RateOfFire > 0 then
						--	weaponText = (weaponText .. ", RoF: " .. LOUDFORMAT("%.2f", weapon.RateOfFire) .. "/s"):gsub("%.?0+$", "")
						end
						
						-- Check Min/Max Radius and concat.
						if weapon.MaxRadius > 0 then
							if weapon.MinRadius > 0 then
								weaponText = (weaponText .. ", Rng: " .. LOUD_KiloCheck(weapon.MinRadius * 20) .. "-" .. LOUD_KiloCheck(weapon.MaxRadius * 20))
							else
								weaponText = (weaponText .. ", Rng: " .. LOUD_KiloCheck(weapon.MaxRadius * 20))
							end
						end
						
						-- Finish text line.
						weaponText = (weaponText .. " }")

						-- Check duplicate weapons. We compare lots of values here, 
						-- any slight difference should be considered a different weapon. 
						if weapon.Damage == lastWeaponDmg and LOUDFLOOR(PhxLib.PhxWeapDPS(weapon).DPS + 0.5) == lastWeaponDPS and weapon.ProjectilesPerOnFire == lastWeaponPPOF and weapon.DoTPulses == lastWeaponDoT and weapon.DamageRadius == lastWeaponDmgRad and weapon.MinRadius == lastWeaponMinRad and weapon.MaxRadius == lastWeaponMaxRad and weapon.DamageFriendly == lastWeaponFF and PhxLib.PhxWeapDPS(weapon).RateOfFire == lastWeaponROF and weapon.CollideFriendly == lastWeaponCF and weapon.TargetRestrictOnlyAllow == lastWeaponTarget then
							dupWeaponCount = dupWeaponCount + 1
							-- Remove the old line, to insert the new one with the updated weapon count.
							table.remove(textLines, table.getn(textLines))
							table.insert(textLines, LOUDFORMAT("%s (x%d)", weaponText, dupWeaponCount))
						else
							dupWeaponCount = 1
							-- Insert the textLine.
							table.insert(textLines, weaponText)
						end
					end
				end
				
				-- Set lastWeapon stuff.
				lastWeaponDmg = weapon.Damage
				lastWeaponDPS = LOUDFLOOR(PhxLib.PhxWeapDPS(weapon).DPS + 0.5)
				lastWeaponPPOF = weapon.ProjectilesPerOnFire
				lastWeaponDoT = weapon.DoTPulses
				lastWeaponDmgRad = weapon.DamageRadius
				lastWeaponROF = PhxLib.PhxWeapDPS(weapon).RateOfFire
				lastWeaponMinRad = weapon.MinRadius
				lastWeaponMaxRad = weapon.MaxRadius
				lastWeaponFF = weapon.DamageFriendly
				lastWeaponCF = weapon.CollideFriendly
				lastWeaponTarget = weapon.TargetRestrictOnlyAllow
				lastWeaponNukeInDmg = weapon.NukeInnerRingDamage
				lastWeaponNukeInRad = weapon.NukeInnerRingRadius
				lastWeaponNukeOutDmg = weapon.NukeOuterRingDamage
				lastWeaponNukeOutRad = weapon.NukeOuterRingRadius
			end
		end
	end

	local weapon_end = table.getn(textLines)
	local physicsText = ""

	--Physics info
	if physics and physics.MotionType ~= 'RULEUMT_None' then
		if physics.MotionType == 'RULEUMT_Air' then
			if air.MaxAirspeed ~= 0 then
				physicsText = ("Top Speed: " .. LOUD_SpeedCheck(air.MaxAirspeed))
				
				if air.TurnSpeed ~= 0 then
					physicsText = (physicsText .. ", Turn Speed: " .. LOUD_SpeedCheck(air.TurnSpeed))
				end
				if physics.FuelUseTime ~= 0 then
					physicsText = (physicsText .. ", Fuel Time: " .. LOUD_FuelCheck(physics.FuelUseTime))
				end
			end
			
			-- Insert the physics text into the table.
			table.insert(textLines, physicsText)
			-- Get the index of the physics text line from the textLines table.
			physics_line = table.getn(textLines)
		else
			if physics.MaxSpeed ~= 0 then
				physicsText = ("Top Speed: " .. LOUD_SpeedCheck(physics.MaxSpeed))
				
				if physics.MaxAcceleration ~= 0 then
					physicsText = (physicsText .. ", Acceleration: " .. LOUD_SpeedCheck(physics.MaxAcceleration))
				end
			end
			
			-- Insert the physics text into the table.
			table.insert(textLines, physicsText)
			-- Get the index of the physics text line from the textLines table.
			physics_line = table.getn(textLines)
		end
	end

	local intelText = ""
	
	-- Intel info
	if intel then
		if intel.VisionRadius ~= 0 then
			intelText = ("Vision: " .. LOUD_KiloCheck(intel.VisionRadius * 20))
		end
		if intel.RadarRadius ~= 0 then
			intelText = (intelText .. ", Radar: " .. LOUD_KiloCheck(intel.RadarRadius * 20))
		end
		if intel.SonarRadius ~= 0 then
			intelText = (intelText .. ", Sonar: " .. LOUD_KiloCheck(intel.SonarRadius * 20))
		end
		
		-- Insert the intel text into the table.
		if intelText ~= "" then
			table.insert(textLines, intelText)
		end
		-- Get the index of the intel text line from the textLines table.
		intel_line = table.getn(textLines)
	end

	-- Unit cap
	if capCost then
		local capCostStr = string.format("%.1f", capCost)
		capCostStr = capCostStr:gsub("%.?0+$", "")
		table.insert(textLines, "Unit Cap Cost: "..capCostStr)
	else
		table.insert(textLines, "Unit Cap Cost: 1")
	end
	cap_line = table.getn(textLines)

	for i, v in textLines do
	
		local index = i
		
		if control.Value[index] then
			-- If control.Value (View.Description) has a value, 
			-- set the text of the value to the value of the index we're looping through.
			control.Value[index]:SetText(v)
		else
			-- If control.Value (View.Description) has no value, we create the value.
			control.Value[index] = UIUtil.CreateText( control, v, 12, UIUtil.bodyFont)
			LayoutHelpers.Below(control.Value[index], control.Value[index-1])
			LayoutHelpers.AtRightIn(control.Value[index], control, 7)
			control.Value[index].Width:Set(function() return control.Right() - control.Left() - LayoutHelpers.ScaleNumber(14) end)
			control.Value[index]:SetClipToWidth(true)
			control.Value[index]:DisableHitTest(true)
		end
		
		-- Set colors of lines.
		if index <= abilityLines then
			control.Value[index]:SetColor(UIUtil.bodyColor)
			control.Value[index]:SetFont(UIUtil.bodyFont, 12)
		elseif index == physics_line then
			-- Physics text color
			control.Value[index]:SetColor('ff83d5e6')
			-- Text font size
			control.Value[index]:SetFont(UIUtil.bodyFont, 11)
		elseif index == intel_line then
			-- Intel text color
			control.Value[index]:SetColor('ff29757e')
			-- Text font size
			control.Value[index]:SetFont(UIUtil.bodyFont, 11)
		elseif index > weapon_start and index <= weapon_end then
			control.Value[index]:SetFont(UIUtil.bodyFont, 11)
			if LOUDFIND(tostring(v), "Direct") then	-- Direct Fire
				control.Value[index]:SetColor('ffff3333')
			elseif LOUDFIND(tostring(v), "Indirect") then -- Indirect Fire
				control.Value[index]:SetColor('ffffff00')
			elseif LOUDFIND(tostring(v), "Anti Navy") then -- Anti Navy
				control.Value[index]:SetColor('ff00ff00')
			elseif LOUDFIND(tostring(v), "Anti Air") then -- Anti Air
				control.Value[index]:SetColor('ff00ffff')
			elseif LOUDFIND(tostring(v), " Defense") then -- Countermeasure
				control.Value[index]:SetColor('ffffa500')
			elseif LOUDFIND(tostring(v), "Nuke") then -- Nuke
				control.Value[index]:SetColor('ffffa500')
			elseif LOUDFIND(tostring(v), "Crash") then -- Air Crash
				control.Value[index]:SetColor('ffb077ff')
			elseif LOUDFIND(tostring(v), "Volatile") then -- Volatile
				control.Value[index]:SetColor('ffb077ff')
			elseif LOUDFIND(tostring(v), "Suicide") then -- Kamikaze/Suicide
				control.Value[index]:SetColor('ffb077ff')
			elseif LOUDFIND(tostring(v), "Melee") then	-- Melee
				control.Value[index]:SetColor('ffff3333')
			else
				control.Value[index]:SetColor('ff909090')
			end
		elseif index == cap_line then
			control.Value[index]:SetColor(UIUtil.fontColor)
			control.Value[index]:SetFont(UIUtil.bodyFont, 11)
		else
			control.Value[index]:SetColor(UIUtil.fontColor)
			control.Value[index]:SetFont(UIUtil.bodyFont, 12)
		end
		
		control.Height:Set(function() return (math.max(table.getsize(textLines), 4) * control.Value[1].Height()) + LayoutHelpers.ScaleNumber(30) end)
	end
	
	for i, v in control.Value do
	
		local index = i
		
		if index > table.getsize(textLines) then
			v:SetText("")
		end
	end
end

function Show(bp, buildingUnit, bpID)

	if CheckFormat() then
		
		LayoutHelpers.AtTopIn(View.UnitShortDesc, View, 10)
		View.UnitShortDesc:SetFont(UIUtil.bodyFont, 14)
		
		local description = LOC(bp.Description)
		
        if GetTechLevelString(bp) == 35 then
			description = LOCF('Elite %s', description)
		elseif GetTechLevelString(bp) == 4 then
			description = LOCF('%s', description)
		elseif GetTechLevelString(bp) == 5 then
			description = LOCF('Titan %s', description)
		elseif GetTechLevelString(bp) == 6 then
			description = LOCF('Hero %s', description)
		else
            description = LOCF('Tech %d %s', GetTechLevelString(bp), description)
        end
		
		if bp.General.UnitName ~= nil then
			View.UnitShortDesc:SetText(LOCF("%s: %s", bp.General.UnitName, description))
		else
			View.UnitShortDesc:SetText(LOCF("%s", description))
		end
		
		if View.UnitShortDesc:GetStringAdvance(View.UnitShortDesc:GetText()) > View.UnitShortDesc.Width() then
			LayoutHelpers.AtTopIn(View.UnitShortDesc, View, 14)
			View.UnitShortDesc:SetFont(UIUtil.bodyFont, 10)
		end
		
		local showecon = true
		local showUpKeep = false
		local showAbilities = false
		
		if buildingUnit ~= nil then
		
			local time, energy, mass = import('/lua/game.lua').GetConstructEconomyModel(buildingUnit, bp.Economy)
			time = math.max(time, 1)
			
			showUpKeep = DisplayResources(bp, time, energy, mass)
			View.TimeStat.Value:SetFont(UIUtil.bodyFont, 14)
			View.TimeStat.Value:SetText(string.format("%s", FormatTime(time)))
			
			if string.len(View.TimeStat.Value:GetText()) > 5 then
				View.TimeStat.Value:SetFont(UIUtil.bodyFont, 10)
			end
		else
			showecon = false
		end

		-- Health stat
		View.HealthStat.Value:SetText(string.format("%d", bp.Defense.MaxHealth))

		if View.Description then
			WrapAndPlaceText(bp.Air, bp.Physics, bp.Intel, bp.Weapon, bp.Display.Abilities, bp.General.CapCost, LOC(UnitDescriptions[bpID]), View.Description)
		end
		
		local showShield = false
		
		if bp.Defense.Shield and bp.Defense.Shield.ShieldMaxHealth then
			showShield = true
			View.ShieldStat.Value:SetText(bp.Defense.Shield.ShieldMaxHealth)
		end

		local iconName = GameCommon.GetUnitIconPath(bp)
		
		View.UnitImg:SetTexture(iconName)
		LayoutHelpers.SetDimensions(View.UnitImg, 48, 46)

		ShowView(showUpKeep, false, showecon, showShield)
	else
		Hide()
	end
end

function DisplayResources(bp, time, energy, mass)

	-- Cost Group
	if time > 0 then
		local consumeEnergy = -energy / time
		local consumeMass = -mass / time
		View.BuildCostGroup.EnergyValue:SetText( string.format("%d (%d)",-energy,consumeEnergy) )
		View.BuildCostGroup.MassValue:SetText( string.format("%d (%d)",-mass,consumeMass) )

		View.BuildCostGroup.EnergyValue:SetColor( "FFF05050" )
		View.BuildCostGroup.MassValue:SetColor( "FFF05050" )
	end

	-- Upkeep Group
	local plusEnergyRate = bp.Economy.ProductionPerSecondEnergy or bp.ProductionPerSecondEnergy
	local negEnergyRate = bp.Economy.MaintenanceConsumptionPerSecondEnergy or bp.MaintenanceConsumptionPerSecondEnergy or bp.ConsumptionPerSecondEnergy
	local plusMassRate = bp.Economy.ProductionPerSecondMass or bp.ProductionPerSecondMass
	local negMassRate = bp.Economy.MaintenanceConsumptionPerSecondMass or bp.MaintenanceConsumptionPerSecondMass or bp.ConsumptionPerSecondMass
	local upkeepEnergy = GetYield(negEnergyRate, plusEnergyRate)
	local upkeepMass = GetYield(negMassRate, plusMassRate)
	local showUpkeep = false
	
	if upkeepEnergy ~= 0 or upkeepMass ~= 0 then
	
		View.UpkeepGroup.Label:SetText(LOC("<LOC uvd_0002>Yield"))
		View.UpkeepGroup.EnergyValue:SetText( string.format("%d",upkeepEnergy) )
		View.UpkeepGroup.MassValue:SetText( string.format("%d",upkeepMass) )
		
		if upkeepEnergy >= 0 then
			View.UpkeepGroup.EnergyValue:SetColor( "FF50F050" )
		else
			View.UpkeepGroup.EnergyValue:SetColor( "FFF05050" )
		end

		if upkeepMass >= 0 then
			View.UpkeepGroup.MassValue:SetColor( "FF50F050" )
		else
			View.UpkeepGroup.MassValue:SetColor( "FFF05050" )
		end
		
		showUpkeep = true
		
	elseif bp.Economy and (bp.Economy.StorageEnergy ~= 0 or bp.Economy.StorageMass ~= 0) then
	
		View.UpkeepGroup.Label:SetText(LOC("<LOC uvd_0006>Storage"))
		
		local upkeepEnergy = bp.Economy.StorageEnergy or 0
		local upkeepMass = bp.Economy.StorageMass or 0
		
		View.UpkeepGroup.EnergyValue:SetText( string.format("%d",upkeepEnergy) )
		View.UpkeepGroup.MassValue:SetText( string.format("%d",upkeepMass) )
		View.UpkeepGroup.EnergyValue:SetColor( "FF50F050" )
		View.UpkeepGroup.MassValue:SetColor( "FF50F050" )
		
		showUpkeep = true
	end

	return showUpkeep 
end

function GetYield(consumption, production)

    if consumption then
        return -consumption
    elseif production then
        return production
    else
        return 0
    end
end

function OnNIS()
	if View then
		View:Hide()
		View:SetNeedsFrameUpdate(false)
	end
end

function Hide()

    if View then
        View:Hide()
        View.Hiding = true
    end
end

function SetLayout()
    import(UIUtil.GetLayoutFilename('unitviewDetail')).SetLayout()
end

function SetupUnitViewLayout(parent)

	if View then
		View:Destroy()
		View = nil
	end
	
	MapView = parent
	
	SetLayout()
	
	View:Hide()
	View:SetNeedsFrameUpdate(true)
	View:DisableHitTest(true)
end

end

else
	
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Group = import('/lua/maui/group.lua').Group
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local GameCommon = import('/lua/ui/game/gamecommon.lua')
local ItemList = import('/lua/maui/itemlist.lua').ItemList
local Prefs = import('/lua/user/prefs.lua')
local UnitDescriptions = import('/lua/ui/help/unitdescription.lua').Description

View = false
ViewState = "full"
MapView = false

local enhancementSlotNames = 
{
    back = "<LOC uvd_0007>Back",
    lch = "<LOC uvd_0008>LCH",
    rch = "<LOC uvd_0009>RCH",
}

function Contract()
    View:SetNeedsFrameUpdate(false)
    View:SetAlpha(0)
end

function Expand()
    View:SetNeedsFrameUpdate(true)
end

function GetTechLevelString(bp)
    if EntityCategoryContains(categories.TECH1, bp.BlueprintId) then
        return 1
    elseif EntityCategoryContains(categories.TECH2, bp.BlueprintId) then
        return 2
    elseif EntityCategoryContains(categories.TECH3, bp.BlueprintId) then
        return 3
    elseif EntityCategoryContains(categories.ELITE, bp.BlueprintId) then
        return 35
    elseif EntityCategoryContains(categories.EXPERIMENTAL, bp.BlueprintId) then
        return 4		
    elseif EntityCategoryContains(categories.TITAN, bp.BlueprintId) then
        return 5	
    elseif EntityCategoryContains(categories.HERO, bp.BlueprintId) then
        return 6			
    else
        return false
    end
end

function FormatTime(seconds)
    local tempSeconds = math.floor(seconds)
    local tempMinutes = 00

    tempMinutes = math.floor(tempSeconds / 60)
    tempSeconds = tempSeconds - (tempMinutes * 60)
    if(tempMinutes < 10) then
        tempMinutes = "0" .. tostring(tempMinutes)
    end
    if(tempSeconds < 10) then
        tempSeconds = "0" .. tostring(tempSeconds)
    end
    local tempTime = tostring(tempMinutes) .. ":" .. tostring(tempSeconds)
    return tempTime
end

function GetAbilityList(bp)
    local abilitiesList = {}

    return abilitiesList
end
    
function CheckFormat()
    if ViewState != Prefs.GetOption('uvd_format') then
        SetLayout()
    end
    if ViewState == "off" then
        return false
    else
        return true
    end
end
    
function ShowView(showUpKeep, enhancement, showecon, showShield)
    import('/lua/ui/game/unitview.lua').ShowROBox(false, false)
    View.Hiding = false
    
    View.UpkeepGroup:SetHidden(not showUpKeep)
    
    View.BuildCostGroup:SetHidden(not showecon)
    View.UpkeepGroup:SetHidden(not showUpKeep)
    View.TimeStat:SetHidden(not showecon)
    View.HealthStat:SetHidden(not showecon)
        
    View.HealthStat:SetHidden(enhancement)
    
    View.ShieldStat:SetHidden(not showShield)
    
    if View.Description then
        View.Description:SetHidden(ViewState == "limited" or View.Description.Value[1]:GetText() == "")
    end
end
   
function ShowEnhancement(bp, bpID, iconID, iconPrefix, userUnit)
    if CheckFormat() then
        # Name / Description
        View.UnitImg:SetTexture(UIUtil.UIFile(iconPrefix..'_btn_up.dds'))
        
        LayoutHelpers.AtTopIn(View.UnitShortDesc, View, 10)
        View.UnitShortDesc:SetFont(UIUtil.bodyFont, 14)

        local slotName = enhancementSlotNames[string.lower(bp.Slot)]
        slotName = slotName or bp.Slot

        if bp.Name != nil then
            View.UnitShortDesc:SetText(LOCF("%s: %s", bp.Name, slotName))
        else
            View.UnitShortDesc:SetText(LOC(slotName))
        end
        if View.UnitShortDesc:GetStringAdvance(View.UnitShortDesc:GetText()) > View.UnitShortDesc.Width() then
            LayoutHelpers.AtTopIn(View.UnitShortDesc, View, 14)
            View.UnitShortDesc:SetFont(UIUtil.bodyFont, 10)
        end
        
        local showecon = true
        local showAbilities = false
        local showUpKeep = false
        local time, energy, mass
        if bp.Icon != nil and not string.find(bp.Name, 'Remove') then
            time, energy, mass = import('/lua/game.lua').GetConstructEconomyModel(userUnit, bp)
            time = math.max(time, 1)
            showUpKeep = DisplayResources(bp, time, energy, mass)
            View.TimeStat.Value:SetFont(UIUtil.bodyFont, 14)
            View.TimeStat.Value:SetText(string.format("%s", FormatTime(time)))
            if string.len(View.TimeStat.Value:GetText()) > 5 then
                View.TimeStat.Value:SetFont(UIUtil.bodyFont, 10)
            end
        else
            showecon = false
            if View.Description then
                View.Description:Hide()
                for i, v in View.Description.Value do
                    v:SetText("")
                end
            end
        end
        
        if View.Description then
            local tempDescID = bpID.."-"..iconID
            if UnitDescriptions[tempDescID] and not string.find(bp.Name, 'Remove') then
                local tempDesc = LOC(UnitDescriptions[tempDescID])
                WrapAndPlaceText(nil, tempDesc, View.Description)
            else
                WARN('No description found for unit: ', bpID, ' enhancement: ', iconID)
                View.Description:Hide()
                for i, v in View.Description.Value do
                    v:SetText("")
                end
            end
        end
        
        local showShield = false
        if bp.ShieldMaxHealth then
            showShield = true
            View.ShieldStat.Value:SetText(bp.ShieldMaxHealth)
        end
    
        ShowView(showUpKeep, true, showecon, showShield)
        if time == 0 and energy == 0 and mass == 0 then
            View.BuildCostGroup:Hide()
            View.TimeStat:Hide()
        end
    else
        Hide()
    end
end
    
function WrapAndPlaceText(abilities, text, control)
    local lines = {}
    if text then
        lines = import('/lua/maui/text.lua').WrapText(text, control.Value[1].Width(),
                function(text) return control.Value[1]:GetStringAdvance(text) end)
    end
    local abilityLines = 0
    if abilities then
        local i = table.getn(abilities)
        while abilities[i] do
            table.insert(lines, 1, LOC(abilities[i]))
            i = i - 1
        end
        abilityLines = table.getsize(abilities)
    end
    for i, v in lines do
        local index = i
        if control.Value[index] then
            control.Value[index]:SetText(v)
        else
            control.Value[index] = UIUtil.CreateText( control, v, 12, UIUtil.bodyFont)
            LayoutHelpers.Below(control.Value[index], control.Value[index-1])
            control.Value[index].Right:Set(function() return control.Right() - 7 end)
            control.Value[index].Width:Set(function() return control.Right() - control.Left() - 14 end)
            control.Value[index]:SetClipToWidth(true)
            control.Value[index]:DisableHitTest()
        end
        if index <= abilityLines then
            control.Value[index]:SetColor(UIUtil.bodyColor)
        else
            control.Value[index]:SetColor(UIUtil.fontColor)
        end
        control.Height:Set(function() return (math.max(table.getsize(lines), 4) * control.Value[1].Height()) + 30 end)
    end
    for i, v in control.Value do
        local index = i
        if index > table.getsize(lines) then
            v:SetText("")
        end
    end
end
    
function Show(bp, buildingUnit, bpID)
    if CheckFormat() then
        # Name / Description
        if false then
            local foo, iconName = GameCommon.GetCachedUnitIconFileNames(bp)
            if iconName then
                View.UnitIcon:SetTexture(iconName)
            else
                View.UnitIcon:SetTexture(UIUtil.UIFile('/icons/units/default_icon.dds'))    
            end
        end
        LayoutHelpers.AtTopIn(View.UnitShortDesc, View, 10)
        View.UnitShortDesc:SetFont(UIUtil.bodyFont, 14)
        local description = LOC(bp.Description)
        if GetTechLevelString(bp) == 35 then
			description = LOCF('Elite %s', description)
		elseif GetTechLevelString(bp) == 4 then
			description = LOCF('%s', description)
		elseif GetTechLevelString(bp) == 5 then
			description = LOCF('Titan %s', description)
		elseif GetTechLevelString(bp) == 6 then
			description = LOCF('Hero %s', description)
		else
            description = LOCF('Tech %d %s', GetTechLevelString(bp), description)
        end
        if bp.General.UnitName != nil then
            View.UnitShortDesc:SetText(LOCF("%s: %s", bp.General.UnitName, description))
        else
            View.UnitShortDesc:SetText(LOCF("%s", description))
        end
        if View.UnitShortDesc:GetStringAdvance(View.UnitShortDesc:GetText()) > View.UnitShortDesc.Width() then
            LayoutHelpers.AtTopIn(View.UnitShortDesc, View, 14)
            View.UnitShortDesc:SetFont(UIUtil.bodyFont, 10)
        end
        local showecon = true
        local showUpKeep = false
        local showAbilities = false
        if buildingUnit != nil then
            local time, energy, mass = import('/lua/game.lua').GetConstructEconomyModel(buildingUnit, bp.Economy)
            time = math.max(time, 1)
            showUpKeep = DisplayResources(bp, time, energy, mass)
            View.TimeStat.Value:SetFont(UIUtil.bodyFont, 14)
            View.TimeStat.Value:SetText(string.format("%s", FormatTime(time)))
            if string.len(View.TimeStat.Value:GetText()) > 5 then
                View.TimeStat.Value:SetFont(UIUtil.bodyFont, 10)
            end
        else
            showecon = false
        end
            
        # Health stat
        View.HealthStat.Value:SetText(string.format("%d", bp.Defense.MaxHealth))
    
        if View.Description then
            WrapAndPlaceText(bp.Display.Abilities, LOC(UnitDescriptions[bpID]), View.Description)
        end
        local showShield = false
        if bp.Defense.Shield and bp.Defense.Shield.ShieldMaxHealth then
            showShield = true
            View.ShieldStat.Value:SetText(bp.Defense.Shield.ShieldMaxHealth)
        end
        
        local iconName = GameCommon.GetCachedUnitIconFileNames(bp)
        View.UnitImg:SetTexture(iconName)
        View.UnitImg.Height:Set(46)
        View.UnitImg.Width:Set(48)
        
        ShowView(showUpKeep, false, showecon, showShield)
    else
        Hide()
    end
end

function DisplayResources(bp, time, energy, mass)
    # Cost Group
    if time > 0 then
        local consumeEnergy = -energy / time
        local consumeMass = -mass / time
        View.BuildCostGroup.EnergyValue:SetText( string.format("%d (%d)",-energy,consumeEnergy) )
        View.BuildCostGroup.MassValue:SetText( string.format("%d (%d)",-mass,consumeMass) )
        
        View.BuildCostGroup.EnergyValue:SetColor( "FFF05050" )
        View.BuildCostGroup.MassValue:SetColor( "FFF05050" )
    end

    # Upkeep Group
    local plusEnergyRate = bp.Economy.ProductionPerSecondEnergy or bp.ProductionPerSecondEnergy
    local negEnergyRate = bp.Economy.MaintenanceConsumptionPerSecondEnergy or bp.MaintenanceConsumptionPerSecondEnergy
    local plusMassRate = bp.Economy.ProductionPerSecondMass or bp.ProductionPerSecondMass
    local negMassRate = bp.Economy.MaintenanceConsumptionPerSecondMass or bp.MaintenanceConsumptionPerSecondMass
    local upkeepEnergy = GetYield(negEnergyRate, plusEnergyRate)
    local upkeepMass = GetYield(negMassRate, plusMassRate)
    local showUpkeep = false
    if upkeepEnergy != 0 or upkeepMass != 0 then
        View.UpkeepGroup.Label:SetText(LOC("<LOC uvd_0002>Yield"))
        View.UpkeepGroup.EnergyValue:SetText( string.format("%d",upkeepEnergy) )
        View.UpkeepGroup.MassValue:SetText( string.format("%d",upkeepMass) )
        if upkeepEnergy >= 0 then
            View.UpkeepGroup.EnergyValue:SetColor( "FF50F050" )
        else
            View.UpkeepGroup.EnergyValue:SetColor( "FFF05050" )
        end
    
        if upkeepMass >= 0 then
            View.UpkeepGroup.MassValue:SetColor( "FF50F050" )
        else
            View.UpkeepGroup.MassValue:SetColor( "FFF05050" )
        end
        showUpkeep = true
    elseif bp.Economy and (bp.Economy.StorageEnergy != 0 or bp.Economy.StorageMass != 0) then
        View.UpkeepGroup.Label:SetText(LOC("<LOC uvd_0006>Storage"))
        local upkeepEnergy = bp.Economy.StorageEnergy or 0
        local upkeepMass = bp.Economy.StorageMass or 0
        View.UpkeepGroup.EnergyValue:SetText( string.format("%d",upkeepEnergy) )
        View.UpkeepGroup.MassValue:SetText( string.format("%d",upkeepMass) )
        View.UpkeepGroup.EnergyValue:SetColor( "FF50F050" )
        View.UpkeepGroup.MassValue:SetColor( "FF50F050" )
        showUpkeep = true
    end
    
    return showUpkeep 
end

function GetYield(consumption, production)
    if consumption then
        return -consumption
    elseif production then
        return production
    else
        return 0
    end
end

function OnNIS()
    if View then
        View:SetAlpha(0, true)
        View:SetNeedsFrameUpdate(false)
    end
end

function Hide()
    View.Time = 0
    View.Hiding = true
end

function SetLayout()
    import(UIUtil.GetLayoutFilename('unitviewDetail')).SetLayout()
end

function SetupUnitViewLayout(parent)
    if View then
        View:Destroy()
        View = nil
    end
    MapView = parent
    SetLayout()
    View:SetAlpha(0, true)
    View:SetNeedsFrameUpdate(true)
    View.Hiding = true
    View:DisableHitTest(true)
    View.OnFrame = function(self, delta)
        if self.Hiding then
            local newAlpha = self:GetAlpha() - (delta * 3)
            if newAlpha < 0 then
                newAlpha = 0
                self.Hiding = true
            end
            self:SetAlpha(newAlpha, true)
        elseif self:GetAlpha() < 1 then
            local newAlpha = math.min(self:GetAlpha() + (delta * 9), 1)
            self:SetAlpha(newAlpha, true)
        end
    end
end

end

else

local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Group = import('/lua/maui/group.lua').Group
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local GameCommon = import('/lua/ui/game/gamecommon.lua')
local ItemList = import('/lua/maui/itemlist.lua').ItemList
local Prefs = import('/lua/user/prefs.lua')
local options = Prefs.GetFromCurrentProfile('options')
local UnitDescriptions = import('/lua/ui/help/unitdescription.lua').Description
local WrapText = import('/lua/maui/text.lua').WrapText
local armorDefinition = import('/lua/armordefinition.lua').armordefinition

local controls = import('/lua/ui/controls.lua').Get()

View = controls.View or false
MapView = controls.MapView or false
ViewState = "full"

local enhancementSlotNames =
{
    back = "<LOC uvd_0007>Back",
    lch = "<LOC uvd_0008>LCH",
    rch = "<LOC uvd_0009>RCH",
}

function Contract()
    View:Hide()
end

function Expand()
    View:Show()
end

function GetTechLevelString(bp)
    if EntityCategoryContains(categories.TECH1, bp.BlueprintId) then
        return 1
    elseif EntityCategoryContains(categories.TECH2, bp.BlueprintId) then
        return 2
    elseif EntityCategoryContains(categories.TECH3, bp.BlueprintId) then
        return 3
    elseif EntityCategoryContains(categories.ELITE, bp.BlueprintId) then
        return 35
    elseif EntityCategoryContains(categories.EXPERIMENTAL, bp.BlueprintId) then
        return 4		
    elseif EntityCategoryContains(categories.TITAN, bp.BlueprintId) then
        return 5	
    elseif EntityCategoryContains(categories.HERO, bp.BlueprintId) then
        return 6			
    else
        return false
    end
end

function FormatTime(seconds)
    return string.format("%02d:%02d", math.floor(seconds / 60), math.mod(seconds, 60))
end

function GetAbilityList(bp)
    local abilitiesList = {}

    return abilitiesList
end

function CheckFormat()
    if ViewState ~= Prefs.GetOption('uvd_format') then
        SetLayout()
    end
    if ViewState == "off" then
        return false
    else
        return true
    end
end

function ShowView(showUpKeep, enhancement, showecon, showShield)
    import('/lua/ui/game/unitview.lua').ShowROBox(false, false)
    View:Show()

    View.UpkeepGroup:SetHidden(not showUpKeep)

    View.BuildCostGroup:SetHidden(not showecon)
    View.UpkeepGroup:SetHidden(not showUpKeep)
    View.TimeStat:SetHidden(not showecon)
    View.HealthStat:SetHidden(not showecon)

    View.HealthStat:SetHidden(enhancement)

    View.ShieldStat:SetHidden(not showShield)

    if View.Description then
        View.Description:SetHidden(ViewState == "limited" or View.Description.Value[1]:GetText() == "")
    end
end

function ShowEnhancement(bp, bpID, iconID, iconPrefix, userUnit)
    if not CheckFormat() then
        View:Hide()
        return
    end

    -- Name / Description
    View.UnitImg:SetTexture(UIUtil.UIFile(iconPrefix..'_btn_up.dds'))

    LayoutHelpers.AtTopIn(View.UnitShortDesc, View, 10)
    View.UnitShortDesc:SetFont(UIUtil.bodyFont, 14)

    local slotName = enhancementSlotNames[string.lower(bp.Slot)]
    slotName = slotName or bp.Slot

    if bp.Name ~= nil then
        View.UnitShortDesc:SetText(LOCF("%s: %s", bp.Name, slotName))
    else
        View.UnitShortDesc:SetText(LOC(slotName))
    end
    if View.UnitShortDesc:GetStringAdvance(View.UnitShortDesc:GetText()) > View.UnitShortDesc.Width() then
        LayoutHelpers.AtTopIn(View.UnitShortDesc, View, 14)
        View.UnitShortDesc:SetFont(UIUtil.bodyFont, 10)
    end

    local showecon = true
    local showAbilities = false
    local showUpKeep = false
    local time, energy, mass
    if bp.Icon ~= nil and not string.find(bp.Name, 'Remove') then
        time, energy, mass = import('/lua/game.lua').GetConstructEconomyModel(userUnit, bp)
        time = math.max(time, 1)
        showUpKeep = DisplayResources(bp, time, energy, mass)
        View.TimeStat.Value:SetFont(UIUtil.bodyFont, 14)
        View.TimeStat.Value:SetText(string.format("%s", FormatTime(time)))
        if string.len(View.TimeStat.Value:GetText()) > 5 then
            View.TimeStat.Value:SetFont(UIUtil.bodyFont, 10)
        end
    else
        showecon = false
        if View.Description then
            View.Description:Hide()
            for i, v in View.Description.Value do
                v:SetText("")
            end
        end
    end

    if View.Description then
        -- If enhancement of preset, then remove extension. (ual0301_Engineer -> ual0301)
        if string.find(bpID, '_') then
            bpID = string.sub(bpID, 1, string.find(bpID, "_[^_]*$")-1)
        end
        WrapAndPlaceText(nil, nil, bpID.."-"..iconID, View.Description)
    end

    local showShield = false
    if bp.ShieldMaxHealth then
        showShield = true
        View.ShieldStat.Value:SetText(bp.ShieldMaxHealth)
    end

    ShowView(showUpKeep, true, showecon, showShield)
    if time == 0 and energy == 0 and mass == 0 then
        View.BuildCostGroup:Hide()
        View.TimeStat:Hide()
    end
end

function CreateLines(control, blocks)
    local i = 0
    local prevText = control.Value[1]
    for _, block in blocks do
        for _, line in block.lines do
            i = i + 1
            local text = control.Value[i]
            if text then
                text:SetText(line)
            else
                text = UIUtil.CreateText(control, line, 12, UIUtil.bodyFont)
                LayoutHelpers.Below(text, prevText)
                text.Width:Set(prevText.Width)
                text:DisableHitTest()
                control.Value[i] = text
            end
            text:SetColor(block.color)
            prevText = text
        end
    end
    if i > 0 then
        control.Height:Set(prevText.Bottom() - control.Value[1].Top() + LayoutHelpers.ScaleNumber(30))
    else
        control.Height:Set(LayoutHelpers.ScaleNumber(30))
    end
    for i = i + 1, table.getsize(control.Value) do
        control.Value[i]:SetText('')
    end
end

function DecimalToBinary(string)
    local number = tonumber(string)
    local cnt = 0
    local bitArray = {}
    while number > 0 do
        local last = math.mod(number, 2)
        bitArray[cnt] = last
        number = (number - last) / 2
        cnt = cnt + 1
    end
    return bitArray
end

function ExtractAbilityFromString(ability)
    local i = string.find(ability,'>')
    if i then
        return string.sub(ability,6,i-1)
    end
    return ability
end

function LOCStr(str)
    local id = str:lower()
    id = id:gsub(' ', '_')
    return LOC('<LOC ls_'..id..'>'..str)
end

function GetShortDesc(bp)
    local desc = ''
    if bp.General.UnitName then
        desc = LOC(bp.General.UnitName)
        if desc ~='' then
            desc = desc..': '
        end
    end
    if GetTechLevelString(bp) then
        desc = desc..LOC('<LOC _Tech>')..GetTechLevelString(bp)..' '
    end
    return desc..LOC(bp.Description)
end

IsAbilityExist = {
    ability_radar = function(bp)
        return bp.Intel.RadarRadius > 0
    end,
    ability_sonar = function(bp)
        return bp.Intel.SonarRadius > 0
    end,
    ability_omni = function(bp)
        return bp.Intel.OmniRadius > 0
    end,
    ability_flying = function(bp)
        return bp.Air.CanFly
    end,
    ability_hover = function(bp)
        return bp.Physics.MotionType == 'RULEUMT_Hover'
    end,
    ability_amphibious = function(bp)
        local bitArray = DecimalToBinary(bp.Physics.BuildOnLayerCaps)
        return (bitArray[0] == 1 -- LAYER_Land
           and bitArray[1] == 1) -- LAYER_Seabed
            or bp.Physics.MotionType == 'RULEUMT_Amphibious'
    end,
    ability_aquatic = function(bp)
        local bitArray = DecimalToBinary(bp.Physics.BuildOnLayerCaps)
        return (bitArray[0] == 1 -- LAYER_Land
           and bitArray[3] == 1) -- LAYER_Water
            or bp.Physics.MotionType == 'RULEUMT_AmphibiousFloating'
    end,
    ability_sacrifice = function(bp)
        return DecimalToBinary(bp.General.CommandCaps)[16] == 1 -- RULEUCC_Sacrifice
    end,
    ability_engineeringsuite = function(bp)
        return (bp.CategoriesHash.ENGINEER or bp.CategoriesHash.ENGINEERSTATION or bp.CategoriesHash.REPAIR) and (bp.Economy.BuildRate > 0)
    end,
    ability_carrier = function(bp)
        return bp.Transport.StorageSlots > 0
           and DecimalToBinary(bp.General.CommandCaps)[8] == 1 -- RULEUCC_Transport
    end,
    ability_factory = function(bp)
        return bp.CategoriesHash.FACTORY and bp.CategoriesHash.SHOWQUEUE
    end,
    ability_upgradable = function(bp)
        return bp.General.UpgradesTo and bp.General.UpgradesTo ~= ''
    end,
    ability_tacticalmissledeflect = function(bp)
        return bp.Defense.AntiMissile.Radius > 0 and bp.Defense.AntiMissile.RedirectRateOfFire > 0
    end,
    ability_cloak = function(bp)
        return bp.Intel.Cloak
    end,
    ability_transportable = function(bp)
        return DecimalToBinary(bp.General.CommandCaps)[9] == 1 -- RULEUCC_CallTransport
    end,
    ability_transport = function(bp)
        return bp.CategoriesHash.TRANSPORTATION
           and DecimalToBinary(bp.General.CommandCaps)[8] == 1 -- RULEUCC_Transport
    end,
    ability_airstaging = function(bp)
        return bp.CategoriesHash.AIRSTAGINGPLATFORM
    end,
    ability_submersible = function(bp)
        return DecimalToBinary(bp.General.CommandCaps)[19] == 1 -- RULEUCC_Dive
    end,
    ability_jamming = function(bp)
        return bp.Intel.JammerBlips > 0 and bp.Intel.JamRadius.Max > 0
    end,
    ability_building = function(bp)
        return bp.General.BuildBones and bp.CategoriesHash.CONSTRUCTION
    end,
    ability_repairs = function(bp)
        return DecimalToBinary(bp.General.CommandCaps)[6] == 1 -- RULEUCC_Repair
    end,
    ability_reclaim = function(bp)
        return DecimalToBinary(bp.General.CommandCaps)[20] == 1 -- RULEUCC_Reclaim
    end,
    ability_capture = function(bp)
        return DecimalToBinary(bp.General.CommandCaps)[7] == 1 -- RULEUCC_Capture
    end,
    ability_personalshield = function(bp)
        return bp.Defense.Shield.PersonalShield or bp.Defense.Shield.PersonalBubble
    end,
    ability_shielddome = function(bp)
        return not(bp.Defense.Shield.PersonalShield or bp.Defense.Shield.PersonalBubble) and (bp.Defense.Shield.ShieldSize > 0)
    end,
    ability_personalstealth = function(bp)
        return bp.Intel.RadarStealth and bp.Intel.RadarStealthFieldRadius <= 0
    end,
    ability_stealthfield = function(bp)
        return bp.Intel.RadarStealthFieldRadius > 0
    end,
    ability_stealth_sonar = function(bp)
        return bp.Intel.SonarStealth and bp.Intel.SonarStealthFieldRadius <= 0
    end,
    ability_stealth_sonarfield = function(bp)
        return bp.Intel.SonarStealthFieldRadius > 0
    end,
    ability_customizable = function(bp)
        return not table.empty(bp.Enhancements)
    end,
    ability_notcap = function(bp)
        return bp.CategoriesHash.COMMAND or bp.CategoriesHash.SUBCOMMANDER or bp.BlueprintId == 'uaa0310'
    end,
    ability_massive = function(bp)
        return bp.Display.MovementEffects.Land.Footfall.Damage.Amount > 0
           and bp.Display.MovementEffects.Land.Footfall.Damage.Radius > 0
    end,
    ability_personal_teleporter = function(bp)
        return DecimalToBinary(bp.General.CommandCaps)[12] == 1 -- RULEUCC_Teleport
    end
}

GetAbilityDesc = {
    ability_radar = function(bp)
        return LOCF('<LOC uvd_Radius>', bp.Intel.RadarRadius)
    end,
    ability_sonar = function(bp)
        return LOCF('<LOC uvd_Radius>', bp.Intel.SonarRadius)
    end,
    ability_omni = function(bp)
        return LOCF('<LOC uvd_Radius>', bp.Intel.OmniRadius)
    end,
    ability_flying = function(bp)
        return LOCF("<LOC uvd_0011>Speed: %0.1f, Turning: %0.1f", bp.Air.MaxAirspeed, bp.Air.TurnSpeed)
    end,
    ability_carrier = function(bp)
        return LOCF('<LOC uvd_StorageSlots>', bp.Transport.StorageSlots)
    end,
    ability_factory = function(bp)
        return LOCF('<LOC uvd_BuildRate>', bp.Economy.BuildRate)
    end,
    ability_upgradable = function(bp)
        return GetShortDesc(__blueprints[bp.General.UpgradesTo])
    end,
    ability_tacticalmissledeflect = function(bp)
        return LOCF('<LOC uvd_Radius>', bp.Defense.AntiMissile.Radius)..', '
             ..LOCF('<LOC uvd_FireRate>', 1 / bp.Defense.AntiMissile.RedirectRateOfFire)
    end,
    --[[ability_transportable = function(bp)
        return LOCF('<LOC uvd_UnitSize>', bp.Transport.TransportClass)
    end,]]
    ability_transport = function(bp)
        local text = LOC('<LOC uvd_Capacity>')
        return bp.Transport and bp.Transport.Class1Capacity and text..bp.Transport.Class1Capacity
            or bp.CategoriesHash.TECH1 and text..'≈6'
            or bp.CategoriesHash.TECH2 and text..'≈12'
            or bp.CategoriesHash.TECH3 and text..'≈28'
            or ''
    end,
    ability_airstaging = function(bp)
        return LOCF('<LOC uvd_RepairRate>', bp.Transport.RepairRate)..', '
             ..LOCF('<LOC uvd_DockingSlots>', bp.Transport.DockingSlots)
    end,
    ability_jamming = function(bp)
        return LOCF('<LOC uvd_Radius>', bp.Intel.JamRadius.Max)..', '
             ..LOCF('<LOC uvd_Blips>', bp.Intel.JammerBlips)
    end,
    ability_personalshield = function(bp)
        return LOCF('<LOC uvd_RegenRate>', bp.Defense.Shield.ShieldRegenRate)
    end,
    ability_shielddome = function(bp)
        return LOCF('<LOC uvd_Radius>', bp.Defense.Shield.ShieldSize)..', '
             ..LOCF('<LOC uvd_RegenRate>', bp.Defense.Shield.ShieldRegenRate)
    end,
    ability_stealthfield = function(bp)
        return LOCF('<LOC uvd_Radius>', bp.Intel.RadarStealthFieldRadius)
    end,
    ability_stealth_sonarfield = function(bp)
        return LOCF('<LOC uvd_Radius>', bp.Intel.SonarStealthFieldRadius)
    end,
    ability_customizable = function(bp)
        local cnt = 0
        for _, v in bp.Enhancements do
            if v.RemoveEnhancements or (not v.Slot) then continue end
            cnt = cnt + 1
        end
        return cnt
    end,
    ability_massive = function(bp)
        return string.format(LOC('<LOC uvd_0010>Damage: %d, Splash: %d'),
            bp.Display.MovementEffects.Land.Footfall.Damage.Amount,
            bp.Display.MovementEffects.Land.Footfall.Damage.Radius)
    end,
    ability_personal_teleporter = function(bp)
        if not bp.General.TeleportDelay then return '' end
        return LOCF('<LOC uvd_Delay>', bp.General.TeleportDelay)
    end
}

function WrapAndPlaceText(bp, builder, descID, control)
    local lines = {}
    local blocks = {}
    --Unit description
    local text = LOC(UnitDescriptions[descID])
    if text and text ~='' then
        table.insert(blocks, {color = UIUtil.fontColor,
            lines = WrapText(text, control.Value[1].Width(), function(text)
                return control.Value[1]:GetStringAdvance(text)
            end)})
        table.insert(blocks, {color = UIUtil.bodyColor, lines = {''}})
    end

    if builder and bp.EnhancementPresetAssigned then
        table.insert(lines, LOC('<LOC uvd_upgrades>')..':')
        for _, v in bp.EnhancementPresetAssigned.Enhancements do
            table.insert(lines, '    '..LOC(bp.Enhancements[v].Name))
        end
        table.insert(blocks, {color = 'FFB0FFB0', lines = lines})
    elseif bp then
        --Get not autodetected abilities
        if bp.Display.Abilities then
            for _, id in bp.Display.Abilities do
                local ability = ExtractAbilityFromString(id)
                if not IsAbilityExist[ability] then
                    table.insert(lines, LOC(id))
                end
            end
        end
        --Autodetect abilities exclude engineering
        for id, func in IsAbilityExist do
            if (id ~= 'ability_engineeringsuite') and (id ~= 'ability_building') and
               (id ~= 'ability_repairs') and (id ~= 'ability_reclaim') and (id ~= 'ability_capture') and func(bp) then
                local ability = LOC('<LOC '..id..'>')
                if GetAbilityDesc[id] then
                    local desc = GetAbilityDesc[id](bp)
                    if desc ~= '' then
                        ability = ability..' - '..desc
                    end
                end
                table.insert(lines, ability)
            end
        end
        if not table.empty(lines) then
            table.insert(lines, '')
        end
        table.insert(blocks, {color = 'FF7FCFCF', lines = lines})
        --Autodetect engineering abilities
        if IsAbilityExist.ability_engineeringsuite(bp) then
            lines = {}
            table.insert(lines, LOC('<LOC '..'ability_engineeringsuite'..'>')
                ..' - '..LOCF('<LOC uvd_BuildRate>', bp.Economy.BuildRate)
                ..', '..LOCF('<LOC uvd_Radius>', bp.Economy.MaxBuildDistance))
            local orders = LOC('<LOC order_0011>')
            if IsAbilityExist.ability_building(bp) then
                orders = orders..', '..LOC('<LOC order_0001>')
            end
            if IsAbilityExist.ability_repairs(bp) then
                orders = orders..', '..LOC('<LOC order_0005>')
            end
            if IsAbilityExist.ability_reclaim(bp) then
                orders = orders..', '..LOC('<LOC order_0006>')
            end
            if IsAbilityExist.ability_capture(bp) then
                orders = orders..', '..LOC('<LOC order_0007>')
            end
            table.insert(lines, orders)
            table.insert(lines, '')
            table.insert(blocks, {color = 'FFFFFFB0', lines = lines})
        end

        if options.gui_render_armament_detail == 1 then
            --Armor values
            lines = {}
            local armorType = bp.Defense.ArmorType
            if armorType and armorType ~= '' then
                local spaceWidth = control.Value[1]:GetStringAdvance(' ')
                local str = LOC('<LOC uvd_ArmorType>')..LOC('<LOC at_'..armorType..'>')
                local spaceCount = (195 - control.Value[1]:GetStringAdvance(str)) / spaceWidth
                str = str..string.rep(' ', spaceCount)..LOC('<LOC uvd_DamageTaken>')
                table.insert(lines, str)
                for _, armor in armorDefinition do
                    if armor[1] == armorType then
                        local row = 0
                        local armorDetails = ''
                        local elemCount = table.getsize(armor)
                        for i = 2, elemCount do
                            --if string.find(armor[i], '1.0') > 0 then continue end
                            local armorName = armor[i]
                            armorName = string.sub(armorName, 1, string.find(armorName, ' ') - 1)
                            armorName = LOC('<LOC an_'..armorName..'>')..' - '..string.format('%0.1f', tonumber(armor[i]:sub(armorName:len() + 2, armor[i]:len())) * 100)
                            if row < 1 then
                                armorDetails = armorName
                                row = 1
                            else
                                local spaceCount = (195 - control.Value[1]:GetStringAdvance(armorDetails)) / spaceWidth
                                armorDetails = armorDetails..string.rep(' ', spaceCount)..armorName
                                table.insert(lines, armorDetails)
                                armorDetails = ''
                                row = 0
                            end
                        end
                        if armorDetails ~= '' then
                            table.insert(lines, armorDetails)
                        end
                    end
                end
                table.insert(lines, '')
                table.insert(blocks, {color = 'FF7FCFCF', lines = lines})
            end
            --Weapons
            if not table.empty(bp.Weapon) then
                local weapons = {upgrades = {normal = {}, death = {}},
                                    basic = {normal = {}, death = {}}}
                for _, weapon in bp.Weapon do
                    if not weapon.WeaponCategory then continue end
                    local dest = weapons.basic
                    if weapon.EnabledByEnhancement then
                        dest = weapons.upgrades
                    end
                    if (weapon.FireOnDeath) or (weapon.WeaponCategory == 'Death') then
                        dest = dest.death
                    else
                        dest = dest.normal
                    end
                    if dest[weapon.DisplayName] then
                        dest[weapon.DisplayName].count = dest[weapon.DisplayName].count + 1
                    else
                        dest[weapon.DisplayName] = {info = weapon, count = 1}
                    end
                end
                for k, v in weapons do
                    if not table.empty(v.normal) or not table.empty(v.death) then
                        table.insert(blocks, {color = UIUtil.fontColor, lines = {LOC('<LOC uvd_'..k..'>')..':'}})
                    end
                    for name, weapon in v.normal do
                        local info = weapon.info
                        local weaponDetails1 = LOCStr(name)..' ('..LOCStr(info.WeaponCategory)..') '
                        if info.ManualFire then
                            weaponDetails1 = weaponDetails1..LOC('<LOC uvd_ManualFire>')
                        end
                        local weaponDetails2
                        if info.NukeInnerRingDamage then
                            weaponDetails2 = string.format(LOC('<LOC uvd_0014>Damage: %d - %d, Splash: %d - %d')..', '..LOC('<LOC uvd_Range>'),
                                info.NukeInnerRingDamage + info.NukeOuterRingDamage, info.NukeOuterRingDamage,
                                info.NukeInnerRingRadius, info.NukeOuterRingRadius, info.MinRadius, info.MaxRadius)
                        else
                            local MuzzleBones = 0
                            if info.MuzzleSalvoDelay > 0 then
                                MuzzleBones = info.MuzzleSalvoSize
                            elseif info.RackBones then
                                for _, v in info.RackBones do
                                    MuzzleBones = MuzzleBones + table.getsize(v.MuzzleBones)
                                end
                                if not info.RackFireTogether then
                                    MuzzleBones = MuzzleBones / table.getsize(info.RackBones)
                                end
                            else
                                MuzzleBones = 1
                            end

                            local Damage = info.Damage
                            if info.DamageToShields then
                                Damage = math.max(Damage, info.DamageToShields)
                            end
                            Damage = Damage * (info.DoTPulses or 1)
                            local ProjectilePhysics = __blueprints[info.ProjectileId].Physics
                            while ProjectilePhysics do
                                Damage = Damage * (ProjectilePhysics.Fragments or 1)
                                ProjectilePhysics = __blueprints[string.lower(ProjectilePhysics.FragmentId or '')].Physics
                            end

                            local ReloadTime = math.max((info.RackSalvoChargeTime or 0) + (info.RackSalvoReloadTime or 0) +
                                (info.MuzzleSalvoDelay or 0) * (info.MuzzleSalvoSize or 1), 1 / info.RateOfFire)

                            if not info.ManualFire and info.WeaponCategory ~= 'Kamikaze' then
                                local DPS = Damage * MuzzleBones
                                if info.BeamLifetime > 0 then
                                    DPS = DPS * info.BeamLifetime * 10
                                end
                                DPS = DPS / ReloadTime + (info.InitialDamage or 0)
                                weaponDetails1 = weaponDetails1..LOCF('<LOC uvd_DPS>', DPS)
                            end

                            weaponDetails2 = string.format(LOC('<LOC uvd_0010>Damage: %d, Splash: %d')..', '..LOC('<LOC uvd_Range>')..', '..LOC('<LOC uvd_Reload>'),
                                Damage, info.DamageRadius, info.MinRadius, info.MaxRadius, ReloadTime)
                        end
                        if weapon.count > 1 then
                            weaponDetails1 = weaponDetails1..' x'..weapon.count
                        end
                        table.insert(blocks, {color = UIUtil.fontColor, lines = {weaponDetails1}})
                        table.insert(blocks, {color = 'FFFFB0B0', lines = {weaponDetails2}})
                    end
                    lines = {}
                    for name, weapon in v.death do
                        local info = weapon.info
                        local weaponDetails = LOCStr(name)..' ('..LOCStr(info.WeaponCategory)..') '
                        if info.NukeInnerRingDamage then
                            weaponDetails = weaponDetails..LOCF('<LOC uvd_0014>Damage: %d - %d, Splash: %d - %d',
                                info.NukeInnerRingDamage + info.NukeOuterRingDamage, info.NukeOuterRingDamage,
                                info.NukeInnerRingRadius, info.NukeOuterRingRadius)
                        else
                            weaponDetails = weaponDetails..LOCF('<LOC uvd_0010>Damage: %d, Splash: %d',
                                info.Damage, info.DamageRadius)
                        end
                        if weapon.count > 1 then
                            weaponDetails = weaponDetails..' x'..weapon.count
                        end
                        table.insert(lines, weaponDetails)
                    end
                    if not table.empty(v.normal) or not table.empty(v.death) then
                        table.insert(lines, '')
                    end
                    table.insert(blocks, {color = 'FFFF0000', lines = lines})
                end
            end
        end
        --Other parameters
        lines = {}
        table.insert(lines, LOCF("<LOC uvd_0013>Vision: %d, Underwater Vision: %d, Regen: %0.1f, Cap Cost: %0.1f",
            bp.Intel.VisionRadius, bp.Intel.WaterVisionRadius, bp.Defense.RegenRate, bp.General.CapCost))

        if (bp.Physics.MotionType ~= 'RULEUMT_Air' and bp.Physics.MotionType ~= 'RULEUMT_None')
        or (bp.Physics.AltMotionType ~= 'RULEUMT_Air' and bp.Physics.AltMotionType ~= 'RULEUMT_None') then
            table.insert(lines, LOCF("<LOC uvd_0012>Speed: %0.1f, Reverse: %0.1f, Acceleration: %0.1f, Turning: %d",
                bp.Physics.MaxSpeed, bp.Physics.MaxSpeedReverse, bp.Physics.MaxAcceleration, bp.Physics.TurnRate))
        end

        table.insert(blocks, {color = 'FFB0FFB0', lines = lines})
    end
    CreateLines(control, blocks)
end

function Show(bp, builderUnit, bpID)
    if not CheckFormat() then
        View:Hide()
        return
    end

    -- Name / Description
    LayoutHelpers.AtTopIn(View.UnitShortDesc, View, 10)
    View.UnitShortDesc:SetFont(UIUtil.bodyFont, 14)

    View.UnitShortDesc:SetText(GetShortDesc(bp))

    local scale = View.UnitShortDesc.Width() / View.UnitShortDesc.TextAdvance()
    if scale < 1 then
        LayoutHelpers.AtTopIn(View.UnitShortDesc, View, 10 / scale)
        View.UnitShortDesc:SetFont(UIUtil.bodyFont, 14 * scale)
    end
    local showecon = true
    local showUpKeep = false
    local showAbilities = false
    if builderUnit ~= nil then
        -- Differential upgrading. Check to see if building this would be an upgrade
        local targetBp = bp
        local builderBp = builderUnit:GetBlueprint()

        local performUpgrade = false

        if targetBp.General.UpgradesFrom == builderBp.BlueprintId then
            performUpgrade = true
        elseif targetBp.General.UpgradesFrom == builderBp.General.UpgradesTo then
            performUpgrade = true
        elseif targetBp.General.UpgradesFromBase ~= "none" then
            -- try testing against the base
            if targetBp.General.UpgradesFromBase == builderBp.BlueprintId then
                performUpgrade = true
            elseif targetBp.General.UpgradesFromBase == builderBp.General.UpgradesFromBase then
                performUpgrade = true
            end
        end

        local time, energy, mass

        if performUpgrade then
            time, energy, mass = import('/lua/game.lua').GetConstructEconomyModel(builderUnit, bp.Economy, builderBp.Economy)
        else
            time, energy, mass = import('/lua/game.lua').GetConstructEconomyModel(builderUnit, bp.Economy)
        end

        time = math.max(time, 1)
        showUpKeep = DisplayResources(bp, time, energy, mass)
        View.TimeStat.Value:SetFont(UIUtil.bodyFont, 14)
        View.TimeStat.Value:SetText(string.format("%s", FormatTime(time)))
        if string.len(View.TimeStat.Value:GetText()) > 5 then
            View.TimeStat.Value:SetFont(UIUtil.bodyFont, 10)
        end
    else
        showecon = false
    end

    -- Health stat
    View.HealthStat.Value:SetText(string.format("%d", bp.Defense.MaxHealth))

    if View.Description then
        WrapAndPlaceText(bp, builderUnit, bpID, View.Description)
    end
    local showShield = false
    if bp.Defense.Shield and bp.Defense.Shield.ShieldMaxHealth then
        showShield = true
        View.ShieldStat.Value:SetText(bp.Defense.Shield.ShieldMaxHealth)
    end

    local iconName = GameCommon.GetCachedUnitIconFileNames(bp)
    View.UnitImg:SetTexture(iconName)
    LayoutHelpers.SetDimensions(View.UnitImg, 46, 46)

    ShowView(showUpKeep, false, showecon, showShield)
end

function DisplayResources(bp, time, energy, mass)
    -- Cost Group
    if time > 0 then
        local consumeEnergy = -energy / time
        local consumeMass = -mass / time
        View.BuildCostGroup.EnergyValue:SetText(string.format("%d (%d)",-energy,consumeEnergy))
        View.BuildCostGroup.MassValue:SetText(string.format("%d (%d)",-mass,consumeMass))

        View.BuildCostGroup.EnergyValue:SetColor("FFF05050")
        View.BuildCostGroup.MassValue:SetColor("FFF05050")
    end

    -- Upkeep Group
    local upkeepEnergy, upkeepMass = GetUpkeep(bp)
    local showUpkeep = false
    if upkeepEnergy ~= 0 or upkeepMass ~= 0 then
        View.UpkeepGroup.Label:SetText(LOC("<LOC uvd_0002>Yield"))
        View.UpkeepGroup.EnergyValue:SetText(string.format("%d",upkeepEnergy))
        View.UpkeepGroup.MassValue:SetText(string.format("%d",upkeepMass))
        if upkeepEnergy >= 0 then
            View.UpkeepGroup.EnergyValue:SetColor("FF50F050")
        else
            View.UpkeepGroup.EnergyValue:SetColor("FFF05050")
        end

        if upkeepMass >= 0 then
            View.UpkeepGroup.MassValue:SetColor("FF50F050")
        else
            View.UpkeepGroup.MassValue:SetColor("FFF05050")
        end
        showUpkeep = true
    elseif bp.Economy and (bp.Economy.StorageEnergy ~= 0 or bp.Economy.StorageMass ~= 0) then
        View.UpkeepGroup.Label:SetText(LOC("<LOC uvd_0006>Storage"))
        local upkeepEnergy = bp.Economy.StorageEnergy or 0
        local upkeepMass = bp.Economy.StorageMass or 0
        View.UpkeepGroup.EnergyValue:SetText(string.format("%d",upkeepEnergy))
        View.UpkeepGroup.MassValue:SetText(string.format("%d",upkeepMass))
        View.UpkeepGroup.EnergyValue:SetColor("FF50F050")
        View.UpkeepGroup.MassValue:SetColor("FF50F050")
        showUpkeep = true
    end

    return showUpkeep
end

function GetUpkeep(bp)
    local upkeepEnergy = (bp.Economy.ProductionPerSecondEnergy or 0) - (bp.Economy.MaintenanceConsumptionPerSecondEnergy or 0)
    local upkeepMass = (bp.Economy.ProductionPerSecondMass or 0) - (bp.Economy.MaintenanceConsumptionPerSecondMass or 0)
    upkeepEnergy = upkeepEnergy + (bp.ProductionPerSecondEnergy or 0) - (bp.MaintenanceConsumptionPerSecondEnergy or 0)
    upkeepMass = upkeepMass + (bp.ProductionPerSecondMass or 0) - (bp.MaintenanceConsumptionPerSecondMass or 0)

    if bp.EnhancementPresetAssigned then
        for _, v in bp.EnhancementPresetAssigned.Enhancements do
            local Enh = bp.Enhancements[v]
            upkeepEnergy = upkeepEnergy + (Enh.ProductionPerSecondEnergy or 0) - (Enh.MaintenanceConsumptionPerSecondEnergy or 0)
            upkeepMass = upkeepMass + (Enh.ProductionPerSecondMass or 0) - (Enh.MaintenanceConsumptionPerSecondMass or 0)
        end
    end

    return upkeepEnergy, upkeepMass
end

function OnNIS()
    if View then
        View:Hide()
    end
end

function Hide()
    View:Hide()
end

function SetLayout()
    import(UIUtil.GetLayoutFilename('unitviewDetail')).SetLayout()
end

function SetupUnitViewLayout(parent)
    if View then
        View:Destroy()
        View = nil
    end
    MapView = parent
    controls.MapView = MapView
    SetLayout()
    controls.View = View
    View:Hide()
    View:DisableHitTest(true)
end


end 