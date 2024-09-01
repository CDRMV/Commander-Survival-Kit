#****************************************************************************
#**
#**  File     :  /cdimage/units/DEA0202/DEA0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Matt Vainio
#**
#**  Summary  :  UEF Supersonic Fighter Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TAirToAirLinkedRailgun = import('/lua/terranweapons.lua').TAirToAirLinkedRailgun

UEFSAS05 = Class(TAirUnit) {
    Weapons = {
		RightBeam = Class(TAirToAirLinkedRailgun) {
				            IdleState = State (TAirToAirLinkedRailgun.IdleState) {
                Main = function(self)
                    TAirToAirLinkedRailgun.IdleState.Main(self)
                end,
                
                OnGotTarget = function(self)
					self.unit:SetElevation(2)
                    TAirToAirLinkedRailgun.IdleState.OnGotTarget(self)
                end,
                OnWeaponFired = function(self)
                    self.unit:SetElevation(18)
                    TAirToAirLinkedRailgun.IdleState.OnFire(self)
                end,                
            },
		
		        OnGotTarget = function(self)
                    self.unit:SetElevation(2)
                    TAirToAirLinkedRailgun.OnGotTarget(self)
                end, 

				OnWeaponFired = function(self)
                    self.unit:SetElevation(18)
                    TAirToAirLinkedRailgun.IdleState.OnFire(self)
                end,  
		},
        LeftBeam = Class(TAirToAirLinkedRailgun) {
				            IdleState = State (TAirToAirLinkedRailgun.IdleState) {
                Main = function(self)
                    TAirToAirLinkedRailgun.IdleState.Main(self)
                end,
                
                OnGotTarget = function(self)
					self.unit:SetElevation(2)
                    TAirToAirLinkedRailgun.IdleState.OnGotTarget(self)
                end,
                OnWeaponFired = function(self)
                    self.unit:SetElevation(18)
                    TAirToAirLinkedRailgun.IdleState.OnFire(self)
                end,                
            },
		
		        OnGotTarget = function(self)
                    self.unit:SetElevation(2)
                    TAirToAirLinkedRailgun.OnGotTarget(self)
                end, 

				OnWeaponFired = function(self)
                    self.unit:SetElevation(18)
                    TAirToAirLinkedRailgun.IdleState.OnFire(self)
                end, 
		},
    },
    
    OnCreate = function(self)
        TAirUnit.OnCreate(self)
		self:RotateWings()
        self:RotateTowardsMid()
    end,
	
	RotateWings = function(self)
        if not self.LWingRotator then
            self.LWingRotator = CreateRotator(self, 'Left_Wing', 'y')
            self.Trash:Add(self.LWingRotator)
        end
        if not self.RWingRotator then
            self.RWingRotator = CreateRotator(self, 'Right_Wing', 'y')
            self.Trash:Add(self.RWingRotator)
        end
        local fighterAngle = -105
        local bomberAngle = 0
        local wingSpeed = 45
		        self.LWingRotator:SetSpeed(wingSpeed)
                self.LWingRotator:SetGoal(-fighterAngle)
				self.RWingRotator:SetSpeed(wingSpeed)
                self.RWingRotator:SetGoal(fighterAngle)
    end,
    
}

TypeClass = UEFSAS05