#****************************************************************************
#**
#**  File     :  /cdimage/units/DRL0204/DRL0204_script.lua
#**  Author(s):  Dru Staltman, Eric Williamson
#**
#**  Summary  :  Cybran Rocket Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CWalkingLandUnit = import('/lua/defaultunits.lua').StructureUnit
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CDFRocketIridiumWeapon = CybranWeaponsFile.CDFRocketIridiumWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')


SRL0200Missile = Class(CWalkingLandUnit) {
        OnCreate = function(self)
		CWalkingLandUnit.OnCreate(self)
		if self and not self.Dead then
	self:HideBone(0,true)
		end
    end,
}

TypeClass = SRL0200Missile
