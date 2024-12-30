#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0304/UEA0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Strategic Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CAirUnit = import('/lua/defaultunits.lua').AirUnit
local CIFNaniteTorpedoWeapon = import('/lua/cybranweapons.lua').CIFNaniteTorpedoWeapon
local CWeapons = import('/lua/cybranweapons.lua')
local CDFHeavyDisintegratorWeapon = CWeapons.CDFLaserDisintegratorWeapon02

CSKCA0303 = Class(CAirUnit) {
    Weapons = {
        Bomb = Class(CIFNaniteTorpedoWeapon) {},
        AARailGun1 = Class(CDFHeavyDisintegratorWeapon) {},
    },
}

TypeClass = CSKCA0303
