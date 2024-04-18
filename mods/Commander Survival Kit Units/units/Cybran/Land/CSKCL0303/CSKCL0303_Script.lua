#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0303/URL0303_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local cWeapons = import('/lua/cybranweapons.lua')
local CDFLaserDisintegratorWeapon = cWeapons.CDFLaserDisintegratorWeapon01
local CIFMissileLoaWeapon = cWeapons.CIFMissileLoaWeapon

CSKCL0303 = Class(CWalkingLandUnit) 
{

    Weapons = {
		MainGun = Class(CDFLaserDisintegratorWeapon) {},
		MissileRack = Class(CIFMissileLoaWeapon) {},
    },
}

TypeClass = CSKCL0303