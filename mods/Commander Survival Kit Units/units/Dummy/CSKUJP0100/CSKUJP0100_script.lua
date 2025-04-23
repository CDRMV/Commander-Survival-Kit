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
	
	OnCreate = function(self)
		TAirUnit.OnCreate(self)
		self:ForkThread(
        function()
		local number = 0
		while true do
		if number == 0 then
		local cargo = self:GetCargo()
		for _, unit in cargo or {} do
		local Health = unit:GetHealth()
		local MaxHealth = unit:GetMaxHealth()
		LOG(Health)
		LOG(MaxHealth)
		self:SetMaxHealth(Health)
		self:SetHealth(nil, Health)
        end
		number = number + 1
		break
		end
		WaitSeconds(0.1)
		end
		end
        )
	end, 
	
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