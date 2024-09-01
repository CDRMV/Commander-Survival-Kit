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
local TDFHeavyPlasmaCannonWeapon = import('/lua/terranweapons.lua').TDFHeavyPlasmaCannonWeapon
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon

CSKTL0321 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TDFHeavyPlasmaCannonWeapon) {
        },
		Riotgun01 = Class(TDFMachineGunWeapon) {
        },
    },
}

TypeClass = CSKTL0321