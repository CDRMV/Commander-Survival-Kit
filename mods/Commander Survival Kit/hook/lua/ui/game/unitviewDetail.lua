do 

local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then
if DiskGetFileInfo('/lua/AI/CustomAIs_v2/ExtrasAI.lua') then
if import('/lua/AI/CustomAIs_v2/ExtrasAI.lua').AI.Name == 'AI Patch LOUD' then

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

		if bp.Description then
		WrapAndPlaceText(nil, nil, nil, nil, nil, nil, LOC(bp.Description), View.Description)
		else

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

function WrapAndPlaceText2(air, physics, intel, weapons, abilities, capCost, text, control)
	
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
			if not LOUDFIND(weapon.Label, 'Dummy') and (not LOUDFIND(weapon.Label, 'Tractor')) and not LOUDFIND(weapon.Label, 'Painter') then
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

else

function ShowEnhancement(bp, bpID, iconID, iconPrefix, userUnit)
LOG(bp.Description)
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
		
		if bp.Description then
        WrapAndPlaceText(nil, LOC(bp.Description), View.Description)
		else
		        
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


end

else
function ShowEnhancement(bp, bpID, iconID, iconPrefix, userUnit)
LOG(bp.Description)
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
		
		if bp.Description then
        WrapAndPlaceText(nil, LOC(bp.Description), View.Description)
		else
		        
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

end

else

function ShowEnhancement(bp, bpID, iconID, iconPrefix, userUnit)
LOG(bp.Description)
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
        time, energy, mass = import("/lua/game.lua").GetConstructEconomyModel(userUnit, bp)
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
	
	if bp.Description then
        WrapAndPlaceText2(nil, nil, LOC(bp.Description), View.Description)
	else

    if View.Description then
        -- If enhancement of preset, then remove extension. (ual0301_Engineer -> ual0301)
        if string.find(bpID, '_') then
            bpID = string.sub(bpID, 1, string.find(bpID, "_[^_]*$")-1)
        end
        WrapAndPlaceText(nil, nil, bpID.."-"..iconID, View.Description)
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
end

function WrapAndPlaceText2(bp, builder, text, control)
    local lines = {}
    local blocks = {}
    --Unit description
    local text = LOC(text)
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
                local headerString = LOC('<LOC uvd_ArmorType>')..LOC('<LOC at_'..armorType..'>')
                local spaceCount = (195 - control.Value[1]:GetStringAdvance(headerString)) / spaceWidth
                local takesAdjustedDamage = false
                for _, armor in armorDefinition do
                    if armor[1] == armorType then
                        local row = 0
                        local armorDetails = ''
                        local elemCount = table.getsize(armor)
                        for i = 2, elemCount do
                            if string.find(armor[i], '1.0') > 0 then continue end
                            takesAdjustedDamage = true
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

                if takesAdjustedDamage then
                    headerString = headerString..string.rep(' ', spaceCount)..LOC('<LOC uvd_DamageTaken>')
                end
                table.insert(lines, 1, headerString)

                table.insert(blocks, {color = 'FF7FCFCF', lines = lines})
            end
            --Weapons
            if not table.empty(bp.Weapon) then
                local weapons = {upgrades = {normal = {}, death = {}},
                                    basic = {normal = {}, death = {}}}
                local totalWeaponCount = 0
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
                    if not dest.death then
                        totalWeaponCount = totalWeaponCount + 1
                    end
                end
                for k, v in weapons do
                    if not table.empty(v.normal) or not table.empty(v.death) then
                        table.insert(blocks, {color = UIUtil.fontColor, lines = {LOC('<LOC uvd_'..k..'>')..':'}})
                    end
                    local totalDirectFireDPS = 0
                    local totalIndirectFireDPS = 0
                    local totalNavalDPS = 0
                    local totalAADPS = 0
                    for name, weapon in v.normal do
                        local info = weapon.info
                        local weaponDetails1 = LOCStr(name)..' ('..LOCStr(info.WeaponCategory)..') '
                        if info.ManualFire then
                            weaponDetails1 = weaponDetails1..LOC('<LOC uvd_ManualFire>')
                        end
                        local weaponDetails2
                        -- matches the requirements in weapon.lua for a projectile to have nuke damage
                        if info.NukeOuterRingDamage and info.NukeOuterRingRadius and info.NukeOuterRingTicks and info.NukeOuterRingTotalTime
                            and info.NukeInnerRingDamage and info.NukeInnerRingRadius and info.NukeInnerRingTicks and info.NukeInnerRingTotalTime
                        then
                            weaponDetails2 = string.format(LOC('<LOC uvd_0014>Damage: %.8g - %.8g, Splash: %.3g - %.3g')..', '..LOC('<LOC uvd_Range>'),
                                info.NukeInnerRingDamage + info.NukeOuterRingDamage, info.NukeOuterRingDamage,
                                info.NukeInnerRingRadius, info.NukeOuterRingRadius, info.MinRadius, info.MaxRadius)
                        else
                            --DPS Calculations
                            local Damage = info.Damage
                            if info.DamageToShields then
                                Damage = Damage + info.DamageToShields
                            end
                            if info.BeamLifetime > 0 then
                                Damage = Damage * (1 + MathFloor(MATH_IRound(info.BeamLifetime*10)/(MATH_IRound(info.BeamCollisionDelay*10)+1)))
                            else
                                Damage = Damage * (info.DoTPulses or 1) + (info.InitialDamage or 0)
                                local ProjectilePhysics = __blueprints[info.ProjectileId].Physics
                                while ProjectilePhysics do
                                    Damage = Damage * (ProjectilePhysics.Fragments or 1)
                                    ProjectilePhysics = __blueprints[string.lower(ProjectilePhysics.FragmentId or '')].Physics
                                end
                            end

                            --Simulate the firing cycle to get the reload time.
                            local CycleProjs = 0 --Projectiles fired per cycle
                            local CycleTime = 0

                            --Various delays need to be adapted to game tick format.
                            local FiringCooldown = math.max(0.1, MATH_IRound(10 / info.RateOfFire) / 10)
                            local ChargeTime = info.RackSalvoChargeTime or 0
                            if ChargeTime > 0 then
                                ChargeTime = math.max(0.1, MATH_IRound(10 * ChargeTime) / 10)
                            end
                            local MuzzleDelays = info.MuzzleSalvoDelay or 0
                            if MuzzleDelays > 0 then
                                MuzzleDelays = math.max(0.1, MATH_IRound(10 * MuzzleDelays) / 10)
                            end
                            local MuzzleChargeDelay = info.MuzzleChargeDelay or 0
                            if MuzzleChargeDelay and MuzzleChargeDelay > 0 then
                                MuzzleDelays = MuzzleDelays + math.max(0.1, MATH_IRound(10 * MuzzleChargeDelay) / 10)
                            end
                            local ReloadTime = info.RackSalvoReloadTime or 0
                            if ReloadTime > 0 then
                                ReloadTime = math.max(0.1, MATH_IRound(10 * ReloadTime) / 10)
                            end

                            -- Keep track that the firing cycle has a constant rate
                            local singleShot = true
                            --OnFire is called from FireReadyState at this point, so we need to track time
                            --to know how much the fire rate cooldown has progressed during our fire cycle.
                            local SubCycleTime = 0
                            local RackBones = info.RackBones
                            if RackBones then --Teleport damage will not have a rack bone
                                --Save the rack count so we can correctly calculate the final rack's fire cooldown
                                local RackCount = table.getsize(RackBones)
                                for index, Rack in RackBones do
                                    local MuzzleCount = info.MuzzleSalvoSize
                                    if info.MuzzleSalvoDelay == 0 then
                                        MuzzleCount = table.getsize(Rack.MuzzleBones)
                                    end
                                    if MuzzleCount > 1 or info.RackFireTogether and RackCount > 1 then singleShot = false end
                                    CycleProjs = CycleProjs + MuzzleCount

                                    SubCycleTime = SubCycleTime + MuzzleCount * MuzzleDelays
                                    if not info.RackFireTogether and index ~= RackCount then
                                        if FiringCooldown <= SubCycleTime + ChargeTime then
                                            CycleTime = CycleTime + SubCycleTime + ChargeTime + math.max(0.1, FiringCooldown - SubCycleTime - ChargeTime)
                                        else
                                            CycleTime = CycleTime + FiringCooldown
                                        end
                                        SubCycleTime = 0
                                    end
                                end
                            end
                            if FiringCooldown <= (SubCycleTime + ChargeTime + ReloadTime) then
                                CycleTime = CycleTime + SubCycleTime + ReloadTime + ChargeTime + math.max(0.1, FiringCooldown - SubCycleTime - ChargeTime - ReloadTime)
                            else
                                CycleTime = CycleTime + FiringCooldown
                            end

                            local DPS = 0
                            if not info.ManualFire and info.WeaponCategory ~= 'Kamikaze' and info.WeaponCategory ~= 'Defense' then
                                --Round DPS, or else it gets floored in string.format.
                                DPS = MATH_IRound(Damage * CycleProjs / CycleTime)
                                weaponDetails1 = weaponDetails1..LOCF('<LOC uvd_DPS>', DPS)
                                -- Do not calulcate the DPS total if the unit only has one valid weapon.
                                if totalWeaponCount > 1 then
                                    if (info.WeaponCategory == 'Direct Fire' or info.WeaponCategory == 'Direct Fire Naval' or info.WeaponCategory == 'Direct Fire Experimental') and not info.IgnoreIfDisabled then
                                        totalDirectFireDPS = totalDirectFireDPS + DPS * weapon.count
                                    elseif info.WeaponCategory == 'Indirect Fire' or info.WeaponCategory == 'Missile' or info.WeaponCategory == 'Artillery' or info.WeaponCategory == 'Bomb' then
                                        totalIndirectFireDPS = totalIndirectFireDPS + DPS * weapon.count
                                    elseif info.WeaponCategory == 'Anti Navy' then
                                        totalNavalDPS = totalNavalDPS + DPS * weapon.count
                                    elseif info.WeaponCategory == 'Anti Air' then
                                        totalAADPS = totalAADPS + DPS * weapon.count
                                    end
                                end
                            end

                            -- Avoid saying a unit fires a salvo when it in fact has a constant rate of fire
                            if singleShot and ReloadTime == 0 and CycleProjs > 1 then
                                CycleTime = CycleTime / CycleProjs
                                CycleProjs = 1
                            end

                            if CycleProjs > 1 then
                                weaponDetails2 = string.format(LOC('<LOC uvd_0015>Damage: %.8g x%d, Splash: %.3g')..', '..LOC('<LOC uvd_Range>')..', '..LOC('<LOC uvd_Reload>'),
                                Damage, CycleProjs, info.DamageRadius, info.MinRadius, info.MaxRadius, CycleTime)
                            -- Do not display Reload stats for Kamikaze weapons
                            elseif info.WeaponCategory == 'Kamikaze' then
                                weaponDetails2 = string.format(LOC('<LOC uvd_0010>Damage: %.7g, Splash: %.3g')..', '..LOC('<LOC uvd_Range>'),
                                Damage, info.DamageRadius, info.MinRadius, info.MaxRadius)
                            -- Do not display 'Range' and Reload stats for 'Teleport in' weapons
                            elseif info.WeaponCategory == 'Teleport' then
                                weaponDetails2 = string.format(LOC('<LOC uvd_0010>Damage: %.7g, Splash: %.3g'),
                                Damage, info.DamageRadius)
                            else
                                weaponDetails2 = string.format(LOC('<LOC uvd_0010>Damage: %.7g, Splash: %.3g')..', '..LOC('<LOC uvd_Range>')..', '..LOC('<LOC uvd_Reload>'),
                                Damage, info.DamageRadius, info.MinRadius, info.MaxRadius, CycleTime)
                            end

                        end
                        if weapon.count > 1 then
                            weaponDetails1 = weaponDetails1..' x'..weapon.count
                        end
                        table.insert(blocks, {color = UIUtil.fontColor, lines = {weaponDetails1}})

                        if info.DamageType == 'Overcharge' then
                            table.insert(blocks, {color = 'FF5AB34B', lines = {weaponDetails2}}) -- Same color as auto-overcharge highlight (autocast_green.dds)
                        elseif info.WeaponCategory == 'Kamikaze' then
                            table.insert(blocks, {color = 'FFFF2C2C', lines = {weaponDetails2}})
                        else
                            table.insert(blocks, {color = 'FFFFB0B0', lines = {weaponDetails2}})
                        end

                        if info.EnergyRequired > 0 and info.EnergyDrainPerSecond > 0 then
                            local weaponDetails3 = string.format(LOC('<LOC uvd_cost>Charge Cost: -%d E (-%d E/s)'), info.EnergyRequired, info.EnergyDrainPerSecond)
                            table.insert(blocks, {color = 'FFFF9595', lines = {weaponDetails3}})
                        end

                        local ProjectileEco = __blueprints[info.ProjectileId].Economy
                        if ProjectileEco and (ProjectileEco.BuildCostMass > 0 or ProjectileEco.BuildCostEnergy > 0) and ProjectileEco.BuildTime > 0 then
                            local weaponDetails4 = string.format(LOC('<LOC uvd_missile>Missile Cost: %d M, %d E, %d BT'), ProjectileEco.BuildCostMass, ProjectileEco.BuildCostEnergy, ProjectileEco.BuildTime)
                            table.insert(blocks, {color = 'FFFF9595', lines = {weaponDetails4}})
                        end
                    end
                    lines = {}
                    for name, weapon in v.death do
                        local info = weapon.info
                        local weaponDetails = LOCStr(name)..' ('..LOCStr(info.WeaponCategory)..') '
                        if info.NukeInnerRingDamage then
                            weaponDetails = weaponDetails..LOCF('<LOC uvd_0014>Damage: %.8g - %.8g, Splash: %.3g - %.3g',
                                info.NukeInnerRingDamage + info.NukeOuterRingDamage, info.NukeOuterRingDamage,
                                info.NukeInnerRingRadius, info.NukeOuterRingRadius)
                        else
                            weaponDetails = weaponDetails..LOCF('<LOC uvd_0010>Damage: %.7g, Splash: %.3g',
                                info.Damage, info.DamageRadius)
                        end
                        if weapon.count > 1 then
                            weaponDetails = weaponDetails..' x'..weapon.count
                        end
                        table.insert(lines, weaponDetails)
                        table.insert(blocks, {color = 'FFFF0000', lines = lines})
                    end
                    
                    -- Only display the totalDPS stats if they are greater than 0.
                    -- Prevent the totalDPS stats from being displayed under the 'Upgrades' tab and avoid the doubling of empty lines.
                    local upgradesAvailable = not table.empty(weapons.upgrades.normal) or not table.empty(weapons.upgrades.death)
                    if k == 'basic' then
                        if totalDirectFireDPS > 0 then
                            table.insert(blocks, {color = 'FFA600', lines = {LOCF('<LOC uvd_0018>', totalDirectFireDPS)}})
                        end
                        if totalIndirectFireDPS > 0 then
                            table.insert(blocks, {color = 'FFA600', lines = {LOCF('<LOC uvd_0019>', totalIndirectFireDPS)}})
                        end
                        if totalNavalDPS > 0 then
                            table.insert(blocks, {color = 'FFA600', lines = {LOCF('<LOC uvd_0020>', totalNavalDPS)}})
                        end
                        if totalAADPS > 0 then
                            table.insert(blocks, {color = 'FFA600', lines = {LOCF('<LOC uvd_0021>', totalAADPS)}})
                        end
                        if not upgradesAvailable then
                            table.insert(blocks, {color = UIUtil.fontColor, lines = {''}}) -- Empty line
                        end
                    end
                    -- Avoid the doubling of empty lines when the unit has upgrades.
                    if upgradesAvailable then
                        table.insert(blocks, {color = UIUtil.fontColor, lines = {''}}) -- Empty line
                    end
                end
            end
        end
        --Other parameters
        lines = {}
        table.insert(lines, LOCF("<LOC uvd_0013>Vision: %d, Underwater Vision: %d, Regen: %.3g, Cap Cost: %.3g",
            bp.Intel.VisionRadius, bp.Intel.WaterVisionRadius, bp.Defense.RegenRate, bp.General.CapCost))

        if (bp.Physics.MotionType ~= 'RULEUMT_Air' and bp.Physics.MotionType ~= 'RULEUMT_None')
        or (bp.Physics.AltMotionType ~= 'RULEUMT_Air' and bp.Physics.AltMotionType ~= 'RULEUMT_None') then
            table.insert(lines, LOCF("<LOC uvd_0012>Speed: %.3g, Reverse: %.3g, Acceleration: %.3g, Turning: %d",
                bp.Physics.MaxSpeed, bp.Physics.MaxSpeedReverse, bp.Physics.MaxAcceleration, bp.Physics.TurnRate))
        end
        
        -- Display the TransportSpeedReduction stat in the UI.
        -- Naval units and land experimentals also have this stat, but it since it is not relevant for non-modded games, we do not display it by default.
        -- If a mod wants to display the TransportSpeedReduction stat for naval units or experimentals, this file can be hooked.
        if bp.Physics.TransportSpeedReduction and not (bp.CategoriesHash.NAVAL or bp.CategoriesHash.EXPERIMENTAL) then
            table.insert(lines, LOCF("<LOC uvd_0017>Transport Speed Reduction: %.3g",
            bp.Physics.TransportSpeedReduction))
        end

        table.insert(blocks, {color = 'FFB0FFB0', lines = lines})
    end
    CreateLines(control, blocks)
end

end

end