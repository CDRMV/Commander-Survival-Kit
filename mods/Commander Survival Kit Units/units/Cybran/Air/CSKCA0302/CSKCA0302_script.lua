#****************************************************************************
#**
#**  File     :  /cdimage/units/XRA0305/XRA0305_script.lua
#**  Author(s):  Drew Staltman, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Cybran Heavy Gunship Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CAirUnit = import('/lua/defaultunits.lua').MobileUnit
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
}
TypeClass = CSKCA0302