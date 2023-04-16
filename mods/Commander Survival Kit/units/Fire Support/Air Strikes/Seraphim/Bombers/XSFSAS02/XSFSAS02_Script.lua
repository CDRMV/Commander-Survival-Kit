#****************************************************************************
#**
#**  File     :  /data/units/XSA0202/XSA0202_script.lua
#**  Author(s):  Jessica St. Croix, Gordon Duclos, Matt Vainio, Aaron Lundquist
#**
#**  Summary  :  Seraphim Fighter/Bomber Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SDFBombOtheWeapon = SeraphimWeapons.SDFBombOtheWeapon

XSFSAS02 = Class(SAirUnit) {
    Weapons = {
        Bomb = Class(SDFBombOtheWeapon) {},
    },
	
	OnCreate = function(self)
        SAirUnit.OnCreate(self)
        self:RotateTowardsMid()
    end,
}
TypeClass = XSFSAS02