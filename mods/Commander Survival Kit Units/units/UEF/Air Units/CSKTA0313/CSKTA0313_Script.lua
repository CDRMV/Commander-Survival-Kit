#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0304/UEA0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Strategic Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon

CSKTA0313 = Class(TAirUnit) {
    Weapons = {
        Turret01 = Class(TDFRiotWeapon) {},
		Turret02 = Class(TDFGaussCannonWeapon) {}
    },
	
	OnCreate = function(self)
        TAirUnit.OnCreate(self)
		self.Spinners = {
            Spinner1 = CreateRotator(self, 'L_Propeller01', 'z', nil, 0, 360, 360):SetTargetSpeed(0),
            Spinner2 = CreateRotator(self, 'L_Propeller02', 'z', nil, 0, 360, 360):SetTargetSpeed(0),
			Spinner3 = CreateRotator(self, 'R_Propeller01', 'z', nil, 0, 360, 360):SetTargetSpeed(0),
            Spinner4 = CreateRotator(self, 'R_Propeller02', 'z', nil, 0, 360, 360):SetTargetSpeed(0),
        }
		for k, v in self.Spinners do
            self.Trash:Add(v)
        end
    end,
	
	OnStartBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStartBeingBuilt(self,builder,layer)
		self.Spinners = {
            Spinner1 = CreateRotator(self, 'L_Propeller01', 'z', nil, 0, 360, 360):SetTargetSpeed(0),
            Spinner2 = CreateRotator(self, 'L_Propeller02', 'z', nil, 0, 360, 360):SetTargetSpeed(0),
			Spinner3 = CreateRotator(self, 'R_Propeller01', 'z', nil, 0, 360, 360):SetTargetSpeed(0),
            Spinner4 = CreateRotator(self, 'R_Propeller02', 'z', nil, 0, 360, 360):SetTargetSpeed(0),
        }
		for k, v in self.Spinners do
            self.Trash:Add(v)
        end

    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
		self.Spinners = {
            Spinner1 = CreateRotator(self, 'L_Propeller01', 'z', nil, 0, 360, 360):SetTargetSpeed(5000),
            Spinner2 = CreateRotator(self, 'L_Propeller02', 'z', nil, 0, 360, 360):SetTargetSpeed(5000),
			Spinner3 = CreateRotator(self, 'R_Propeller01', 'z', nil, 0, 360, 360):SetTargetSpeed(5000),
            Spinner4 = CreateRotator(self, 'R_Propeller02', 'z', nil, 0, 360, 360):SetTargetSpeed(5000),
        }
		for k, v in self.Spinners do
            self.Trash:Add(v)
        end

    end,
	
    Patrol = function(self)
		local unitPos = self:GetPosition()
		local direction = Random(1,2)
		if direction == 1 then
		IssueClearCommands({self})
		IssueGuard({self}, {unitPos[1]+15, unitPos[2], unitPos[3]+5})
		LOG('*positive!')
		else
		IssueClearCommands({self})
		IssueGuard({self}, {unitPos[1]-15, unitPos[2], unitPos[3]-5})
		LOG('*negative!')
		end
	end,


	
}

TypeClass = CSKTA0313
