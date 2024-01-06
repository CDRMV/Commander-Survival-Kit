#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0111/UEL0111_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Missile Launcher Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local WeaponFile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua')
local TElectricMaserBeamWeapon = WeaponFile.TElectricMaserBeamWeapon

CSKTL0317 = Class(TLandUnit) {

    Weapons = {
        ElectricMaserWeapon = Class(TElectricMaserBeamWeapon) {
		},
	
	},  
}

TypeClass = CSKTL0317