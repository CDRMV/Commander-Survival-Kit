#****************************************************************************
#**
#**  File     :  /units/UEL0303b/UEL0303b_script.lua
#**  Author(s):  Resin_Smoker
#**
#**  Summary  :  UEF Siege Assault Bot Script (With Napalm Launcher)
#**
#**  Copyright © 2009, 4th-Dimension
#****************************************************************************

local TerranWeaponFile = import('/lua/terranweapons.lua')
local TWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
CSKTL0303 = Class(TWalkingLandUnit) {

    Weapons = {
        L_MissileLauncher = Class(TSAMLauncher) {},
		R_MissileLauncher = Class(TSAMLauncher) {},
		Dummy = Class(TDFGaussCannonWeapon) {},
		R_Cannon = Class(TDFGaussCannonWeapon) {},
		L_Cannon = Class(TDFGaussCannonWeapon) {},
		R_GatlingCannon = Class(TDFMachineGunWeapon) 
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'R_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFMachineGunWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'R_Gatling_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TDFMachineGunWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'R_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFMachineGunWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
		L_GatlingCannon = Class(TDFMachineGunWeapon) 
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'L_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFMachineGunWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'L_Gatling_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TDFMachineGunWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'L_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFMachineGunWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
    },  

	OnStopBeingBuilt = function(self, builder, layer)
        TWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:HideBone( 'L_MissileLauncher', true )
		self:HideBone( 'R_MissileLauncher', true )
		self:HideBone( 'L_Gatling_Arm', true )
		self:HideBone( 'R_Gatling_Arm', true )
		self:HideBone( 'L_Cannon_Arm', true )
		self:HideBone( 'R_Cannon_Arm', true )
		local RandomNumber = math.random(1, 2)
		
		if RandomNumber == 1 then
		self:HideBone( 'L_MissileLauncher', true )
		self:HideBone( 'R_MissileLauncher', true )
		self:HideBone( 'L_Gatling_Arm', true )
		self:HideBone( 'R_Gatling_Arm', true )
		self:ShowBone( 'L_Cannon_Arm', true )
		self:ShowBone( 'R_Cannon_Arm', true )
		self:SetWeaponEnabledByLabel('Dummy', true)
		self:SetWeaponEnabledByLabel('R_Cannon', true)
		self:SetWeaponEnabledByLabel('L_Cannon', true)
		self:SetWeaponEnabledByLabel('L_GatlingCannon', false)
		self:SetWeaponEnabledByLabel('R_GatlingCannon', false)
		elseif RandomNumber == 2 then
		self:ShowBone( 'L_MissileLauncher', true )
		self:HideBone( 'R_MissileLauncher', true )
		self:HideBone( 'L_Gatling_Arm', true )
		self:ShowBone( 'R_Gatling_Arm', true )
		self:HideBone( 'L_Cannon_Arm', true )
		self:HideBone( 'R_Cannon_Arm', true )
		self:SetWeaponEnabledByLabel('Dummy', true)
		self:SetWeaponEnabledByLabel('L_GatlingCannon', false)
		self:SetWeaponEnabledByLabel('R_GatlingCannon', true)
		self:SetWeaponEnabledByLabel('R_Cannon', false)
		self:SetWeaponEnabledByLabel('L_Cannon', false)
		end
		
		ForkThread( function()

		end
		)
    end,
    
}
TypeClass = CSKTL0303