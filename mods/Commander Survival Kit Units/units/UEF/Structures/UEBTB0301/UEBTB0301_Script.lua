#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2301/UEB2301_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local TIFCruiseMissileLauncher = import('/lua/terranweapons.lua').TIFCruiseMissileLauncher
local EffectTemplate = import('/lua/EffectTemplates.lua')

UEBTB0301 = Class(TStructureUnit) {
    Weapons = {
        CruiseMissile = Class(TIFCruiseMissileLauncher) {
            FxMuzzleFlash = EffectTemplate.TIFCruiseMissileLaunchBuilding,
        },
    },
}

TypeClass = UEBTB0301