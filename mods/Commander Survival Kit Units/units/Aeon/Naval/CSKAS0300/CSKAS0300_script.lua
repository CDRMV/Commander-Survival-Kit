#****************************************************************************
#**
#**  File     :  /cdimage/units/UAS0201/UAS0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Destroyer Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local ASeaUnit = import('/lua/defaultunits.lua').SeaUnit
local AeonWeapons = import('/lua/aeonweapons.lua')
local ADFCannonOblivionWeapon = AeonWeapons.ADFCannonOblivionWeapon
local AAAZealotMissileWeapon = AeonWeapons.AAAZealotMissileWeapon
local ADFCannonQuantumWeapon = AeonWeapons.ADFCannonQuantumWeapon
local AANChronoTorpedoWeapon = AeonWeapons.AANChronoTorpedoWeapon
local AIFQuasarAntiTorpedoWeapon = AeonWeapons.AIFQuasarAntiTorpedoWeapon
local AAMWillOWisp = AeonWeapons.AAMWillOWisp


CSKAS0300 = Class(ASeaUnit) {
    BackWakeEffect = {},
    Weapons = {
	    SideTurret = Class(ADFCannonQuantumWeapon) {},
		FrontTurret = Class(ADFCannonOblivionWeapon) {},
		AntiAirMissiles0 = Class(AAAZealotMissileWeapon) {},
        AntiMissile = Class(AAMWillOWisp) {},
		Torpedo1 = Class(AANChronoTorpedoWeapon) {},
        Torpedo2 = Class(AANChronoTorpedoWeapon) {},
        AntiTorpedo = Class(AIFQuasarAntiTorpedoWeapon) {},
        AntiTorpedo2 = Class(AIFQuasarAntiTorpedoWeapon) {},
    },
}

TypeClass = CSKAS0300