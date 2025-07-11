#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0103/UAA0103_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').MobileUnit
local AIFBombGravitonWeapon = import('/lua/aeonweapons.lua').AIFBombGravitonWeapon
local ADFCannonQuantumWeapon = import('/lua/aeonweapons.lua').ADFCannonQuantumWeapon

CSKMDAA0306 = Class(AAirUnit) {
    Weapons = {
        Bomb = Class(AIFBombGravitonWeapon) {},
		FrontTurret = Class(ADFCannonQuantumWeapon) {},
    },
	
    OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
			self.OpenAnimManip = CreateAnimator(self)
			self.Trash:Add(self.OpenAnimManip)
			self.OpenAnimManip:PlayAnim('/Mods/Commander Survival Kit Units/units/Addon/Official/Mechdivers/Aeon/CSKMDAA0306/CSKMDAA0306_Fly.sca', true):SetRate(0.3)
    end,
}

TypeClass = CSKMDAA0306

