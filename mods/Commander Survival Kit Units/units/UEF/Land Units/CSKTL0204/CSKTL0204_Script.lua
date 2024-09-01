#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0304/UEL0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Heavy Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TAMPhalanxWeapon = import('/lua/terranweapons.lua').TAMPhalanxWeapon

CSKTL0204 = Class(TLandUnit) {
    Weapons = {
        Turret01 = Class(TAMPhalanxWeapon) {},
    },
}

TypeClass = CSKTL0204