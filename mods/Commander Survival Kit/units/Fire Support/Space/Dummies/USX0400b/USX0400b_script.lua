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

USX0400b = Class(StructureUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
			self:ForkThread(function()
			self:HideBone('UEFSSP0100b', true)
			local position = self:GetPosition()
			local number = 0
			while true do
			if number == 0 then
			DamageArea(self, position, 45, 1500, "Normal", true, true)
			WaitSeconds(0.1)
			DamageArea(self, position, 45, 1, 'Force', true, true)
			WaitSeconds(0.1)
			DamageArea(self, position, 45, 1, 'Force', true, true)
			self:Destroy()	
			end
			WaitSeconds(0.1)
			end
			end)	
    end,

}

TypeClass = USX0400b