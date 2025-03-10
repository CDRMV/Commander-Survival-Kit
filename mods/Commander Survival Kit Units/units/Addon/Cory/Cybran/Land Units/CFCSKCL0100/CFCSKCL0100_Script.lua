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
local CDFProtonCannonWeapon = import('/lua/cybranweapons.lua').CDFProtonCannonWeapon

CSKCL0100 = Class(CLandUnit) {
    Weapons = {
		MainGun = Class(CDFProtonCannonWeapon) {},
    },
}

TypeClass = CSKCL0100