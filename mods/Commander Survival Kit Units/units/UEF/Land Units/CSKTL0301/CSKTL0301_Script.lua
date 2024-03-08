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
local TSAMLauncher = TerranWeaponFile.TSAMLauncher
local TIFArtilleryWeapon = TerranWeaponFile.TIFArtilleryWeapon
local TDFLightPlasmaCannonWeapon = TerranWeaponFile.TDFLightPlasmaCannonWeapon
local TDFGaussCannonWeapon = TerranWeaponFile.TDFGaussCannonWeapon
local TDFMachineGunWeapon = TerranWeaponFile.TDFMachineGunWeapon
local WeaponFile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua')
local TDualMaserBeamWeapon = WeaponFile.TDualMaserBeamWeapon

CSKTL0301 = Class(TWalkingLandUnit) {

    Weapons = {
	    DummyTurret = Class(TDFRiotWeapon) {},
		LMaserWeapon = Class(TDualMaserBeamWeapon) {},
		RMaserWeapon = Class(TDualMaserBeamWeapon) {},
		LPlasmaGun = Class(TDFLightPlasmaCannonWeapon) {},
		RPlasmaGun = Class(TDFLightPlasmaCannonWeapon) {},
		LFlamethrower = Class(TDFMachineGunWeapon) {},
		RFlamethrower = Class(TDFMachineGunWeapon) {},
		LGauss = Class(TDFGaussCannonWeapon) {},
		RGauss = Class(TDFGaussCannonWeapon) {},
		LArtillery = Class(TIFArtilleryWeapon) {},
		RArtillery = Class(TIFArtilleryWeapon) {},
		LDisArtillery = Class(TIFArtilleryWeapon) {},
		RDisArtillery = Class(TIFArtilleryWeapon) {},
		LHArtillery = Class(TIFArtilleryWeapon) {},
		RHArtillery = Class(TIFArtilleryWeapon) {},
        LMGGatling = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank,
			
			PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'L_Gatling_Muzzle', self.unit:GetArmy(), EffectTemplate.WeaponSteam01 )
                TDFRiotWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'L_Gatling_Barrel', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TDFRiotWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'L_Gatling_Muzzle', self.unit:GetArmy(), EffectTemplate.WeaponSteam01 )
                TDFRiotWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
		RMGGatling = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank,
			
			PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'R_Gatling_Muzzle', self.unit:GetArmy(), EffectTemplate.WeaponSteam01 )
                TDFRiotWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'R_Gatling_Barrel', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TDFRiotWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'R_Gatling_Muzzle', self.unit:GetArmy(), EffectTemplate.WeaponSteam01 )
                TDFRiotWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
        L_Missile_Pod = Class(TSAMLauncher) {
        },
		R_Missile_Pod = Class(TSAMLauncher) {
        },
		
		RPGatling = Class(TDFPlasmaCannonWeapon) 
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'R_Gatling_Muzzle', self.unit:GetArmy(), EffectTemplate.WeaponSteam01 )
                TDFPlasmaCannonWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'R_Gatling_Barrel', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TDFPlasmaCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'R_Gatling_Muzzle', self.unit:GetArmy(), EffectTemplate.WeaponSteam01 )
                TDFPlasmaCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
		
		LPGatling = Class(TDFPlasmaCannonWeapon) 
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'L_Gatling_Muzzle', self.unit:GetArmy(), EffectTemplate.WeaponSteam01 )
                TDFPlasmaCannonWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'L_Gatling_Barrel', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TDFPlasmaCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'L_Gatling_Muzzle', self.unit:GetArmy(), EffectTemplate.WeaponSteam01 )
                TDFPlasmaCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
		
		
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
		self.JetPackEffectsBag = {}
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self:SetWeaponEnabledByLabel('DummyTurret', true)
		self:SetWeaponEnabledByLabel('LMaserWeapon', false)
		self:SetWeaponEnabledByLabel('RMaserWeapon', false)
		self:SetWeaponEnabledByLabel('RPlasmaGun', false)
		self:SetWeaponEnabledByLabel('LPlasmaGun', false)
		self:SetWeaponEnabledByLabel('RFlamethrower', false)
		self:SetWeaponEnabledByLabel('LFlamethrower', false)
		self:SetWeaponEnabledByLabel('RGauss', false)
		self:SetWeaponEnabledByLabel('LGauss', false)
		self:SetWeaponEnabledByLabel('LMGGatling', false)
		self:SetWeaponEnabledByLabel('RMGGatling', false)
		self:SetWeaponEnabledByLabel('LPGatling', false)
		self:SetWeaponEnabledByLabel('RPGatling', false)
		self:SetWeaponEnabledByLabel('L_Missile_Pod', false)
		self:SetWeaponEnabledByLabel('R_Missile_Pod', false)
		self:SetWeaponEnabledByLabel('LArtillery', false)
		self:SetWeaponEnabledByLabel('RArtillery', false)
		self:SetWeaponEnabledByLabel('LDisArtillery', false)
		self:SetWeaponEnabledByLabel('RDisArtillery', false)
		self:SetWeaponEnabledByLabel('LHArtillery', false)
		self:SetWeaponEnabledByLabel('RHArtillery', false)
		self:HideBone( 'L_Gatling', true )
		self:HideBone( 'R_Gatling', true )
		self:HideBone( 'L_ML', true )
		self:HideBone( 'R_ML', true )
		self:HideBone( 'L_Hold', true )
		self:HideBone( 'R_Hold', true )
		self:HideBone( 'L_Arm_Hold', true )
		self:HideBone( 'R_Arm_Hold', true )
		self:HideBone( 'L_Art', true )
		self:HideBone( 'R_Art', true )
		self:HideBone( 'L_Arm_BPlate', true )
		self:HideBone( 'R_Arm_BPlate', true )
		self:HideBone( 'L_Arm_SPlate', true )
		self:HideBone( 'R_Arm_SPlate', true )
		self:HideBone( 'L_Beam', true )
		self:HideBone( 'R_Beam', true )
		self:HideBone( 'L_Flamethrower', true )
		self:HideBone( 'R_Flamethrower', true )
		self:HideBone( 'L_Gauss', true )
		self:HideBone( 'R_Gauss', true )
		self:HideBone( 'L_Plasma', true )
		self:HideBone( 'R_Plasma', true )
		self:HideBone( 'L_Arm_ML', true )
		self:HideBone( 'R_Arm_ML', true )
		self:HideBone( 'L_Maser', true )
		self:HideBone( 'R_Maser', true )
		
		local RandomNumber = math.random(1, 17)
		
		if RandomNumber == 1 then
		self:SetWeaponEnabledByLabel('LMGGatling', true)
		self:SetWeaponEnabledByLabel('RMGGatling', true)
		self:SetWeaponEnabledByLabel('L_Missile_Pod', true)
		self:SetWeaponEnabledByLabel('R_Missile_Pod', true)
		self:ShowBone( 'L_Gatling', true )
		self:ShowBone( 'R_Gatling', true )
		self:ShowBone( 'L_Arm_SPlate', true )
		self:ShowBone( 'R_Arm_SPlate', true )
		self:ShowBone( 'L_Arm_Hold', true )
		self:ShowBone( 'R_Arm_Hold', true )
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_ML', true )
		self:ShowBone( 'R_ML', true )
		elseif RandomNumber == 2 then
		self:SetWeaponEnabledByLabel('LMGGatling', true)
		self:SetWeaponEnabledByLabel('RMGGatling', true)
		self:ShowBone( 'L_Arm_SPlate', true )
		self:ShowBone( 'R_Arm_SPlate', true )
		self:ShowBone( 'L_Arm_Hold', true )
		self:ShowBone( 'R_Arm_Hold', true )
		self:ShowBone( 'L_Gatling', true )
		self:ShowBone( 'R_Gatling', true )
		elseif RandomNumber == 3 then
		self:SetWeaponEnabledByLabel('LPGatling', true)
		self:SetWeaponEnabledByLabel('RPGatling', true)
		self:SetWeaponEnabledByLabel('L_Missile_Pod', true)
		self:SetWeaponEnabledByLabel('R_Missile_Pod', true)
		self:ShowBone( 'L_Gatling', true )
		self:ShowBone( 'R_Gatling', true )
		self:ShowBone( 'L_Arm_Hold', true )
		self:ShowBone( 'R_Arm_Hold', true )
		self:ShowBone( 'L_Arm_BPlate', true )
		self:ShowBone( 'R_Arm_BPlate', true )
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_ML', true )
		self:ShowBone( 'R_ML', true )
		elseif RandomNumber == 4 then
		self:SetWeaponEnabledByLabel('LPGatling', true)
		self:SetWeaponEnabledByLabel('RPGatling', true)
		self:ShowBone( 'L_Arm_Hold', true )
		self:ShowBone( 'R_Arm_Hold', true )
		self:ShowBone( 'L_Arm_BPlate', true )
		self:ShowBone( 'R_Arm_BPlate', true )
		self:ShowBone( 'L_Gatling', true )
		self:ShowBone( 'R_Gatling', true )
		elseif RandomNumber == 5 then
		-- Nix Assault (Right Configuration)
		self:SetWeaponEnabledByLabel('RDisArtillery', true)
		self:SetWeaponEnabledByLabel('LPlasmaGun', true)
		self:SetWeaponEnabledByLabel('RPlasmaGun', true)
		self:ShowBone( 'L_Arm_Hold', true )
		self:ShowBone( 'L_Arm_SPlate', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'R_Art', true )
		self:ShowBone( 'L_Plasma', true )
		self:ShowBone( 'R_Plasma', true )
		elseif RandomNumber == 6 then
		-- Nix Assault (Left Configuration)
		self:SetWeaponEnabledByLabel('LDisArtillery', true)
		self:SetWeaponEnabledByLabel('LPlasmaGun', true)
		self:SetWeaponEnabledByLabel('RPlasmaGun', true)
		self:ShowBone( 'R_Arm_Hold', true )
		self:ShowBone( 'R_Arm_SPlate', true )
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'L_Art', true )
		self:ShowBone( 'L_Plasma', true )
		self:ShowBone( 'R_Plasma', true )
		elseif RandomNumber == 7 then
		-- Nix ZC (Right Configuration)
		self:SetWeaponEnabledByLabel('L_Missile_Pod', true)
		self:SetWeaponEnabledByLabel('RArtillery', true)
		self:SetWeaponEnabledByLabel('LFlamethrower', true)
		self:SetWeaponEnabledByLabel('RPGatling', true)
		self:ShowBone( 'L_Arm_Hold', true )
		self:ShowBone( 'R_Arm_Hold', true )
		self:ShowBone( 'L_Arm_SPlate', true )
		self:ShowBone( 'R_Arm_SPlate', true )
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_ML', true )
		self:ShowBone( 'R_Art', true )
		self:ShowBone( 'L_Flamethrower', true )
		self:ShowBone( 'R_Gatling', true )
		elseif RandomNumber == 8 then
		-- Nix ZC (Left Configuration)
		self:SetWeaponEnabledByLabel('R_Missile_Pod', true)
		self:SetWeaponEnabledByLabel('LArtillery', true)
		self:SetWeaponEnabledByLabel('RFlamethrower', true)
		self:SetWeaponEnabledByLabel('LPGatling', true)
		self:ShowBone( 'L_Arm_Hold', true )
		self:ShowBone( 'R_Arm_Hold', true )
		self:ShowBone( 'L_Arm_SPlate', true )
		self:ShowBone( 'R_Arm_SPlate', true )
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'R_ML', true )
		self:ShowBone( 'L_Art', true )
		self:ShowBone( 'R_Flamethrower', true )
		self:ShowBone( 'L_Gatling', true )
		elseif RandomNumber == 9 then
		-- Nix Artillery
		self:SetWeaponEnabledByLabel('LArtillery', true)
		self:SetWeaponEnabledByLabel('RArtillery', true)
		self:SetWeaponEnabledByLabel('LGauss', true)
		self:SetWeaponEnabledByLabel('RGauss', true)
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_Arm_Hold', true )
		self:ShowBone( 'R_Arm_Hold', true )
		self:ShowBone( 'L_Arm_BPlate', true )
		self:ShowBone( 'R_Arm_BPlate', true )
		self:ShowBone( 'L_Art', true )
		self:ShowBone( 'R_Art', true )
		self:ShowBone( 'L_Gauss', true )
		self:ShowBone( 'R_Gauss', true )
		elseif RandomNumber == 10 then
		-- Nix Close Combat
		self:SetWeaponEnabledByLabel('LFlamethrower', true)
		self:SetWeaponEnabledByLabel('RFlamethrower', true)
		self:SetWeaponEnabledByLabel('L_Missile_Pod', true)
		self:SetWeaponEnabledByLabel('R_Missile_Pod', true)
		self:ShowBone( 'L_Arm_Hold', true )
		self:ShowBone( 'R_Arm_Hold', true )
		self:ShowBone( 'L_Arm_SPlate', true )
		self:ShowBone( 'R_Arm_SPlate', true )
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_ML', true )
		self:ShowBone( 'R_ML', true )
		self:ShowBone( 'L_Flamethrower', true )
		self:ShowBone( 'R_Flamethrower', true )
		elseif RandomNumber == 11 then
		-- Nix Destroy Cannon
		self:SetWeaponEnabledByLabel('LDisArtillery', true)
		self:SetWeaponEnabledByLabel('RDisArtillery', true)
		self:SetWeaponEnabledByLabel('LGauss', true)
		self:SetWeaponEnabledByLabel('RGauss', true)
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_Arm_Hold', true )
		self:ShowBone( 'R_Arm_Hold', true )
		self:ShowBone( 'L_Arm_BPlate', true )
		self:ShowBone( 'R_Arm_BPlate', true )
		self:ShowBone( 'L_Art', true )
		self:ShowBone( 'R_Art', true )
		self:ShowBone( 'L_Gauss', true )
		self:ShowBone( 'R_Gauss', true )
		elseif RandomNumber == 12 then
		-- Nix C1
		self:SetWeaponEnabledByLabel('RMGGatling', true)
		self:SetWeaponEnabledByLabel('R_Missile_Pod', true)
		self:SetWeaponEnabledByLabel('LGauss', true)
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_Arm_Hold', true )
		self:ShowBone( 'L_Arm_SPlate', true )
		self:ShowBone( 'R_ML', false )
		self:ShowBone( 'L_Gauss', true )
		self:ShowBone( 'R_Gatling', true )
		elseif RandomNumber == 13 then
		-- Nix C2
		self:SetWeaponEnabledByLabel('LMGGatling', true)
		self:SetWeaponEnabledByLabel('L_Missile_Pod', true)
		self:SetWeaponEnabledByLabel('RGauss', true)
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Arm_Hold', true )
		self:ShowBone( 'R_Arm_SPlate', true )
		self:ShowBone( 'L_ML', true )
		self:ShowBone( 'R_Gauss', true )
		self:ShowBone( 'L_Gatling', true )
		elseif RandomNumber == 14 then
		-- Nix A
		self:SetWeaponEnabledByLabel('LPlasmaGun', true)
		self:SetWeaponEnabledByLabel('RGauss', true)
		self:ShowBone( 'L_Arm_Hold', true )
		self:ShowBone( 'L_Arm_SPlate', true )
		self:ShowBone( 'R_Arm_Hold', true )
		self:ShowBone( 'R_Arm_SPlate', true )
		self:ShowBone( 'R_Gauss', true )
		self:ShowBone( 'L_Plasma', true )
		elseif RandomNumber == 15 then
		-- Nix A2
		self:SetWeaponEnabledByLabel('RPlasmaGun', true)
		self:SetWeaponEnabledByLabel('LGauss', true)
		self:ShowBone( 'L_Arm_Hold', true )
		self:ShowBone( 'L_Arm_SPlate', true )
		self:ShowBone( 'R_Arm_Hold', true )
		self:ShowBone( 'R_Arm_SPlate', true )
		self:ShowBone( 'L_Gauss', true )
		self:ShowBone( 'R_Plasma', true )
		elseif RandomNumber == 16 then
		-- Nix Heavy Artillery
		self:SetWeaponEnabledByLabel('LHArtillery', true)
		self:SetWeaponEnabledByLabel('RHArtillery', true)
		self:SetWeaponEnabledByLabel('LGauss', true)
		self:SetWeaponEnabledByLabel('RGauss', true)
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_Arm_Hold', true )
		self:ShowBone( 'R_Arm_Hold', true )
		self:ShowBone( 'L_Arm_BPlate', true )
		self:ShowBone( 'R_Arm_BPlate', true )
		self:ShowBone( 'L_Art', false )
		self:ShowBone( 'R_Art', false )
		self:ShowBone( 'L_Gauss', true )
		self:ShowBone( 'R_Gauss', true )
		elseif RandomNumber == 17 then
		-- Nix Maser MK-1
		self:SetWeaponEnabledByLabel('LMaserWeapon', true)
		self:SetWeaponEnabledByLabel('RMaserWeapon', true)
		self:ShowBone( 'L_Arm_Hold', true )
		self:ShowBone( 'R_Arm_Hold', true )
		self:ShowBone( 'L_Arm_SPlate', true )
		self:ShowBone( 'R_Arm_SPlate', true )
		self:ShowBone( 'L_Maser', true )
		self:ShowBone( 'R_Maser', true )
		end
		
		ForkThread( function()

		end
		)
    end,
	
	CreateEnhancement = function(self, enh)
        TWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh == 'LeftGatling' then
		self:SetWeaponEnabledByLabel('LPlasmaGun', false)
		self:SetWeaponEnabledByLabel('LFlamethrower', false)
		self:SetWeaponEnabledByLabel('LGauss', false)
		self:SetWeaponEnabledByLabel('LMGGatling', true)
		self:SetWeaponEnabledByLabel('LPGatling', false)
		self:SetWeaponEnabledByLabel('LMaserWeapon', false)
		
        elseif enh == 'RightGatling' then
		self:SetWeaponEnabledByLabel('RPlasmaGun', false)
		self:SetWeaponEnabledByLabel('RFlamethrower', false)
		self:SetWeaponEnabledByLabel('RGauss', false)
		self:SetWeaponEnabledByLabel('RMGGatling', true)
		self:SetWeaponEnabledByLabel('RPGatling', false)
		self:SetWeaponEnabledByLabel('RMaserWeapon', false)
		
		elseif enh == 'LeftPlasmaGatling' then
		self:SetWeaponEnabledByLabel('LPlasmaGun', false)
		self:SetWeaponEnabledByLabel('LFlamethrower', false)
		self:SetWeaponEnabledByLabel('LGauss', false)
		self:SetWeaponEnabledByLabel('LMGGatling', false)
		self:SetWeaponEnabledByLabel('LPGatling', true)
		self:SetWeaponEnabledByLabel('LMaserWeapon', false)
		
		elseif enh == 'RightPlasmaGatling' then
		self:SetWeaponEnabledByLabel('RPlasmaGun', false)
		self:SetWeaponEnabledByLabel('RFlamethrower', false)
		self:SetWeaponEnabledByLabel('RGauss', false)
		self:SetWeaponEnabledByLabel('RMGGatling', false)
		self:SetWeaponEnabledByLabel('RPGatling', true)
		self:SetWeaponEnabledByLabel('RMaserWeapon', false)
		
        elseif enh == 'RightPlasma' then
		self:SetWeaponEnabledByLabel('RPlasmaGun', true)
		self:SetWeaponEnabledByLabel('RFlamethrower', false)
		self:SetWeaponEnabledByLabel('RGauss', false)
		self:SetWeaponEnabledByLabel('RMGGatling', false)
		self:SetWeaponEnabledByLabel('RPGatling', false)
		self:SetWeaponEnabledByLabel('RMaserWeapon', false)
		
        elseif enh == 'LeftPlasma' then
		self:SetWeaponEnabledByLabel('LPlasmaGun', true)
		self:SetWeaponEnabledByLabel('LFlamethrower', false)
		self:SetWeaponEnabledByLabel('LGauss', false)
		self:SetWeaponEnabledByLabel('LMGGatling', false)
		self:SetWeaponEnabledByLabel('LPGatling', false)
		self:SetWeaponEnabledByLabel('LMaserWeapon', false)
		
		elseif enh == 'RightGauss' then
		self:SetWeaponEnabledByLabel('RPlasmaGun', false)
		self:SetWeaponEnabledByLabel('RFlamethrower', false)
		self:SetWeaponEnabledByLabel('RGauss', true)
		self:SetWeaponEnabledByLabel('RMGGatling', false)
		self:SetWeaponEnabledByLabel('RPGatling', false)
		self:SetWeaponEnabledByLabel('RMaserWeapon', false)
		
		elseif enh == 'LeftGauss' then
		self:SetWeaponEnabledByLabel('LPlasmaGun', false)
		self:SetWeaponEnabledByLabel('LFlamethrower', false)
		self:SetWeaponEnabledByLabel('LGauss', true)
		self:SetWeaponEnabledByLabel('LMGGatling', false)
		self:SetWeaponEnabledByLabel('LPGatling', false)
		self:SetWeaponEnabledByLabel('LMaserWeapon', false)
		
		elseif enh == 'RightFlamethrower' then
		self:SetWeaponEnabledByLabel('RPlasmaGun', false)
		self:SetWeaponEnabledByLabel('RFlamethrower', true)
		self:SetWeaponEnabledByLabel('RGauss', false)
		self:SetWeaponEnabledByLabel('RMGGatling', false)
		self:SetWeaponEnabledByLabel('RPGatling', false)
		self:SetWeaponEnabledByLabel('RMaserWeapon', false)
		
		elseif enh == 'LeftFlamethrower' then
		self:SetWeaponEnabledByLabel('LPlasmaGun', false)
		self:SetWeaponEnabledByLabel('LFlamethrower', true)
		self:SetWeaponEnabledByLabel('LGauss', false)
		self:SetWeaponEnabledByLabel('LMGGatling', false)
		self:SetWeaponEnabledByLabel('LPGatling', false)
		self:SetWeaponEnabledByLabel('LMaserWeapon', false)
		
		elseif enh == 'LeftBackMissileLauncher' then
		self:SetWeaponEnabledByLabel('LDisArtillery', false)
		self:SetWeaponEnabledByLabel('LArtillery', false)
		self:SetWeaponEnabledByLabel('LHArtillery', false)
		self:SetWeaponEnabledByLabel('L_Missile_Pod', true)
		self:SetWeaponEnabledByLabel('LMaserWeapon', false)
		
		elseif enh == 'RightBackMissileLauncher' then
		self:SetWeaponEnabledByLabel('RDisArtillery', false)
		self:SetWeaponEnabledByLabel('RArtillery', false)
		self:SetWeaponEnabledByLabel('RHArtillery', false)
		self:SetWeaponEnabledByLabel('R_Missile_Pod', true)
		self:SetWeaponEnabledByLabel('RMaserWeapon', false)
		
		elseif enh == 'LeftBackDispersalArtillery' then
		self:SetWeaponEnabledByLabel('LDisArtillery', true)
		self:SetWeaponEnabledByLabel('LArtillery', false)
		self:SetWeaponEnabledByLabel('LHArtillery', false)
		self:SetWeaponEnabledByLabel('L_Missile_Pod', false)
		self:SetWeaponEnabledByLabel('LMaserWeapon', false)
		
		elseif enh == 'RightBackDispersalArtillery' then
		self:SetWeaponEnabledByLabel('RDisArtillery', true)
		self:SetWeaponEnabledByLabel('RArtillery', false)
		self:SetWeaponEnabledByLabel('RHArtillery', false)
		self:SetWeaponEnabledByLabel('R_Missile_Pod', false)
		self:SetWeaponEnabledByLabel('RMaserWeapon', false)
		
		elseif enh == 'LeftBackArtillery' then
		self:SetWeaponEnabledByLabel('LDisArtillery', false)
		self:SetWeaponEnabledByLabel('LArtillery', true)
		self:SetWeaponEnabledByLabel('LHArtillery', false)
		self:SetWeaponEnabledByLabel('L_Missile_Pod', false)
		self:SetWeaponEnabledByLabel('LMaserWeapon', false)
		
		elseif enh == 'RightBackArtillery' then
		self:SetWeaponEnabledByLabel('RDisArtillery', false)
		self:SetWeaponEnabledByLabel('RArtillery', true)
		self:SetWeaponEnabledByLabel('RHArtillery', false)
		self:SetWeaponEnabledByLabel('R_Missile_Pod', false)
		self:SetWeaponEnabledByLabel('RMaserWeapon', false)
		
		elseif enh == 'LeftBackAntiMatterArtillery' then
		self:SetWeaponEnabledByLabel('LDisArtillery', false)
		self:SetWeaponEnabledByLabel('LArtillery', false)
		self:SetWeaponEnabledByLabel('LHArtillery', true)
		self:SetWeaponEnabledByLabel('L_Missile_Pod', false)
		self:SetWeaponEnabledByLabel('LMaserWeapon', false)
		
		elseif enh == 'RightBackAntiMatterArtillery' then
		self:SetWeaponEnabledByLabel('RDisArtillery', false)
		self:SetWeaponEnabledByLabel('RArtillery', false)
		self:SetWeaponEnabledByLabel('RHArtillery', true)
		self:SetWeaponEnabledByLabel('R_Missile_Pod', false)
		self:SetWeaponEnabledByLabel('RMaserWeapon', false)
		
		elseif enh == 'LeftMaser' then
		self:SetWeaponEnabledByLabel('LPlasmaGun', false)
		self:SetWeaponEnabledByLabel('LFlamethrower', false)
		self:SetWeaponEnabledByLabel('LGauss', false)
		self:SetWeaponEnabledByLabel('LMGGatling', false)
		self:SetWeaponEnabledByLabel('LPGatling', false)
		self:SetWeaponEnabledByLabel('LMaserWeapon', true)
		
		elseif enh == 'RightMaser' then
		self:SetWeaponEnabledByLabel('RPlasmaGun', false)
		self:SetWeaponEnabledByLabel('RFlamethrower', false)
		self:SetWeaponEnabledByLabel('RGauss', false)
		self:SetWeaponEnabledByLabel('RMGGatling', false)
		self:SetWeaponEnabledByLabel('RPGatling', false)
		self:SetWeaponEnabledByLabel('RMaserWeapon', true)
        end
    end,
	
	
	OnMotionHorzEventChange = function(self, new, old)
        TWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
		if old == 'Stopped' then
			self:AddToggleCap('RULEUTC_WeaponToggle')
			self:SetScriptBit('RULEUTC_WeaponToggle', false)
        elseif new == 'Stopped' then
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
        end
    end,
	
	
	OnScriptBitSet = function(self, bit)
	local Oldlocation = self:GetPosition()
	local MovePos = self:GetCurrentMoveLocation()
	local Bombers = {} 
	local bp = self:GetBlueprint()
	local AirDummyUnit = bp.Display.AirDummyUnit
        if bit == 1 then 
			LOG('ScriptBit: ',self:GetScriptBit(2))
			LOG('MovePos: ',MovePos)
			ForkThread( function()
			local aiBrain = self:GetAIBrain()
			local qx, qy, qz, qw = unpack(self:GetOrientation())
			Bombers[1] = CreateUnit(AirDummyUnit,1,Oldlocation[1], Oldlocation[2], Oldlocation[3],qx, qy, qz, qw, 0)
			self:AttachBoneTo(-2, Bombers[1], 0)
			for i, Bomber in Bombers do
			EffectBones = self:GetBlueprint().Display.JetPackEffectBones
			self.Effect1 = CreateAttachedEmitter(self,EffectBones[1],self:GetArmy(), ModEmPath .. 'jetpack_trail_01_emit.bp'):OffsetEmitter(0 ,0, -0.4):ScaleEmitter(0.5)
            self.Trash:Add(self.Effect1)
			self.Effect2 = CreateAttachedEmitter(self,EffectBones[2],self:GetArmy(), ModEmPath .. 'jetpack_trail_01_emit.bp'):OffsetEmitter(0 ,0, -0.4):ScaleEmitter(0.5)
            self.Trash:Add(self.Effect2)
			self.Effect3 = CreateAttachedEmitter(self,EffectBones[3],self:GetArmy(), ModEmPath .. 'jetpack_trail_01_emit.bp'):OffsetEmitter(0 ,0, -0.4):ScaleEmitter(0.5)
            self.Trash:Add(self.Effect3)
			self.Effect4 = CreateAttachedEmitter(self,EffectBones[4],self:GetArmy(), ModEmPath .. 'jetpack_trail_01_emit.bp'):OffsetEmitter(0 ,0, -0.4):ScaleEmitter(0.5)
            self.Trash:Add(self.Effect4)
			self.Effect5 = CreateAttachedBeam(self,EffectBones[1],self:GetArmy(),  0.2, 0.05, ModTexPath .. 'beam_jetpack_exhaust.dds')
            self.Trash:Add(self.Effect5)
			self.Effect6 = CreateAttachedBeam(self,EffectBones[2],self:GetArmy(), 0.2, 0.05, ModTexPath .. 'beam_jetpack_exhaust.dds')
            self.Trash:Add(self.Effect6)
			self.Effect7 = CreateAttachedBeam(self,EffectBones[3],self:GetArmy(),  0.2, 0.05, ModTexPath .. 'beam_jetpack_exhaust.dds')
            self.Trash:Add(self.Effect5)
			self.Effect8 = CreateAttachedBeam(self,EffectBones[4],self:GetArmy(), 0.2, 0.05, ModTexPath .. 'beam_jetpack_exhaust.dds')
            self.Trash:Add(self.Effect6)
			Bombers[1]:SetElevation(10)
            IssueTransportUnload({Bomber}, MovePos)
            end
			end
			)
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 1 then 
			self.Effect1:Destroy()
			self.Effect2:Destroy()
			self.Effect3:Destroy()
			self.Effect4:Destroy()
			self.Effect5:Destroy()
			self.Effect6:Destroy()
			self.Effect7:Destroy()
			self.Effect8:Destroy()
        end
    end,
    
}

TypeClass = CSKTL0301