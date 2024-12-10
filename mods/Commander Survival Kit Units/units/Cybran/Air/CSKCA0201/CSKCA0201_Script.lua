#****************************************************************************
#**
#**  File     :  /cdimage/units/URA0103/URA0103_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Cybran Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CAirUnit = import('/lua/defaultunits.lua').AirUnit
local CIFMissileLoaWeapon = import('/lua/cybranweapons.lua').CIFMissileLoaWeapon
local CDFLaserPulseLightWeapon = import('/lua/cybranweapons.lua').CDFLaserPulseLightWeapon
local CIFBombNeutronWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon

CSKCA0201 = Class(CAirUnit) {
    Weapons = {
	    Bomb = Class(CIFBombNeutronWeapon) {},
        AutoCannon = Class(CDFLaserPulseLightWeapon) {},
        MissileRack = Class(CIFMissileLoaWeapon) {},
        },
    ExhaustBones = {'Exhaust',},
}

TypeClass = CSKCA0201