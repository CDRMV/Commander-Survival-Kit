#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0202/URL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/defaultunits.lua').MobileUnit
local ModWeaponsFile = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua')
local CDFLaserIridiumWeapon = ModWeaponsFile.CDFLaserIridiumWeapon
local DummyTurretWeapon = import('/mods/Commander Survival Kit Units/lua/CSKUnitsWeapons.lua').DummyTurretWeapon

CSKCL0311 = Class(CLandUnit) {
    Weapons = {
      L_MainGun = Class(CDFLaserIridiumWeapon) {},
	  R_MainGun = Class(CDFLaserIridiumWeapon) {},
	  Dummy = Class(DummyTurretWeapon) {},
	},
	
	OnStopBeingBuilt = function(self,builder,layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
        #self:SetMaintenanceConsumptionActive()
        self:SetMaintenanceConsumptionInactive()
        self:SetScriptBit('RULEUTC_CloakToggle', true)
        self:RequestRefreshUI()
    end,
	
	OnIntelEnabled = function(self, intel)
        CLandUnit.OnIntelEnabled(self, intel)
		self:SetWeaponEnabledByLabel('R_MainGun', false)
		self:SetWeaponEnabledByLabel('L_MainGun', false)
    end,

    OnIntelDisabled = function(self, intel)
        CLandUnit.OnIntelDisabled(self, intel)
		self:SetWeaponEnabledByLabel('R_MainGun', true)
		self:SetWeaponEnabledByLabel('L_MainGun', true)
    end,
	
}

TypeClass = CSKCL0311