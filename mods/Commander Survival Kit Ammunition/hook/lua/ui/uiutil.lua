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

end 