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
        self:DisableUnitIntel('RadarStealth')
        self:DisableUnitIntel('Cloak')
		self.WeaponBuffHandle = self:ForkThread(self.WeaponBuffThread)
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

TypeClass = UEL0314