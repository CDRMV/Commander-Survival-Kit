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
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TIFArtilleryWeapon
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon

CSKTL0323 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
        },
		FrontGun = Class(TDFRiotWeapon) {
        },
		RSecondary = Class(TDFGaussCannonWeapon) {
        },
		LSecondary = Class(TDFGaussCannonWeapon) {
        },
    },
}

TypeClass = CSKTL0323