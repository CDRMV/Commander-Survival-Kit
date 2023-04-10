#****************************************************************************
#**
#**  File     :  /units/XSA0304/XSA0304_script.lua
#**  Author(s):  Drew Staltman, Greg Kohne, Gordon Duclos
#**
#**  Summary  :  Seraphim Strategic Bomber Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local SIFBombZhanaseeWeapon = import('/lua/seraphimweapons.lua').SIFBombZhanaseeWeapon

XSFSAS03 = Class(SAirUnit) {
    Weapons = {
        Bomb = Class(SIFBombZhanaseeWeapon) {
						IdleState = State(SIFBombZhanaseeWeapon.IdleState) {
                OnGotTarget = function(self)
				     SIFBombZhanaseeWeapon.IdleState.OnGotTarget(self)
                end,            
                OnFire = function(self)
					ChangeState(self, self.RackSalvoFiringState)
					
                end,
        },
		
		RackSalvoFireReadyState = State(SIFBombZhanaseeWeapon.RackSalvoFireReadyState) {
                OnFire = function(self)
                        SIFBombZhanaseeWeapon.RackSalvoFireReadyState.OnFire(self)
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
        SAirUnit.OnCreate(self)
        self:RotateTowardsMid()
    end,
}
TypeClass = XSFSAS03