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

CSKCL0314 = Class(CLandUnit) {
    Weapons = {
	  AAGun = Class(CDFLaserIridiumWeapon) {},
      SecGun = Class(CDFLaserIridiumWeapon) {},
	},
	  
	
}

TypeClass = CSKCL0314