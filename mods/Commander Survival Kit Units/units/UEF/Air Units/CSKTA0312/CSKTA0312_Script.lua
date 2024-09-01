#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0304/UEA0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Strategic Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TIFSmallYieldNuclearBombWeapon = import('/lua/terranweapons.lua').TIFSmallYieldNuclearBombWeapon
local TAirToAirLinkedRailgun = import('/lua/terranweapons.lua').TAirToAirLinkedRailgun

CSKTA0312 = Class(TAirUnit) {
    Weapons = {
        Bomb = Class(TIFSmallYieldNuclearBombWeapon) {},
        AARailGun1 = Class(TAirToAirLinkedRailgun) {},
        AARailGun1 = Class(TAirToAirLinkedRailgun) {},
    },
}

TypeClass = CSKTA0312
