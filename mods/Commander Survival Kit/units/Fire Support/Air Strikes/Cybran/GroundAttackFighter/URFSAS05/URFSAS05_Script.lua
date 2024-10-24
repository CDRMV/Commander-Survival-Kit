#****************************************************************************
#**
#**  File     :  /cdimage/units/DRA0202/DRA0202_script.lua
#**  Author(s):  Dru Staltman, Eric Williamson
#**
#**  Summary  :  Cybran Bomber Fighter Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CAirUnit = import('/lua/defaultunits.lua').AirUnit
local CIFMissileCorsairWeapon = import('/lua/cybranweapons.lua').CIFMissileCorsairWeapon

URFSAS05 = Class(CAirUnit) {
    Weapons = {
        GroundMissile = Class(CIFMissileCorsairWeapon) {},
    },
    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionInactive()
        self:SetScriptBit('RULEUTC_StealthToggle', true)
        self:RequestRefreshUI()
    end,
	
	OnCreate = function(self)
        CAirUnit.OnCreate(self)
        self:RotateTowardsMid()
    end,
    
}

TypeClass = URFSAS05
