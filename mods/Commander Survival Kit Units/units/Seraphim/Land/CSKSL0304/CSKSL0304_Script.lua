#****************************************************************************
#**
#**  File     :  /units/XSL0202/XSL0202_script.lua
#**
#**  Summary  :  Seraphim Heavy Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local SIFLaanseTacticalMissileLauncher = import('/lua/seraphimweapons.lua').SIFLaanseTacticalMissileLauncher

CSKSL0304 = Class(SWalkingLandUnit) {
    Weapons = {
        MainGun = Class(SIFLaanseTacticalMissileLauncher) {},
    },

}
TypeClass = CSKSL0304