#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0103/UEA0103_script.lua
#**  Author(s):  John Comes, David Tomandl, Gordon Duclos
#**
#**  Summary  :  Terran Carpet Bomber Unit Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
#
# Terran Bomber Script : UEA0103
#
local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TIFCarpetBombWeapon = import('/lua/terranweapons.lua').TIFCarpetBombWeapon


UEFSAS01 = Class(TAirUnit) {
	
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
#    DestructionPartsLowToss = {'P01', 'P02', 'P03', 'P04', 'P05', 'P06', },
#    DestructionTicks = 50,
    DamageEffectPullback = 0.5,

	
	OnCreate = function(self)
        TAirUnit.OnCreate(self)
        self:RotateTowardsMid()
    end,
}

TypeClass = UEFSAS01

