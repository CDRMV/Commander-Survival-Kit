#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0303/UEL0303_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TerranWeaponFile = import('/lua/terranweapons.lua')
local TWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon
local TSAMLauncher = TerranWeaponFile.TSAMLauncher

CSKTL0301 = Class(TWalkingLandUnit) {

    Weapons = {
        Riotgun01 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
        L_Missile_Pod = Class(TSAMLauncher) {
        },
		R_Missile_Pod = Class(TSAMLauncher) {
        },
    },
    
}

TypeClass = CSKTL0301