#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0304/UAA0304_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Strategic Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local AIFBombQuarkWeapon = import('/lua/aeonweapons.lua').AIFBombQuarkWeapon


UAFSAS03 = Class(AAirUnit) {
    Weapons = {
        Bomb = Class(AIFBombQuarkWeapon) {
								IdleState = State(AIFBombQuarkWeapon.IdleState) {
                OnGotTarget = function(self)
				     AIFBombQuarkWeapon.IdleState.OnGotTarget(self)
                end,            
                OnFire = function(self)
					ChangeState(self, self.RackSalvoFiringState)
					
                end,
        },
		
		RackSalvoFireReadyState = State(AIFBombQuarkWeapon.RackSalvoFireReadyState) {
                OnFire = function(self)
                        AIFBombQuarkWeapon.RackSalvoFireReadyState.OnFire(self)
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
    },
	
	OnCreate = function(self)
        AAirUnit.OnCreate(self)
        self:RotateTowardsMid()
    end,
}

TypeClass = UAFSAS03