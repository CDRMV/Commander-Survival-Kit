#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0101/UEA0101_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  UEF Scout Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************


local TConstructionUnit = import('/lua/defaultunits.lua').ConstructionUnit
local TDFLightPlasmaCannonWeapon = import('/lua/terranweapons.lua').TDFLightPlasmaCannonWeapon

CSKSL0400HPD = Class(TConstructionUnit) {
    Weapons = {
        MainGun = Class(TDFLightPlasmaCannonWeapon) {}
    },

    Parent = nil,

    SetParent = function(self, parent, podName)
        self.Parent = parent
        self.Pod = podName
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self.Parent:NotifyOfPodDeath(self.Pod)
        self.Parent = nil
        TConstructionUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
	
	OnCreate = function(self)
        TConstructionUnit.OnCreate(self)
		self:SetWeaponEnabledByLabel('MainGun',false)
		self:HideBone(0, true)
		self:SetUnTargetable(true)
    end,
	
	CreateEnhancement = function(self, enh)
        TConstructionUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh == 'Teleporter' then
			self:ShowBone(0, true)
			self:AddCommandCap('RULEUCC_Attack')
			self:AddCommandCap('RULEUCC_RetaliateToggle')
			self:AddCommandCap('RULEUCC_Move')
			self:AddCommandCap('RULEUCC_Patrol')
			self:AddCommandCap('RULEUCC_Guard')
			self:AddCommandCap('RULEUCC_Stop')
            self:SetWeaponEnabledByLabel('MainGun',true)
        elseif enh == 'TeleporterRemove' then
			self:HideBone(0, true)
			self:RemoveCommandCap('RULEUCC_Attack')
			self:RemoveCommandCap('RULEUCC_RetaliateToggle')
			self:RemoveCommandCap('RULEUCC_Move')
			self:RemoveCommandCap('RULEUCC_Patrol')
			self:RemoveCommandCap('RULEUCC_Guard')
			self:RemoveCommandCap('RULEUCC_Stop')
            self:SetWeaponEnabledByLabel('MainGun',false)
        end
    end,
	


}
TypeClass = CSKSL0400HPD


