#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0303/UAL0303_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AWalkingLandUnit = import('/lua/aeonunits.lua').AWalkingLandUnit
local CSKUWeaponFile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua')
local ADFGreenLaserBeamWeapon = CSKUWeaponFile.ADFGreenLaserBeamWeapon

CSKAL0300 = Class(AWalkingLandUnit) {    
    Weapons = {
        FrontTurret01 = Class(ADFGreenLaserBeamWeapon) {}
    },
	
	OnKilled = function(self)
            local wep1 = self:GetWeaponByLabel('FrontTurret01')
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
                  
            AWalkingLandUnit.OnKilled(self)
    end, 
    
}

TypeClass = CSKAL0300