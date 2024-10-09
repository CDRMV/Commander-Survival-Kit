#****************************************************************************
#**
#**  File     :  /data/units/XAA0202/XAA0202_script.lua
#**  Author(s):  Jessica St. Croix
#**
#**  Summary  :  Aeon Combat Fighter Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').AirUnit
local AAAAutocannonQuantumWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon

UAFSAS05 = Class(AAirUnit) {
    Weapons = {
        AutoCannon1 = AAAAutocannonQuantumWeapon,
    },
}

TypeClass = UAFSAS05