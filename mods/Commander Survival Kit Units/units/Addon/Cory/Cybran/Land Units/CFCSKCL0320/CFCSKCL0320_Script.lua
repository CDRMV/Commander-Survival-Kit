#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0202/URL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Tank Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/defaultunits.lua').MobileUnit
local CDFHeavyDisintegratorWeapon = import('/lua/cybranweapons.lua').CDFLaserDisintegratorWeapon02
local CDFProtonCannonWeapon = import('/lua/cybranweapons.lua').CDFProtonCannonWeapon

CSKCL0320 = Class(CLandUnit) {
    Weapons = {
        SecGun = Class(CDFHeavyDisintegratorWeapon) {},
		MainGun = Class(CDFProtonCannonWeapon) {},
    },
}

TypeClass = CSKCL0320