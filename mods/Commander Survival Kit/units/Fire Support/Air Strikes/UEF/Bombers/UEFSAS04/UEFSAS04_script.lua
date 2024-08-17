#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0204/UEA0204_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Torpedo Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TANTorpedoAngler = import('/lua/terranweapons.lua').TANTorpedoAngler


UEFSAS04 = Class(TAirUnit) {
    Weapons = {
        Torpedo = Class(TANTorpedoAngler) {
		
		            IdleState = State (TANTorpedoAngler.IdleState) {
                Main = function(self)
                    TANTorpedoAngler.IdleState.Main(self)
                end,
                
                OnGotTarget = function(self)
					self.unit:SetElevation(2)
                    TANTorpedoAngler.IdleState.OnGotTarget(self)
                end,
                OnWeaponFired = function(self)
                    self.unit:SetElevation(18)
                    TANTorpedoAngler.IdleState.OnFire(self)
                end,                
            },
		
		        OnGotTarget = function(self)
                    self.unit:SetElevation(2)
                    TANTorpedoAngler.OnGotTarget(self)
                end, 

				OnWeaponFired = function(self)
                    self.unit:SetElevation(18)
                    TANTorpedoAngler.IdleState.OnFire(self)
                end,  
		
        },
    },
	
	OnCreate = function(self)
        TAirUnit.OnCreate(self)
        self:RotateTowardsMid()
    end,
}

TypeClass = UEFSAS04