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

UEL0313 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
        },
		Rocket = Class(TDFGaussCannonWeapon) {
        },
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        TLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:DisableUnitIntel('RadarStealth')
        self:DisableUnitIntel('Cloak')
    end,
	
	OnScriptBitSet = function(self, bit)
        if bit == 8 then # cloak toggle
		    self:SetScriptBit('RULEUTC_CloakToggle', true)
		    --self:RemoveCommandCap('RULEUCC_Move')
			--self:RemoveCommandCap('RULEUCC_Patrol')
			--self:RemoveCommandCap('RULEUCC_Guard')
			--self:SetImmobile(true)
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
			self:EnableUnitIntel('ToggleBit3', 'CloakField')
            self:EnableUnitIntel('Cloak')
            self:EnableUnitIntel('RadarStealth')
            self:EnableUnitIntel('RadarStealthField')        
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 8 then # cloak toggle
		    self:SetScriptBit('RULEUTC_CloakToggle', false)
		    --self:AddCommandCap('RULEUCC_Move')
			--self:AddCommandCap('RULEUCC_Patrol')
			--self:AddCommandCap('RULEUCC_Guard')
		    --self:SetImmobile(false)
			self.Effect1:Destroy()
			self.Effect2:Destroy()
			self.Effect3:Destroy()
			self.Effect4:Destroy()
			self.Effect5:Destroy()
            self:DisableUnitIntel('Cloak')
			self:DisableUnitIntel('ToggleBit3', 'CloakField')
            self:DisableUnitIntel('RadarStealth')
            self:DisableUnitIntel('RadarStealthField')
        end
    end,
}

TypeClass = UEL0313