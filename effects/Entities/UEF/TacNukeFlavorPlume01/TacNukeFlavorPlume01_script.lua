#
# UEF Nuke Flavor Plume effect
#
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')

TacNukeFlavorPlume01 = Class(EmitterProjectile) {
    FxTrails = EffectTemplate.TNukeFlavorPlume01,
    FxTrailScale = 0.5,
    FxImpactUnit = {},
    FxImpactLand = {},
    FxImpactWater = {},
    FxImpactUnderWater = {},
    FxImpactNone = {},
}

TypeClass = TacNukeFlavorPlume01

