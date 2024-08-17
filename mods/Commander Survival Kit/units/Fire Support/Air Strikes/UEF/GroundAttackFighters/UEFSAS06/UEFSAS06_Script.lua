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
local TIFCarpetBombWeapon = import('/lua/terranweapons.lua').TIFCarpetBombWeapon

UEFSAS06 = Class(TAirUnit) {
    Weapons = {
        Bomb = Class(TIFCarpetBombWeapon) {},
    },
    
    OnCreate = function(self)
        TAirUnit.OnCreate(self)
		self:RotateWings()
        self:RotateTowardsMid()
		self.Plane01 = import('/lua/sim/Entity.lua').Entity()
		BombMesh = '/mods/Commander Survival Kit/projectiles/TIFArmorPiercingBomb01/Deco_mesh',
        self.Plane01:AttachBoneTo( -1, self, 'Bomb' )
        self.Plane01:SetMesh(BombMesh)
        self.Plane01:SetDrawScale(0.118)
        self.Plane01:SetVizToAllies('Intel')
        self.Plane01:SetVizToNeutrals('Intel')
        self.Plane01:SetVizToEnemies('Intel')
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

TypeClass = UEFSAS06