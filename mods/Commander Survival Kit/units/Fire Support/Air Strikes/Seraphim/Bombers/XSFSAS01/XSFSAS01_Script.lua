#****************************************************************************
#**
#**  File     :  /data/units/XSA0103/XSA0103_script.lua
#**  Author(s):  Jessica St. Croix
#**
#**  Summary  :  Seraphim Bomber Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SAirUnit = import('/lua/defaultunits.lua').AirUnit
local SDFBombOtheWeapon = import('/lua/seraphimweapons.lua').SDFBombOtheWeapon

XSFSAS01 = Class(SAirUnit) {
    Weapons = {
        Bomb = Class(SDFBombOtheWeapon) {},
    },
	
	OnCreate = function(self)
        SAirUnit.OnCreate(self)
        self:RotateTowardsMid()
    end,
}

TypeClass = XSFSAS01