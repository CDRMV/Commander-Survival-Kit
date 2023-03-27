#
# UEF Nuke Flavor Plume effect
#
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile
local ModEffectTemplate = import('/mods/Commander Survival Kit/lua/FireSupportEffects.lua')

TacNukeFlavorPlume01 = Class(EmitterProjectile) {
    FxTrails = ModEffectTemplate.TCNukeFlavorPlume01,
    FxTrailScale = 0.5,
    FxImpactUnit = {},
    FxImpactLand = {},
    FxImpactWater = {},
    FxImpactUnderWater = {},
    FxImpactNone = {},
}

TypeClass = TacNukeFlavorPlume01

