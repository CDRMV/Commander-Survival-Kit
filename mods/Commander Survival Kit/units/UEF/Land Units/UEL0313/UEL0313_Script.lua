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
UEL0313 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
        },
		Rocket = Class(TDFGaussCannonWeapon) {
        },
    },
	
	OnCreate = function(self)
		TLandUnit.OnCreate(self)
		   
    end,
	
	OnScriptBitSet = function(self, bit)
        if bit == 1 then 
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self:ForkThread(function()
			self.NoTeleDistance = 10	
			if self.NoTeleDistance == 10 then
			self:SetDoNotTarget(true)
			local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.LAND + categories.MOBILE,
			self:GetPosition(), 
			self.NoTeleDistance
			
			)
            
            #Give them a 5 second regen buff
            for _,unit in units do
				unit:SetDoNotTarget(true)
            end
			end
			LOG('NoTeleDistance: ', self.NoTeleDistance)
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

			self.NoTeleDistance = 0	
			if self.NoTeleDistance == 0 then
			self:SetDoNotTarget(false)
			local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.LAND + categories.MOBILE,
			self:GetPosition(), 
			20
			
			)
            
            #Give them a 5 second regen buff
            for _,unit in units do
				unit:SetDoNotTarget(false)
            end
			end
			LOG('NoTeleDistance: ', self.NoTeleDistance)
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
			self.NoTeleDistance = 10	
			if self.NoTeleDistance == 10 then
			self:SetDoNotTarget(true)
			local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.LAND + categories.MOBILE,
			self:GetPosition(), 
			self.NoTeleDistance
			
			)
            
            #Give them a 5 second regen buff
            for _,unit in units do
				unit:SetDoNotTarget(true)
            end
			end
			LOG('NoTeleDistance: ', self.NoTeleDistance)
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

			self.NoTeleDistance = 0	
			if self.NoTeleDistance == 0 then
			self:SetDoNotTarget(false)
			local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.LAND + categories.MOBILE,
			self:GetPosition(), 
			20
			
			)
            
            #Give them a 5 second regen buff
            for _,unit in units do
				unit:SetDoNotTarget(false)
            end
			end
			LOG('NoTeleDistance: ', self.NoTeleDistance)
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

TypeClass = UEL0313