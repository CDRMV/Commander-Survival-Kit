#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0202/UEL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CLandUnit = import('/lua/defaultunits.lua').MobileUnit
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CDFLaserHeavyWeapon = CybranWeaponsFile.CDFLaserHeavyWeapon

CSKCL0203 = Class(CLandUnit) {
    Weapons = {
        MainGun = Class(CDFLaserHeavyWeapon) {
        }
    },
}

TypeClass = CSKCL0203