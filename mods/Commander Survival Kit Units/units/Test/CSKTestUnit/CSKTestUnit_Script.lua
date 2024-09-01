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

local Entity = import("/lua/sim/Entity.lua").Entity

CSKTestUnit = Class(TWalkingLandUnit) {

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
	
	NotifyOfPodDeath = function(self, pod)
        if pod == 'RightPod' and self.HasLeftPod then
            --self:CreateEnhancement('RightPodRemove')
            --self:CreateEnhancement('LeftPod')
            self.HasRightPod = false
            self:RequestRefreshUI()
        elseif pod == 'RightPod' and not self.HasLeftPod then
            --self:CreateEnhancement('RightPodRemove')
            --self:CreateEnhancement('LeftPodRemove')
            self.HasRightPod = false
            self:RequestRefreshUI()
        elseif pod == 'LeftPod' then
            self.HasLeftPod = false
            --self:CreateEnhancement('LeftPodRemove')
            self:RequestRefreshUI()
        end
    end,
	
	OnCreate = function(self)
        TWalkingLandUnit.OnCreate(self)
            local location = self:GetPosition('AttachSpecial01')
			local location2 = self:GetPosition('AttachSpecial02')
			local location3 = self:GetPosition('AttachSpecial03')
            local pod = CreateUnitHPR('CSKSL0400HPD', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			--pod:AttachTo(self, 'AttachSpecial01')
            pod:SetParent(self, 'Pod1')
            pod:SetCreator(self)
			local pod2 = CreateUnitHPR('CSKSL0400HPD', self:GetArmy(), location2[1], location2[2], location2[3], 0, 0, 0)
			--pod:AttachTo(self, 'AttachSpecial01')
            pod2:SetParent(self, 'Pod2')
            pod2:SetCreator(self)
			local pod3 = CreateUnitHPR('CSKSL0400HPD', self:GetArmy(), location3[1], location3[2], location3[3], 0, 0, 0)
			--pod:AttachTo(self, 'AttachSpecial01')
            pod3:SetParent(self, 'Pod3')
            pod3:SetCreator(self)
            self.Trash:Add(pod)
			self.HasLeftPod = true
            self.LeftPod = pod
			self.Trash:Add(pod2)
			self.HasRightPod = true
            self.RightPod = pod2
			self.Trash:Add(pod3)
			self.HasCenterPod = true
            self.CenterPod = pod3

			
    end,
	

	

	
	
	
	
	
    
}

TypeClass = CSKTestUnit