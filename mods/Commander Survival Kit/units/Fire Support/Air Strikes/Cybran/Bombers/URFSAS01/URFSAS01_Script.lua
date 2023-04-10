#****************************************************************************
#**
#**  File     :  /cdimage/units/URA0103/URA0103_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Cybran Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local CIFBombNeutronWeapon = import('/lua/cybranweapons.lua').CIFBombNeutronWeapon

URFSAS01 = Class(CAirUnit) {
    Weapons = {
        Bomb = Class(CIFBombNeutronWeapon) {
						IdleState = State(CIFBombNeutronWeapon.IdleState) {
		               OnGotTarget = function(self)
				     CIFBombNeutronWeapon.IdleState.OnGotTarget(self)
                end,            
                OnFire = function(self)
					ChangeState(self, self.RackSalvoFiringState)
					
                end,
        },
		
		RackSalvoFireReadyState = State(CIFBombNeutronWeapon.RackSalvoFireReadyState) {
                OnFire = function(self)
                        CIFBombNeutronWeapon.RackSalvoFireReadyState.OnFire(self)
						self:ForkThread(self.CreateAirStrikeDecal)
                end,
            },  
		
		CreateAirStrikeDecal = function(self)
			local position = self.unit:GetPosition()
        local qx, qy, qz, qw = unpack(self.unit:GetOrientation())
        local a = math.atan2(2.0 * (qx * qz + qw * qy), qw * qw + qx * qx - qz * qz - qy * qy)
        local current_yaw = math.abs(a)
		if current_yaw <= 1.5 then 
			local x, z = position[1], position[3] + 15
			local newposition = {x, 0 , z}
			CreateDecal(newposition,  current_yaw, '/Mods/Commander Survival Kit/textures/airstrikedecal.dds', '', 'Albedo', 9, 38, 1000, 15, self.unit:GetArmy())
		else
			local x, z = position[1] + 15, position[3]
			local newposition = {x, 0 , z}
			CreateDecal(newposition,  current_yaw, '/Mods/Commander Survival Kit/textures/airstrikedecal.dds', '', 'Albedo', 9, 38, 1000, 15, self.unit:GetArmy())		
		end
        end,
		
		},
        },
    ExhaustBones = {'Exhaust_L','Exhaust_R',},
    ContrailBones = {'Contrail_L','Contrail_R',},
	
	OnCreate = function(self)
        CAirUnit.OnCreate(self)
        self:RotateTowardsMid()
    end,
}

TypeClass = URFSAS01