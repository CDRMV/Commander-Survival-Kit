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
local TAMPhalanxWeapon = import('/lua/terranweapons.lua').TAMPhalanxWeapon

CSKTL0204 = Class(TLandUnit) {
    Weapons = {
        Turret01 = Class(TAMPhalanxWeapon) {
                PlayFxWeaponUnpackSequence = function(self)
                    if not self.SpinManip then 
                        self.SpinManip = CreateRotator(self.unit, 'Turret_Barrel_B01', 'z', nil, 270, 180, 60)
                        self.unit.Trash:Add(self.SpinManip)
                    end
                    if self.SpinManip then
                        self.SpinManip:SetTargetSpeed(270)
                    end
                    TAMPhalanxWeapon.PlayFxWeaponUnpackSequence(self)
                end,

                PlayFxWeaponPackSequence = function(self)
                    if self.SpinManip then
                        self.SpinManip:SetTargetSpeed(0)
                    end
                    TAMPhalanxWeapon.PlayFxWeaponPackSequence(self)
                end,
            
            },
    },
}

TypeClass = CSKTL0204