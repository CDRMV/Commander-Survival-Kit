#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0304/UAA0304_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Strategic Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').AirUnit
local AIFBombQuarkWeapon = import('/lua/aeonweapons.lua').AIFBombQuarkWeapon
local ADFMiniPhasonLaser2 = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').ADFMiniPhasonLaser2


CSKAA0301 = Class(AAirUnit) {
    Weapons = {
        Bomb = Class(AIFBombQuarkWeapon) {},
		BeamWeapon = Class(ADFMiniPhasonLaser2) {},
    },
}

TypeClass = CSKAA0301