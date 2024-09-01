#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0101/UEA0101_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  UEF Scout Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit

CSKUJP0100 = Class(TAirUnit) {
    DestructionPartsLowToss = {'CSKUJP0100'},
    DestroySeconds = 7.5,
	
	
	OnTransportDetach = function(self, attachBone, unit)
		unit:SetScriptBit(2, false)
		self:Destroy()
    end,
	
    OnKilled = function(self)
		self.cargo = {}
        local cargo = self:GetCargo()
        for _, unit in cargo or {} do
			unit:Kill()
        end
    end,
	
}

TypeClass = CSKUJP0100