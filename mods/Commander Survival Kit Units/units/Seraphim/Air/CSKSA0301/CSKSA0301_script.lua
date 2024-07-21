#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0203/UAA0203_script.lua
#**  Author(s):  Drew Staltman, Gordon Duclos
#**
#**  Summary  :  Seraphim Gunship Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SAirUnit = import('/lua/defaultunits.lua').AirUnit
local SDFPhasicAutoGunWeapon = import('/lua/seraphimweapons.lua').SDFPhasicAutoGunWeapon

CSKSA0301 = Class(SAirUnit) {
    Weapons = {
        TurretLeft = Class(SDFPhasicAutoGunWeapon) {},
        TurretRight = Class(SDFPhasicAutoGunWeapon) {},
    },
}
TypeClass = CSKSA0301