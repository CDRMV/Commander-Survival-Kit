local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function
	LOG('Commander Survival Kit Units: [unitview.lua '..debug.getinfo(1).currentline..'] - Gameversion is older then 3652. Hooking "UpdateWindow" to add our own unit icons')

local MyUnitIdTable = {

   
 -- New Units
 
 -- Aeon
 
  -- Air
   	  cskaa0200=true, 
 
  -- Land
  
      cskal0300=true, 
 
  -- Structures
  
  
 
 -- UEF
   
 -- Air  	
   
      cskta0210=true, 
	  cskta0310=true, 
	  cskta0311=true, 
	  cskta0312=true, 
	  cskta0400=true, 
	  
 -- Land 
 	  csktl0100=true,  
	  csktl0101=true,
 	  csktl0200=true, 
	  csktl0201=true, 
	  csktl0202=true, 
	  csktl0300=true, 
	  csktl0310=true, 
	  csktl0311=true, 
	  csktl0312=true,
	  csktl0313=true, 
	  csktl0314=true,  
	  csktl0315=true,  
	  csktl0316=true,  
	  csktl0317=true,  
	  
 -- Naval	
      cskts0110=true,  
      cskts0200=true, 
	  cskts0201=true, 
	  cskts0202=true, 
	  cskts0300=true, 
	  cskts0301=true, 
	  cskts0302=true, 
	  cskts0400=true, 
	  
-- Structures
	  ueb8000=true,	
	  
-- Cybran

 -- Naval	
	  cskcs0220=true, 

 -- Land	
	  cskcl0400=true, 	

-- Structures 	  

 -- Seraphim
 
 -- Structures	 
	   

}

local IconPath = "/Mods/Commander Survival Kit Units"
	local oldUpdateWindow = UpdateWindow
	function UpdateWindow(info)
		oldUpdateWindow(info)
		if MyUnitIdTable[info.blueprintId] then
			controls.icon:SetTexture(IconPath .. '/icons/units/' .. info.blueprintId .. '_icon.dds')
		end
	end

else
	LOG('Commander Survival Kit Units: [unitview.lua '..debug.getinfo(1).currentline..'] - Gameversion is 3652 or newer. No need to insert the unit icons by our own function.')
end -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function