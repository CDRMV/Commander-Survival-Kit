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
local Buff = import('/lua/sim/Buff.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')

UEL0314 = Class(TLandUnit) {
	
	WeaponBuffThread = function(self)
        while not self:IsDead() do
            #Get friendly units in the area (including self)
            local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.LAND + categories.MOBILE,
			self:GetPosition(), 
			self:GetBlueprint().Intel.CloakFieldRadius
			
			)
            
            #Give them a 5 second regen buff
            for _,unit in units do
			    if not Buffs['WeaponBuff'] then
                BuffBlueprint {
                    Name = 'WeaponBuff',
                    DisplayName = 'WeaponBuff',
                    BuffType = 'AMMOWEAPONBUFF',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        Damage = {
                            Add =  200,
                            Mult = 1,
                        },
                        RateOfFire = {
                            Add = 0.4,
                            Mult = 1,
                        },
                    },
                }
				end
                Buff.ApplyBuff(unit, 'WeaponBuff')
            end
            
            #Wait 5 seconds
            WaitSeconds(5)
        end
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
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

TypeClass = UEL0314