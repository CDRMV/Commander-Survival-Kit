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

UEB9001 = Class(TCivilianStructureUnit) {
	
	OnStopBeingBuilt = function(self,builder,layer)
		TCivilianStructureUnit.OnStopBeingBuilt(self,builder,layer)
	        
    end,
}


TypeClass = UEB9001

