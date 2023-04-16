#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0103/UAA0103_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local AIFBombGravitonWeapon = import('/lua/aeonweapons.lua').AIFBombGravitonWeapon

UAFSAS01 = Class(AAirUnit) {
    Weapons = {
        Bomb = Class(AIFBombGravitonWeapon) {},
    },
	
	OnCreate = function(self)
        AAirUnit.OnCreate(self)
        self:RotateTowardsMid()
    end,
}

TypeClass = UAFSAS01

