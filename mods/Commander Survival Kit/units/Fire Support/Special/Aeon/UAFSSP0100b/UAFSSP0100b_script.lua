#****************************************************************************
#**
#**  UEF Medium Artillery Strike
#**  Author(s):  CDRMV
#**
#**  Summary  :  A Dummy Unit which fires Artillery Strikes below it. 
#**				 It is Selectable and Untargetable by enemy Units.				
#**				 It attacks enemy Units automatically in Range and will be destroyed after 10 Seconds.
#**              
#**  Copyright © 2022 Fire Support Manager by CDRMV
#****************************************************************************

local StructureUnit = import('/lua/defaultunits.lua').StructureUnit
local AIUtils = import('/lua/ai/aiutilities.lua')
local Modpath = '/mods/Commander Survival Kit/effects/emitters/'
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local Buff = import('/lua/sim/Buff.lua')
local AIUtils = import('/lua/ai/aiutilities.lua')

UAFSSP0100b = Class(StructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
			self:ForkThread(function()
			self:HideBone('UEFSSP0100b', true)
			self:SetMaintenanceConsumptionActive()
			self:EnableUnitIntel('Cloak')
			self:EnableUnitIntel('CloakField')
		    self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), Modpath .. 'smoke_activate01_emit.bp'):ScaleEmitter(1.0)
            self.Trash:Add(self.Effect1)
			self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), Modpath .. 'regen_smoke_cloud_01_emit.bp'):ScaleEmitter(3.0)
            self.Trash:Add(self.Effect2)
			self.Effect3 = CreateAttachedEmitter(self,0,self:GetArmy(), Modpath .. 'regen_smoke_cloud_03_emit.bp'):ScaleEmitter(3.0)
            self.Trash:Add(self.Effect3)
			self.Effect4 = CreateAttachedEmitter(self,0,self:GetArmy(), Modpath .. 'regen_smoke_cloud_02_emit.bp'):ScaleEmitter(3.0)
            self.Trash:Add(self.Effect4)  
			local interval = 0
			 while (interval < 21) do
				LOG(interval)
					if interval < 20 then 
						self.RegenThreadHandle = self:ForkThread(self.RegenBuffThread)
						WaitSeconds(1)
						interval = interval + 1
					elseif interval == 20 then
						self:DisableUnitIntel('Cloak')
						self:DisableUnitIntel('CloakField')	
						self.Effect1:Destroy()
						self.Effect2:Destroy()
						self.Effect3:Destroy()
						self.Effect4:Destroy()
						self:Destroy()	
						break
					end
                end			
			end)
    end,
	
	RegenBuffThread = function(self)
        while not self:IsDead() do
            #Get friendly units in the area (including self)
            local units = AIUtils.GetOwnUnitsAroundPoint(
			
			self:GetAIBrain(), 
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			self:GetBlueprint().Intel.VisionRadius
			
			)
            local buff
            local type
			buff = 'NaniteRegen1'
			if not Buffs[buff] then
                local buff_bp = {
                    Name = buff,
                    DisplayName = buff,
                    BuffType = 'VETERANCYREGEN',
                    Stacks = 'REPLACE',
                    Duration = 1,
                    Affects = {
                        Regen = {
                            Add = 5,
                            Mult = 1,
                        },
                    },
                }
                BuffBlueprint(buff_bp)
            end
            for _,unit in units do
                Buff.ApplyBuff(unit, 'NaniteRegen1')
            end
            
            WaitSeconds(1)
        end
    end,

}

TypeClass = UAFSSP0100b