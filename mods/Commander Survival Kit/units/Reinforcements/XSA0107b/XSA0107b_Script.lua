#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0107/UAA0107_script.lua
#**  Author(s):  John Comes
#**
#**  Summary  :  Aeon T1 Transport Script
#**
#**  Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SAirUnit = import('/lua/defaultunits.lua').AirUnit

XSA0107b = Class(SAirUnit) {

    Weapons = {
    },

	OnStopBeingBuilt = function(self,builder,layer)
        SAirUnit.OnStopBeingBuilt(self,builder,layer)
		
		LOG('*ATTACHING UNITS TO TRANS!!')
        local position = self:GetPosition()
		self.Station08 = CreateUnitHPR('xsl0101', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo(0, self, 'Left_Attachpoint01')
		self.Station09 = CreateUnitHPR('xsl0101', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo(0, self, 'Left_Attachpoint02')
		self.Station10 = CreateUnitHPR('xsl0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo(0, self, 'Left_Attachpoint03')
		self.Station08 = CreateUnitHPR('xsl0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo(0, self, 'Left_Attachpoint04')
		self.Station09 = CreateUnitHPR('xsl0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo(0, self, 'Left_Attachpoint05')
		self.Station10 = CreateUnitHPR('xsl0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo(0, self, 'Left_Attachpoint06')
		self.Station09 = CreateUnitHPR('xsl0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo(0, self, 'Left_Attachpoint07')
		self.Station10 = CreateUnitHPR('xsl0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo(0, self, 'Left_Attachpoint08')
    end,

}

TypeClass = XSA0107b