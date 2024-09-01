#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0101/UEL0101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Land Scout Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local CSKUWeaponFile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua')
local TLightMaserBeamWeapon = CSKUWeaponFile.TLightMaserBeamWeapon


CSKTL0100 = Class(TLandUnit) {
    
    Weapons = {
        LightMaserWeapon = Class(TLightMaserBeamWeapon) {
        },
		
		OnKilled = function(self)
            local wep1 = self:GetWeaponByLabel('LightMaserWeapon')
            local bp1 = wep1:GetBlueprint()
            if bp1.Audio.BeamStop then
                wep1:PlaySound(bp1.Audio.BeamStop)
            end
            if bp1.Audio.BeamLoop and wep1.Beams[1].Beam then
                wep1.Beams[1].Beam:SetAmbientSound(nil, nil)
            end
            for k, v in wep1.Beams do
                v.Beam:Disable()
            end     
                  
            TLandUnit.OnKilled(self)
        end,   
    },  

}


TypeClass = CSKTL0100
