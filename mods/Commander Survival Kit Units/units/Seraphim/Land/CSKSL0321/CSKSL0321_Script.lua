#****************************************************************************
#**
#**  File     :  /units/XSL0202/XSL0202_script.lua
#**
#**  Summary  :  Seraphim Heavy Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local SLaanseMissileWeapon = import('/lua/seraphimweapons.lua').SLaanseMissileWeapon

CSKSL0321 = Class(SWalkingLandUnit) {
    Weapons = {
		MissileRack1 = Class(SLaanseMissileWeapon) {},
		MissileRack2 = Class(SLaanseMissileWeapon) {}
    },

	
	OnStopBeingBuilt = function(self,builder,layer)
        SWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		self:SetWeaponEnabledByLabel('MissileRack1', true)
		self:SetWeaponEnabledByLabel('MissileRack2', false)
		--[[
		if self:GetAIBrain().BrainType != 'Human' then
			LOG('AI: ADS activated') 
            self:SetScriptBit('RULEUTC_SpecialToggle', true)
		else
			LOG('Human Player: ADS deactivated') 
			self:SetScriptBit('RULEUTC_SpecialToggle', false)
        end
		]]--
        self:RequestRefreshUI()
    end,
	
	OnScriptBitSet = function(self, bit)
        SWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		
        end
		if bit == 7 then 
			self:AddCommandCap('RULEUCC_SiloBuildTactical')
			self:AddCommandCap('RULEUCC_Tactical')
		    self:SetWeaponEnabledByLabel('MissileRack1', false)
            self:SetWeaponEnabledByLabel('MissileRack2', true)
            self:GetWeaponManipulatorByLabel('MissileRack2'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('MissileRack1'):GetHeadingPitch() )
			self:RequestRefreshUI()
        end
    end,

    OnScriptBitClear = function(self, bit)
        SWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		
        end
		if bit == 7 then 
			self:RemoveCommandCap('RULEUCC_SiloBuildTactical')
			self:RemoveCommandCap('RULEUCC_Tactical')
		    self:SetWeaponEnabledByLabel('MissileRack1', true)
            self:SetWeaponEnabledByLabel('MissileRack2', false)
            self:GetWeaponManipulatorByLabel('MissileRack1'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('MissileRack2'):GetHeadingPitch() )
			self:RequestRefreshUI()
        end
    end,
}
TypeClass = CSKSL0321