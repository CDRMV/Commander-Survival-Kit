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

UAFSSP0200b = Class(StructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
			self:ForkThread(function()
			self:HideBone('UEFSSP0100b', true)
			self:SetMaintenanceConsumptionActive()
			self:EnableUnitIntel('Cloak')
			self:EnableUnitIntel('CloakField')
		    self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), Modpath .. 'smoke_activate01_emit.bp'):ScaleEmitter(1.0)
            self.Trash:Add(self.Effect1)
			self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), '/effects/emitters/aeon_build_01_emit.bp'):ScaleEmitter(10.0):OffsetEmitter(0, 0.5, 0)
            self.Trash:Add(self.Effect2)
			self.Effect3 = CreateAttachedEmitter(self,0,self:GetArmy(), '/effects/emitters/aeon_being_built_ambient_01_emit.bp'):ScaleEmitter(10.0):OffsetEmitter(0, 0.5, 0)
            self.Trash:Add(self.Effect3)
			local interval = 0
			 while (interval < 21) do
				LOG(interval)
					if interval < 20 then 
						self.StunThreadHandle = self:ForkThread(self.StunThread)
						WaitSeconds(1)
						interval = interval + 1
					elseif interval == 20 then
						self:DisableUnitIntel('Cloak')
						self:DisableUnitIntel('CloakField')	
						self.Effect1:Destroy()
						self.Effect2:Destroy()
						self.Effect3:Destroy()
						self:Destroy()	
						break
					end
                end			
			end)
    end,
	
	StunThread = function(self)
        while not self:IsDead() do
            local units = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			self:GetBlueprint().Intel.VisionRadius,
			'Enemy'
			
			)
			
			local allyunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE, 
			self:GetPosition(), 
			self:GetBlueprint().Intel.VisionRadius,
			'Ally'
			
			)
            for _,allyunit in allyunits do
				allyunit:SetStunned(1)
            end
			
			for _,unit in units do
				unit:SetStunned(1)
            end
            
            WaitSeconds(1)
        end
    end,

}

TypeClass = UAFSSP0200b