#****************************************************************************
#**
#**  File     :  /units/XSL0202/XSL0202_script.lua
#**
#**  Summary  :  Seraphim Heavy Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local SDFUltraChromaticBeamGenerator = import('/lua/seraphimweapons.lua').SDFUltraChromaticBeamGenerator

CSKSL0320 = Class(SWalkingLandUnit) {
    Weapons = {
        MainGun = Class(SDFUltraChromaticBeamGenerator) {},
    },
	
	OnKilled = function(self, instigator, type, overkillRatio)
        local wep1 = self:GetWeaponByLabel('MainGun')
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
        
        
        SWalkingLandUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
}
TypeClass = CSKSL0320