#****************************************************************************
#** 
#**  File     :  /cdimage/units/UAC1501/UAC1501_script.lua 
#**  Author(s):  John Comes, David Tomandl 
#** 
#**  Summary  :  Aeon Manufacturing Center, Ver1
#** 
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit

XSB8502 = Class(StructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
		
		Sync.HQComCenterDetected = true

    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
		Sync.HQComCenterDetected = false
		self:ForkThread(self.DeathThread, overkillRatio , instigator)
    end,

}


TypeClass = XSB8502

