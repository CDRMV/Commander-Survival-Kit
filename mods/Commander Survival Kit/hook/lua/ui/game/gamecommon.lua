local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function
	LOG('Commander Survival Kit: [gamecommon.lua '..debug.getinfo(1).currentline..'] - Gameversion is older then 3652. Hooking "GetUnitIconFileNames" to add our own unit icons')

local MyUnitIdTable = {

 

 -- Tech 1 Air Transports (Reinforcement Version)

   uaa0107b=true, 
   uea0107b=true, 
   ura0107b=true, 
   xsa0107b=true, 

 -- Tech 2 Air Transports (Reinforcement Version)

   uaa0104b=true, 
   uea0104b=true, 
   ura0104b=true, 
   xsa0104b=true, 
   
 -- Cybran Experimental Mobile Artillery (Required because of Brewlan)
 
    url0401b=true,
   
 -- New Units
 
 -- Aeon
 
 -- Structures
	  uab8500=true, 
	  uab8501=true, 
	  uab8502=true, 
	  uab8503=true,
	  uab8503b=true,
	  uab8503c=true,
	  uab8503d=true,
	  uab8503e=true,	  
	  uab8504=true,
	  uab8504b=true, 
	  uab8504c=true, 
	  uab8504d=true, 
	  uab8504e=true, 
	  uab8800=true, 
	  uab8801=true, 
 	  uab8802=true, 		  
 
 -- UEF
 
 -- Air
   xea0010=true,
   xea0011=true,
   
-- Structures
	  ueb8500=true, 	  
	  ueb8501=true, 
	  ueb8502=true,
	  ueb8503=true,
	  ueb8503b=true, 
	  ueb8503c=true, 
	  ueb8503d=true, 
	  ueb8503e=true, 	  
	  ueb8504=true,
	  ueb8504b=true,
	  ueb8504c=true,
	  ueb8504d=true,
	  ueb8504e=true,
	  ueb8800=true,
	  ueb8801=true,
	  ueb8802=true, 
	  uerdt8800=true,
	  uerdt8801=true,
	  uerdt8802=true, 
	  
-- Cybran

-- Structures
	  urb8500=true, 
	  urb8501=true,
 	  urb8502=true, 
	  urb8503=true,
	  urb8503b=true,
	  urb8503c=true,
	  urb8503d=true,
	  urb8503e=true,
 	  urb8504=true,
	  urb8504b=true,
      urb8504c=true,
	  urb8504d=true,
	  urb8504e=true,
	  urb8800=true,
	  urb8801=true,
	  urb8802=true,
 	  dcrb8800=true, 
	  dcrb8801=true, 
	  dcrb8802=true,	  
	  
 -- Seraphim
 
 -- Structures
	  xsb8500=true, 	
	  xsb8501=true, 
	  xsb8502=true, 	  
	  xsb8503=true,
	  xsb8503b=true, 
	  xsb8503c=true, 
	  xsb8503d=true, 
	  xsb8503e=true, 	  
	  xsb8504=true, 
	  xsb8504b=true,
	  xsb8504c=true,
	  xsb8504d=true,
	  xsb8504e=true,
	  xsb8800=true,
	  xsb8801=true,
	  xsb8802=true,
   
}

	local IconPath = "/Mods/Commander Survival Kit"
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
	LOG('Commander Survival Kit: [gamecommon.lua '..debug.getinfo(1).currentline..'] - Gameversion is 3652 or newer. No need to insert the unit icons by our own function.')
end -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function