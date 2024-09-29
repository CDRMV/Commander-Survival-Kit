#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0202/UEL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local TDFPlasmaCannonWeapon = import('/lua/terranweapons.lua').TDFPlasmaCannonWeapon
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')

UEB8800 = Class(TLandUnit) {

    Weapons = {
	    Dummy = Class(TDFMachineGunWeapon) {

        },
		MissileRack01 = Class(TSAMLauncher) {},
		
        MachineGun = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Two_MachineGuns = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		Gauss = Class(TDFGaussCannonWeapon) {},
		
		Two_Gauss = Class(TDFGaussCannonWeapon) {},
		
		GatlingCannon = Class(TDFPlasmaCannonWeapon) 
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFPlasmaCannonWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'Gatling_Rotate', 'z', nil, 270, 180, 60)
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
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFPlasmaCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
    },

    OnCreate = function(self)
        TLandUnit.OnCreate(self)
		------------------- 
		-- The Turret is an Mobile Unit = Movable Turret durning attack? -- No, so lets deactivate that
		-- Deactivates Move and Turn Speed.
		-- Effects: Keep the Turret to be angled on the Terrian and not movable during attacks

		self:SetSpeedMult(0)
		self:SetTurnMult(0)
		
		-----------------

		self:SetWeaponEnabledByLabel('Two_MachineGuns', false)
		self:SetWeaponEnabledByLabel('MachineGun', true)
		self:SetWeaponEnabledByLabel('Gauss', false)
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:SetWeaponEnabledByLabel('MissileRack01', false)
		self:HideBone('Armor', false)
		self:HideBone('L_Ammo', false)
		self:HideBone('R_Ammo', false)
		self:HideBone('L_Ammo2', false)
		self:HideBone('R_Ammo2', false)
		self:HideBone('L_Sensor', false)
		self:HideBone('R_Sensor', false)
		self:HideBone('Gatling', true)
		--self:HideBone('SingleBarrel', true)
		--self:HideBone('SingleMachineGun', true)
		self:HideBone('Gauss', true)
		self:HideBone('TwoBarrel', true)
		self:HideBone('Two_Gatling', true)
		self:HideBone('Two_Gauss', true)
		self:HideBone('Two_MachineGun', true)
		self:HideBone('SAMMissileLauncher', true)
		self:HideBone('CenterAmmo', false)
		self:HideBone('CenterAmmo2', false)
		
    end,
	
	CreateEnhancement = function(self, enh)
        TLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh =='MachineGun' then
		self:SetWeaponEnabledByLabel('Gauss', false)
		self:SetWeaponEnabledByLabel('MachineGun', true)  
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:SetWeaponEnabledByLabel('MissileRack01', false)
		self:HideBone('SAMMissileLauncher', true)
		self:ShowBone('SingleBarrel', true)
		self:ShowBone('SingleMachineGun', true)
		self:HideBone('Gatling', true)
		self:HideBone('Gauss', true)
		self:HideBone('TwoBarrel', true)
		self:HideBone('Two_Gatling', true)
		self:HideBone('Two_Gauss', true)
		self:HideBone('Two_MachineGun', true)		
        elseif enh =='MachineGunRemove' then
		self:SetWeaponEnabledByLabel('MachineGun', false)  
		self:HideBone('SAMMissileLauncher', true)
		self:HideBone('SingleBarrel', true)
		self:HideBone('SingleMachineGun', true)
		self:HideBone('Gatling', true)
		self:HideBone('Gauss', true)
		self:HideBone('TwoBarrel', true)
		self:HideBone('Two_Gatling', true)
		self:HideBone('Two_Gauss', true)
		self:HideBone('Two_MachineGun', true)
        elseif enh =='GaussCannon' then
		self:SetWeaponEnabledByLabel('Gauss', true)
		self:SetWeaponEnabledByLabel('MachineGun', false)  
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:SetWeaponEnabledByLabel('MissileRack01', false)
		self:HideBone('SAMMissileLauncher', true)
		self:ShowBone('SingleBarrel', true)
		self:HideBone('SingleMachineGun', true)
		self:HideBone('Gatling', true)
		self:ShowBone('Gauss', true)
		self:HideBone('TwoBarrel', true)
		self:HideBone('Two_Gatling', true)
		self:HideBone('Two_Gauss', true)
		self:HideBone('Two_MachineGun', true)
		self:ShowBone('CenterAmmo', true)
        elseif enh =='GaussCannonRemove' then
		self:SetWeaponEnabledByLabel('Gauss', false)
		self:HideBone('SAMMissileLauncher', true)
		self:HideBone('SingleBarrel', true)
		self:HideBone('SingleMachineGun', true)
		self:HideBone('Gatling', true)
		self:HideBone('Gauss', true)
		self:HideBone('TwoBarrel', true)
		self:HideBone('Two_Gatling', true)
		self:HideBone('Two_Gauss', true)
		self:HideBone('Two_MachineGun', true)
		self:HideBone('CenterAmmo', true)
            --local bp = self:GetBlueprint().Enhancements['HeavyAntiMatterCannon']
            --if not bp then return end
            --local wep = self:GetWeaponByLabel('RightZephyr')
            --wep:AddDamageMod(-bp.ZephyrDamageMod)
            --local bpDisrupt = self:GetBlueprint().Weapon[1].MaxRadius
            --wep:ChangeMaxRadius(bpDisrupt or 22)
            --local oc = self:GetWeaponByLabel('OverCharge')
            --oc:ChangeMaxRadius(bpDisrupt or 22)            
        elseif enh =='GatlingCannon' then
		self:SetWeaponEnabledByLabel('Gauss', false)
		self:SetWeaponEnabledByLabel('MachineGun', false)  
		self:SetWeaponEnabledByLabel('GatlingCannon', true)
		self:SetWeaponEnabledByLabel('MissileRack01', false)
		self:HideBone('SAMMissileLauncher', true)
		self:ShowBone('SingleBarrel', true)
		self:HideBone('SingleMachineGun', true)
		self:ShowBone('Gatling', true)
		self:HideBone('Gauss', true)
		self:HideBone('TwoBarrel', true)
		self:HideBone('Two_Gatling', true)
		self:HideBone('Two_Gauss', true)
		self:HideBone('Two_MachineGun', true)
        elseif enh == 'GatlingCannonRemove' then
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:HideBone('SAMMissileLauncher', true)
		self:HideBone('SingleBarrel', true)
		self:HideBone('SingleMachineGun', true)
		self:HideBone('Gatling', true)
		self:HideBone('Gauss', true)
		self:HideBone('TwoBarrel', true)
		self:HideBone('Two_Gatling', true)
		self:HideBone('Two_Gauss', true)
		self:HideBone('Two_MachineGun', true)
		elseif enh =='MissileLauncher' then
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:SetWeaponEnabledByLabel('Gauss', false)
		self:SetWeaponEnabledByLabel('MachineGun', false)  
		self:SetWeaponEnabledByLabel('MissileRack01', true)
		self:ShowBone('SAMMissileLauncher', true)
		self:HideBone('SingleBarrel', true)
		self:HideBone('SingleMachineGun', true)
		self:HideBone('Gatling', true)
		self:HideBone('Gauss', true)
		self:HideBone('TwoBarrel', true)
		self:HideBone('Two_Gatling', true)
		self:HideBone('Two_Gauss', true)
		self:HideBone('Two_MachineGun', true)
        elseif enh == 'MissileLauncherRemove' then
		self:HideBone('SAMMissileLauncher', true)
		self:HideBone('SingleBarrel', true)
		self:HideBone('SingleMachineGun', true)
		self:HideBone('Gatling', true)
		self:HideBone('Gauss', true)
		self:HideBone('TwoBarrel', true)
		self:HideBone('Two_Gatling', true)
		self:HideBone('Two_Gauss', true)
		self:HideBone('Two_MachineGun', true)
		elseif enh =='LAmmo' then
		self:ShowBone('L_Ammo', true)
		self:HideBone('L_Ammo2', false)
		self:HideBone('L_Sensor', false)
        elseif enh == 'LAmmoRemove' then
		self:HideBone('L_Ammo', false)
		self:HideBone('L_Ammo2', false)
		self:HideBone('L_Sensor', false)
		elseif enh =='LAmmo2' then
		self:HideBone('L_Ammo', false)
		self:ShowBone('L_Ammo2', true)
		self:HideBone('L_Sensor', false)
        elseif enh == 'LAmmoRemove' then
		self:HideBone('L_Ammo', false)
		self:HideBone('L_Ammo2', false)
		self:HideBone('L_Sensor', false)
		elseif enh =='LSensor' then
		self:HideBone('L_Ammo', false)
		self:HideBone('L_Ammo2', false)
		self:ShowBone('L_Sensor', true)
        elseif enh == 'LSensorRemove' then
		self:HideBone('L_Ammo', false)
		self:HideBone('L_Ammo2', false)
		self:HideBone('L_Sensor', false)
		elseif enh =='RAmmo' then
		self:ShowBone('R_Ammo', true)
		self:HideBone('R_Ammo2', false)
		self:HideBone('R_Sensor', false)
        elseif enh == 'RAmmoRemove' then
		self:HideBone('R_Ammo', false)
		self:HideBone('R_Ammo2', false)
		self:HideBone('R_Sensor', false)
		elseif enh =='RAmmo2' then
		self:HideBone('R_Ammo', false)
		self:ShowBone('R_Ammo2', true)
		self:HideBone('R_Sensor', false)
        elseif enh == 'RAmmoRemove' then
		self:HideBone('R_Ammo', false)
		self:HideBone('R_Ammo2', false)
		self:HideBone('R_Sensor', false)
		elseif enh =='RSensor' then
		self:HideBone('R_Ammo', false)
		self:HideBone('R_Ammo2', false)
		self:ShowBone('R_Sensor', true)
        elseif enh == 'RSensorRemove' then
		self:HideBone('R_Ammo', false)
		self:HideBone('R_Ammo2', false)
		self:HideBone('R_Sensor', false)
		elseif enh =='MachineGunArmor' then
		self:ShowBone('Armor', false)
        elseif enh == 'MachineGunArmorRemove' then
		self:HideBone('Armor', false)
		elseif enh =='GaussCannonArmor' then
		self:ShowBone('Armor', false)
        elseif enh == 'GaussCannonArmorRemove' then
		self:HideBone('Armor', false)
		elseif enh =='GatlingCannonArmor' then
		self:ShowBone('Armor', false)
        elseif enh == 'GatlingCannonArmorRemove' then
		self:HideBone('Armor', false)
		elseif enh =='MissileLauncherArmor' then
		self:ShowBone('Armor', false)
        elseif enh == 'MissileLauncherArmorRemove' then
		self:HideBone('Armor', false)
        end
    end,

}

TypeClass = UEB8800