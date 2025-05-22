#****************************************************************************
#**
#**  File     :  /cdimage/units/URB0102/URB0102_script.lua
#**  Author(s):  David Tomandl
#**
#**  Summary  :  Cybran Tier 1 Air Factory Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CCivilianStructureUnit = import('/lua/defaultunits.lua').StructureUnit


URB9000 = Class(CCivilianStructureUnit) {
	EffectBones01 = {
		'L_Funnel01', 'L_Funnel02', 'R_Funnel01', 'R_Funnel02',	'Funnel01', 'Funnel02',				
	},
	

	OnStopBeingBuilt = function(self,builder,layer)
		CCivilianStructureUnit.OnStopBeingBuilt(self,builder,layer)
		local army = self:GetArmy()
        for k, v in self.EffectBones01 do
            CreateAttachedEmitter(self,v,army,'/effects/emitters/uec1501_smoke_01_emit.bp')
        end		        
    end,
}

TypeClass = URB9000