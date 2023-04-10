#****************************************************************************
#**
#**  File     :  /cdimage/units/DEA0202/DEA0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Matt Vainio
#**
#**  Summary  :  UEF Supersonic Fighter Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TAirToAirLinkedRailgun = import('/lua/terranweapons.lua').TAirToAirLinkedRailgun
local TIFCarpetBombWeapon = import('/lua/terranweapons.lua').TIFCarpetBombWeapon

UEFSAS02 = Class(TAirUnit) {
    Weapons = {
        Bomb = Class(TIFCarpetBombWeapon) {
		IdleState = State(TIFCarpetBombWeapon.IdleState) {
                OnGotTarget = function(self)
				     TIFCarpetBombWeapon.IdleState.OnGotTarget(self)
                end,            
                OnFire = function(self)
					ChangeState(self, self.RackSalvoFiringState)
					
                end,
        },
		
		RackSalvoFireReadyState = State(TIFCarpetBombWeapon.RackSalvoFireReadyState) {
                OnFire = function(self)
                        TIFCarpetBombWeapon.RackSalvoFireReadyState.OnFire(self)
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
        TAirUnit.OnCreate(self)
        self:RotateTowardsMid()
    end,
    
}

TypeClass = UEFSAS02