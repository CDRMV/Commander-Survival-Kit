#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0304/UEL0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Heavy Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TMobileAdvancedKamikazeBombWeapon = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').TMobileAdvancedKamikazeBombWeapon

CSKTL0302 = Class(TLandUnit) {
    Weapons = {
        
        Suicide = Class(TMobileAdvancedKamikazeBombWeapon) {   
     
			OnFire = function(self)			
				#disable death weapon
				self.unit:SetDeathWeaponEnabled(false)
				TMobileAdvancedKamikazeBombWeapon.OnFire(self)
			end,
        },
    },
}

TypeClass = CSKTL0302