local ASeaUnit = import('/lua/defaultunits.lua').MobileUnit
local AeonWeapons = import('/lua/aeonweapons.lua')
local WeaponsFile = import('/lua/aeonweapons.lua')
local ADFCannonQuantumWeapon = AeonWeapons.ADFCannonQuantumWeapon
local AAASonicPulseBatteryWeapon = WeaponsFile.AAASonicPulseBatteryWeapon
local ADFCannonOblivionWeapon = WeaponsFile.ADFCannonOblivionWeapon02

local AIFQuasarAntiTorpedoWeapon = AeonWeapons.AIFQuasarAntiTorpedoWeapon
local AANChronoTorpedoWeapon = AeonWeapons.AANChronoTorpedoWeapon
local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local fxutil = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local AAMWillOWisp = AeonWeapons.AAMWillOWisp
local AAASonicPulseBatteryWeapon = import('/lua/aeonweapons.lua').AAASonicPulseBatteryWeapon
local AIFMissileTacticalSerpentine02Weapon = import("/lua/aeonweapons.lua").AIFMissileTacticalSerpentine02Weapon
local AAAZealotMissileWeapon = AeonWeapons.AAAZealotMissileWeapon

AMAS302 = Class(ASeaUnit) {
    FxDamageScale = 2,

    Weapons = {
        MainGun = Class(ADFCannonOblivionWeapon) {FxMuzzleFlashScale = 1.8},
        TopTurret = Class(ADFCannonQuantumWeapon) {},
        MissileRackFront = Class(AIFMissileTacticalSerpentine02Weapon) {},
        AntiAirMissiles = Class(AAAZealotMissileWeapon) {
	},
    },
    

}

TypeClass = AMAS302