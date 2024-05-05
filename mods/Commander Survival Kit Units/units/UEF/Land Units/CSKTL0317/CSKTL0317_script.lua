#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0111/UEL0111_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Missile Launcher Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local WeaponFile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua')
local TElectricMaserBeamWeapon = WeaponFile.TElectricMaserBeamWeapon

CSKTL0317 = Class(TLandUnit) {

    Weapons = {
        ElectricMaserWeapon = Class(TElectricMaserBeamWeapon) {
		},
	
	}, 

	OnKilled = function(self)
            local wep1 = self:GetWeaponByLabel('ElectricMaserWeapon')
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
            
            CWalkingLandUnit.OnKilled(self)
    end, 	
}

TypeClass = CSKTL0317