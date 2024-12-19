--****************************************************************************
--**
--**  Author(s):  Strutman12345
--**
--**  Summary  :  UEF CROWS Humvee Script

--****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon

SCSKTL0100 = Class(TLandUnit) {
    
    Weapons = {
        MainGun = Class(TDFMachineGunWeapon) {},
    },

}

TypeClass = SCSKTL0100
