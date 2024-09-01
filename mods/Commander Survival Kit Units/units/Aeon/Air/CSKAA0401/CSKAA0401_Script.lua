#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0304/UAA0304_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Strategic Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').AirUnit
local AIFQuanticArtillery = import('/lua/aeonweapons.lua').AIFQuanticArtillery
local AIFBombQuarkWeapon = import('/lua/aeonweapons.lua').AIFBombQuarkWeapon
local AAAZealotMissileWeapon = import('/lua/aeonweapons.lua').AAAZealotMissileWeapon

CSKAA0401 = Class(AAirUnit) {
	
    Weapons = {
        Bomb1 = Class(AIFBombQuarkWeapon) {},
		Bomb2 = Class(AIFBombQuarkWeapon) {},
		MainBomb = Class(AIFBombQuarkWeapon) {},
		AntiAirMissiles = Class(AAAZealotMissileWeapon) {},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
			self:HideBone('R_WingEffect', true)
			self:HideBone('L_WingEffect', true)
			self:ShowBone('Exhaust01', true)
			self:ShowBone('Exhaust02', true)
    end,
	
	
	OnCreate = function(self)
        AAirUnit.OnCreate(self)
		self:AddToggleCap('RULEUTC_ProductionToggle')
		self:SetWeaponEnabledByLabel('Bomb1', false)
		self:SetWeaponEnabledByLabel('Bomb2', false)			
    end,
	
	OnScriptBitSet = function(self, bit)
        AAirUnit.OnScriptBitSet(self, bit)
		if bit == 1 then 
		self:RemoveToggleCap('RULEUTC_ProductionToggle')
		self:SetWeaponEnabledByLabel('MainBomb', false)	
		self:SetWeaponEnabledByLabel('Bomb1', true)
		self:SetWeaponEnabledByLabel('Bomb2', true)
		end	
    end,
	
	OnScriptBitClear = function(self, bit)
        AAirUnit.OnScriptBitClear(self, bit)
		if bit == 1 then 	
		self:ForkThread(function()  
			WaitSeconds(10)	
			self:SetWeaponEnabledByLabel('Bomb1', false)
			self:SetWeaponEnabledByLabel('Bomb2', false)
			self:AddToggleCap('RULEUTC_ProductionToggle')
			self:SetWeaponEnabledByLabel('MainBomb', true)				
		end)
		end	
    end,
}

TypeClass = CSKAA0401