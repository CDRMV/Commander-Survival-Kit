#****************************************************************************
#**
#**  File     :  /cdimage/units/XRA0305/XRA0305_script.lua
#**  Author(s):  Drew Staltman, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Cybran Heavy Gunship Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CAirUnit = import('/lua/defaultunits.lua').AirUnit
local CAAMissileNaniteWeapon = import('/lua/cybranweapons.lua').CAAMissileNaniteWeapon
local CDFLaserDisintegratorWeapon = import('/lua/cybranweapons.lua').CDFLaserDisintegratorWeapon02
local CDFProtonCannonWeapon = import('/lua/cybranweapons.lua').CDFProtonCannonWeapon
CSKCA0302 = Class(CAirUnit) {
    
    Weapons = {
		FrontCannon01 = Class(CDFProtonCannonWeapon) {},
        Missiles1 = Class(CAAMissileNaniteWeapon) {},
        Disintegrator01 = Class(CDFLaserDisintegratorWeapon) {},
        Disintegrator02 = Class(CDFLaserDisintegratorWeapon) {},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
		local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )
		if version < 3652 then
		if DiskGetFileInfo('/lua/AI/CustomAIs_v2/ExtrasAI.lua') then
		if import('/lua/AI/CustomAIs_v2/ExtrasAI.lua').AI.Name == 'AI Patch LOUD' then
		self:GiveTacticalSiloAmmo(10)
		end
		
		else
		
		end
		else
		
		end

    end,
}
TypeClass = CSKCA0302