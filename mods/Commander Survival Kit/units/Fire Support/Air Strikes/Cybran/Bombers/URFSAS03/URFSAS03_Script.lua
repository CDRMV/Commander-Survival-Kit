#****************************************************************************
#**
#**  File     :  /cdimage/units/URA0304/URA0304_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Cybran Strategic Bomber Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CAirUnit = import('/lua/defaultunits.lua').AirUnit
local CIFBombNeutronWeapon = import('/lua/cybranweapons.lua').CIFBombNeutronWeapon
local CAAAutocannon = import('/lua/cybranweapons.lua').CAAAutocannon

URFSAS03 = Class(CAirUnit) {
    Weapons = {
        Bomb = Class(CIFBombNeutronWeapon) {},
        AAGun1 = Class(CAAAutocannon) {},
        AAGun2 = Class(CAAAutocannon) {},
    },
    ContrailBones = {'Left_Exhaust','Center_Exhaust','Right_Exhaust'},
    ExhaustBones = {'Left_Exhaust','Center_Exhaust','Right_Exhaust'},
    
    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetScriptBit('RULEUTC_StealthToggle', true)
    end,
	
	OnCreate = function(self)
        CAirUnit.OnCreate(self)
        self:RotateTowardsMid()
    end,
}
TypeClass = URFSAS03