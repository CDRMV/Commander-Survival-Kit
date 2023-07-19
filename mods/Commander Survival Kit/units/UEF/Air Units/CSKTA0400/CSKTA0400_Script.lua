#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0304/UEA0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Strategic Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TIFSmallYieldNuclearBombWeapon = import('/lua/terranweapons.lua').TIFSmallYieldNuclearBombWeapon
local TAirToAirLinkedRailgun = import('/lua/terranweapons.lua').TAirToAirLinkedRailgun

CSKTA0400 = Class(TAirUnit) {
    Weapons = {
	    Bomb = Class(TIFSmallYieldNuclearBombWeapon) {},
        MissileWeapon = Class(TIFSmallYieldNuclearBombWeapon) {},
        AARailGun1 = Class(TAirToAirLinkedRailgun) {},
    },
	
	OnCreate = function(self)
        TAirUnit.OnCreate(self)
		self:AddToggleCap('RULEUTC_ProductionToggle')
		self:SetWeaponEnabledByLabel('Bomb', false)	
    end,
	
	OnScriptBitSet = function(self, bit)
        TAirUnit.OnScriptBitSet(self, bit)
		if bit == 1 then 
		self:RemoveToggleCap('RULEUTC_ProductionToggle')
		self:SetWeaponEnabledByLabel('MissileWeapon', false)	
		self:SetWeaponEnabledByLabel('Bomb', true)		
		end	
    end,
	
	OnScriptBitClear = function(self, bit)
        TAirUnit.OnScriptBitClear(self, bit)
		if bit == 1 then 	
		self:ForkThread(function()  
			WaitSeconds(10)	
			self:SetWeaponEnabledByLabel('Bomb', false)	
			self:AddToggleCap('RULEUTC_ProductionToggle')
			self:SetWeaponEnabledByLabel('MissileWeapon', true)				
		end)
		end	
    end,
}

TypeClass = CSKTA0400
