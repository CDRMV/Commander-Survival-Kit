local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function



LOG('Commander Survival Kit Units: [uiutil.lua '..debug.getinfo(1).currentline..'] - Gameversion is older then 3652. Hooking "UIFile" to add our own unit icons')

local MyUnitIdTable = {
   
 -- New Units
 
 -- Aeon
 
 -- Air
      cskaa0100=true, 
   	  cskaa0200=true, 
	  cskaa0201=true, 
	  cskaa0300=true, 
	  cskaa0301=true,
	  cskaa0302=true, 	  
	  cskaa0400=true,
	  cskaa0401=true,
 
 -- Land
  
      cskal0300=true,
      cskal0302=true, 
      cskal0303=true,
      cskal0304=true, 
      cskal0305=true,	  
	  cskal0400=true, 
 	  cskal0401=true, 
	  cskal0402=true, 
	  cskal0404=true, 
	  
 -- Structures
	  uabab0201=true, 
	  uabab0300=true, 
	  
 -- Naval
	  cskas0300=true,
  
 
 -- UEF
   
 -- Air  	
   
      cskta0210=true, 
	  cskta0310=true, 
	  cskta0311=true, 
	  cskta0312=true, 
	  cskta0313=true,
	  cskta0313b=true,
	  cskta0314=true, 
	  cskta0314b=true, 
	  cskta0315=true, 
	  cskta0315b=true, 
	  cskta0400=true, 
	  cskta0401=true, 
	  
 -- Land 
 
 	  cfcsktl0303=true,
	  scsktl0100=true,
	  scsktl0200=true,
 
 	  csktl0100=true,  
	  csktl0101=true,
 	  csktl0200=true, 
	  csktl0201=true, 
	  csktl0202=true, 
	  csktl0203=true, 
	  csktl0204=true, 
	  csktl0300=true, 
	  csktl0301=true,
	  csktl0302=true, 
	  csktl0303=true,	  
	  csktl0310=true, 
	  csktl0311=true, 
	  csktl0312=true,
	  csktl0313=true, 
	  csktl0314=true,  
	  csktl0315=true,  
	  csktl0316=true,  
	  csktl0317=true,  
	  csktl0318=true,  
	  csktl0319=true,  
	  csktl0320=true, 
	  csktl0321=true, 
	  csktl0322=true, 
	  csktl0323=true,
	  csktl0324=true,
	  csktl0400=true, 
	  
 -- Naval	
      cskts0110=true,  
      cskts0200=true, 
	  cskts0201=true, 
	  cskts0202=true, 
	  cskts0300=true, 
	  cskts0301=true, 
	  cskts0302=true, 
	  cskts0303=true, 
	  cskts0400=true, 
	  
-- Structures
	  ueb5104=true,
	  ueb5105=true,
	  uebtb0102=true,
	  uebtb0200=true,	
	  uebtb0201=true,
	  uebtb0202=true,	
	  uebtb0203=true,	
	  uebtb0300=true,
	  uebtb0301=true,
	  uebtb0302=true,
	  uebtb0303=true,
	  uebtb0304=true,
	  uebtb0400=true,	
	  
-- Cybran

 -- Air
	  cskca0200=true, 
	  cskca0201=true, 
	  cskca0300=true, 
	  cskca0301=true, 
	  cskca0302=true, 
	  cskca0303=true, 
	  cskca0400=true, 
	  
 -- Naval	
	  cskcs0220=true, 

 -- Land	
	  cfcskcl0100=true,
  	  cfcskcl0320=true,
 
	  cskcl0101=true,
  	  cskcl0201=true,
	  cskcl0202=true, 
	  cskcl0203=true, 
	  cskcl0204=true,
      cskcl0205=true, 	  
 	  cskcl0300=true,
 	  cskcl0301=true, 	
 	  cskcl0302=true, 	
 	  cskcl0303=true, 	
 	  cskcl0304=true, 	
 	  cskcl0305=true, 
 	  cskcl0306=true, 	
 	  cskcl0307=true,
 	  cskcl0308=true, 	
 	  cskcl0309=true,
	  cskcl0310=true,
	  cskcl0311=true, 
	  cskcl0312=true, 	  
 	  cskcl0320=true, 		  
	  cskcl0400=true, 	
	  cskcl0401=true, 
	  cskcl0402=true, 
	  cskcl0403=true, 		  
	  cskcl0405=true, 	  

-- Structures 

	  urbcb0102=true,
	  urbcb0201=true, 
	  urbcb0300=true,
	  urbcb0400=true,
	  urbcb0401=true,

 -- Seraphim
 
 -- Land
 	  csksl0300=true, 
	  csksl0301=true, 
	  csksl0302=true,
	  csksl0303=true, 
	  csksl0304=true,
	  csksl0305=true, 	
	  csksl0320=true,
	  csksl0321=true, 
 -- Air
      csksa0100=true, 
   	  csksa0200=true, 
	  csksa0300=true,
	  csksa0301=true, 	  
      csksa0302=true,
	  csksa0303=true,
	  
 -- Structures	  

}
local IconPath = "/Mods/Commander Survival Kit Units"
	-- Adds icons to the engeneer/factory buildmenu
	local oldUIFile = UIFile
	function UIFile(filespec)
		local skins = import('/lua/skins/skins.lua').skins
		local visitingSkin = currentSkin()
		local IconName = string.gsub(filespec,'_icon.dds','')
		IconName = string.gsub(IconName,'/icons/units/','')
		if MyUnitIdTable[IconName] then
			local curfile =  IconPath .. filespec
			return curfile
		end
		return oldUIFile(filespec)
	end
	
else 	
function UIFile(filespec, checkMods)
    if UIFileBlacklist[filespec] then return filespec end
    local skins = import('/lua/skins/skins.lua').skins
    local useSkin = currentSkin()
    local currentPath = skins[useSkin].texturesPath
    local origPath = currentPath
	
    if useSkin == nil or currentPath == nil then
        return nil
    end

    if not UIFileCache[currentPath .. filespec] then
        local found = false

        if useSkin == 'default' then
            found = currentPath .. filespec
        else
            while not found and useSkin do
                found = currentPath .. filespec
                if not DiskGetFileInfo(found) then
                    -- Check mods
                    local inmod = false
                    if checkMods then
                        if __active_mods then
                            for id, mod in __active_mods do
                                -- Unit Icons
                                if DiskGetFileInfo(mod.location .. filespec) then
                                    found = mod.location .. filespec
                                    inmod = true
                                    break
                                -- ACU Enhancements
                                elseif DiskGetFileInfo(mod.location .. currentPath .. filespec) then
                                    found = mod.location .. currentPath .. filespec
                                    inmod = true
                                    break
                                end
                            end
                        end
                    end

                    if not inmod then
                        found = false
                        useSkin = skins[useSkin].default
                        if useSkin then
                            currentPath = skins[useSkin].texturesPath
                        end
                    end
                end
            end
        end

        if not found then
            -- don't print error message if "filespec" is a valid path
            if not DiskGetFileInfo(filespec) then
                SPEW('[uiutil.lua, function UIFile()] - Unable to find file:'.. origPath .. filespec)
            end
            found = filespec
        end

        UIFileCache[origPath .. filespec] = found
    end
    return UIFileCache[origPath .. filespec]
end
	LOG('Commander Survival Kit Units: [uiutil.lua '..debug.getinfo(1).currentline..'] - Gameversion is 3652 or newer. No need to insert the unit icons by our own function.')
end -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function