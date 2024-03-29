#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0301/UAL0301_script.lua
#**  Author(s):  Jessica St. Croix
#**
#**  Summary  :  Aeon Sub Commander Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit

local AWeapons = import('/lua/aeonweapons.lua')
local ADFCannonOblivionWeapon = AWeapons.ADFCannonOblivionWeapon
local ADFGravitonProjectorWeapon = AWeapons.ADFGravitonProjectorWeapon

UAL0301 = Class(AWalkingLandUnit) {    
    Weapons = {
        MainGun = Class(ADFCannonOblivionWeapon) {},
		SecGun = Class(ADFGravitonProjectorWeapon) {},
    },
    
}

TypeClass = UAL0301
