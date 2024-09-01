#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB5101/UAB5101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Wall Piece Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CElektroFenceUnit = import('/lua/defaultunits.lua').StructureUnit
URBCB0201b = Class(CElektroFenceUnit) {

	OnStopBeingBuilt = function(self, builder, layer)
        CElektroFenceUnit.OnStopBeingBuilt(self, builder, layer)
		
        self:HideBone( 0, true )
			
    end,

    OnScriptBitSet = function(self, bit)
        CElektroFenceUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
			local pos = self:GetPosition()
			CreateUnitHPR('URBCB0201a',self:GetArmy(), pos[1], pos[2], pos[3], 0, 0, 0)
			self:Destroy()
        end
    end,

}

TypeClass = URBCB0201b