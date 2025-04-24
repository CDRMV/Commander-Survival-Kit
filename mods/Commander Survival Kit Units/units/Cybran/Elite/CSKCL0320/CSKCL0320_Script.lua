#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0202/URL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/defaultunits.lua').MobileUnit
local ModWeaponsFile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua')
local CDFLaserIridiumWeapon = ModWeaponsFile.CDFLaserIridiumWeapon

CSKCL0320 = Class(CLandUnit) {
    Weapons = {
      MainGun = Class(CDFLaserIridiumWeapon) {},
	},  
}

TypeClass = CSKCL0320