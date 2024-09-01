#****************************************************************************
#**
#**  File     :  /data/units/XEL0306/XEL0306_script.lua
#**  Author(s):  Jessica St. Croix, Dru Staltman
#**
#**  Summary  :  UEF Mobile Missile Platform Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local WeaponFile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua')
local TDFHeavyMaserCannonWeapon = WeaponFile.TDFHeavyMaserCannonWeapon
local TIFFragLauncherWeapon = WeaponsFile.TIFFragLauncherWeapon

CSKTL0316 = Class(TLandUnit) {
    Weapons = {
        HeavyMaserWeapon = Class(TDFHeavyMaserCannonWeapon) {
        },
		
		Grenade = Class(TIFFragLauncherWeapon) {},  
    },	

}

TypeClass = CSKTL0316