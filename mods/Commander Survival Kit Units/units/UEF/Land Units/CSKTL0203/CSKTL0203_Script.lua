#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0304/UEL0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Heavy Artillery Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon

CSKTL0203 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
        },
    },
}

TypeClass = CSKTL0203