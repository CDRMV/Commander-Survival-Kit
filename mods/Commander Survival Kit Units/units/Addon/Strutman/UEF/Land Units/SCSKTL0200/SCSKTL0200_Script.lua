--****************************************************************************
--**
--**  Author(s):  Strutman12345
--**
--**  Summary  :  UEF Armoured Humvee Script

--****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TWeapons = import("/lua/terranweapons.lua")
local TAMPhalanxWeapon = TWeapons.TAMPhalanxWeapon

local EffectUtils = import("/lua/effectutilities.lua")
local Effects = import("/lua/effecttemplates.lua")

SCSKTL0200 = Class(TLandUnit) {

    Weapons = {
            GatlingCannon = Class(TAMPhalanxWeapon)
        
            {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                EffectUtils.CreateBoneEffects(self.unit, 'Gatling_Muzzle', self.unit.Army, Effects.WeaponSteam01)
                TAMPhalanxWeapon.PlayFxWeaponPackSequence(self)
            end,

            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'Gatling_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end

                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TAMPhalanxWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            

            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gatling_Muzzle', self.unit.Army, Effects.WeaponSteam01)
                TAMPhalanxWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
		TMDGatlingCannon = Class(TAMPhalanxWeapon)
        
            {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                EffectUtils.CreateBoneEffects(self.unit, 'Gatling_Muzzle', self.unit.Army, Effects.WeaponSteam01)
                TAMPhalanxWeapon.PlayFxWeaponPackSequence(self)
            end,

            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'Gatling_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end

                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TAMPhalanxWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            

            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gatling_Muzzle', self.unit.Army, Effects.WeaponSteam01)
                TAMPhalanxWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },

    },

    OnCreate = function(self)
        TLandUnit.OnCreate(self)
        self:SetWeaponEnabledByLabel('GatlingCannon', true)
    end,
    
    OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
            self:SetWeaponEnabledByLabel('TMDGatlingCannon', true)
            self:SetWeaponEnabledByLabel('GatlingCannon', false)
            self:GetWeaponManipulatorByLabel('TMDGatlingCannon'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('GatlingCannon'):GetHeadingPitch() )
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
            self:SetWeaponEnabledByLabel('TMDGatlingCannon', false)
            self:SetWeaponEnabledByLabel('GatlingCannon', true)
            self:GetWeaponManipulatorByLabel('GatlingCannon'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('TMDGatlingCannon'):GetHeadingPitch() )
        end
    end,
}

TypeClass = SCSKTL0200
