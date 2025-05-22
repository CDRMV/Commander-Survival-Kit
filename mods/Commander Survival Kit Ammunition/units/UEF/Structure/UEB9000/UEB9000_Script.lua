#****************************************************************************
#** 
#**  File     :  /cdimage/units/UEC1501/UEC1501_script.lua 
#**  Author(s):  John Comes, David Tomandl, Gordon Duclos
#** 
#**  Summary  :  Earth Manufacturing Center, Ver1
#** 
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TCivilianStructureUnit = import('/lua/defaultunits.lua').StructureUnit

UEB9000 = Class(TCivilianStructureUnit) {
	
	EffectBones01 = {
		'L_Funnel01', 'L_Funnel02', 'R_Funnel01', 'R_Funnel02',					
	},
	

	OnStopBeingBuilt = function(self,builder,layer)
		TCivilianStructureUnit.OnStopBeingBuilt(self,builder,layer)
		local army = self:GetArmy()
        for k, v in self.EffectBones01 do
            CreateAttachedEmitter(self,v,army,'/effects/emitters/uec1501_smoke_01_emit.bp')
        end		        
    end,
}


TypeClass = UEB9000

