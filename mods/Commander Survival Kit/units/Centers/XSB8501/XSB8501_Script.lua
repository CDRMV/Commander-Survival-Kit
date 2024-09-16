#****************************************************************************
#** 
#**  File     :  /cdimage/units/XSC1501/XSC1501_script.lua 
#** 
#** 
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit

XSB8501 = Class(StructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)

    end,

}


TypeClass = XSB8501

