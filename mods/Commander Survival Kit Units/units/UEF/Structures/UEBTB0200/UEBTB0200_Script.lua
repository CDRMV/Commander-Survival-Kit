#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2301/UEB2301_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local TDFLightningBeam = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').TDFLightningBeam
local cWeapons = import('/lua/cybranweapons.lua')
local CDFLaserHeavyWeapon = cWeapons.CDFLaserHeavyWeapon

UEBTB0200 = Class(TStructureUnit) {
    Weapons = {
        PhasonBeam = Class(TDFLightningBeam) {
		    OnWeaponFired = function(self)
                TDFLightningBeam.OnWeaponFired(self)
                local wep = self.unit:GetWeaponByLabel('StunWeapon')
                self.targetaquired = self:GetCurrentTargetPos()
                if self.targetaquired then
                    wep:SetTargetGround(self.targetaquired)
                    self.unit:SetWeaponEnabledByLabel('StunWeapon', true)
                    wep:SetTargetGround(self.targetaquired)
                    wep:OnFire()
                end
            end,
		}, 
		StunWeapon = Class(CDFLaserHeavyWeapon){
            OnWeaponFired = function(self)
                CDFLaserHeavyWeapon.OnWeaponFired(self)
                self:SetWeaponEnabled(false)
            end,
        },
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self.Effect1 = CreateAttachedEmitter(self,'Effect1',self:GetArmy(), '/effects/emitters/economy_electricity_01_emit.bp'):ScaleEmitter(2.0)
        self.Trash:Add(self.Effecct1)
    end,
}

TypeClass = UEBTB0200