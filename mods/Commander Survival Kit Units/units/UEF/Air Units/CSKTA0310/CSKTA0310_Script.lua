#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0304/UEA0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Strategic Bomber Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher
local TIFCruiseMissileUnpackingLauncher = import('/lua/terranweapons.lua').TIFCruiseMissileUnpackingLauncher

CSKTA0310 = Class(TAirUnit) {
    Weapons = {
        Turret01 = Class(TDFRiotWeapon) {},
		MissileRack01 = Class(TSAMLauncher) {},
		MissileWeapon = Class(TIFCruiseMissileUnpackingLauncher) 
        {
            FxMuzzleFlash = {'/effects/emitters/terran_mobile_missile_launch_01_emit.bp'},
        },
    },
	
	OnCreate = function(self)
        TAirUnit.OnCreate(self)
		self.Spinners = {
            Spinner1 = CreateRotator(self, 'Spinner01', 'y', nil, 0, 360, 360):SetTargetSpeed(0),
            Spinner2 = CreateRotator(self, 'Spinner02', 'y', nil, 0, 360, 360):SetTargetSpeed(0),
        }
		for k, v in self.Spinners do
            self.Trash:Add(v)
        end
    end,
	
	OnStartBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStartBeingBuilt(self,builder,layer)
		self.Spinners = {
            Spinner1 = CreateRotator(self, 'Spinner01', 'y', nil, 0, 360, 360):SetTargetSpeed(0),
            Spinner2 = CreateRotator(self, 'Spinner02', 'y', nil, 0, 360, 360):SetTargetSpeed(0),
        }
		for k, v in self.Spinners do
            self.Trash:Add(v)
        end

    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
		self.Spinners = {
            Spinner1 = CreateRotator(self, 'Spinner01', 'y', nil, 0, 360, 360):SetTargetSpeed(5000),
            Spinner2 = CreateRotator(self, 'Spinner02', 'y', nil, 0, 360, 360):SetTargetSpeed(-5000),
        }
		for k, v in self.Spinners do
            self.Trash:Add(v)
        end

    end,

	
}

TypeClass = CSKTA0310
