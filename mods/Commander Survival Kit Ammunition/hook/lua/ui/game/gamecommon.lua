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
 
    -- Land
  	cskasl0100=true,
 	cskasl0200=true,
	cskasl0300=true,
	
	cskasltest01=true,
 
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