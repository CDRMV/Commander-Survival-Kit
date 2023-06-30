#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0304/UEL0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Heavy Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local Modpath = '/mods/Commander Survival Kit/effects/emitters/'
local AIUtils = import('/lua/ai/aiutilities.lua')
CSKTL0313 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
        },
		Rocket = Class(TDFGaussCannonWeapon) {
        },
    },
	OnCreate = function(self)
		TLandUnit.OnCreate(self)
		self:DisableUnitIntel('Cloak')
		self:DisableUnitIntel('CloakField')
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
		TLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:DisableUnitIntel('Cloak')
		self:DisableUnitIntel('CloakField')
    end,
	
	OnScriptBitSet = function(self, bit)
        if bit == 1 then 
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self:ForkThread(function()
			self:SetMaintenanceConsumptionActive()
			self:EnableUnitIntel('Cloak')
			self:EnableUnitIntel('CloakField')
		    self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), Modpath .. 'smoke_activate01_emit.bp'):ScaleEmitter(1.0)
            self.Trash:Add(self.Effect1)
			self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), Modpath .. 'smoke_cloud_01_emit.bp'):ScaleEmitter(3.0)
            self.Trash:Add(self.Effect2)
			self.Effect3 = CreateAttachedEmitter(self,0,self:GetArmy(), Modpath .. 'smoke_cloud_01_emit.bp'):ScaleEmitter(3.0)
            self.Trash:Add(self.Effect3)
			self.Effect4 = CreateAttachedEmitter(self,0,self:GetArmy(), Modpath .. 'smoke_cloud_01_emit.bp'):ScaleEmitter(3.0)
            self.Trash:Add(self.Effect4)
			self.Effect5 = CreateAttachedEmitter(self,0,self:GetArmy(), Modpath .. 'smoke_cloud_01_emit.bp'):ScaleEmitter(3.0)
            self.Trash:Add(self.Effect5)   
			WaitSeconds(10)	
			self:DisableUnitIntel('Cloak')
			self:DisableUnitIntel('CloakField')
			self.Effect1:Destroy()
			self.Effect2:Destroy()
			self.Effect3:Destroy()
			self.Effect4:Destroy()
			self.Effect5:Destroy()

			WaitSeconds(10)	
			self:AddToggleCap('RULEUTC_WeaponToggle')			
			end)			
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 1 then 
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self:ForkThread(function()
			self:SetMaintenanceConsumptionActive()
			self:EnableUnitIntel('Cloak')
			self:EnableUnitIntel('CloakField')
		    self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), Modpath .. 'smoke_activate01_emit.bp'):ScaleEmitter(1.0)
            self.Trash:Add(self.Effect1)
			self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), Modpath .. 'smoke_cloud_01_emit.bp'):ScaleEmitter(3.0)
            self.Trash:Add(self.Effect2)
			self.Effect3 = CreateAttachedEmitter(self,0,self:GetArmy(), Modpath .. 'smoke_cloud_01_emit.bp'):ScaleEmitter(3.0)
            self.Trash:Add(self.Effect3)
			self.Effect4 = CreateAttachedEmitter(self,0,self:GetArmy(), Modpath .. 'smoke_cloud_01_emit.bp'):ScaleEmitter(3.0)
            self.Trash:Add(self.Effect4)
			self.Effect5 = CreateAttachedEmitter(self,0,self:GetArmy(), Modpath .. 'smoke_cloud_01_emit.bp'):ScaleEmitter(3.0)
            self.Trash:Add(self.Effect5)   
			WaitSeconds(10)	
			self:DisableUnitIntel('Cloak')
			self:DisableUnitIntel('CloakField')
			self.Effect1:Destroy()
			self.Effect2:Destroy()
			self.Effect3:Destroy()
			self.Effect4:Destroy()
			self.Effect5:Destroy()

			WaitSeconds(10)	
			self:AddToggleCap('RULEUTC_WeaponToggle')		
			end)	
        end
    end,
}

TypeClass = CSKTL0313