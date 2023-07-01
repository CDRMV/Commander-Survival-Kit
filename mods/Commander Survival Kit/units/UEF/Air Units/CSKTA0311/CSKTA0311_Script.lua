#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0304/UEA0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Strategic Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local TIFCruiseMissileUnpackingLauncher = import('/lua/terranweapons.lua').TIFCruiseMissileUnpackingLauncher

CSKTA0311 = Class(TAirUnit) {
    Weapons = {
		Riotgun01 = Class(TDFMachineGunWeapon) {},
		MissileAir01 = Class(TIFCruiseMissileUnpackingLauncher) 
		{
            FxMuzzleFlash = {'/effects/emitters/terran_mobile_missile_launch_01_emit.bp'},
        },
		MissileWeapon = Class(TIFCruiseMissileUnpackingLauncher) 
        {
            FxMuzzleFlash = {'/effects/emitters/terran_mobile_missile_launch_01_emit.bp'},
        },
    },
}

TypeClass = CSKTA0311
