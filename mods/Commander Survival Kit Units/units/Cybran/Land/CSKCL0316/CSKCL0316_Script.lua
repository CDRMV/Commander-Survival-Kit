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
local CDFHeavyMicrowaveLaserGeneratorCom = import('/lua/cybranweapons.lua').CDFHeavyMicrowaveLaserGeneratorCom
local CDFLaserIridiumWeapon = ModWeaponsFile.CDFLaserIridiumWeapon
local DummyTurretWeapon = ModWeaponsFile.DummyTurretWeapon

CSKCL0316 = Class(CLandUnit) {
    Weapons = {
	  Dummy = Class(DummyTurretWeapon) {},
      SecGun = Class(CDFLaserIridiumWeapon) {},
	  MLG = Class(CDFHeavyMicrowaveLaserGeneratorCom) {},
	},  
	
}

TypeClass = CSKCL0316