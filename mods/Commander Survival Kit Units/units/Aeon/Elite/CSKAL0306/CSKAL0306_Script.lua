#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0303/UAL0303_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local AeonWeapons = import('/lua/aeonweapons.lua')
local ADFCannonOblivionWeapon = AeonWeapons.ADFPhasonLaser
local SDFUnstablePhasonBeam = import('/lua/seraphimweapons.lua').SDFUnstablePhasonBeam
local EffectUtil = import('/lua/EffectUtilities.lua')

CSKAL0306 = Class(AWalkingLandUnit) {    
    Weapons = {
        EyeWeapon = Class(ADFCannonOblivionWeapon) {},
		PhasonBeam = Class(SDFUnstablePhasonBeam) {}
    },
}

TypeClass = CSKAL0306