#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB5101/UAB5101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Wall Piece Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local ALaserFenceUnit = import('/lua/aeonunits.lua').ALaserFenceDummyUnit
UABAB0201a = Class(ALaserFenceUnit) {
    OnScriptBitSet = function(self, bit)
        ALaserFenceUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
			local pos = self:GetPosition()
			CreateUnitHPR('UABAB0201b',self:GetArmy(), pos[1], pos[2], pos[3], 0, 0, 0)
			self:Destroy()
        end
    end,

}

TypeClass = UABAB0201a