local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 


local MyUnitIdTable = {

 -- New Units
 
 -- Aeon
 
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
	end

else

	local oldUpdateWindow = UpdateWindow
	function UpdateWindow(info)
		oldUpdateWindow(info)
		
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
	end
	LOG('Commander Survival Kit Units: [unitview.lua '..debug.getinfo(1).currentline..'] - Gameversion is 3652 or newer. No need to insert the unit icons by our own function.')
end -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function