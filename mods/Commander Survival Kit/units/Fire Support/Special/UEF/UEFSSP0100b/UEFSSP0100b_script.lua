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

UEFSSP01XX = Class(StructureUnit) {

    OnCreate = function(self)
        StructureUnit.OnCreate(self)
			self:ForkThread(function()
			self:HideBone('UEFSSP0100b', true)
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
			WaitSeconds(20)	
			self:DisableUnitIntel('Cloak')
			self:DisableUnitIntel('CloakField')
			self.Effect1:Destroy()
			self.Effect2:Destroy()
			self.Effect3:Destroy()
			self.Effect4:Destroy()
			self.Effect5:Destroy()	
			self:Destroy()			
			end)	
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
			self:ForkThread(function()
			self:HideBone('UEFSSP0100b', true)
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
			WaitSeconds(20)	
			self:DisableUnitIntel('Cloak')
			self:DisableUnitIntel('CloakField')
			self.Effect1:Destroy()
			self.Effect2:Destroy()
			self.Effect3:Destroy()
			self.Effect4:Destroy()
			self.Effect5:Destroy()	
			self:Destroy()	
			end)	
    end,

}

TypeClass = UEFSSP01XX