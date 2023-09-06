#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0304/UEL0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Heavy Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local Modpath = '/mods/Commander Survival Kit Units/effects/emitters/'
local AIUtils = import('/lua/ai/aiutilities.lua')
CSKTL0313 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
        },
		Rocket = Class(TDFGaussCannonWeapon) {
        },
    },
	
	OnScriptBitSet = function(self, bit)
        if bit == 1 then 
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			local location = self:GetPosition()
			self:ForkThread(function()  
			WaitSeconds(1)	
			local SmokeUnit = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(3)	
			local SmokeUnit2 = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(3)	
			local SmokeUnit3 = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(20) -- Sets the Reloadtime of the Ability
			self:AddToggleCap('RULEUTC_WeaponToggle')		
			end)			
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 1 then 
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			local location = self:GetPosition()
			self:ForkThread(function()  
			WaitSeconds(1)	
			local SmokeUnit = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(3)	
			local SmokeUnit2 = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(3)	
			local SmokeUnit3 = CreateUnitHPR('UEFSSP01XX', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			WaitSeconds(20) -- Sets the Reloadtime of the Ability
			self:AddToggleCap('RULEUTC_WeaponToggle')		
			end)	
        end
    end,
}

TypeClass = CSKTL0313