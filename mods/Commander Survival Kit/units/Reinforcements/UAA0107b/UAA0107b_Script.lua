#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0107/UAA0107_script.lua
#**  Author(s):  John Comes
#**
#**  Summary  :  Aeon T1 Transport Script
#**
#**  Copyright � 2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').AirUnit

UAA0107 = Class(AAirUnit) {

    Weapons = {
    },
	OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
        LOG('*ATTACHING UNITS TO TRANS!!')
        local position = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Station08 = CreateUnitHPR('ual0106', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo('AttachPoint', self, 'Attachpoint_Small_01')
		self.Station09 = CreateUnitHPR('ual0106', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo('AttachPoint', self, 'Attachpoint_Small_02')
		self.Station10 = CreateUnitHPR('ual0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo('AttachPoint', self, 'Attachpoint_Small_03')
		self.Station11 = CreateUnitHPR('ual0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station11:AttachBoneTo('AttachPoint', self, 'Attachpoint_Small_04')
		self.Station10 = CreateUnitHPR('ual0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo('AttachPoint', self, 'Attachpoint_Small_05')
		self.Station11 = CreateUnitHPR('ual0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station11:AttachBoneTo('AttachPoint', self, 'Attachpoint_Small_06')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		AAirUnit.OnStopBeingBuilt(self,builder,layer)
    end,
}

TypeClass = UAA0107