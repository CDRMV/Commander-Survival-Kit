#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0202/URL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/defaultunits.lua').MobileUnit
local ModWeaponsFile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua')
local CDFLaserIridiumWeapon = ModWeaponsFile.CDFLaserIridiumWeapon
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')

CSKCL0101 = Class(CLandUnit) {
    Weapons = {
      MainGun = Class(CDFLaserIridiumWeapon) {
	        PlayFxWeaponPackSequence = function(self)
                if self.SpinManip1 then
                    self.SpinManip1:SetTargetSpeed(0)
                end
				if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'L_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
				self.ExhaustEffects2 = EffectUtils.CreateBoneEffects( self.unit, 'R_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                CDFLaserIridiumWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip1 then 
                    self.SpinManip1 = CreateRotator(self.unit, 'L_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip1)
                end
				if not self.SpinManip2 then 
                    self.SpinManip2 = CreateRotator(self.unit, 'R_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip2)
                end
                
                if self.SpinManip1 then
                    self.SpinManip1:SetTargetSpeed(500)
                end
				if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(-500)
                end
                CDFLaserIridiumWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip1 then
                    self.SpinManip1:SetTargetSpeed(200)
                end
				if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(-200)
                end
                self.ExhaustEffects1 = EffectUtils.CreateBoneEffects( self.unit, 'L_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
				self.ExhaustEffects2 = EffectUtils.CreateBoneEffects( self.unit, 'R_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                CDFLaserIridiumWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
	  },
	},  
}

TypeClass = CSKCL0101