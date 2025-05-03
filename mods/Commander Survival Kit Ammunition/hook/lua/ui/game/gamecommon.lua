local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 

local MyUnitIdTable = {

   
 -- New Units
 
 -- Aeon
 
 -- Structures
	  --uab8500=true, 
 
 -- UEF
   
 -- Land
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
	-- Adds icons to the unitselectionwindow
	local oldGetUnitIconFileNames = GetUnitIconFileNames
	function GetUnitIconFileNames(blueprint)
		if MyUnitIdTable[blueprint.Display.IconName] then
			local iconName = IconPath .. "/icons/units/" .. blueprint.Display.IconName .. "_icon.dds"
			local upIconName = IconPath .. "/icons/units/" .. blueprint.Display.IconName .. "_icon.dds"
			local downIconName = IconPath .. "/icons/units/" .. blueprint.Display.IconName .. "_icon.dds"
			local overIconName = IconPath .. "/icons/units/" .. blueprint.Display.IconName .. "_icon.dds"
			return iconName, upIconName, downIconName, overIconName
		else
			return oldGetUnitIconFileNames(blueprint)
		end
	end

else

end 