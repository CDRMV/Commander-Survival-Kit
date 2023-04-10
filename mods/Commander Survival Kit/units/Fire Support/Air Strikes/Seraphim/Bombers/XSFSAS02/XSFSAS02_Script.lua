#****************************************************************************
#**
#**  File     :  /data/units/XSA0202/XSA0202_script.lua
#**  Author(s):  Jessica St. Croix, Gordon Duclos, Matt Vainio, Aaron Lundquist
#**
#**  Summary  :  Seraphim Fighter/Bomber Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SDFBombOtheWeapon = SeraphimWeapons.SDFBombOtheWeapon

XSFSAS02 = Class(SAirUnit) {
    Weapons = {
        Bomb = Class(SDFBombOtheWeapon) {
								IdleState = State(SDFBombOtheWeapon.IdleState) {
                OnGotTarget = function(self)
				     SDFBombOtheWeapon.IdleState.OnGotTarget(self)
                end,            
                OnFire = function(self)
					ChangeState(self, self.RackSalvoFiringState)
					
                end,
        },
		
		RackSalvoFireReadyState = State(SDFBombOtheWeapon.RackSalvoFireReadyState) {
                OnFire = function(self)
                        SDFBombOtheWeapon.RackSalvoFireReadyState.OnFire(self)
						self:ForkThread(self.CreateAirStrikeDecal)
                end,
            },  
		
		CreateAirStrikeDecal = function(self)
			local position = self.unit:GetPosition()
        local qx, qy, qz, qw = unpack(self.unit:GetOrientation())
        local a = math.atan2(2.0 * (qx * qz + qw * qy), qw * qw + qx * qx - qz * qz - qy * qy)
        local current_yaw = math.abs(a)
		if current_yaw <= 1.5 then 
			local x, z = position[1], position[3] + 45
			local newposition = {x, 0 , z}
			CreateDecal(newposition,  current_yaw, '/Mods/Commander Survival Kit/textures/airstrikedecal.dds', '', 'Albedo', 9, 95, 1000, 15, self.unit:GetArmy())
		else
			local x, z = position[1] + 45, position[3]
			local newposition = {x, 0 , z}
			CreateDecal(newposition,  current_yaw, '/Mods/Commander Survival Kit/textures/airstrikedecal.dds', '', 'Albedo', 9, 95, 1000, 15, self.unit:GetArmy())		
		end
        end,
		
		},
    },
	
	OnCreate = function(self)
        SAirUnit.OnCreate(self)
        self:RotateTowardsMid()
    end,
}
TypeClass = XSFSAS02