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
local ModEffectpath = '/mods/Commander Survival Kit Units/effects/emitters/'

UTX0402 = Class(StructureUnit) {

    OnCreate = function(self)
        StructureUnit.OnCreate(self)
			self:ForkThread(function()
				local interval = 0
                while (interval < 11) do
				LOG(interval)
					if interval < 10 then 
						DamageArea(self, self:GetPosition(), self:GetBlueprint().Intel.VisionRadius, 500, 'Fire', false, false)
						self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'smoke_cloud_01_emit.bp'):ScaleEmitter(1)
						self.Trash:Add(self.Effect1)
						WaitSeconds(1)
						interval = interval + 1
					elseif interval == 10 then
						self.Effect1:Destroy()
						self:Destroy()
						break
					end
                end		
			end)	
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
			self:ForkThread(function()
				local interval = 0
                while (interval < 11) do
				LOG(interval)
					if interval < 10 then 
						DamageArea(self, self:GetPosition(), self:GetBlueprint().Intel.VisionRadius, 500, 'Fire', false, false)
						self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'smoke_cloud_01_emit.bp'):ScaleEmitter(1)
						self.Trash:Add(self.Effect1)
						WaitSeconds(1)
						interval = interval + 1
					elseif interval == 10 then
						self.Effect1:Destroy()
						self:Destroy()
						break
					end
                end		
			end)	
    end,

}

TypeClass = UTX0402