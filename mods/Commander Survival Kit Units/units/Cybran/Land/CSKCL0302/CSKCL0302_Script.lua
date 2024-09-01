#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0202/URL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/defaultunits.lua').MobileUnit
local CWeapons = import('/lua/cybranweapons.lua')
local CDFLaserDisintegratorWeapon = CWeapons.CDFLaserDisintegratorWeapon02

CSKCL0302 = Class(CLandUnit) {

    Weapons = {
        Disintegrator = Class(CDFLaserDisintegratorWeapon) {
            OnCreate = function(self)
                CDFLaserDisintegratorWeapon.OnCreate(self)
                #Disable buff 
                self:DisableBuff('STUN')
            end,
        },
    },

    OnStopBeingBuilt = function(self,builder,layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
				self.Spinners = {
				Spinner1 = CreateRotator(self, 'Spinner1', 'x', nil, 0, 60, 360):SetTargetSpeed(0),
				Spinner2 = CreateRotator(self, 'Spinner2', 'x', nil, 0, 30, 360):SetTargetSpeed(0),
				}
				for k, v in self.Spinners do
					self.Trash:Add(v)
				end
    end,

	OnMotionHorzEventChange = function(self, new, old)
        CLandUnit.OnMotionHorzEventChange(self, new, old)
                if( old == 'Stopped' ) then
				self:ForkThread(function()
				while true do
				DamageArea(self, self:GetPosition(), 1, 15, 'Fire', false)
				WaitSeconds(1)
				end
				end)
				self.Spinners = {
				Spinner1 = CreateRotator(self, 'Spinner1', 'x', nil, 0, 60, 360):SetTargetSpeed(70),
				Spinner2 = CreateRotator(self, 'Spinner2', 'x', nil, 0, 30, 360):SetTargetSpeed(-70),
				}
				for k, v in self.Spinners do
					self.Trash:Add(v)
				end
                elseif( new == 'Stopped' ) then
				for k, v in self.Spinners do
					v:SetTargetSpeed(0)
				end
                end	
    end,
}

TypeClass = CSKCL0302