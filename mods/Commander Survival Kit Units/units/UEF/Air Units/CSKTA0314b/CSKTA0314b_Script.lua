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
local TIFSmallYieldNuclearBombWeapon = import('/lua/terranweapons.lua').TIFSmallYieldNuclearBombWeapon

CSKTA0314b = Class(TAirUnit) {
    Weapons = {
        Bomb = Class(TIFSmallYieldNuclearBombWeapon) {},
    },
	
	OnCreate = function(self)
        TAirUnit.OnCreate(self)
		self.Spinners = {
            Spinner1 = CreateRotator(self, 'L_Propeller01', 'y', nil, 0, 360, 360):SetTargetSpeed(0),
            Spinner2 = CreateRotator(self, 'L_Propeller02', 'y', nil, 0, 360, 360):SetTargetSpeed(0),
			Spinner3 = CreateRotator(self, 'R_Propeller01', 'y', nil, 0, 360, 360):SetTargetSpeed(0),
            Spinner4 = CreateRotator(self, 'R_Propeller02', 'y', nil, 0, 360, 360):SetTargetSpeed(0),
        }
		for k, v in self.Spinners do
            self.Trash:Add(v)
        end
    end,
	
	OnStartBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStartBeingBuilt(self,builder,layer)
		self.Spinners = {
            Spinner1 = CreateRotator(self, 'L_Propeller01', 'y', nil, 0, 360, 360):SetTargetSpeed(0),
            Spinner2 = CreateRotator(self, 'L_Propeller02', 'y', nil, 0, 360, 360):SetTargetSpeed(0),
			Spinner3 = CreateRotator(self, 'R_Propeller01', 'y', nil, 0, 360, 360):SetTargetSpeed(0),
            Spinner4 = CreateRotator(self, 'R_Propeller02', 'y', nil, 0, 360, 360):SetTargetSpeed(0),
        }
		for k, v in self.Spinners do
            self.Trash:Add(v)
        end

    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
		self.Spinners = {
            Spinner1 = CreateRotator(self, 'L_Propeller01', 'y', nil, 0, 360, 360):SetTargetSpeed(5000),
            Spinner2 = CreateRotator(self, 'L_Propeller02', 'y', nil, 0, 360, 360):SetTargetSpeed(5000),
			Spinner3 = CreateRotator(self, 'R_Propeller01', 'y', nil, 0, 360, 360):SetTargetSpeed(5000),
            Spinner4 = CreateRotator(self, 'R_Propeller02', 'y', nil, 0, 360, 360):SetTargetSpeed(5000),
        }
		for k, v in self.Spinners do
            self.Trash:Add(v)
        end

    end,


	
}

TypeClass = CSKTA0314b
