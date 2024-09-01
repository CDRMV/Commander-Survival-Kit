#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB5101/UAB5101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Wall Piece Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TShieldFenceUnit = import('/lua/defaultunits.lua').StructureUnit
UEBTB0202b = Class(TShieldFenceUnit) {

	OnStopBeingBuilt = function(self, builder, layer)
        TShieldFenceUnit.OnStopBeingBuilt(self, builder, layer)
		self:ForkThread(function()
        self:HideBone( 0, true )
		end)
			
    end,

    OnScriptBitSet = function(self, bit)
        TShieldFenceUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
			local pos = self:GetPosition()
			CreateUnitHPR('UEBTB0202a',self:GetArmy(), pos[1], pos[2], pos[3], 0, 0, 0)
			self:Destroy()
        end
    end,

}

TypeClass = UEBTB0202b