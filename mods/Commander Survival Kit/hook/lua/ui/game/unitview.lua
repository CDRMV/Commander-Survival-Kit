local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function
	LOG('Commander Survival Kit: [unitview.lua '..debug.getinfo(1).currentline..'] - Gameversion is older then 3652. Hooking "UpdateWindow" to add our own unit icons')

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
   
 -- New Units
 
 -- Aeon
 
 -- Structures
	  uab8500=true, 
 
 -- UEF
   
 -- Air  	
   
      cskta0210=true, 
	  cskta0310=true, 
	  cskta0311=true, 
	  cskta0312=true, 
	  cskta0400=true, 
	  
 -- Land  
	  csktl0310=true, 
	  csktl0311=true, 
	  csktl0312=true,
	  csktl0313=true, 
	  csktl0314=true,  
	  csktl0315=true,  
	  
 -- Naval	
      cskts0110=true,  
      cskts0200=true, 
	  cskts0201=true, 
	  cskts0202=true, 
	  
-- Structures
	  ueb8000=true,
	  ueb8500=true, 	  
	  
-- Cybran

 -- Naval	
	  cskcs0220=true, 	

-- Structures
	  urb8500=true, 	

 -- Seraphim
 
 -- Structures
	  xsb8500=true, 

}

local IconPath = "/Mods/Commander Survival Kit"
	local oldUpdateWindow = UpdateWindow
	function UpdateWindow(info)
		oldUpdateWindow(info)
		if MyUnitIdTable[info.blueprintId] then
			controls.icon:SetTexture(IconPath .. '/icons/units/' .. info.blueprintId .. '_icon.dds')
		end
	end

else
	LOG('Commander Survival Kit: [unitview.lua '..debug.getinfo(1).currentline..'] - Gameversion is 3652 or newer. No need to insert the unit icons by our own function.')
end -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function