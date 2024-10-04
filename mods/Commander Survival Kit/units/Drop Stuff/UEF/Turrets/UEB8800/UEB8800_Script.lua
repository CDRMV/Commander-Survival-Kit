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
		Two_GatlingCannons = Class(TDFPlasmaCannonWeapon) 
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip1 then
                    self.SpinManip1:SetTargetSpeed(0)
                end
				if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(0)
                end
                self.ExhaustEffects1 = EffectUtils.CreateBoneEffects( self.unit, 'L_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
				self.ExhaustEffects2 = EffectUtils.CreateBoneEffects( self.unit, 'R_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFPlasmaCannonWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip1 then 
                    self.SpinManip1 = CreateRotator(self.unit, 'L_Gatling_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip1)
                end
				
				if not self.SpinManip2 then 
                    self.SpinManip2 = CreateRotator(self.unit, 'R_Gatling_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip2)
                end
                
                if self.SpinManip1 then
                    self.SpinManip1:SetTargetSpeed(500)
                end
				
				if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(500)
                end
                TDFPlasmaCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(200)
                end
				if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(200)
                end
                self.ExhaustEffects1 = EffectUtils.CreateBoneEffects( self.unit, 'L_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
				self.ExhaustEffects2 = EffectUtils.CreateBoneEffects( self.unit, 'R_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
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
		self:SetWeaponEnabledByLabel('Two_GatlingCannons', false)
		self:SetWeaponEnabledByLabel('Two_Gauss', false)
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
		self:HideBone('Armor', false)
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		self:SetWeaponEnabledByLabel('Gauss', false)
		self:SetWeaponEnabledByLabel('MachineGun', true)  
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:SetWeaponEnabledByLabel('MissileRack01', false)
		self:SetWeaponEnabledByLabel('Two_MachineGuns', false)
		self:SetWeaponEnabledByLabel('Two_GatlingCannons', false)
		self:SetWeaponEnabledByLabel('Two_Gauss', false)
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
		elseif enh =='TwoMachineGuns' then
		self:SetWeaponEnabledByLabel('Gauss', false)
		self:SetWeaponEnabledByLabel('MachineGun', false)  
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:SetWeaponEnabledByLabel('MissileRack01', false)
		self:SetWeaponEnabledByLabel('Two_MachineGuns', true)
		self:SetWeaponEnabledByLabel('Two_GatlingCannons', false)
		self:SetWeaponEnabledByLabel('Two_Gauss', false)
		self:HideBone('SAMMissileLauncher', true)
		self:HideBone('SingleBarrel', true)
		self:HideBone('SingleMachineGun', true)
		self:HideBone('Gatling', true)
		self:HideBone('Gauss', true)
		self:ShowBone('TwoBarrel', true)
		self:HideBone('Two_Gatling', true)
		self:HideBone('Two_Gauss', true)
		self:ShowBone('Two_MachineGun', true)		
        elseif enh =='TwoMachineGunsRemove' then
		self:SetWeaponEnabledByLabel('Two_MachineGuns', false)  
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
		self:HideBone('Armor', false)
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		self:SetWeaponEnabledByLabel('Gauss', true)
		self:SetWeaponEnabledByLabel('MachineGun', false)  
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:SetWeaponEnabledByLabel('MissileRack01', false)
		self:SetWeaponEnabledByLabel('Two_MachineGuns', false)
		self:SetWeaponEnabledByLabel('Two_GatlingCannons', false)
		self:SetWeaponEnabledByLabel('Two_Gauss', false)
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
        elseif enh =='TwoGaussCannons' then
		self:SetWeaponEnabledByLabel('Gauss', false)
		self:SetWeaponEnabledByLabel('MachineGun', false)  
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:SetWeaponEnabledByLabel('MissileRack01', false)
		self:SetWeaponEnabledByLabel('Two_MachineGuns', false)
		self:SetWeaponEnabledByLabel('Two_GatlingCannons', false)
		self:SetWeaponEnabledByLabel('Two_Gauss', true)
		self:HideBone('SAMMissileLauncher', true)
		self:HideBone('SingleBarrel', true)
		self:HideBone('SingleMachineGun', true)
		self:HideBone('Gatling', true)
		self:HideBone('Gauss', true)
		self:ShowBone('TwoBarrel', true)
		self:HideBone('Two_Gatling', true)
		self:ShowBone('Two_Gauss', true)
		self:HideBone('Two_MachineGun', true)
		self:ShowBone('CenterAmmo2', true)
		self:HideBone('CenterAmmo', true)
        elseif enh =='TwoGaussCannonsRemove' then
		self:SetWeaponEnabledByLabel('Two_Gauss', false)
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
		self:HideBone('CenterAmmo2', true) 		
        elseif enh =='GatlingCannon' then
		self:HideBone('Armor', false)
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		self:SetWeaponEnabledByLabel('Gauss', false)
		self:SetWeaponEnabledByLabel('MachineGun', false)  
		self:SetWeaponEnabledByLabel('GatlingCannon', true)
		self:SetWeaponEnabledByLabel('MissileRack01', false)
		self:SetWeaponEnabledByLabel('Two_MachineGuns', false)
		self:SetWeaponEnabledByLabel('Two_GatlingCannons', false)
		self:SetWeaponEnabledByLabel('Two_Gauss', false)
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
		elseif enh =='TwoGatlingCannons' then
		self:SetWeaponEnabledByLabel('Gauss', false)
		self:SetWeaponEnabledByLabel('MachineGun', false)  
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:SetWeaponEnabledByLabel('MissileRack01', false)
		self:SetWeaponEnabledByLabel('Two_MachineGuns', false)
		self:SetWeaponEnabledByLabel('Two_GatlingCannons', true)
		self:SetWeaponEnabledByLabel('Two_Gauss', false)
		self:HideBone('SAMMissileLauncher', true)
		self:HideBone('SingleBarrel', true)
		self:HideBone('SingleMachineGun', true)
		self:HideBone('Gatling', true)
		self:HideBone('Gauss', true)
		self:ShowBone('TwoBarrel', true)
		self:ShowBone('Two_Gatling', true)
		self:HideBone('Two_Gauss', true)
		self:HideBone('Two_MachineGun', true)
        elseif enh == 'TwoGatlingCannonsRemove' then
		self:SetWeaponEnabledByLabel('Two_GatlingCannons', false)
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
		self:HideBone('Armor', false)
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		self:SetWeaponEnabledByLabel('GatlingCannon', false)
		self:SetWeaponEnabledByLabel('Gauss', false)
		self:SetWeaponEnabledByLabel('MachineGun', false)  
		self:SetWeaponEnabledByLabel('MissileRack01', true)
		self:SetWeaponEnabledByLabel('Two_MachineGuns', false)
		self:SetWeaponEnabledByLabel('Two_GatlingCannons', false)
		self:SetWeaponEnabledByLabel('Two_Gauss', false)
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
		self:SetWeaponEnabledByLabel('MissileRack01', false)
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
		local wep1 = self:GetWeaponByLabel('GatlingCannon')
        wep1:ChangeDamage(250)
		local wep2 = self:GetWeaponByLabel('Gauss')
        wep2:ChangeDamage(350)
		local wep3 = self:GetWeaponByLabel('MachineGun')
        wep3:ChangeDamage(20)
		local wep4 = self:GetWeaponByLabel('MissileRack01')
        wep4:ChangeDamage(300)
		local wep5 = self:GetWeaponByLabel('Two_GatlingCannons')
        wep5:ChangeDamage(250)
		local wep6 = self:GetWeaponByLabel('Two_Gauss')
        wep6:ChangeDamage(350)
		local wep7 = self:GetWeaponByLabel('Two_MachineGuns')
        wep7:ChangeDamage(20)
		self:ShowBone('L_Ammo', true)
		self:HideBone('L_Ammo2', false)
		self:HideBone('L_Sensor', false)
        elseif enh == 'LAmmoRemove' then
		local wep1 = self:GetWeaponByLabel('GatlingCannon')
        wep1:ChangeDamage(175)
		local wep2 = self:GetWeaponByLabel('Gauss')
        wep2:ChangeDamage(250)
		local wep3 = self:GetWeaponByLabel('MachineGun')
        wep3:ChangeDamage(13.5)
		local wep4 = self:GetWeaponByLabel('MissileRack01')
        wep4:ChangeDamage(200)
		local wep5 = self:GetWeaponByLabel('Two_GatlingCannons')
        wep5:ChangeDamage(175)
		local wep6 = self:GetWeaponByLabel('Two_Gauss')
        wep6:ChangeDamage(250)
		local wep7 = self:GetWeaponByLabel('Two_MachineGuns')
        wep7:ChangeDamage(13.5)
		self:HideBone('L_Ammo', false)
		self:HideBone('L_Ammo2', false)
		self:HideBone('L_Sensor', false)
		elseif enh =='LAmmo2' then
		local wep1 = self:GetWeaponByLabel('GatlingCannon')
        wep1:ChangeDamage(350)
		local wep2 = self:GetWeaponByLabel('Gauss')
        wep2:ChangeDamage(450)
		local wep3 = self:GetWeaponByLabel('MachineGun')
        wep3:ChangeDamage(30)
		local wep4 = self:GetWeaponByLabel('MissileRack01')
        wep4:ChangeDamage(400)
		local wep5 = self:GetWeaponByLabel('Two_GatlingCannons')
        wep5:ChangeDamage(350)
		local wep6 = self:GetWeaponByLabel('Two_Gauss')
        wep6:ChangeDamage(450)
		local wep7 = self:GetWeaponByLabel('Two_MachineGuns')
        wep7:ChangeDamage(30)
		self:HideBone('L_Ammo', false)
		self:ShowBone('L_Ammo2', true)
		self:HideBone('L_Sensor', false)
        elseif enh == 'LAmmo2Remove' then
		local wep1 = self:GetWeaponByLabel('GatlingCannon')
        wep1:ChangeDamage(250)
		local wep2 = self:GetWeaponByLabel('Gauss')
        wep2:ChangeDamage(350)
		local wep3 = self:GetWeaponByLabel('MachineGun')
        wep3:ChangeDamage(20)
		local wep4 = self:GetWeaponByLabel('MissileRack01')
        wep4:ChangeDamage(300)
		local wep5 = self:GetWeaponByLabel('Two_GatlingCannons')
        wep5:ChangeDamage(250)
		local wep6 = self:GetWeaponByLabel('Two_Gauss')
        wep6:ChangeDamage(350)
		local wep7 = self:GetWeaponByLabel('Two_MachineGuns')
        wep7:ChangeDamage(20)
		self:HideBone('L_Ammo', false)
		self:HideBone('L_Ammo2', false)
		self:HideBone('L_Sensor', false)
		elseif enh =='LSensor' then
		local wep = self:GetWeaponByLabel('Dummy')
        wep:ChangeMaxRadius(60)
		local wep1 = self:GetWeaponByLabel('GatlingCannon')
        wep1:ChangeMaxRadius(60)
		local wep2 = self:GetWeaponByLabel('Gauss')
        wep2:ChangeMaxRadius(60)
		local wep3 = self:GetWeaponByLabel('MachineGun')
        wep3:ChangeMaxRadius(60)
		local wep4 = self:GetWeaponByLabel('MissileRack01')
        wep4:ChangeMaxRadius(60)
		local wep5 = self:GetWeaponByLabel('Two_GatlingCannons')
        wep5:ChangeMaxRadius(60)
		local wep6 = self:GetWeaponByLabel('Two_Gauss')
        wep6:ChangeMaxRadius(60)
		local wep7 = self:GetWeaponByLabel('Two_MachineGuns')
        wep7:ChangeMaxRadius(60)
		self:SetIntelRadius('Vision', 60)
		self:HideBone('L_Ammo', false)
		self:HideBone('L_Ammo2', false)
		self:ShowBone('L_Sensor', true)
        elseif enh == 'LSensorRemove' then
		local wep = self:GetWeaponByLabel('Dummy')
        wep:ChangeMaxRadius(30)
		local wep1 = self:GetWeaponByLabel('GatlingCannon')
        wep1:ChangeMaxRadius(30)
		local wep2 = self:GetWeaponByLabel('Gauss')
        wep2:ChangeMaxRadius(30)
		local wep3 = self:GetWeaponByLabel('MachineGun')
        wep3:ChangeMaxRadius(30)
		local wep4 = self:GetWeaponByLabel('MissileRack01')
        wep4:ChangeMaxRadius(30)
		local wep5 = self:GetWeaponByLabel('Two_GatlingCannons')
        wep5:ChangeMaxRadius(30)
		local wep6 = self:GetWeaponByLabel('Two_Gauss')
        wep6:ChangeMaxRadius(30)
		local wep7 = self:GetWeaponByLabel('Two_MachineGuns')
        wep7:ChangeMaxRadius(30)
		self:SetIntelRadius('Vision', 20)
		self:HideBone('L_Ammo', false)
		self:HideBone('L_Ammo2', false)
		self:HideBone('L_Sensor', false)
		elseif enh =='RAmmo' then
		local wep1 = self:GetWeaponByLabel('GatlingCannon')
        wep1:ChangeDamage(250)
		local wep2 = self:GetWeaponByLabel('Gauss')
        wep2:ChangeDamage(350)
		local wep3 = self:GetWeaponByLabel('MachineGun')
        wep3:ChangeDamage(20)
		local wep4 = self:GetWeaponByLabel('MissileRack01')
        wep4:ChangeDamage(300)
		local wep5 = self:GetWeaponByLabel('Two_GatlingCannons')
        wep5:ChangeDamage(250)
		local wep6 = self:GetWeaponByLabel('Two_Gauss')
        wep6:ChangeDamage(350)
		local wep7 = self:GetWeaponByLabel('Two_MachineGuns')
        wep7:ChangeDamage(20)
		self:ShowBone('R_Ammo', true)
		self:HideBone('R_Ammo2', false)
		self:HideBone('R_Sensor', false)
        elseif enh == 'RAmmoRemove' then
		local wep1 = self:GetWeaponByLabel('GatlingCannon')
        wep1:ChangeDamage(175)
		local wep2 = self:GetWeaponByLabel('Gauss')
        wep2:ChangeDamage(250)
		local wep3 = self:GetWeaponByLabel('MachineGun')
        wep3:ChangeDamage(13.5)
		local wep4 = self:GetWeaponByLabel('MissileRack01')
        wep4:ChangeDamage(200)
		local wep5 = self:GetWeaponByLabel('Two_GatlingCannons')
        wep5:ChangeDamage(175)
		local wep6 = self:GetWeaponByLabel('Two_Gauss')
        wep6:ChangeDamage(250)
		local wep7 = self:GetWeaponByLabel('Two_MachineGuns')
        wep7:ChangeDamage(13.5)
		self:HideBone('R_Ammo', false)
		self:HideBone('R_Ammo2', false)
		self:HideBone('R_Sensor', false)
		elseif enh =='RAmmo2' then
		local wep1 = self:GetWeaponByLabel('GatlingCannon')
        wep1:ChangeDamage(350)
		local wep2 = self:GetWeaponByLabel('Gauss')
        wep2:ChangeDamage(450)
		local wep3 = self:GetWeaponByLabel('MachineGun')
        wep3:ChangeDamage(30)
		local wep4 = self:GetWeaponByLabel('MissileRack01')
        wep4:ChangeDamage(400)
		local wep5 = self:GetWeaponByLabel('Two_GatlingCannons')
        wep5:ChangeDamage(350)
		local wep6 = self:GetWeaponByLabel('Two_Gauss')
        wep6:ChangeDamage(450)
		local wep7 = self:GetWeaponByLabel('Two_MachineGuns')
        wep7:ChangeDamage(30)
		self:HideBone('R_Ammo', false)
		self:ShowBone('R_Ammo2', true)
		self:HideBone('R_Sensor', false)
        elseif enh == 'RAmmo2Remove' then
		local wep1 = self:GetWeaponByLabel('GatlingCannon')
        wep1:ChangeDamage(250)
		local wep2 = self:GetWeaponByLabel('Gauss')
        wep2:ChangeDamage(350)
		local wep3 = self:GetWeaponByLabel('MachineGun')
        wep3:ChangeDamage(20)
		local wep4 = self:GetWeaponByLabel('MissileRack01')
        wep4:ChangeDamage(300)
		local wep5 = self:GetWeaponByLabel('Two_GatlingCannons')
        wep5:ChangeDamage(250)
		local wep6 = self:GetWeaponByLabel('Two_Gauss')
        wep6:ChangeDamage(350)
		local wep7 = self:GetWeaponByLabel('Two_MachineGuns')
        wep7:ChangeDamage(20)
		self:HideBone('R_Ammo', false)
		self:HideBone('R_Ammo2', false)
		self:HideBone('R_Sensor', false)
		elseif enh =='RSensor' then
		local wep = self:GetWeaponByLabel('Dummy')
        wep:ChangeMaxRadius(60)
		local wep1 = self:GetWeaponByLabel('GatlingCannon')
        wep1:ChangeMaxRadius(60)
		local wep2 = self:GetWeaponByLabel('Gauss')
        wep2:ChangeMaxRadius(60)
		local wep3 = self:GetWeaponByLabel('MachineGun')
        wep3:ChangeMaxRadius(60)
		local wep4 = self:GetWeaponByLabel('MissileRack01')
        wep4:ChangeMaxRadius(60)
		local wep5 = self:GetWeaponByLabel('Two_GatlingCannons')
        wep5:ChangeMaxRadius(60)
		local wep6 = self:GetWeaponByLabel('Two_Gauss')
        wep6:ChangeMaxRadius(60)
		local wep7 = self:GetWeaponByLabel('Two_MachineGuns')
        wep7:ChangeMaxRadius(60)
		self:SetIntelRadius('Vision', 60)
		self:HideBone('R_Ammo', false)
		self:HideBone('R_Ammo2', false)
		self:ShowBone('R_Sensor', true)
        elseif enh == 'RSensorRemove' then
		local wep = self:GetWeaponByLabel('Dummy')
        wep:ChangeMaxRadius(30)
		local wep1 = self:GetWeaponByLabel('GatlingCannon')
        wep1:ChangeMaxRadius(30)
		local wep2 = self:GetWeaponByLabel('Gauss')
        wep2:ChangeMaxRadius(30)
		local wep3 = self:GetWeaponByLabel('MachineGun')
        wep3:ChangeMaxRadius(30)
		local wep4 = self:GetWeaponByLabel('MissileRack01')
        wep4:ChangeMaxRadius(30)
		local wep5 = self:GetWeaponByLabel('Two_GatlingCannons')
        wep5:ChangeMaxRadius(30)
		local wep6 = self:GetWeaponByLabel('Two_Gauss')
        wep6:ChangeMaxRadius(30)
		local wep7 = self:GetWeaponByLabel('Two_MachineGuns')
        wep7:ChangeMaxRadius(30)
		self:SetIntelRadius('Vision', 20)
		self:HideBone('R_Ammo', false)
		self:HideBone('R_Ammo2', false)
		self:HideBone('R_Sensor', false)
		elseif enh =='MachineGunArmor' then
		self:ShowBone('Armor', false)
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
        elseif enh == 'MachineGunArmorRemove' then
		self:HideBone('Armor', false)
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		elseif enh =='GaussCannonArmor' then
		self:ShowBone('Armor', false)
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
        elseif enh == 'GaussCannonArmorRemove' then
		self:HideBone('Armor', false)
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		elseif enh =='GatlingCannonArmor' then
		self:ShowBone('Armor', false)
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
        elseif enh == 'GatlingCannonArmorRemove' then
		self:HideBone('Armor', false)
		self:SetMaxHealth(10000)
		self:SetHealth(self, 10000)
		elseif enh =='MissileLauncherArmor' then
		self:ShowBone('Armor', false)
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
        elseif enh == 'MissileLauncherArmorRemove' then
		self:HideBone('Armor', false)
		self:SetMaxHealth(15000)
		self:SetHealth(self, 15000)
        end
    end,

}

TypeClass = UEB8800