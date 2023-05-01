#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0204/UAA0204_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Torpedo Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').AirUnit
local AIFBombGravitonWeapon = import('/lua/aeonweapons.lua').AIFBombGravitonWeapon

UAFSAS02 = Class(AAirUnit) {
    Weapons = {
        Bomb = Class(AIFBombGravitonWeapon) {},
    },
	
	OnCreate = function(self)
        AAirUnit.OnCreate(self)
        self:RotateTowardsMid()
    end,
}

TypeClass = UAFSAS02