#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0304/UEA0304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Strategic Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TIFSmallYieldNuclearBombWeapon = import('/lua/terranweapons.lua').TIFSmallYieldNuclearBombWeapon
local TAirToAirLinkedRailgun = import('/lua/terranweapons.lua').TAirToAirLinkedRailgun

UEFSAS03 = Class(TAirUnit) {
    Weapons = {
        Bomb = Class(TIFSmallYieldNuclearBombWeapon) {
				IdleState = State(TIFSmallYieldNuclearBombWeapon.IdleState) {
                OnGotTarget = function(self)
				     TIFSmallYieldNuclearBombWeapon.IdleState.OnGotTarget(self)
                end,            
                OnFire = function(self)
					ChangeState(self, self.RackSalvoFiringState)
					
                end,
        },
		
		RackSalvoFireReadyState = State(TIFSmallYieldNuclearBombWeapon.RackSalvoFireReadyState) {
                OnFire = function(self)
                        TIFSmallYieldNuclearBombWeapon.RackSalvoFireReadyState.OnFire(self)
						self:ForkThread(self.CreateAirStrikeDecal)
                end,
            },  
		
		CreateAirStrikeDecal = function(self)
			local position = self.unit:GetPosition()
        local qx, qy, qz, qw = unpack(self.unit:GetOrientation())
        local a = math.atan2(2.0 * (qx * qz + qw * qy), qw * qw + qx * qx - qz * qz - qy * qy)
        local current_yaw = math.abs(a)
		if current_yaw <= 1.5 then 
			local x, z = position[1], position[3] + 26
			local newposition = {x, 0 , z}
			CreateDecal(newposition,  current_yaw, '/Mods/Commander Survival Kit/textures/airstrikedecal.dds', '', 'Albedo', 10, 55, 1000, 15, self.unit:GetArmy())
		else
			local x, z = position[1] + 26, position[3]
			local newposition = {x, 0 , z}
			CreateDecal(newposition,  current_yaw, '/Mods/Commander Survival Kit/textures/airstrikedecal.dds', '', 'Albedo', 10, 55, 1000, 15, self.unit:GetArmy())		
		end
        end,
			
		},
        LinkedRailGun1 = Class(TAirToAirLinkedRailgun) {},
        LinkedRailGun2 = Class(TAirToAirLinkedRailgun) {},
    },
	
	OnCreate = function(self)
        TAirUnit.OnCreate(self)
        self:RotateTowardsMid()
    end,
}

TypeClass = UEFSAS03
