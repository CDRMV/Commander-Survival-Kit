#****************************************************************************
#**
#**  File     :  /units/UEL0303b/UEL0303b_script.lua
#**  Author(s):  CDRMV
#**
#**  Summary  :  UEF Patroit/Emancipator Mech Script
#**
#**  Copyright © 2025, Commander Survival Kit Project
#****************************************************************************

local TerranWeaponFile = import('/lua/terranweapons.lua')
local TWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local DummyTurretWeapon = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').DummyTurretWeapon
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone

CSKTL0303 = Class(TWalkingLandUnit) {

    Weapons = {
        L_MissileLauncher = Class(TSAMLauncher) {},
		R_MissileLauncher = Class(TSAMLauncher) {},
		Dummy = Class(DummyTurretWeapon) {},
		R_Cannon = Class(TDFGaussCannonWeapon) {

		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'R_Cannon_Muzzle01' then
		CreateAttachedEmitter(self.unit, 'R_Cannon_Shell01', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/autocannon_shell_01_emit.bp')
		end
		if muzzle == 'R_Cannon_Muzzle02' then
		CreateAttachedEmitter(self.unit, 'R_Cannon_Shell02', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		},
		L_Cannon = Class(TDFGaussCannonWeapon) {
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'L_Cannon_Muzzle01' then
		CreateAttachedEmitter(self.unit, 'L_Cannon_Shell01', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/autocannon_shell_01_emit.bp')
		end
		if muzzle == 'L_Cannon_Muzzle02' then
		CreateAttachedEmitter(self.unit, 'L_Cannon_Shell02', self.unit:GetArmy(), '/mods/Commander Survival Kit Units/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		},
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

	OnCreate = function(self)
        TWalkingLandUnit.OnCreate(self)
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
		self:SetWeaponEnabledByLabel('L_MissileLauncher', false)
		self:SetWeaponEnabledByLabel('R_MissileLauncher', false)
		elseif RandomNumber == 2 then
		self:ShowBone( 'L_MissileLauncher', true )
		self:HideBone( 'R_MissileLauncher', true )
		self:HideBone( 'L_Gatling_Arm', true )
		self:ShowBone( 'R_Gatling_Arm', true )
		self:HideBone( 'L_Cannon_Arm', true )
		self:HideBone( 'R_Cannon_Arm', true )
		self:SetWeaponEnabledByLabel('Dummy', true)
		self:SetWeaponEnabledByLabel('L_MissileLauncher', true)
		self:SetWeaponEnabledByLabel('R_MissileLauncher', false)
		self:SetWeaponEnabledByLabel('L_GatlingCannon', false)
		self:SetWeaponEnabledByLabel('R_GatlingCannon', true)
		self:SetWeaponEnabledByLabel('R_Cannon', false)
		self:SetWeaponEnabledByLabel('L_Cannon', false)
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
		self:SetWeaponEnabledByLabel('L_Cannon', false)
		self:SetWeaponEnabledByLabel('L_GatlingCannon', true)
		self:SetWeaponEnabledByLabel('L_MissileLauncher', false)
		
        elseif enh == 'RightGatling' then
		self:SetWeaponEnabledByLabel('R_Cannon', false)
		self:SetWeaponEnabledByLabel('R_GatlingCannon', true)
		self:SetWeaponEnabledByLabel('R_MissileLauncher', false)
		
		elseif enh == 'RightAutoCannon' then
		self:SetWeaponEnabledByLabel('R_Cannon', true)
		self:SetWeaponEnabledByLabel('R_GatlingCannon', false)
		self:SetWeaponEnabledByLabel('R_MissileLauncher', false)
		
		elseif enh == 'LeftAutoCannon' then
		self:SetWeaponEnabledByLabel('L_Cannon', true)
		self:SetWeaponEnabledByLabel('L_GatlingCannon', false)
		self:SetWeaponEnabledByLabel('L_MissileLauncher', false)
		
		elseif enh == 'LeftMissileLauncher' then
		self:SetWeaponEnabledByLabel('L_Cannon', false)
		self:SetWeaponEnabledByLabel('L_GatlingCannon', false)
		self:SetWeaponEnabledByLabel('L_MissileLauncher', true)
		
		elseif enh == 'RightMissileLauncher' then
		self:SetWeaponEnabledByLabel('R_Cannon', false)
		self:SetWeaponEnabledByLabel('R_GatlingCannon', false)
		self:SetWeaponEnabledByLabel('R_MissileLauncher', true)
        end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		local army = self:GetArmy()
		CreateAttachedEmitter(self, 'L_Gatling_Arm', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'L_Gatling_Arm', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'L_Gatling_Arm', 1.0)
		explosion.CreateFlash( self, 'L_Gatling_Arm', 1.0, army )
		self:HideBone("L_Cannon_Arm", true)
		self:HideBone("L_Gatling_Arm", true)
		self:HideBone("L_MissileLauncher", true)
		CreateAttachedEmitter(self, 'R_Gatling_Arm', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'R_Gatling_Arm', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'R_Gatling_Arm', 1.0)
		explosion.CreateFlash( self, 'R_Gatling_Arm', 1.0, army )
		self:HideBone("R_Cannon_Arm", true)
		self:HideBone("R_Gatling_Arm", true)
		self:HideBone("R_MissileLauncher", true)

        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end

    
        self:DestroyAllDamageEffects()
        self:CreateWreckage( overkillRatio )
		
		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
	  
}
TypeClass = CSKTL0303