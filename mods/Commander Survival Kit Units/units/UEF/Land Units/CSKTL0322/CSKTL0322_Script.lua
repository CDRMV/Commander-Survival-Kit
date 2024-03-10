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
local EffectUtils = import('/lua/effectutilities.lua')
local Util = import('/lua/utilities.lua')
local ModTexPath = '/mods/Commander Survival Kit Units/textures/particles/'
local ModEmPath = '/mods/Commander Survival Kit Units/effects/emitters/'
local TerranWeaponFile = import('/lua/terranweapons.lua')
local TWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local TDFRiotWeapon = TerranWeaponFile.TDFRiotWeapon
local TDFPlasmaCannonWeapon = TerranWeaponFile.TDFPlasmaCannonWeapon
local TIFCruiseMissileLauncher = TerranWeaponFile.TIFCruiseMissileLauncher
local TIFArtilleryWeapon = TerranWeaponFile.TIFArtilleryWeapon
local TDFLightPlasmaCannonWeapon = TerranWeaponFile.TDFLightPlasmaCannonWeapon
local TDFGaussCannonWeapon = TerranWeaponFile.TDFGaussCannonWeapon
local TDFMachineGunWeapon = TerranWeaponFile.TDFMachineGunWeapon
local WeaponFile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua')
local TDualMaserBeamWeapon = WeaponFile.TDualMaserBeamWeapon

CSKTL0322 = Class(TWalkingLandUnit) {

    Weapons = {
		LMaserWeapon = Class(TDualMaserBeamWeapon) {},
		RMaserWeapon = Class(TDualMaserBeamWeapon) {},
		LPlasmaGun = Class(TDFLightPlasmaCannonWeapon) {},
		RPlasmaGun = Class(TDFLightPlasmaCannonWeapon) {},
		LGauss = Class(TDFGaussCannonWeapon) {},
		RGauss = Class(TDFGaussCannonWeapon) {},
		Missile_Pod = Class(TIFCruiseMissileLauncher) {},
		
		OnKilled = function(self)
            local wep1 = self:GetWeaponByLabel('LMaserWeapon')
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
            local wep2 = self:GetWeaponByLabel('RMaserWeapon')
            local bp2 = wep2:GetBlueprint()
            if bp2.Audio.BeamStop then
                wep2:PlaySound(bp2.Audio.BeamStop)
            end
            if bp2.Audio.BeamLoop and wep2.Beams[1].Beam then
                wep2.Beams[1].Beam:SetAmbientSound(nil, nil)
            end
            for k, v in wep2.Beams do
                v.Beam:Disable()
            end  			
                  
            TWalkingLandUnit.OnKilled(self)
        end, 
    },
	
	OnStopBeingBuilt = function(self, builder, layer)
        TWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		--self:SetWeaponEnabledByLabel('DummyTurret', true)

		--self:HideBone( 'L_Gatling', true )
		
		local RandomNumber = math.random(1, 1)
		
		if RandomNumber == 1 then
		
		end
		
		ForkThread( function()

		end
		)
    end,
    
}

TypeClass = CSKTL0322