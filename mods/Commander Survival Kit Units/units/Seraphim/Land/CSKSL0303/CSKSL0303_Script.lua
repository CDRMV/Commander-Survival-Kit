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
local SDFAireauBolterWeapon = import('/lua/seraphimweapons.lua').SDFAireauBolterWeapon02
local SDFLightChronotronCannonWeapon = import('/lua/seraphimweapons.lua').SDFLightChronotronCannonWeapon
local DummyTurretWeapon = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').DummyTurretWeapon

CSKSL0303 = Class(SWalkingLandUnit) {
    Weapons = {
        R_Beam = Class(SDFUltraChromaticBeamGenerator) {},
		L_Beam = Class(SDFUltraChromaticBeamGenerator) {},
		R_Gun = Class(SDFAireauBolterWeapon) {},
		L_Gun = Class(SDFAireauBolterWeapon) {},
		Center_Gun = Class(SDFLightChronotronCannonWeapon) {},
		DummyTurret = Class(DummyTurretWeapon) {},
    },
	
	OnStopBeingBuilt = function(self, builder, layer)
        SWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetWeaponEnabledByLabel('R_Beam', false)
		self:SetWeaponEnabledByLabel('L_Beam', false)
		self:SetWeaponEnabledByLabel('R_Gun', false)
		self:SetWeaponEnabledByLabel('L_Gun', false)
		self:SetWeaponEnabledByLabel('Center_Gun', false)
		self:HideBone( 'L_Turret_Upgrade1', true )
		self:HideBone( 'R_Turret_Upgrade1', true )
		self:HideBone( 'L_Turret_Upgrade2', true )
		self:HideBone( 'R_Turret_Upgrade2', true )
		self:HideBone( 'Middle_Upgrade2', true )
		self:HideBone( 'Middle_Upgrade', true )
		self:HideBone( 'Middle_Turret', true )
		
		local RandomNumber = math.random(1, 5)
		
		if RandomNumber == 1 then
		self:ShowBone( 'Middle_Upgrade2', false )
		self:SetWeaponEnabledByLabel('R_Gun', true)
		self:SetWeaponEnabledByLabel('L_Gun', true)
		self:ShowBone( 'L_Turret2', false )
		self:ShowBone( 'R_Turret2', false )
		self:ShowBone( 'L_Turret_Upgrade2', true )
		self:ShowBone( 'R_Turret_Upgrade2', true )
		elseif RandomNumber == 2 then
		self:ShowBone( 'Middle_Upgrade2', false )
		self:SetWeaponEnabledByLabel('R_Beam', true)
		self:SetWeaponEnabledByLabel('L_Beam', true)
		self:ShowBone( 'L_Turret', false )
		self:ShowBone( 'R_Turret', false )
		self:ShowBone( 'L_Turret_Upgrade1', true )
		self:ShowBone( 'R_Turret_Upgrade1', true )
		elseif RandomNumber == 3 then
		self:SetWeaponEnabledByLabel('Center_Gun', true)
		self:ShowBone( 'Middle_Upgrade', true )
		self:ShowBone( 'Middle_Turret', true )
		self:ShowBone( 'Middle_Upgrade2', false )
		self:SetWeaponEnabledByLabel('R_Beam', true)
		self:SetWeaponEnabledByLabel('L_Beam', true)
		self:ShowBone( 'L_Turret', false )
		self:ShowBone( 'R_Turret', false )
		self:ShowBone( 'L_Turret_Upgrade1', true )
		self:ShowBone( 'R_Turret_Upgrade1', true )
		elseif RandomNumber == 4 then
		self:SetWeaponEnabledByLabel('Center_Gun', true)
		self:ShowBone( 'Middle_Upgrade', true )
		self:ShowBone( 'Middle_Turret', true )
		self:ShowBone( 'Middle_Upgrade2', false )
		self:SetWeaponEnabledByLabel('R_Gun', true)
		self:SetWeaponEnabledByLabel('L_Gun', true)
		self:ShowBone( 'L_Turret2', false )
		self:ShowBone( 'R_Turret2', false )
		self:ShowBone( 'L_Turret_Upgrade2', true )
		self:ShowBone( 'R_Turret_Upgrade2', true )
		elseif RandomNumber == 5 then
		self:SetWeaponEnabledByLabel('Center_Gun', true)
		self:ShowBone( 'Middle_Upgrade', true )
		self:ShowBone( 'Middle_Turret', true )
		end
		
		ForkThread( function()

		end
		)
    end,
	
	CreateEnhancement = function(self, enh)
        SWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh == 'HeavySniperTurret' then
		self:SetWeaponEnabledByLabel('Center_Gun', true)
		self:SetWeaponEnabledByLabel('R_Beam', false)
		self:SetWeaponEnabledByLabel('L_Beam', false)
		self:SetWeaponEnabledByLabel('R_Gun', false)
		self:SetWeaponEnabledByLabel('L_Gun', false)
        elseif enh == 'RapidFireGuns' then
		self:SetWeaponEnabledByLabel('Center_Gun', false)
		self:SetWeaponEnabledByLabel('R_Beam', false)
		self:SetWeaponEnabledByLabel('L_Beam', false)
		self:SetWeaponEnabledByLabel('R_Gun', true)
		self:SetWeaponEnabledByLabel('L_Gun', true)
		elseif enh == 'HeavySniperTurret2' then
		self:SetWeaponEnabledByLabel('Center_Gun', true)
		self:SetWeaponEnabledByLabel('R_Beam', false)
		self:SetWeaponEnabledByLabel('L_Beam', false)
		self:SetWeaponEnabledByLabel('R_Gun', true)
		self:SetWeaponEnabledByLabel('L_Gun', true)
        elseif enh == 'BeamCannons' then
		self:SetWeaponEnabledByLabel('Center_Gun', false)
		self:SetWeaponEnabledByLabel('R_Beam', true)
		self:SetWeaponEnabledByLabel('L_Beam', true)
		self:SetWeaponEnabledByLabel('R_Gun', false)
		self:SetWeaponEnabledByLabel('L_Gun', false)
		elseif enh == 'HeavySniperTurret3' then
		self:SetWeaponEnabledByLabel('Center_Gun', true)
		self:SetWeaponEnabledByLabel('R_Beam', true)
		self:SetWeaponEnabledByLabel('L_Beam', true)
		self:SetWeaponEnabledByLabel('R_Gun', false)
		self:SetWeaponEnabledByLabel('L_Gun', false)
        end
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
        local wep1 = self:GetWeaponByLabel('R_Beam')
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

        local wep1 = self:GetWeaponByLabel('L_Beam')
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
TypeClass = CSKSL0303