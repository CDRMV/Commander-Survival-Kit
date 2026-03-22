local ASeaUnit = import('/lua/aeonunits.lua').ASeaUnit
local AeonWeapons = import('/lua/aeonweapons.lua')
local WeaponsFile = import('/lua/aeonweapons.lua')
local ADFCannonQuantumWeapon = AeonWeapons.ADFCannonQuantumWeapon
local ADFCannonOblivionWeapon = WeaponsFile.ADFCannonOblivionWeapon
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
        TopTurret = Class(ADFCannonQuantumWeapon) {},
        FrontTurret = Class(ADFCannonQuantumWeapon) {},
   BackTurret = Class(ADFCannonOblivionWeapon) {            FxMuzzleFlashScale = 0.8,},
        MissileRackFront = Class(AIFMissileTacticalSerpentine02Weapon) {},
        AntiAirMissiles = Class(AAAZealotMissileWeapon) {
	},
    },
    

}

TypeClass = AMAS302