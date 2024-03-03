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
local TerranWeaponFile = import('/lua/terranweapons.lua')
local TWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local TDFRiotWeapon = TerranWeaponFile.TDFRiotWeapon
local TDFPlasmaCannonWeapon = TerranWeaponFile.TDFPlasmaCannonWeapon
local TSAMLauncher = TerranWeaponFile.TSAMLauncher
local TIFArtilleryWeapon = TerranWeaponFile.TIFArtilleryWeapon

CSKTL0301 = Class(TWalkingLandUnit) {

    Weapons = {
	    DummyTurret = Class(TDFRiotWeapon) {
        },
		LArtillery = Class(TIFArtilleryWeapon) {
        },
		RArtillery = Class(TIFArtilleryWeapon) {
        },
		LDisArtillery = Class(TIFArtilleryWeapon) {
        },
		RDisArtillery = Class(TIFArtilleryWeapon) {
        },
		LHArtillery = Class(TIFArtilleryWeapon) {
        },
		RHArtillery = Class(TIFArtilleryWeapon) {
        },
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
    },
	
	OnStopBeingBuilt = function(self, builder, layer)
        TWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetWeaponEnabledByLabel('DummyTurret', true)
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
		self:HideBone( 'L_Art', true )
		self:HideBone( 'R_Art', true )
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
		
		local RandomNumber = math.random(1, 10)
		
		if RandomNumber == 1 then
		self:SetWeaponEnabledByLabel('LMGGatling', true)
		self:SetWeaponEnabledByLabel('RMGGatling', true)
		self:SetWeaponEnabledByLabel('L_Missile_Pod', true)
		self:SetWeaponEnabledByLabel('R_Missile_Pod', true)
		self:ShowBone( 'L_Gatling', true )
		self:ShowBone( 'R_Gatling', true )
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_ML', true )
		self:ShowBone( 'R_ML', true )
		elseif RandomNumber == 2 then
		self:SetWeaponEnabledByLabel('LMGGatling', true)
		self:SetWeaponEnabledByLabel('RMGGatling', true)
		self:ShowBone( 'L_Gatling', true )
		self:ShowBone( 'R_Gatling', true )
		elseif RandomNumber == 3 then
		self:SetWeaponEnabledByLabel('LPGatling', true)
		self:SetWeaponEnabledByLabel('RPGatling', true)
		self:SetWeaponEnabledByLabel('L_Missile_Pod', true)
		self:SetWeaponEnabledByLabel('R_Missile_Pod', true)
		self:ShowBone( 'L_Gatling', true )
		self:ShowBone( 'R_Gatling', true )
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_ML', true )
		self:ShowBone( 'R_ML', true )
		elseif RandomNumber == 4 then
		self:SetWeaponEnabledByLabel('LPGatling', true)
		self:SetWeaponEnabledByLabel('RPGatling', true)
		self:ShowBone( 'L_Gatling', true )
		self:ShowBone( 'R_Gatling', true )
		elseif RandomNumber == 5 then
		self:SetWeaponEnabledByLabel('LArtillery', true)
		self:SetWeaponEnabledByLabel('RArtillery', true)
		self:SetWeaponEnabledByLabel('LMGGatling', true)
		self:SetWeaponEnabledByLabel('RMGGatling', true)
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_Art', true )
		self:ShowBone( 'R_Art', true )
		self:ShowBone( 'L_Gatling', true )
		self:ShowBone( 'R_Gatling', true )
		elseif RandomNumber == 6 then
		self:SetWeaponEnabledByLabel('LHArtillery', true)
		self:SetWeaponEnabledByLabel('RHArtillery', true)
		self:SetWeaponEnabledByLabel('LMGGatling', true)
		self:SetWeaponEnabledByLabel('RMGGatling', true)
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_Art', false )
		self:ShowBone( 'R_Art', false )
		self:ShowBone( 'L_HArt_Muzzle', false )
		self:ShowBone( 'R_HArt_Muzzle', false )
		self:ShowBone( 'L_Gatling', true )
		self:ShowBone( 'R_Gatling', true )
		elseif RandomNumber == 7 then
		self:SetWeaponEnabledByLabel('LDisArtillery', true)
		self:SetWeaponEnabledByLabel('RDisArtillery', true)
		self:SetWeaponEnabledByLabel('LMGGatling', true)
		self:SetWeaponEnabledByLabel('RMGGatling', true)
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_Art', true )
		self:ShowBone( 'R_Art', true )
		self:ShowBone( 'L_Gatling', true )
		self:ShowBone( 'R_Gatling', true )
		elseif RandomNumber == 8 then
		self:SetWeaponEnabledByLabel('LArtillery', true)
		self:SetWeaponEnabledByLabel('RArtillery', true)
		self:SetWeaponEnabledByLabel('LPGatling', true)
		self:SetWeaponEnabledByLabel('RPGatling', true)
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_Art', true )
		self:ShowBone( 'R_Art', true )
		self:ShowBone( 'L_Gatling', true )
		self:ShowBone( 'R_Gatling', true )
		elseif RandomNumber == 9 then
		self:SetWeaponEnabledByLabel('LHArtillery', true)
		self:SetWeaponEnabledByLabel('RHArtillery', true)
		self:SetWeaponEnabledByLabel('LPGatling', true)
		self:SetWeaponEnabledByLabel('RPGatling', true)
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_Art', false )
		self:ShowBone( 'R_Art', false )
		self:ShowBone( 'L_HArt_Muzzle', false )
		self:ShowBone( 'R_HArt_Muzzle', false )
		self:ShowBone( 'L_Gatling', true )
		self:ShowBone( 'R_Gatling', true )
		elseif RandomNumber == 10 then
		self:SetWeaponEnabledByLabel('LDisArtillery', true)
		self:SetWeaponEnabledByLabel('RDisArtillery', true)
		self:SetWeaponEnabledByLabel('LPGatling', true)
		self:SetWeaponEnabledByLabel('RPGatling', true)
		self:ShowBone( 'L_Hold', true )
		self:ShowBone( 'R_Hold', true )
		self:ShowBone( 'L_Art', true )
		self:ShowBone( 'R_Art', true )
		self:ShowBone( 'L_Gatling', true )
		self:ShowBone( 'R_Gatling', true )
		end
		
		ForkThread( function()

		end
		)
    end,
    
}

TypeClass = CSKTL0301